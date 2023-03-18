nop
nop
addi $5, $0, 1
addi $6, $0, 1
blt $5, $6, 5   # not taken
addi $5, $0, 3
addi $6, $0, 4
blt $5, $6, 5   # taken
addi $5, $0, 5
addi $6, $0, 6
