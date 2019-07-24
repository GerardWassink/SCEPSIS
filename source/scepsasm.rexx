#!/usr/bin/rexx
/* Rexx */

/* -------------------------------------------------------------------------- */
/* Program name:    scepsasm.rexx                                             */
/* Author:          Gerard Wassink                                            */
/* Date:            June 2019                                                 */
	versionString = "1.3.5"
/* Purpose:         Teach peeople about simple CPU's and microcode            */
/*                                                                            */
/* History:                                                                   */
/*   v1.2.1   Copied SCEPSIS source to make use of it's parsing routines      */
/*   v1.2.2   Coded parse phase 1, 2 and 3 and produced assembly listing      */
/*   v1.2.3   Code cleanup, corrected a few minor bugs                        */
/*   v1.3.3   Altered to accomodate larger memory                             */
/*   v1.3.4   Make SCEPSASM a commandline tool, strip the GUI bloat           */
/*   v1.3.5   Implement assembler directives (Issue #28)                      */
/*                                                                            */
/* -------------------------------------------------------------------------- */

/* -------------------------------------------------------------------------- */
/* ----- Initialize screen control and color Control values ----------------- */
/* -------------------------------------------------------------------------- */
Globals:

	color.black = 30; color.red     = 31; color.green = 32; color.yellow = 33
	color.blue  = 34; color.magenta = 35; color.cyan  = 36; color.white  = 37
	color.brightblack  = 90; color.brightred    = 91; color.brightgreen   = 92
	color.brightyellow = 93; color.brightblue   = 94; color.brightmagenta = 95
	color.brightcyan   = 96; color.brightwhite  = 97
	color.reset = 0
	ESC = d2c(27) || "["
	LF = d2c(10)


/* -------------------------------------------------------------------------- */
/* ----- Control the machine functions --------------------- controlPanel --- */
/* -------------------------------------------------------------------------- */
Main:
	Parse Arg arguments
	
	Call screenHeader
	Call Initialize
	choice = ""
	errorMsg = ""
	Call processArguments

	If Interactive == 1 Then Do
		Call handleDisplay
	End; Else Do
		Call screenHeader "SCEPSASM - Generating executable from source file"
		Say "source  file =" SRCfile
		Say "object  file =" OBJfile
		Say "listing file =" LSTfile
		Call Assemble
	End

	Call endProgram
Exit


/* -------------------------------------------------------------------------- */
/* ----- Split command line, redefine defaults --------- processArguments --- */
/* -------------------------------------------------------------------------- */
processArguments:
	Parse Var arguments val0 '-' opt1 val1 '-' opt2 val2 junk
	
										/* initialize output vars ----------- */
	sourceFile = ""; objectFile = ""; listFile = ""
	Interactive = 0

										/* Get source file name ------------- */
	If val0 <> "" Then Do
		sourceFile = val0
		If opt1 <> "" Then Do
			If val1 <> "" Then Do
				Select
					When Upper(opt1) == "O" Then objectFile = val1
					When Upper(opt1) == "L" Then listFile   = val1
					Otherwise Do
						Say "Invalid option:" opt1
						Call Usage
					End
				End
				If opt2 <> "" Then Do
					If val2 <> "" Then Do
						Select
							When Upper(opt2) == "O" Then objectFile = val2
							When Upper(opt2) == "L" Then listFile   = val2
							Otherwise Do
								Say "Invalid option:" opt2
								Call Usage
							End
						End
						If junk <> "" Then Do
							Say "Invalid junk at end of command:" junk
							Call Usage
						End
					End; Else Do
						Say opt2 "specified but no filename found"
						Call Usage
					End
				End
			End; Else Do
				Say opt1 "specified but no filename found"
				Call Usage
			End

		End
		If sourceFile <> "" Then Do
			SRCfile = CheckInputFileName(sourceFile)
			If SRCfile == "" Then Do
				Say "source" errorMsg
				Exit
			End
		End
		
		If objectFile <> "" Then Do
			OBJfile = CheckOutputFileName(objectFile)
			If OBJfile == "" Then Do
				Say "object" errorMsg
				Exit
			End
		End
			
		If listFile <> "" Then Do
			LSTfile = CheckOutputFileName(listFile)
			If LSTfile == "" Then Do
				Say "listing" errorMsg
				Exit
			End
		End

	End; Else Do
		errorMsg = "no arguments given, switched to interactive mode with default values"
		Interactive = 1
	End
	
Return	


/* -------------------------------------------------------------------------- */
/* ----- Display usage of the command line ------------------------ Usage --- */
/* -------------------------------------------------------------------------- */
Usage:
	Say "Usage:"
	Say "scepsasm sourcefile [-o objectfile] [-l listingfile]"
Exit


