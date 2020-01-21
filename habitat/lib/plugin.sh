# shellcheck shell=bash

# Bio Plugin Git Source
# Allows to use git repository url in `pkg_source`
#
# Variables:
# `pkg_git_source_branch` - branch, tag or ref to download. SHA Commit is not allowed. Default `master`
# `pkg_git_source_depth` - number of commits to fetch. Default `1`
# `pkg_git_source_origin` - origin name to use. Default `biome-plugin`
#
# Functions:
# `do_git_source_download` - does shallow clone or fetch from `pkg_source`
# `do_git_source_verify` - skipped because git verifies files automatically
# `do_git_source_clean` - quickly cleans and resets repo using git
# `do_git_source_unpack` - check outs specified branch


: "${pkg_git_source_branch:=master}"
: "${pkg_git_source_depth:=1}"
: "${pkg_git_source_origin:=biome-plugin}"

do_default_download() {
    do_git_source_download
}

do_git_source_download() {
    _git_source_reset_dirname

    if [[ -z "${pkg_source:-}" ]]; then
        exit_with "pkg_source is not set" 1
    fi

    if [[ -d "$CACHE_PATH/.git" ]]; then
        (
            cd "$CACHE_PATH"
            build_line "Git repository $CACHE_PATH exists. Attempt to reuse"
            # shellcheck disable=SC2154
            git remote set-url "$pkg_git_source_origin" "$pkg_source"
            git fetch --depth "$pkg_git_source_depth" "$pkg_git_source_origin" +refs/heads/"$pkg_git_source_branch":refs/remotes/"$pkg_git_source_origin"/"$pkg_git_source_branch"
        )
    else
        build_line "Git download! Doing shallow clone from $pkg_source to $CACHE_PATH"
        git clone --origin "$pkg_git_source_origin" --depth "$pkg_git_source_depth" --no-checkout --branch "$pkg_git_source_branch" "$pkg_source" "$CACHE_PATH"
    fi
}

do_default_verify() {
    do_git_source_verify
}

do_git_source_verify() {
    build_line "Skipping checksum verification for git repository."
    return 0
}

do_default_clean() {
    do_git_source_clean
}

do_git_source_clean() {
    _git_source_reset_dirname

    if [ ! -d "$CACHE_PATH" ]; then
        return 0
    fi

    if [ -d "$CACHE_PATH/.git" ]; then
        (
            cd "$CACHE_PATH"
            build_line "Clean up repository using git"
            git reset --hard HEAD
            git clean -fdx
        )
    else
        warn "$CACHE_PATH does not look like git repository"
    fi
}

do_default_unpack() {
    do_git_source_unpack
}

do_git_source_unpack() {
    _git_source_reset_dirname

    build_line "Force checkout $pkg_git_source_branch"
    (
        cd "$CACHE_PATH"
        git checkout -f "$pkg_git_source_origin/$pkg_git_source_branch"
    )
}

# We don't need separate folder for each combintation of pkg_name-pkg_version
# However there are many places where path can be updated, so reset them before any action
_git_source_reset_dirname() {
    # shellcheck disable=SC2154
    pkg_dirname="$pkg_name"
    CACHE_PATH="$HAB_CACHE_SRC_PATH/$pkg_dirname"
    SRC_PATH="$CACHE_PATH"
}
