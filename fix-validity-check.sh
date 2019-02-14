#!/bin/bash
# Kiet To
#

function die() {
    MSG=$1
    echo "${MSG}"
    exit 1
}

function git_fetch () {
    PKG="$1"
    [ ! -d "${PKG}" ] && git clone "https://aur.archlinux.org/${PKG}.git"
    [ -d "${PKG}" ] && rm -rf "${PKG}/.git" "${PKG}/.SRCINFO"
}

[ -n "$1" ] && PKG="$1" || die "pkgname not specified."

git_fetch "${PKG}"
if [ -f "${PKG}/PKGBUILD" ]; then
    YELLOW="\033[0;33m"
    NC="\033[0m"
    pushd "${PKG}"
    HASH=$(makepkg -g)
    # rm -rfv src "${PKG}*"

    ## common bug #1 - bad hash
    echo -e "${YELLOW}setting hash to ${HASH}${NC}"
    sed -i "s/^.*sums=.*$/${HASH}/" PKGBUILD

    ## common bug #2 - missing pkgver in src directory path
    if [ -f *.tar.gz ]; then
        BASEDIR=$(basename $(tar ztf *.tar.gz | egrep '^[^/]*/$'))
        echo -e "${YELLOW}using base directory ${BASEDIR}${NC}"
        [ -n "${BASEDIR}" ] && sed -i -E "s/_dir=\"[^\"]*\"/_dir=\"${BASEDIR}\"/" PKGBUILD
    fi

    ## make parallel compile
    sed -i -E 's/make$/make -j$(nproc)/' PKGBUILD

    makepkg -si
    popd
fi
