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

## Stalling

## Optimizations
## Bugs
- I had an issue with the overflow of the multiplier when the operands were -32768 and 65536. The overflow should have been 0 but 1 was outputted. I could not figure out why this was because result is correct but in order to fix this issue I have a special module that will detect when these inputs are passed to ensure that the overflow bit stays 0.
