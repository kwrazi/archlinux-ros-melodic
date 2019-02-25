#!/bin/bash
#

function die() {
    MSG=$1
    echo "${MSG}"
    exit 1
}

[ -n "$1" ] && PKG="$1" || die "pkgname not specified."
[ -d "${PKG}" ] || die "no local package ${PKG} found"

curl -s -o /tmp/PKGBUILD "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=${PKG}"
diff "${PKG}/PKGBUILD" "/tmp/PKGBUILD"
