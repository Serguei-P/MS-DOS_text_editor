Unit SP_Calnd;

Interface

{$DEFINE WithoutDatabase}

Uses SP_Types,
{$IFNDEF WithoutDatabase}
     SP_dBase,
{$EndIf}
     SP_CRT,SP_DOS,SP_List,SP_Intrf,SP_Scr
{$IFNDEF WithoutDatabase}
     ,SP_Form
{$EndIf}
     ;

Type Calendar = object
                  X1,Y1    : byte;
                  NAttr    : byte;
                  WDAttr   : byte;
                  WEAttr   : byte;
                  HAttr    : byte;
                  Month    : byte;
                  Year     : word;
                  Day      : byte;
                  FirstDay : byte;
                  LastDay  : byte;
                  MkShadow : boolean;
                  Scr      : BoxContType;
                  Constructor Init ( X0,Y0       : byte;
                                     NormAttr    : byte;
                                     WorkDayAttr : byte;
                                     WeekEndAttr : byte;
                                     HighAttr    : byte;
                                     TheDate     : longint;
                                     Shadow      : boolean );
                  Destructor Done;
                  Procedure Show;
                  Procedure ShowDay; virtual;
                  Procedure HighlightDay;
                  Procedure GetDay;
                  Procedure GetDayAndMonth;
                end;

{$IFNDEF WithoutDatabase}
Type DiaryBook = object
                   Area                : byte;
                   Calend_X0,Calend_Y0 : byte;
                   Edit_X1,Edit_Y1     : byte;
                   Edit_X2,Edit_Y2     : byte;
                   NAttr,FAttr,
                   SAttr,HAttr         : byte;
                   Constructor Open ( DataName    : string;
                                      IndexName   : string;
                                      X0,Y0       : byte;
                                      X1,Y1,X2,Y2 : byte;
                                      NormAttr    : byte;
                                      FieldAttr   : byte;
                                      SundayAttr  : byte;
                                      HighAttr    : byte );
                   Destructor Close;
                   Procedure MakeIndex ( IndexName : string );
                   Procedure Edit;
                 end;
{$ENDIF}

Function DayOfWeek ( Date : DateType ) : byte;

Function DaysInMonth ( Year : word; Month : byte ) : byte;

Function MakeDate ( Year : word; Month : word; Day : word ) : DateType;

{$IFNDEF WithoutDatabase}
Procedure CreateDiaryBook ( FileName : string );

Function DiaryIndex : string;
{$ENDIF}

Implementation

Const DiaryStringLength = 80;

{$IFNDEF WithoutDatabase}
Type DayDiaryElement = object(ListElement)
                         Time    : TimeType;
                         TextStr : string[DiaryStringLength];
                         Rec     : longint;
                         Changed : boolean;
                         Constructor Init;
                         Destructor Done; virtual;
                       end;

Type DayDiaryList = object(BrowseList)
                      BrowseCol : byte;
                      Date      : DateType;
                      Constructor Init ( X0,Y0,Xl,Yl : byte;
                                         NormAttr    : byte; 
                                         FieldAttr   : byte;
                                         HighAttr    : byte;
                                         TheDate     : DateType );
                      Procedure ShowOneElement ( N : word ); virtual;
                      Procedure HighlightOneElement ( N : word ); virtual;
                      Function  FirstGreater ( Element1,Element2 : ListElementPtr ) : boolean; virtual;
                      Procedure SwapElements ( Element1,Element2 : ListElementPtr ); virtual;
                      Procedure Browse;
                    end;
{$ENDIF}

Function DayOfWeek ( Date : longint ) : byte;
var D,M,Y,C : integer;
begin
  D:=Date mod 100;
  M:=(Date div 100) mod 100;
  Y:=Date div 10000;
  If M<3 then
    begin
      M:=M+10;
      Y:=Y-1
    end
   else  M:=M-2;
  C:=Y div 100;
  Y:=Y mod 100;
  D:=abs((26*M-2) div 10 + D + (Y div 4) + Y + (C div 4) - 2*C) mod 7;
  If D=0 then  DayOfWeek:=7  else  DayOfWeek:=D
