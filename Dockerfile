FROM alpine:3.3
RUN apk add --update python3 py3-pip
RUN apk del python2 py2-pip

# add work script
ADD start.sh /
ADD searchd.sh /

# install sphinxsearch   
RUN echo "http://dl-5.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
	&& apk --update --no-cache add sphinx \
	&& mkdir -p /var/lib/sphinx \
	&& mkdir -p /var/lib/sphinx/data \
	&& mkdir -p /var/log/sphinx \
	&& mkdir -p /var/run/sphinx \
	&& chmod a+x searchd.sh \
	&& chmod a+x start.sh  

# run cron and seachd
CMD ["./start.sh"]

COPY requirements.txt /src/requirements.txt
RUN pip3 install -r /src/requirements.txt
COPY app.py /src
COPY templates /src/templates
COPY static /src/static
CMD python3 /src/app.py
