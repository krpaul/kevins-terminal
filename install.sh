#!/usr/bin/env bash
# Installs or updates the terminal config. Safe to re-run.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"

command -v git >/dev/null || { echo "install: git is required" >&2; exit 1; }
command -v zsh >/dev/null || { echo "install: zsh is required" >&2; exit 1; }

# Shallow clone, or fast-forward if already present.
clone_or_pull() {
  local url="$1" dir="$2"
  if [ -d "$dir/.git" ]; then
    echo "updating  $dir"
    git -C "$dir" pull --quiet --ff-only || echo "  (update failed, keeping current version)" >&2
  else
    echo "cloning   $url"
    git clone --quiet --depth=1 "$url" "$dir"
  fi
}

# Symlink src to dst, moving any existing file out of the way first.
link() {
  local src="$1" dst="$2"
  if [ "$(readlink "$dst" 2>/dev/null)" = "$src" ]; then
    echo "linked    $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    local backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    echo "backed up $dst -> $backup"
  fi
  ln -s "$src" "$dst"
  echo "linked    $dst -> $src"
}

# Install a package with whichever package manager is available.
ensure() {
  local pkg="$1"
  if command -v "$pkg" >/dev/null; then
    echo "found     $pkg"
  elif command -v brew >/dev/null; then
    echo "installing $pkg"
    brew install --quiet "$pkg"
  elif command -v apt-get >/dev/null; then
    echo "installing $pkg"
    sudo apt-get install -y "$pkg"
  else
    echo "install: please install $pkg manually" >&2
  fi
}

ensure tmux

clone_or_pull https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_DIR"
clone_or_pull https://github.com/sindresorhus/pure.git "$ZSH_DIR/custom/pure"

link "$REPO/zsh/zshrc" "$HOME/.zshrc"
link "$REPO/tmux/tmux.conf" "$HOME/.tmux.conf"

echo "done. Open a new terminal or run: exec zsh"
