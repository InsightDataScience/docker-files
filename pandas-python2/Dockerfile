########################################################
# Dockerfile for Pandas - Python2
# Based on Debian
########################################################
FROM debian:jessie

MAINTAINER Ronak Nathani

RUN apt-get update \
    && apt-get install -y python \
    && apt-get install -y python-dev \
    && apt-get install -y python-pip

RUN pip install pandas