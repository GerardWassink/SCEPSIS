#!/usr/bin/rexx
/* Rexx */

/* -------------------------------------------------------------------------- */
/* Program name:    scepsasm.rexx                                             */
/* Author:          Gerard Wassink                                            */
/* Date:            June 2019                                                 */
/* Version:         1.2.2                                                      */
/* Purpose:         Teach peeople about simple CPU's and microcode            */
/*                                                                            */
/* History:                                                                   */
/*   v0.1     Copies SCEPSIS soucre to make use of it's parsing routines      */
/*                                                                            */
/* -------------------------------------------------------------------------- */


/* -------------------------------------------------------------------------- */
/* ----- Initialize screen control and color Control values ----------------- */
/* -------------------------------------------------------------------------- */
Globals:
	versionString = "1.2.2"
	
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
	Call Initialize

	choice = ""
	errorMsg = ""
	Do Until choice = "X"
		Call controlPanelDisplay(errorMsg)
		choice = Strip(linein())					/* get next command ----- */
		Parse Var choice command value
		command = Upper(command)
		If (choice =="") Then choice = "S"
		errorMsg = ""
		Select

			/* -------------------------------------------------------------- */
			/* ----- Memory commands ---------------------------------------- */
			/* -------------------------------------------------------------- */
			When command == "INIT"  Then	Do
				Call initMemory
				errorMsg = "Memory initialized"
			End
			When command == "SAVE"  Then	Do
				Call saveMemory
				errorMsg = "Memory saved"
			End
			When command == "LOAD"  Then	Do
				Call loadMemory
				errorMsg = "Memory loaded"
			End
			
			/* -------------------------------------------------------------- */
			/* ----- File commands ------------------------------------------ */
			/* -------------------------------------------------------------- */
			When command == "SRC" Then	SRCfile = CheckInputFileName(value)
			When command == "OBJ" Then	OBJfile = CheckOutputFileName(value)

			/* -------------------------------------------------------------- */
			/* ----- Assembler commands ------------------------------------- */
			/* -------------------------------------------------------------- */
			When command == "ASM" Then	Call Assemble
			
			/* -------------------------------------------------------------- */
			/* ----- Miscelaneous commands ---------------------------------- */
			/* -------------------------------------------------------------- */
			When command == "MEM" Then	Call handleMemory
			When command == "INS" Then	Call handleInstructions
			When command == "?"   Then	Call CPhelpInfo
			When command == "IX"  Then	Call indexMe	/* hidden feature --- */
			When command == "X"   Then	Do
				command = ""
				Leave
			End
			Otherwise Do
				errorMsg = "Invalid command: " || choice 
			End
		End
	End

	Call endProgram

Exit


/* -------------------------------------------------------------------------- */
/* ----- Display the machine functions -------------- controlPanelDisplay --- */
/* -------------------------------------------------------------------------- */
controlPanelDisplay:
	Parse Arg message
	
	Call screenHeader "SCEPSASM - Simple CPU Emulator Program (Student Instruction System)"

	Call Display  2  1 color.brightwhite "===> "
	Call Display  2  6 color.brightred "___________________________________________________________________________"


	Call Display  4  3 color.cyan		 "File names"
	Call Display  5  3 color.cyan		 "SRC file name:"
	Call Display  5 18 color.brightcyan  Left(SRCfile||"__________________________________________________",50)
	Call Display  6  3 color.cyan		 "OBJ file name:"
	Call Display  6 18 color.brightcyan  Left(OBJfile||"__________________________________________________",50)
	
	
	Call Display 13  3 color.brightwhite "Commands ---------------"
	Call Display 14  3 color.brightwhite "SRC"
	Call Display 14  7 color.brightcyan  "Enter name of source file"
	Call Display 15  3 color.brightwhite "OBJ"
	Call Display 15  7 color.brightcyan  "Enter name of object file"
	Call Display 16  3 color.brightwhite "ASM"
	Call Display 16  7 color.brightcyan  "Assemble the source file"

	Call Display 13 33 color.brightwhite "------------------------"
	Call Display 14 33 color.brightwhite "MEM"
	Call Display 14 37 color.brightcyan  "Handle Memory"
	Call Display 15 33 color.brightwhite "INS"
	Call Display 15 37 color.brightcyan  "Handle Instructions"
	Call Display 16 33 color.brightwhite "INIT SAVE LOAD"
	Call Display 16 48 color.brightcyan  "Memory"

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
	
	Call screenHeader "SCEPSASM - Generating executable from source file"
	Call Display  3  1 color.cyan " "
	
	Call readParseSource				/* Result is formal parsed table ---- */
	
	If (parsePhase == "OK") Then Do
		Say " "
		Say "Parse phase" parsePhase
		Say " "
	End; Else Do	
		Say " "
		Say "Parse phase" parsePhase
		Say " "
	End
	
	Call enterForMore
