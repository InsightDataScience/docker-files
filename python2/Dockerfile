##########################################
# Dockerfile for basic Python 2 container
# Based on Debian
###########################################
FROM debian:jessie

MAINTAINER Austin Ouyang

RUN apt-get update \
    && apt-get install -y git \
    && apt-get install -y vim \
    && apt-get install -y python \
    && apt-get install -y python-dev \
    && apt-get install -y python-pip

RUN pip install pdb ipython pylint hypothesis pytest pytest-cov
