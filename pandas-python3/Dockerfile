########################################################
# Dockerfile for Pandas
# Based on Debian
########################################################
FROM debian:jessie

MAINTAINER Ronak Nathani

RUN apt-get update \
    && apt-get install -y python3 \
    && apt-get install -y python3-dev \
    && apt-get install -y python3-pip \
    && apt-get install -y python3-pandas

RUN pip3 install pdb ipython pylint pytest pytest-cov
