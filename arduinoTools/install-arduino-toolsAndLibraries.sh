## This script runs as root to install Arduino IDE and nessasery libraries
## to program ESP8266 with temperature and light switch and MQTT messaging

#sudo apt-get update

#This will ensure the tar.xz will unpack
#sudo apt-get install xz-utils

##Set version required
arduinoVersion=arduino-1.8.9-linux64
arduinoFolder=arduino-1.8.9
if [ ! -e "$arduinoVersion.tar.xz" ]; then
    sudo curl https://downloads.arduino.cc/$arduinoVersion.tar.xz -O -J -L
fi

if [ ! -e "zippedtar-xz-SHA512.txt" ];then
    sha512sum $arduinoVersion.tar.xz > zippedtar-xz-SHA512.txt
fi
## The following command retrives a list of hashes for various distrobutions
if [ ! -e "arduino-sha512sum.txt" ]; then
    sudo curl https://downloads.arduino.cc/arduino-1.8.9.sha512sum.txt > arduino-sha512sum.txt
fi
## The following command extracts the relevant hash for downloded distro 
if [ ! -e "theSha512sum.txt" ]; then 
    grep $arduinoVersion.tar.xz arduino-sha512sum.txt > theSha512sum.txt
fi

x=$(cat zippedtar-xz-SHA512.txt)
y=$(cat theSha512sum.txt)

printf $x
printf $y

if [ "$x" != "$y" ];
then
    printf "wrong hash\n"
#    exit 0
fi

if [ ! -e "$arduinoVersion" ]; then
    printf "Hashes are OK and unpacking\n"
    tar -xvJf $arduinoVersion.tar.xz
fi
## Now we need libraries to allow ESP8268 to comunicate
## info at https://github.com/knolleary/pubsubclient
if [ ! -e "pubsubclient-master.zip" ]; then
    sudo curl https://github.com/knolleary/pubsubclient/archive/master.zip -O -J -L
    unzip pubsubclient-master.zip
    mv pubsubclient-master pubsubclient
fi
## The teperature and humidity libries are required
## info at https://github.com/adafruit/DHT-sensor-library
if [ ! -e "DHT-sensor-library-master.zip" ]; then
    sudo curl https://github.com/adafruit/DHT-sensor-library/archive/master.zip -O -J -L
    unzip DHT-sensor-library-master.zip
    mv DHT-sensor-library-master DHT
fi
rm *.zip
thisDirectory=$PWD
if [ ! -e "$arduinoFolder" ]; then
    ## The following library removes errors when starting arduino
    sudo apt-get install libcanberra-gtk-module
    sudo mv $arduinoFolder /opt/
    cd /opt/$arduinoFolder
    #sudo ./install.sh
    cd $thisDirectory
fi

mv DHT ~/Arduino/libraries
mv pubsubclient ~/Arduino/libraries
cp lightTempHumid ~/Arduino/

printf "Arduino should be installed now\n"
printf "Open the preferences window from the Arduino IDE. Go to File > Preferences\n"
printf "Enter http://arduino.esp8266.com/stable/package_esp8266com_index.json\n"
printf "into the Additional Board Manager URLs then press OK\n"
printf "If problems with serial port permitions refer to following page\n"
printf "https://www.arduino.cc/en/Guide/Linux\n" 
printf "Start arduino then select file open then lightTempHumid should now be ready to compile"
