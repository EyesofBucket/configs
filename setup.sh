#!/bin/bash

branch="main"
all=""
packages='curl wget zsh git vim neovim tmux'

usage(){
>&2 cat << EOF
Usage: setup.sh [-a]
EOF
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
    -a | --all)  all="-a"   ; shift ;;
    -h | --help) usage; exit; shift ;;
    # -- means the end of the arguments. Shift and break out of the while loop
    --) shift; break ;;
    *) >&2 echo Unsupported option: $1
       usage; exit 1 ;;
  esac
done

# Check for root
if [ "$EUID" -ne 0 ]; then
  echo "Must be run as root!"
  exit 1
fi

# Install packages
# Debian
if which apt >/dev/null; then
  apt install -y $packages

# Fedora
elif which yum >/dev/null; then
  yum install -y $packages

# Arch
elif which pacman >/dev/null; then
  pacman -S --noconfirm $packages
else
  printf "\033[0;31mUnable to install requirements: No package manager found.\033[0m\n" 1>&2
  exit 1
fi

# Set default shell
usermod "$USER" -s "$(which zsh)"

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install oh-my-posh
declare -A arch=( ['x86_64']='amd64' ['aarch64']='arm64' ['armv71']='arm' )
wget "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-${arch[$(uname -m)]}" -O /usr/local/bin/oh-my-posh
chmod a+rx /usr/local/bin/oh-my-posh

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Run update script
./update.sh $all
