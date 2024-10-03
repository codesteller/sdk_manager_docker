#!/bin/sh

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

mkdir -p nvdrive_home/nvidia
mkdir -p nvdrive_home/Downloads
nvdrive_HOME=$(realpath ./nvdrive_home)

docker run --privileged --rm -it \
           --volume=$XSOCK:$XSOCK:rw \
           --volume=$XAUTH:$XAUTH:rw \
           --volume=/dev:/dev:rw \
           --volume="$nvdrive_HOME/nvidia":/home/nvdrive/nvidia:rw \
           --volume="$nvdrive_HOME/Downloads":/home/nvdrive/Downloads:rw \
           --shm-size=1gb \
           --env="XAUTHORITY=${XAUTH}" \
           --env="DISPLAY=${DISPLAY}" \
           --env=TERM=xterm-256color \
           --env=QT_X11_NO_MITSHM=1 \
           --net=host \
           -u "nvdrive"  \
           nvdriveos_20.04:latest
