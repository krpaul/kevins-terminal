# kevins-terminal

Terminal config, installed by symlink so the repo stays the source of truth.

## Install

```sh
git clone <repo-url> ~/kevins-terminal
~/kevins-terminal/install.sh
```

`install.sh` installs tmux (Homebrew or apt), clones Oh My Zsh and the Pure
prompt, then symlinks `zsh/zshrc` to `~/.zshrc` and `tmux/tmux.conf` to
`~/.tmux.conf`. Existing files are moved to `<name>.backup.<timestamp>`.
It is safe to re-run.

## Update

```sh
termup
```

Pulls this repo, updates Oh My Zsh and Pure, and reloads the shell.

## tmux

The prefix is Option+p (Alt+p). Mouse mode is on, `prefix |` and `prefix -`
split the pane side by side and stacked, and `prefix r` reloads the config. On macOS terminals that type `π` for Option+p, that character is
accepted as the prefix too, so no terminal setup is needed.

## Machine-specific settings

Put them in `~/.zshrc.local`. It is sourced last and is not tracked here.
