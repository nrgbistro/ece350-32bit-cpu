# Created by Nolan Gelinas and Ashley Hong
# 2023-24-04

# $score=$24: game score
# $btn=$25: button id (0 = not pressed, 1 = b1, 2 = b2, 3 = b3, 4 = b4)
# $mult=$26: score multiplier
# $prev=$27: previous 16 target ids
# $time=$28: number of seconds elapsed since power on
#
# last word of memory controls LEDs

# Sets initial multiplier to 1
addi $mult, $0, 1


# Main loop
main:
    seg $0, $score, 1
    seg $0, $time, 0
    bne $btn, $0, handle_button_press

    jal check_timers

    j main


handle_button_press:
    addi $a0, $btn, 0
    jal save_hit
    addi $a0, $btn, 0
    jal get_button_value
    # Multiply score increment value from get_button_value by multiplier
    mul $t0, $mult, $v0
    add $score, $score, $t0

    jal parse_previous_hits

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

    get_button_value_begin:
        addi $t0, $0, 1
        bne $t1, $t0, not_b1

        # $btn == 1:

        # Create a new LED timer for 2 seconds
        addi $a0, $0, 2 # 2 second timer
        addi $a1, $0, 1 # LED1 timer
        jal new_timer

        addi $v0, $0, 1
        j reset_button

    not_b1:
        addi $t0 $0, 2
        bne $t1, $t0, not_b2

        # $btn == 2:

        # Create a new LED timer for 2 seconds
        addi $a0, $0, 2 # 2 second timer
        addi $a1, $0, 2 # LED2 timer
        jal new_timer

        addi $v0, $0, 10
        j reset_button

    not_b2:
        addi $t0 $0, 3
        bne $t1, $t0, not_b3

        # $btn == 3:
        # Create a new LED timer for 2 seconds
        addi $a0, $0, 2 # 2 second timer
        addi $a1, $0, 3 # LED3 timer
        jal new_timer

        addi $v0, $0, 25
        j reset_button

    not_b3:
        addi $t0 $0, 4
        bne $t1, $t0, not_b4

        # $btn == 4:
        addi $v0, $0, 50
        j reset_button

    not_b4:
        addi $v0, $0, 0
        j reset_button

    reset_button:
        addi $btn, $0, 0
        jr $ra


# Checks all currently active timers, removes and executes them if they have expired
# $s0: copy of stack pointer
check_timers:
    addi $s0, $sp, 0

    check_timers_loop:



    blt $sp, $t0, check_timers_loop_end

    check_timers_loop_end:
        addi $sp, $s0, 0
        jr $ra



# Writes a value to memory representing the target time for a new timer
# input:  $a0: timer length in seconds
#         $a1: timer type (0 = multiplier, 1 = LED1, 2 = LED2, 3 = LED3)
#         $a2: multiplier value (only used if $a1 == 0)
new_timer:
    add $a0 $a0, $time
    bne $a1, $0, new_timer_led

    # Sets the top bit of the timer id to 1, signifying a multiplier timer
    # Example timer id with multiplier of 4: 32'b10000...100
    new_timer_multiplier:
        # $t0: bitmask for setting top bit of timer id to 1
        # $t1: timer id
        addi $t0, $0, 2147483648
        or $t1, $t0, $a2

        # write timer id and target time to memory
        addi $sp, $sp, 2
        sw $t1, 0($sp)
        sw $a0, 1($sp)

        j new_timer_done

    # Example timer id with LED1: 32'b00000...001
    new_timer_led:
        addi $sp, $sp, 2
        sw $a1, 0($sp)
        sw $a0, 1($sp)

    new_timer_done:
        jr $ra


# Appends most recent hit to the LSBs
# Only called when a button is hit
save_hit:
    sll $prev, $prev, 2
    add $prev, $prev, $a0
    jr $ra


# Reads each bit in $prev and executes commands if a pattern is detected
parse_previous_hits:
    # $t0 holds loop counter
    addi $t0, $0, 0

    loop_over_hits:
        addi $sp, $sp, 1
        addi $t0, $t0, 1
        sw $t0, 0($sp)

        # load bit mask correspondingg to current loop count intput $a0
        jal get_individual_hit
        addi $t2, $t0, $v0 # current hit
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











