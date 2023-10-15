#!/bin/bash

branch="main"
all=""

usage(){
>&2 cat << EOF
Usage: setup.sh [-a]
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
    -a | --all)  all="-a" ; shift ;;
    -h | --help) usage     ; shift ;;
    # -- means the end of the arguments. Shift and break out of the while loop
    --) shift; break ;;
    *) >&2 echo Unsupported option: $1
       usage ;;
  esac
done

if [ "$EUID" -ne 0 ]; then
  echo "Must be run as root!"
  exit 1
fi

# Install requirements
PACKAGES='curl wget zsh git vim'

# Debian
if which apt >/dev/null; then
  apt install -y $PACKAGES

# Fedora
elif which yum >/dev/null; then
  yum install -y $PACKAGES

# Arch
elif which pacman >/dev/null; then
  pacman -S --noconfirm $PACKAGES
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

# Install oh-my-posh
declare -A arch=( ['x86_64']='amd64' ['aarch64']='arm64' ['armv71']='arm' )
wget "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-${arch[$(uname -m)]}" -O /usr/local/bin/oh-my-posh
chmod a+rx /usr/local/bin/oh-my-posh

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Run update script
./update.sh $all
