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
xxxx x101 - Not
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

| Opcode | Name Example | Description |
|:--- |:--- |:--- |:--- |
| | | | --- Add instructions --- |
| xxx 00 000 | Add Immediate | ADI 01 | Add 1 to register A |

	</tr>
	<tr>
		<td>xxx 01 000</td>
		<td>Add from memory</td>
		<td>ADM 01</td>
		<td>Add memory to register A</td>
	</tr>
	<tr>
		<td>xxx 10 000</td>
		<td>Add register B</td>
		<td>ADB</td>
		<td>Add register B to register A</td>
	</tr>
	<tr>
		<td>xxx 11 000</td>
		<td>Add PCT</td>
		<td>ADP</td>
		<td>Add PCT to register A</td>
	</tr>
	
	<tr>
		<td align="right" colspan="4">--- Subtract instructions ---</td>
	</tr>
	
	<tr>
		<td>xxx 00 001</td>
		<td>Subtract Immediate</td>
		<td>SBI 01</td>
		<td>Subtract 1 from register A</td>
	</tr>
	<tr>
		<td>xxx 01 001</td>
		<td>Subtract memory</td>
		<td>SBM 01</td>
		<td>Subtract memory from register A</td>
	</tr>
	<tr>
		<td>xxx 10 001</td>
		<td>Subtract register B</td>
		<td>SBB</td>
		<td>Subtract register B from register A</td>
	</tr>
	<tr>
		<td>xxx 11 001</td>
		<td>Subtract PCT</td>
		<td>SBP</td>
		<td>Subtract PCT from register A</td>
	</tr>
	
	<tr>
		<td align="right" colspan="4">--- Compare instructions ---</td>
	</tr>
	
	<tr>
		<td>xxx 00 010</td>
		<td>Compare Immediate</td>
		<td>CPI 01</td>
		<td>Compare register A with 01</td>
	</tr>
	<tr>
		<td>xxx 01 010</td>
		<td>Compare memory</td>
		<td>CPM 01</td>
		<td>Compare register A with memory</td>
	</tr>
	<tr>
		<td>xxx 10 010</td>
		<td>Compare register B</td>
		<td>CPB</td>
		<td>Compare register a with register B</td>
	</tr>
	<tr>
		<td>xxx 11 010</td>
		<td>Compare PCT</td>
		<td>CPP</td>
		<td>Compare register A with  PCT</td>
	</tr>
	
	<tr>
		<td align="right" colspan="4">--- Logical AND instructions ---</td>
	</tr>
	
	<tr>
		<td>xxx 00 011</td>
		<td>AND Immediate</td>
		<td>ANI 01</td>
		<td>AND register A with 01</td>
	</tr>
	<tr>
		<td>xxx 01 011</td>
		<td>AND memory</td>
		<td>ANM 01</td>
		<td>AND register A with memory</td>
	</tr>
	<tr>
		<td>xxx 10 011</td>
		<td>Compare register B</td>
		<td>ANB</td>
		<td>AND register A with register B</td>
	</tr>
	<tr>
		<td>xxx 11 011</td>
		<td>AND PCT</td>
		<td>ANP</td>
		<td>AND register A with PCT</td>
	</tr>
	
	<tr>
		<td align="right" colspan="4">--- Logical OR instructions ---</td>
	</tr>
	
	<tr>
		<td>xxx 00 100</td>
		<td>OR Immediate</td>
		<td>ORI 01</td>
		<td>OR register A with 01</td>
	</tr>
	<tr>
		<td>xxx 01 100</td>
		<td>OR memory</td>
		<td>ORM 01</td>
		<td>OR register A with memory</td>
	</tr>
	<tr>
		<td>xxx 10 100</td>
		<td>OR register B</td>
		<td>ORB</td>
		<td>OR register A with register B</td>
	</tr>
	<tr>
		<td>xxx 11 100</td>
		<td>OR PCT</td>
		<td>ORP</td>
		<td>OR register A with PCT</td>
	</tr>
	
	<tr>
		<td align="right" colspan="4">--- Logical NOT instructions ---</td>
	</tr>
	
	<tr>
		<td>xxx 00 100</td>
		<td>NOT register A</td>
		<td>NTA</td>
		<td>Invert register A</td>
	</tr>
	<tr>
		<td>xxx 01 100</td>
		<td>NOT memory</td>
		<td>NTM 01</td>
		<td>Invert memory value into register A</td>
	</tr>
	<tr>
		<td>xxx 10 100</td>
		<td>NOT register B</td>
		<td>NTB</td>
		<td>Invert register B into register A</td>
	</tr>
	<tr>
		<td>xxx 11 100</td>
		<td>NOT PCT</td>
		<td>NTP</td>
		<td>Invert PCT into register A</td>
	</tr>
	
</table>


### Further reading

- [README file for SCEPSIS](../README.md)
- [Components of the SCEPSIS CPU](./Components.md)
- [Control signals in the SCEPSIS CPU](./ControlSignals.md)
- [Example instruction for the SCEPSIS CPU](./Example.md)
- [Language definition for the SCEPSIS CPU](./Langdef.md)
- [ALU instructions for the SCEPSIS CPU](./ALUinstructions.md)

