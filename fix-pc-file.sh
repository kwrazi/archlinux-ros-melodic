#!/bin/bash
# Kiet To
# 2019-02-07

cat <<'EOF'
------------------------------------------------------
Insert the following lines into PKGBUILD, inside the package() section:

find ${pkgdir} -name "*.pc" | while read PCFILE; do
  sed -i 's/l-lpthread/lpthread/g' "${PCFILE}"
done
------------------------------------------------------
EOF

set -e
pacman -Q | cut -d' ' -f1 | grep ros- | while read PKG; do
    set +e
    TEST=$(pacman -Ql ${PKG} | egrep '\.pc$' | cut -d' ' -f2 | xargs -r -- grep -l l-lpthread)
    set -e
    if [ -n "${TEST}" ]; then
        echo "Fixing ${PKG}..."
        [ ! -d "${PKG}" ] && git clone "https://aur.archlinux.org/${PKG}.git"
        sed -i '/make .* install/a \
        # fix cmake 3.13.x -l-lpthread issue \
        find ${pkgdir} -name "*.pc" | while read PCFILE; do \
          sed -i "s/l-lpthread/lpthread/g" "${PCFILE}" \
        done' "${PKG}/PKGBUILD"
        pushd "${PKG}"
        makepkg -si --noconfirm
        popd
    fi
done

### files found that needs to be fixed

# ros-melodic-actionlib
# ros-melodic-actionlib-tutorials
# ros-melodic-class-loader
# ros-melodic-cpp-common
# ros-melodic-laser-geometry
# ros-melodic-nodelet-topic-tools
# ros-melodic-rosconsole
# ros-melodic-rostest
# ros-melodic-rostime
# ros-melodic-urdf
