/    *****************************************************************
//    ** COMPANY NAME:  HPA Systems
//    *****************************************************************
//    ** Application......:
//    **
//    ** Module Name......: RichFunctions1.pas
//    ** Program Name.....: 
//    ** Program Description: Library of Procedures/Functions for various things.
//    **
//    **
//    **
//    **
//    **
//    **
//    **
//    ** Documentation....:
//    ** Called By........:
//    ** Sequence.........:
//    ** Programs Called..:
//    **
//    ** Create Options...:
//    ** Object Owner.....:
//    ** CREATED By.......:  RICHARD KNECHTEL
//    ** Creation Date....:  02/07/2002
//    **
//    **
//    *****************************************************************
//    *
//    *     INPUT FILES:
//    *
//    *    UPDATE FILES:
//    *
//    *****************************************************************
//    *
//    *                          PARAMETERS
//    *   ------------------------------------------------------------
//    *
//    *   PARAMETERS PASSED TO THIS PROGRAM:
//    *
//    *      NAME        DESCRIPTION
//    *   ----------   -----------------------------------------------
//    *      NONE
//    *
//    *****************************************************************
//    *
//    *                        PROGRAMS CALLED
//    *   ------------------------------------------------------------
//    *   NO PROGRAMS CALLED
//    *
//    *****************************************************************
//    *****************************************************************
//    * License
//    *****************************************************************
//    *
//    * This program is free software; you can redistribute it and/or modify
//    * it under the terms of the GNU General Public License as published by
//    * the Free Software Foundation; either version 2 of the License, or
//    * (at your option) any later version.
//    *
//    * This program is distributed in the hope that it will be useful,
//    * but WITHOUT ANY WARRANTY; without even the implied warranty of
//    * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    * GNU General Public License for more details.
//    *
//    * You should have received a copy of the GNU General Public License
//    * along with this program; if not, write to the Free Software
//    * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//    *
//    *****************************************************************
//    *  MODIFICATION LOG:                                            *
//    *===============================================================*
//    *##|WHO        |WHEN      |WHAT & (CSR#)                        *
//    *===============================================================*
//    *  |           |          |                                     *
//    *  |           |          |                                     *
//    *---------------------------------------------------------------*
//    *****************************************************************
//    *****************************************************************
//    **
//    **
Unit RichFunctions;

Interface

//******************************************************************************
//** Functions/Procedures Prototypes
//******************************************************************************
Procedure GetFunctionNamesFromDLL(DLLName: string; List: TStrings);
Procedure CopyDos (FileIn, FileOut: PChar);
Function CvtUrlHex(strURL: String): String;
Function UnHex(strURL: String): Integer;
Function HexToDec(HexNumber: String): Integer;
Function DecToHex(DecNumber: Integer): String;
Function CelToFar(Cel: String): String;
Function FarToCel(Far: String): String;
Function BinToDec(BinNumber: String): Integer;
Function DecToBin(DecNumber: Integer): String;
Function AsciiToDec(Str: String): String;
Procedure DelTree(const RootDir  : String);
Function FileThere (strFile: String): Boolean;
Procedure ClickStart;
Function IsEven (intEven: integer) : Boolean;
Function IsPos (intPos: integer) : Boolean;
Function InStr(nStart: Integer; const sData, sFind: string): Integer;
Function Mid(const sData: string; nStart: Integer; nLength: Integer): string; overload;
Function StrLeft(const sData: string; nLength: integer): string;
Function StrRight(const sData: string; nLength: integer): string;
Function LCase(const sData: string; nLength: Integer): String;
Function UCase(const sData: string; nLength: Integer): String;
Function GetCurSysDate(VAR intMonth: integer; VAR intDay: integer; VAR intYear: integer): string;
Function GoAgain(): Boolean;
Procedure MsgBox1(pc_Messg: PChar);
Function MsgBox2(pc_Messg: PChar): Int64;
Procedure GoAway;
Procedure WriteInstructions;
Function IsAlpha(chrChar: Char): Boolean;
Function ITOST(i_Num: Integer): String;
Function STOI( cNum: STRING ): LONGINT;
Function RTOI( RealNum: REAL ): LONGINT;
//******************************************************************************

