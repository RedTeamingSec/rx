#!/bin/bash

set -e

# Fungsi as_root
as_root() {
  if [ $EUID -eq 0 ]; then "$@"
  elif command -v sudo >/dev/null; then sudo "$@"
  else su -c "$*"
  fi
}
export -f as_root

# Build dan install semua paket
(
  bash -e

  for package in $(grep -v '^#' ../app-7.md5 | awk '{print $2}')
  do
    packagedir="${package%.tar.?z*}"
    tar -xf "$package"
    cd "$packagedir"

    if [[ $packagedir == luit-* ]]; then
      sed -i -e "/D_XOPEN/s/5/6/" configure
    fi

    ./configure $XORG_CONFIG
    make -j$(nproc)
    as_root make install

    cd ..
    rm -rf "$packagedir"
  done

  exit
)

# Hapus xkeystone jika ada
as_root rm -f $XORG_PREFIX/bin/xkeystone
