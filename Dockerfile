FROM debian:bullseye-slim
MAINTAINER Wolfram Schneider <wosch@FreeBSD.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q && \
  apt-get upgrade -y && \
  env RUN_MANDB=no apt-get install -y git make sudo gnupg vim screen gcc perl && \
  apt-get clean

RUN cpan Test::More
