{$I defs.inc}

{*****************************************************************************
*               Библиотека объектов для работы со списками.                  *
*                   Автор : Сергей Поляков, (c)  1993 г.                     *
*             Транслятор : Turbo-Pascal 7.0 (c) Borland Int. Inc.            *
******************************************************************************}
Unit SP_List;

Interface

Uses SP_Types,SP_DOS;

Type AbstractList = object
                      BoList : boolean;
                      EoList : boolean;
                      Constructor Init;
                      Destructor Done; virtual;
                       { Перейти к следующему элементу }
                      Procedure Skip; virtual;
                       { Перейти к предыдущему элементу }
                      Procedure SkipBack; virtual;
                       { Перейти к N-ому элементу списка }
                      Procedure GoToElement ( N : longint ); virtual;
                       { Номер текущего элемента }
                      Function CurrElementNumber : longint; virtual;
                       { Перейти к началу списка }
                      Procedure GoTop; virtual;
                       { Перейти к концу списка }
                      Procedure GoBottom; virtual;
                      Function  ForCondition : boolean; virtual;
                      Function  CountOfElements : longint; virtual;
                    end;
     AbstractListPtr = ^AbstractList;

{ Объект ListElement - элемент списка }
Type ListElementPtr = ^ListElement;
     ListElement    = object
                        Prev : ListElementPtr; { указатель на предыдущий элемент }
                        Next : ListElementPtr; { указатель на следующий элемент }
                        Constructor Init;
                        Destructor Done; virtual;
                        Procedure Print; virtual;
                      end;

{ Объект ListObject - список }
Type ListObject = object(AbstractList)
                    FirstElement   : ListElementPtr; { указатель на первый элемент списка }
                    CurrentElement : ListElementPtr; { указатель на текущий элемент }
                    Constructor Init;
                    Destructor Done; virtual;
                     { Добавить один элемент в список }
                    Procedure AddElement ( P0 : ListElementPtr );
                     { Вставить один элемент в список, перед элементом P }
                    Procedure InsertElement ( P0 : ListElementPtr );
                     { Удалить текущий элемент }
                    Procedure RemoveCurrentElement; virtual;
                     { Перейти к следующему элементу }
                    Procedure SkipNext;
                     { Перейти к предыдущему элементу }
                    Procedure SkipPrev;
                     { Перейти к следующему элементу }
                    Procedure Skip; virtual;
                     { Перейти к предыдущему элементу }
                    Procedure SkipBack; virtual;
                     { Перейти к началу списка }
                    Procedure GoTop; virtual;
                     { Перейти к концу списка }
                    Procedure GoBottom; virtual;
                     { Указатель на N-ый элемент списка }
                    Function  ElementPointer ( N : longint ) : pointer;
                     { Указатель на следующий (при N=1) элемент списка }
                    Function  NextElementPointer ( N : longint ) : pointer;
                     { Перейти к N-ому элементу списка }
                    Procedure GoToElement ( N : longint ); virtual;
                     { Номер текущего элемента списка }
                    Function  CurrElementNumber : longint; virtual;
                     { Номер элемента }
                    Function  ElementNumber ( P : ListElementPtr ) : longint; virtual;
                     { Число элементов списка }
                    Function  CountOfElements : longint; virtual;
                     { Найти элемент списка, удовлетворяющего условию ElementFound }
                    Function  FindElement ( S : string ) : pointer;
                     { Условие для поиска элемента списка }
                    Function  ElementFound ( S : string ) : boolean; virtual;
                     { Напечатать весь список }
                    Procedure PrintAll;
                     { Функция, возвращающая true если значение элемента, на 
                       который указывает указатель Element1 больше значения
                       элемента указываемого Element2 (вызывается методом Sort) }
                    Function  FirstGreater ( Element1,Element2 : ListElementPtr ) : boolean; virtual;
                     { Поменять местами два элемента (вызывается методом Sort) }
                    Procedure SwapElements ( Element1,Element2 : ListElementPtr );
                     { Сортировать список }
                    Procedure Sort;
                    Function PositionProcent ( Element : ListElementPtr ) : integer;
                  end;
     ListObjectPtr = ^ListObject;