/* -------------------------------------------------------------------------- */
/* ----- Handle commands from screen ---------------------- handleDisplay --- */
/* -------------------------------------------------------------------------- */
handleDisplay:
	Do Until choice = "X"
		Call controlPanelDisplay(errorMsg)
		choice = Strip(linein())					/* get next command - */
		Parse Var choice command value
		command = Upper(command)
		If (choice =="") Then choice = "S"
		errorMsg = ""
		Select

			/* ---------------------------------------------------------- */
			/* ----- File commands -------------------------------------- */
			/* ---------------------------------------------------------- */
			When command == "SRC" Then	SRCfile = CheckInputFileName(value)
			When command == "OBJ" Then	OBJfile = CheckOutputFileName(value)
			When command == "LST" Then	LSTfile = CheckOutputFileName(value)

			/* ---------------------------------------------------------- */
			/* ----- Assembler commands --------------------------------- */
			/* ---------------------------------------------------------- */
			When command == "ASM" Then	Call Assemble
			
			/* ---------------------------------------------------------- */
			/* ----- Miscelaneous commands ------------------------------ */
			/* ---------------------------------------------------------- */
			When command == "?"   Then	Call CPhelpInfo
			When command == "IX"  Then	Call indexMe	/* hidden feature */
			When command == "X"   Then	Do
				command = ""
				Leave
			End
			Otherwise Do
				errorMsg = "Invalid command: " || choice 
			End
		End
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- Display the machine functions -------------- controlPanelDisplay --- */
/* -------------------------------------------------------------------------- */
controlPanelDisplay:
	Parse Arg message
	
	Call screenHeader

	Call Display  2  1 color.brightwhite "===> "
	Call Display  2  6 color.brightred "___________________________________________________________________________"


	Call Display  4  3 color.cyan		 "File names"
	Call Display  5  3 color.cyan		 "SRC file name:"
	Call Display  5 18 color.brightcyan  Left(SRCfile||"__________________________________________________",50)
	Call Display  6  3 color.cyan		 "OBJ file name:"
	Call Display  6 18 color.brightcyan  Left(OBJfile||"__________________________________________________",50)
	Call Display  7  3 color.cyan		 "LST file name:"
	Call Display  7 18 color.brightcyan  Left(LSTfile||"__________________________________________________",50)
	
	
	Call Display 10  3 color.brightwhite "Commands ---------------"
	Call Display 11  3 color.brightwhite "SRC"
	Call Display 11  7 color.brightcyan  "{name of source file}"
	Call Display 12  3 color.brightwhite "OBJ"
	Call Display 12  7 color.brightcyan  "{name of object file}"
	Call Display 13  3 color.brightwhite "LST"
	Call Display 13  7 color.brightcyan  "{name of listing file}"
	Call Display 15  3 color.brightwhite "ASM"
	Call Display 15  7 color.brightcyan  "- Assemble the source file"

	Call Display 18  3 color.brightwhite "X"
	Call Display 18  5 color.brightcyan  "Exit"
	Call Display 18 53 color.brightwhite "?"
	Call Display 18 57 color.brightcyan  "Help info"
	
	If Strip(message) <> "" Then Do
		Call Display 21 1 color.brightwhite "===>" message
	End
	Call Display  2 6 color.brightwhite
Return


/* -------------------------------------------------------------------------- */
/* ----- Assemble the source into an object -------------------- Assemble --- */
/* -------------------------------------------------------------------------- */
Assemble:
	
	If Interactive == 1 Then Call Display  3  1 color.cyan " "
	
	phase1.0 = 0; parsePhase1 = 0
	phase2.0 = 0; parsePhase2 = 0
	phase3.0 = 0; parsePhase3 = 0

	Say "- Phase 1 - Reading and parsing source file"
	If parseSourcePhase1() Then Do		/* Result is formal parsed table ---- */
		Say "   finished"
		Say "- Phase 2 - Reading and parsing source file"
		If parseSourcePhase2() Then Do	/* Go through the parsed table ------ */
			Say "   finished"
/*	Call listParseTable
	Exit
 */
			Say "- Phase 3 - Generating the code into memory"
			If parseSourcePhase3() Then Do	/* Generate output in memory ---- */
				Say "   finished"
				
				Call saveMemory			/* save generated code to OBJ file -- */

			End; Else Do
				Say "Parse phase 3 contained errors"
			End
		End; Else Do	
			Say "Parse phase 2 contained errors"
		End
	End; Else Do	
		Say "Parse phase 1 contained errors"
	End
	Say "Generating listing and messages file"
	Call listResults
	
	If Interactive == 1 Then Call enterForMore
	
Return


