# SCEPSIS

## Simple CPU Emulator Program (Student Instruction System)

### Purpose

Educating people into the concepts of low-level computing, by emulating a simple CPU. The properties of this CPU will be:

- 8 bits
- ability to define microcode
- thus being able to create one's own instruction set
- combined data- and address bus

### Background

For a bit more background read this [page about the "von Neumann machine"](https://geronimo370.nl/computers/theory/the-von-neumann-machine/). It describes the famous '**fetch - decode - get data - execute**' cycle

## To be done:

### Decide on the hardware components to be emulated

To build a computer we need components:

- **CPU** - Central Processing Unit
- **RAM** - Memory
- **INP** - means to input stuff
- **OUT** - some way of outputting things
- **CNB** - CoNtrol Bus, means of control the different components
- **DAB** - DAta Bus, a way to transport data back and forth

### Inside the actual CPU

Further down, inside the CPU we have components as well:

- **CLK** - A CLocK pulse generator
- **PCT** - Program CounTer
- **INR** - INstruction Register
- **ALU** - Arithmetic Logical Unit
- **RGA** - ReGister A
- **RGB** - ReGister B
- **MAR** - Memory Address Register
- **CTU** - ConTrol Unit


## Control signals that are needed for these components

Every component in a CPU has functions, al of which can be controlled by control signals; all these control signals together form the 'control bus'. Bus is a fancy way in computer tech speak to indicate a number of signals combined in one 'bundle of wires'. [For an example of control signals look here](https://geronimo370.nl/wp-content/uploads/2019/05/Microcode_control_signals.pdf "Example of Control Signals").

- **CE** - Counter Enable, the program counter advances to the next instruction
- **INRI** - Set the instruction register to input, to take a value from the DAB
- **INRO** - Set the instruction register to output, put its on the DAB
- **PCTI** - Set the Program Counter to input, getting a value from the DAB
- **PCTO** - Set the Program Counter to output, put it's value to the DAB
- **RGAI** - Set RGA to input, accept a value from the DAB
- **RGAO** - Set RGA to output, put its value out to the DAB
- **RGBI** - Set RGA to input, accept a value from the DAB
- **RGBO** - Set RGA to output, put its value out to the DAB
- **MARI** - Set the MAR to input, accept an address from the DAB
- **MARO** - Set the MAR to output, put it out to the DAB
- **RAMI** - Set memory, pointed to by MAR to input, getting the value from the DAB
- **RAMO** - Set memory, pointed to by MAR to output, put value on the DAB
- ...


## Instructions as a combination of Control Signals

Now that all Control Signals have been defined we can think of ways to combine them to have the computer do what we want it to do.

### An example

The first thing for every instruction is that we have to ***fetch*** the actual instruction from memory. As we shall see this incorporates the use of several Control Signals in subsequent microcode steps:

#### The fetch phase

The fetch phase is exactly the same for every instruction. This is the combination of Control Signals for the fetch phase:

##### microcode for the fetch phase

- Clock Cycle 1 - PCTO + MARI - *put the value of the PCT in the MAR*
- Clock Cycle 2 - RAMO + INRI + CE - *put the value out of memory into the INR and bump the PCT up by 1*

Now, after two clock ticks, we have read the value out of memory (pointed to by the Program Counter), that is the value of the next instruction, into the Instruction Register from where it can be decoded; lastly, we had the PCT point to the next instruction.


