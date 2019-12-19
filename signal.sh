#!/bin/sh
#
# Created by Egodrone
# Detect when WiFi device is out of signal
#
# Run script from the terminal:
# sudo bash signal.sh
# alternative:
# sudo chmod +x signal.sh; ./signal.sh

# Declare normal state, to compare signal strength to:
compare=202

# Declare current folder with the files that needed
cwd=$(pwd)

while true
do
    val=0
    val=$(sudo cat /proc/net/wireless | grep "wlan0" | awk '{print $4}' | grep -o '[0-9]*');
    case $val in
        ''|*[!0-9]*) check=404 ;;
        *) check=202 ;;
    esac
    # Check if signal is not out of the reach. Usially if its over 80 its too far away
    # Obs this is logaritmical, not usual numbers
    echo $val
    if [ $check -eq $compare ] && [ $val -ne 1 ] && [ ! -z $val ]
    then
        echo "Hotspot signal is fine!"
        # Call another script to play the music, light up led lamps or whatever
        sudo sh $cwd/play.sh
    else
        echo "Hotspot signal is out of the reach"
        # Call another script or do nothing. Lets play barking dog sound
        sudo python3 dog.py
    fi
    sleep 2
done

# For more details of the WiFi signal:

#watch -n 1 "awk 'NR==3 {print \"WiFi Signal Strength = \" \$3 \"00 %\"}''' /proc/net/wireless"

# This one is the same too
#watch -n 1 cat /proc/net/wireless

# Another one
#watch -n 1 "awk 'NR==3 {print \"WiFi Signal Strength = \" (\$3/70)*100 \" %\"}''' /proc/net/wireless"

# Another one with no conversion
#cat /proc/net/wireless

# Another one
#watch -n 1 "iwconfig wlan0 | grep 'Bit\|Link'"