/* -------------------------------------------------------------------------- */
/* ----- Read and parse the source file --------------- parseSourcePhase1 --- */
/* -------------------------------------------------------------------------- */
parseSourcePhase1: 
	lnum = 0
	parsePhase1 = 1

	c = Stream(SRCfile, 'C', 'SEEK =')
	c = Stream(SRCfile, 'C', 'OPEN READ')
	
	phase1.  = ""						/* Initialize phase1 output --------- */
	phase1.0 = 0
	
	/* ---------------------------------------------------------------------- */
	/* Create array that contains the assembly code as follows: -------- typ  */
	/*   source.0	-	number of instructions ------------------------------ */
	/*   source.n.1	-	label if present, else "" ----------------------- C - */
	/*   source.n.2	-	instruction mnemonic ---------------------------- C - */
	/*   source.n.3	-	operand when present, else "" ------------------- C - */
	/*   source.n.4	-	instruction line nummer in source file ---------- D - */
	/*   source.n.5	-	instruction address ----------------------------- D - */
	/*   source.n.6	-	instruction opcode ------------------------------ X - */
	/*   source.n.7	-	instruction operand value if present, else "" --- X - */
	/*   source.n.8	-	instruction length ------------------------------ D - */
	/*   source.n.9	-	original source line ---------------------------- C - */
	/* ---------------------------------------------------------------------- */
	
	source. = ""						/* empty array to hold parse output - */
	source.0 = 0
	instrAddr = 0						/* start address at start of memory - */
	
	Do While Lines(SRCfile)
		inLine = Upper(Linein(SRCfile))			/* make upper case ---------- */
		lnum   = lnum + 1
		asmMsg = ""
		source.0 = source.0 + 1					/* housekeeping for array --- */
		instrPtr = source.0
		Select
			
			When ( Substr(inLine,1,1) == "#") Then Do	/* comment lines ---- */
				source.instrPtr.4 = lnum		/* store line number -------- */
				source.instrPtr.5 = ""			/* store address ------------ */
				source.instrPtr.9 = inLine		/* store original source line */
			End
			
			When ( Strip(inLine) == "") Then Do	/* blank lines -------------- */
				source.instrPtr.4 = lnum		/* store line number -------- */
				source.instrPtr.5 = ""			/* store address ------------ */
				source.instrPtr.9 = inLine		/* store original source line */
			End
			
			Otherwise Do
				Parse Var inLine line '#' comment	/* Set comment aside ---- */
				
				/* ---------------------------------------------------------- */
				/* Split all relevant values from the source line ----------- */
				/* ---------------------------------------------------------- */
				labl = ""						/* see if there's a label --- */
				If isWhiteSpace(Left(line,1))
					Then Parse Var line mnem oprnd junk			/* no label   */
					Else Parse Var line labl mnem oprnd junk	/* yes label  */
				
				labl  = Strip(labl)				/* Strip superfluous spaces - */
				mnem  = Strip(mnem)
				oprnd = Strip(oprnd)
				junk  = Strip(junk)
				
												/* store label when found --- */
				If (labl <> "") Then source.instrPtr.1 = labl
				source.instrPtr.2 = mnem		/* store mnemonic ----------- */
				source.instrPtr.3 = oprnd		/* store operand text ------- */
				source.instrPtr.4 = lnum		/* store line number--------- */
				source.instrPtr.9 = inLine		/* store original source line */
				source.instrPtr.5 = Right("0000"||D2X(instrAddr),4)	/*address */
				
				/* ---------------------------------------------------------- */
				/* Using mnemonic, find opcode or directive ----------------- */
				/* ---------------------------------------------------------- */
				i = findMnem(mnem)				/* Try to find mnemonic ----- */
				If (i > 0) Then Do				/* zero if not found -------- */
					source.instrPtr.6 = instr.i.1	/* store opcode if found  */
				End; Else Do
											/* Is it an assembler directive?  */
					If Wordpos(mnem, asmDirectives) > 0 Then Do
						source.instrPtr.6 = "  "	/* store directive opc -- */
					End; Else Do
						Call addPhase1Msg "Error: Unknown instruction '"||mnem||"' found in source line" lnum
						parsePhase1 = 0
					End
				End
				
				/* ---------------------------------------------------------- */
				/* Set operand values when given, handle labels in phase 2 -- */
				/* ---------------------------------------------------------- */
				If (oprnd <> "") Then Do
					oprndValue = ""				/* initialize for phase 2 --- */
					
					If (Substr(oprnd,2,1) == "'") Then Do
												/* assume it's a value, check */
						Select
							When Left(oprnd,1) == "C" Then Do
												/* it's a character value --- */
								Parse var oprnd "C'" opval "'"	/* strip ---- */
								oprndValue = Right("0000"||C2X(opval),4)
							End
							
							When Left(oprnd,1) == "X" Then Do
												/* it's a hexadecimal value - */
								Parse var oprnd "X'" opval "'"	/* strip ---- */
								If isHex(opval) Then Do
									oprndValue = Right("0000"||opval,4)
								End; Else Do
									Call addPhase1Msg "Error: invalid hexadecimal value "||opval||" found in source line" lnum
									parsePhase1 = 0
								End
							End
							
							When Left(oprnd,1) == "B" Then Do
												/* it's a binary value ------ */
								Parse var oprnd "B'" opval "'"	/* strip quotes - */
								If isBin(opval) Then Do
									oprndValue = Right("0000"||B2X(opval),4)
								End; Else Do
									Call addPhase1Msg "Error: invalid binary value "||opval||" found in source line" lnum
									parsePhase1 = 0
								End
							End
							
							When Left(oprnd,1) == "D" Then Do
												/* it's a decimal value ----- */
								Parse var oprnd "D'" opval "'"	/* strip quotes - */
								If isDec(opval) Then Do
									oprndValue = Right("0000"||D2X(opval),4)
								End; Else Do
									Call addPhase1Msg "Error: invalid decimal value "||opval||" found in source line" lnum
									parsePhase1 = 0
								End
							End
							
							/* ---------------------------------------------- */
							/* NOTE: labels handled in Parse Phase 2 -------- */
							/* ---------------------------------------------- */
							
							Otherwise Do
								Call addPhase1Msg "Error: invalid operand "||oprnd||" found in source line" lnum
								parsePhase1 = 0
							End
							
						End
						
						/* -------------------------------------------------- */
						/* Check whether values have proper range ----------- */
						/* -------------------------------------------------- */
						If source.instrPtr.6 == "  " Then Do	/* directive  */
							source.instrPtr.7 = oprndValue
						End; Else Do
																/* opcode --- */
													/* check value in range - */
							If oprndValue <> "" Then Do
								If (X2D(oprndValue) < 0 | X2D(oprndValue) > (memSize - 1)) Then Do
									Call addPhase1Msg "Error: operand value '"||oprndValue||"' out of range in source line" lnum " opcode" opcode
									parsePhase1 = 0
								End; Else Do			/* store value ---------- */
									source.instrPtr.7 = oprndValue
								End
							End
						End
					End
				End
				
				If (oprnd == "") Then Do		/* store instruction length - */
					source.instrPtr.8 = 1
				End; Else Do
					source.instrPtr.8 = 3
				End
				
								/* Calculate storage length for Directices -- */
				If source.instrPtr.6 == "  " Then Do
					Select
						When mnem == "EQU" Then Do
							storLen = 0
						End
						When mnem == "BASE" Then Do
							instrAddr = x2d(oprndValue)		/* set address -- */
							storLen = X2D(oprndValue) - instrAddr
						End
						When mnem == "DS" Then Do
							If Left(oprnd,2) == "CL" Then Do
								Parse Var oprnd "CL" ll .
								If isDec(ll) Then Do
									storLen = ll
								End; Else Do
									storLen = 0
									Call addPhase1Msg "Error: length not numeric '" mnem oprnd "' in source line" lnum
								End
							End; Else Do
								Call addPhase1Msg "Error: invalid operand syntax '" mnem oprnd "' found in source line" lnum
							End
						End
						When mnem == "DC" Then Do
							oprndValue = ""
							Call makeStorOperand
							source.instrPtr.7 = oprndValue
							storLen = Length(oprndValue)/2
						End
						Otherwise NOP
					End
					source.instrPtr.8 = storLen			/* for directives --- */
				End
				
				source.instrPtr.5 = instrAddr

											/* set address for next line ---- */
				instrAddr = instrAddr + source.instrPtr.8
				
				If ((instr.i.2.1 == "") & (oprnd <> "")) Then Do
					Call addPhase1Msg "Error: unexpected operand '"||oprnd||"' found in source line" lnum
					parsePhase1 = 0
				End
				
				If junk <> "" Then Do
					Call addPhase1Msg "Error: Superfluous '"||junk||"' found in source line" lnum
					parsePhase1 = 0
				End
			End
		End
	End
