# docker-cam
Docker container for ipcam capturing of movement

[![Docker Pulls](https://img.shields.io/docker/pulls/trueosiris/cam.svg)](https://hub.docker.com/r/trueosiris/cam/) [![Docker Stars](https://img.shields.io/docker/stars/trueosiris/cam.svg)](https://hub.docker.com/r/trueosiris/cam/) [![Docker Automated buil](https://img.shields.io/docker/automated/trueosiris/cam.svg)](https://hub.docker.com/r/trueosiris/cam/) [![Docker Build Statu](https://img.shields.io/docker/build/trueosiris/cam.svg)](https://hub.docker.com/r/trueosiris/cam/) ![GitHub last commit](https://img.shields.io/github/last-commit/trueosiris/docker-cam.svg)

    docker create \
    -p 4567:80 \
    -v /some/host/folder/www:/www \
    -v /some/host/folder/config:/config \
    -e 'stream1':'rtsp://10.10.0.1/MainStream'
    trueosiris/cam
