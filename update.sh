#!/bin/bash

branch="main"
config_dir="$HOME/.config/bvkt"

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
    # -- means the end of the arguments. Shift and break out of the while loop
    --) shift; break ;;
    *) >&2 echo Unsupported option: $1
       usage ;;
  esac
done

if [ "$EUID" -ne 0 ] && [ "$all" = true ]; then
  echo "Must be run as root!"
  exit 1
fi

# Add bvkt dir if it hasn't already been created
if [ ! -f $config_dir ]; then
  mkdir -p $config_dir 
fi

# Add custom config template if it hasn't already been created
if [ ! -f $config_dir/custom.sh ]; then
  cp ./dotfiles/custom.sh $config_dir/custom.sh
fi

# Add config files
cp ./dotfiles/zshrc $HOME/.zshrc
cp ./dotfiles/vimrc $HOME/.vimrc
cp ./dotfiles/alias.sh $config_dir/alias.sh
cp ./dotfiles/eyesofbucket.omp.json $config_dir/eyesofbucket.omp.json

# Install vim plugins as listed in the config file
vim --not-a-term -c "PlugInstall" -c "%w /tmp/vim.log" -c "qa" >/dev/null
cat /tmp/vim.log

if [ "$all" = true ]; then
  cp ./dotfiles/sudoers_eyesofbucket -O /etc/sudoers.d/eyesofbucket
  chmod 440 /etc/sudoers.d/eyesofbucket
fi
