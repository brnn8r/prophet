FROM continuumio/miniconda:4.7.12

EXPOSE 5000

RUN sed -i 's http://.*.debian.org/debian http://ftp.nz.debian.org/debian g' /etc/apt/sources.list


RUN apt-get update \ 
    && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

ARG APP_DIR=/usr/src/app/

RUN mkdir -p $APP_DIR

COPY environment.yml $APP_DIR

WORKDIR $APP_DIR

RUN conda env create -f environment.yml 

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "prophet", "/bin/bash", "-c"]

COPY app/* $APP_DIR

# Make sure the environment is activated:
RUN echo "Make sure fbprophet is installed:"
RUN python -c "import fbprophet; import flask"

CMD ["conda", "run", "-n", "prophet", "uwsgi", "prophet-uwsgi.ini"]