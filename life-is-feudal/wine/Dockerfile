FROM            ghcr.io/parkervcp/yolks:wine_latest

LABEL           author="Christophe Roblin" maintainer="christophe@rampart.games"
LABEL           org.opencontainers.image.licenses=MIT

# Install required packages
RUN             dpkg --add-architecture i386 \
                && apt update -y \
                && apt install -y --no-install-recommends \
                    telnet \
                    expect
                    
ENV         LANG en_US.UTF-8  
ENV         LANGUAGE en_US:en  
ENV         LC_ALL en_US.UTF-8

## Setup user and working directory
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

ENV             WINEPREFIX=/home/container/.wines
ENV             WINEDLLOVERRIDES="mscoree,mshtml="
ENV             DISPLAY=:0
ENV             DISPLAY_WIDTH=1024
ENV             DISPLAY_HEIGHT=768
ENV             DISPLAY_DEPTH=24
ENV             AUTO_UPDATE=1
ENV             XVFB=0

# Sets the default stop signal as wings can (currently) only send a kill or generic stop
STOPSIGNAL SIGINT

COPY            wine/entrypoint.sh /entrypoint.sh
CMD             [ "/bin/bash", "/entrypoint.sh" ]
