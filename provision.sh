#!/bin/bash
# Kiet To

function die () {
    [ -n "$1" ] && echo "$1" || echo "dying without error message."
    exit 1
}

function install_PKGBUILD () {
    local PKG
    [ -n "$1" ] && PKG="$1" || return
    pacman -Qi "${PKG}" 2> /dev/null > /dev/null && return

    [ -d "${BASEDIR}" ] || die "BASEDIR ${BASEDIR} not found."

    if [ -d "${BASEDIR}/${PKG}" ]; then
        pushd "${BASEDIR}/${PKG}"
        makepkg -si --noconfirm --needed
        popd
    else
        yaourt -Sy --noconfirm --needed "${PKG}"
    fi
}

function process_PKGBUILD () {
    local PKG i DEPS MAKEDEPS
    [ -n "$1" ] && PKG="$1" || return
    pacman -Qi "${PKG}" 2> /dev/null > /dev/null && return

    PKGBUILD="/tmp/PKGBUILD-${PKG}"
    set +e
    unset ros_depends ros_makedepends
    curl --silent -o "${PKGBUILD}" "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=${PKG}"
    source "${PKGBUILD}"
    DEPS=( "${ros_makedepends[@]}" "${ros_depends[@]}" )
    rm -fv "${PKGBUILD}"
    set -e

    if [ -n "${DEPS}" ]; then
        for (( i=0; i<${#DEPS[@]}; i++ )); do
            ### echo "$i / ${#DEPS[@]} -> ${DEPS[$i]}"
            process_PKGBUILD "${DEPS[$i]}"
            ### echo "${PKG} <= ${DEPS[@]}"
        done
    else
        echo "${PKG}: leaf package"
    fi

    install_PKGBUILD "${PKG}"

    unset ros_depends ros_makedepends PKG DEPS MAKEDEPS
    return 0
}

[ -n "$1" ] && BASEDIR="$1" || BASEDIR="/vagrant"
[ -n "$2" ] && TOPPKG="$2" || TOPPKG="ros-melodic-desktop-full"

set -e
## fix ignition-transport bug with libpgm
sudo mkdir -pv /usr/lib/pgm-5.2/include

## for opencv
yaourt -Sy --noconfirm --needed openblas

# install AUR dependencies
for PKG in urdfdom-headers \
           python-rosdistro \
           console-bridge \
           log4cxx \
           flann \
           ogre-1.9 \
           pcl \
           urdfdom \
           ros-build-tools \
           python2-empy \
           python-empy \
           ros-melodic-catkin \
           ros-melodic-opencv3; do
    install_PKGBUILD "${PKG}"
done

process_PKGBUILD "${TOPPKG}"
set +e

cat <<EOF
To set up your shell environment (i.e. for bash):
  $ . /opt/ros/melodic/setup.bash
After installation, remember to initialize the package dependency database
  $ sudo rosdep init
  $ rosdep update
To start you the ros core
  $ roscore
EOF
