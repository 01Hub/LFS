#!/bin/bash

if [ $# -lt 1 ] ; then
  echo "This script needs the location of the xml file to update"
  exit 1
fi

FILE=$1

./make-aux-files.sh

# Bootscript data
bootscripts=$(ls lfs-systemd-units*.bz2)
base=$(basename $bootscripts .tar.bz2)
bootsize=$(ls -lk $bootscripts | cut -f5 -d" ")
bootmd5=$(md5sum $bootscripts | cut -f1 -d" ")

# Figure intalled size of bootscripts
TOPDIR=$(pwd)
TMP_DIR=$(mktemp -d /tmp/lfsbootfiles.XXXXXX)
pushd $TMP_DIR > /dev/null
tar -xf $TOPDIR/$bootscripts
bootinstallsize=$(du -sk $TMP_DIR | cut -f1)
popd > /dev/null
rm -rf $TMP_DIR

sed -i -e s/LFS-UNITS-SIZE/$bootsize/              \
       -e s/LFS-UNITS-INSTALL-KB/$bootinstallsize/ \
       -e s/LFS-UNITS-MD5SUM/$bootmd5/ $FILE

