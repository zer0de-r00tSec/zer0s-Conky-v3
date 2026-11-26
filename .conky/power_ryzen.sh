#!/bin/bash
# CPU-Paketleistung ueber RAPL (funktioniert auch bei Ryzen).
# Ohne "sleep": merkt sich den letzten Messwert und rechnet die Differenz,
# damit Conky nicht jede Sekunde blockiert.

RAPL="/sys/class/powercap/intel-rapl:0/energy_uj"
STATE="/dev/shm/conky_rapl.state"

if [ ! -r "$RAPL" ]; then
  echo "n/a"
  exit 0
fi

E=$(<"$RAPL")
T=$(date +%s%N)
OE="" OT=""
[ -r "$STATE" ] && read -r OE OT < "$STATE"
echo "$E $T" > "$STATE"

# Erster Aufruf oder Zaehler-Ueberlauf -> noch kein Wert
if [ -z "$OE" ] || [ "$E" -lt "$OE" ] || [ "$T" -le "$OT" ]; then
  echo "…"
  exit 0
fi

# µJ / ns  ->  W   (dE*1e-6 / dT*1e-9 = dE*1000/dT)
awk -v e=$((E - OE)) -v t=$((T - OT)) 'BEGIN { printf "%.1f W\n", e * 1000 / t }'
