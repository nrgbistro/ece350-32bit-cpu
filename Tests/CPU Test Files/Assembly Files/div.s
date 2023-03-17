nop # Basic Div Test No hazards
nop # Values initialized using addi (positive only)
nop # Author: Nolan Gelinas
nop
nop
nop
addi $r1, $r0, 5
addi $r2, $r0, 10
addi $r3, $r0, 50
nop
nop
nop
nop
div $r5, $r2, $r1
nop
nop
nop
nop
nop
div $r6, $r3, $r2
