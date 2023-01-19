#!/bin/bash
ls /etc/systemd/system | grep -EI ".+VM"
printf "Which VM would you like to remove autostart for? (Name of VM only)\n"
read vmName
serviceName="${vmName}VM.service"

systemctl disable $serviceName &&
systemctl stop $serviceName &&
rm -f /etc/systemd/system/$serviceName

checkDelete=$(ls /etc/systemd/system | grep -Ei "$serviceName")
if [ "$checkDelete" == "$serviceName" ]; then
        printf "File persists, try again\n"
elif [ "$checkDelete" == "" ]; then
        printf "File deleted!\n"
fi
