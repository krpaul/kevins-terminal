# kevins-terminal

Terminal config, installed by symlink so the repo stays the source of truth.

## Install

```sh
git clone <repo-url> ~/kevins-terminal
~/kevins-terminal/install.sh
```

`install.sh` clones Oh My Zsh and the Pure prompt, then symlinks `zsh/zshrc` to
`~/.zshrc`. An existing `~/.zshrc` is moved to `~/.zshrc.backup.<timestamp>`.
It is safe to re-run.

## Update

```sh
termup
```

Pulls this repo, updates Oh My Zsh and Pure, and reloads the shell.

## Machine-specific settings

Put them in `~/.zshrc.local`. It is sourced last and is not tracked here.
