#!/usr/bin/bash

SUPPORTED_VERSION=(latest oldstable testing unstable)
OLDPATH=`pwd`


# Update docker
for i in ${SUPPORTED_VERSION[@]}; do
    docker pull debian:$i
done

cd $OLDPATH/../../
ENV_PATH=`pwd`
cd $OLDPATH

for i in ${SUPPORTED_VERSION[@]}; do
    docker pull debian:$i
    docker run --rm -it --name env_debian_$i -v $ENV_PATH:/BUILD  \
    -i debian:$i sh -c "cd /BUILD/src/deb/ && bash deb_builder.sh -u -b "$i
done

