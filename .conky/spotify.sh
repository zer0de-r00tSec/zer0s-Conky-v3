#!/bin/bash
# Spotify-Infos fuer Conky
#   spotify.sh cover          -> laedt Cover nur, wenn sich der Titel aendert
#   spotify.sh artist|title|album [laenge]

P="playerctl -p spotify"

case "$1" in
  cover)
    URL=$($P metadata mpris:artUrl 2>/dev/null) || exit 0
    URL=${URL/open.spotify.com/i.scdn.co}   # aeltere Clients liefern falsche Domain
    LAST=/dev/shm/spotify_cover.url
    if [ -n "$URL" ] && [ "$URL" != "$(cat "$LAST" 2>/dev/null)" ]; then
      curl -s --max-time 5 "$URL" -o /dev/shm/spotify_cover.tmp \
        && mv /dev/shm/spotify_cover.tmp /dev/shm/spotify_cover.jpg \
        && echo "$URL" > "$LAST"
    fi
    ;;
  artist|title|album)
    $P metadata --format "{{ trunc($1, ${2:-22}) }}" 2>/dev/null
    ;;
esac
