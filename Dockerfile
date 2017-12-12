# Dockerfile: rpi-radiko

FROM resin/rpi-raspbian:stretch
LABEL maintainer="mt08 <mt08xx@users.noreply.github.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget bsdmainutils openvpn less rtmpdump mplayer swftools libxml2-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD vgc play_nhk.sh play_radiko.sh /bin/

ENTRYPOINT [ "/bin/bash" ]
