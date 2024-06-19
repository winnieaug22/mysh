FPGA_PREFIX=BBDL_SPW_XXV_20240307.bit.bin

echo 0 > /sys/class/fpga_manager/fpga0/flags
# echo system.bit > /sys/class/fpga_manager/fpga0/firmware
echo $FPGA_PREFIX > /sys/class/fpga_manager/fpga0/firmware

rm -rf /configfs
mkdir /configfs
mount -t configfs configfs /configfs
cd /configfs/device-tree/overlays
mkdir full
#echo -n "base.dtbo" > full/path
echo -n "pl.dtbo" > full/path
echo "Done"
echo " "
