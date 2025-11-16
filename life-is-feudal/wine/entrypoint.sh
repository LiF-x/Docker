#!/bin/bash

# Life is Feudal: Your Own - Wine Container Entrypoint
# For use with Pterodactyl

# Start Xvfb for headless Wine
Xvfb :99 -screen 0 1024x768x16 &
export DISPLAY=:99

# Wait for Xvfb to start
sleep 2

# Change to the server directory
cd /home/container || exit 1

# Execute the command passed to the container
# This allows Pterodactyl to control the startup command
exec "$@"
