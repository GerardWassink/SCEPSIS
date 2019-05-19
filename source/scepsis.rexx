#!/usr/bin/rexx
/* Rexx */

/* ---------------------------------------------------------------- */
/* Program name:    scepsis.rexx                                    */
/* Author:          Gerard Wassink                                  */
/* Date:            May 2019                                        */
/* Version:         0.1                                             */
/* Purpose:         Teach peeople about simple CPU's and microcode  */
/* ---------------------------------------------------------------- */


/* -------------------------------------------------------------------------- */
/* ----- Initialize screen control and color Control values ----------------- */
/* -------------------------------------------------------------------------- */
	color.black = 30; color.red     = 31; color.green = 32; color.yellow = 33
	color.blue  = 34; color.magenta = 35; color.cyan  = 36; color.white  = 37
	color.brightblack  = 90; color.brightred    = 91; color.brightgreen   = 92
	color.brightyellow = 93; color.brightblue   = 94; color.brightmagenta = 95
	color.brightcyan   = 96; color.brightwhite  = 97
	color.reset = 0
	ESC = d2c(27) || "["
	LF = d2c(10)



Main:
	Call Initialize

	choice = ""
	errorMsg = ""
	Do Until choice = "X"
		choice = mainMenu(errorMsg)
		errorMsg = ""
		Select
			When choice == "LH" Then	Call listHardware
			When choice == "LC" Then	Call listComponents
			When choice == "LS" Then	Call listControlSignals
			When choice == "LM" Then	Call listMemory
			
			When choice == "IM" Then	Do
				Call initMemory
				errorMsg = "Memory initialized"
			End
			
			When choice == "CP" Then	Call controlPanel
			
			When choice == "X" Then	Leave

			Otherwise
				errorMsg = "Invalid choice: " || choice
			
		End
	End
	Call endProgram
Exit


/* -------------------------------------------------------------------------- */
/* ----- Show main Menu and return choice ---------------------- mainMenu --- */
/* -------------------------------------------------------------------------- */
mainMenu:
	Parse Arg message
	
	Call screenHeader

	Call Display  2 1 color.brightwhite "===> "
	Call Display  2 6 color.brightred "___________________________________________________________________________"

	Call Display  5  3 color.brightwhite "LH"
	Call Display  5  6 color.brightcyan  "List hardware"

	Call Display  6  3 color.brightwhite "LC"
	Call Display  6  6 color.brightcyan  "List components"

	Call Display  7  3 color.brightwhite "LS"
	Call Display  7  6 color.brightcyan  "List Control Signals"

	Call Display  8  3 color.brightwhite "LM"
	Call Display  8  6 color.brightcyan  "List memory"

	Call Display 18  3 color.brightwhite "X"
	Call Display 18  6 color.brightcyan  "End program"


	Call Display  5 60 color.brightwhite "CP"
	Call Display  5 63 color.brightcyan  "Control Panel"


	Call Display  5 32 color.brightwhite "IM"
	Call Display  5 35 color.brightcyan  "Init Memory"

	
	If Strip(message) <> "" Then Do
		Call Display 21 1 color.brightwhite message
	End
	
	Call Display  2 6 color.brightwhite
	
	choice = Upper(linein())
Return choice


