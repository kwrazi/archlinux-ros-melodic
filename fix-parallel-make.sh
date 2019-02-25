#!/bin/bash
# Kiet To

find -name PKGBUILD | xargs -n 1 -r -- sed -i -E 's/make$/nice make -j$(nproc)/'
