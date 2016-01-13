##########################################
# Dockerfile for basic Python 2 container
# Based on Debian
###########################################
FROM debian:jessie

MAINTAINER Austin Ouyang

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y vim
RUN apt-get install -y python
RUN apt-get install -y python-dev
RUN apt-get install -y python-pip

RUN pip install pdb ipython pylint hypothesis