Return parsePhase1


/* -------------------------------------------------------------------------- */
/* ----- Make operand storable ----------------------------- addPhase1Msg --- */
/* -------------------------------------------------------------------------- */
makeStorOperand:
	Select
		When Left(oprnd,1) == "C" Then Do
							/* it's a character value --- */
			Parse var oprnd "C'" opval "'"	/* strip ---- */
			oprndValue = C2X(opval)
		End
		
		When Left(oprnd,1) == "X" Then Do
							/* it's a hexadecimal value - */
			Parse var oprnd "X'" opval "'"	/* strip quotes - */
			If isHex(opval) Then Do
				oprndValue = opval
			End; Else Do
				Call addPhase1Msg "Error: invalid hexadecimal value "||opval||" found in source line" lnum
				parsePhase1 = 0
			End
		End
		
		When Left(oprnd,1) == "B" Then Do
							/* it's a binary value ------ */
			Parse var oprnd "B'" opval "'"	/* strip quotes - */
			If isBin(opval) Then Do
				oprndValue = B2X(opval)
			End; Else Do
				Call addPhase1Msg "Error: invalid binary value "||opval||" found in source line" lnum
				parsePhase1 = 0
			End
		End
		
		When Left(oprnd,1) == "D" Then Do
							/* it's a decimal value ----- */
			Parse var oprnd "D'" opval "'"	/* strip quotes - */
			If isDec(opval) Then Do
				oprndValue = D2X(opval)
			End; Else Do
				Call addPhase1Msg "Error: invalid decimal value "||opval||" found in source line" lnum
				parsePhase1 = 0
			End
		End
		Otherwise Do
		End
	End
	If (Length(oprndValue)/2) <> (Trunc(Length(oprndValue)/2)) Then Do
		oprndValue = "0"||oprndValue
	End
Return

/* -------------------------------------------------------------------------- */
/* ----- Add a message as output of phase 1 ---------------- addPhase1Msg --- */
/* -------------------------------------------------------------------------- */
addPhase1Msg:
	Procedure Expose phase1.
	Parse arg msg
	phase1.0 = phase1.0 + 1
	p1 = phase1.0
	phase1.p1 = msg
	Say "   MSG -" msg
Return


/* -------------------------------------------------------------------------- */
/* ----- Parse phase 2, substitute labels by addresses -- parseSourcePhase2 - */
/* -------------------------------------------------------------------------- */
parseSourcePhase2: 
	parsePhase2 = 1
	phase2.  = ""
	phase2.0 = 0
	
	Do instrPtr = 1 To source.0			/* find label and substitute adress - */
		oprnd		= source.instrPtr.3
		oprndValue	= source.instrPtr.7
		opcode		= source.instrPtr.6
		If opcode <> "  " Then Do
			If (oprnd <> "" & oprndValue == "") Then Do
				x = findLabel(oprnd)
				If x > 0 Then Do						/* substitute addres  */
					source.instrPtr.7 = right("0000"||D2X(source.x.5),4)
				End; Else Do
					Call addPhase2Msg "Error: label '"||oprnd||"' not found in source line" source.instrPtr.4
					parsePhase2 = 0
				End
			End
		End
	End
Return parsePhase2


/* -------------------------------------------------------------------------- */
/* ----- Add a message as output of phase 2 ---------------- addPhase2Msg --- */
/* -------------------------------------------------------------------------- */
addPhase2Msg:
	Procedure Expose phase2.
	Parse arg msg
	phase2.0 = phase2.0 + 1
	p2 = phase2.0
	phase2.p2 = msg
	Say "   MSG -" msg
