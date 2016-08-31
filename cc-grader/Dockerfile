##########################################
# Dockerfile for cc-grader
# Based on insightdatascience/pandas-python2
###########################################
FROM insightdatascience/pandas-python2

MAINTAINER Austin Ouyang

ENV REVISION_DATE="Tuesday July 12th, 2016" MAVEN_VERSION=3.3.9

RUN echo "deb http://ftp.de.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y git \
    && apt-get install -y wget \
    && apt-get install -y openjdk-8-jdk \
    && apt-get install -y scala \
    && apt-get install -y build-essential

RUN wget https://dl.bintray.com/sbt/debian/sbt-0.13.7.deb -P ~/ \
    && dpkg -i ~/sbt-* \
    && wget -q -O "maven-${MAVEN_VERSION}-bin.tar.gz" "http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
    && tar -xvzf "maven-${MAVEN_VERSION}-bin.tar.gz" \
    && mv "apache-maven-${MAVEN_VERSION}" /usr/share/maven \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN pip install networkx
