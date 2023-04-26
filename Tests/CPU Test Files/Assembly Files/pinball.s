# Created by Nolan Gelinas and Ashley Hong
# 2023-24-04

# #led=$22: bottom 3 bits control LEDs, next 3 sets of 9 bits set the end time for each LED
# $lives=$23: number of lives remaining
# $score=$24: game score
# $btn=$25: button id (0 = not pressed, 1 = b1, 2 = b2, 3 = b3, 4 = b4)
# $mult=$26: score multiplier
# $prev=$27: previous 16 target ids
# $time=$28: number of seconds elapsed since power on


# Sets initial multiplier to 1 and lives to 3
addi $mult, $0, 1
addi $lives, $0, 3


# DEBUG - create a 5 second timer for LED 3
# addi $a0, $0, 5 # 5 second timer
# addi $a1, $0, 3 # for LED 3
# jal new_timer

# 5x mult timer for 8 seconds
addi $t0, $t0, 5
mul $mult, $mult, $t0
sw $t0, 0($sp)
addi $t0, $0, 8
sw $t0, 1($sp)
addi $sp, $sp, 3

# Main loop
main:
    seg $0, $time, 1
    seg $0, $mult, 0

    jal button_manager
    jal check_mult_timers
    jal check_led_timers

    j main



check_led_timers:
    addi $t0, $time, 0 # copy of current time
    sll $t0, $t0, 3 # shift to match duration location of led 1 timer

    # $t4: bitmask for selecting end time of timer (9 ones)
    addi $t4, $0, 511
    sll $t4, $t4, 3

    # $t6: bitmask for removing active timer (9 zeros)
    addi $t6, $0, -512
    sll $t6, $t6, 3
    addi $t6, $t6, 7 # pad bottom 3 bits with 1s

    and $t5, $t4, $led
    blt $t0, $t5, check_led_timers_skip_1
    bne $t5, $0, check_led_timers_turn_off_1
    j check_led_timers_skip_1

    check_led_timers_turn_off_1:
    # Turn off LED 1
    addi $t3, $0, -2 # bit mask to turn off led 1
    and $led, $led, $t3
    and $led, $led, $t6 # remove end time duration from led 1
    j check_led_timers_done

    check_led_timers_skip_1:
        sll $t0, $t0, 9 # shift to match duration location of led 2 timer
        # shift masks to match duration location of led 2 timer
        sll $t4, $t4, 9
        sll $t6, $t6, 9
        addi $t6, $t6, 511 # pad bottom 9 bits with 1s

        and $t5, $t4, $led
        blt $t0, $t5, check_led_timers_skip_2
        bne $t5, $0, check_led_timers_turn_off_2
        j check_led_timers_skip_2

        check_led_timers_turn_off_2:
        # Turn off LED 2
        addi $t3, $0, -3 # bit mask to turn off led 2
        and $led, $led, $t3
        and $led, $led, $t6 # remove end time duration from led 2
        j check_led_timers_done


    check_led_timers_skip_2:
        sll $t0, $t0, 9 # shift to match duration location of led 3 timer
        # shift masks to match duration location of led 3 timer
        sll $t4, $t4, 9
        sll $t6, $t6, 9
        addi $t6, $t6, 511 # pad bottom 9 bits with 1s

        and $t5, $t4, $led
        blt $t0, $t5, check_led_timers_done
        bne $t5, $0, check_led_timers_turn_off_3
        j check_led_timers_done

        check_led_timers_turn_off_3:
        # Turn off LED 3
        addi $t3, $0, -5 # bit mask to turn off led 3
        and $led, $led, $t3
        and $led, $led, $t6 # remove end time duration from led 3

    check_led_timers_done:
        jr $ra


# Checks all currently active multiplier timers and executes them if they have expired
# $t0: stack pointer iterator
# $t1: timer id
# $t2: target time
check_mult_timers:
    addi $t0, $sp, 0

    check_mult_timers_loop:
        addi $t3, $0, 2
        blt $t0, $t3, check_mult_timers_end

        addi $t0, $t0, -2
        lw $t1, 0($t0)
        lw $t2, 1($t0)

        # If the timer has not expired, skip it
        blt $time, $t2, check_mult_timers_loop_skip_removal
        # Ensure the timer id is not zero
        bne $t1, $0, check_mult_timers_remove_timer

        check_mult_timers_loop_skip_removal:
            j check_mult_timers_loop

        check_mult_timers_remove_timer:
            div $mult, $mult, $t1

            # Remove timer from stack
            sw $0, 0($t0)
            sw $0, 1($t0)

            j check_mult_timers_loop


    check_mult_timers_end:
        jr $ra


button_manager:
    addi $a0, $btn, 0
    bne $btn, $0, handle_button_press
    jr $ra


handle_button_press:
    sw $a0, 0($sp)
    addi $sp, $sp, 1
    jal save_hit
    addi $sp, $sp, -1
    lw $a0, 0($sp)
    jal get_button_value

    mul $t0, $mult, $v0
    add $score, $score, $t0

    j main