Return


/* -------------------------------------------------------------------------- */
/* ----- Create the object file from the parse table -- parseSourcePhase3 --- */
/* -------------------------------------------------------------------------- */
parseSourcePhase3: 
	"clear"
	parsePhase3 = 1
	phase3.  = ""
	phase3.0 = 0
	
	Call initMemory						/* clear out memory ----------------- */
	
	adrPtr = 0							/* walk thru the memory ------------- */

	Do instrPtr = 1 To source.0			/* Go thru the parse table ---------- */
		If source.instrPtr.5 <> "" Then Do	/* Not a comment or empty line? - */
			mnem		= source.instrPtr.2
			instrAddr	= source.instrPtr.5
			opcode		= source.instrPtr.6
			oprndValue	= source.instrPtr.7
			instrLength	= source.instrPtr.8
			lnum		= source.instrPtr.4

			/* -------------------------------------------------------------- */
			/* Process Assembler Directives --------------------------------- */
			/* -------------------------------------------------------------- */
			If opcode == "  " Then Do		
				If mnem == "BASE" Then Do
					adrPtr = X2D(oprndValue)
				End
				If mnem == "DC" Then Do
					Do i = 1 To Length(oprndValue) by 2
						bval = Substr(oprndValue, i, 2)
						MEM.adrPtr = X2D(bval)
						adrPtr = adrPtr + 1
					End
				End
				If mnem == "DS" Then Do
					adrPtr = adrPtr + instrLength
				End
			End; Else Do
			
			/* -------------------------------------------------------------- */
			/* Process other instructions ----------------------------------- */
			/* -------------------------------------------------------------- */
				MEM.adrPtr = X2D(opcode)	/* store opcode into memory ----- */
				adrPtr = adrPtr + 1			/* bump pointer ----------------- */
				If adrPtr > (memSize - 1) Then Do
					Call addPhase3Msg "Error: program longer than allowable memSize ("||memSize||") in source line" lnum
					Leave
				End
				If oprndValue <> "" Then Do
											 /* operand value into memory --- */
					memval = Substr(oprndValue, 1, 2)
					MEM.adrPtr = X2D(memval)
					adrPtr = adrPtr + 1		/* bump pointer ----------------- */

					memval = Substr(oprndValue, 3, 2)
					MEM.adrPtr = X2D(memval)
					adrPtr = adrPtr + 1		/* bump pointer ----------------- */

					If adrPtr > (memSize - 1) Then Do
						Call addPhase3Msg "Error: program longer than allowable memSize ("||memSize||") in source line" lnum
						Leave
					End
				End
			End
		End
	End
Return parsePhase3


/* -------------------------------------------------------------------------- */
/* ----- Add a message as output of phase 3 ---------------- addPhase3Msg --- */
/* -------------------------------------------------------------------------- */
addPhase3Msg:
	Procedure Expose phase3.
	Parse arg msg
	phase3.0 = phase3.0 + 1
	p3 = phase3.0
	phase3.p3 = msg
	Say "   MSG -" msg
Return


/* -------------------------------------------------------------------------- */
/* ----- Find a label in the parse table ---------------------- findLabel --- */
/* -------------------------------------------------------------------------- */
findLabel:
	Procedure Expose source.
	Parse Arg lable
	ptr = 0
	Do i = 1 to source.0
		If lable == source.i.1 Then Do
			ptr = i
			Leave
		End
	End
Return ptr


