#!/bin/bash
myboot="/media/winnie/MYBOOT"
myfs="/media/winnie/myfs"
out="/home/winnie/tftp/out"
bootfile="boot.scr BOOT.BIN  image.ub"
fsfile="rootfs.tar.gz"
blite="$out/blite"
bhw="$out/system.bit $out/pl.dtbo"
bpath="$myfs/lib/firmware"
nbitname="BBDL_SPW_XXV_20240307.bit.bin"

cd $myboot
rm -rf *
cd $myfs
sudo rm -rf *

cd $out
cp $bootfile $myboot
sudo tar zxf $fsfile -C $myfs
echo "----"
sudo cp $bhw $bpath/
sudo cp -r $blite/* $bpath/
cd $bpath
sudo cp system.bit $nbitname
echo "show $bpth"
ls -l *
