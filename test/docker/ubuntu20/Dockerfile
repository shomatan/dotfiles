FROM ubuntu:20.04

RUN set -xe \
    && apt update -y \
    && apt upgrade -y

RUN set -xe \
    && apt install -y software-properties-common

RUN set -xe \
    && apt -y install ansible git sudo

# goss
RUN set -xe \
    && curl -fsSL https://goss.rocks/install | sh
