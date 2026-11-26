#!/bin/bash
# Ryzen-CPU-Temperatur (Tctl) aus dem k10temp-Sensor
for h in /sys/class/hwmon/hwmon*; do
  if [ "$(cat "$h/name" 2>/dev/null)" = "k10temp" ]; then
    t=$(cat "$h/temp1_input" 2>/dev/null) || break
    echo "$((t / 1000)) °C"
    exit 0
  fi
done
echo "n/a"
