# Created by Nolan Gelinas
# 2023-09-04

# $score is the game score
# $btn is the button (0 = not pressed, 1 = b1, 2 = b2, 3 = b3, 4 = b4)
# $s0=$mult is the score multiplier
# $t0 is the score increment value
# $t1 is the score increment value after multiplier

addi $s0, $r0, 1
addi $t0, $r0, 1

# Main loop
main:
    # seg $0, $score, 0
    # bne $btn, $r0, button_press

    j main


# Handles button press
button_press:
    mul $t1, $s0, $t0
    add $score, $score, $t1
    jal reset_button
    j main

get_button_value:


reset_button:
    addi $r3, $r0, 0
    jr $ra