end;

Function DaysInMonth ( Year : word; Month : byte ) : byte;
begin
  Case Month of
     1 : DaysInMonth:=31;
     2 : If Year mod 4 = 0 then  DaysInMonth:=29  else  DaysInMonth:=28;
     3 : DaysInMonth:=31;
     4 : DaysInMonth:=30;
     5 : DaysInMonth:=31;
     6 : DaysInMonth:=30;
     7 : DaysInMonth:=31;
     8 : DaysInMonth:=31;
     9 : DaysInMonth:=30;
    10 : DaysInMonth:=31;
    11 : DaysInMonth:=30;
    12 : DaysInMonth:=31
  end
end;

Function MakeDate ( Year : word; Month : word; Day : word ) : longint;
var D : longint;
begin
  D:=Year;
  MakeDate:=D*10000+Month*100+Day
end;


Constructor Calendar.Init  ( X0,Y0       : byte;
                             NormAttr    : byte;
                             WorkDayAttr : byte;
                             WeekEndAttr : byte;
                             HighAttr    : byte;
                             TheDate     : DateType;
                             Shadow      : boolean );
begin
  X1:=X0;
  Y1:=Y0;
  SaveBoxContents ( Scr,X0,Y0,X0+23,Y0+11 );
  NAttr:=NormAttr;
  WDAttr:=WorkDayAttr;
  WEAttr:=WeekEndAttr;
  HAttr:=HighAttr;
  Year:=TheDate div 10000;
  Month:=(TheDate div 100) mod 100;
  Day:=TheDate mod 100;
  MkShadow:=Shadow
end;

Destructor Calendar.Done;
begin
  RestoreBoxContents ( Scr )
end;

Procedure Calendar.Show;
const ColCount = 6;
var i        : byte;
    X,Y      : byte;
    OldDay   : byte;
    D        : longint;
begin
  D:=Year;
  D:=D*10000+Month*100+1;
  FirstDay:=DayOfWeek(D);
  LastDay:=DaysInMonth(Year,Month);
  X:=X1+1+3+1+ColCount*3-1;
  Y:=Y1+3+7;
  FillBoxWith ( X1,Y1,X,Y,$20,NAttr );
  DrawBox ( X1,Y1,X,Y,NAttr,NormBoxString,MkShadow );
  WriteString ( '���',Y1+3,X1+1,WDAttr );
  WriteString ( '��',Y1+3+1,X1+1,WDAttr );
  WriteString ( '��',Y1+3+2,X1+1,WDAttr );
  WriteString ( '��',Y1+3+3,X1+1,WDAttr );
  WriteString ( '��',Y1+3+4,X1+1,WDAttr );
  WriteString ( '��',Y1+3+5,X1+1,WEAttr );
  WriteString ( '��',Y1+3+6,X1+1,WEAttr );
  WriteString ( '�����',Y1+2,X1,NAttr );
  For i:=1 to ColCount*3-1 do  WriteString ( '�',Y1+2,X1+4+i,NAttr );
  WriteString ( '�',Y1+2,X1+4+ColCount*3,NAttr );
  For i:=1 to 7 do  WriteString ( '�',Y1+3+i-1,X1+4,NAttr );
  WriteString ( '�',Y1+3+7,X1+4,NAttr );
  WriteString ( CenterString(LintToStr(Year)+' '+MonthName[Month],ColCount*3+3),Y1+1,X1+1,NAttr );
  OldDay:=Day;
  Day:=1;
  For i:=1 to LastDay do
    begin
      ShowDay;
      Inc ( Day )
    end;
  Day:=OldDay
end;

Procedure Calendar.HighlightDay;
var X,Y : byte;
    S   : string;
