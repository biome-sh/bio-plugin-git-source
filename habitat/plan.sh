# shellcheck shell=bash

pkg_origin=biome
pkg_name=bio-plugin-git-source
pkg_version=0.1.0
pkg_description="The Biome Plugin Git Source"
pkg_upstream_url="https://github.com/biome-sh/bio-plugin-git-source"

pkg_maintainer="Yauhen Artsiukhou <jsirex@gmail.com>"
pkg_license=("MIT")

pkg_deps=(core/git)

do_build() {
    return 0
}

do_install() {
    # shellcheck disable=SC2154
    cp -r "$PLAN_CONTEXT/lib" "$pkg_prefix"
}

do_strip() {
    return 0
}
