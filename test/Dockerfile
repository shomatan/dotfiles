FROM centos:7

RUN set -xe \
    && yum update -y \
    && yum -y install epel-release \
    && yum -y install ansible git sudo which

# goss
RUN set -xe \
    && curl -fsSL https://goss.rocks/install | sh