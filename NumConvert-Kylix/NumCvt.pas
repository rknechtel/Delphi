//*********************************************************************************
//**
//** Program: NumConvert
//**
//** Description: This program will Convert Numbers:
//**                                        Hexidecimal to a Decimal
//**                                        Decimal to Hexidecimal
//**                                        Decimal to Binary
//**                                        Binary to Decimal
//**                                        Hexidecimal to Binary
//**                                        Binary to Hexidecimal
//**
//** Author: Richard Knechtel
//** Email: rknech@pcisys.net
//** Date:  02/7/2002
//**
//** Note: This program and any of the source may not be sold, sub-licensed
//**       or sold for profit without the express written permisson of the
//**       the author (ME). Author holds all exclusive copyrights.
//**       This program is released under the GPL (see below license) and the
//**       Copying.txt file accompanying the source.
//**
//********************************************************************************
//********  LICENSE  *************************************/
//*                                                      */
//* This program is free software; you can redistribute  */
//* it and/or modify it under the terms of the GNU       */
//* General Public License as published by  the Free     */
//* Software Foundation; either version 2 of the License,*/
//* or (at your option) any later version.               */
//*                                                      */
//* This program is distributed in the hope that it will */
//* be useful, but WITHOUT ANY WARRANTY; without even    */
//* the implied warranty of MERCHANTABILITY or FITNESS   */
//* FOR A PARTICULAR PURPOSE.  See the GNU General       */
//* Public License for more details.                     */
//*                                                      */
//* You should have received a copy of the GNU General   */
//* Public License along with this program; if not,      */
//* write to the                                         */
//* Free Software                                        */
//* Foundation, Inc., 675 Mass Ave,                      */
//* Cambridge, MA 02139, USA.                            */
//*                                                      */
//********************************************************/
unit NumCvt;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QButtons, QExtCtrls;

type
  TfrmHex2Dec = class(TForm)
    pnlHex2Dec: TPanel;
    lblHex: TLabel;
    eHex: TEdit;
    lblDec: TLabel;
    eDec: TEdit;
    btnOk: TBitBtn;
    btnExit: TBitBtn;
    gbConvert: TGroupBox;
    rbDec2Hex: TRadioButton;
    rbHex2Dec: TRadioButton;
    lblBin: TLabel;
    eBin: TEdit;
    rbDec2Bin: TRadioButton;
    rbBin2Dec: TRadioButton;
    rbHex2Bin: TRadioButton;
    rbBin2Hex: TRadioButton;
    btnClear: TBitBtn;
    procedure btnOkClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExitClick(Sender: TObject);
  private
    { Private declarations }
    Function HexToDec(HexNum: String): Integer;
    Function DecToHex(DecNumber: Integer): String;
    Function BinToDec(BinNumber: String): Integer;
    Function DecToBin(DecNumber: Integer): String;
    Function InStr(nStart: Integer; const sData, sFind: string): Integer;
    Function Mid(const sData: string; nStart: Integer; nLength: Integer): string; overload;

  public
    { Public declarations }


  end;

var
  frmHex2Dec: TfrmHex2Dec;

implementation

{$R *.xfm}
{$OPTIMIZATION OFF}

//******************************************************************************
//**                        User Defined Functions
//******************************************************************************

//******************************************************************************
//** Function Instr - Like the Visual Basic Function
//******************************************************************************
Function TfrmHex2Dec.InStr(nStart: Integer; const sData, sFind: string): Integer;
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

//******************************************************************************
//** Function Mid - Like the Visual Basic Funciton
//******************************************************************************
Function TfrmHex2Dec.Mid(const sData: string; nStart: Integer; nLength: Integer): string;
Begin
      Mid:= Copy(sData, nStart, nLength);
End;
//******************************************************************************

//******************************************************************************
//** HexToDec - Convert a Hexidecimal String to a Deciumal #
//**             Deicmal Number (0 ... 255)
//**             Hexidecimal String (2 Digits)
//**        Parm = Hexidecimal String
//**        Return = Decimal Number
//******************************************************************************
Function TfrmHex2Dec.HexToDec(HexNum: String): Integer;
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
//** DecToHex - Convert a Decimal # to a Hexadecimal String
//**             Deicmal Number (0 ... 255)
//**             Hexidecimal String (2 Digits)
//**        Parm = Decimal Number
//**        Return = Hexidecimal String
//******************************************************************************
Function TfrmHex2Dec.DecToHex(DecNumber: Integer): String;
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
//** BinToDec - Converts an Binary # To Deciaml #
//**            Binary number (Max 64 Bits)
//**        Parm = Binary # (As String)
//**        Returns = Decimal Number
//******************************************************************************
Function TfrmHex2Dec.BinToDec(BinNumber: String): Integer;
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
//******************************************************************************
Function TfrmHex2Dec.DecToBin(DecNumber: Integer): String;
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
//**                            Form Operations
//******************************************************************************

//******************************************************************************
Procedure TfrmHex2Dec.btnOkClick(Sender: TObject);
Var
	iTemp   : Integer;
     strTemp : String;

Begin

      //** Convert Hex To Decimal
      If (rbHex2Dec.Checked = True) Then
          Begin
          	eDec.Text := IntToStr(HexToDec(eHex.Text));
          End;
      //** Convert Deciaml To Hex
      If (rbDec2Hex.Checked = True) Then
          Begin
                eHex.Text := (DecTohex(StrToInt(eDec.Text)));
          End;
	 //** Convert Decimal to Binary
      If (rbDec2Bin.Checked = True) Then
          Begin
               eBin.Text := DecToBin(StrToInt(eDec.Text));
          End;
      //** Convert Binray to Decimal
      If (rbBin2Dec.Checked = True) Then
          Begin
                eDec.Text := IntToStr(BinToDec(eBin.Text));
          End;
      //** Convert Hex to Binary
      If (rbHex2Bin.Checked = True) Then
          Begin
               iTemp := HexToDec(eHex.Text);
               eBin.Text := DecToBin(iTemp);
          End;
      //** Convert Binary to Hex
      If (rbBin2Hex.Checked = True) Then
          Begin
                iTemp := BinToDec(eBin.Text);
                eHex.Text := DecTohex(iTemp);
          End;


End;
//******************************************************************************

//******************************************************************************
Procedure TfrmHex2Dec.btnClearClick(Sender: TObject);
Begin
 	eHex.Text := '';
     eDec.Text := '';
     eBin.Text := '';

     rbHex2Dec.Checked := False;
     rbDec2Hex.Checked := False;
     rbDec2Bin.Checked := False;
     rbBin2Dec.Checked := False;
     rbHex2Bin.Checked := False;
     rbBin2Hex.Checked := False;
End;
//******************************************************************************

//******************************************************************************
Procedure TfrmHex2Dec.FormClose(Sender: TObject; var Action: TCloseAction);
Begin
	//free the form
	Action := caFree;
End;
//******************************************************************************


//******************************************************************************
Procedure TfrmHex2Dec.btnExitClick(Sender: TObject);
Begin
	 //** Close the Form
      frmHex2Dec.Close;
End;
//******************************************************************************

//******************************************************************************
End.
//****** End of Code ***********************************************************
