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
if ! grep -q signals "${PKG}/PKGBUILD"; then
    sed -i '/Build the project/i \
	# boost 1.69 uses signals2 as a header-only package \
	sed -i "s/ signals//" ${srcdir}/${_dir}/CMakeLists.txt' "${PKG}/PKGBUILD"
    grep -q signals "${PKG}/PKGBUILD" && echo "fixed successful" || \
            die "fixed failure. do it manually."
else
    echo "${PKG} already fixed."
fi

if grep -q signals "${PKG}/PKGBUILD"; then
    pushd "${PKG}"
    makepkg -si --noconfirm
    popd
fi

### packages that needed this fix

# ros-melodic-roscpp
# ros-melodic-message-filters
# ros-melodic-tf
# ros-melodic-tf2
# ros-melodic-rviz
# ros-melodic-image-view
# ros-melodic-laser-assembler
# ros-melodic-laser-filters
