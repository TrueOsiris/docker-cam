FROM trueosiris/webserver:latest
MAINTAINER tim@chaubet.be

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get dist-upgrade -y 
RUN apt-get install -y ffmpeg \
                       imagemagick \
                       bc \
 && apt-get autoremove -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* 

COPY clean_tempvid.sh /sbin/clean_tempvid.sh
RUN chmod +x /sbin/clean_tempvid.sh
COPY compare.sh /sbin/compare.sh
RUN chmod +x /sbin/compare.sh
COPY timelapse.sh /sbin/timelapse.sh
RUN chmod +x /sbin/timelapse.sh

COPY startup.sh /sbin/startup2
RUN chmod +x /sbin/startup2; sync \
    && /bin/bash -c /sbin/startup2 

VOLUME ["/config", "/www"]

EXPOSE 80

CMD ["/sbin/my_init"]
