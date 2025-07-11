#!/bin/bash

echo "========= Xorg Build Environment Checker ========="

# Daftar dependency & file penting
declare -A CHECKS=(
  ["xau"]="pkg-config:xau"
  ["xdmcp"]="pkg-config:xdmcp"
  ["xproto"]="pkg-config:xproto"
  ["xext"]="pkg-config:xext"
  ["x11"]="pkg-config:x11"
  ["xfont2"]="pkg-config:xfont2"
  ["fontutil"]="pkg-config:fontutil"
  ["libpciaccess"]="pkg-config:pciaccess"
  ["libdrm"]="pkg-config:libdrm"
  ["libxkbfile"]="pkg-config:xkbfile"
  ["libxshmfence"]="pkg-config:xshmfence"
  ["libepoxy"]="pkg-config:epoxy"
  ["libtirpc"]="file:/usr/include/tirpc/rpc/rpc.h"
  ["libbsd"]="pkg-config:bsd"
  ["xkbcomp"]="binary:/usr/bin/xkbcomp"
  ["xtrans"]="header:/usr/include/X11/Xtrans/Xtrans.h"
  ["presentproto"]="pkg-config:presentproto"
  ["xineramaproto"]="pkg-config:xineramaproto"
  ["xf86bigfontproto"]="pkg-config:xf86bigfontproto"
  ["xf86vidmodeproto"]="pkg-config:xf86vidmodeproto"
  ["libxcb"]="pkg-config:xcb"
  ["libXrender"]="pkg-config:xrender"
  ["libXfixes"]="pkg-config:fixesproto"
  ["libXdamage"]="pkg-config:damageproto"
  ["libXcomposite"]="pkg-config:xcomposite"
  ["libXcursor"]="pkg-config:xcursor"
  ["libXrandr"]="pkg-config:xrandr"
  ["libXi"]="pkg-config:xi"
  ["libXmu"]="pkg-config:xmu"
  ["libXt"]="pkg-config:xt"
  ["libXpm"]="pkg-config:xpm"
  ["libXaw"]="pkg-config:xaw7"
  ["libICE"]="pkg-config:ice"
  ["libSM"]="pkg-config:sm"
  ["libXv"]="pkg-config:xv"
  ["libXvMC"]="pkg-config:xvmc"
  ["libXtst"]="pkg-config:xtst"
  ["libXres"]="pkg-config:xres"
  ["pixman-1"]="pkg-config:pixman-1"
  ["nettle"]="pkg-config:nettle"
  ["mesa"]="pkg-config:gl"
  ["dbus-1"]="pkg-config:dbus-1"
  ["gbm"]="pkg-config:gbm"
  ["xkeyboard-config"]="file:/usr/share/X11/xkb/rules/evdev"
)

for name in "${!CHECKS[@]}"; do
    check=${CHECKS[$name]}
    type=${check%%:*}
    value=${check#*:}

    case $type in
        pkg-config)
            if pkg-config --exists "$value"; then
                echo "[OK]        $name (pkg-config: $value)"
            else
                echo "[MISSING]   $name (pkg-config: $value)"
            fi
            ;;
        file)
            if [ -f "$value" ]; then
                echo "[OK]        $name (file: $value)"
            else
                echo "[MISSING]   $name (file: $value)"
            fi
            ;;
        header)
            if [ -f "$value" ]; then
                echo "[OK]        $name (header: $value)"
            else
                echo "[MISSING]   $name (header: $value)"
            fi
            ;;
        binary)
            if [ -x "$value" ]; then
                echo "[OK]        $name (binary: $value)"
            else
                echo "[MISSING]   $name (binary: $value)"
            fi
            ;;
    esac
done

echo "=================================================="