Return


/* -------------------------------------------------------------------------- */
/* ----- Read and parse the source file ----------------- readParseSource --- */
/* -------------------------------------------------------------------------- */
readParseSource: 
	Say "Reading and parsing source file"
	Say ""

	lnum = 0
	parsePhase = "OK"

	c = Stream(SRCfile, 'C', 'POSITION =')
	c = Stream(SRCfile, 'C', 'OPEN READ')
	
	
	/* -------------------------------------------------------------------------- */
	/* Create array that contains the assembly code as follows: ----------------- */
	/*   source.0	-	number of instructions ---------------------------------- */
	/*   source.n.1	-	label if present, else "" ------------------------------- */
	/*   source.n.2	-	instruction mnemonic ------------------------------------ */
	/*   source.n.3	-	operand when present, else "" --------------------------- */
	/*   source.n.4	-	instruction line nummer in source file ------------------ */
	/*   source.n.5	-	instruction address ------------------------------------- */
	/*   source.n.6	-	instruction opcode -------------------------------------- */
	/*   source.n.7	-	instruction operand value if present, else "" ----------- */
	/*   source.n.8	-	instruction length -------------------------------------- */
	/* -------------------------------------------------------------------------- */
	source. = ""
	source.0 = 0
	Do While Lines(SRCfile)
		line = Upper(Linein(SRCfile))
		lnum = lnum + 1
		asmMsg = ""
		Select
			When ( Substr(line,1,1) == "#") Then Nop
			When ( Strip(line) == "") Then Nop
			Otherwise Do
				Parse Var line line '#' comment		/* leave comment out ---- */
				source.0 = source.0 + 1
				instrPtr = source.0
				labl = ""
				If isWhiteSpace(Left(line,1))
					Then Parse Var line mnem oprnd junk
					Else Parse Var line labl mnem oprnd junk
				labl  = Strip(labl)
				mnem  = Strip(mnem)
				oprnd = Strip(oprnd)
				junk  = Strip(junk)

				If (labl <> "") Then Do
					source.instrPtr.1 = labl
				End
								
				source.instrPtr.2 = mnem		/* store mnemonic ----------- */
				source.instrPtr.3 = oprnd		/* store operand ------------ */
				source.instrPtr.4 = lnum		/* store line number--------- */
				source.instrPtr.5 = 0			/* zero to address (for now)  */
				source.instrPtr.7 = ""			/* store operand value ------ */
				If (oprnd == "") Then Do
					source.instrPtr.8 = 1		/* store instruction length - */
				End; Else Do
					source.instrPtr.8 = 2		/* store instruction length - */
				End
				
				i = findMnem(mnem)		/* yields position or 0 ------------- */
				If (i > 0) Then Do
					source.instrPtr.6 = instr.i.1	/* store opcode ------------- */
				End; Else Do
					asmMsg =  "Error: Unknown instruction '"||mnem||"' found in source line" lnum
					parsePhase = "NOK"
				End
				
				If ((instr.i.2.1 == "") & (oprnd <> "")) Then Do
					asmMsg =  "Error: unexpected operand '"||oprnd||"' found in source line" lnum
					parsePhase = "NOK"
				End
				
				If junk <> "" Then Do
					asmMsg = "Error: Superfluous '"||junk||"' found in source line" lnum
					parsePhase = "NOK"
				End
				
				Say Right("000000"||source.instrPtr.4,6) " "	|| ,
					Left(source.instrPtr.6||"   ",3)			|| ,
					Left(source.instrPtr.7||"   ",5)			|| ,
					Left(source.instrPtr.1||"         ",9)		|| ,
					Left(source.instrPtr.2||"     ",5)			|| ,
					Left(source.instrPtr.3||"         ",9)		|| ,
					asmMsg
			End
		End
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- Handle Memory related stuff ----------------------- handleMemory --- */
/* -------------------------------------------------------------------------- */
handleMemory:
	memChoice = ""
	memMsg = ""
	Do Until memChoice = "X"
		memChoice = Upper(strip(listMemory(memMsg)))
		Parse Var memChoice command value
		memMsg = ""

		Select
			/* -------------------------------------------------------------- */
			/* ----- Memory commands ---------------------------------------- */
			/* -------------------------------------------------------------- */
			When command == "M" Then	Do		/* fill memory with values -- */
				Parse Var value adr vals
				If isHex(adr) Then Do
					adr = x2d(adr)
					Do i = 1 To Words(vals)
						Parse Var vals val vals
						val = Strip(val)
						If isHex(val) Then Do
							val = x2d(val)
							If (adr <= memSize) Then Do
								If (val <= 255) Then Do
									MEM.adr = val
									memMsg = "Value(s) entered into memory"
									adr = adr + 1	/* in case there's more   */
								End; Else Do
									memMsg = "Value for MEM:" d2x(val) "value > 255"
								End
							End; Else Do
								memMsg = "Value for MEM address > memSize"
							End
						End; Else Do
							memMsg = "Value for MEM value not HEXa-decimal"
						End
					End
				End; Else Do
					memMsg = "Value for MEM address not HEXa-decimal"
				End
			End

			When command == "INIT"  Then	Do
				Call initMemory
				memMsg = "Memory initialized"
			End

			When command == "SAVE"  Then	Do
				Call saveMemory
			End

			When command == "LOAD"  Then	Do
				Call loadMemory
			End

			Otherwise Do
				memMsg = "Invalid choice: " || memChoice 
			End
		End
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- List Memory in hex dump format----------------------- listMemory --- */
/* -------------------------------------------------------------------------- */
listMemory:
	Call screenHeader "SCEPSASM - memory display"
	
	Call Display  2  1 color.brightwhite "===> "
	Call Display  2  6 color.brightred "___________________________________________________________________________"
	
							/* --- Display contents of memory in neat ------- */
							/* ---   little groups, 32 bytes per row -------- */
	lnum = 5; p = 0
	line = Right("0000"||d2x(p),4) || ": "
	Do p = 0 to memSize - 1
		If p > 0 Then Do
			Select
				When ((p // 32) == 0) Then Do
					Call Display lnum 2 color.cyan line
					lnum = lnum + 1
					line = Right("0000"||d2x(p),4) || ": "
				End
				When ((p // 16) == 0) Then line = line || " - "
				When ((p //  8) == 0) Then line = line || " "
				When ((p //  4) == 0) Then line = line || " "
				Otherwise Nop
			End
		End
		line = line || Right("00"||d2x(MEM.p),2)
	End
	Call Display lnum 2 color.cyan line
	lnum = lnum + 1


	Call Display 20  3 color.brightwhite "X"
	Call Display 20  5 color.brightcyan "return"
	Call Display 20 13 color.brightwhite "M"
	Call Display 20 15 color.brightcyan "{adr] {val ...}"
	Call Display 20 32 color.brightwhite "INIT"
	Call Display 20 37 color.brightwhite "SAVE"
	Call Display 20 42 color.brightwhite "LOAD"
	Call Display 20 47 color.brightcyan  "Memory"
		
	
	If Strip(memMsg) <> "" Then Do
		Call Display 21 1 color.brightwhite "===>" memMsg
	End
	Call Display  2 6 color.brightwhite
	memChoice = Strip(Upper(linein()))
Return memChoice


/* -------------------------------------------------------------------------- */
/* ----- Save Memory in hex format --------------------------- saveMemory --- */
/* -------------------------------------------------------------------------- */
saveMemory:
	lnum = 1; p = 0						/* save from location 0, count lines  */
	line = ""
	memFile = "./SCEPSIS.memory"
	If Stream(memFile, 'C', 'OPEN WRITE') = "READY:" Then Do
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
		memMsg = "Wrote" lnum "lines to" memFile
	End; Else Do
		memMsg = "Error opening file" memFile
		Exit 8
	End

Return


/* -------------------------------------------------------------------------- */
/* ----- Load Memory in hex format --------------------------- loadMemory --- */
/* -------------------------------------------------------------------------- */
loadMemory:
	lnum = 0; p = 0						/* load from location 0, count lines  */
	line = ""
regel = ""
	memFile = "./SCEPSIS.memory"
	If Stream(memFile, 'C', 'OPEN READ') = "READY:" Then Do
		Do While Lines(memFile)
			line = Strip(Upper(Linein(memFile)))
			lnum = lnum + 1
			llen = Length(line)
			If (llen > 0) Then Do
				Do lp = 1 To llen By 2
					MEM.p = X2D(Substr(line, lp,2))
					p = p + 1
				End
			End
		End
		memMsg = "Loaded" lnum "lines from" memFile
	End; Else Do
		memMsg = "Error opening file" memFile
		Exit 8
	End

Return


/* -------------------------------------------------------------------------- */
/* ----- Check whether a value is bin or not ------------------- checkBin --- */
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
/* ----- Check whether a value is hex or not ------------------- checkHex --- */
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
/* --------------------------------------------------- handleInstructions --- */
/* -------------------------------------------------------------------------- */
/* ----- Show Instructions and display individual ones ---------------------- */
/* -------------------------------------------------------------------------- */
handleInstructions:
	lstIChoice = ""
	lstIMsg = ""
	liMsg = ""
	Do Until lstIChoice = "X"
		lstIChoice = Upper(strip(listInstructions(lstIMsg)))
		Parse Var lstIChoice command value
		lstIMsg = ""

		Select
			/* -------------------------------------------------------------- */
			/* ----- Instruction commands ----------------------------------- */
			/* -------------------------------------------------------------- */
			When command == "D" Then Do
				Parse Var value opc .
				opc = Strip(opc)
				optr = findOpcd(Strip(opc))
				If (optr == 0) Then Do
					lstIMsg = "Opcode" opc "does not exist (yet)"
				End; Else Do
					Call listInstruction(optr)
				End
			End
			
			Otherwise Do
				lstImMsg = "Invalid choice: " || lstIChoice 
			End
			
		End
		
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- List all instructions ------------------------- listInstructions --- */
/* -------------------------------------------------------------------------- */
listInstructions:
	Call screenHeader "SCEPSASM - Instructions"
	Call Display  2  1 color.brightwhite "===> "
	Call Display  2  6 color.brightred "___________________________________________________________________________"

	Call Display  5  3 color.brightwhite "List of opcodes and instructions"
	liLine = ""
	scrLine = 6
	Do i = 1 to instr.0
		liLine = liLine || Left(instr.i.1||"  ",2) || " " || Left(instr.i.2||"    ", 4) || " " || Left(instr.i.2.1||"  ", 2) || "   "
		If ((i //  6) == 0) Then Do
			Call Display scrLine 3 color.cyan liLine
			scrLine = scrLine + 1
			liLine = ""
		End
	End
	If (liLine <> "") Then Call Display scrLine 3 color.cyan liLine
	scrLine = scrLine + 1
	
	Call Display 20  3 color.brightwhite "X"
	Call Display 20  5 color.brightcyan "return"
	Call Display 20 13 color.brightwhite "D"
	Call Display 20 15 color.brightcyan "{opcode}"

	If Strip(lstIMsg) <> "" Then Do
		Call Display 21 1 color.brightwhite "===>" lstIMsg
	End
	Call Display  2 6 color.brightwhite
	lstIChoice = Strip(Upper(linein()))
Return lstIChoice


/* -------------------------------------------------------------------------- */
/* ----- List one instruction --------------------------- listInstruction --- */
/* -------------------------------------------------------------------------- */
listInstruction:
	Parse Arg pointer .
	Call screenHeader "SCEPSASM - breakup of the " || instr.pointer.2 || " Instruction"
	
	Call Display  2  1 color.brightwhite "===> "
	Call Display  2  6 color.brightred "___________________________________________________________________________"
	
	Call Display  5  3 color.brightwhite "OPC  Ins Arg Stp  Control Signals"
	liLine = instr.pointer.1 "-" left(instr.pointer.2||"    ",5) || Left(instr.pointer.2.1||"   ",3)
	scrLine = 6
	Call Display scrLine 3 color.brightwhite liLine
	Do step = 1 to instr.pointer.3.0
		liLine2 = step " "
		Do cs = 1 To instr.pointer.3.step.0
			liLine2 = liLine2 instr.pointer.3.step.cs
		End
		Call Display scrLine 17 color.cyan liLine2
		scrLine = scrLine + 1
	End
	scrLine = scrLine + 1
	
	If Strip(liMsg) <> "" Then Do
		Call Display 21 1 color.brightwhite "===>" liMsg
	End
	
	Call Display 21 6 color.brightwhite
	Call enterForMore
Return


/* -------------------------------------------------------------------------- */
/* ----- Help info for control panel ------------------------- CPhelpInfo --- */
/* -------------------------------------------------------------------------- */
CPhelpInfo:
	Call screenHeader "SCEPSASM - Help information for the Control Panel"
	
	Call Display  3  3 color.brightwhite  "Help info for SCEPSASM" versionString
	Call Display  5  3 color.cyan  "Every highlighted word can be used as a command."
	Call Display  6  3 color.cyan  "Where appropriate you can add values:"
	Call Display  7  3 color.cyan  "- for 'components' it's a hexadecimal value from 00 to FF"
	Call Display  8  3 color.cyan  "- for 'control signals' it's a binary bit value (0 or 1)"
	Call Display  9  3 color.cyan  "Commands do not have parameters here"

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
	"clear"
	Call Display  1  1 color.brightwhite Copies("-", 74) versionString
	If (Strip(headerLine) == "") 
		Then headerLine = "SCEPSASM - Simple CPU Emulator Program (Simple ASseMbler)"
	position = (37 - Trunc(Length(headerLine)/2))
	Call Display  1 position color.brightwhite " " || headerLine || " "
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
	Say ""
	Say "Enter to continue"
	junk = linein()
Return


/* -------------------------------------------------------------------------- */
/* ----- Initialisation of global variables ------------------ Initialize --- */
/* -------------------------------------------------------------------------- */
Initialize:
	/* ----- Set default values for program parameters ----- */
	microCodeSteps	= 7						/* Max number of micro code steps */
	memorySize		= 256					/* Size of memory in bytes*/
	configFile		= "./config/SCEPSIS.conf"		/* File containing the engine parameters */
	langDefFile		= "./config/SCEPSIS.langdef"	/* File containing the instruction definitions */
	
	SRCfile			= "./myfirst.sasm"		/* Example source file */
	OBJfile			= "./myfirst.memory"	/* Example source file */
	
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
	
	If (memorySize > 256) Then Do
		Say "MemorySize specified in config file too large, maximum is 256 byes)"
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
					Otherwise Do
						Say "Invalid keyword" keyword "in cofig file line" lnum 
						Exit 8
					End
				End
			End
		End
	End
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
/* ----- End of program -------------------------------------- endProgram --- */
/* -------------------------------------------------------------------------- */
endProgram:
	Call reset
	Say "SCEPSASM signing of - Goodbye"
Return


/* -------------------------------------------------------------------------- */
/* ----- Check Input file name ----------------------- CheckInputFileName --- */
/* -------------------------------------------------------------------------- */
CheckInputFileName:
	Procedure Expose errorMsg
	Parse arg filename
	If Stream(filename, 'C', 'OPEN READ') = "READY:" Then Do
		errorMsg = "File" filename "exists, ready to read"
	End; Else Do
		errorMsg = "File can not be found:" filename
	End
Return filename


/* -------------------------------------------------------------------------- */
/* ----- Check Output file name --------------------- CheckOutputFileName --- */
/* -------------------------------------------------------------------------- */
CheckOutputFileName:
	Procedure Expose errorMsg
	Parse arg filename
	If Stream(filename, 'C', 'OPEN WRITE') = "READY:" Then Do
		errorMsg = "File" filename "ready to write"
	End; Else Do
		errorMsg = "File can not be found:" filename
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

