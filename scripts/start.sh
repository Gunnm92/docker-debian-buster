#!/bin/bash
echo "---Checking if UID: ${UID} matches user---"
usermod -u ${UID} ${USER}
echo "---Checking if GID: ${GID} matches user---"
usermod -g ${GID} ${USER}
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "root:${ROOT_PWD}" | chpasswd

echo "---Checking for optional scripts---"
if [ -f /opt/scripts/user.sh ]; then
	echo "---Found optional script, executing---"
    chmod +x /opt/scripts/user.sh
    /opt/scripts/user.sh
else
	echo "---No optional script found, continuing---"
fi

if [ ! -d /tmp/xdg ]; then
	mkdir /tmp/xdg
fi

echo "---Starting...---"
rm -R ${DATA_DIR}/.dbus/session-bus/* 2> /dev/null
rm -R ${DATA_DIR}/.cache 2> /dev/null
chown -R ${UID}:${GID} /usr/bin/pm-is-supported
chown -R ${UID}:${GID} /opt/scripts
chown -R ${UID}:${GID} /tmp/xdg
chmod -R 0700 /tmp/xdg
dbus-uuidgen > /var/lib/dbus/machine-id
rm -R /tmp/.* 2> /dev/null
chown -R ${UID}:${GID} ${DATA_DIR}
chown -R ${UID}:${GID} /tmp/config
su ${USER} -c "/opt/scripts/start-server.sh"