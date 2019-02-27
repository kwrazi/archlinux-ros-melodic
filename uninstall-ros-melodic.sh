#!/bin/bash
# Kiet To

AUX=( \
      console-bridge \
      gazebo \
      gmock \
      gtest \
      ignition-fuel_tools \
      ignition-transport \
      log4cxx \
      nvidia-cg-toolkit \
      ogre-1.9 \
      ois \
      pcl \
      poco \
      python-gnupg \
      python-netifaces \
      python-psutil \
      python-pydot \
      python-rosdep \
      python-rosdistro \
      python-rospkg \
      sbcl \
      sdformat \
      tinyxml \
      urdfdom \
      urdfdom-headers \
    )

function remove_not_installed () {
    FILTER=()
    for PKG in $*; do
	if pacman -Q "${PKG}" >& /dev/null; then
	    FILTER+=("${PKG}")
	fi
    done
    if [ "${#FILTER[@]}" -gt 0 ]; then
	yaourt -R --noconfirm "${FILTER[@]}"
    else
	echo "No packages to uninstall."
    fi
}

ROSPKGS=$(pacman -Q | grep ros- | cut -d' ' -f1)
remove_not_installed ${AUX[@]} ${ROSPKGS[@]}

find -mindepth 2 -maxdepth 2 -type d -name src | xargs -r -- rm -rfv
find -mindepth 2 -maxdepth 2 -type d -name pkg | xargs -r -- rm -rfv
find -mindepth 2 -maxdepth 2 -type f -name "*.tar.xz" | xargs -r -- rm -fv
