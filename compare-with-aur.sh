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
    curl -s -o /tmp/PKGBUILD "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=${PKG}"
    diff "${PKG}/PKGBUILD" "/tmp/PKGBUILD"
}

[ -n "$1" ] && PKG="$1" || die "pkgname not specified."
while [ -n "$1" ]; do
    compare_with_aur "$1"
    shift
done

