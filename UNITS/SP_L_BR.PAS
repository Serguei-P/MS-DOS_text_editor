{$I defs.inc}

{*****************************************************************************
*               ������⥪� ��ꥪ⮢ ��� ࠡ��� � ᯨ᪠��.                  *
*             ���� : ��ࣥ� ���类�   ��� "������"   1993 �.                *
*             �࠭���� : Turbo-Pascal 7.0 (c) Borland Int.                 *
******************************************************************************}
Unit SP_L_Br;

Interface

Uses SP_Types,SP_List,SP_DOS,SP_CRT,SP_Intrf;

{ ��ꥪ� BrowseList - ᯨ᮪ � ��㧥஬ }
Type BrowseList = object(ListObject)
                   Private
                    CurrBrowsePos  : word; 
                   Public
                    MaxBrowsePos   : word;
                    RealMaxPos     : word;
                    X1,X2,Y1,Y2    : byte; { ���न���� ���� ��㧥� (��� ��� ࠬ��) }
                    NAttr          : byte; { ���ਡ�� 梥� ࠬ�� }
                    FAttr          : byte; { ���ਡ�� 梥� ������⮢ ᯨ᪠ }
                    HAttr          : byte; { ���ਡ�� 梥� �뤥������� ������� ᯨ᪠ }
                    HeaderSize     : byte; { ������ ��������� }
                    BottomSize     : byte;
                    Constructor Init ( X0,Y0     : byte; { ��������� ������ ���孥�� 㣫� }
                                       Xl,Yl     : byte; { ����� � ���� ��㧥� }
                                       NormAttr  : byte; { ���ਡ�� ࠬ�� }
                                       FieldAttr : byte; { ���ਡ�� ������⮢ ᯨ᪠ }
                                       HighAttr  : byte  { ���ਡ�� �뤥������� ������� ᯨ᪠ } );
                     { �������� ���� ������� ᯨ᪠ }
                    Procedure ShowOneLine ( N    : word; { ����� ������� ᯨ᪠ � ���� ��㧥� }
                                            Attr : byte  { ���ਡ�� 梥� } ); virtual;
                     { �������� ���� ����࠭�� ������� ᯨ᪠ }
                    Procedure ShowOneElement ( N : word ); virtual;
                     { �������� ���� ��࠭�� ������ ᯨ᪠ � ������� ����⨥ ������ }
                    Procedure HighlightOneElement ( N : word ); virtual;
                     { ���ᮢ��� ���� ��㧥� }
                    Procedure DrawBrowseWindow; virtual;
                     { ��ࠡ�⪠ �㭪樮������ ������ }
                    Procedure ParseHotKeys; virtual;
                     { �������� ���� ������� � ᯨ᮪ }
                    Procedure AddNewElement; virtual;
                     { ����� �� ����� ������ ��� �� �뤥������ ������� ᯨ᪠ }
                    Function  MyMouseClick : boolean;
                     { �맢��� ��㧥� }
                    Procedure Browse;
                     { �������� ���� � ������⠬� ᯨ᪠ }
                    Procedure Show;
                     { ������஢��� ᯨ᮪ }
                    Procedure Edit;
                  end;

{ ��ꥪ� FileDescription - ���ᠭ�� 䠩��-������� ᯨ᪠ 䠩��� }
Type FileDescription = object(ListElement)
                         Name     : string[13]; { ��� 䠩�� }
                         FileAttr : byte;       { ���ਡ�� 䠩�� }
                         Time     : longint;    { �६� ᮧ����� 䠩�� }
                         Date     : longint;    { ��� ᮧ����� 䠩�� }
                         Size     : longint;    { ࠧ��� 䠩�� }
                         Constructor Init ( FileFound : FindFileRecord );
                       end;
     FileDescriptionPtr = ^FileDescription;