Type FileDescription = object(ListElement)
                         Name : string[12];
                         Time : word;
                         Date : DateType;
                         Size : longint;
                         Attr : byte;
                         Constructor Init;
                       end;
     FileDescriptionPtr = ^FileDescription;

Type ListOfFilesObject = object(ListObject)
                           Constructor Init ( Mask : string;
                                              Attr : byte );
                         end;
     ListOfFilesObjectPtr = ^ListOfFilesObject;

Implementation

{**************************** AbstractList object ***************************}

Constructor AbstractList.Init;
begin
  BoList:=false;
  EoList:=false
end;

Destructor AbstractList.Done;
begin
end;

Procedure AbstractList.GoTop;
begin
end;

Procedure AbstractList.GoBottom;
begin
end;

Procedure AbstractList.Skip;
begin
end;

Procedure AbstractList.SkipBack;
begin
end;

Procedure AbstractList.GoToElement ( N : longint );
begin
end;

Function AbstractList.CurrElementNumber : longint;
begin
  CurrElementNumber:=0
end;

Function AbstractList.ForCondition : boolean;
begin
  ForCondition:=true
end;

Function AbstractList.CountOfElements : longint;
begin
  CountOfElements:=0
end;

{***************************** ListElement object ***************************}

Constructor ListElement.Init;
begin
  Prev:=nil;
  Next:=nil
end;

Destructor ListElement.Done;
begin
end;

Procedure ListElement.Print;
begin
end;

{**************************** ListObject object *****************************}

Constructor ListObject.Init;
begin
  Inherited Init;
  FirstElement:=nil;
  CurrentElement:=nil;
  EoList:=true;
  BoList:=true
end;

Destructor ListObject.Done;
var P,P0 : ListElementPtr;
begin
  P:=FirstElement;
  If P<>nil then
    begin
      While P^.Next<>nil do
        begin
          P:=P^.Next
        end;
      Repeat
        P0:=P^.Prev;
        Dispose ( P,Done );   { Done - virtual destructor }
        P:=P0
      until P=nil
    end;
  FirstElement:=nil;
  CurrentElement:=nil;
  Inherited Done
end;

Var PP : pointer;

Procedure ListObject.AddElement ( P0 : ListElementPtr );
var P : ListElementPtr;
begin
  If P0=nil then  Exit;
  BoList:=false;
  EoList:=false;
  P:=CurrentElement;
  If PP<>P then
    begin
      P:=CurrentElement
    end;
  PP:=P0;
  If P<>nil then
    begin
      While P^.Next<>nil do
        P:=P^.Next;
      P^.Next:=P0;
      P0^.Prev:=P;
      P0^.Next:=nil;
      CurrentElement:=P0
    end
   else
    begin
      FirstElement:=P0;
      FirstElement^.Prev:=nil;
      FirstElement^.Next:=nil;
      CurrentElement:=P0
    end
end;

Procedure ListObject.InsertElement ( P0 : ListElementPtr );
var P : ListElementPtr;
begin
  If P0=nil then  Exit;
  BoList:=false;
  EoList:=false;
  P:=CurrentElement;
  If P<>nil then
    begin
      If P^.Prev<>nil then  P^.Prev^.Next:=P0  else  FirstElement:=P0;
      P0^.Prev:=P^.Prev;
      P0^.Next:=P;
      P^.Prev:=P0
    end
   else
    AddElement ( P0 )
end;

Procedure ListObject.RemoveCurrentElement;
var P : ListElementPtr;
begin
  If CurrentElement=nil then  Exit;
  P:=CurrentElement;
  If CurrentElement^.Prev<>nil then  CurrentElement^.Prev^.Next:=CurrentElement^.Next;
  If CurrentElement^.Next<>nil then  CurrentElement^.Next^.Prev:=CurrentElement^.Prev;
  If P^.Next<>nil then
    CurrentElement:=P^.Next
   else
    CurrentElement:=P^.Prev;
  If FirstElement=P then  FirstElement:=FirstElement^.Next;
  If FirstElement=nil then
    begin
      BoList:=true;
      EoList:=true
    end;
  Dispose ( P,Done )
