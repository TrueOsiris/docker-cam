FROM trueosiris/webserver
MAINTAINER tim@chaubet.be

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get dist-upgrade -y 
RUN apt-get install -y ffmpeg \
 && apt-get autoremove -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* 

VOLUME ["/config", "/www"]

EXPOSE 80

CMD ["/sbin/my_init"]
