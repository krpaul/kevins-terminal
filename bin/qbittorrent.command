#!/usr/bin/env bash
# Double-click to open qBittorrent's Web UI from the home server in your browser.
# Opens an SSH tunnel (local 8080 -> server 8080) and keeps it open until you
# close this window or press Ctrl+C. The ports must match: qBittorrent rejects
# requests whose Host header doesn't match the port it listens on.
set -u

HOST="${QBT_HOST:-kevin@pollux-v3}"
PORT="${QBT_PORT:-8080}"
URL="http://localhost:$PORT"

if nc -z localhost "$PORT" 2>/dev/null; then
  echo "Port $PORT is already in use on this Mac:"
  lsof -nP -iTCP:"$PORT" -sTCP:LISTEN | tail -n +2
  echo
  echo "If that's an old tunnel, close it and try again."
  read -rp "Press Enter to close..."
  exit 1
fi

ssh -N -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 \
  -L "$PORT:localhost:$PORT" "$HOST" &
tunnel=$!
trap 'kill "$tunnel" 2>/dev/null' EXIT INT TERM HUP

# Wait up to ~10s for the tunnel to come up.
for _ in $(seq 1 50); do
  nc -z localhost "$PORT" 2>/dev/null && break
  kill -0 "$tunnel" 2>/dev/null || { echo "SSH tunnel failed to start."; read -rp "Press Enter to close..."; exit 1; }
  sleep 0.2
done

if ! nc -z localhost "$PORT" 2>/dev/null; then
  echo "Timed out waiting for the tunnel."
  read -rp "Press Enter to close..."
  exit 1
fi

echo "Tunnel up: $URL  (close this window to disconnect)"
[ -z "${QBT_NO_OPEN:-}" ] && open "$URL"
wait "$tunnel"
