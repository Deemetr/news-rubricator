FROM alpine:edge

ARG SPHINX_VERSION=2.2.11-release

RUN \
  apk add --update \
    tini \

  && addgroup -g 82 -S sphinx \
  && adduser -u 82 -S -D -h /var/cache/sphinx -s /sbin/nologin -G sphinx sphinx

RUN \
  apk add --virtual .sphinx-build-dependencies \
    curl \
    expat-dev \
    g++ \
    gcc \
    libre2-dev \
    make \
    mariadb-dev \
    postgresql-dev \
    snowball-dev \
  && apk add --virtual .sphinx-runtime-dependencies \
    expat \
    libpq \
    libstdc++ \

RUN mkdir -p /var/lib/sphinx \
	&& mkdir -p /var/lib/sphinx/data \
	&& mkdir -p /var/log/sphinx \
	&& mkdir -p /var/run/sphinx \

  # Save MySQL client library
  && mv /usr/lib/libmysqlclient* /usr/local/lib \

  # Sphinx
  && SPHINX_SOURCE="http://sphinxsearch.com/files/sphinx-${SPHINX_VERSION}.tar.gz" \
  && curl -fSL --connect-timeout 30 ${SPHINX_SOURCE} | tar xz -C /tmp \
  && cd /tmp/sphinx-${SPHINX_VERSION} \

  # Patches
  && PAGESIZE_PATCH="http://git.alpinelinux.org/cgit/aports/plain/community/sphinx/sphinx-pagesize.patch" \
  && curl -fSL --connect-timeout 30 ${PAGESIZE_PATCH} | patch -p1 -u \

  && ./configure \
    --prefix=/usr \
    --exec-prefix=/usr \
    --sysconfdir=/etc/sphinx \
    --localstatedir=/var/lib/sphinx \
    --enable-id64 \
    --with-iconv \
    --with-libexpat \
    --with-libstemmer \
    --with-mysql \
    --with-pgsql \
    --with-re2 \
  && make -j $(getconf _NPROCESSORS_ONLN) \
  && make install \

  # Removing build dependencies, clean temporary files
  && apk del .sphinx-build-dependencies \
  && rm -rf /var/cache/apk/* /var/tmp/* /tmp/*

COPY sphinx.conf /etc/sphinx/ 

ENTRYPOINT ["tini", "--"]
CMD ["searchd"]

COPY requirements.txt /src/requirements.txt
RUN pip3 install -r /src/requirements.txt
COPY app.py /src
COPY templates /src/templates
COPY static /src/static
CMD python3 /src/app.py
