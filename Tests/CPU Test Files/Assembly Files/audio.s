main:
    seg $0, $time, 1
    seg $0, $audio, 0

    jal button_manager

    j main


button_manager:
    addi $a0, $btn, 0
    bne $btn, $0, handle_button_press
    jr $ra

handle_button_press:
    jal get_button_value
    j main


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

        addi $audio, $0, 0
        j reset_button

    not_b1:
        addi $t0 $0, 2
        bne $t1, $t0, not_b2

        # $btn == 2:

        addi $audio, $audio, 1
        j reset_button

    not_b2:
        addi $t0 $0, 3
        bne $t1, $t0, not_b3

        # $btn == 3:
        addi $audio, $audio, 2
        j reset_button

    not_b3:
        addi $t0 $0, 4
        bne $t1, $t0, not_b4

        # $btn == 4:
        j reset_button

    not_b4:
        addi $v0, $0, 0

    reset_button:
        addi $btn, $0, 0
        addi $sp, $sp, -1
        lw $ra, 0($sp)
        jr $ra
