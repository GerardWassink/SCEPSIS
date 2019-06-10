# SCEPSIS - roadmap

## Small versions, progressing to release 1.2
Release 1.2 will contain conditional jumps. All of the intermediate small releases will work towards that goal.

#### 1.1.9	Where needed, fix minor bugs, do housekeeping

### Release 1.2
Include all of the above.


## History

#### DONE 1.1.8	Introduce the 'execute the program' command
Build code for the 'R' instruction to execute the program from where the PCT is pointing; includes building code for the HLT instruction / status.

#### DONE 1.1.7	Introduce the 'execute one instruction' command
Build code for the 'I' instruction to execute a complete instruction with all it's microcode steps.

#### DONE -  1.1.6	Expand example instruction set with examples of conditional jumps

#### DONE -  1.1.5	Implement conditional jumps
Implement control signals to facilitatie conditional jumps (they would work the same way as the existing PCTI, only dependent on conditions).

#### DONE - 1.1.4	Set appropriate flags
Depending on the outcome of ALU operations, set flags.

#### DONE - 1.1.2	Arithmetic
Add code to decode ALU instructions and control it's operations.

