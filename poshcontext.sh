function set_poshcontext() {
    depth=$(dirs -p | tail -n +2 | wc -l)
    if [ "$depth" -ne "0" ]; then
        export BVKT_DEPTH="${depth}"
        return
    fi
    unset BVKT_DEPTH
}

