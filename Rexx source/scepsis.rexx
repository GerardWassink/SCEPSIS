#!/usr/bin/rexx
/* Rexx */

/* ---------------------------------------------------------------- */
/* Program name:    scepsis.rexx                                    */
/* Author:          Gerard Wassink                                  */
/* Date:            May 2019                                        */
/* Version:         0.1                                             */
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
			When choice == "B" Then	Do
				Call initMemory
				errorMsg = "Memory initialized"
			End

			When choice == "X" Then	Leave
			Otherwise
				errorMsg = "ERROR: Invalid choice: " || choice
		End
	End
	Call endProgram
Exit

/* -------------------------------------------------------------------------- */
/* ----- Initialisation of global variables ------------------ Initialize --- */
/* -------------------------------------------------------------------------- */
Initialize:
	Say "Initalizing:"
	Say

	/* ----- Memory ----- */
	ramSize = 256
	Do p = 0 to (ramSize - 1)
		RAM.p = p
	End

	/* ----- Available Control Signals ----- */
	ctlSig.0 = 0
	
	Call addCtlSig("CE Counter Enable, the program counter advances to the next instruction")
	Call addCtlSig("INPO Set the input register to output, put its on the DAB")
	Call addCtlSig("INRI Set the instruction register to input, to take a value from the DAB")
	Call addCtlSig("INRO Set the instruction register to output, put its on the DAB")
	Call addCtlSig("MARI Set the MAR to input, accept an address from the DAB")
	Call addCtlSig("MARO Set the MAR to output, put it out to the DAB")
	Call addCtlSig("PCTI Set the Program Counter to input, getting a value from the DAB")
	Call addCtlSig("PCTO Set the Program Counter to output, put it's value to the DAB")
	Call addCtlSig("OUTI Set the output register to input, getting a value from the DAB")
	Call addCtlSig("RAMI Set memory, pointed to by MAR to input, getting the value from the DAB")
	Call addCtlSig("RAMO Set memory, pointed to by MAR to output, put value on the DAB")
	Call addCtlSig("RGAI Set RGA to input, accept a value from the DAB")
	Call addCtlSig("RGAO Set RGA to output, put its value out to the DAB")
	Call addCtlSig("RGBI Set RGB to input, accept a value from the DAB")
	Call addCtlSig("RGBO Set RGB to output, put its value out to the DAB")

Return


/* -------------------------------------------------------------------------- */
/* ----- Initialize Memory ----------------------------------- initMemory --- */
/* -------------------------------------------------------------------------- */
initMemory:
	Procedure Expose ramSize RAM.
	/* ----- Memory ----- */
	ramSize = 256
	Do p = 0 to (ramSize - 1)
		RAM.p = 0
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- Helper routine to add control signals to the table --- addCtlSig --- */
/* -------------------------------------------------------------------------- */
addCtlSig:
	Procedure Expose ctlSig.
	Parse Arg ctl desc

	ctlSig.0 = ctlSig.0 + 1; p = ctlSig.0
	ctlSig.p = ctl
	ctlSig.p.1 = desc

Return p


/* -------------------------------------------------------------------------- */
/* ----- Show main Menu and return choice ---------------------- mainMenu --- */
/* -------------------------------------------------------------------------- */
mainMenu:
	Procedure
	Parse Arg message
	
	Call screenHeader

	Say "1. List hardware            A. List memory"
	Say "2. List components          B. Init Memory"
	Say "3. List Control Signals"
	Say ""
	Say "X. End program"
	Say ""
	Say "----- " || message
	Say ""
	Say "Your choice please:"
	choice = Upper(linein())
Return choice


/* -------------------------------------------------------------------------- */
/* ----- End of program -------------------------------------- endProgram --- */
/* -------------------------------------------------------------------------- */
endProgram:
	Say "goodbye"
Return


/* -------------------------------------------------------------------------- */
/* ----- List Memory in hex dump format----------------------- listMemory --- */
/* -------------------------------------------------------------------------- */
listMemory:
	Procedure Expose ramSize RAM.

	Call screenHeader

	Say "----- List of Memory -----"
	Say ""
	p = 0
	line = Right("0000"||d2x(p),4) || " : "
	Do p = 0 to ramSize - 1
		If p > 0 Then Do
			Select
				When ((p // 16) == 0) Then Do
					say line 
					line = Right("0000"||d2x(p),4) || " : "
				End
				When ((p //  8) == 0) Then line = line || " - "
				When ((p //  4) == 0) Then line = line || " "
				Otherwise Nop
			End
		End
		line = line || Right("00"||d2x(RAM.p),2)
	End
	Say ""
	Call enterForMore
Return


/* -------------------------------------------------------------------------- */
/* ----- List Hardware in our model computer---------------- listHardware --- */
/* -------------------------------------------------------------------------- */
listHardware:
	Procedure

	Call screenHeader

	Say "----- List of Hardware -----"
	Say ""
    Say "CPU - Central Processing Unit"
    Say "CNB - CoNtrol Bus, means of control the different components"
    Say "DAB - DAta Bus, a way to transport data back and forth"
    Say "INP - means to input stuff"
    Say "OUT - some way of outputting things"
    Say "RAM - Memory"
	Say ""
	Call enterForMore
Return


/* -------------------------------------------------------------------------- */
/* ----- List Components in our model computer------------ listComponents --- */
/* -------------------------------------------------------------------------- */
listComponents:
	Procedure

	Call screenHeader

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
	Call enterForMore
Return


/* -------------------------------------------------------------------------- */
/* ----- List available Control Signals -------------- listControlSignals --- */
/* -------------------------------------------------------------------------- */
listControlSignals:
	Procedure Expose ctlSig.

	Call screenHeader

	Say "----- List of Control Signals -----"
	Say ""
	Do c = 1 to ctlSig.0
		Say ctlSig.c || " - " || ctlSig.c.1
	End
	Say ""
	Call enterForMore
Return


/* -------------------------------------------------------------------------- */
/* ----- Press enter for more routine ---------------------- enterForMore --- */
/* -------------------------------------------------------------------------- */
enterForMore:
	Procedure
	Say "----- "
	Say ""
	Say "Enter to continue"
	junk = linein()
Return


/* -------------------------------------------------------------------------- */
/* ----- Display Screen Header ----------------------------- screenHeader --- */
/* -------------------------------------------------------------------------- */
screenHeader:
	Procedure
	Say "SCEPSIS - Simple CPU Emulator Program (Student Instruction System) v0.1"
	Say ""
Return

