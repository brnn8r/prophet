FROM python:3.8-slim

EXPOSE 5000

ARG APP_DIR=/usr/src/app

COPY requirements.txt $APP_DIR
COPY ./app $APP_DIR
WORKDIR $APP_DIR

RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

CMD ["python","app.py"]