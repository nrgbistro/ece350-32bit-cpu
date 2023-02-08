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
## Bugs
- None as far as I can tell from testing
