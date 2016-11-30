#!/usr/bin/bash

PREFIX="jail_bk"
ARCHS=(amd64 i386)
while getopts ":ud" optname
  do
    case "$optname" in
      "u")
        OS='ubuntu'
        REPO="http://espejos.ucr.ac.cr/ubuntu/"
        SUPPORTED_VERSION=(precise trusty xenial yakkety)
        ;;
      "d")
        OS='debian'
        REPO="http://espejos.ucr.ac.cr/debian/"
        SUPPORTED_VERSION=(stable testing unstable)
        ;;
      *)
      # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
done

for version in ${SUPPORTED_VERSION[@]}; do
    for arch in ${ARCHS[@]}; do
        workdir=$PREFIX/$OS/$version/$arch 
        mkdir -p $workdir
        echo "Running debootstrap --arch $arch $version $workdir $REPO"
        sudo debootstrap --arch $arch $version $workdir $REPO &
    done
done
