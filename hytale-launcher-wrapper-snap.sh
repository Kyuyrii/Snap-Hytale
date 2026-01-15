#!/bin/sh
export XDG_CONFIG_HOME="$SNAP_USER_COMMON/.config"

export XDG_DATA_HOME="$SNAP_USER_COMMON/.local/share"

export XDG_CACHE_HOME="$SNAP_USER_COMMON/.cache"

LAUNCHER_DIR="$XDG_DATA_HOME/Hytale"
LAUNCHER_BIN="$LAUNCHER_DIR/hytale-launcher"
BUNDLED_HASH_FILE="$LAUNCHER_DIR/.bundled_hash"
mkdir -p "$LAUNCHER_DIR"
# Compute hash of bundled binary to detect Snap package updates
BUNDLED_HASH=$(sha256sum $SNAP/usr/bin/hytale-launcher | cut -d" " -f1)
# Copy bundled binary if: no binary exists, OR the Snap package was updated
# This preserves self-updates while still applying Snap package updates
if [ ! -x "$LAUNCHER_BIN" ] || [ ! -f "$BUNDLED_HASH_FILE" ] || [ "$(cat "$BUNDLED_HASH_FILE")" != "$BUNDLED_HASH" ]; then
  cp $SNAP/usr/bin/hytale-launcher "$LAUNCHER_BIN"
  echo "$BUNDLED_HASH" > "$BUNDLED_HASH_FILE"
fi
exec "$LAUNCHER_BIN" "$@"
