FROM amd64/python:3.8-slim

EXPOSE 5000

RUN sed -i 's http://.*.debian.org/debian http://ftp.nz.debian.org/debian g' /etc/apt/sources.list


RUN apt-get update \ 
    && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

ARG APP_DIR=/usr/src/app/

RUN mkdir -p $APP_DIR

COPY *requirements.txt $APP_DIR
COPY app/* $APP_DIR
WORKDIR $APP_DIR

RUN pip install --upgrade pip \
    && pip install --upgrade setuptools \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -r fbprophet-requirements.txt

CMD ["python","app.py"]