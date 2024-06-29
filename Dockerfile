FROM ubuntu:latest

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

## preseed tzdata, update package index, upgrade packages and install needed software
RUN echo "tzdata tzdata/Areas select America" > /tmp/preseed.txt ; \
    echo "tzdata tzdata/Zones/America select Toronto" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt && \
    apt-get update && \
    apt-get install -y tzdata
    
RUN   apt-get update && \
  apt-get install -y swi-prolog

RUN   export PATH=/root/.local/bin:/usr/local/bin:/root/.local/bin:$PATH
COPY simple_server.pl ./
ENTRYPOINT swipl -g 'consult("simple_server.pl").'
