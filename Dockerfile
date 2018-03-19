FROM ubuntu:16.04
MAINTAINER "Tom Manville <tom@kasten.io>"

ENV DEBIAN_FRONTEND noninteractive

USER root

ADD . /kanister

RUN /kanister/install.sh && rm -rf /kanister && rm -rf /tmp && mkdir /tmp