end;

Procedure ListObject.SkipNext;
begin
  If CurrentElement^.Next<>nil then
    begin
      BoList:=false;
      CurrentElement:=CurrentElement^.Next
    end
   else
    EoList:=true
end;

Procedure ListObject.SkipPrev;
begin
  If CurrentElement^.Prev<>nil then
    begin
      EoList:=false;
      CurrentElement:=CurrentElement^.Prev
    end
   else
    BoList:=true
end;

Procedure ListObject.Skip;
begin
  SkipNext
end;

Procedure ListObject.SkipBack;
begin
  SkipPrev
end;

Procedure ListObject.GoTop;
begin
  CurrentElement:=FirstElement;
  If FirstElement<>nil then
    begin
      BoList:=false;
      EoList:=false
    end
end;

Procedure ListObject.GoBottom;
begin
  If CurrentElement<>nil then
    begin
      While CurrentElement^.Next<>nil do  CurrentElement:=CurrentElement^.Next;
      BoList:=false;
      EoList:=false
    end
end;

Function ListObject.ElementPointer ( N : longint ) : pointer;
var P : ListElementPtr;
    i : longint;
begin
  P:=FirstElement;
  i:=1;
  While (i<N) and Assigned(P) do
    begin
      P:=P^.Next;
      Inc ( i )
    end;
  ElementPointer:=P
end;

Function ListObject.NextElementPointer ( N : longint ) : pointer;
var P : ListElementPtr;
    i : longint;
begin
  P:=CurrentElement;
  i:=0;
  While (i<N) and Assigned(P) and Assigned(P^.Next) do
    begin
      P:=P^.Next;
      Inc ( i )
    end;
  NextElementPointer:=P
end;

Procedure ListObject.GoToElement ( N : longint );
begin
  If FirstElement=nil then  Exit;
  BoList:=false;
  EoList:=false;
  CurrentElement:=FirstElement;
  While (N>1) and Assigned(CurrentElement^.Next) do
    begin
      Dec ( N );
      CurrentElement:=CurrentElement^.Next
    end
end;

Function ListObject.CurrElementNumber : longint;
var i : word;
    P : ListElementPtr;
begin
  i:=1;
  P:=FirstElement;
  If P<>nil then
    begin
      While (P<>CurrentElement) and (P<>nil) do
        begin
          Inc ( i );
          P:=P^.Next
        end;
      CurrElementNumber:=i
    end
   else  CurrElementNumber:=0
end;

Function ListObject.ElementNumber ( P : ListElementPtr ) : longint;
var i  : longint;
    P1 : ListElementPtr;
begin
  i:=0;
  ElementNumber:=0;
  P1:=FirstElement;
  While P1<>nil do
    begin
      Inc ( i );
      If P=P1 then
        begin
          ElementNumber:=i;
          break
        end;
      P1:=P1^.Next
    end
end;

Function ListObject.CountOfElements : longint;
var i : word;
    P : ListElementPtr;
begin
  i:=0;
  P:=FirstElement;
  While Assigned(P) do
    begin
      Inc ( i );
      P:=P^.Next
    end;
  CountOfElements:=i
end;

Function ListObject.FindElement ( S : string ) : pointer;
var P : ListElementPtr;
begin
  P:=CurrentElement;
  CurrentElement:=FirstElement;
  FindElement:=nil;
  If not Assigned(P) then  Exit;
  While (not ElementFound(S)) and Assigned(CurrentElement^.Next) do  CurrentElement:=CurrentElement^.Next;
  If ElementFound(S) then  FindElement:=CurrentElement;
  CurrentElement:=P
end;

Function ListObject.ElementFound ( S : string ) : boolean;
begin
  ElementFound:=false
end;

Procedure ListObject.PrintAll;
var P : ListElementPtr;
begin
  P:=FirstElement;
  While Assigned(P) do
    begin
      P^.Print;
      P:=P^.Next
    end
end;


