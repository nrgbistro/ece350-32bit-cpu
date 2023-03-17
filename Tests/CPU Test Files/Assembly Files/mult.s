nop # Basic Mult Test No hazards
nop # Values initialized using addi (positive only)
nop # Author: Nolan Gelinas
nop
nop
nop
addi $r1, $r0, 5
addi $r2, $r0, 5
nop
nop
nop
nop
mul $r3, $r1, $r2
nop
nop
nop
nop
nop
mul $r4, $r1, $r3
addi $r10, $r0, -10
nop
nop
nop
nop
mul $r11, $r10, $r4