begin
  Y:=Y1+2+DayOfWeek(MakeDate(Year,Month,Day));
  X:=X1+1+3+1+((Day+FirstDay-2) div 7)*3;
  S:=ByteToStr(Day);
  If length(S)=1 then  S:=' '+S;
  WriteString ( S,Y,X,HAttr )
end;

Procedure Calendar.ShowDay;
var X,Y  : byte;
    S    : string;
    DoW  : byte;
    Attr : byte;
begin
  DoW:=DayOfWeek(MakeDate(Year,Month,Day));
  Y:=Y1+2+DoW;
  X:=X1+1+3+1+((Day+FirstDay-2) div 7)*3;
  S:=ByteToStr(Day);
  If length(S)=1 then  S:=' '+S;
  If DoW<6 then  Attr:=WDAttr  else  Attr:=WEAttr;
  WriteString ( S,Y,X,Attr )
end;

Procedure Calendar.GetDay;
begin
  Show;
  Repeat
    HighlightDay;
    WaitEvent;
    ShowDay;
    Case KeyEvent of
       Key_Down : begin
                    If (DayOfWeek(MakeDate(Year,Month,Day))<7) and (Day<LastDay) then  Inc ( Day );
                    ClearEvent
                  end;
         Key_Up : begin
                    If (DayOfWeek(MakeDate(Year,Month,Day))>1) and (Day>1) then  Dec ( Day );
                    ClearEvent
                  end;
      Key_Right : begin
                    If Day+7<=LastDay then  Day:=Day+7;
                    ClearEvent
                  end;
       Key_Left : begin
                    If Day>7 then  Day:=Day-7;
                    ClearEvent
                  end;
       Key_Home : begin
                    Day:=1;
                    ClearEvent
                  end;
        Key_End : begin
                    Day:=LastDay;
                    ClearEvent
                  end;
    end
  until AnyEvent
end;

Procedure Calendar.GetDayAndMonth;
begin
  Repeat
    GetDay;
    Case KeyEvent of
      Key_PgDn : begin
                   If Month<12 then
                     Inc ( Month )
                    else
                     begin
                       Month:=1;
                       Inc ( Year )
                     end;
                   ClearEvent
                 end;
      Key_PgUp : begin
                   If Month>1 then
                     Dec ( Month )
                    else
                     begin
                       Month:=12;
                       Dec ( Year )
                     end;
                   ClearEvent
                 end
    end
  until AnyEvent;
end;

{$IFNDEF WithoutDatabase}
Constructor DayDiaryElement.Init;
begin
  Time:=round(NumField('Time'))*100;
  Rec:=RecNumber;
  Changed:=false;
  TextStr:=CharField('Text')
end;

Destructor DayDiaryElement.Done;
var T : float;
begin
  If Changed then
    begin
      GoToRec ( Rec );
      T:=Time;
      PutNumField ( T/100,'Time' );
      PutCharField ( TextStr,'Text' );
      Replace
    end
end;

Type DayDiaryForm = object(OneLineForm)
                      Constructor Init ( X0,Y0,Xl,
                                         FieldAttr,
                                         HighAttr  : byte;
                                         P         : pointer );
                    end;

Constructor DayDiaryForm.Init ( X0,Y0,Xl,
                                FieldAttr,
                                HighAttr : byte;
                                P        : pointer );
var Element : ^DayDiaryElement absolute P;
begin
  Inherited Init ( X0,Y0,FieldAttr,FieldAttr,FieldAttr,HighAttr );
  AddTimeField ( Addr(Element^.Time),1,1 );
  AddRussianScrollStringField ( Addr(Element^.TextStr),7,1,Xl,DiaryStringLength )
end;

Constructor DayDiaryList.Init ( X0,Y0,Xl,Yl : byte;
                                NormAttr    : byte;
                                FieldAttr   : byte;
                                HighAttr    : byte;
                                TheDate     : longint );
