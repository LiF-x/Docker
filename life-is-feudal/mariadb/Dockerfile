FROM --platform=$BUILDPLATFORM debian:bookworm-slim

LABEL author="Christophe Roblin" maintainer="christophe@rampart.games"
LABEL org.opencontainers.image.source="https://github.com/lif-x/docker"
LABEL org.opencontainers.image.licenses=MIT

ARG DEBIAN_FRONTEND=noninteractive

# Remove custom sources to avoid conflicts
# COPY sources.list /etc/apt/sources.list

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        dirmngr \
        mariadb-server \
        netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*
RUN         useradd -m -d /home/container -s /bin/bash container

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY mariadb/entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
