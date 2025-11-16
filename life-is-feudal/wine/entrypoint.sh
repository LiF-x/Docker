#!/bin/bash
cd /home/container

# Start Xvfb BEFORE ANY wine or steamcmd commands
if [[ $XVFB == 1 ]]; then
    echo "Starting Xvfb on display :0"
    Xvfb :0 -screen 0 ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x${DISPLAY_DEPTH} &
    export DISPLAY=:0
    sleep 2   # Important: give Xvfb time to initialize
fi

# Information output
echo "Running on Debian $(cat /etc/debian_version)"
echo "Current timezone: $(cat /etc/timezone)"
wine --version    # Now safe – DISPLAY exists

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP


## steam user handling
if [ -z "$STEAM_USER" ]; then
    echo -e "steam user is not set.\nUsing anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
else
    echo -e "user set to ${STEAM_USER}"
fi

## auto update logic
if [ -z "$AUTO_UPDATE" ] || [ "$AUTO_UPDATE" == "1" ]; then 
    if [ -n "$SRCDS_APPID" ]; then
        ./steamcmd/steamcmd.sh +force_install_dir /home/container \
            +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} \
            $( [[ "${WINDOWS_INSTALL}" == "1" ]] && printf %s '+@sSteamCmdForcePlatformType windows' ) \
            +app_update 1007 \
            +app_update ${SRCDS_APPID} \
            $( [[ -n ${SRCDS_BETAID} ]] && printf %s "-beta ${SRCDS_BETAID}" ) \
            $( [[ -n ${SRCDS_BETAPASS} ]] && printf %s "-betapassword ${SRCDS_BETAPASS}" ) \
            $( [[ -n ${HLDS_GAME} ]] && printf %s "+app_set_config 90 mod ${HLDS_GAME}" ) \
            $( [[ -n ${VALIDATE} ]] && printf %s "validate" ) \
            +quit
    else
        echo -e "No appid set. Starting Server."
    fi
else
    echo -e "Not updating server as AUTO_UPDATE is 0."
fi

echo "First launch may throw Wine errors. This is normal."

mkdir -p $WINEPREFIX

# List and install other packages
for trick in $WINETRICKS_RUN; do
        echo "Installing $trick"
        winetricks -q $trick
done

# Replace Startup Variables
MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
