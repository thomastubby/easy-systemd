#!/bin/bash
printf "What is the name of the VM?\n"
read vmName
serviceName="${vmName}VM.service"
printf "Confirm: $vmName (y/n)\n"
read answer
if [ "$answer" == "y" ]; then
sudo cat <<EOF > /etc/systemd/system/${serviceName}
[Unit]
Description=VirtualBox VM $vmName
After=network.target vboxdrv.service
Before=runlevel2.target shutdown.target

[Service]
ExecStartPre=/bin/sleep 30
#User=[[USER]]
#Group=[[GROUP]]
Type=forking
Restart=always
TimeoutSec=5min
IgnoreSIGPIPE=no
KillMode=process
GuessMainPID=no
RemainAfterExit=yes

ExecStart=/usr/bin/vboxmanage startvm "$vmName" --type headless
ExecStop=/usr/bin/vboxmanage controlvm "$vmName" acpipowerbutton

[Install]
WantedBy=multi-user.target
EOF
printf "Service file ${serviceName} placed in /etc/systemd/system/\n"
systemctl enable ${serviceName} &&
printf "${serviceName} is now enabled!\n"
else printf "Cancelled\n"
fi
