#!/usr/bin/env bash

set -ex

# Download
URL="https://github.com/ccache/ccache/releases/download/v3.7.7/ccache-3.7.7.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/ccache-3.7.7.tar.gz"

# Configure
. cross-pkg-config
pushd ccache-3.7.7
./configure \
    --host="aarch64-rpi3-linux-gnu" \
    --prefix="/usr/local" \
    CFLAGS="--sysroot ${RPI3_SYSROOT} -O3 \
            $(pkg-config zlib --cflags)" \
    CXXFLAGS="--sysroot ${RPI3_SYSROOT} -O3 \
            $(pkg-config zlib --cflags)" \
    LDFLAGS="$(pkg-config zlib --libs)"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI3_STAGING}"

# Cleanup
popd
rm -rf ccache-3.7.7