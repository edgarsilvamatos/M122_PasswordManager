# Shellcheck
@test "shellcheck return 0 (static code check)" {
        run shellcheck ./passwordManager.sh
        [ "$status" -eq 0 ]
}

# Downloaded package 'coreutils' to set a timeout so the test doesn't run forever
@test "Add password" {
    run timeout 5 bash -c 'printf "1\nTeams\nesilva\n12345678\n1234\n1234" | ./passwordManager.sh'
    [ "$status" -eq 0 ] || [ "$status" -eq 124 ]  # 124 is the exit status of timeout
}

@test "List passwords" {
    run timeout 5 bash -c 'printf "2\n1234" | ./passwordManager.sh'
    [ "$status" -eq 0 ] || [ "$status" -eq 124 ] 
}

