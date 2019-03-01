# README

The aim of this project is to create a test environment for the ROS melodic packages in the AUR
repository for Arch Linux. The main script is ``provision.sh`` which is used to install
``ros-melodic-desktop-full``.  It is also the same script used to provision an Arch Linux vagrant
box for testing, debugging and applying PKGBUILD fixes.

The way ``provision.sh`` works is that if there is a local ``ros-melodic-*/PKGBUILD`` then it builds
and installs that version (using ``makepkg -si``) otherwise, it will use ``yaourt`` to install it.

This way, if there are any broken AUR packages, we can fix it locally and install it. Hence to
install it on an Arch Linux machine, goto the ``provision.sh`` subdirectory and type:

```
./provision.sh <local-fix-dir> <top-package>
# <local-fix-dir> defaults to /vagrant
# <top-package> dfaults to ros-melodic-desktop-full

# To install ros-melodic-desktop-full on Arch Linux
./provision.sh .

# To install ros-melodic-desktop
./provision.sh . ros-melodic-desktop

# To install bare-bones ros-melodic-ros-base
./provision.sh . ros-melodic-ros-base
```

If the packages are fixed upstream, we can just remove the local ``PKGBUILD`` subdirectories to make
``provision.sh`` use the official packages.

Included in this packages are all the corrected packages that I used to successfully build and
install ros-melodic (as of 2019-02-14).

## Vagrant ros-melodic Test Box

To boot up the vagrant box:

```
vagrant up
```
This may take several hours depend on your machine and network connect to install ALL the ``ros-melodic-desktop-full`` packages.

Ohter useful commands:

```
# just apply provisioning to the vagrant box
vagrant provision

# reboot and reload all /vagrant files to the vagrant box
vagrant reload

# remove the vagrant box completely
vagrant destroy
```

## Useful Scripts

* ``fix-validity-check.sh`` - if you have a validity check problem, this script creates a fix for
  it. This appears to be the most common issue. To use, just type the package as the first argument:

   ```
   # for example
   ./fix-validity-check.sh ros-melodic-rosout

   # you can continue with provisioning after this
   ./provision.sh .
   ```
* ``fix-boost-signals.sh`` - at the time I created this, Arch Linux was using boost 1.69 which
  removed signsla and replaced it with signsls2. Some of the CMakeLists.txt used by ROS packages
  tries to detect boost signals. This script fixes packages that has this issue.

   ```
   # for example
   ./fix-boost-signals.sh ros-melodic-roscpp
   ```
* ``fix-pc-file.sh`` - at the time I created this, Arch Linux was using cmake 3.13 which created
  ``-l-lpthread`` cflags problems. This script fixes packages that has this issue.
* ``fix-parallel-make.sh`` - this add ``make -j$(nproc)`` to local package so speed up
  building. This is an optional fix.
* ``clean-ros-melodic.sh`` cleans up makepkg files in local packages
* ``uninstall-ros-melodic.sh`` - uninstall all ros-melodic packages from local install.
* ``compare-with-aur.sh`` - compares the local PKGBUILD with the AUR version.
* ``get-pacman-log.sh`` - ``tail -f`` the pacman.log file on the vagrant machine. Used to monitor
  and snapshot what packages were installed.
