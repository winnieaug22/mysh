# FPGA_PREFIX=BBDL_SPW_XXV_20240307.bit.bin
libf=/lib/firmware
fpgam=/sys/class/fpga_manager
conf=/configfs/device-tree/overlays/full

echo "------"
echo "echo 0 > $fpgam/fpga0/flags"
echo "echo $FPGA_PREFIX > $fpgam/fpga0/firmware"
echo "------"
echo 0 > $fpgam/fpga0/flags
# echo system.bit > /sys/class/fpga_manager/fpga0/firmware
echo $FPGA_PREFIX > $fpgam/fpga0/firmware

rm -rf /configfs
mkdir /configfs
mount -t configfs configfs /configfs

echo "------"
echo "cp $libf/xilinx/base/base.dtbo $libf/"
echo "echo -n \"base.dtbo\" > $conf/path"
echo "------"
mkdir -p $conf
cp $libf/xilinx/base/base.dtbo $libf/
echo -n "base.dtbo" > $conf/path
echo -n "pl.dtbo" > $conf/path

echo "Done"
echo " "
