#!/usr/bin/env python3
"""Krypto-Kurs in EUR fuer Conky (Quelle: CoinGecko, kein API-Key noetig).

Aufruf: python3 price.py BTC
Holt alle Coins mit EINEM Abruf, cached 6 Minuten in /tmp und gibt bei
Netzproblemen den letzten bekannten Wert aus. Nur Standardbibliothek.
Fehler landen in /tmp/conky_crypto.err (zum Nachschauen).
"""
import fcntl
import json
import os
import sys
import time
import urllib.request

# Conky-Kuerzel -> CoinGecko-ID
COINS = {
    "BTC": "bitcoin",
    "XRP": "ripple",
    "DOGE": "dogecoin",
    "LTC": "litecoin",
    "PEPE": "pepe",
}
CACHE = "/tmp/conky_crypto.json"
LOCK = "/tmp/conky_crypto.lock"
ERRLOG = "/tmp/conky_crypto.err"
MAX_AGE = 360
UP = "3DFF6E"     # gruen
DOWN = "FF5050"   # rot
URL = ("https://api.coingecko.com/api/v3/simple/price?vs_currencies=eur"
       "&include_24hr_change=true&ids="
       + ",".join(COINS.values()))


def load_cache():
    try:
        with open(CACHE) as f:
            return json.load(f)
    except (OSError, ValueError):
        return None


def cache_age():
    try:
        return time.time() - os.path.getmtime(CACHE)
    except OSError:
        return float("inf")


def fetch():
    req = urllib.request.Request(URL, headers={"User-Agent": "conky-owc"})
    with urllib.request.urlopen(req, timeout=5) as r:
        data = json.load(r)
    if not isinstance(data, dict) or "bitcoin" not in data:
        raise ValueError(f"unerwartete Antwort: {str(data)[:200]}")
    tmp = CACHE + ".tmp"
    with open(tmp, "w") as f:
        json.dump(data, f)
    os.replace(tmp, CACHE)
    return data


def get_data():
    if cache_age() < MAX_AGE:
        return load_cache()
    with open(LOCK, "w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        if cache_age() < MAX_AGE:
            return load_cache()
        try:
            return fetch()
        except Exception as e:
            with open(ERRLOG, "a") as f:
                f.write(f"{time.strftime('%F %T')} {e!r}\n")
            return load_cache()


def fmt(p):
    if p >= 1:
        s = f"{p:,.2f}"
    elif p >= 0.01:
        s = f"{p:,.4f}"
    else:
        s = f"{p:.8f}"
    return s.replace(",", "X").replace(".", ",").replace("X", ".") + " €"


def main():
    # Ausgabe enthaelt Conky-Markup -> in Conky mit ${execpi ...} aufrufen
    if len(sys.argv) < 2:
        print("Usage: price.py <COIN> [x-Position Trend]")
        return
    cid = COINS.get(sys.argv[1].upper())
    col = sys.argv[2] if len(sys.argv) > 2 else "435"
    coin = (get_data() or {}).get(cid, {}) if cid else {}
    price = coin.get("eur")
    change = coin.get("eur_24h_change")
    out = "${color2}" + (fmt(price) if isinstance(price, (int, float)) else "?.??")
    if isinstance(change, (int, float)):
        up = change >= 0
        pct = f"{change:+.2f}".replace(".", ",")
        out += "${goto %s}${color %s}%s %s %%" % (col, UP if up else DOWN, "▲" if up else "▼", pct)
    print(out)


if __name__ == "__main__":
    main()
