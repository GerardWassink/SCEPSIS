# SCEPSIS - roadmap

## Release 2.0 - SCEPSASM, an example of a SCEPSIS Assembler
Using a langdef file and a source file, will generate a memory file that can be executed in the SCEPSIS emulator.

## History

### DONE - 1.2.1 - Prep SCEPSIS for ASM
Change the .langdef file format to include arguments for the upcoming assembler syntax checking; 
change SCEPSIS code to read and process it

### DONE - 1.2 - Conditional jumps
Release 1.2 contains control signals for the conditional loading of the PCT, to facilitate the definition of conditional jumps.

#### DONE - 1.1.9 - Where needed, fix minor bugs, do housekeeping
Fix a bug that caused an error when a program ran thru the upper memory limit; made new screenshost for the UI screens.

#### DONE - 1.1.8 - Introduce the 'execute the program' command
Build code for the 'R' instruction to execute the program from where the PCT is pointing; includes building code for the HLT instruction / status.

#### DONE - 1.1.7 - Introduce the 'execute one instruction' command
Build code for the 'I' instruction to execute a complete instruction with all it's microcode steps.

#### DONE -	1.1.6 - Expand example instruction set with examples of conditional jumps

#### DONE - 1.1.5 - Implement conditional jumps
Implement control signals to facilitatie conditional jumps (they would work the same way as the existing PCTI, only dependent on conditions).

#### DONE - 1.1.4 - Set appropriate flags
Depending on the outcome of ALU operations, set flags.

#### DONE - 1.1.2 - Arithmetic
Add code to decode ALU instructions and control it's operations.