/* -------------------------------------------------------------------------- */
/* ----- Control the machine functions --------------------- controlPanel --- */
/* -------------------------------------------------------------------------- */
controlPanel:
	choice = ""
	errorMsg = ""
	Do Until choice = "M"
		choice = Upper(strip(controlPanelDisplay(errorMsg)))
		Parse Var choice command value
		errorMsg = ""
		Select
			When command == "PCT" Then	Do
				If isHex(value) Then comp_PCT = x2d(value)
				Else errorMsg = "Value for PCT not HEXa-decimal"
			End
			When command == "MAR" Then	Do
				If isHex(value) Then comp_MAR = x2d(value)
				Else errorMsg = "Value for MAR not HEXa-decimal"
			End
			When command == "INR" Then	Do
				If isHex(value) Then comp_INR = x2d(value)
				Else errorMsg = "Value for INR not HEXa-decimal"
			End

			When command == "INP" Then	Do
				If isHex(value) Then comp_INP = x2d(value)
				Else errorMsg = "Value for INP not HEXa-decimal"
			End
			When command == "OUT" Then	Do
				If isHex(value) Then comp_OUT = x2d(value)
				Else errorMsg = "Value for OUT not HEXa-decimal"
			End

			When command == "REGA" Then	Do
				If isHex(value) Then comp_REGA = x2d(value)
				Else errorMsg = "Value for REGA not HEXa-decimal"
			End
			When command == "REGB" Then	Do
				If isHex(value) Then comp_REGB = x2d(value)
				Else errorMsg = "Value for REGB not HEXa-decimal"
			End
			When command == "STC" Then	Do
				If isHex(value) Then comp_STC = x2d(value)
				Else errorMsg = "Value for STC not HEXa-decimal"
			End
			
			When command == "MEM" Then	Do
				Parse Var value adr val .
				If isHex(adr) Then Do
					If isHex(val) Then Do
						adr = x2d(adr)
						val = x2d(val)
						RAM.adr = val
					End; Else Do
						errorMsg = "Value for MEM value not HEXa-decimal"
					End
				End; Else Do
					errorMsg = "Value for MEM address not HEXa-decimal"
				End
			End
			
			When choice == "X" Then	Do
				choice = ""
				Leave
			End

			Otherwise
				errorMsg = "Invalid choice: " || choice
			
		End
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- Check whether a vlue is hex or not -------------------- checkHex --- */
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
/* ----- Display the machine functions -------------- controlPanelDisplay --- */
/* -------------------------------------------------------------------------- */
controlPanelDisplay:
	Parse Arg message
	
	Call screenHeader "SCEPSIS Control Panel"

	Call Display  2 1 color.brightwhite "===> "
	Call Display  2 6 color.brightred "___________________________________________________________________________"

	Call Display  5  3 color.brightwhite "Components --------------"

	Call Display  7  3 color.brightwhite "PCT"
	Call Display  7  8 color.brightcyan  Right("00"||D2X(comp_PCT),2)

	Call Display  7 12 color.brightwhite "MAR"
	Call Display  7 17 color.brightcyan  Right("00"||D2X(comp_MAR),2)

	Call Display  7 21 color.brightwhite "INR"
	Call Display  7 26 color.brightcyan  Right("00"||D2X(comp_INR),2)


	Call Display  8  3 color.brightwhite "INP"
	Call Display  8  8 color.brightcyan  Right("00"||D2X(comp_INP),2)

	Call Display  8 12 color.brightwhite "OUT"
	Call Display  8 17 color.brightcyan  Right("00"||D2X(comp_OUT),2)


	Call Display  9  3 color.brightwhite "REGA"
	Call Display  9  8 color.brightcyan  Right("00"||D2X(comp_REGA),2)

	Call Display 10  3 color.brightwhite "REGB"
	Call Display 10  8 color.brightcyan  Right("00"||D2X(comp_REGB),2)


	Call Display 12  3 color.brightwhite "STC"
	Call Display 12  8 color.brightcyan  Right("00"||D2X(comp_STC),2)

	Call Display  7  3 color.brightwhite "PCT"
	Call Display  7  8 color.brightcyan  Right("00"||D2X(comp_PCT),2)


	Call Display  5 43 color.brightwhite "Control Signals ---------"

	Call Display  7 43 color.brightwhite "CE"
	Call Display  7 48 color.brightcyan  cs_CE

	Call Display  7 52 color.brightwhite "HLT"
	Call Display  7 57 color.brightcyan  cs_HLT

	Call Display  8 43 color.brightwhite "INPO"
	Call Display  8 48 color.brightcyan  cs_INPO
	
	Call Display  8 52 color.brightwhite "OUTI"
	Call Display  8 57 color.brightcyan  cs_OUTI

	Call Display  9 43 color.brightwhite "INRI"
	Call Display  9 48 color.brightcyan  cs_INRI

	Call Display  9 52 color.brightwhite "INRO"
	Call Display  9 57 color.brightcyan  cs_INRO

	Call Display 10 43 color.brightwhite "MARI"
	Call Display 10 48 color.brightcyan  cs_MARI

	Call Display 10 52 color.brightwhite "MARO"
	Call Display 10 57 color.brightcyan  cs_MARO

	Call Display 11 43 color.brightwhite "PCTI"
	Call Display 11 48 color.brightcyan  cs_PCTI

	Call Display 11 52 color.brightwhite "PCTO"
	Call Display 11 57 color.brightcyan  cs_PCTO

	Call Display 12 43 color.brightwhite "RAMI"
	Call Display 12 48 color.brightcyan  cs_RAMI

	Call Display 12 52 color.brightwhite "RAMO"
	Call Display 12 57 color.brightcyan  cs_RAMO

	Call Display 13 43 color.brightwhite "RGAI"
	Call Display 13 48 color.brightcyan  cs_RGAI

	Call Display 13 52 color.brightwhite "RGAO"
	Call Display 13 57 color.brightcyan  cs_RGAO

	Call Display 14 43 color.brightwhite "RGBI"
	Call Display 14 48 color.brightcyan  cs_RGBI

	Call Display 14 52 color.brightwhite "RGBO"
	Call Display 14 57 color.brightcyan  cs_RGBO


	Call Display 18  3 color.brightwhite "X"
	Call Display 18  6 color.brightcyan  "Back to Main"

	
	If Strip(message) <> "" Then Do
		Call Display 21 1 color.brightwhite "ERROR" message
	End
	
	Call Display  2 6 color.brightwhite
	
	choice = Strip(Upper(linein()))
	
