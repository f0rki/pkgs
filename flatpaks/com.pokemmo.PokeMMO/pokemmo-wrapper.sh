#!/usr/bin/env bash

os_flags=""

case "`uname`" in
  Darwin* )
    # GLFW/LWJGL3 limitation for macOS
    os_flags="-XstartOnFirstThread"
    ;;
esac

# PokeMMO requires that the working directory be that of all game files (PokeMMO.exe / data / roms / etc.)
# `cd` to this directory prior to executing this script, or include your `cd` below.

set -e
mkdir -p "$XDG_DATA_HOME/game/"
cd "$XDG_DATA_HOME/game/"
if ! test -e ./PokeMMO.exe || test "$(cat revision.txt)" -ne "$(cat /app/bin/revision.txt)"; then
  echo "[Unpacking] revision $(cat /app/bin/revision.txt)"
  if test -e ./revision.txt; then
    echo "[Unpacking] overwriting revision $(cat ./revision.txt)"
  fi
  unzip /app/bin/pokemmo.zip
fi

# PokeMMO currently requires JDK 17.
# Consult your distro's documentation for how to install the OpenJDK 17 Java Runtime Environment

exec java -Xmx384M $os_flags -Dfile.encoding="UTF-8" -cp PokeMMO.exe com.pokeemu.client.Client
