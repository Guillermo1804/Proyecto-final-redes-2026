FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-client \
    iputils-ping \
    net-tools \
    curl \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["bash"]