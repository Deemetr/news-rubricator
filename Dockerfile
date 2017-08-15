FROM alpine:3.5
RUN apk add --update python3 py3-pip
RUN apk del python2 py2-pip
COPY requirements.txt /src/requirements.txt
RUN pip3 install -r /src/requirements.txt
COPY app.py /src
COPY buzz /src/buzz
COPY static /src/static
CMD python3 /src/app.py