var Element : ^DayDiaryElement;
begin
  BrowseCol:=1;
  Inherited Init ( X0,Y0,Xl,Yl,NormAttr,FieldAttr,HighAttr );
  NAttr:=NormAttr;
  Date:=TheDate;
  Find ( LintToStr(TheDate) );
  Element:=nil;
  While (not EoFile) and (DateField('Date')=TheDate) do
    begin
      If not RecordDeleted then
        begin
          If MaxAvail<SizeOf(Element^) then
            begin
              Done;
              Fail
            end;
          New ( Element,Init );
          AddElement ( Element )
        end;
      Skip
    end;
  Sort;
  GoToElement ( 1 );
  If Date=SystemDate then
    begin
      Element:=Addr(CurrentElement^);
      If Element<>nil then
        begin
          While (CurrentElement^.Next<>nil) and (Element^.Time<SystemTime) do
            begin
              CurrentElement:=CurrentElement^.Next;
              Element:=Addr(CurrentElement^)
            end
        end
    end
end;

Procedure DayDiaryList.ShowOneElement ( N : word );
var S1,S2   : string;
    Element : ^DayDiaryElement;
begin
  Element:=NextElementPointer(N-1);
  WriteString ( TimeToStr(Element^.Time,1),Y1+N-1,X1,FAttr );
  WriteString ( Copy(Element^.TextStr,1,X2-X1+1-6),Y1+N-1,X1+6,FAttr )
end;

Procedure DayDiaryList.HighlightOneElement ( N : word );
var S1,S2   : string;
    Element : ^DayDiaryElement;
    Form    : DayDiaryForm;
    Clear   : boolean;
begin
  Element:=NextElementPointer(N-1);
{  Clear:=ClearOnFirstInput;
  ClearOnFirstInput:=false;}
  Form.Init ( X1,Y1+N-1,X2-X1+1-6,FAttr,HAttr,Element );
  Form.GoToElement ( BrowseCol );
  Form.Edit;
  If Form.Changed then  Element^.Changed:=true;
  BrowseCol:=Form.CurrElementNumber;
  Form.Done;
{  ClearOnFirstInput:=Clear}
end;

Procedure DayDiaryList.Browse;
var Scr     : BoxContType;
    i       : byte;
    Element : ^DayDiaryElement;
begin
  SaveBoxContents ( Scr,X1-1,Y1-3,X2+2,Y2+2 );
  FillBoxWith ( X1-1,Y1-3,X2+1,Y2+1,$20,NAttr );
  DrawBox ( X1-1,Y1-3,X2+1,Y2+1,NAttr,NormBoxString,NoShadow );
  WriteString ( CenterString(ByteToStr(Day(Date))+' '+MonthName[Month(Date)]+' '+
                WordToStr(Year(Date)),X2-X1-1),Y1-2,X1,NAttr );
  WriteString ( '�'+Replicate('�',X2-X1+1)+'�',Y1-1,X1-1,NAttr );
  WriteString ( '�',Y1-1,X1+5,NAttr );
  For i:=Y1 to Y2 do  WriteString ( '�',i,X1+5,NAttr );
  WriteString ( '�',Y2+1,X1+5,NAttr );
  Repeat
    Inherited Browse;
    Case KeyEvent of
      Key_Insert : begin
                     If MaxAvail>SizeOf(Element^) then
                       begin
                         ClearRecBuffer;
                         PutDateField ( Date,'Date' );
                         AppendRecord;
                         New ( Element,Init );
                         AddElement ( Element );
                         GoToElement ( CountOfElements )
                       end
                      else  ShowMessage ( '�� 墠⠥� �����.',HAttr,ButtonAttr );
                     ClearEvent
                   end
    end
  until KeyEvent=Key_Esc;
  RestoreBoxContents ( Scr )
end;

Function DayDiaryList.FirstGreater ( Element1,Element2 : ListElementPtr ) : boolean;
var E1 : ^DayDiaryElement absolute Element1;
    E2 : ^DayDiaryElement absolute Element2;
