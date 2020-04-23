unit vinverify;

{
    '***************************************************************************
    '** Written by: Richard Knechtel
    '** Ported to Delphi: by Greg Sherman on 9/24/2003 
    '** Contact: krs3@uswest.net / krs3@quest.net
    '**          http://www.users.uswest.net/~krs3/
    '** Date: 11/01/2000
    '**
    '** Description:
    '** This function will calculate the Check Digit for a vehilces VIN number
    '** and verify that the passed VIN's check digit is valid.
    '**
    '** Parameters:
    '** This function requires a 17 character VIN number to be passed to it.
    '** It will return a Boolean value:
    '** If the VIN Check Digit is valid the functin will return TRUE.
    '** If the VIN Check Digit as not-valid the function will return FALSE.
    '**
    '** Notes:
    '** If the Check Digit is valid then the VIN number is valid.
    '** A Vehicle VIN number contains 17 characters.
    '** The 9th position in the VIN is the Check Digit.
    '**
    '***************************************************************************
    '*********  LICENSE  ************************************/
    '/*                                                      */
    '/* This program is free software; you can redistribute  */
    '/* it and/or modify it under the terms of the GNU       */
    '/* General Public License as published by  the Free     */
    '/* Software Foundation; either version 2 of the License,*/
    '/* or (at your option) any later version.               */
    '/*                                                      */
    '/* This program is distributed in the hope that it will */
    '/* be useful, but WITHOUT ANY WARRANTY; without even    */
    '/* the implied warranty of MERCHANTABILITY or FITNESS   */
    '/* FOR A PARTICULAR PURPOSE.  See the GNU General       */
    '/* Public License for more details.                     */
    '/*                                                      */
    '/* You should have received a copy of the GNU General   */
    '/* Public License along with this program; if not,      */
    '/* write to the                                         */
    '/* Free Software                                        */
    '/* Foundation, Inc., 675 Mass Ave,                      */
    '/* Cambridge, MA 02139, USA.                            */
    '/*                                                      */
    '/********************************************************/
}

interface

function ValidVIN(VIN: String): Boolean;

implementation

uses SysUtils, miscroutines;

function ValidVIN(VIN: String): Boolean;
   var
   strVIN: String;      { String representation of VIN }
   strVINPos: Char;     { Position of VIN character }
   Idx: Integer;        { Index used to parse the position out of the VIN }
   lngSubTotal: integer;{ Sub Total used in multipling the "Numeric Factor" by the "Weight Factor" }
   lngTotal: integer;   { Used to total the VIN }
   intCalcCD: Integer;  { This is OUR calculated check digit - compare to 9th position in VIN }
   strCalcCD: String;   { String verson of Check Digit }
   strVINCD:  String;   { This is the string version Check Digit from the passed VIN # }
   intNV: Integer;      { Used to find "Numeric Value" }
   intWF: integer;      { Used to find "Weight Factor" }

   begin
   lngSubTotal := 0;
   lngTotal := 0;

   {** Get a VIN Number to Work with }
   strVIN := Trim(VIN);

   For Idx := 1 To 17 do // Idx = The Position  - a VIN Contains 17 characters.
      begin
      // We do not want to do anything with the 9th position
      // - It IS the Check Digit.
      If Idx <> 9 Then
         begin
         // First: a numerical value is assigned to letters in the VIN.
         // The letters I, O and Q are not allowed so on the positions
         // these letters the numerical sequence skips:
         strVINPos := strVIN[Idx];
         IntNV := 0;
         IntWF := 0;
         Case strVINPos of
           '0'                   : intNV := 0;
           '1', 'A', 'J'         : intNV := 1;
           '2', 'B', 'K', 'S'    : intNV := 2;
           '3', 'C', 'L', 'T'    : intNV := 3;
           '4', 'D', 'M', 'U'    : intNV := 4;
           '5', 'E', 'N', 'V'    : intNV := 5;
           '6', 'F','W'          : intNV := 6;
           '7', 'G', 'P', 'X'    : intNV := 7;
           '8', 'H','Y'          : intNV := 8;
           '9', 'R', 'Z'         : intNV := 9;
           end;

         { Second: a weight factor is assigned to all positions of the VIN,
           except of course for the 9th position, being the position of the
           check digit, as follows: }

         case Idx of // Idx = The Position
            1, 11                : intWF := 8;
            2, 12                : intWF := 7;
            3, 13                : intWF := 6;
            4, 14                : intWF := 5;
            5, 15                : intWF := 4;
            6, 16                : intWF := 3;
            7, 17                : intWF := 2;
            8                    : intWF := 10;
            10                   : intWF := 9;
            end;


         { Then the Numbers and the Numercial Values of the letters in the
           VIN must be multiplied by their assigned Wieght Factor and the
           resulting products added up. }

         lngSubTotal := lngSubTotal + (intNV * intWF);
         lngTotal := lngSubTotal;

         end; { if }
      end; { for }

   {** Find the whole number remainder - (This is the Check Digit) }
   intCalcCD := lngTotal Mod 11;    // Get the Calculated Check Digit
   strVINCD := VIN[9];              // Get the Passed VIN's Check Digit

   output(strVinCD);

   {** If the numerical remainder is 10            }
   {** then the Check Digit will be the Letter "X" }
   If intCalcCD = 10 Then
       strCalcCD := 'X'
   else
       strCalcCD := IntToStr(intCalcCD);

   {** Compare the calculated Check Digit with the Check Digit from the}
   {** Passed VIN # to see if they match.}

   If strCalcCD = strVINCD Then
      result := True   { If Check Digit is valid return TRUE }
   else
      result := False; {** If Check Digit is not-valid return FALSE }
   end;

end.