{ ��ꥪ� ListOfFiles - ᯨ� 䠩��� }
Type ListOfFiles = object(BrowseList)
                     DirectoryName : string[67]; { ��� ��⠫��� }
                     Constructor Init ( X0,Y0    : byte;   { ���न���� ������ ���孥�� 㣫� ���� }
                                        Yl       : byte;   { ������⢮ ��ப � ���� }
                                        NormAttr : byte;   { 梥� ���� }
                                        HighAttr : byte;   { 梥� ����� �뤥������� 䠩�� }
                                        Mask     : string; { ��᪠ ����� 䠩�� }
                                        Attrib   : byte ); { ��᪠ ���ਡ�� 䠩�� }
                     Constructor Find ( Mask   : string;
                                        Attrib : byte );
                     Procedure ShowOneElement ( N : word ); virtual;
                     Procedure HighlightOneElement ( N : word ); virtual;
                     Function  FirstGreater ( Element1,Element2 : ListElementPtr ) : boolean; virtual;
                   end;

Implementation

{**************************** BrowseList object *****************************}

Constructor BrowseList.Init ( X0,Y0,Xl,Yl,NormAttr,FieldAttr,HighAttr : byte );
begin
  Inherited Init;
  X1:=X0;
  Y1:=Y0;
  Y2:=Y1+Yl-1;
  X2:=X1+Xl-1;
  MaxBrowsePos:=Y2-Y1+1;
  HeaderSize:=1;
  BottomSize:=1;
  NAttr:=NormAttr;
  FAttr:=FieldAttr;
  HAttr:=HighAttr;
  CurrBrowsePos:=1
end;

Procedure BrowseList.Show;
var i : word;
    P : ListElementPtr;
begin
  P:=CurrentElement;
  i:=0;
  While (i<MaxBrowsePos) and Assigned(P) do
    begin
      Inc ( i );
      ShowOneElement ( i );
      P:=P^.Next
    end
end;

Procedure BrowseList.ShowOneLine ( N : word; Attr : byte );
begin
end;

Procedure BrowseList.ShowOneElement ( N : word );
begin
  ShowOneLine ( N,FAttr )
end;

Procedure BrowseList.HighlightOneElement ( N : word );
begin
  ShowOneLine ( N,HAttr );
  WaitEvent;
  If (MouseButton=LeftMouseButton) and
     (MouseX>=X1) and (MouseX<=X2) and
     (MouseY=Y1+N-1) then
    begin
      ClearEvent;
      KeyEvent:=Key_Enter
    end
end;

Procedure BrowseList.Browse;
var i           : word;
    LastElement : ListElementPtr;
    Count       : longint;
    T           : longint;
    HElement    : ListElementPtr;