begin
  If E1^.Time>E2^.Time then  FirstGreater:=true  else  FirstGreater:=false
end;

Procedure DayDiaryList.SwapElements ( Element1,Element2 : ListElementPtr );
var E1 : ^DayDiaryElement absolute Element1;
    E2 : ^DayDiaryElement absolute Element2;
    T  : TimeType;
    C  : string;
    R  : longint;
    Ch : boolean;
begin
  T:=E1^.Time;
  E1^.Time:=E2^.Time;
  E2^.Time:=T;
  C:=E1^.TextStr;
  E1^.TextStr:=E2^.TextStr;
  E2^.TextStr:=C;
  R:=E1^.Rec;
  E1^.Rec:=E2^.Rec;
  E2^.Rec:=R;
  Ch:=E1^.Changed;
  E1^.Changed:=E2^.Changed;
  E2^.Changed:=Ch
end;


Function DiaryIndex : string;
begin
  DiaryIndex:=CharField('Date')
end;

Constructor DiaryBook.Open ( DataName     : string;
                             IndexName    : string;
                             X0,Y0        : byte;
                             X1,Y1,X2,Y2  : byte;
                             NormAttr     : byte;
                             FieldAttr    : byte;
                             SundayAttr   : byte;
                             HighAttr     : byte );
begin
  Area:=FirstFreeArea;
  Select ( Area );
  Use ( DataName );
  If not FileExists(IndexName) then  MakeIndex ( IndexName );
  OpenIndex ( DiaryIndex,IndexName );
  Calend_X0:=X0;
  Calend_Y0:=Y0;
  Edit_X1:=X1;
  Edit_Y1:=Y1;
  Edit_X2:=X2;
  Edit_Y2:=Y2;
  NAttr:=NormAttr;
  FAttr:=FieldAttr;
  SAttr:=SundayAttr;
  HAttr:=HighAttr
end;

Destructor DiaryBook.Close;
begin
  CloseDB
end;

Procedure DiaryBook.MakeIndex ( IndexName : string );
begin
  CreateIndex ( DiaryIndex,IndexName )
end;

Procedure CreateDiaryBook ( FileName : string );
begin
  NewStructure;
   AddNewField ( 'Date','D',8,0 );
   AddNewField ( 'Time','N',4,0 );
   AddNewField ( 'Text','C',DiaryStringLength,0 );
  CreateStructure ( FileName )
end;

Procedure DiaryBook.Edit;
var CalendarWindow : Calendar;
    TextWindow     : DayDiaryList;
    TheDate        : longint;
begin
  CalendarWindow.Init ( Calend_X0,Calend_Y0,
                        NAttr,FAttr,SAttr,HAttr,SystemDate,true );
  Repeat
    ClearStatus;
    AddStatusKey ( Key_Esc,'Esc','��室' );
    AddStatusKey ( Key_Enter,'Enter','�ᯮ�冷� ���' );
    ShowStatusLine;
    CalendarWindow.GetDayAndMonth;
    Case KeyEvent of
      Key_Enter : begin
                    ClearStatus;
                    AddStatusKey ( Key_Esc,'Esc','��室' );
                    AddStatusKey ( Key_Insert,'Insert','��������' );
                    ShowStatusLine;
                    TheDate:=CalendarWindow.Year;
                    TheDate:=TheDate*10000+CalendarWindow.Month*100+CalendarWindow.Day;
                    TextWindow.Init ( Edit_X1+1,Edit_Y1+3,
                                      Edit_X2-1,Edit_Y2-1,
                                      NAttr,FAttr,HAttr,
                                      TheDate );
                    TextWindow.Browse;
                    TextWindow.Done;
                    ClearEvent
                  end
    end
  until KeyEvent=Key_Esc;
  ClearStatus;
  ShowStatusLine;
  CalendarWindow.Done
end;
{$ENDIF}

end.
