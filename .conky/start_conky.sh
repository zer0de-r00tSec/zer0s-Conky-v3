#!/bin/bash
# Startet die drei OWC-Conky-Fenster (alte Instanzen werden beendet)

killall -q conky
sleep 2   # beim Login: kurz warten, bis der Desktop steht

for c in clock top bottom; do
  conky -c "$HOME/.conky/owc_$c.conf" &
done
