#!/usr/bin/bash

OLDPATH=`pwd`
PREFIX="jail"
ARCHS=(amd64 i386)
UPDATE='-u'
while getopts ":udn" optname
  do
    case "$optname" in
      "u")
        OS='ubuntu'
        SUPPORTED_VERSION=(precise trusty xenial yakkety)
        ;;
      "d")
        OS='debian'
        SUPPORTED_VERSION=(stable testing sid )
        ;;
      "n")
        UPDATE=''
        ;;

      *)
      # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
done

cd $OLDPATH/../../
ENV_PATH=`pwd`
cd $OLDPATH

function build_deb(){
    fworkdir=$1
    fOS=$2
    farch=$3
    fversion=$4

    if [ $OS == 'ubuntu' ]; then
        echo "deb http://espejos.ucr.ac.cr/ubuntu $fversion main universe" > $fworkdir/etc/apt/sources.list
       if [ -L  $fworkdir/usr/sbin/invoke-rc.d ]; then
            echo "Ok, not invoke services :)"
        else
            systemd-nspawn --directory=$fworkdir /bin/bash -c "dpkg-divert --rename --add /usr/sbin/invoke-rc.d && ln -s /bin/true /usr/sbin/invoke-rc.d"
        fi
    fi

    mkdir -p $fworkdir/mnt
    mount -o bind $ENV_PATH $fworkdir/mnt
    rm $fworkdir/etc/resolv.conf
    echo "nameserver 8.8.8.8" > $fworkdir/etc/resolv.conf
    systemd-nspawn --directory=$fworkdir /bin/bash -c "cd /mnt/src/deb/ && bash deb_builder.sh $UPDATE -a $farch -d $fOS -b $fversion"
    umount $fworkdir/mnt
};

for version in ${SUPPORTED_VERSION[@]}; do
    for arch in ${ARCHS[@]}; do
        workdir=$PREFIX/$OS/$version/$arch 
        build_deb $workdir $OS $arch $version 
    done
done
