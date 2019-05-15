#!/usr/bin/rexx
/* Rexx */

/* ---------------------------------------------------------------- */
/* Program name:    scepsis.rexx                                    */
/* Author:          Gerard Wassink                                  */
/* Date:            May 2019                                        */
/* Purpose:         Teach peeople about simple CPU's and microcode  */
/* ---------------------------------------------------------------- */

Main:
	Call Initialize
	choice = ""
	errorMsg = ""
	Do Until choice = "X"
		choice = mainMenu(errorMsg)
		errorMsg = ""
		Select
			When choice == "1" Then	Call listHardware
			When choice == "2" Then	Call listComponents
			When choice == "3" Then	Call listControlSignals
			When choice == "A" Then	Call listMemory
			When choice == "X" Then	Leave
			Otherwise
				errorMsg = "ERROR: Invalid choice: " || choice
		End
	End
	Call endProgram
Exit


Initialize:
	Say "Initalizing:"
	Say
	/* ----- Memory ----- */
	ramSize = 256
	Do p = 0 to (ramSize - 1)
		RAM.p = p
	End
Return


mainMenu:
	Procedure
	Parse Arg message
	Say "SCEPSIS - Simple CPU Emulator Program (Student Instruction System)"
	Say ""
	Say "1. List hardware            A. List memory"
	Say "2. List components"
	Say "3. List Control Signals"
	Say ""
	Say "X. End program"
	Say ""
	Say "----- " || message
	Say ""
	Say "Your choice please:"
	choice = Upper(linein())
Return choice


endProgram:
	Say "goodbye now"
Return


listMemory:
	Procedure Expose ramSize RAM.
	Say "SCEPSIS - Simple CPU Emulator Program (Student Instruction System)"
	Say ""
	Say "----- List of Memory -----"
	Say ""
	Do p = 0 to ramSize
		Say Right("00"||d2x(RAM.p),2)
	End
	Say ""
Return


listHardware:
	Procedure
	Say "SCEPSIS - Simple CPU Emulator Program (Student Instruction System)"
	Say ""
	Say "----- List of Hardware -----"
	Say ""
    Say "CPU - Central Processing Unit"
    Say "CNB - CoNtrol Bus, means of control the different components"
    Say "DAB - DAta Bus, a way to transport data back and forth"
    Say "INP - means to input stuff"
    Say "OUT - some way of outputting things"
    Say "RAM - Memory"
	Say ""
Return


listComponents:
	Procedure
	Say "SCEPSIS - Simple CPU Emulator Program (Student Instruction System)"
	Say ""
	Say "----- List of Components -----"
	Say ""
    Say "ALU - Arithmetic Logical Unit"
    Say "CLK - A CLocK pulse generator"
    Say "CTU - ConTrol Unit"
    Say "INP - INPut Register"
    Say "INR - INstruction Register"
    Say "MAR - Memory Address Register"
	Say "OUT - OUTput Register"
    Say "PCT - Program CounTer"
    Say "RGA - ReGister A"
    Say "RGB - ReGister B"
	Say ""
Return


listControlSignals:
	Procedure
	Say "SCEPSIS - Simple CPU Emulator Program (Student Instruction System)"
	Say ""
	Say "----- List of Control Signals -----"
	Say ""
	Say "CE - Counter Enable, the program counter advances to the next instruction"
	Say "INPO - Set the input register to output, put its on the DAB"
	Say "INRI - Set the instruction register to input, to take a value from the DAB"
	Say "INRO - Set the instruction register to output, put its on the DAB"
	Say "MARI - Set the MAR to input, accept an address from the DAB"
	Say "MARO - Set the MAR to output, put it out to the DAB"
	Say "PCTI - Set the Program Counter to input, getting a value from the DAB"
	Say "PCTO - Set the Program Counter to output, put it's value to the DAB"
	Say "OUTI - Set the output register to input, getting a value from the DAB"
	Say "RAMI - Set memory, pointed to by MAR to input, getting the value from the DAB"
	Say "RAMO - Set memory, pointed to by MAR to output, put value on the DAB"
	Say "RGAI - Set RGA to input, accept a value from the DAB"
	Say "RGAO - Set RGA to output, put its value out to the DAB"
	Say "RGBI - Set RGA to input, accept a value from the DAB"
	Say "RGBO - Set RGA to output, put its value out to the DAB"
	Say ""
Return
