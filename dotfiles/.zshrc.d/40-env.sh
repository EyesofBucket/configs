addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

addToPathFront $HOME/.local/scripts

if which nvim >/dev/null 2>&1
then
    export EDITOR="$(which nvim)"
    export MANPAGER="$(which nvim) +Man!"
    git config --global core.pager "nvim -R"
    git config --global color.pager no
else
    export EDITOR="$(which vim)"
fi

fpath=(~/.zshrc.d/fpath $fpath)
