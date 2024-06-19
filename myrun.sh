#!/bin/bash
timeStart=$(date +%s)
homedir="/home/winnie"
toolpath="~/tool/petalinux_v2021_2"
action=$1
projName="leo_zcu111v2021_2"
myProj=$(pwd)
# myProj="$homedir/myprojects/$projName"
out="$myProj/out"
buse="$out/buse"
img="$myProj/images/linux"
buildLog="$myProj/build/build.log"

xsaPath="$homedir/data/xsa"
forChXsa="BBDL_SPW_XXV_20240307.xsa"
# forChXsa="LCISpace111_Golden_20240611.xsa"
# forChXsa="LCISpace111_Golden_20240615.xsa"
otherXsa="BBDL_SPW_XXV_20240307.xsa
    LCISpace111_Golden_20240611.xsa
    LCISpace111_Golden_20240615.xsa"
remoteUrl="http://140.96.28.94:3000/LEO/$projName.git"

plDtsi="$myProj/components/plnx_workspace/device-tree/device-tree/pl.dtsi"

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
            echo myrun.sh [action: clone / chxsa xsa/ all / config / build / clean / cp ]
            echo myrun.sh [action: qset / qbuild / qrun ]
            echo hostfwd=tcp:127.0.0.1:2222-10.0.2.15:22
            echo
            echo git clone $remoteUrl
            echo for change xsa:$xsaPath/$forChXsa
            echo other xsa:
            echo $otherXsa
            echo
            echo Example:
            echo myrun.sh clone
            echo myrun.sh run
            echo myrun.sh build
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
    forChXsa=$1
    # echo "cp $xsaPath/$forChXsa itri_system.xsa"
    cp -v $xsaPath/$forChXsa itri_system.xsa
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
    #get bitsteam name
    bitname=$(cat $plDtsi |grep firmware-name|grep -oP '(?<=firmware-name = ")[^";]+' )
    mysh="$homedir/mysh"
    fpgaInit="fpgaInitok.sh"
    check_inproj

    rm -rf $out
    mkdir -p $out
    mkdir -p $buse


    cd $img
    cp BOOT.BIN image.ub rootfs.tar.gz boot.scr $out
    cp pl.dtbo $buse/
    cp system.bit $buse/$bitname
    cp -r ~/share/blite $out
    # cp $mysh/myacer2sd.sh $buse

    echo "FPGA_PREFIX=$bitname">$buse/$fpgaInit
    cat $mysh/fpgaInit.sh >> $buse/$fpgaInit
    echo $out
    ls -l $out/
    ls -l $buse/
    cd $myProj
    echo "---ssh acer:$acerOutPath---"
    # acerOutPath=tftp/out$(date "+%Y%m%d_%H%M%S")
    acerOutPath=out
    ssh -t acer "rm -rvf $acerOutPath;exit"
    scp -r out acer:$acerOutPath
    ssh -t acer "ls -l $acerOutPath/;exit"
    echo "scp $homedir/mysh/myacer2sd.sh acer:"
    echo "ssh acer"
    echo "./myacer2sd.sh out"

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
        chxsa $forChXsa 
        ;;
    "chxsa")
        chxsa $2
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
