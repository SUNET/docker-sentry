FROM ubuntu:14.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ENV DEBIAN_FRONTEND noninteractive

RUN /bin/echo -e "deb http://se.archive.ubuntu.com/ubuntu trusty main restricted universe\ndeb http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe\ndeb http://security.ubuntu.com/ubuntu trusty-security main restricted universe" > /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y \
      sed \
      git \
      build-essential \
      libpython-dev \
      python-pip \
      python-virtualenv \
      libpq-dev \
      libxml2-dev \
      libxslt1-dev \
      libffi-dev && \
    apt-get clean

VOLUME ["/opt/sentry/conf", "/var/log/sentry"]

ADD setup.sh /opt/sentry/setup.sh
ADD supervisor.conf /etc/supervisor.conf
ADD uwsgi.ini /etc/uwsgi.ini

RUN /opt/sentry/setup.sh

ADD start.sh /start.sh

WORKDIR /

EXPOSE 9000

CMD ["bash", "/start.sh"]
