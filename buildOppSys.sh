#!/bin/bash
printf "THIS IS A VERRY POWERFULL SCRIPT TAKE CARE AS HARDDRIVE COULD BE WIPED\n"
sleep 5s
#sudo apt-get update
#sudo apt-get install -y curl
#sudo apt-get install -y util-linux
#sudo curl http://downloads.raspberrypi.org/raspbian_lite/images\
#/raspbian_lite-2019-04-09/2019-04-08-raspbian-stretch-lite.zip -O -J -L
#sha256sum 2019-04-08-raspbian-stretch-lite.zip > zipSHA256.txt
# REM this is a comment we now need the 256 hash from website by the following cmd 
#sudo curl http://downloads.raspberrypi.org/raspbian_lite/images\
#/raspbian_lite-2019-04-09/2019-04-08-raspbian-stretch-lite.zip.sha256 > onlinesha256.txt

x=$(cat zipSHA256.txt)
y=$(cat onlinesha256.txt)
echo $x
printf $y
if [ "$x" != "$y" ];
then
    printf "wrong hash\n"
    exit 0
fi

printf "Hashes are OK and unzipping\n"
#unzip 2019-04-08-raspbian-stretch-lite.zip
#REM this is a comment, the following cmd uses prefered browser and runs in background
#xdg-open https://www.raspberrypi.org/downloads/raspbian/&

printf "we now need start block of the boot sector for mounting\n"
sudo fdisk -l 2019-04-08-raspbian-stretch-lite.img
printf "we will use this to mount the image\n"

read -p "please enter start block for the boot sector"$'\n' startblock
numbersregex='^[0-9]+$'
while ! [[  $startblock =~ $numbersregex ]]; do
    printf "you did not enter a number\n"
    read -p "you did not enter a number"$'\n' startblock
done

printf "we will now calculate the offset as 512 * start block to find mount point\n"

mymountpoint=$((startblock*512))
printf $mymountpoint 

read -n1 -r -p $'\n'"press y to continue n to stop"$'\n' key
if [ "$key" != 'y' ]; then
    printf "stopping\n"
    exit 0
fi

printf "continuing\n"

## This is the file that is mounted
ourmountfile=/mnt

if grep -qs $ourmountfile /proc/mounts; then
    printf "mounted so we will dismount\n"
    sudo umount $ourmountfile
fi

printf "we are mounting now\n"
sudo mount -o loop,offset=$mymountpoint 2019-04-08-raspbian-stretch-lite.img $ourmountfile

myhome=$PWD

cd $ourmountfile
ls
sudo touch ssh
printf "\nwe have created a blank secure shell file\n"

ls
printf "We are creating wpa_supplicants for network connection\n"
#sudo touch wpa_supplicant.conf
#sudo cat $myhome/wpa_supplicant.conf > wpa_supplicant.conf
sudo cp $myhome/wpa_supplicant.conf  wpa_supplicant.conf
cd $myhome

read -n1 -r -p $'\n'"press y key to procceed"$'\n' key
if [ "$key" != 'y' ]; then
    printf [$key]" ok you have now quit an we will unmount\n"
    sudo umount $ourmountfile
    exit 0
fi

sudo umount $ourmountfile
printf [$key]" umounted\n"

sudo lsblk
sudo fdisk -l
df -h
read -n1 -r -p $'\n'"please insert SD card for writing and press y to continue"$'\n' key
if [ "$key" != 'y' ]; then
    printf [$key]" ok you have now quit\n"
    exit 0
fi
sudo lsblk
sudo fdisk -l
df -h
read -n1 -r -p $'\n'"please enter number of partitions on /dev/s for SD card"$'\n' key
numbersregex='^[1-2]+$'
while ! [[  $key =~ $numbersregex ]]; do
    read -p "you did not enter a number or more tha 2 partitions"$'\n' key
done

if [ "$key" == '1' ]; then
    read -p $'\n'"please enter device with partition number /dev/s..1"$'\n' SDmountpoint1
    printf $SDmountpoint1" Dismounting\n"
    sudo umount $SDmountpoint1
else
    read -p $'\n'"please enter device with partition number1 /dev/s..1"$'\n' SDmountpoint1
    printf $SDmountpoint1"\n"
    sudo umount $SDmountpoint1
    read -p $'\n'"please enter device with partition number /dev/s..2"$'\n' SDmountpoint2
    printf $SDmountpoint2"\n"
    sudo umount $SDmountpoint2
fi

read -n1 -r -p $'\n'"if you are happy  press y to continue"$'\n' key
if [ "$key" != 'y' ]; then
    printf [$key]" ok you have now quit\n"
    exit 0
fi
read -p $'\n'"now enter device to writ to /dev/s..without partition number"$'\n' Filemountpoint

printf $Filemountpoint "\n"

sudo dd bs=4M status=progress if=2019-04-08-raspbian-stretch-lite.img of=$Filemountpoint conv=fsync

exit 0 
