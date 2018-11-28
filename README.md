# docker-cam
Docker container for ipcam capturing of movement. 
This is a spycam, based on rtsp stream(s).

It will take smaller thumbnails every second and compare them.
If there is a decent change detected, the actual pictures will be moved to a permanent folder.
These pictures will be made into a daily timelapse video.
A 15 second movie will also be moved to a permanent location.


[![Docker Pulls](https://img.shields.io/docker/pulls/trueosiris/cam.svg)](https://hub.docker.com/r/trueosiris/cam/) [![Docker Stars](https://img.shields.io/docker/stars/trueosiris/cam.svg)](https://hub.docker.com/r/trueosiris/cam/) [![Docker Automated buil](https://img.shields.io/docker/automated/trueosiris/cam.svg)](https://hub.docker.com/r/trueosiris/cam/) [![Docker Build Statu](https://img.shields.io/docker/build/trueosiris/cam.svg)](https://hub.docker.com/r/trueosiris/cam/) ![GitHub last commit](https://img.shields.io/github/last-commit/trueosiris/docker-cam.svg)

    docker create \
    -p 4567:80 \
    -v /some/host/folder/www:/www \
    -v /some/host/folder/config:/config \
    -e 'stream1':'rtsp://10.10.0.1/MainStream'
    trueosiris/cam

You can restart the functionality of the container from within:

    docker exec -it cam /bin/bash
    /sbin/startup2

# extra environment variables

- default global fuzziness factor for all streams for imagemagick compare command = 15

      -e FUZZ_GLOBAL:15

- individual fuzziness factor for a stream

      -e stream1_FUZZ:10
