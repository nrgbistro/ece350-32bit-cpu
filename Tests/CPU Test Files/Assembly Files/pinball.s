# Created by Nolan Gelinas
# 2023-15-04

# $score=$24 is the game score
# $btn=$25 is the button (0 = not pressed, 1 = b1, 2 = b2, 3 = b3, 4 = b4)
# $mult=$26 is the score multiplier

addi $mult, $0, 1

# Main loop
main:
    seg $0, $score, 0
    addi $t5 $0, 420
    seg $0, $t5, 1
    bne $btn, $0, handle_button_press

    j main


# Handles button press
handle_button_press:
    addi $a0, $btn, 0
    jal get_button_value

    # Multiply score increment value from get_button_value by multiplier
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

    get_button_value_begin:
        addi $t0, $0, 1
        bne $t1, $t0, not_b1

        # $btn == 1:
        addi $v0, $0, 5
        j reset_button

    not_b1:
        addi $t0 $0, 2
        bne $t1, $t0, not_b2

        # $btn == 2:
        addi $v0, $0, 10
        j reset_button

    not_b2:
        addi $t0 $0, 3
        bne $t1, $t0, not_b3

        # $btn == 3:
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
