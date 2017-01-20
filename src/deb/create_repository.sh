#!/usr/bin/bash

USER=`whoami`
OLDPATH=`pwd`
PREFIX="repo"
ARCHS=(amd64 i386)
BUILD_PREFIX=`pwd`
NAME="firmadigitalcr"
VERSION="1.1"
GPGKEY="391090B9"


while getopts ":ud" optname
  do
    case "$optname" in
      "u")
        OS='ubuntu'
        SUPPORTED_VERSION=(precise trusty xenial yakkety)
        CODENAME=(precise trusty xenial yakkety)
        ;;
      "d")
        OS='debian'
        SUPPORTED_VERSION=(stable testing unstable)
        CODENAME=(jessie stretch sid)
        ;;

      *)
      # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
done

sudo chown -R $USER:$USER $BUILD_PREFIX/$OS/

CONF=$PREFIX/$OS/conf/
mkdir -p $CONF
OLDPATH=`pwd`

for ((i=0; i<${#SUPPORTED_VERSION[*]}; i++)); do
    version=${SUPPORTED_VERSION[i]}
    codename=${CODENAME[i]}
    VERSION2="$VERSION~$version"
    FILENAME=$NAME-$VERSION2.deb
     cat repoconf/distributions | sed -e "s/CODENAME/$codename/g" - | sed -e "s/VERSION/$version/g" - >> $CONF/distributions
    cp repoconf/options $CONF
    touch $CONF/override.$version

    for arch in ${ARCHS[@]}; do
        jaildir=$BUILD_PREFIX/$OS/$version/$arch
        # not needed reprepro do it.        
        #dpkg-sig --sign builder $jaildir/$FILENAME
        cd $PREFIX/$OS/
        echo "reprepro includedeb $codename $jaildir/$FILENAME"
        reprepro includedeb $codename $jaildir/$FILENAME
        cd $OLDPATH
    done
done

gpg --armor --output $PREFIX/firmadigitalcr.gpg.key --export $GPGKEY
