
# SCEPSIS

## Language definition

As we have seen, we can define instructions as a combination of subsequent steps in which various [components](./Components.md) of the CPU are ordered to do things and work together. We do that by activating [Control Signals](./ControlSignals.md). We have also seen an [example](./Example.md) of how this could be done.

The instructions for SCEPSIS are defined in a language definition file. In the [scepsis.conf file](../source/config/scepsis.conf) you can tell the program which language definition you would like to use, so you can make several definition files for yourself.

Now let's have a look at the syntax of this language definition.

### Comments

All lines that are empty or start with a hash sign ('#') are considered to be commants and will be discarded.

### Definition lines

All other lines are treated as language definition lines. Every definition line consists of three or four parts:

- OpCode
- Mnemonic
- Microcode steps
- comment

#### Syntax of the line

OpCode Mnemonic [operand] | microcodestep - microcodestep [...] [# comment]

#### OpCode
The opcode is a hexadecimal number from x00 to xFF, uniquely identifying the instruction when it is encountered in memory. This is the value you will have to enter into memory when programming SCEPSIS.

#### Mnemonic
A more or less recognisable acronim for your instruction, for example I2M, which we saw as an example, meaning '*Input To Memory*'.

#### Operand
Operand is a placeholder for documentary purposes, just an indication that there must be an operand when coding this instruction.

#### Microcode step
Microcodestep is a combination of two or more control signals. Each microcode step is seperated from the next one by a dash (minus sign). As you can see in the example below (that [we used earlier](./Example.md)) We see:

- OpCode is 30 (hexadecimal)
- Mnemonic is 'I2M'
- Microcode steps are
  * PCTO MARI 
  * MEMO INRI CE 
  * PCTO MARI 
  * MEMO MARI 
  * INPO MEMI CE

So the resulting definition would look something like:

<pre>
#
# I2M {address} - put the value from the INP register into memory location {address]
30 I2M PCTO MARI - MEMO INRI CE - PCTO MARI - MEMO MARI - INPO MEMI CE # Input to Memory
</pre>



### Further reading

- [README file for SCEPSIS](../README.md)
- [Components of the SCEPSIS CPU](./Components.md)
- [Diagram of SCEPSIS components](../gfx/SCEPSIS_Components.JPG)
- [Control signals in the SCEPSIS CPU](./ControlSignals.md)
- [Example instruction for the SCEPSIS CPU](./Example.md)
- [Language definition for the SCEPSIS CPU](./Langdef.md)
- [ALU instructions for the SCEPSIS CPU](./ALUinstructions.md)

