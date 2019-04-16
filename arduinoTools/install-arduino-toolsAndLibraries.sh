#sudo apt-get update
#This will ensure the tar.xz will unpack
#sudo apt-get install xz-utils

#Set version required
arduinoVersion=arduino-1.8.9-linux32
#sudo curl https://downloads.arduino.cc/$arduinoVersion.tar.xz -O -J -L
#sha512sum $arduinoVersion.tar.xz > zippedtar-xz-SHA512.txt

# The following command retrives a list of hashes for various distrobutions
sudo curl https://downloads.arduino.cc/arduino-1.8.9.sha512sum.txt > arduino-sha512sum.txt

# The following command extracts the relevant hash for downloded distro 
grep $arduinoVersion.tar.xz arduino-sha512sum.txt > theSha512sum.txt

x=$(cat zippedtar-xz-SHA512.txt)
y=$(cat theSha512sum.txt)

echo $x
printf $y

if [ "$x" != "$y" ];
then
    printf "wrong hash\n"
    exit 0
fi

printf "Hashes are OK and unpacking\n"
#tar -xvJf $arduinoVersion.tar.xz

# Now we need libraries to allow ESP8268 to comunicate
# info at https://github.com/knolleary/pubsubclient
curl https://github.com/knolleary/pubsubclient/archive/master.zip

#The teperature and humidity libries are required
#info at https://github.com/adafruit/DHT-sensor-library
curl https://github.com/adafruit/DHT-sensor-library/archive/master.zip