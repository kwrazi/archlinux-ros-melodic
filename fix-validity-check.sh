#!/bin/bash
# Kiet To
#

# According to https://github.com/ros-gbp/ros_comm-release README.md
# to following packages are affected by changes in ros_comm
ROS_COMM_SET=(
   "ros-melodic-message-filters"
   "ros-melodic-ros-comm"
   "ros-melodic-rosbag"
   "ros-melodic-rosbag-storage"
   "ros-melodic-roscpp"
   "ros-melodic-rosgraph"
   "ros-melodic-roslaunch"
   "ros-melodic-roslz4"
   "ros-melodic-rosmaster"
   "ros-melodic-rosmsg"
   "ros-melodic-rosnode"
   "ros-melodic-rosout"
   "ros-melodic-rosparam"
   "ros-melodic-rospy"
   "ros-melodic-rosservice"
   "ros-melodic-rostest"
   "ros-melodic-rostopic"
   "ros-melodic-roswtf"
   "ros-melodic-topic-tools"
   "ros-melodic-xmlrpcpp"
)

# see https://github.com/ros-gbp/common_msgs-release
COMMON_MSGS_SET=(
   "ros-melodic-actionlib-msgs"
   "ros-melodic-common-msgs"
   "ros-melodic-diagnostic-msgs"
   "ros-melodic-geometry-msgs"
   "ros-melodic-nav-msgs"
   "ros-melodic-sensor-msgs"
   "ros-melodic-shape-msgs"
   "ros-melodic-stereo-msgs"
   "ros-melodic-trajectory-msgs"
   "ros-melodic-visualization-msgs"
)

function check_pkg_in_set () {
    [ -n "$1" ] && PKG="$1" || return
    [ -n "$2" ] && PKGSET="${2}[@]" || return

    for p in "${!PKGSET}"; do
        if [ "${PKG}" == "$p" ]; then
            return 0 # PKG is in package set
        fi
    done
    return 1 # PKG is not in package set
}

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

function fix_pkg () {
    [ -n "$1" ] && PKG="$1" || return
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
        sed -i -E 's/make$/nice make -j$(nproc)/' PKGBUILD

        makepkg -si
        popd
    fi
}

[ -n "$1" ] && PKG="$1" || die "pkgname not specified."

fix_pkg "${PKG}"
if check_pkg_in_set "${PKG}" "ROS_COMM_SET"; then
    echo "NOTE: ${PKG} is in ROS_COMM_SET"
elif check_pkg_in_set "${PKG}" "COMMON_MSGS_SET"; then
    echo "NOTE: ${PKG} is in COMMON_MSGS_SET"
fi     
[ -n "$2" ] && [ "$2" == "--set" ] || exit 0
if check_pkg_in_set "${PKG}" "ROS_COMM_SET"; then
    echo "fixing all packages in ros_comm-release"
    for PKG in ${ROS_COMM_SET[@]}; do
        fix_pkg "${PKG}"
    done
elif check_pkg_in_set "${PKG}" "COMMON_MSGS_SET"; then
    echo "fixing all packages in common_msgs-release"
    for PKG in ${COMMON_MSGS_SET[@]}; do
        fix_pkg "${PKG}"
    done
fi