//** Var goes above here

Implementation



//** User Defined Functions ****************************************************

//******************************************************************************
//** GetFunctionNamesFromDLL -
//**                          This code enables you to view all procedures and
//**                          functions what DLL,DAT,EXE,DRV file has.
//**                          It displays them to your screen
//**                          and later you can use this file with Delphi.
//**     Parms = DLL Name, List
//**     Returns = All procedures and functions what DLL,EXE,DAT,DRV file has.
//**
//** Function by: Priit Serk
//**
//******************************************************************************
Procedure GetFunctionNamesFromDLL(DLLName: string; List: TStrings);
Type chararr = array[0..$FFFFFF] of char;
Var
        h: THandle;
        i, fc: integer;
        st: string;
        arr: pointer;
        ImageDebugInformation: PImageDebugInformation;

Begin
    List.Clear;
    DLLName := ExpandFileName(DLLName);
    
    If Not FileExists(DLLName) Then Exit;
       h := CreateFile(PChar(DLLName), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

    If h = -1 Then Exit;
       ImageDebugInformation := MapDebugInformation(h, PChar(DLLName), nil, 0);

    If ImageDebugInformation = nil Then Exit;

    arr := ImageDebugInformation^.ExportedNames;
    fc := 0;

    For i := 0 To ImageDebugInformation^.ExportedNamesSize - 1 Do
       Begin
             If chararr(arr^)[i] = #0 Then
               Begin
                    st := PChar(@chararr(arr^)[fc]);
                    If length(st) > 0 Then List.Add(st);

                    If (i > 0) And (chararr(arr^)[i - 1] = #0) Then Break;

                    fc := i + 1; end;
               End;

            UnmapDebugInformation(ImageDebugInformation);
            CloseHandle(h);
       End;
End;
//******************************************************************************

//******************************************************************************
//** CopyDos - Like DOS Copy Command
//** (COMSPEC is necessary in case you are running DR DOS.)
//******************************************************************************
Procedure CopyDos (FileIn, FileOut: PChar);
Var
    CommandLine: array[0..$FF] of Char;
Begin
    StrCopy (CommandLine, GetEnvVar ('COMSPEC'));
    StrCat  (CommandLine, ' /c copy ');
    StrCat  (CommandLine, FileIn);
    StrCat  (CommandLine, ' ');
    StrCat  (CommandLine, FileOut);
    WinExec (CommandLine, sw_Hide);
End;
//******************************************************************************

//******************************************************************************
//** CvtUrlHex - Takes all the Hex(%FF) code in a url and converts them
//**             to it's character value.
//**        Parm = String
//**        Return = Decimal Number
//** Usage:
//** CvtUrlHex('http://hotbot.lycos.com/?MT=%26%5E%5E%25%25%24%27&SQ=1&TR=7111&AM1=MC');
//******************************************************************************
//** UnHex - used by CvtUrlHex
Function UnHex(strURL: String): Integer;
Var
    b1 : String;
    b2 : String;
    i  : Integer;
Begin
    b1 := copy(strURL, 1,1);
    b2 := copy(strURL, length(strURL),1);

    For i := 0 To 5 do
         Begin
    			If b1 = Chr(65 + i) Then
               	b1 := inttostr(10 + i)
    			Else
    				If b1 = Chr(97 + i) Then
                    	b1 := inttostr(10 + i);
    				If b2 = Chr(65 + i) Then
                    	Begin
                           b2 := inttostr(10 + i);
                         End
    			Else
    				If b2 = Chr(97 + i) Then
                    	b2 := inttostr(10 + i);
    	    End; //** Next
    UnHex := (16 * strtoint(b1)) + strtoint(b2);
End;

Function CvtUrlHex(strURL: String): String;
Var
    k : integer;
    s : String;
Begin
    k := 1;
    While k <= Length(strURL) Do
    Begin
        If copy(strURL, k, 1) = '%' Then
          Begin
              s := s + Chr(UnHex(copy(strURL, k + 1, 2)));
              k := k + 2
          End
        Else
        	Begin
              s := s + copy(strURL, k, 1);
              k := k + 1;
        	End;
    End;
    ConUrlHex := s;
End;
//******************************************************************************

//******************************************************************************
//** HexToDec - Convert a Hexidecimal String to a Deciumal #
//**             Deicmal Number (0 ... 255)
//**             Hexidecimal String (2 Digits)
//**        Parm = Hexidecimal String
//**        Return = Decimal Number
//******************************************************************************
Function HexToDec(HexNum: String): Integer;
Var
	Strlength : Integer;
     dech      : Integer;
     decl      : Integer;

Begin

    dech := 0;
    //** Calculate length of hex string
    Strlength := Length(HexNum);
    //** Convert least significant digit
    decl := Ord(HexNum[Strlength]) - Ord('0');

    //** Digit > 9 subtract offset A...F
    If decl > 9  Then
    		Begin
		    decl := decl - 7;
          End;

    //** Digit > 15 subtract offset A...F
    If decl > 15 Then
    		Begin
		    decl := decl - 32;
          End;
    //** If second digit exist convert it
    If Strlength = 2 Then
      Begin
          //** Convert most significant digit
           dech := Ord(HexNum[1]) - Ord('0');
		 //** Digit > 9 subtract offset A...F
     	 If dech > 9  Then
           	Begin
	               dech := dech - 7;
               End;

           //** Digit > 15 subtract offset A...F
	      If dech > 15 Then
           	Begin
		           dech := dech - 32;
               End;
      End;

    //** Shift MSD 4 bit left & add to LSD
    HexToDec := (dech SHL 4) + decl;

End;
//******************************************************************************

//******************************************************************************
//** DecToHex - Convert a Decimal # to a Hexadecimal String
//**             Deicmal Number (0 ... 255)
//**             Hexidecimal String (2 Digits)
//**        Parm = Decimal Number
//**        Return = Hexidecimal String
//******************************************************************************
Function DecToHex(DecNumber: Integer): String;
Type
	String2 = String[2];
Var
	hex1   : String2;
     hex2   : String2;
     VarChr : Variant;

Begin
      //** MSD = dec. number / 16
      hex1 := IntToStr(DecNumber DIV 16);
      //** LSD = remainder dec number / 16
      hex2 := IntToStr(DecNumber MOD 16);
      //** If digit > 9 add offset for A...F
      If StrToInt(hex1) > 9 Then
      	Begin
          	VarChr := Chr(StrToInt(hex1) + 55);
      		hex1 := VarChr;
          End;
      //** If digit > 9 add offset for A...F
      If StrToInt(hex2) > 9 Then
      	Begin
          	VarChr := Chr(StrToInt(hex2)+ 55);
			hex2 := VarChr;
          End;

      DecToHex := hex1 + hex2; //** Store Result
End;
//******************************************************************************

//******************************************************************************
//** CelToFar - Convert Celcius to Farenheit
//**        Parm = Celcius Tempature
//**        Return = Farenheit Tempature
//******************************************************************************
Function CelToFar(Cel: String): String;
Var
	C : Real; //** Celcius Tempature
     F : Real; //** Farenheit Tempature
     S : string; //** Temp variable for conversion
Begin
     C := StrtoFloat(Cel);	       //** Convert passed string to a Real Number
     F := C*9/5+32;		            //** do the conversion
     S := FloattoStrF(F, ffFixed, 5, 2); //** convert result of conversion to text
     CelToFar := S;		            //** Return Farenheit Tempature
End;
//******************************************************************************

//******************************************************************************
//** FarToCel - Convert Farenheit To Celcius
//**        Parm = Farenheit Tempature
//**        Return = Celcius Tempature
//******************************************************************************
Function FarToCel(Far: String): String;
Var
	C : Real; //** Celcius Tempature
     F : Real; //** Farenheit Tempature
     S : string; //** Temp variable for conversion
Begin
     F := StrtoFloat(Far);	       //** Convert passed string to a Real Number
     C := (F-32)*5/9;				//** do the conversion
     S := FloattoStrF(C, ffFixed, 5, 2);  //** convert result of conversion to text
     FarToCel := S;			       //** Return Celcius Tempature
End;
//******************************************************************************

//******************************************************************************
//** BinToDec - Converts an Binary # To Deciaml #
//**            Binary number (Max 64 Bits)
//**        Parm = Binary # (As String)
//**        Returns = Decimal Number
//******************************************************************************
Function BinToDec(BinNumber: Tbinstring): Integer;
Var
	i      : Integer;
     weight : Integer;
     dec    : Integer;

Begin
    Weight := 1; //** Set weight factor at lowest bit
    dec := 0;   //** Reset decimal number

    //** Convert all bits from bin. string
    For i := Length(BinNumber) DownTo 1 Do
         Begin
	          //** If bit=1 then add weigth factor
       		dec := dec + Ord(BinNumber[i] = '1') * Weight;
			//** Multiply weight factor by 2
		     Weight := Weight SHL 1;
      END;

    //** Store result
    BinToDec := dec;
    
End;
//******************************************************************************

//******************************************************************************
//** DecToBin - Converts an Decimal # To Binary #
//**        Parm = Decimal #
//**        Returns = Binary Number (Max 64 Bits) (As String)
//** NOTE: Requires Instr & Mid Functions
//******************************************************************************
Function DecToBin(DecNumber: Integer): Tbinstring;
Type
	arBinNum = Array[1..64] of Integer;

Var
	i    : Integer;
  	bin  : String;
     Remain : Integer;
     Quot  : Integer;
     WrkNum : Integer;
     BinNum : arBinNum;
     iPos : Integer;

Begin


     Quot := DecNumber;

     For i := 1 To 64 Do
     	BinNum[i] := 0;

     i := 1;
     Repeat
     	Begin
               WrkNum := Quot DIV 2;
               Remain := Quot MOD 2;
               BinNum[i] := Remain;
               i := i + 1;
               Quot := WrkNum;
          End
     Until Quot = 0;

    //** Store result
    For i := 64 DownTo 1 Do
    		bin := bin + IntToStr(BinNum[i]);

    //** Strip Excess Leading Zero's
    iPos := Instr(1,bin,'1');
    bin := Mid(bin, (iPos), (Length(bin) - (iPos - 1)));

   //** Return Result
   DecToBin := bin;

End;
//******************************************************************************

//******************************************************************************
//** AsciiToDec - Converts an ASCII To Decimal
//**        Parm = ASCII String
//**        Returns = Deicmal # (As String)
//******************************************************************************
Function AsciiToDec(Str: String): String;
Var
	Temp : String;
	J    : Integer;
Begin
    //** Initializations
    Temp :='';
    J    := 0;

    For J := 1 To Length(Str) Do
      Begin
      	Temp := Temp + IntToStr(Ord(Str[J]));
      End;
    AsciiToDec := Temp;

End ;
//******************************************************************************

//******************************************************************************
//** DelTree - Like DOS Command DelTree
//**        Parm = Directory Path
//******************************************************************************
Procedure DelTree(const RootDir  : String);
Var
  SearchRec : TSearchRec;
  
Begin

Try

    ChDir(RootDir);  //** Path to the directory given as parameter
    FindFirst('*.*', faAnyFile, SearchRec);
    Erc := 0;

    While Erc = 0 Do
    		Begin
              //** Ignore higher level markers
              If ((SearchRec.Name <> '.' ) And (SearchRec.Name <> '..')) Then
                Begin
                    If (SearchRec.Attr and faDirectory>0) Then
                          Begin
                              //** Have found a directory, not a file.
                              //** Recusively call ouselves to delete its files
                               DelTree(SearchRec.Name);
                           End
                    Else
                          Begin
                            //** Found a file.
                            //** Delete it or whatever you want to do here

                           End;
                End;

                Erc := FindNext(SearchRec);
                //** Erc is zero if FindNext successful,
                //** otherwise Erc = negative DOS error

                //** Give someone else a chance to run
                Application.ProcessMessages;
    		End;

finally
      //** If we are not at the root of the disk, back up a level
      if Length(RootDir) > 3 then
          ChDir('..');
      //** I guess you would remove directory RootDir here

End;

End;
//******************************************************************************

//******************************************************************************
//** FileThere
//******************************************************************************
Function FileThere (strFile: String): Boolean;
Begin
      FileThere := FileExists(strFile);
End;
//******************************************************************************

//******************************************************************************
//** ClickStart - Simulates a click on the Windows start button
//******************************************************************************
Procedure ClickStart;
Begin
    SendMessage(Self.Handle, WM_SYSCOMMAND, SC_TASKLIST, 0);
End;
//******************************************************************************

//******************************************************************************
//** Function IsEven - Tests if a given integer is Even
//******************************************************************************
Function IsEven (intEven: integer) : Boolean;
        Begin
                If intEven MOD 2 = 0 then
                        IsEven:= True //** Number is Even
                Else
                        IsEven:= False;  //** Number is Odd
        End;

//******************************************************************************
//** Function IsPos - Tests if a given integer is Positive
//******************************************************************************
Function IsPos (intPos: integer) : Boolean;
        Begin
                If intPos < 0 Then
                        IsPos:= False //** Number is Negative
                Else
                        IsPos:= True  //** Number is Positive
        End;


//******************************************************************************
//** Function Instr - Like the Visual Basic Function
//******************************************************************************
Function InStr(nStart: Integer; const sData, sFind: string): Integer;
Var
        sTemp: String;
        nFound: Integer;
Begin
          sTemp := Copy(sData, nStart, (Length(sData) - (nStart - 1)));
          nFound := Pos(sFind, sTemp);
          If nFound = 0 then
             Begin
                Instr:= 0;
             End
          Else
             Begin
                Instr:= nFound + nStart - 1;
             End
End;

//******************************************************************************
//** Function Mid - Like the Visual Basic Funciton
//******************************************************************************
Function Mid(const sData: string; nStart: Integer; nLength: Integer): string; overload;
Begin
      Mid:= Copy(sData, nStart, nLength);
End;

//******************************************************************************
//** Function Left - Like the Visual Basic Funciton
//******************************************************************************
Function StrLeft(const sData: string; nLength: integer): string;
        Begin
                StrLeft:= Copy(sData, 1, nLength);
        End;

//******************************************************************************
//** Function Right - Like the Visual Basic Funciton
//******************************************************************************
Function StrRight(const sData: string; nLength: integer): string;
        Begin
                StrRight:= Copy(sData, Length(sData) - (nLength - 1), nLength);
        End;

//******************************************************************************
//** Function LCase - converts passed string to lower case
//******************************************************************************
Function LCase(const sData: string; nLength: Integer): String;
Var
        x: Integer;

        Begin
                For x:= 1 to nLength Do
                    Begin
                        LCase:= LowerCase(sData[x]);
                    End;

        End;

//******************************************************************************
//** Function UCase - converts passed string to upper case
//******************************************************************************
Function UCase(const sData: string; nLength: Integer): String;
Var
        x: Integer;

        Begin
                For x:= 1 to nLength Do
                    Begin
                        UCase:= UpperCase(sData[x]);
                    End;

        End;

//******************************************************************************
//** Get Curent Date MM/DD/YYYY
//******************************************************************************
Function GetCurSysDate(VAR intMonth: integer; VAR intDay: integer; VAR intYear: integer): string;
//** Returns date in mm/dd/yy format
//** Also returns MM , DD, YYYY By Reference. (need global variables to hold these in).

//** Call from program with:
//** Get the current system Date
//**  strSysDate:= GetCurSysDate(intSysMonth, intSysDay, intSysYear);

Var
        strDate: string; //** Holds Current date
        intPos: integer; //** Holds 1st position of /
        intPos2: integer; //** Holds 2nd position of /
        intLen: integer; //** Holds length of Date string
        endPos: integer; //** End position for Mid
        startPos: integer; //** Start position for Mid
        strWork: string;  //** Work variable for String to Integer Conversion

        Begin
                strDate:= DateTimetoStr(Now); //** Get date in mm/dd/yy
                strDate:= FormatDateTime('" " mm/dd/yyyy, " " hh:mm AM/PM', strtodatetime(strDate));
                strDate:= mid(strDate,2,11);
                intLen:= length(strDate);

                intPos:= instr(1,strDate,'/');
                endPos:= (intPos - 1);
                If intPos > 0 Then
                   Begin
                        //** Get Month
                        strWork:= mid(strDate, 1, endPos); //** Get mm
                        intMonth:= StrtoInt(strWork);
                        //** Get Day
                        strWork:= mid(strDate, (endPos + 2), 2);
                        intDay:= StrtoInt(strWork);
                   End;

                //** Get Year
                intPos2:= instr((intPos + 1),strDate,'/');
                startPos:= (intPos2 + 1);
                If intPos2 > 0 Then
                   Begin
                        strWork:= mid(strDate, startPos, (intLen - intPos2));
                        intYear:= StrtoInt(strWork);
                   End;
        End;

//******************************************************************************
//** Function GoAgain - Does user want to Continue?
//******************************************************************************
Function GoAgain(): Boolean;

//** Call from program with:
//** See if User Wants to Go Again
//** blnGoAgain:= GoAgain();
//   If blnGoAgain = True Then
//      Begin
//           blnExit:= False
//     End
//  Else
//     Begin
//          blnExit:= True
//     End
//***************************************************************

Var
                strYN: String; //** For program exit or not
                blnExit2: Boolean; //** Boolean to tell if We should exit a loop
                strUpCase: String; //** Used to hold converted Upper case letter
        Begin

                //** Initializations
                blnExit2:= False;
                strUpCase:= ' ';

                         //** See if User Wants to Go Again
                        Repeat
                              Begin
                                     Write('Do you wish to Continue? ');
                                     Readln(strYN);
                                     strUpCase:= UpperCase(strYN);

                                     If strUpCase = 'Y' Then //** User wants to continue
                                        Begin
                                                blnExit2:= True;
                                                GoAgain:= blnExit2;
                                        End

                                     Else If strUpCase = 'N' Then //** User wants to exit
                                        Begin
                                                blnExit2:= False;
                                                GoAgain:= blnExit2;
                                                blnExit2:= True; //** Force to exit loop
                                        End

                                     Else If (strUpCase <> 'N') Or (strUpCase <> 'Y') Then
                                        Begin
                                                writeln('Please enter Y or N');
                                                blnExit2:= False;
                                        End
                              End
                         Until blnExit2 = True;

        End;
//** End of GoAgain ************************************************************

//******************************************************************************
//** MsgBox1 - Display an informational Message Box to User  Ok Button
//******************************************************************************
Procedure MsgBox1(pc_Messg: PChar);
Begin
      with Application Do
          Begin
            NormalizeTopMosts;
            MessageBox(pc_Messg,'MyApplication',MB_OK);
            RestoreTopMosts;
          End;

End;
//** End of MsgBox *************************************************************

//******************************************************************************
//** MsgBox2 - Display an informational Message Box to User  Ok/Cancel Buttons
//******************************************************************************
Function MsgBox2(pc_Messg: PChar): Int64;
Var
  i_RtnCode : Int64;

Begin
  with Application Do
    Begin
      NormalizeTopMosts;
      i_RtnCode:= MessageBox(pc_Messg,'MyApplication',MB_OKCANCEL);
      RestoreTopMosts;
    End;

  MsgBox2 := i_RtnCode;

End;
//** End of MsgBox ************************************************************


//******************************************************************************
//** GoAway - This Procedure will End the program  (Console Mode)
//******************************************************************************
Procedure GoAway;
Begin
        Writeln;
        Writeln('Press <ENTER> to Exit');
        Readln
End;
//** End of GoAway ************************************************************


//******************************************************************************
//** Write Instructions
//******************************************************************************
Procedure WriteInstructions;

//** Call from program with:
//** Give User instructions if wanted
//** WriteInstructions();

Var
        chrInstr: Char; //** Charcter either Y or N to check if user wants instructions

        Begin
                //** Initializations
                chrInstr:= ' ';

                Repeat  //** Instructions Loop
                        //** Does user need Instructions?
                        Write('Do you Need Instructions (Y/N)?');
                        readln(chrInstr);
                        If UpperCase(chrInstr) = 'Y' Then
                            Begin
                                //** Write out Instructions
                                writeln;
                                //******************************************
                                //** Insert writeln's with user instructions
                                //** Here
                                //******************************************
                                writeln;
                                Writeln('Press ENTER to continue');
                                writeln;
                                readln;
                                blnExit:= True;  //** Set on loop exit trigger
                                writeln;
                            End
                        Else If (UpperCase(chrInstr) = 'N') Then
                            Begin
                                 blnExit:= True;
                                writeln;
                            End
                        Else If (UpperCase(chrInstr) <> 'N') And (UpperCase(chrInstr) <> 'Y') Then
                            Begin
                                Writeln('Please enter either Y or N');
                                blnExit:= False; //** set off loop exit trigger
                            End

                Until blnExit = True;
        End;
//** End of WriteInstructions *****************************

//******************************************************************************
//** Function IsAlpha
//******************************************************************************
Function IsAlpha(chrChar: Char): Boolean;
//** Checks whether a passed character is one of the alpha letters or not

Var
        blnAlpha: Boolean; //** Is Alpha switch

        blnAlpha:= False; //** Initialize to False (not Alpha)

        Begin
                Case chrChar Of
                        'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T', 'U','V','W','X','Y','Z': blnAlpha:= True;
                 End;

                 If blnAlpha = True Then
                    Begin
                        IsAlpha:= True;
                    End
                 Else
                    Begin
                        IsAlpha:= False;
                    End

        End
//** End of IsAlpha ********************************************************

//******************************************************************************
//** ITOST - Convert an Integer to a String
//******************************************************************************
Function ITOST(i_Num: Integer): String;
Var
    v_INum : Variant;
Begin
  v_INum := I_Num;
  ITOST := v_INum;
End;
//******************************************************************************

//******************************************************************************
//** STOI - Convert STRING to INTEGER
//** PARAMETER:  cNum - String to convert to integer format
//** RETURNS: cNum as a numeric integer
//******************************************************************************
Function STOI( cNum: STRING ): LONGINT;
Var
   c: INTEGER;
   i: LONGINT;
Begin
     VAL( cNum, i, c );
     STOI := i;
End;
//************END OF STOI*******************************************************

//******************************************************************************
//** RTOI - convert a real to an integer
//** PARAMETER:   RealNum - Real type number
//** RETURNS:    The integer part of RealNum
//******************************************************************************
Function RTOI( RealNum: REAL ): LONGINT;
Var
   s: String;
   l: LongInt;
   i: Integer;
Begin
     STR( RealNum:17:2, s );
     s := Left( s, LENGTH(s) - 3 );
     VAL( s, l, i );
     RTOI := l;
End;
//********END OF RTOI**********************************************************



//*****************************************************************************
End.
//** End of Code **************************************************************

