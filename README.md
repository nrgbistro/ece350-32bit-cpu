# ALU
## Nolan Gelinas

## Description of Design
- ALU
  - Adder
    - I combined 8 1-bit full adders together and modified it to output P and G instead of carry out
    - I also created a CLA module which takes in an 8-bit bus of P's and G's and outputs 8-bit C values as well as GG and PG
    - I combined 4 of these 8-bit carry lookahead adders and connected them using the calculated GG and PG for each set of 8 bits
    - I also created a 2's compliment module to assist with subtraction
      - There were some edge cases for subtraction with the overflow bit where I can to calculate when the two's compliment would overflow. I used a 1-bit mux to get around this
  - and/or
    - This module is where I learned how to use genvar
    - I used a for loop that iterates 32 times which creates 32 and/or gates
  - Shifter
    - Bit shifting was relatively easy, I simply took the top or bottom n bits and put them on a wire, then set the reminaing bits on that wire accordingly
    - Each shifter has a mux built in that can be activated by a 1 bit selector
    - I chained each of my barrel shifters together directly and split up the 5-bit shift amount to each shifter
  - Comparator
    - I used the comparator we created in lab and modified it to less than instead of greater than
    - I left equals as is and simply notted the value before I passed it to the alu output
- Multiplier
  - Counter
    - I implemented the counter like we did in class using t flip flops. I expected to only need a 4 bit counter for modified booth's algorithm but I ended up needing a 5 bit counter because I needed to count up to 16 cycles to generate the correct answer.
  - Special modules
    - I needed to make a 65 bit register to hold my product.
    - I also needed to make a 4 bit mux that takes in 65 bits of data. In order to create this module I also needed a 2 bit mux that takes in 65 bits of data.
    - I detect resets when mult or div is enabled. This works for the current checkpoint but may need to be modified to implement division
    - The special case checker module was also needed to ensure the overflow bit was correct when the operands were -32768 and 65536. This is the only case of incorrect overflow I could find.

## Bypassing
- I was able to get bypassing working for most instructions where the value being read from memory was being or going to be updated in the memory or writeback stages.
- The most difficult part of the bypassing logic was checking the correct parts of the intruction for its instruction type. I used a 2 bit mux to select the correct part of the instruction to check for the instruction type, which changed the values being compared to rd for i type instructions.
- I used a 2 bit wire to select where to bypass from. 1x means do not bypass, 00 means bypass from memory, 01 means bypass from writeback.
  - These values are calculated inside my Bypass module and used in the processor module.
- dmem bypassing was very simple to implement, I only had to check if the memory RD was the same as the writeback RD.
## Stalling
- There were many bugs that I ran into while debugging sort.s that I could not figure out how to bypass. I ended up having to implement stalling for the following instruction sequences:
  - Load:
    - lw $A, 0($B)
    - add $A, $A, $C
  - Jump Return:
    - lw $A, 0($B)
    - jr $A
  - Save:
    - sw $A, 0($B)
    - sw $C, 0($A)
- In order to stall, I had a wire for each stage in the pipeline that would be set to 1 if the stage was stalled. These wires were notted inside the module and disabled the write for that set of registers.
- I also needed to stall the entire processor whenever a mult or div instruction got to the execute stage. I did not implement a separate pipeline stage for multdiv, I instead used the inputs for the ALU and selected the output from multdiv when it was complete to send to the next stage.

## Optimizations
- I optimized my hardware cost by using as few additional adders as possible. I had one in my ALU, one for PC + 1, and one to calculate branch addresses.
- Further optimizations could likely be made by reducing the amount of stalling that occurs, but I was not able to get this working in time for the deadline.
- Another optimization I thought of would be allowing non-conflicting instructions to pass through a multdiv operation. This would require a separate pipeline latch and would likely be more difficult to implement due to the complexity of detecting conflicts during a multi-cycle operation.
## Bugs
- I had an issue with the overflow of the multiplier when the operands were -32768 and 65536. The overflow should have been 0 but 1 was outputted. I could not figure out why this was because result is correct but in order to fix this issue I have a special module that will detect when these inputs are passed to ensure that the overflow bit stays 0.
