FROM mongo:3.6
MAINTAINER "Tom Manville <tom@kasten.io>"

USER root

ADD . /kanister

COPY --from=google/cloud-sdk:206.0.0-slim /usr/lib/google-cloud-sdk /usr/lib/google-cloud-sdk

RUN /kanister/install.sh && rm -rf /kanister && rm -rf /tmp && mkdir /tmp

CMD ["tail", "-f", "/dev/null"]