Function ListObject.FirstGreater ( Element1,Element2 : ListElementPtr ) : boolean;
begin
  FirstGreater:=false
end;

Procedure ListObject.SwapElements ( Element1,Element2 : ListElementPtr );
var N1,P1 : ListElementPtr;
    N2,P2 : ListElementPtr;
begin
  If Element1=nil then  Exit;
  If Element2=nil then  Exit;
  BoList:=false;
  EoList:=false;
  If Element1=FirstElement then
    FirstElement:=Element2
   else
    If Element2=FirstElement then
      FirstElement:=Element1;
  N1:=Element1^.Next;
  P1:=Element1^.Prev;
  N2:=Element2^.Next;
  P2:=Element2^.Prev;
  If N1=Element2 then
    begin
      Element1^.Next:=N2;
      If N2<>nil then  N2^.Prev:=Element1;
      Element1^.Prev:=Element2;
      Element2^.Next:=Element1;
      Element2^.Prev:=P1;
      If P1<>nil then  P1^.Next:=Element2
    end
   else
    If P1=Element2 then
      begin
        Element1^.Next:=Element2;
        Element1^.Prev:=P2;
        If P2<>nil then  P2^.Next:=Element1;
        Element2^.Next:=N1;
        If N1<>nil then  N1^.Prev:=Element2;
        Element2^.Prev:=Element1
      end
     else
      begin
        Element1^.Next:=N2;
        If N2<>nil then  N2^.Prev:=Element1;
        Element1^.Prev:=P2;
        If P2<>nil then  P2^.Next:=Element1;
        Element2^.Next:=N1;
        If N1<>nil then  N1^.Prev:=Element2;
        Element2^.Prev:=P1;
        If P1<>nil then  P1^.Next:=Element2
      end
end;

Procedure ListObject.Sort;
var P1,P2 : ListElementPtr;
    OK    : boolean;
begin
  If FirstElement=nil then  Exit;
  BoList:=false;
  EoList:=false;
  Repeat
    OK:=true;
    P1:=FirstElement;
    P2:=P1^.Next;
    While (P1<>nil) and (P2<>nil) do
      begin
        If FirstGreater(P1,P2) then
          begin
            SwapElements ( P1,P2 );
            P2:=P1^.Next;
            OK:=false
          end
         else
          begin
            P1:=P2;
            P2:=P1^.Next
          end
      end
  until OK
end;

Function ListObject.PositionProcent ( Element : ListElementPtr ) : integer;
var P  : ListElementPtr;
    OK : boolean;
    N1 : word;
    N0 : word;
begin
  OK:=false;
  N0:=0;
  N1:=0;
  P:=FirstElement;
  While P<>nil do
    begin
      If not OK then
        begin
          If P=Element then  OK:=true;
          Inc ( N1 )
        end;
      Inc ( N0 );
      P:=P^.Next
    end;
  If N0>1 then
    PositionProcent:=(N1-1)*100 div (N0-1)
   else
    PositionProcent:=-1
end;

{*************************** FileDescription object *************************}

Constructor FileDescription.Init;
begin
  Inherited Init;
  Name:='';
  Date:=0;
  Time:=0
end;

{************************** ListOfFilesObject object ************************}

Constructor ListOfFilesObject.Init ( Mask : string;
                                     Attr : byte );
var FindRecord : FindFileRecord;
    OK         : boolean;
    Descript   : FileDescriptionPtr;
begin
  Inherited Init;
  OK:=FindFirstFile(Mask,Attr,FindRecord);
  While OK do
    begin
      If MaxAvail<SizeOf(FileDescription) then
        begin
          Done;
          Fail
        end;
      Descript:=New(FileDescriptionPtr,Init);
      Descript^.Name:=ASCIIZtoPascal(FindRecord.Name);
      Descript^.Date:=FDateToLongint(FindRecord.Date);
      Descript^.Time:=FTimeToLongint(FindRecord.Time);
      Descript^.Size:=FindRecord.Size;
      Descript^.Attr:=FindRecord.Attr;
      AddElement ( Descript );
      OK:=FindNextFile
    end
end;


end.
