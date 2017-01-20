#!/usr/bin/bash

DIR_PREFIX="debian"
CODEBASE=`lsb_release -cs`
ARCH=`uname -m`
NAME="firmadigitalcr"
VERSION="1.1"


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



VERSION="$VERSION~$CODEBASE"
PREFIX="usr"
CODE_PREFIX="../.."
WORKDIR=$DIR_PREFIX/$CODEBASE/$ARCH/$NAME-$VERSION
OLDPATH=`pwd`

FILE_PATHS=($PREFIX/share/$NAME/ca-certificates/Costa_Rica/ $PREFIX/share/doc/$NAME/ lib/systemd/system/ etc/Athena/ usr/share/firmadigitalcr/bin/ etc/pkcs11/modules/ usr/lib/)

if [ -d "$WORKDIR" ]; then
    rm -rf $WORKDIR
fi
mkdir -p $WORKDIR
mkdir -p $WORKDIR/$PREFIX/share/$NAME/ca-certificates/Costa_Rica
mkdir -p $WORKDIR/$PREFIX/lib
mkdir -p $WORKDIR/$PREFIX/share/doc/$NAME

if [ $ARCH == 'x86_64' -o  $ARCH == 'amd64' ]; then
    DARCH="amd64"
else
    DARCH="i386"
fi

echo "deb_builder building on $WORKDIR"
mkdir -p $WORKDIR/lib/
cp -a base/* $WORKDIR
cp -a $CODE_PREFIX/etc  $WORKDIR
cp -a $CODE_PREFIX/lib/systemd $WORKDIR/lib/
cp -a $CODE_PREFIX/usr/ $WORKDIR


sed -i "s/ARCH/$DARCH/g" $WORKDIR/DEBIAN/control
sed -i "s/VERSION/$VERSION/g" $WORKDIR/DEBIAN/control

bash $OLDPATH/pkg_search.sh -i
DEPS=$(bash $OLDPATH/pkg_search.sh)
CERTPATH="\/$PREFIX\/share\/$NAME\/ca-certificates\/Costa_Rica"

sed -i "s/DEPS/$DEPS/g" $WORKDIR/DEBIAN/control
sed -i "s/NAME/$NAME/g" $WORKDIR/DEBIAN/postinst
sed -i "s/CERTPATH/$CERTPATH/g" $WORKDIR/DEBIAN/postinst
sed -i "s/APP/$NAME/g" $WORKDIR/DEBIAN/changelog
sed -i "s/VERSION/$VERSION/g" $WORKDIR/DEBIAN/changelog
sed -i "s/OS/$CODEBASE/g" $WORKDIR/DEBIAN/changelog



cp $CODE_PREFIX/certs/* $WORKDIR/$PREFIX/share/$NAME/ca-certificates/Costa_Rica
cp $CODE_PREFIX/lib/$ARCH/* $WORKDIR/$PREFIX/lib/
cp $WORKDIR/DEBIAN/copyright  $WORKDIR/$PREFIX/share/doc/$NAME/

gzip -9 -c $WORKDIR/DEBIAN/changelog > $WORKDIR/$PREFIX/share/doc/$NAME/changelog.gz

rm $WORKDIR/DEBIAN/changelog
rm $WORKDIR/DEBIAN/copyright
rm $WORKDIR/$PREFIX/share/$NAME/ca-certificates/Costa_Rica/Readme.md



chown -R root:root $WORKDIR


cd $WORKDIR

for fp in  ${FILE_PATHS[@]}; do
    for u in $fp*; do  md5sum "$u" >> DEBIAN/md5sums; done
done


chmod +x usr/share/firmadigitalcr/bin/update-p11-kit-symlinks



cd $OLDPATH

cd $WORKDIR/../
dpkg-deb -b $NAME-$VERSION
cd $OLDPATH
