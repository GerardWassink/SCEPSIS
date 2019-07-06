
# SCEPSIS

## Components

A computer is built up from components. The major ones are described below.

### Emulated hardware

To build a computer we need components:

- **CPU** - Central Processing Unit
- **INP** - means to input stuff
- **OUT** - some way of outputting things
- **MEM** - Memory
- **DAB** - Data / Address Bus, a way to transport data back and forth

### Components inside the actual CPU

Further down, **inside** the CPU we have components as well:

- **PCT** - Program CounTer
- **INR** - INstruction Register
- **STC** - STep Counter for microcode steps
- **INP** - INPut Register
- **OUT** - OUTput Register
- **ALU** - Arithmetic Logical Unit
- **MAR** - Memory Address Register
- **RGA** - ReGister A
- **RGB** - ReGister B

Furthermore, we need something to let the CPU 'tick' (a clock pulse) and something to decode our instructions (usually called the 'Control Unit'.

- **CLK** - A CLocK pulse generator, advancing a setp at a time
- **CTU** - ConTrol Unit, translating the instruction to steps

### Communication

For these components to be able to exchange information we need a 'transport mechanism'. In computer terms such a mechanism is often called a 'bus'. Bus is a fancy way in computer tech speak to indicate a number of signals combined in one 'bundle of wires'. In complex computers there's more than one bus. As you can see above, in our simple computer we will use a ***combined data / address bus and call it DAB***.

### Further reading

- [README file for SCEPSIS](../README.md)
- [Components of the SCEPSIS CPU](./Components.md)
- [Diagram of SCEPSIS components](../gfx/SCEPSIS Components.JPG)
- [Control signals in the SCEPSIS CPU](./ControlSignals.md)
- [Example instruction for the SCEPSIS CPU](./Example.md)
- [ALU instructions for the SCEPSIS CPU](./ALUinstructions.md)

