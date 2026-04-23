FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server \
    apache2 \
    sudo \
    cron \
    rsync \
    syslog-ng \
    quota \
    htop \
    curl \
    net-tools \
    iproute2 \
    tini \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# SSH config
RUN mkdir /var/run/sshd
RUN echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Copiar scripts de inicio y configuración
COPY entrypoint.sh /entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY scripts/ /opt/scripts/

RUN chmod +x /entrypoint.sh /opt/scripts/*.sh

EXPOSE 22 80

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/entrypoint.sh"]