#!/bin/bash
# Zufaelliges Bild fuer die Dia-Show (240x180, schwarzer Rand, im RAM)

BILD=$(find /home/zer0/Bilder/Kids -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | shuf -n1)
[ -n "$BILD" ] || exit 0

# Erst in Temp-Datei, dann umbenennen -> Conky liest nie ein halbes Bild
convert "$BILD" -auto-orient -background black -alpha remove -alpha off \
  -resize 240x180 -gravity center -extent 240x180 /dev/shm/current.tmp.png \
  && mv /dev/shm/current.tmp.png /dev/shm/current.png
