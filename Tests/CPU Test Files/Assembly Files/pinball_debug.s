addi $mult, $0, 1

# 3x mult timer for 8 seconds
addi $t0, $0, 3
sw $t0, 0($0)
addi $t1, $0, 8
sw $t1, 1($0)
addi $sp, $sp, 2

mul $mult, $mult, $t0

# Main loop
main:
    seg $0, $time, 1
    seg $0, $mult, 0

    j check_mult_timers

    lw $s0, 0($0) # Sanity check
    lw $s1, 1($0) # Sanity check

    j main

check_mult_timers:
    addi $t0, $sp, 0
    addi $s4, $ra, 0 # Sanity check

    check_mult_timers_loop:
        addi $t3, $0, 2
        blt $t0, $t3, main

        nop
        nop
        addi $t0, $t0, -2
        lw $t1, 0($t0)
        lw $t2, 1($t0)

        # If the timer has not expired, skip it
        blt $time, $t2, check_mult_timers_loop_skip_removal
        # Ensure the timer multiplier is not zero
        bne $t1, $0, check_mult_timers_remove_timer

        check_mult_timers_loop_skip_removal:
            j check_mult_timers_loop

        check_mult_timers_remove_timer:
            nop
            nop
            nop
            div $mult, $mult, $t1
            nop
            nop
            nop

            # Remove timer from stack
            sw $0, 0($t0)
            sw $0, 1($t0)

            j check_mult_timers_loop