/* -------------------------------------------------------------------------- */
/* ----- List Parse Table --- DEBUGGING PURPOSES --------- listParseTable --- */
/* -------------------------------------------------------------------------- */
listParseTable:
	If Stream(LSTfile, 'C', 'OPEN WRITE REPLACE') = "READY:" Then Do
		Call listWrite Copies('-',80)
		Call listWrite "Parse Table listing for file" SRCfile
		Call listWrite Copies('-',80)
		Call listWrite " "
		Call listWrite "Label--- Mnem- Oprnd- SrcLin Addr-- Opc Opval InLen OrgLine------"
		Do instrPtr = 1 to source.0			/* find label and substitute adress - */
			line = ""
			line = line || Left(source.instrPtr.1, 8) || " "
			line = line || Left(source.instrPtr.2, 5) || " "
			line = line || Left(source.instrPtr.3, 6) || " "
			line = line || Left(source.instrPtr.4, 6) || " "
			If source.instrPtr.5 == ""
				Then addr = "    "
				Else addr = Right("000000"||d2x(source.instrPtr.5),6)
			line = line || addr || " "
			line = line || Left(source.instrPtr.6, 3) || " "
			line = line || Left(source.instrPtr.7, 5) || " "
			line = line || Left(source.instrPtr.8, 5) || " "
			line = line || Left(source.instrPtr.9, 72)

			Call listWrite line
		End
		Call listWrite " "
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- List listing and results -------------------------- list Results --- */
/* -------------------------------------------------------------------------- */
listResults:
	If Stream(LSTfile, 'C', 'OPEN WRITE REPLACE') = "READY:" Then Do
										/* ---------------------------------- */
										/* Print the assembled source file -- */
										/* ---------------------------------- */
		Call listWrite Copies('-',80)
		Call listWrite "Assembly listing for file" SRCfile
		Call listWrite Copies('-',80)
		Call listWrite " "
		Call listWrite "SrcLin -Addr- Op Oprnd   --- Source line ---"
		Do instrPtr = 1 to source.0			/* find label and substitute adress - */
			If source.instrPtr.5 == "" Then Do
				addrs = "      "
			End; Else Do
				addrs = Right("000000"||d2x(source.instrPtr.5),6)
			End
			Call listWrite  Right("      "||source.instrPtr.4,6)||" "|| ,	/* linenum -- */
				addrs											||" "|| ,	/* address -- */
				Left(source.instrPtr.6||"   ",3)				|| ,		/* opcode  -- */
				Left(source.instrPtr.7||"   ",5)				|| ,		/* operand value */
				"   " || source.instrPtr.9
		End
		Call listWrite " "
										/* ---------------------------------- */
										/* Print phase 1 output ------------- */
										/* ---------------------------------- */
		If phase1.0 > 0 Then Do
			Call listWrite Copies('-',80)
			Call listWrite "Phase 1 messages for" SRCfile
			Call listWrite Copies('-',80)
			Do i = 1 To phase1.0
				Call listWrite phase1.i
			End
		End; Else Do
			Call listWrite "Phase 1 parsing ended successfully"
		End
		Call listWrite " "
										/* ---------------------------------- */
										/* Print phase 2 output ------------- */
										/* ---------------------------------- */
		If phase2.0 > 0 Then Do
			Call listWrite Copies('-',80)
			Call listWrite "Phase 2 messages for" SRCfile
			Call listWrite Copies('-',80)
			Do i = 1 To phase2.0
				Call listWrite phase2.i
			End
		End; Else Do
			Call listWrite "Phase 2 parsing ended successfully"
		End
		Call listWrite " "
										/* ---------------------------------- */
										/* Print phase 3 output ------------- */
										/* ---------------------------------- */
		If phase3.0 > 0 Then Do
			Call listWrite Copies('-',80)
			Call listWrite "Phase 3 messages for" SRCfile
			Call listWrite Copies('-',80)
			Do i = 1 To phase3.0
				Call listWrite phase3.i
			End
		End; Else Do
			Call listWrite "Phase 3 parsing ended successfully"
		End
										/* ---------------------------------- */
										/* Final remarks -------------------- */
										/* ---------------------------------- */
		Call listWrite " "
		Call listWrite Copies('-',80)
		Call listWrite "End of assembly for file" SRCfile
		Call listWrite Copies('-',80)
		
		Say "   listing and results written to" LSTfile
		
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- Write a line to the listing file --------------------- listWrite --- */
/* -------------------------------------------------------------------------- */
listWrite:
	Parse Arg outLine
	lc = Lineout(LSTfile, outLine)
Return


