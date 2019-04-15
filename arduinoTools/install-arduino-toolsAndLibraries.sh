#sudo apt-get update
#sudo apt-get install xz-utils
arduinoVersion=arduino-1.8.9-linux32
#sudo curl https://downloads.arduino.cc/$arduinoVersion.tar.xz -O -J -L
sudo curl https://downloads.arduino.cc/arduino-1.8.9.sha512sum.txt > arduino-sha512sum.txt
grep $arduinoVersion.tar.xz arduino-sha512sum.txt > theSha512sum.txt

#sha512sum $arduinoVersion.tar.xz > zippedtar-xz-SHA512.txt

x=$(cat zippedtar-xz-SHA512.txt)
y=$(cat theSha512sum.txt)

echo $x
printf $y

if [ "$x" != "$y" ];
then
    printf "wrong hash\n"
    exit 0
fi

printf "Hashes are OK and unzipping\n"
#tar -xvJf $arduinoVersion.tar.xz

