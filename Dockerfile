FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \ 
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gpg \
        gpg-agent \
        wget

RUN echo "deb http://download.opensuse.org/repositories/home:/p4lang/xUbuntu_22.04/ /" | tee /etc/apt/sources.list.d/home:p4lang.list && \
    wget -qO - "http://download.opensuse.org/repositories/home:/p4lang/xUbuntu_22.04/Release.key" | apt-key add -
    
RUN apt-get update && \
    apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade && \
    apt-get install -y --no-install-recommends --fix-missing \
        ca-certificates \
        curl \
        git \
        iproute2 \
        net-tools \
        python3 \
        python3-pip \
        tcpdump \
        unzip \
        valgrind \
        wget \
        xcscope-el \
        p4lang-p4c \
        p4lang-bmv2 \
        p4lang-pi \
        # Other stuff
        mininet \
        make \
        sudo \
        iputils-ping \
        # Project Specific
        ffmpeg \
        vlc \
        tcpreplay

RUN pip3 install -U scapy ipaddr ptf psutil grpcio \
    # Project specific
    ffmpeg-python \
    python-vlc