begin
  T:=TimerTickCount;
  Count:=CountOfElements;
  RealMaxPos:=1;
  LastElement:=FirstElement;
  While Assigned(LastElement) and Assigned(LastElement^.Next) do
    begin
      LastElement:=LastElement^.Next;
      If RealMaxPos<MaxBrowsePos then  Inc ( RealMaxPos )
    end;
  i:=1;
  While (i<MaxBrowsePos) and (LastElement<>FirstElement) do
    begin
      LastElement:=LastElement^.Prev;
      Inc ( i )
    end;
  While (CurrBrowsePos<RealMaxPos) and Assigned(CurrentElement^.Prev) do
    begin
      Inc ( CurrBrowsePos );
      CurrentElement:=CurrentElement^.Prev
    end;
  Repeat
    Show;
    Repeat
      HElement:=CurrentElement;
      If Assigned(FirstElement) then
        begin
          SetVerticalScrollBar ( X2+1,Y1,Y2-Y1+1,NAttr,(NAttr shr 4) or lo(NAttr shl 4) );
          If Count>1 then
            ShowVerticalScrollBar ( ((CurrElementNumber+CurrBrowsePos-2)*100 div (Count-1)) )
           else
            ShowVerticalScrollBar ( 0 );
          HighlightOneElement ( CurrBrowsePos );
          ShowOneElement ( CurrBrowsePos );
          If MyMouseClick then  ClearEvent;
          ClearMouseKeys ( 'V' )
        end
       else
        WaitEvent;
      Case KeyEvent of
        Key_Down : If CurrBrowsePos<RealMaxPos then
                     begin
                       Inc ( CurrBrowsePos );
                       ClearEvent
                     end;
          Key_Up : If CurrBrowsePos>1 then
                     begin
                       Dec ( CurrBrowsePos );
                       ClearEvent
                     end
      end;
      If MouseButton=LeftMouseButton then
        begin
          If (MouseX>=X1) and (MouseX<=X2) and
             (MouseY>=Y1) and (MouseY<=Y1+RealMaxPos-1) then
            begin
             MouseButton:=0;
             If CurrBrowsePos=MouseY-Y1+1 then
               KeyEvent:=Key_Enter
              else
               begin
                 CurrBrowsePos:=MouseY-Y1+1;
                 ClearEvent
               end
            end
        end
    until AnyEvent;
    Case KeyEvent of
          Key_Down : begin
                       If LastElement<>CurrentElement then  SkipNext;
                       ClearEvent
                     end;
            Key_Up : begin
                       If FirstElement<>CurrentElement then  SkipPrev;
                       ClearEvent
                     end;
        cmMoveDown : begin
                       Repeat
                       until TimerTickCount-T>0;
                       T:=TimerTickCount;
                       If LastElement<>CurrentElement then  SkipNext;
                       ClearEvent
                     end;
          cmMoveUp : begin
                       Repeat
                       until TimerTickCount-T>0;
                       T:=TimerTickCount;
                       If FirstElement<>CurrentElement then  SkipPrev;
                       ClearEvent
                     end;
          Key_PgDn : begin
                       i:=0;
                       While (i<MaxBrowsePos) and (LastElement<>CurrentElement) do
                         begin
                           SkipNext;
                           Inc ( i )
                         end;
                       CurrBrowsePos:=RealMaxPos;
                       ClearEvent
                     end;
          Key_PgUp : begin
                       i:=0;
                       While (i<MaxBrowsePos) and (FirstElement<>CurrentElement) do
                         begin
                           SkipPrev;
                           Inc ( i )
                         end;
                       CurrBrowsePos:=1;
                       ClearEvent
                     end;
      Key_CtrlPgUp : begin
                       CurrentElement:=FirstElement;
                       CurrBrowsePos:=1;
                       ClearEvent
                     end;
      Key_CtrlPgDn : begin
                       CurrentElement:=LastElement;
                       CurrBrowsePos:=RealMaxPos;
                       ClearEvent
                     end
    end
  until AnyEvent and ((MouseButton<>LeftMouseButton) or
                      (MouseX<X1) or (MouseX>X2) or
                      (MouseY<Y1) or (MouseY>Y2));
  i:=1;
  While i<CurrBrowsePos do
    begin
      CurrentElement:=CurrentElement^.Next;
      Inc ( i )
    end;
  CurrBrowsePos:=1
end;

Procedure BrowseList.DrawBrowseWindow;
begin
  DrawBox ( X1-1,Y1-HeaderSize,X2+1,Y2+BottomSize,NAttr,NormBoxString,Shadow );
  MaxBrowsePos:=Y2-Y1+1;
  FillBoxWith ( X1,Y1,X2,Y2,$20,NAttr )
end;

Procedure BrowseList.Edit;
var SavedScreen : BoxContType;
begin
  SaveBoxContents ( SavedScreen,X1-1,Y1-HeaderSize,X2+2,Y2+1+BottomSize );
  Repeat
    DrawBrowseWindow;
    Browse;
    ClearMouseKeys ( 'B' );
    ParseHotKeys
  until AnyEvent;
  RestoreBoxContents ( SavedScreen )
end;

Procedure BrowseList.AddNewElement;
begin
end;

Procedure BrowseList.ParseHotKeys;
begin
  Case KeyEvent of
    Key_F8 : begin
               If CurrentElement<>nil then
                 RemoveCurrentElement;
               ClearEvent
             end;
    Key_F9 : begin
               AddNewElement;
               ClearEvent
             end
  end
