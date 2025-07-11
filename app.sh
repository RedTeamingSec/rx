#!/bin/bash

# [+] Xorg Applications Installer - BLFS 11.2
# [+] https://www.linuxfromscratch.org/blfs/view/11.2/x/xorg-applications.html

set -e  # Exit jika ada error

# 1. Siapkan variabel dan direktori
mkdir -pv /sources/xorg-apps/{app,build}
cd /sources/xorg-apps

cat > app-7.md5 << "EOF"
5d3feaa898875484b6b340b3888d49d8  iceauth-1.0.9.tar.xz
c4a3664e08e5a47c120ff9263ee2f20c  luit-1.1.1.tar.bz2
fd2e6e5a297ac2bf3d7d54799bf69de0  mkfontscale-1.2.2.tar.xz
92be564d4be7d8aa7b5024057b715210  sessreg-1.1.2.tar.bz2
2f72c7170cdbadc8ef786b2f9cfd4a69  setxkbmap-1.3.3.tar.xz
3a93d9f0859de5d8b65a68a125d48f6a  smproxy-1.0.6.tar.bz2
e96b56756990c56c24d2d02c2964456b  x11perf-1.6.1.tar.bz2
dbcf944eb59343b84799b2cc70aace16  xauth-1.1.2.tar.xz
5b6405973db69c0443be2fba8e1a8ab7  xbacklight-1.2.3.tar.bz2
82a90e2feaeab5c5e7610420930cc0f4  xcmsdb-1.0.6.tar.xz
25cc7ca1ce5dcbb61c2b471c55e686b5  xcursorgen-1.0.7.tar.bz2
f67116760888f2e06486ee3d179875d2  xdpyinfo-1.3.3.tar.xz
480e63cd365f03eb2515a6527d5f4ca6  xdriinfo-1.0.6.tar.bz2
61219e492511b3d78375da76defbdc97  xev-1.2.5.tar.xz
90b4305157c2b966d5180e2ee61262be  xgamma-1.0.6.tar.bz2
a48c72954ae6665e0616f6653636da8c  xhost-1.0.8.tar.bz2
ac6b7432726008b2f50eba82b0e2dbe4  xinput-1.6.3.tar.bz2
c45e9f7971a58b8f0faf10f6d8f298c0  xkbcomp-1.4.5.tar.bz2
c747faf1f78f5a5962419f8bdd066501  xkbevd-1.1.4.tar.bz2
cf65ca1aaf4c28772ca7993cfd122563  xkbutils-1.0.5.tar.xz
938177e4472c346cf031c1aefd8934fc  xkill-1.0.5.tar.bz2
61671fee12535347db24ec3a715032a7  xlsatoms-1.1.3.tar.bz2
4fa92377e0ddc137cd226a7a87b6b29a  xlsclients-1.1.4.tar.bz2
f33841b022db1648c891fdc094014aee  xmessage-1.0.6.tar.xz
0d66e07595ea083871048c4b805d8b13  xmodmap-1.0.11.tar.xz
9cf272cba661f7acc35015f2be8077db  xpr-1.1.0.tar.xz
2358e29133d183ff67d4ef8afd70b9d2  xprop-1.2.5.tar.bz2
fe40f7a4fd39dd3a02248d3e0b1972e4  xrandr-1.5.1.tar.xz
85f04a810e2fb6b41ab872b421dce1b1  xrdb-1.2.1.tar.bz2
33b04489e417d73c90295bd2a0781cbb  xrefresh-1.0.7.tar.xz
70ea7bc7bacf1a124b1692605883f620  xset-1.2.4.tar.bz2
5fe769c8777a6e873ed1305e4ce2c353  xsetroot-1.1.2.tar.bz2
b13afec137b9b331814a9824ab03ec80  xvinfo-1.1.4.tar.bz2
f783a209f2e3fa13253cedb65eaf9cdb  xwd-1.0.8.tar.bz2
26d46f7ef0588d3392da3ad5802be420  xwininfo-1.1.5.tar.bz2
5ff5dc120e8e927dc3c331c7fee33fc3  xwud-1.0.6.tar.xz
EOF

# 2. Download semua paket
cd app
grep -v '^#' ../app-7.md5 | awk '{print $2}' | wget --no-check-certificate -c -i- -B https://www.x.org/pub/individual/app/

# 3. Verifikasi checksum
md5sum -c ../app-7.md5

# 4. Fungsi untuk jadi root
as_root() {
    if [ $EUID -eq 0 ]; then "$@"
    elif command -v sudo >/dev/null; then sudo "$@"
    else su -c "$*"
    fi
}
export -f as_root

# 5. Build & Install semua paket
bash -e
for package in $(grep -v '^#' ../app-7.md5 | awk '{print $2}'); do
    packagedir=${package%.tar.?z*}
    tar -xf $package
    pushd $packagedir

    case $packagedir in
        luit-[0-9]* )
            sed -i -e "/D_XOPEN/s/5/6/" configure
        ;;
    esac

    ./configure $XORG_CONFIG
    make -j$(nproc)
    as_root make install

    popd
    rm -rf $packagedir
done
exit

# 6. Hapus script rusak (opsional)
as_root rm -f $XORG_PREFIX/bin/xkeystone

echo "✅ Semua Xorg Applications selesai diinstall!"
