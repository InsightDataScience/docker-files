###########################################
# Dockerfile for basic Python 3 container
# Based on Debian
###########################################
FROM debian:jessie

MAINTAINER Austin Ouyang

RUN apt-get update \
    && apt-get install -y git \
    && apt-get install -y vim \
    && apt-get install -y python3 \
    && apt-get install -y python3-dev \
    && apt-get install -y python3-pip

RUN pip3 install pdb ipython pylint hypothesis pytest
