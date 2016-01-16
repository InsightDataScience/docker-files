############################################################
# Dockerfile to build Postgres client container image
# Based on Debian
############################################################
FROM debian:jessie

MAINTAINER Austin Ouyang

RUN apt-get update \
    && apt-get install -y wget

RUN touch /etc/apt/sources.list.d/pgdg.list \
    && echo deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main > /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt-get install -y postgresql-client-9.4 \
