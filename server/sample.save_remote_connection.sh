#!/bin/bash
BD_NAME="[BD_NAME]"
BD_PASSWD="[BD_PASSWD]"

DATE=$(date +"%Y-%m-%d %H:%M")

mysql -u remote_devices --password='$BD_PASSWD' $BD_NAME << EOF
insert into RemoteDevices (idDevice,URL,LastSeen) values('$1','$2','$DATE') on duplicate key update URL='$2',LastSeen='$DATE';
EOF