/* -------------------------------------------------------------------------- */
/* ----- Initialize Memory ----------------------------------- initMemory --- */
/* -------------------------------------------------------------------------- */
initMemory:
	Procedure Expose memSize MEM.
	/* ----- Memory ----- */
	Do p = 0 to (memSize - 1)
		MEM.p = 0
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- Save Memory in hex format --------------------------- saveMemory --- */
/* -------------------------------------------------------------------------- */
saveMemory:
	lnum = 1; p = 0						/* save from location 0, count lines  */
	line = ""
	Say "Saving object file"
	memFile = OBJfile
	If Stream(memFile, 'C', 'OPEN WRITE REPLACE') = "READY:" Then Do
		Do p = 0 to memSize - 1
			If p > 0 Then Do
				If ((p // 32) == 0) Then Do
						lc = Lineout(memFile, line, lnum)
						lnum = lnum + 1
						line = ""
				End
			End
			line = line || Right("00"||d2x(MEM.p),2)
		End
		lc = Lineout(memFile, line, lnum)
		lnum = lnum + 1
		line = ""
		Say "   object save to file" memFile 
	End; Else Do
		memMsg = "Error opening object file" memFile
		Exit 8
	End

Return


/* -------------------------------------------------------------------------- */
/* ----- Check whether a value is bin or not ---------------------- isBin --- */
/* -------------------------------------------------------------------------- */
isBin:
	Parse Arg possibleBin
	rval = 1
	Do h = 1 to Length(possibleBin)
		If Index("01", Substr(possibleBin,h,1)) == 0 Then Do
			rval = 0
			Leave
		End
	End
Return rval


/* -------------------------------------------------------------------------- */
/* ----- Check whether a value is hex or not ---------------------- isHex --- */
/* -------------------------------------------------------------------------- */
isHex:
	Parse Arg possibleHex
	rval = 1
	Do h = 1 to Length(possibleHex)
		If Index("0123456789ABCDEF", Substr(possibleHex,h,1)) == 0 Then Do
			rval = 0
			Leave
		End
	End
Return rval


/* -------------------------------------------------------------------------- */
/* ----- Check whether a value is decimal or not ------------------ isDec --- */
/* -------------------------------------------------------------------------- */
isDec:
	Parse Arg possibleDec
	rval = 1
	Do h = 1 to Length(possibleDec)
		If Index("0123456789", Substr(possibleDec,h,1)) == 0 Then Do
			rval = 0
			Leave
		End
	End
Return rval


/* -------------------------------------------------------------------------- */
/* ----- Check whether a value is hex or not ------------------- checkHex --- */
/* -------------------------------------------------------------------------- */
isWhiteSpace:
	Parse Arg possibleWhiteSpace
	rval = 1
	isTab = D2C(9)
	Do h = 1 to Length(possibleWhiteSpace)
		If Index(" "||isTab, Substr(possibleWhiteSpace,h,1)) == 0 Then Do
			rval = 0
			Leave
		End
	End
Return rval


/* -------------------------------------------------------------------------- */
/* ----- Help info for control panel ------------------------- CPhelpInfo --- */
/* -------------------------------------------------------------------------- */
CPhelpInfo:
	Call screenHeader "SCEPSASM - Help information for the Control Panel"
	
	Call Display  3  3 color.brightwhite  "Help info for SCEPSASM" versionString
	Call Display  5  3 color.cyan  "Every highlighted word can be used as a command."
	Call Display  6  3 color.cyan  "Where appropriate you can add values"

	Call Display 19  3 color.cyan  "For more info see"
	Call Display 19 21 color.brightred  "https://github.com/GerardWassink/SCEPSASM"

	Call Display 21 1 color.brightwhite " "
	Call enterForMore
	
Return


/* -------------------------------------------------------------------------- */
/* ----- Display Screen Header ----------------------------- screenHeader --- */
/* -------------------------------------------------------------------------- */
screenHeader:
	Parse Arg headerLine

	If (Strip(headerLine) == "") 
		Then headerLine = "SCEPSASM - Simple CPU Emulator Program (Simple ASseMbler)"
	
	If Interactive == 1 Then Do
		"clear"
		Call Display  1  1 color.brightwhite Copies("-", 74) versionString
		position = (37 - Trunc(Length(headerLine)/2))
		Call Display  1 position color.brightwhite " " || headerLine || " "
	End; Else Do
		Say headerline " - " versionString
	End
Return



/* -------------------------------------------------------------------------- */
/* ----- Display one thing, encoding attributes and positions --- Display --- */
/* -------------------------------------------------------------------------- */
Display:
	Parse Arg row col atr txt
	lineOut = ""
	If ((row > 0) & (col > 0)) Then			/* Position? If yes, encode it ----- */
		lineOut = lineOut || ESC || row || ";" || col || "H"
	If (atr <> "") Then					/* attribute? If yes, encode it	---- */
		lineOut = lineOut || ESC || atr || "m"
	If (txt <> "") Then			/* Do we have text? If yes, encode it ------ */
		lineOut = lineOut || txt
	Do j = 1 To Length(lineOut)		/* Write encoded string to the screen -- */
		call charout ,substr(lineOut,j,1)
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- Reset screen attributes to default ----------------------- Reset --- */
/* -------------------------------------------------------------------------- */
Reset:
  Call Display "23 1" color.reset
Return


/* -------------------------------------------------------------------------- */
/* ----- Press enter for more routine ---------------------- enterForMore --- */
/* -------------------------------------------------------------------------- */
enterForMore:
	Say "----- "
	Say "Enter to continue"
	junk = linein()
Return


/* -------------------------------------------------------------------------- */
/* ----- Initialisation of global variables ------------------ Initialize --- */
/* -------------------------------------------------------------------------- */
Initialize:
	/* ----- Set default values for program parameters ----- */
	microCodeSteps	= 16					/* Max number of micro code steps */
	memorySize		= 65536					/* Size of memory in bytes ------ */
									/* File containing the engine parameters  */
	configFile		= "./config/scepsis.conf"
							/* File containing the instruction definitions -- */
	langDefFile		= "./config/scepsis.langdef"

					/* These can be overwritten in the config file ---------- */
	SRCfile			= "./myfirst/myfirst.sasm"		/* Example source file -- */
	OBJfile			= "./myfirst/myfirst.memory"	/* Example object file -- */
	LSTfile			= "./myfirst/myfirst.lst"		/* Example listing file - */
	
	asmDirectives	= "EQU DC DS BASE"		/* assembler Directives --------- */
	
	/* ----- Read language definition file ----- */
	instr.	= 0								/* stem to hold instructions */
	instr.0 = 0
	If Stream(langDefFile, 'C', 'OPEN READ') = "READY:" Then Do
		Call processLangDefFile
	End; Else Do
		Say "Error opening file" langDefFile
		Exit 8
	End


	/* ----- Read configuration file ----- */
	If Stream(configFile, 'C', 'OPEN READ') = "READY:" Then Do
		Call processConfigFile
	End; Else Do
		Say "Error opening file" configFile
		Exit 8
	End
	
	If (memorySize > 65536) Then Do
		Say "MemorySize specified in config file too large, maximum is 64K (65536 byes)"
		Exit 8
	End
	
	/* ----- Initialize Memory ----- */
	memSize = memorySize
	Call initMemory
	
Return


/* -------------------------------------------------------------------------- */
/* ----- Process the language definition file -------- processLangDefFile --- */
/* -------------------------------------------------------------------------- */
processLangDefFile:
	lnum = 0
	Do While Lines(langDefFile)
		line = Upper(Linein(langDefFile))
		lnum = lnum + 1
		Select
			When ( Substr(line,1,1) == "#") Then Nop
			When ( Strip(line) == "") Then Nop
			Otherwise Do
				Parse Var line opcd mnem argm '|' mcSteps '#' comment
				opcd = Strip(opcd)
				mnem = Strip(mnem)
				argm = Strip(argm)
				i = findOpcd(opcd)		/* yields position or 0 ------------- */
				If (i == 0) Then Do
					instr.0 = instr.0 + 1
					i = instr.0
				End
				instr.i.1   = opcd			/* store opcode ----------------- */
				instr.i.2   = mnem			/* store mnemonic --------------- */
				instr.i.2.1 = argm			/* store argument --------------- */
				instr.i.3.0 = 0				/* ptr to microde steps --------- */
				Do While Words(mcSteps) > 0	/* store ctl signals per step --- */
					Parse Var mcSteps mcStep '-' mcSteps
					instr.i.3.0 = instr.i.3.0 + 1
					s = instr.i.3.0			/* ptr to microde steps --------- */
					instr.i.3.s.0 = 0				/* ptr to ctl Signals --- */
					Do While Words(mcStep) > 0
						Parse Var mcStep ctlSig mcStep
						instr.i.3.s.0 = instr.i.3.s.0 + 1
						mcp = instr.i.3.s.0
						instr.i.3.s.mcp = Strip(ctlSig)
					End
				End
			End
		End
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- Find opcode in the instruction tabel ------------------ findOpcd --- */
/* -------------------------------------------------------------------------- */
findOpcd:
	Procedure Expose instr.
	Parse Arg oc .
	pos = 0
	Do p = 1 to instr.0
		If (oc == instr.p.1) Then Do
			pos = p
			Leave
		End
	End
Return pos


/* -------------------------------------------------------------------------- */
/* ----- Find mnemonic in the instruction table ---------------- findMnem --- */
/* -------------------------------------------------------------------------- */
findMnem:
	Procedure Expose instr.
	Parse Arg mn .
	pos = 0
	Do p = 1 to instr.0
		If (mn == instr.p.2) Then Do
			pos = p
			Leave
		End
	End
Return pos


/* -------------------------------------------------------------------------- */
/* ----- Read configuration file and process values --- processConfigFile --- */
/* -------------------------------------------------------------------------- */
processConfigFile:
	lnum = 0
	Do While Lines(configFile)
		line = Linein(configFile)
		lnum = lnum + 1
		Select
			When ( Substr(line,1,1) == "#") Then Nop
			When ( Strip(line) == "") Then Nop
			Otherwise Do
				Parse Var line keyword "=" rest
				Parse Var rest value "#" comment
				keyword = Strip(keyword)
				value = Strip(value)
				Select
					When keyword = "microCodeSteps"		Then microCodeSteps = value
					When keyword = "memorySize"			Then memorySize = value
					When keyword = "langDefFile"		Then langDefFile = value
					When keyword = "SRCfile"			Then SRCfile = CheckInputFileName(value)
					When keyword = "OBJfile"			Then OBJfile = CheckOutputFileName(value)
					When keyword = "LSTfile"			Then LSTfile = CheckOutputFileName(value)
					When keyword = "Animate"			Then NOP
					Otherwise Do
						Say "Invalid keyword" keyword "in config file line" lnum 
						Exit 8
					End
				End
			End
		End
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- End of program -------------------------------------- endProgram --- */
/* -------------------------------------------------------------------------- */
endProgram:
	If Interactive == 1 Then Call reset
	Say "SCEPSASM signing of - Goodbye"
Return


/* -------------------------------------------------------------------------- */
/* ----- Check Input file name ----------------------- CheckInputFileName --- */
/* -------------------------------------------------------------------------- */
CheckInputFileName:
	Procedure Expose errorMsg
	Parse arg filename
	If Stream(filename, 'C', 'OPEN READ') == "READY:" Then Do
		errorMsg = "file" filename "exists, ready to read"
	End; Else Do
		errorMsg = "file can not be found:" filename
		filename = ""
	End
Return filename


/* -------------------------------------------------------------------------- */
/* ----- Check Output file name --------------------- CheckOutputFileName --- */
/* -------------------------------------------------------------------------- */
CheckOutputFileName:
	Procedure Expose errorMsg
	Parse arg filename
	If Stream(filename, 'C', 'OPEN WRITE') == "READY:" Then Do
		errorMsg = "file" filename "ready to write"
	End; Else Do
		errorMsg = "file not available for writing:" filename
		filename = ""
	End
	retCod = Stream(filename, 'C', 'CLOSE')
Return filename


/* -------------------------------------------------------------------------- */
/* ----- Index of labels in this Rexx file ---------------------- indexMe --- */
/* -------------------------------------------------------------------------- */
indexMe:
	"clear"
	lnum = 0
	longest = 0
	srcFile = "./SCEPSASM.rexx"			/* Read our own source -------------- */
	If Stream(srcFile, 'C', 'OPEN READ') = "READY:" Then Do
		i = 1
		Do While Lines(srcFile)
			line = Strip(Linein(srcFile))
			lnum = lnum + 1
			If (line <> "") Then Do
				w = Word(line,1)
				If (Right(w, 1) == ":") Then Do	/* Do we have a label? ------ */
					If Length(w) > longest Then longest = Length(w)
					index.i.1 = Right("      "||lnum, 6)
					index.i.2 = w
					index.0 = i
					i = i + 1
				End
			End
		End
		status = Stream(srcFile, 'C', 'CLOSE')
		Do i = 1 to index.0
			If (Length(index.i.2)/2) <> Trunc(Length(index.i.2)/2) Then index.i.2 = index.i.2||" "
			Say index.i.2 Copies(" .", Trunc((longest - Length(index.i.2)) / 2 )) index.i.1 
		End
		Say ""
		Call enterForMore
	End; Else Do
		srcMsg = "Error opening file" srcFile
		Exit 8
	End
Return

