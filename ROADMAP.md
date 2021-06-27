# SCEPSIS - roadmap

## To Do

## History

### DONE - 1.3.6 - Improve the 'Animate' function
Issue #32

### DONE - 1.3.5 - Assembler directives built in 
Issue #28 completed:

sasmDirectives = "BASE DC DS EQU"
- BASE {address} # What follows starts at this address in memory
- DC {data} # See below for definitions
- DS {stor_def} # see below
- lbl EQU # the label, 'lbl', gets the current address value

{address}
- 16 bit address (can be specified as seen below)

{data} can be
- c'character data[']
- b'binary data[']
- d'decimal data[']
- x'hexadecimal data[']

{stor_def}
- CLnn # character for a length of nn


### DONE - 1.3.4 - SCEPSASM now executable as commandline program
SCEPSASM can now be executed as command line tool like:

	SCEPSASM sourcefile [-o objectfile] [-l listfile]


### DONE - 1.3.3 - SCEPSIS and SCEPSASM now work with 16 bits
We now have 64K (65536 bytes) to work with. Enlarged the stack from 16 to 256 bytes

### DONE - 1.3.2 - Solved several issues
Issues 22, 23, 24 and 25.

### DONE - 1.3.1 - Cleanup code and UI
Code cleanup and make the UI consistent.
Add possibility to test control signals.

### DONE - 1.3 - Few little improvements, example program
The computation of the flag settings was flawed; corrected the errors.
Built in an animate level function in the config file.
Coded a SCEPSASM program to generate prime numbers as an example.

### DONE - 1.2.2 - Complete SCEPSASM
Coded the assembler in three phases, and coded a proper assembly listing.

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
