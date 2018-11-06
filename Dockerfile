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
 
 # add apache2 deamon to runit
#RUN mkdir -p /etc/service/apache2  /var/log/apache2 ; sync 
#COPY apache2.sh /etc/service/apache2/run
#RUN chmod +x /etc/service/apache2/run \
#    && cp /var/log/cron/config /var/log/apache2/ \
#    && chown -R www-data /var/log/apache2
    
#COPY runonce.sh /sbin/runonce
#RUN chmod +x /sbin/runonce; sync \
#    && /bin/bash -c /sbin/runonce \
#    && rm /sbin/runonce

COPY clean_tempvid.sh /sbin/clean_tempvid.sh
RUN chmod +x /sbin/clean_tempvid.sh

COPY startup.sh /sbin/startup2
RUN chmod +x /sbin/startup2; sync \
    && /bin/bash -c /sbin/startup2 


VOLUME ["/config", "/www"]

EXPOSE 80

CMD ["/sbin/my_init"]
