# Biome Plugin Git Source

This plugin allows you use `git url` as `pkg_source`.

It overrides `do_default_clean`, `do_default_download`, `do_default_verify` and `do_default_unpack` to get source from git repository.

## Usage

```
# Set url to your repository
pkg_source="https://github.com/biome-sh/bio-plugin-git-source.git"
pkg_build_deps+=(biome/bio-plugin-git-source)

# Set git reference to use
pkg_git_source_branch=master

# Set how many commits to fetch
pkg_git_source_depth=50

# Set origin name
pkg_git_source_origin=biome-plugin

do_setup_environment() {
  source $(pkg_path_for biome/bio-plugin-git-source)/lib/plugin.sh
}
```

Consider source [bio-plugin-git-source](habitat/lib/plugin.sh)
