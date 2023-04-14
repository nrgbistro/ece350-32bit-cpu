# Created by Nolan Gelinas
# 2023-09-04

# $r2 is the game score
# $r3 is the button (0 = not pressed, 1 = b1, 2 = b2, 3 = b3, 4 = b4)
# $r4 is the score multiplier
# $r5 is the score increment value
# $r6 is the score increment value after multiplier

addi $r4, $r0, 1
addi $r5, $r0, 1

# Main loop
main:
    # seg $0, $r2, 0
    # bne $r3, $r0, button_press

    j main


# Handles button press
button_press:
    # Apply score multiplier
    mul $r6, $r4, $r5
    # Add score increment to score
    add $r2, $r2, $r6
    # Reset button
    addi $r3, $r0, 0
    j main
