#!/bin/bash
timeStart=$(date +%s)
toolpath=~/tool/petalinux_v2021_2
action=$1
myProj=$(pwd)
out=$myProj/out
img=$myProj/images/linux
buildLog=$myProj/build/build.log

# forChXsa="/home/winnie/data/xsa/BBDL_SPW_XXV_20240307.xsa"
forChXsa="/home/winnie/data/xsa/LCISpace111_Golden_20240611.xsa"
# forChXsa="/home/winnie/data/xsa/LCISpace111_Golden_20240615.xsa"
projName=leo_zcu111v2021_2
remoteUrl=http://140.96.28.94:3000/LEO/$projName.git

check_inproj(){
    if [ ! -d "images" ]; then
        hint "notinproj"
        exit
    fi
}
hint(){
    error=$1
    case $error in
        "notinproj")
            echo no images dir
            ;;
        "all")
            echo Set according to your own petalinux path.
            echo source $toolpath/settings.sh
            echo
            echo bash run.sh [action:clone/chxsa/all/config/build/clean/cp]
            echo bash run.sh [action:qset/qbuild/qrun]
            echo hostfwd=tcp:127.0.0.1:2222-10.0.2.15:22
            echo
            echo git clone $remoteUrl
            echo for change xsa:$forChXsa
            echo
            echo Example:
            echo ./run.sh clone
            echo ./run.sh run
            echo ./run.sh build
            echo ""
            echo ~/cmdgit/gencmd.sh
            echo ~/cmdgit/filelist_nl
            echo ~/cmdgit/log
            ;;
        *)
            hint "all"
            exit
            ;;
    esac

}
setenv(){
    source $toolpath/settings.sh
}
clean(){
    petalinux-build -x mrproper
}
chxsa(){
    echo "cp $forChXsa itri_system.xsa"
    cp $forChXsa itri_system.xsa
}
config(){
    petalinux-config --get-hw-description itri_system.xsa --silentconfig
    # petalinux-config --get-hw-description=itri_system.xsa --silentconfig
    # petalinux-config -c kernel --silentconfig
    # petalinux-config -c u-boot --silentconfig
    # petalinux-config -c busybox --silentconfig
    # petalinux-config -c rootfs --silentconfig
}
pack(){
    petalinux-package --force --boot --fsbl --fpga no --u-boot
}
checkerror(){
    echo "#########error:###########"
    cat $buildLog | grep -n "error: "
    echo "##########################"
}
cp2out(){
    check_inproj
    rm -rf $out
    mkdir -p $out
    cd $img
    cp BOOT.BIN system.bit image.ub pl.dtbo rootfs.tar.gz boot.scr $out
    cp -r ~/share/blite $out
    echo $out
    ls -l $out/
    cd $myProj
    echo "---ssh acer:$acerOutPath---"
    # acerOutPath=tftp/out$(date "+%Y%m%d_%H%M%S")
    acerOutPath=tftp/out
    ssh -t acer "rm -rvf $acerOutPath;exit"
    scp -r out acer:$acerOutPath
    ssh -t acer "ls -l $acerOutPath/;exit"
    echo "ssh acer; ./my2sd.sh"

}
build(){
    petalinux-build
    petalinux-package --boot --u-boot --format BIN
    checkerror
    cp2out
}
if [ "$#" -eq 0 ]; then
    hint "all"
    exit
fi
case $action in
    "clone")
        git clone $remoteUrl
        cd $projName
        git submodule update --init --recursive
        chxsa
        ;;
    "chxsa")
        chxsa
        ;;
    "all")
        config
        build
        ;;
    "pack")
        pack
        ;;
    "clean")
        clean
        ;;
    "config")
        config
        ;;
    "build")
        build
        ;;
    "cp")
        checkerror
        cp2out
        ;;
    "qset")
        petalinux-package --prebuilt --fpga images/linux/system.bit
        cp ~/myprojects/xilinx-zcu111-2021.2/pre-built/linux/images/pmu_rom_qemu_sha3.elf pre-built/linux/images
        ;&
    "qbuild")
        petalinux-package --wic
        cp images/linux/petalinux-sdimage.wic pre-built/linux/images/
        ;;
    "qrun")
        petalinux-boot --qemu --prebuilt 3 --qemu-args "-net nic -net nic -net nic -net nic -net user,hostfwd=tcp:127.0.0.1:2222-10.0.2.15:22"
        ;;
    *)
        hint "all"
        exit
        ;;
esac
#elapsed time
timeFinish=$(date +%s);
echo $((timeFinish-timeStart)) | awk '{print "elapsed time: "int($1/60)" min "int($1%60)" sec"}'
