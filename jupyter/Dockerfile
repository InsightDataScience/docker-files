###########################################
# Dockerfile for basic Python 3 Jupyter container
# Based on python3 alpine
###########################################
FROM python:3-alpine

MAINTAINER Austin Ouyang

RUN apk update && \
    apk add gcc

RUN pip3 install ipython["notebook"]
