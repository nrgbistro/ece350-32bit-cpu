# Created by Nolan Gelinas
# 2023-15-04

# $score=$24 is the game score
# $btn=$25 is the button (0 = not pressed, 1 = b1, 2 = b2, 3 = b3, 4 = b4)
# $mult=$26 is the score multiplier

addi $mult, $0, 3

# Main loop
main:
    seg $0, $score, 0
    bne $btn, $0, handle_button_press

    j main


# Handles button press
handle_button_press:
    add $a0, $btn, $0
    jal get_button_value

    # Multiply score increment value from get_button_value by multiplier
    mul $t0, $mult, $v0
    add $score, $score, $t0
    jal reset_button
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
    # If $a0 == 1
    addi $t0, $0, 2
    blt $a0, $t0, b1_pressed

    # If $a0 == 2
    addi $t0, $0, 3
    blt $a0, $t0, b2_pressed

    # If $a0 == 3
    addi $t0, $0, 4
    blt $a0, $t0, b3_pressed

    # If $a0 == 4
    addi $t0, $0, 5
    blt $a0, $t0, b4_pressed

    # Default case
    addi $v0, $0, 17
    jr $ra

    b1_pressed:
        addi $v0, $0, 5
        jr $ra

    b2_pressed:
        addi $v0, $0, 10
        jr $ra

    b3_pressed:
        addi $v0, $0, 25
        jr $ra

    b4_pressed:
        addi $v0, $0, 50
        jr $ra

reset_button:
    addi $btn, $0, 0
    jr $ra
