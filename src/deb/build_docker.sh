#!/usr/bin/bash
OS="debian"
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
    if [ -z `docker ps -qaf name=env_$OS_$i` ] ; then 
        docker pull $OS:$i
        docker create -it --name env_$OS_$i -v $ENV_PATH:/BUILD $OS:$i
    fi

    docker start env_$OS_$i
    docker exec -it env_$OS_$i sh -c "cd /BUILD/src/deb/ && bash deb_builder.sh -u -d $OS -b $i"
    docker stop env_$OS_$i
       
done

