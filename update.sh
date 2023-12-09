#!/bin/bash

branch="main"
XDG_CONFIG_HOME="$HOME/.config"

usage(){
>&2 cat << EOF
Usage: update.sh [-a]
EOF
exit 1
}

# Arg validation
args=$(getopt -o ah --long all,help -- "$@")
if [[ $? -gt 0 ]]; then
  usage
fi

# Arg parsing
eval set -- ${args}
while :
do
  case $1 in
    -a | --all)  all=true ; shift ;;
    -h | --help) usage    ; shift ;;
    --) shift; break ;;
    *) >&2 echo Unsupported option: $1
       usage ;;
  esac
done

if [ "$EUID" -ne 0 ] && [ "$all" = true ]; then
  echo "Must be run as root!"
  exit 1
fi

# Add config files
cp ./dotfiles/zshrc $HOME/.zshrc
cp ./dotfiles/vimrc $HOME/.vimrc

# bvkt
if [ ! -f $XDG_CONFIG_HOME/bvkt ]; then mkdir -p $XDG_CONFIG_HOME/bvkt; fi
cp -r ./dotfiles/bvkt/* $XDG_CONFIG_HOME/bvkt

# tmux
if [ ! -f $XDG_CONFIG_HOME/tmux ]; then mkdir -p $XDG_CONFIG_HOME/tmux; fi
cp -r ./dotfiles/tmux/* $XDG_CONFIG_HOME/tmux

# nvim
if [ ! -f "$XDG_CONFIG_HOME/nvim" ]; then mkdir -p "$XDG_CONFIG_HOME/nvim"; fi
git clone https://github.com/eyesofbucket/nvim-config.git "$XDG_CONFIG_HOME/nvim"

# Add custom config template if it hasn't already been created
if [ ! -f $XDG_CONFIG_HOME/bvkt/custom.sh ]; then
  cp ./dotfiles/custom.sh $XDG_CONFIG_HOME/bvkt/custom.sh
fi

# Install vim plugins as listed in the config file
vim --not-a-term -c "PlugInstall" -c "%w /tmp/vim.log" -c "qa" >/dev/null
cat /tmp/vim.log

# Install neovim plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

if [ "$all" = true ]; then
  cp ./dotfiles/sudoers_eyesofbucket /etc/sudoers.d/eyesofbucket
  chmod 440 /etc/sudoers.d/eyesofbucket
fi
