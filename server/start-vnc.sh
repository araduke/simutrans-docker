#!/bin/bash

# Remove any stale X lock files
rm -f /tmp/.X99-lock

# Start virtual framebuffer on display :99
Xvfb :99 -screen 0 1920x1080x24 &
sleep 1

# Start VNC server exposing :99
x11vnc -display :99 -forever -rfbauth /root/.vnc/passwd -quiet -listen 0.0.0.0 -xkb &

# Simutransを起動する
eval "$COMMAND" &
PID=$!
# もしSimutransプロセスが終了したら再起動する
while true; do
  if ! ps -p $PID > /dev/null; then
    echo "Simutrans process has exited. Restarting..."
    eval "$COMMAND" &
    PID=$!
  fi
  sleep 5
done &

# Keep the script running to maintain the VNC server
wait
