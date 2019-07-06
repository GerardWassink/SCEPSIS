
# SCEPSIS and SCEPSASM
There are two main programs in this respository, SCEPSIS and SCEPSASM.

## SCEPSIS - Simple CPU Emulator Program (Student Instruction System)
![SCEPSIS control panel](https://github.com/GerardWassink/SCEPSIS/blob/master/gfx/scepsis_main.JPG "SCEPSIS main screen")

### Purpose
The purpose of this project is to educate people in the concepts of low-level computing, by emulating a simple CPU. The properties of this CPU are:
- 8 bits
- fixed number of given components & control signals
- ability to define custom microcode
- thus being able to create one's own instruction set
- combined data- and address bus

## SCEPSASM - Simple CPU Emulator Program (ASeMbler)
![SCEPSASM main screen](https://github.com/GerardWassink/SCEPSIS/blob/master/gfx/scepsasm_main.JPG "SCEPSASM main screen")

### Purpose
SCEPSASM is an assembler that will - based on a language definition (langdef) file - parse a source file and convert it into an object memory file that can be executed with the SCEPSIS emulator.

## General information

### Background
For a bit more background read this [page about the "von Neumann machine"](https://geronimo370.nl/computers/theory/the-von-neumann-machine/). It describes the famous '**fetch - decode - get data - execute**' cycle

### Dependencies
A dependency is the use of ANSI escape codes, especially on Windows systems where it was only implemented recently (in Windows 10 Version 1511). More [info about ANSI codes](https://en.wikipedia.org/wiki/ANSI_escape_code). This dependency has been solved for older Windows versions as described in [Issue 2](https://github.com/GerardWassink/SCEPSIS/issues/3).

### Further reading
- [Components of the SCEPSIS CPU](./doc/Components.md)
- [Diagram of SCEPSIS components](./gfx/SCEPSIS Components.JPG)
- [Control signals in the SCEPSIS CPU](./doc/ControlSignals.md)
- [Example instruction for the SCEPSIS CPU](./doc/Example.md)
- [Language definition for the SCEPSIS CPU](./doc/Langdef.md)
- [ALU instructions for the SCEPSIS CPU](./doc/ALUinstructions.md)
