# 🗃️ dotfiles
Modular, Stow-powered dotfiles for my development environment.
Each tool's configuration lives in its own folder, symlinked into place using GNU Stow.

## 📦 Included Configs
- `neovim` → `~/.config/nvim`
- `tmux` -> `~/.config/tmux` && `~/.tmux`

## 📥 Installation

Clone the repo recursively:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

If you're using SSH:

```bash
git clone git@github.com:yourusername/dotfiles.git ~/dotfiles
```

Install GNU Stow if you don’t already have it:

```bash
sudo pacman -S stow     # Arch
brew install stow       # macOS
```

## 🔗 Symlink your configs

From the root of the repo:

```bash
stow neovim
```

This will create a symlink:
```bash
~/.config/nvim → ~/dev/dotfiles/neovim/.config/nvim
```
You can repeat this for other modules:

```bash
stow tmux
stow zsh
stow alacritty
```

Or stow everything:

```bash
stow *
```

## 🧹 Unstowing

To remove symlinks created by a package:

```bash
stow -D neovim
```

This safely removes symlinks without deleting your actual files.

## 💡 Tip: Use an alias for convenience

Add this to your `.zshrc` or `.bashrc`:

```bash
alias stow="stow --target=$HOME"
```
