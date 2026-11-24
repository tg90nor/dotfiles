# AGENTS.md

Instructions for AI coding agents working in this repository.

## Git policy

- **Stay on the `main` branch.** Do not create new branches, switch branches, or
  set up worktrees unless the user explicitly asks for it.
- **Never `git push`** under any circumstances. The user will push manually.
- Commits are fine. Make small, focused commits with clear messages. Stage only
  the files that belong to the change; ignore unrelated edits already in the
  working tree.

## Repository overview

Personal dotfiles for `tg90nor`. The repo is cloned to `$DOTDIR/dotfiles`
(default `~/dot/dotfiles`) and the contents are symlinked into `$HOME` and
`$XDG_CONFIG_HOME` by `setup.sh`.

- `setup.sh` — bootstraps a fresh machine: installs packages (`curl`, `tmux`,
  `git`, `vim`), clones this repo, then symlinks config files into place. Only
  `tmux_conf` and `zsh_conf` are enabled by default; `vim_conf` and
  `homemanager_conf` are commented out.
- `bin/dot` — entry-point shell wrapper. Subcommands: `setup`, `check`,
  `update`, `envs ...`, plus a default that launches a tmux session for a named
  environment under `$DOTDIR/envs/<name>` (a symlink to a target directory).
- `bin/` — user scripts on `PATH` (e.g. `kc`, `dot`, `99`, `hm-update`).
  `bin/mkpw` and `*.zwc` files are gitignored.
- `zsh/` — `zshenv` (env vars, `DOTDIR`, `PATH`) and `zshrc`. `ppath` holds
  bootstrap dirs that load before the snap-installed zsh plugins.
- `home-manager/` — Nix home-manager config (`flake.nix`, `home.nix`,
  `flake.lock`). Disabled by default; re-enable in `setup.sh` when used.
- `nixos/` — NixOS host configs and shared `lib`.
- `nvim/` — a small Neovim config (`init.lua`), independent of the legacy Vim
  setup in `vim_conf`.
- Top-level files symlinked into `$HOME`: `vimrc`, `tmux.conf`, `ctags`,
  `gitmux`, `ripgreprc`, `gh-config.yml`, `Monokai.itermcolors`,
  `wsltty.tar.gz`.
- `README.md` — the user-facing install/update instructions.

## Conventions

- Shell scripts start with `#!/usr/bin/env zsh`. Match existing style
  (lowercase variables, two-space indent for `setup.sh`, compact cases in
  `bin/dot`).
- The default branch is `main`. Clone URLs:
  `https://github.com/tg90nor/dotfiles.git` or
  `git@github.com:tg90nor/dotfiles.git` (chosen by `DOTFILES_CLONE_METHOD`).
