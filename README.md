
# SCEPSIS

## Simple CPU Emulator Program (Student Instruction System)

### Purpose

The purpose of this project is to educate people in the concepts of low-level computing, by emulating a simple CPU. The properties of this CPU will be:

- 8 bits
- fixed number of given components & control signals
- ability to define custom microcode
- thus being able to create one's own instruction set
- combined data- and address bus

### Background

For a bit more background read this [page about the "von Neumann machine"](https://geronimo370.nl/computers/theory/the-von-neumann-machine/). It describes the famous '**fetch - decode - get data - execute**' cycle

### Dependencies

A dependency is the use of ANSI escape codes, especially on Windows systems where it was only implemented recently (in Windows 10 Version 1511). More [info about ANSI codes](https://en.wikipedia.org/wiki/ANSI_escape_code).

### Further reading

- [Components of the SCEPSIS CPU](./doc/Components.md)
- [Control signals in the SCEPSIS CPU](./doc/ControlSignals.md)
- [Example instruction for the SCEPSIS CPU](./doc/Example.md)
- [Language definition for the SCEPSIS CPU](./doc/Langdef.md)
