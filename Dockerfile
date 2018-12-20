FROM trueosiris/webserver:latest
MAINTAINER tim@chaubet.be

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get dist-upgrade -y 
RUN apt-get install -y ffmpeg \
                       imagemagick \
                       bc \
                       htop \
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
COPY movevid.sh /sbin/movevid.sh
RUN chmod +x /sbin/movevid.sh
COPY blackwhite.sh /sbin/blackwhite.sh
RUN chmod +x /sbin/blackwhite.sh
COPY capturepics.sh /sbin/capturepics.sh
RUN chmod +x /sbin/capturepics.sh
COPY segments.sh /sbin/segments.sh
RUN chmod +x /sbin/segments.sh

RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh
RUN ln -s /etc/my_init.d/startup.sh /sbin/startup2

VOLUME ["/config", "/www"]

EXPOSE 80

CMD ["/sbin/my_init"]
