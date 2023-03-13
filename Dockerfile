FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl jq xsltproc dos2unix hashalot

COPY assets/ /opt/resource/