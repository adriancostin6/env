_init_omp_last() {
    exec_if oh-my-posh init bash --config "$XDG_CONFIG_HOME/oh-my-posh/.adrianc.omp.json"
    trap - USR2
}
add_trap '_init_omp_last' USR2
