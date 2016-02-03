#!/bin/bash
REMOTE_HOST="[REMOTE_HOST_URL]"
SSH_USER="[REMOTE_HOST_SSH_USER]"
SSH_PASSWD="[REMOTE_HOST_SSH_PASSWD]"

HOSTKEY=$(ssh-keygen -H -F $REMOTE_HOST)
if [ ! "$HOSTKEY" ]; then
        echo "Remote host public key not found, asking for it"
        ssh-keyscan -H $REMOTE_HOST >> ~/.ssh/known_hosts
fi

SESSION=$(tmate -S /tmp/tmate.sock new-session -d -s thinc 2>&1)
if [ ! "$SESSION" ]; then
        tmate -S /tmp/tmate.sock send -t thinc.0 vlock ENTER
        tmate -S /tmp/tmate.sock wait tmate-ready
fi

HOST=$(hostname)
MODEL=$(lsblk --nodeps -no model /dev/sda)
SERIAL=$(lsblk --nodeps -no serial /dev/sda)

NAME=$HOST-${MODEL//[[:blank:]]/}-${SERIAL//[[:blank:]]/}
URL=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')

TOKEN=$(echo $URL | sed 's/ssh \([^@]*\).*/\1/g')
API_INFO=$(curl https://tmate.io/api/t/$TOKEN)

CLOSED=$(echo $API_INFO | sed 's/.*{[^,]*,[^,]*,[^,]*,"closed_at":\([^}]*\)}.*/\1/g')
if [ "$CLOSED" != "null" ]; then
        echo "Expired session!"
        killall -9 tmate
        SESSION=$(tmate -S /tmp/tmate.sock new-session -d -s thinc 2>&1)
        tmate -S /tmp/tmate.sock send -t thinc.0 vlock ENTER
        tmate -S /tmp/tmate.sock wait tmate-ready

        URL=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')
fi

echo $URL
sshpass -p $SSH_PASSWD ssh $SSH_USER@$REMOTE_HOST "~/save_remote_connection.sh '$NAME' '$URL'; exit"

