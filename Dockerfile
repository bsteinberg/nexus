################################################################################
# Dockerfile to build dockerized Nexus server image
# 
# Based on: java:8u45
#
# Created On: June 1, 2015
# Author: Baruch Steinberg <baruch.steinberg@gmail.com>
#
# Description:
# ------------------------------------------------------------------------------
# Image include the following services/applications:
# - 
################################################################################

## Set the base image
FROM java:8u45

## File maintainer
MAINTAINER Baruch Steinberg

################################################################################
#
# INSTALLATION
#
################################################################################

ENV NEXUS_VERSION 2.11.3-01

## Download Nexus 
## -----------------------------------------------------------------------------
WORKDIR /tmp
RUN curl -sSLo /tmp/nexus-$NEXUS_VERSION-bundle.tar.gz    https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-$NEXUS_VERSION-bundle.tar.gz \
	&& tar xzf /tmp/nexus-$NEXUS_VERSION-bundle.tar.gz \
	&& rm -f /tmp/nexus-$NEXUS_VERSION-bundle.tar.gz \
	&& mv /tmp/nexus-$NEXUS_VERSION /usr/local/nexus-$NEXUS_VERSION
	
ENV NEXUS_HOME /usr/local/nexus
WORKDIR /usr/local
RUN ln -s nexus-$NEXUS_VERSION nexus
	

	
################################################################################
#
# CONFIGURATION
# 
################################################################################
ENV RUN_AS_USER root
ENV DATA_VOLUME /var/lib/nexus

ADD conf/nexus.properties ${NEXUS_HOME}/conf/nexus.properties

RUN mkdir ${DATA_VOLUME}

################################################################################
#
# RUN
# 
################################################################################

VOLUME ${DATA_VOLUME}

WORKDIR /usr/local/nexus

## Expose ports 
## -----------------------------------------------------------------------------
EXPOSE 8081/tcp

CMD  ./bin/nexus console


