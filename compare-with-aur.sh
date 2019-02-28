#!/bin/bash
#

function die() {
    MSG=$1
    echo "${MSG}"
    exit 1
}

function compare_with_aur() {
    PKG="$1"
    if [ -d "${PKG}" ]; then
        echo "===== ${PKG} ======================"
    else
        echo "===== No local package ${PKG} found"
        return
    fi
    /bin/rm -f /tmp/PKGBUILD
    curl -s -o /tmp/PKGBUILD "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=${PKG}"
    if [ -f "${PKG}/PKGBUILD" ]; then
        diff -Naur --color=auto "${PKG}/PKGBUILD" "/tmp/PKGBUILD"
    else
        echo "WARNING: no PKGBUILD in ${DIR}"
    fi
}

[ -n "$1" ] && PKG="$1" || die "pkgname not specified."
while [ -n "$1" ]; do
    PKG=$(basename "$1")
    if [ -d "${PKG}" ]; then
        compare_with_aur "${PKG}"
    else
        echo "No local package '${PKG}'. skipping."
    fi
    shift
done
