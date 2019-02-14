#!/bin/bash
# Kiet To

pacman -Q | grep ros- | cut -d' ' -f1 | xargs -r -- yaourt -R --noconfirm
yaourt -R gmock log4cxx ogre-1.9 python-defusedxml python-gnupg python-netifaces python-psutil python-pydot python-rosdep sbcl urdfdom
yaourt -R console-bridge gtest nvidia-cg-toolkit ois poco python-rosdistro tinyxml urdfdom-headers
yaourt -R python-rospkg
# yaourt -R pcl

find -mindepth 2 -maxdepth 2 -type d -name src | xargs -r -- rm -rfv
find -mindepth 2 -maxdepth 2 -type d -name pkg | xargs -r -- rm -rfv
find -mindepth 2 -maxdepth 2 -type f -name "*.tar.xz" | xargs -r -- rm -fv
