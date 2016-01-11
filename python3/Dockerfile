###########################################
# Dockerfile for basic Python 3 container
# Based on Debian
###########################################
FROM debian:jessie

MAINTAINER Austin Ouyang

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y vim
RUN apt-get install -y python3
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-pip

RUN pip3 install pdb ipython pylint hypothesis
