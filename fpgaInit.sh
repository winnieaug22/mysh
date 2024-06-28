# fpgabit=BBDL_SPW_XXV_20240307.bit.bin
# fpgabit=LCISpace111_Golden_20240611.bit.bin
# fpgabit=LCISpace111_Golden_20240615.bit.bin
libf=/lib/firmware
xilinxbase=$libf/xilinx/base
blite=$libf/blite
fmanager=/sys/class/fpga_manager
conf=/configfs/device-tree/overlays/full
home=/home/root
testfile=image_test_14M.ub
gogo=1
echo "---cp $xilinxbase/* to $libf/---"
if [ "$gogo" -eq 1 ]; then
    cp $xilinxbase/* $libf/
fi
echo

echo "---$fpgabit---"
echo "echo 0 > $fmanager/fpga0/flags"
echo "echo $fpgabit > $fmanager/fpga0/firmware"
if [ "$gogo" -eq 1 ]; then
    echo 0 > $fmanager/fpga0/flags
    # echo system.bit > /sys/class/fpga_manager/fpga0/firmware
    echo $fpgabit > $fmanager/fpga0/firmware
fi
echo

echo "---mount /configfs---"
if [ "$gogo" -eq 1 ]; then
    rm -rf /configfs
    mkdir /configfs
    mount -t configfs configfs /configfs
fi

echo "---base.dtbo---"
echo "echo -n \"base.dtbo\" > $conf/path"
if [ "$gogo" -eq 1 ]; then
    mkdir -p $conf
    echo -n "base.dtbo" > $conf/path
fi
echo

echo "--- ifconfig sp0 up ---"
if [ "$gogo" -eq 1 ]; then
    ifconfig sp0 up
fi
echo "---Done---"
echo

echo "--- testspw in $libf ---"
echo "testspw rx"
echo "cp $blite/$testfile $libf"
echo "testspw tx $testfile"
echo "--rx--"
echo "diff /run/$testfile $blite/$testfile"
echo
echo "--- mytestspw in $libf ---"
echo "mytestspw rx > winnie.log"
echo "cp $blite/$testfile $libf"
echo "testspw tx $testfile"
echo "--rx--"
echo "diff $libf/cp_$testfile $libf/$testfile"
echo
