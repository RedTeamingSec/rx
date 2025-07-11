#!/bin/bash
set -e

# Fungsi untuk mengecek apakah program sudah terinstall
is_installed() {
    command -v "$1" >/dev/null 2>&1
}

# Path ke folder app (pastikan jalankan skrip di folder ini)
APP_DIR="$(pwd)"

# Mulai instalasi
for archive in *.tar.*; do
    # Abaikan jika bukan file tar
    [ -f "$archive" ] || continue

    # Ambil nama direktori dari file tar
    dir_name=$(tar tf "$archive" | head -1 | cut -f1 -d"/")
    
    # Tentukan nama binari utama berdasarkan nama paket (heuristik)
    bin_name=$(echo "$dir_name" | sed 's/-[0-9].*//')

    # Lewatkan jika sudah terinstal
    if is_installed "$bin_name"; then
        echo -e "\e[32m[SKIP]\e[0m $bin_name sudah terinstal, lewati..."
        continue
    fi

    echo -e "\e[34m[INSTALL]\e[0m Ekstrak dan build $archive ..."
    tar -xf "$archive"
    cd "$dir_name"

    # Patch khusus jika perlu
    if [[ "$dir_name" == luit-* ]]; then
        sed -i -e "/D_XOPEN/s/5/6/" configure
    fi

    ./configure $XORG_CONFIG
    make -j$(nproc)
    make install

    cd ..
    rm -rf "$dir_name"
    echo -e "\e[32m[OK]\e[0m $bin_name selesai diinstall."
done

echo -e "\n\e[36m[Selesai]\e[0m Semua Xorg Apps diproses."
