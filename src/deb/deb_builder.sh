#!/usr/bin/bash

DIR_PREFIX="debian"
CODEBASE=`lsb_release -cs`
ARCH=`uname -m`
NAME="firmadigitalcr"
VERSION="1.0"

while getopts ":n:ub:a:d:v:" optname
  do
    case "$optname" in
      "n")
        NAME=$OPTARG
        ;;
      "u")
        apt-get update
        ;;
      "d")
        DIR_PREFIX=$OPTARG
        ;;
      "b")
        CODEBASE=$OPTARG
        ;;
      "a")
        ARCH=$OPTARG
        ;;
      "v")
        VERSION=$OPTARG
        ;;
      *)
      # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
done




PREFIX="usr/"
CODE_PREFIX="../.."
WORKDIR=$DIR_PREFIX/$CODEBASE/$ARCH/$NAME-$VERSION
OLDPATH=`pwd`

if [ -d "$WORKDIR" ]; then
    rm -rf $WORKDIR
fi
mkdir -p $WORKDIR
mkdir -p $WORKDIR/$PREFIX/local/share/ca-certificates/Costa_Rica
mkdir -p $WORKDIR/$PREFIX/lib
mkdir -p $WORKDIR/$PREFIX/bin

if [ $ARCH == 'x86_64' -o  $ARCH == 'amd64' ]; then
    DARCH="amd64"
else
    DARCH="i386"
fi

echo "deb_builder building on $WORKDIR"
cp -a base/* $WORKDIR
sed -i "s/ARCH/$DARCH/g" $WORKDIR/DEBIAN/control

bash $OLDPATH/pkg_search.sh -i
DEPS=$(bash $OLDPATH/pkg_search.sh)
sed -i "s/DEPS/$DEPS/g" $WORKDIR/DEBIAN/control
sed -i "s/NAME/$NAME/g" $WORKDIR/DEBIAN/postinst

cp $CODE_PREFIX/certs/* $WORKDIR/$PREFIX/local/share/ca-certificates/Costa_Rica
cp $CODE_PREFIX/lib/$ARCH/* $WORKDIR/$PREFIX/lib/
#cp $CODE_PREFIX/bin/* $WORKDIR/$PREFIX/bin/

cd $WORKDIR
for u in usr/local/share/ca-certificates/Costa_Rica/*; do  md5sum "$u" >> DEBIAN/md5sums; done
for u in lib/systemd/system/*; do  md5sum "$u" >> DEBIAN/md5sums; done
#for u in usr/bin/*; do  md5sum "$u"; done

cd $OLDPATH

cd $WORKDIR/../
dpkg-deb -b $NAME-$VERSION
cd $OLDPATH
