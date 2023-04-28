addi $mult, $0, 1

# +2 mult timer for 3 seconds
addi $t0, $0, 2
sw $t0, 0($0)
addi $t1, $0, 3
sw $t1, 1($0)
addi $sp, $sp, 2

add $mult, $mult, $t0

# Main loop
main:
    seg $0, $time, 1
    seg $0, $mult, 0

    jal check_mult_timers

    lw $s0, 0($0) # Sanity check
    lw $s1, 1($0) # Sanity check

    j main

check_mult_timers:
    addi $t0, $sp, 0
    addi $s4, $ra, 0 # Sanity check

    check_mult_timers_loop:
        addi $t3, $0, 2
        blt $t0, $t3, check_mult_timers_loop_end

        nop
        nop
        addi $t0, $t0, -2
        lw $t1, 0($t0)
        lw $t2, 1($t0)

        # If the timer has not expired, skip it
        blt $time, $t2, check_mult_timers_loop_skip_removal
        # Ensure the timer multiplier is not zero
        bne $t1, $0, check_mult_timers_remove_timer

        nop
        nop
        nop

        check_mult_timers_loop_skip_removal:
            j check_mult_timers_loop

        check_mult_timers_remove_timer:

            sub $mult, $mult, $t1

            # Remove timer from stack
            sw $0, 0($t0)
            sw $0, 1($t0)

            nop
            nop
            nop

            j check_mult_timers_loop
    check_mult_timers_loop_end:
        addi $t6, $ra, 0 # Sanity check
        jr $ra
