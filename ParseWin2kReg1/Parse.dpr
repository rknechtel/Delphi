//    *****************************************************************
//    ** COMPANY NAME:  HPA Systems
//    *****************************************************************
//    ** Application......: File Parser
//    **
//    ** Module Name......:
//    ** Program Name.....: Parser
//    ** Program Description: 1) Will read in data from an exported
//    **                         Win2K Reg file:
//    **                      2) will strip out all NULL characters
//    **                      3) will write out to new "stripped" file.
//    **
//    ** Documentation....:
//    ** Called By........:
//    ** Sequence.........:
//    ** Programs Called..:
//    **
//    ** Create Options...:
//    ** Object Owner.....:
//    ** CREATED By.......:  RICHARD KNECHTEL
//    ** Creation Date....:  12/28/2001
//    ** Class............:  CS341
//    **
//    *****************************************************************
//    *
//    *     INPUT FILES: User Entered
//    *
//    *    UPDATE FILES: User Entered file + .out extention
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
program Lab1a;
{$APPTYPE CONSOLE}
uses
  SysUtils;

//** Define Constants
CONST
        //** Standard Constants
        CR = Chr(13); //** Carriage Return
        LF = Chr(10); //** Line Feed
        NULL = #0;    //** Null

//** Declare Variables
VAR
        DatIn: Text;     //** Text File to be used for Reading
        DatOut: Text;     //** Text File to be used for Writing
        FileLoc: String;   //** Full location of text file to read from
        FileLoc1: String;  //** Full location of text file to write to
        rdc: Char;           //** Character read in
        LineCnt: Integer;  //** Count of the number of lines read

//** Prodcedure and Functions ************************************************

//****************************************************************************
//** Function Mid - Like the Visual Basic Funciton
//****************************************************************************
Function Mid(const sData: string; nStart: integer; nLength: integer): String; Overload;
         Begin
                Mid:= Copy(sData, nStart, nLength);
         End;

//**********************************************************
//** Function Instr - Like the Visual Basic Function
//**********************************************************
Function InStr(nStart: integer; const sData, sFind: string): integer;
VAR
        sTemp: String;
        nFound: integer;
BEGIN
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
END;

//****************************************************************************
//** GetFiles - This Procedure will get the location and name of the files
//**           to be used.
//****************************************************************************
PROCEDURE GetFiles;

Var
        IsThere: Boolean;  //** Check for if file exists
        DotPos: Integer; //** Position of "." in file
        
Begin
        //** Find/Get location of File
        Repeat
                Begin
                        Writeln('Please input the Full Path ');
                        Writeln('of the file. ');
                        Writeln('Example: c:\myfile.txt');
                        Write('File Path > ');
                        readln(FileLoc);
                        IsThere := FileExists(FileLoc);
                End;

                If IsThere = False Then
                        Begin
                              Writeln;
                              Writeln('Please Input a valid');
                              Writeln('path to your file.');
                              Writeln;
                        End

        Until IsThere = True;
        Assign(DatIn, FileLoc);
        Reset(DatIn);

        //** Find/Get location of output File
        DotPos:= Instr(1,FileLoc, '.');
        FileLoc1:= Mid(FileLoc, 1, (DotPos -1));
        FileLoc1:= FileLoc1 + '.out';
        Assign(DatOut, FileLoc1);


        ReWrite(DatOut);

End;

//****************************************************************************
//** writeFile - This Procedure will write out the characters
//****************************************************************************
Procedure WriteFile (chr: Char);
Begin
        Write(DatOut, chr);
End;

//****************************************************************************
//** ReadFile - This Procedure will read the data from the text file and
//**            write out non-NULL/CR/LF characters.
//** Calls:
//**        WriteFile
//****************************************************************************
PROCEDURE ReadFile;
Begin
        Repeat
                Repeat
                        Read(DatIn,rdc);
                        If (rdc <> NULL) And (rdc <> CR) And (rdc <>LF) Then
                            Begin
                                  WriteFile(rdc);
                            End //** End of If <> NULL/CR/LF
                Until eoln(DatIn);
                //** End of Line - write out a CRLF to start at next line.
                WriteFile(CR);
                WriteFile(LF);

        Until eof(DatIn);

        //** Close Files
        Close (DatIn);
        Close (DatOut);

End;

//****************************************************************************
//** WriteInfo - This Procedure will write user information
//****************************************************************************
PROCEDURE WriteInfo;
Begin
        Writeln('This program will take an exported Win2K registry file');
        Writeln('and output a readable text version of the file.');
        Writeln('The output file will have the same name as the input file');
        Writeln('name with a .out extention.');
        Writeln;
        Writeln('Press ENTER to continue.');
        Writeln;
        Readln
End;

//****************************************************************************
//** GoAway - This Procedure will End the program
//****************************************************************************
PROCEDURE GoAway;
Begin
        Writeln;
        Writeln;
        Writeln('Press <ENTER> to Exit');
        Readln
End;

//** Start of Main Program **************************************************
BEGIN

        //** Initializations
        FileLoc:= '';
        FileLoc1:= '';
        //** Get Inputs

        //** Write user Information
        WriteInfo();

        //** Get the File Name and Location
        GetFiles();
        
        //** Read in the File
        ReadFile();

        //** We are out of here!
        GoAway();
        
END.
//    **********END OF PROGRAM****************************************
