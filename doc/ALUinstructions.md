# Description of the ALU instructions

## ALU instruction result
The result of ALU instructions always ends up in register A. Register A is
the implicit first operand of the ALU instructions. The second operand is
determined by the mode bits in the instruction's opcode as follows:

## Coding the bits
Opcode bits that control the working of the ALU:

<PRE>
76543210
+----+--
|    |_________		bits 210 control the operation
|______________		bits 76543 are the identifying part of the ALU ops
</PRE>

### ALU operations
Binary values for ALU operations:

<PRE>
xxxx x000 - Add
xxxx x001 - Subtract
xxxx x010 - Compare
xxxx x011 - And
xxxx x100 - Or
xxxx x101 - Xor
xxxx x110	
xxxx x111	
</PRE>

### ALU addressing modes
The addressing mode controls where the second operand of the instruction comes from. 

- Immediate- (operand directly in instruction)
- Memory   - (operand in memory, address in instruction)
- REGB     - (operand in register B)

These modes depend on the micro step definitions for a specific instruction. The table below gives a suggestion for coding them.

### Decoding the instructions

#### Extracting the ALU operation
The ALU operation can be extracted from the Instruction Register 
as follows:

 ALUoperation = (comp_INR & x7)	/* mask is binary '00000111' */

## The possible ALU instructions
In the table below you find the possible variations of the ALU instructions in the 
way they are coded in SCEPSIS. The modes (bits 4 and 3 of the opcode) are suggestions 
to make the instruction set more structured. Coded in this way the instruction:

 CPM 3A

meaning: compare register a with the contents of memory at address x'3A', would be coded as:

    'xxx 01 010   0011 1010' (binary)

You could opt to code the opcodes for ALU operations starting with '111', as I will do 
in my example langdef file. Then it would be:

    '111 01 010   0011 1010' (binary) or: 'EA 3A' (hexadecimal)

### the ALU operation table:

| Opcode	 	| Name				| Example 	| Description 							|
| :--- 		 	| :---  			| :--- 		| :---									|
| 			 	| 					| 			| **Add instructions**					|
| `xxx 00 000`	| Add Immediate 	| `ADI 01` 	| Add 1 to register A 					|
| `xxx 01 000`	| Add memory		| `ADM 01`	| Add memory to register A				|
| `xxx 10 000`	| Add register B	| `ADB`		| Add register B to register A			|
| `xxx 11 000`	| Add register C	| `ADC`		| Add register C to register A			|	
| 			 	| 					| 			| **Subtract instructions**				|
| `xxx 00 001`	| Sub Immediate 	| `SBI 01` 	| Subtract 1 from register A			|
| `xxx 01 001`	| Sub  memory		| `SBM 01`	| Subtract memory from register A		|
| `xxx 10 001`	| Sub register B	| `SBB`		| Subtract register B from register A	|
| `xxx 11 001`	| Sub register C	| `SBC`		| Subtract register C from register A	|	
| 			 	|					| 			| **Compare instructions**				|
| `xxx 00 010`	| Cmp Immediate 	| `CPI 01` 	| Compare register A with 01			|
| `xxx 01 010`	| Cmp  memory		| `CPM 01`	| Compare register A with memory		|
| `xxx 10 010`	| Cmp register B	| `CPB`		| Compare register A with register B	|
| `xxx 11 010`	| Cmp register C	| `CPC`		| Compare register A with register C	|	
| 				| 					| 			| **Logical AND instructions**			|
| `xxx 00 011`	| AND Immediate 	| `ANI 01` 	| AND register A with 01				|
| `xxx 01 011`	| AND memory		| `ANM 01`	| AND register A with memory			|
| `xxx 10 011`	| AND register B	| `ANB`		| AND register A with register B		|
| `xxx 11 011`	| AND register C	| `ANC`		| AND register A with register C		|	
| 				| 					| 			| **Logical OR instructions**			|
| `xxx 00 100`	| OR Immediate		| `ORI 01` 	| OR register A with 01					|
| `xxx 01 100`	| OR memory			| `ORM 01`	| OR register A with memory				|
| `xxx 10 100`	| OR register B		| `ORB`		| OR register A with register B			|
| `xxx 11 100`	| OR register C		| `ORC`		| OR register A with register C			|	
| 				| 					| 			| **Logical XOR instructions**			|
| `xxx 00 101`	| XOR Immediate		| `XRI 01` 	| XOR register A with 01				|
| `xxx 01 101`	| XOR memory|		| `XRM 01`	| XOR register A with memory			|
| `xxx 10 101`	| XOR register B	| `XRB`		| XOR register A with register B		|
| `xxx 11 101`	| XOR register C	| `XRC`		| XOR register A with register C		|	
	

### Further reading

- [README file for SCEPSIS](../README.md)
- [Components of the SCEPSIS CPU](./Components.md)
- [Control signals in the SCEPSIS CPU](./ControlSignals.md)
- [Example instruction for the SCEPSIS CPU](./Example.md)
- [Language definition for the SCEPSIS CPU](./Langdef.md)
- [ALU instructions for the SCEPSIS CPU](./ALUinstructions.md)