end;

Function BrowseList.MyMouseClick : boolean;
begin
  If (MouseButton=LeftMouseButton) and
     (MouseY=Y1+CurrBrowsePos-1) and
     (MouseX>=X1) and (MouseX<=X2) then  MyMouseClick:=true  else  MyMouseClick:=false
end;


{************************** FileDescription object **************************}

Constructor FileDescription.Init ( FileFound : FindFileRecord );
begin
  Name:=ASCIIZtoPascal(FileFound.Name);
  FileAttr:=FileFound.Attr;
  If FileAttr and $10 = 0 then  Name:=LowerCase(Name);
  Time:=FTimeToLongint(FileFound.Time);
  Date:=FDateToLongint(FileFound.Date);
  Size:=FileFound.Size
end;

{*************************** ListOfFiles object *****************************}

Constructor ListOfFiles.Init ( X0,Y0,Yl,NormAttr,HighAttr : byte; Mask : string; Attrib : byte );
var SearchedFile : FindFileRecord;
begin
  Inherited Init ( X0,Y0,1+12+1+8+1+10+1,Yl,NormAttr,NormAttr,HighAttr );
  DirectoryName:=CurrentDirectory;
  If FindFirstFile('*.*',Attrib and $10,SearchedFile) then
    Repeat
      If (ASCIIZtoPascal(SearchedFile.Name)<>'.') and (SearchedFile.Attr=$10) then
        begin
          AddElement ( New(FileDescriptionPtr,Init(SearchedFile)) )
        end
    until not FindNextFile;
  If FindFirstFile(Mask,Attrib and $EF,SearchedFile) then
    Repeat
      AddElement ( New(FileDescriptionPtr,Init(SearchedFile)) )
    until not FindNextFile;
  Sort;
  CurrentElement:=FirstElement
end;

Constructor ListOfFiles.Find ( Mask : string; Attrib : byte );
var Xl : byte;
begin
  Xl:=1+12+1+8+1+10+1;
  Init ( (MaxTextX-Xl) div 2,6,15,$07,$70,Mask,Attrib )
end;

Procedure ListOfFiles.ShowOneElement ( N : word );
var P : FileDescriptionPtr;
    C : char;
begin
  P:=NextElementPointer(N-1);
  C:=' ';
  If P^.FileAttr and $01>0 then  C:='@';
  If P^.FileAttr and $10 = 0 then
    WriteString ( C+PadR(P^.Name,12)+' '+
                  PadR(LIntToStr(P^.Size),8)+' '+
                  DateToStr(P^.Date)+' ',
                  Y1+N-1,X1,FAttr )
   else
    WriteString ( C+PadR(P^.Name,12)+' '+'<�������>           ',Y1+N-1,X1,FAttr )
end;

Procedure ListOfFiles.HighlightOneElement ( N : word );
var P : FileDescriptionPtr;
    C : char;
begin
  P:=NextElementPointer(N-1);
  C:=' ';
  If P^.FileAttr and $01>0 then  C:='@';
  If P^.FileAttr and $10 = 0 then
    WriteString ( C+PadR(LowerCase(P^.Name),12)+' '+PadR(LIntToStr(P^.Size),8)+' '+DateToStr(P^.Date)+' ',
                  Y1+N-1,X1,HAttr )
   else
    WriteString ( C+PadR(P^.Name,12)+' '+'<�������>           ',Y1+N-1,X1,HAttr );
  WaitEvent;
  Case KeyEvent of
    Key_Home : KeyEvent:=Key_CtrlPgUp;
     Key_End : KeyEvent:=Key_CtrlPgDn
  end
end;

Function ListOfFiles.FirstGreater ( Element1,Element2 : ListElementPtr ) : boolean;
var File1 : FileDescriptionPtr absolute Element1;
    File2 : FileDescriptionPtr absolute Element2;
begin
  If File1^.Name>File2^.Name then  FirstGreater:=true  else  FirstGreater:=false
end;

end.
