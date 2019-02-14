#!/bin/bash
# Kiet To

function clean () {
    find -mindepth 2 -maxdepth 2 -type d -name .git       | xargs -r -- rm -rfv
    find -mindepth 2 -maxdepth 2 -type d -name src        | xargs -r -- rm -rfv
    find -mindepth 2 -maxdepth 2 -type d -name pkg        | xargs -r -- rm -rfv
    find -mindepth 2 -maxdepth 2 -type d -name .SRCINFO   | xargs -r -- rm -fv
    find -mindepth 2 -maxdepth 2 -type f -name "*.tar.xz" | xargs -r -- rm -fv
}

clean
