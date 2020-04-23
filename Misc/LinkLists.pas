/    *****************************************************************
//    ** COMPANY NAME:  HPA Systems
//    *****************************************************************
//    ** Application......:
//    **
//    ** Module Name......: LinkedLists.pas
//    ** Program Name.....: 
//    ** Program Description: Library of Linked List Procedures/Functions.
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

//***************************************************************************
//** AppendList - Append a item to a Linked List
//***************************************************************************
Procedure AppendList(var StartAdr: PtrDataRec; Item: PtrDataRec; Sorted: Boolean);

VAR
        hz: PtrDataRec;

//** This will put the item to any place you like
Procedure SortItemToList;

VAR
        tmp: PtrDataRec;
        nz: PtrDataRec;
        flag: boolean;

Begin
        If StartAdr = Nil Then
                //** This is the first element of the list, no need to sort
                StartAdr:= Item
        Else
            Begin
                //** Sort the Linked List
                //** Sort Criteria - put in ID# order
                //** of names to keep it easy
                //** Insert at list begin
                If Item^.ID < StartAdr^.ID Then
                  Begin
                        //** Store old list begin
                        tmp:= StartAdr;
                        //** List begin is now the new item
                        StartAdr:= Item;
                        //** New item's next points to old list begin
                        Item^.NextRec:= tmp;
                  End
                Else
                    Begin
                      //** Starting search for proper position at list beginning
                        tmp:= StartAdr;
                        //** Pointer for outlook on next data record
                        nz:= tmp^.NextRec;
                        //** Flag indicating end of search
                        Flag:= False;

                        Repeat
                              If nz = Nil Then
                                 //** There are no more items behing this,
                                 //** put it to the end
                                 Flag:= True
                              Else
                                  Begin
                                        If nz^.ID > Item^.ID Then
                                    //** We have to put our item before the next
                                          Flag:= True
                                        Else
                                      //** no matching position found, search on
                                            Begin
                                                 nz:= nz^.NextRec;
                                                 tmp:= tmp^.NextRec;
                                            End;
                                  End;
                        Until Flag;
                        //** Store old pointer to next element
                        nz:= tmp^.NextRec;
                        //** Place Item as next item
                        tmp^.NextRec:= Item;
                        //** Continue list with old next item
                        Item^.NextRec:= nz;
                    End;
            End;
  End;
//**************** End of SortItemToList()

Begin  //** AppendList()

     If Sorted Then
        SortItemtoList
     Else
         Begin
              If StartAdr = Nil Then
                 //** first element in list, that's all to do
                 StartAdr:= Item
              Else
                  Begin
                        //** set a temporary pointer to list begin
                        hz:= StartAdr;
                        //** Look for end of list
                        While hz^.NextRec <> Nil Do
                             hz:= hz^.NextRec;
                             //** set pointer to new element
                             //** which is now at the end of the list
                             hz^.NextRec:= Item;
                  End;
         End;
End;
//*****************************************************************************

//***************************************************************************
//** RemoveItem - Remove an item from a Linked List
//***************************************************************************
Procedure RemoveItem(var StartAdr: PtrDataRec; DelItem: PtrDataRec);

VAR
        tmp: PtrDataRec;

Begin
        If StartAdr = nil Then
          //** List is empty
          Exit;

        //** Delete first element
        If DelItem = StartAdr Then
          Begin
               //** Set list begin to second element
               StartAdr:= StartAdr^.NextRec;
               //** remove first element
               Dispose(DelItem);
          End
        Else
            Begin
                  tmp:= StartAdr;
                  //** find previous element
                  While tmp^.NextRec <> DelItem Do
                        tmp:= tmp^.NextRec;
                        //** bypasssing the element to be deleted
                        tmp^.NextRec:= DelItem^.NextRec;
                        //** Finally delete the item - So we don't leave any
                        //** Memory Leaks!
                        Dispose(DelItem);
            End;
End;
//****************************************************************************

//***************************************************************************
//** FindItem - Find an item from a Linked List
//***************************************************************************
Function FindItem(StartAdr: PtrDataRec; IDNum: Integer): PtrDataRec;

VAR
        tmp: PtrDataRec;
        Item: PtrDatarec;
Begin
        //** Assuming that the ID# can't be found
        Item:= Nil;
        
        //** Yes, the list has at least one item
        If StartAdr <> nil Then
          Begin
               tmp:= StartAdr;
               While (tmp^.NextRec <> nil) and (tmp^.ID <> IDNum) Do
                    Begin

                        //** Check the next element
                        tmp:= tmp^.NextRec;
                    End;
               If tmp^.ID = IDNum Then
                 Item:= tmp;
          End;

        //**Giving back a pointer to the first data record with this name }
        FindItem:= Item;

End;
//****************************************************************************

//***************************************************************************
//** FindRec - Find an item from a Linked List
//***************************************************************************
Procedure FindRec;
VAR
        IDNum: Integer;
        DspRec: PtrDataRec;

Begin
        Write('Please input the ID# you wish to see: ');
        Readln(IDNum);
        Writeln;

        DspRec:= FindItem(StartRec, IDNum);
        If DspRec <> Nil Then
          Begin
               Write('ID# ', DspRec^.ID, Space, 'has ', DspRec^.Cash:10:2);
               Write(Space, 'cash on hand.');
               Writeln;
          End
        Else //** No record exists
               Writeln('No Record exists for ID# ', IDNum);

End;

//***************************************************************************
//** CreateRec - Create an item for a Linked List
//***************************************************************************
Procedure CreateRec;
VAR
        IDNum: Integer;
        rlCashOH: Real;
        NewRec: PtrDataRec;

Begin

        NewRec:=New(PtrDataRec);

        //** Fill data fields
        with NewRec^ Do
            Begin
                Write('Please input the ID# : ');
                Readln(IDNum);
                Writeln;
                ID:= IDNum;

                Write('Please Input the Amount of Cash on Hand: ');
                Readln(rlCashOH);
                Writeln;
                Cash:=rlCashOH;

                NextRec:=nil;
            End;

        //** Add the item to the list
        AppendList(StartRec,NewRec,true);

End;

//***************************************************************************
//** DspRec - Display all items in the Linked List
//***************************************************************************
Procedure DspRec(Item: PtrDatarec);
Begin

   Writeln('The following records are in the List: ');
   While Item <> Nil Do
        Begin
          Writeln('ID ', Item^.ID, Space, 'Has ', Item^.Cash:10:2, ' cash on hand.');
          Item:= Item^.NextRec;
        End;


End;

//***************************************************************************
//** DelteRec - Delete an item in the Linked List
//***************************************************************************
Procedure DeleteRec;

VAR
        IDNumb: Integer;
        DelRec: PtrDataRec;

Begin
        //** Input ID# to delete
        Write('Please input the ID# to delete: ');
        Readln(IDNumb);
        Writeln;

        //** Call FindRec w/ID# - get return pointer to record to delete
        DelRec:= FindItem(StartRec, IDNumb);

        If DelRec <> Nil Then
           Begin
                //** Call RemoveItem - passing Pointer to record to delete
                RemoveItem(StartRec,DelRec);
                Writeln('ID# ', IDNumb, Space, ' has been Deleted.');
           End
        Else
           //** No record exists
           Writeln('No record exists for ID# ', IDNumb);
End;

