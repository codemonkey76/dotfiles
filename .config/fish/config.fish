
if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias vim="nvim"
alias vi="nvim"
alias p="sudo pacman -S --noconfirm"
alias pu="sudo pacman -Syu --noconfirm"
alias mkdir="mkdir -p"
alias ls="exa --icons --group-directories-first"
alias ll="exa --long --no-permissions --octal-permissions --no-time --git --icons --group-directories-first"

set -x fish_user_paths $HOME/go/bin $fish_user_paths
set -x fish_user_paths $HOME/.config/composer/vendor/bin $fish_user_paths
set -x fish_user_paths $HOME/.cargo/bin $fish_user_paths

if [ "$EUID" -ne 0 ]
  set -x STARSHIP_CONFIG $HOME/.config/starship/user/starship.toml
else
  set -x STARSHIP_CONFIG $HOME/.config/starship/root/starship.toml
end

set -x VISUAL nvim
set -x EDITOR nvim

if test -f ~/.env
    while read -la line
        set key (echo $line | cut -d= -f1)
        set value (echo $line | cut -d= -f2)
        set -x $key $value
    end < ~/.env
end

set fish_greeting

starship init fish | source
zoxide init fish --cmd cd | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
