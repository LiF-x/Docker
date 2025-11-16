#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Replace Startup Variables
MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Switch to the container's working directory
cd /home/container || exit 1
mkdir -p /home/container/tmp

# Setup NSS Wrapper for use ($NSS_WRAPPER_PASSWD and $NSS_WRAPPER_GROUP have been set by the Dockerfile)
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
export USER_NAME=container

cd /home/container 

{ /usr/sbin/mysqld & }
MYSQL_PID=$!
sleep 5

# You can now use $MYSQL_PID in your script
echo "MySQL started with PID: $MYSQL_PID"

mysql_upgrade -u root

kill "$MYSQL_PID"

echo "Process $MYSQL_PID terminated."

# Run the Server
eval ${MODIFIED_STARTUP}