# Converts button id to score increment value
# input:  $a0: button id
# output: $v0: score increment value
#
# b1: 5 points
# b2: 10 points
# b3: 25 points
# b4: 50 points
get_button_value:
    # $t0 stores the desired button id
    # $t1 stores the actual button id
    addi $t1, $a0, 0

    sw $ra, 0($sp)
    addi $sp, $sp, 1

    get_button_value_begin:
        addi $t0, $0, 1
        bne $t1, $t0, not_b1

        # $btn == 1:

        # Create a new LED timer for 3 seconds
        addi $a0, $0, 3 # 3 second timer
        addi $a1, $0, 1 # LED1 timer
        jal new_timer

        addi $v0, $0, 1
        j reset_button

    not_b1:
        addi $t0 $0, 2
        bne $t1, $t0, not_b2

        # $btn == 2:

        # Create a new LED timer for 3 seconds
        addi $a0, $0, 3 # 3 second timer
        addi $a1, $0, 2 # LED2 timer
        jal new_timer

        addi $v0, $0, 10
        j reset_button

    not_b2:
        addi $t0 $0, 3
        bne $t1, $t0, not_b3

        # $btn == 3:
        # Create a new LED timer for 3 seconds
        addi $a0, $0, 3 # 3 second timer
        addi $a1, $0, 3 # LED3 timer
        jal new_timer

        addi $v0, $0, 25
        j reset_button

    not_b3:
        addi $t0 $0, 4
        bne $t1, $t0, not_b4

        # $btn == 4:
        # Create a new multiplier timer for 5 seconds
        addi $a0, $0, 5 # 5 second timer
        addi $a1, $0, 0 # MULT timer
        addi $a2, $0, 10 # multiplier value
        # jal new_timer

        addi $v0, $0, 0
        j reset_button

    not_b4:
        addi $v0, $0, 0

    reset_button:
        addi $btn, $0, 0
        addi $sp, $sp, -1
        lw $ra, 0($sp)
        jr $ra


# Writes a value to memory representing the target time for a new timer
# input:  $a0: timer length in seconds
#         $a1: timer type (0 = multiplier, 1 = LED1, 2 = LED2, 3 = LED3)
#         $a2: multiplier value (only used if $a1 == 0)
new_timer:
    add $a0, $a0, $time
    bne $a1, $0, new_timer_led

    # Sets the top bit of the timer id to 1, signifying a multiplier timer
    # Example timer id with multiplier of 4: 32'b10000...100
    new_timer_multiplier:
        mul $mult, $mult, $a2

        # write timer id and target time to memory
        sw $a2, 0($sp)
        sw $a0, 1($sp)
        addi $sp, $sp, 2

        j new_timer_done

    new_timer_led:
        # $t3: bitmask for setting which LED to turn on
        addi $t3, $0, 1

        # shift duration to match led 1 end time location
        sll $a0, $a0, 3

        addi $t2, $0, 1
        bne $a1, $t2, new_timer_led_not_1

        # Turn on LED 1
        or $led, $led, $t3
        or $led, $led, $a0
        j new_timer_done

        new_timer_led_not_1:

        sll $t3, $t3, 1
        sll $a0, $a0, 9
        addi $t2, $0, 2
        bne $a1, $t2, new_timer_led_not_2

        # Turn on LED 2
        or $led, $led, $t3
        or $led, $led, $a0
        j new_timer_done

        new_timer_led_not_2:

            # Turn on LED 3
            sll $t3, $t3, 1
            sll $a0, $a0, 9
            or $led, $led, $t3
            or $led, $led, $a0

    new_timer_done:
        jr $ra


# Appends most recent hit to the LSBs
# Only called when a button is hit
# input: $a0: button id
save_hit:
    sll $prev, $prev, 2
    add $prev, $prev, $a0
    sw $ra, 0($sp)
    addi $sp, $sp, 1
    jal check_patterns
    addi $sp, $sp, -1
    lw $ra, 0($sp)
    jr $ra


# Reads each 2-bit button id in $prev and executes commands if a pattern is detected
# No inputs or outputs (output goes directly into $mult reg via new_timer)
check_patterns:
    jr $ra


# input: $a0: button id
#        $a1: number of previous hits to check
# output: $v0: number of button id hits in prev
count_previous_hits:
    addi $t0, $0, 0 # match counter
    addi $t1, $0, 0 # loop counter
    addi $t2, $0, 3 # bit mask

    addi $t3, $a1, -1 # loop guard

    count_previous_hits_loop:
        blt $t3, $t1, count_previous_hits_end # $a1 - 1 < loop counter
        and $t4, $t2, $prev # get current bits
        bne $a0, $t4, count_previous_hits_restart_loop # if button id != current bits, don't add to match counter

        addi $t0, $t0, 1 # increment match counter

    count_previous_hits_restart_loop:
        sll $t2, $t2, 2 # move bit mask
        sll $a0, $a0, 2 # move button id
        addi $t1, $t1, 1 # increment loop counter
        j count_previous_hits_loop

    count_previous_hits_end:
        addi $v0, $t0, 0
        jr $ra


reset_game:
    addi $mult, $0, 1
    addi $score, $0, 0
    addi $time, $0, 0
    addi $led, $0, 0
    addi $prev, $0, 0
    addi $sp, $0, 0
    j main
