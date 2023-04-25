# Created by Nolan Gelinas and Ashley Hong
# 2023-24-04

# #led=$22: LED control
# $lives=$23: number of lives remaining
# $score=$24: game score
# $btn=$25: button id (0 = not pressed, 1 = b1, 2 = b2, 3 = b3, 4 = b4)
# $mult=$26: score multiplier
# $prev=$27: previous 16 target ids
# $time=$28: number of seconds elapsed since power on


# Sets initial multiplier to 1 and lives to 3
addi $mult, $0, 1
addi $lives, $0, 3


# DEBUG - create a new 5x multiplier timer for 8 seconds
addi $t0, $0, 1
sll $t0, $t0, 31
addi $t0, $t0, 5
sw $t0, 0($0)
addi $t0, $0, 8
sw $t0, 1($0)
addi $sp, $sp, 2

mul $mult, $mult, 5


# Main loop
main:
    seg $0, $time, 1
    seg $0, $mult, 0

    # jal button_manager
    jal check_timers

    j main

# Checks all currently active timers and executes them if they have expired
# $t0: stack pointer iterator
# $t1: timer id
# $t2: target time
check_timers:
    addi $t0, $sp, 0
    sw $ra, 0($sp)
    addi $sp, $sp, 1

    check_timers_loop:
        addi $t3, $0, 2
        blt $t0, $t3, check_timers_end

        addi $t0, $t0, -2
        lw $t1, 0($t0)
        lw $t2, 1($t0)

        # If the timer has not expired, skip it
        blt $time, $t2, check_timers_loop_skip_removal
        # Ensure the timer id is not zero
        bne $t1, $0, check_timers_remove_timer

        check_timers_loop_skip_removal:
            j check_timers_loop

        check_timers_remove_timer:
            sw $t0, 0($sp)
            sw $t1, 1($sp)
            sw $t2, 2($sp)
            sw $ra, 3($sp)
            addi $sp, $sp, 4
            addi $a0, $t0, 0
            addi $a1, $t1, 0
            jal execute_timer
            addi $sp, $sp, -4
            lw $t0, 0($sp)
            lw $t1, 1($sp)
            lw $t2, 2($sp)
            lw $ra, 3($sp)

            j check_timers_loop


    check_timers_end:
        addi $sp, $sp, -1
        lw $ra, 0($sp)
        jr $ra


# input: $a0: stack pointer of timer
#        $a1: timer id
execute_timer:
    sw $ra, 0($sp)
    sw $a0, 1($sp)
    sw $a1, 2($sp)
    addi $sp, $sp, 3
    addi $a0, $a1, 0
    jal get_timer_type
    addi $sp, $sp, -3
    lw $ra, 0($sp)
    lw $a0, 1($sp)
    lw $a1, 2($sp)

    bne $v0, $0, execute_timer_led

    # execute timer action
    execute_timer_multiplier:
        sll $a1, $a1, 1
        sra $a1, $a1, 1
        div $mult, $mult, $a1
        j execute_timer_end


    # execute timer action
    execute_timer_led:
        addi $t0, $0, 1
        bne $a1, $t0, execute_timer_led_not_1

        # Turn off LED 1
        addi $t5, $0, -2
        and $led, $led, $t5

        execute_timer_led_not_1:

        addi $t0, $0, 2
        bne $a1, $t0, execute_timer_led_not_2

        # Turn off LED 2
        addi $t5, $0, -3
        and $led, $led, $t5

        execute_timer_led_not_2:

        # Turn off LED 3
        addi $t5, $0, -5
        and $led, $led, $t5

    # clear timer from memory
    execute_timer_end:
        jr $ra

# input: $a0: timer id
# output: $v0: 0 if timer id is a multiplier timer, 1 otherwise
get_timer_type:
    addi $t0, $0, 1
    sll $t0, $t0, 31
    and $t0, $a0, $t0
    sra $t0, $t0, 31

    # $t0 is either 0 (led) or -1 (multiplier)
    bne $t0, $0, get_timer_type_multiplier

    get_timer_type_led:
        addi $v0, $0, 1
        jr $ra

    get_timer_type_multiplier:
        addi $v0, $0, 0
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

    # jal parse_previous_hits

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

        # Create a new LED timer for 2 seconds
        addi $a0, $0, 2 # 2 second timer
        addi $a1, $0, 1 # LED1 timer
        # jal new_timer

        addi $v0, $0, 1
        j reset_button

    not_b1:
        addi $t0 $0, 2
        bne $t1, $t0, not_b2

        # $btn == 2:

        # Create a new LED timer for 2 seconds
        addi $a0, $0, 2 # 2 second timer
        addi $a1, $0, 2 # LED2 timer
        # jal new_timer

        addi $v0, $0, 10
        j reset_button

    not_b2:
        addi $t0 $0, 3
        bne $t1, $t0, not_b3

        # $btn == 3:
        # Create a new LED timer for 2 seconds
        addi $a0, $0, 2 # 2 second timer
        addi $a1, $0, 3 # LED3 timer
        # jal new_timer

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
        # $t0: bitmask for setting top bit of timer id to 1
        # $t1: timer id
        addi $t0, $0, 1
        sll $t0, $t0, 31
        or $a2, $t0, $a2

        # write timer id and target time to memory
        sw $a2, 0($sp)
        sw $a0, 1($sp)
        addi $sp, $sp, 2


        j new_timer_done

    # Example timer id with LED1: 32'b00000...001
    new_timer_led:
        sw $a1, 0($sp)
        sw $a0, 1($sp)
        addi $sp, $sp, 2

        addi $t3, $0, 1

        addi $t2, $0, 1
        bne $a1, $t2, new_timer_led_not_1

        # Turn on LED 1
        or $led, $led, $t3
        j new_timer_done

        new_timer_led_not_1:

        addi $t2, $0, 2
        bne $a1, $t2, new_timer_led_not_2

        # Turn on LED 2
        sll $t3, $t3, 1
        or $led, $led, $t3
        j new_timer_done

        new_timer_led_not_2:

        # Turn on LED 3
        sll $t3, $t3, 1
        or $led, $led, $t3

    new_timer_done:
        jr $ra


# Appends most recent hit to the LSBs
# Only called when a button is hit
# input: $a0: button id
save_hit:
    sll $prev, $prev, 2
    add $prev, $prev, $a0
    jr $ra


# Reads each bit in $prev and executes commands if a pattern is detected
parse_previous_hits:
    # $t0 holds loop counter
    addi $t0, $0, 0

    loop_over_hits:
        sw $t0, 0($sp)
        addi $sp, $sp, 1
        addi $t0, $t0, 1

        # load bit mask correspondingg to current loop count intput $a0
        jal get_individual_hit
        add $t2, $t0, $v0 # current hit
        addi $sp, $sp, 1
        sw $t2, 0($sp)
        lw $t0, 4($sp)
        addi $t3, $0, 16
        addi $sp, $sp, -1
        bne $t0, $t3, loop_over_hits

# $t0 is copy of prev
# $t1 is lower bound
# $t2 is upper bound
detect_patterns:
    add $t0, $0, $prev

    triple_hit:

    # inputs: $a0: bit mask with 2 1-bits
    get_individual_hit:
        add $t0, $0, $a0
        and $v0, $prev, $t0


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
