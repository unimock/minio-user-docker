#!/bin/sh

#We use the UID, don't care about the user name (because docker :/)
#user_exists=$(id -u ${MINIO_USER} > /dev/null 2>&1; echo $?) 
user_uid=$(id -u ${MINIO_USER} 2> /dev/null) 
uid_exists=$(getent passwd $MINIO_UID)

#Default GID to UID unless explicitly set
if [ ! "$MINIO_GID" ]; then
   MINIO_GID=$MINIO_UID
fi

#Default export dir to /export (which is default for minio)
if [ ! "$MINIO_HOMEDIR" ]; then
   MINIO_HOMEDIR=/export
fi
export HOME="${MINIO_HOMEDIR}"
mkdir -p $MINIO_HOMEDIR

if [ "$uid_exists" ]; then
      echo "user exists"
# else
#    echo "user doesn't exist"
# fi
else
      echo "Ensuring group exists"
      addgroup -g ${MINIO_GID} ${MINIO_GROUP} 
      echo "User does not exist, creating"
      adduser -u ${MINIO_UID} -G ${MINIO_GROUP} -s /bin/bash ${MINIO_USER} -D -h "${MINIO_HOMEDIR}" 
fi

env

#Minio perms hack, won't work without this...
mkdir -p /etc/X11 && chown -R ${MINIO_UID} /etc/X11 && chmod -R 777 /etc/X11

#Pre make & chown minio home dir
mkdir -p "${MINIO_HOMEDIR}/.minio/" && chown -R ${MINIO_UID} "${MINIO_HOMEDIR}/.minio/" && chmod -R 777 "${MINIO_HOMEDIR}/.minio/"
#Ensure home dir correctly set
#/usr/sbin/usermod -m -d ${MINIO_HOMEDIR} ${MINIO_USER}
#No usermod in alpine, will have to delete & recreate user if this comes up

chown -R ${MINIO_UID}:${MINIO_GID} "${MINIO_HOMEDIR}"
/usr/bin/gosu ${MINIO_UID} /go/bin/minio $@

