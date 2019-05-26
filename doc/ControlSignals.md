
# SCEPSIS

## Control signals that are needed for the components

Every component in a CPU has functions, al of which can be controlled by control signals.

### Example: copy A to B
For example, the A register can be instructed to put it's value onto the databus (DAB) by activating the RGAO coontrol signal. If in the same clock cycle (microcode step) we instruct the B register to read it's content from the DAB, the result for that clock cycle is that we have made a copy from the A register content into the B register.

### List of control signals in SCEPSIS

- **CE** - Counter Enable, the program counter advances to the next instruction
- **HLT** - stop (or HALT) the processor
- **INPO** - Set the input register to output, put its on the DAB
- **INRI** - Set the instruction register to input, to take a value from the DAB
- **INRO** - Set the instruction register to output, put its on the DAB
- **MARI** - Set the MAR to input, accept an address from the DAB
- **MARO** - Set the MAR to output, put it out to the DAB
- **OUTI** - Set the output register to input, getting a value from the DAB
- **PCTI** - Set the Program Counter to input, getting a value from the DAB
- **PCTO** - Set the Program Counter to output, put it's value to the DAB
- **MEMI** - Set memory, pointed to by MAR to input, getting the value from the DAB
- **MEMO** - Set memory, pointed to by MAR to output, put value on the DAB
- **RGAI** - Set RGA to input, accept a value from the DAB
- **RGAO** - Set RGA to output, put its value out to the DAB
- **RGBI** - Set RGA to input, accept a value from the DAB
- **RGBO** - Set RGA to output, put its value out to the DAB
- ...

