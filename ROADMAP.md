# SCEPSIS - roadmap

## Small versions, progressing to release 1.2
Release 1.2 will contain conditional jumps. All of the intermediate small releases will work towards that goal.

#### 1.1.2	Arithmetic - DONE
Add code to decode ALU instructions and control it's operations:
- Add
- Subtract
- Compare
- And
- Or
- Not

#### 1.1.4	Set appropriate flags
Depending on the outcome of ALU operations, set flags:
- C		Carry
- Z		Zero
- EQ 	Equal
- LT	Less then
- GT	Greater then

#### 1.1.5	Conditional jumps
Implement control signals to facilitatie conditional jumps (they would work the same way as the existing PCTI, only dependent on conditions):
- SPCC	Set Program Counter when Carry set
- SPCZ	Set Program Counter when Zero
- SPCE	Set Program Counter when Equal
- SPCL	Set Program Counter when Less
- SPCG	Set Program Counter when Greater

#### 1.1.6	Expand example instruction set with one example of conditional jump
- JE	Jump when equal

#### 1.1.7	Introduce the possibility to execute one instruction (with all its microsteps) at once

#### 1.1.8	Introduce the possibility to execute the program from the point where the PCT in pointing

#### 1.1.9	Where needed, fix minor bugs, do housekeeping

### Release 1.2
Include all of the above.

