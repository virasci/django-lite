FROM ubuntu:bionic
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install \
    python3 python3-dev python3-dev python3-pip python3-venv \
    mysql-client libsqlclient-dev libssl-dev default-libmysqlclient-dev \
    supervisor \
    netcat

ARG USER=root
USER $USER
RUN python3 -m venv venv
WORKDIR /app

COPY scripts scripts
COPY scripts/app.conf /etc/supervisor/conf.d/app.conf

COPY source/requirements.txt /app/source/requirements.txt
RUN ../venv/bin/pip install -r source/requirements.txt
COPY . .

EXPOSE 5000
RUN chmod +x scripts/startup.sh
RUN chmod +x /app/scripts/startapp.sh
ENTRYPOINT ["./scripts/startup.sh"]
