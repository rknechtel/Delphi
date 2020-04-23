//    *****************************************************************
//    ** COMPANY NAME:  HPA Systems
//    *****************************************************************
//    ** Application......:
//    **
//    ** Module Name......: stackary.pas
//    ** Program Name.....: 
//    ** Program Description: Library of Stack Array routines.
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
//    ** Creation Date....: 10/20/2001
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

//************************************************************************
//**   Library of Stack Array routines.
//************************************************************************
UNIT StackAry;

                              INTERFACE

   CONST MaxStackSize = 100;


   TYPE  StackDataType = Char;
         StackIndexType = 0..MaxStackSize;
         StackArray = ARRAY [1..MaxStackSize] OF StackDataType;

         StackType = RECORD
                        StackData: StackArray;
                        StackTop: StackIndexType
                     END;

   PROCEDURE InitStack (VAR Stack: StackType);

   FUNCTION Empty (VAR Stack: StackType): Boolean;
   FUNCTION GetStackSize (VAR Stack: StackType): StackIndexType;

   PROCEDURE Push (VAR Stack: StackType;
                   NewData: StackDataType;
                   VAR Error: Boolean);

   PROCEDURE Pop (VAR Stack: StackType;
                  VAR TopElement: StackDataType;
                  VAR Error: Boolean);

   PROCEDURE Peek (VAR Stack: StackType;
                   VAR TopElement: StackDataType;
                   VAR Error: Boolean);


                            IMPLEMENTATION

//*****************************************************************************
//** Procedure InitStack :
//** Clears a given stack (Stack), preparing it to receive elements.
//*****************************************************************************
   PROCEDURE InitStack (VAR Stack: StackType);

      VAR I: StackIndexType;

      BEGIN
         Stack.StackTop := 0
      END;


//*****************************************************************************
//** Function Empty:
//** Returns TRUE if there are no elements of the stack (Stack),
//** FALSE otherwise.
//*****************************************************************************
   FUNCTION Empty (VAR Stack: StackType): Boolean;
      BEGIN
         Empty := (Stack.StackTop = 0)
      END;

//*****************************************************************************
//** Function GetStackSize:
//** Returns the number of elements on a given stack (Stack).
//** Returns 0 if Stack is empty.
//*****************************************************************************
   FUNCTION GetStackSize (VAR Stack: StackType): StackIndexType;
      BEGIN  //** GetStackSize
         GetStackSize := Stack.StackTop
      END;  //** GetStackSize

//*****************************************************************************
//** Procedure Push :
//** Puts the element (NewData) onto the stack (Stack).
//** If the stack is full, leaves the stack intact and returns an
//** error (sets Error to True).
//*****************************************************************************
   PROCEDURE Push (VAR Stack: StackType; NewData: StackDataType; VAR Error: Boolean);
      BEGIN
         IF Stack.StackTop < MaxStackSize THEN
            BEGIN  //** there is more space on the stack
               Stack.StackTop := Stack.StackTop + 1;
               Stack.StackData [Stack.StackTop] := NewData;
               Error := False;
            END    
               ELSE
                  Error := True  //** stack full
      END;

//*****************************************************************************
//** Procedure Pop :
//** Retrievs an element (TopElements) from the stack (Stack).
//** If the stack is empty, returns an error (sets Error to True).
//*****************************************************************************
   PROCEDURE Pop (VAR Stack: StackType; VAR TopElement: StackDataType; VAR Error: Boolean);
      BEGIN
         IF Stack.StackTop > 0 THEN
            BEGIN  //** there is at least 1 element on the stack
               TopElement := Stack.StackData [Stack.StackTop];
               Stack.StackTop := Stack.StackTop - 1;
               Error := False
            END
               ELSE
                  Error := True   //** stack empty
      END;

//*****************************************************************************
//** Procedure Peek :
//** Returns an element (TopElement) at the top of the stack (Stack), but
//** does NOT remove it from the stack, so the next call to Push will
//** return this element.  This allows the program to "look ahead" before
//** retrieving the next data item.  If the stack is empty, returns an error
//**(sets Error to True).
//*****************************************************************************
   PROCEDURE Peek (VAR Stack: StackType; VAR TopElement: StackDataType; VAR Error: Boolean);
          BEGIN
         IF Stack.StackTop > 0 THEN
            BEGIN  //** there is at least 1 element on the stack
               TopElement := Stack.StackData [Stack.StackTop];
               Error := False
            END
               ELSE
                  Error := True   //** stack empty
      END;

   END.
//******************************************************************************