Return choice


/* -------------------------------------------------------------------------- */
/* ----- List Memory in hex dump format----------------------- listMemory --- */
/* -------------------------------------------------------------------------- */
listMemory:
	Call screenHeader

	Say "----- List of Memory -----"
	Say ""
	p = 0
	line = Right("0000"||d2x(p),4) || " : "
	Do p = 0 to ramSize - 1
		If p > 0 Then Do
			Select
				When ((p // 32) == 0) Then Do
					say line 
					line = Right("0000"||d2x(p),4) || " : "
				End
				When ((p // 16) == 0) Then line = line || "  -  "
				When ((p //  8) == 0) Then line = line || "  "
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
    Say "STC - STep CounTer"
	Say ""
	Call enterForMore
Return


/* -------------------------------------------------------------------------- */
/* ----- List available Control Signals -------------- listControlSignals --- */
/* -------------------------------------------------------------------------- */
listControlSignals:
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
/* ----- Display Screen Header ----------------------------- screenHeader --- */
/* -------------------------------------------------------------------------- */
screenHeader:
	Parse Arg headerLine
	"clear"
	Call Display  1  1 color.brightwhite "--------------------------------------------------------------------------------"
	If (Strip(headerLine) == "") Then headerLine = "SCEPSIS - Simple CPU Emulator Program (Student Instruction System)"
	position = (40 - Trunc(Length(headerLine)/2))
	Call Display  1 position color.brightwhite " " || headerLine || " "
Return



/* -------------------------------------------------------------------------- */
/* ----- Display one thing, encoding attributes and positions --- Display --- */
/* -------------------------------------------------------------------------- */
Display:
	Parse Arg line
	Parse Var line row col atr txt
	lineOut = ""
	
						/* Do we have a position? If yes, encode it		--- */
	If row > 0 and col > 0 Then
		lineOut = lineOut || ESC || row || ";" || col || "H"
	
						/* Do we have an attribute? If yes, encode it	--- */
	If atr <> "" Then
		lineOut = lineOut || ESC || atr || "m"
	
						/* Do we have text? If yes, encode it			--- */
	If txt <> "" Then
		lineOut = lineOut || txt
	
						/* Write encoded string to the screen			--- */
	Do j = 1 To Length(lineOut)
		call charout ,substr(lineOut,j,1)
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- Reset screen attributes to default at the bottom of the screen	----- */
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
	/* ----- Available Control Signals ----- */
	ctlSig.0 = 0
	Call addCtlSig("CE Counter Enable, the program counter advances to the next instruction")
	Call addCtlSig("HLT HALT the processor")
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
	
	
	/* ----- Set default values for Components ----- */
	comp_INP  = 0
	comp_INR  = 0
	comp_MAR  = 0
	comp_OUT  = 0
	comp_PCT  = 0
	comp_REGA = 0
	comp_REGB = 0
	comp_STC  = 0
	
	
	/* ----- Set default values for Control Signals ----- */
	cs_CE   = 0
	cs_HLT  = 0
	cs_INPO = 0
	cs_INRI = 0
	cs_INRO = 0
	cs_MARI = 0
	cs_MARO = 0
	cs_OUTI = 0
	cs_PCTI = 0
	cs_PCTO = 0
	cs_RAMI = 0
	cs_RAMO = 0
	cs_RGAI = 0
	cs_RGAO = 0
	cs_RGBI = 0
	cs_RGBO = 0
	
	
	/* ----- Set default values for program parameters ----- */
	microCodeSteps	= 8						/* Max number of micro code steps */
	memorySize		= 256					/* Size of memory in bytes*/
	configFile		= "config/scepsis.conf"		/* File containing the engine parameters */
	langDefFile		= "config/scepsis.langdef"	/* File containing the instruction definitions */
	
	/* ----- Read configuration files ----- */
	If Open(configFile, 'R') Then Do
		Call processConfigFile
	End; Else Do
		Say "Error opening file" configFile
		Exit 8
	End

	/* ----- Memory ----- */
	ramSize = memorySize
	Do p = 0 to (ramSize - 1)
		RAM.p = p
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
/* ----- Read configuration file and process value ---- processConfigFile --- */
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
	Procedure Expose ramSize RAM.
	/* ----- Memory ----- */
	Do p = 0 to (ramSize - 1)
		RAM.p = 0
	End
Return


/* -------------------------------------------------------------------------- */
/* ----- End of program -------------------------------------- endProgram --- */
/* -------------------------------------------------------------------------- */
endProgram:
	Call reset
	Say "goodbye"
Return

