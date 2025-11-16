# Life is Feudal: Your Own - Wine Game Server Container
# Based on Wine for Pterodactyl

FROM debian:bullseye-slim

LABEL maintainer="LiF-x"
LABEL description="Wine container optimized for Life is Feudal: Your Own game server"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Enable 32-bit architecture and update package lists
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        gnupg2 \
        wget \
        ca-certificates \
        curl \
        git \
        unzip \
        tar \
        iproute2 \
        tzdata \
        locales

# Generate UTF-8 locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install Wine from Debian repositories
RUN apt-get update && \
    apt-get install -y --install-recommends wine wine64 wine32 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install additional dependencies for Life is Feudal
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        lib32gcc-s1 \
        lib32stdc++6 \
        libxml2:i386 \
        libfreetype6:i386 \
        libncurses5:i386 \
        libldap-2.4-2:i386 \
        xvfb \
        cabextract && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Note: winetricks can be installed manually if needed
# It's not in Debian's main repositories

# Create user for running the game server
RUN useradd -m -d /home/container -s /bin/bash container

# Set working directory
WORKDIR /home/container

# Set Wine prefix
ENV WINEPREFIX=/home/container/.wine
ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV DISPLAY=:99

# Create entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to container user
USER container

# Initialize Wine prefix
RUN wine wineboot --init && \
    wineserver -w

# Expose default Life is Feudal ports
# Game server port
EXPOSE 28000/udp
# Query port
EXPOSE 28100/tcp

USER container

ENTRYPOINT ["/entrypoint.sh"]
