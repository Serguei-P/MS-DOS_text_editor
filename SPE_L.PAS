{$I-}

Uses SP_Types,SP_CRT,SP_DOS,SP_Intrf,SP_List,SP_Scr,SP_Edit,SP_Font,
     SP_Print,SP_Calc,SP_Calnd,SP_Rsrc,SP_L_Br;

{$I DEFINE.INC}

Var Color       : boolean;
    LoadFont    : boolean;
    SaveDir     : char;
    PrintInt    : char;
    PrintW      : char;
    ProgName    : string;
    ScreenDelay : integer;

Type SaveDirObject = object(YesNoObject)
                       Constructor Init ( V : CharPtr;
                                          X,Y,
                                          NormAttr,DialogAttr,HighAttr : byte );
                       Function ValueCode ( N : byte ) : char; virtual;
                       Function ValueString ( C : char ) : string; virtual;
                       Function AlternatCount : byte; virtual;
                     end;

Type EditOptions = object(ScreenObject)
                     Constructor Init;
                     Destructor Done; virtual;
                     Procedure Show; virtual;
                     Procedure AddSaveDirField ( Vptr : CharPtr; X,Y : byte );
                     Procedure RunBeforeFieldEdit; virtual;
                   end;

Var TextOptionsCopy : record
                        LeftTextPos    : integer;
                        ParagraphPos   : integer;
                        RightTextPos   : integer;
                        DoFormat       : boolean;
                        DoJustify      : boolean;
                        DoPerenos      : boolean;
                        CreateBAKFiles : boolean;
                        Disp           : boolean;
                        LF             : boolean;
                        SD             : char;
                        PrInterval     : char;
                        PrWidth        : char;
                        ScreenDelay    : integer
                      end;

Constructor SaveDirObject.Init ( V : CharPtr;
                                 X,Y,
                                 NormAttr,DialogAttr,HighAttr : byte );
begin
  FieldObject.Init ( X,Y,9,NormAttr,HighAttr );
  DAttr:=DialogAttr;
  Value:=V
end;

Function SaveDirObject.ValueString ( C : char ) : string;
var i : byte;
begin
  Case C of
    '3' : ValueString:='Программы';
    '2' : ValueString:='Текущий  ';
    '1' : ValueString:='Нет      '
   else ValueString:='         '
  end
end;

Function SaveDirObject.ValueCode ( N : byte ) : char;
begin
  ValueCode:=char(N+$30)
end;

Function SaveDirObject.AlternatCount : byte;
begin
  AlternatCount:=3
end;


Function WriteOptions ( FName : string ) : boolean;
var F   : file;
    Res : word;
begin
  WriteOptions:=false;
  Assign ( F,FName );
  Rewrite ( F,1 );
  Move ( TextOptions,TextOptionsCopy,SizeOf(TextOptions) );
  TextOptionsCopy.Disp:=Color;
  TextOptionsCopy.LF:=LoadFont;
  TextOptionsCopy.SD:=SaveDir;
  TextOptionsCopy.PrInterval:=PrintInt;
  TextOptionsCopy.PrWidth:=PrintW;
  TextOptionsCopy.ScreenDelay:=ScreenDelay;
  If IOResult=0 then
    begin
      BlockWrite ( F,TextOptionsCopy,SizeOf(TextOptionsCopy),Res );
      If (IOResult=0) and (Res=SizeOf(TextOptionsCopy)) then  WriteOptions:=true;
      Close ( F )
    end
end;

Function ReadOptions ( FName : string ) : boolean;
var F   : file;
    Res : word;
begin
  ReadOptions:=false;
  Assign ( F,FName );
  Reset ( F,1 );
  If IOResult=0 then
    begin
      BlockRead ( F,TextOptionsCopy,SizeOf(TextOptionsCopy),Res );
      If (IOResult=0) and (Res=SizeOf(TextOptionsCopy)) then
        begin
          ReadOptions:=true;
          Move ( TextOptionsCopy,TextOptions,SizeOf(TextOptions) );
          Color:=TextOptionsCopy.Disp;
          LoadFont:=TextOptionsCopy.LF;
          SaveDir:=TextOptionsCopy.SD;
          PrintInt:=TextOptionsCopy.PrInterval;
          PrintW:=TextOptionsCopy.PrWidth;
          ScreenDelay:=TextOptionsCopy.ScreenDelay;
          SetScreenBlankDelay ( ScreenDelay )
        end;
      Close ( F )
    end
end;

Procedure ChangeEditOptions;
var TextOpt : EditOptions;
    S       : string;
begin
  TextOpt.Init;
  Repeat
    TextOpt.Edit
  until KeyEvent=Key_Esc;
  TextOpt.Done;
  If Color then  SetColorDisplay  else  SetMonoDisplay;
  If VideoMode=7 then  SetMonoDisplay;
  If LoadFont then  LoadFontTable;
  SetScreenBlankDelay ( ScreenDelay );
  If SaveDir>'1' then
    begin
      Case SaveDir of
        '2' : S:='SPE.CFG';
        '3' : S:=PathFromFileName(ProgName)+'SPE.CFG'
      end;
      If not WriteOptions(S) then  ShowMessage ( 'Ошибка при записи в файл : '+S,ErrorAttr,ButtonAttr )
    end
end;

Constructor EditOptions.Init;
begin
  Inherited Init ( MaxTextX div 2 - 21,MaxTextY div 2 - 9,43,19,
                   AltAttr,AltFieldAttr,AltAttr,ButtonAttr,HighAttr,true,true,true );
  With TextOptions do
    begin
      AddIntegerField ( @LeftTextPos,30,4,3 );
      AddIntegerField ( @RightTextPos,30,5,3 );
      AddIntegerField ( @ParagraphPos,30,6,3 );
      AddOnOffField ( @DoFormat,30,7 );
      AddOnOffField ( @DoJustify,30,8 );
      AddOnOffField ( @DoPerenos,30,9 );
      AddOnOffField ( @CreateBAKFiles,30,10 )
    end;
  AddOnOffField ( @Color,30,11 );
  AddOnOffField ( @LoadFont,30,12 );
  AddPrintIntervalField ( @PrintInt,30,13 );
  AddPrintWidthField ( @PrintW,30,14 );
  AddIntegerField ( @ScreenDelay,30,15,1 );
  AddSaveDirField ( @SaveDir,30,16 )
end;

Procedure EditOptions.RunBeforeFieldEdit;
begin
  ClearStatus;
  AddStatusKey ( Key_Esc,'Esc','конец настройки' );
  Case CurrElementNumber of
    4,5,6,7,8,9 : AddStatusKey ( Key_Space,'Пробел','вкл/выкл' );
       10,11,13 : AddStatusKey ( Key_Space,'Пробел','изменить' );
       1,2,3,12 : AddStatusKey ( Key_Delete,'Delete','очистить' )
  end;
  ShowStatusLine
end;

Procedure EditOptions.AddSaveDirField ( Vptr : CharPtr; X,Y : byte );
var P : ^SaveDirObject;
begin
  New ( P,Init(Vptr,X+X1,Y+Y1,FAttr,DAttr,HAttr) );
  AddElement ( Addr(P^) )
end;

Destructor EditOptions.Done;
begin
  Inherited Done;
  With TextOptions do
    begin
      If LeftTextPos<1 then  LeftTextPos:=1;
      If LeftTextPos>252 then  LeftTextPos:=252;
      If ParagraphPos<1 then  ParagraphPos:=1;
      If ParagraphPos>252 then  ParagraphPos:=252;
      If RightTextPos<1 then  RightTextPos:=1;
      If RightTextPos>255 then  RightTextPos:=255
    end
end;

Procedure EditOptions.Show;
begin
  Inherited Show;
  ShowString ( CenterString('Параметры редактора :',41),1,2 );
  ShowString ( 'Левая граница текста :',7,4 );
  ShowString ( 'Правая граница текста :',6,5 );
  ShowString ( 'Отступ абзаца :',14,6 );
  ShowString ( 'Автоматич. форматирование :',2,7 );
  ShowString ( 'Выравнивание правого края :',2,8 );
  ShowString ( 'Перенос слов :',15,9 );
  ShowString ( 'Создавать BAK-файлы :',8,10 );
  ShowString ( 'Цветной дисплей :',12,11 );
  ShowString ( 'Загружать шрифт (EGA/VGA) :',2,12 );
  ShowString ( 'Интервал печати :',12,13 );
  ShowString ( 'Ширина печати :',14,14 );
  ShowString ( 'Задержка очистки экрана :',4,15 );
  ShowString ( 'Каталог файла настройки :',4,16 )
end;

Procedure FileHelp;
const X0=10; Y0=4; Xl=62; Yl=18;
begin
  WriteString ( CenterString('Работа с диском.',Xl-2),Y0+1,X0+1,AltAttr );
  WriteString ( 'F2 - записать текст на диск',Y0+3,X0+6,AltAttr );
  WriteString ( 'Alt+F2 - записать текст на диск под новым именем',Y0+4,X0+2,AltAttr );
  WriteString ( 'F3 - считать текст с диска',Y0+5,X0+6,AltAttr );
end;

Procedure BlockHelp;
const X0=10; Y0=4; Xl=62; Yl=18;
begin
  WriteString ( CenterString('Работа с блоками.',Xl-2),Y0+1,X0+1,AltAttr );
  WriteString ( 'Shift+'#24#25' - отмечать блок',Y0+3,X0+3,AltAttr );
  WriteString ( 'Ctrl+K B - отметить начало блока',Y0+4,X0+3,AltAttr );
  WriteString ( 'Ctrl+K K - отметить конец блока',Y0+5,X0+3,AltAttr );
  WriteString ( 'Ctrl+K C - скопировать блок',Y0+6,X0+3,AltAttr );
  WriteString ( 'Shift+Ins - скопировать блок из другого окна',Y0+7,X0+2,AltAttr );
  WriteString ( 'Ctrl+K V - перенести блок',Y0+8,X0+3,AltAttr );
  WriteString ( 'Ctrl+K Y - удалить блок',Y0+9,X0+3,AltAttr );
  WriteString ( 'Ctrl+K I - сдвинуть блок вправо',Y0+10,X0+3,AltAttr );
  WriteString ( 'Ctrl+K U - сдвинуть блок влево',Y0+11,X0+3,AltAttr );
  WriteString ( 'Ctrl+K F - форматировать блок',Y0+12,X0+3,AltAttr );
  WriteString ( 'Ctrl+K M - сделать из блока один параграф',Y0+13,X0+3,AltAttr )
end;

Procedure FormatHelp;
const X0=10; Y0=4; Xl=62; Yl=19;
begin
  WriteString ( CenterString('Форматирование.',Xl-2),Y0+1,X0+1,AltAttr );
  WriteString ( 'Alt+R - сформатировать абзац',Y0+3,X0+5,AltAttr );
  WriteString ( 'Alt+M - центрировать строку',Y0+4,X0+5,AltAttr );
  WriteString ( 'Alt+F - форматировать от текущей строки до конца абзаца',Y0+5,X0+5,AltAttr );
  WriteString ( 'Ctrl+K F - форматировать блок',Y0+6,X0+2,AltAttr );
  WriteString ( 'Ctrl+K M - сделать из блока один параграф',Y0+7,X0+2,AltAttr );
  WriteString ( 'Для задания левой и правой границ текста и отступа  на-',Y0+9,X0+6,AltAttr );
  WriteString ( 'чала параграфа используйте настройку редактора (Alt+O).',Y0+10,X0+1,AltAttr )
end;

Procedure RestOfHelp;
const X0=10; Y0=4; Xl=62; Yl=18;
begin
  WriteString ( 'F7 - поиск    (или Ctrl+K F) ',Y0+2,X0+12,AltAttr );
  WriteString ( 'Shift+F7 - продолжить поиск    (или Ctrl+L)',Y0+3,X0+6,AltAttr );
  WriteString ( 'Alt+O - настройка',Y0+4,X0+9,AltAttr );
  WriteString ( 'Ctrl+P - печатать текст',Y0+5,X0+8,AltAttr );
  WriteString ( 'Alt+1..Alt+5 - переключение между окнами',Y0+6,X0+2,AltAttr );
  WriteString ( 'Alt+C - калькулятор',Y0+7,X0+9,AltAttr );
  WriteString ( 'Ctrl+I - вставить число из калькулятора',Y0+8,X0+8,AltAttr );
  WriteString ( 'Alt+D - календарь',Y0+9,X0+9,AltAttr );
  WriteString ( 'Esc - выход',Y0+10,X0+11,AltAttr )
end;

Procedure CommandLineHelp;
const X0=10; Y0=4; Xl=62; Yl=18; Max = 5;
begin
  WriteString ( CenterString('Параметры командной строки.',Xl-2),Y0+1,X0+1,AltAttr );
  WriteString ( '/M   черно-белый экран',Y0+3,X0+2,AltAttr );
  WriteString ( '/C   цветной экран',Y0+4,X0+2,AltAttr );
  WriteString ( '/F+  загружать кириллицу (EGA/VGA)',Y0+5,X0+2,AltAttr );
  WriteString ( '/F-  не загружать кириллицу (EGA/VGA)',Y0+6,X0+2,AltAttr );
  WriteString ( '/B+  создавать архивные .BAK-файлы',Y0+7,X0+2,AltAttr );
  WriteString ( '/B-  не создавать архивные .BAK-файлы',Y0+8,X0+2,AltAttr )
end;

Procedure ShowHelp;
const X0=10; Y0=4; Xl=62; Yl=18; Max = 5;
      Items : array[1..Max] of string[18] =
                ( ' Работа с диском  ',
                  ' Работа с блоками ',
                  ' Форматирование   ',
                  ' Другие функции   ',
                  ' Командная строка ' );
var N,i  : word;
    Attr : byte;
begin
  ClearStatus;
  AddStatusKey ( Key_Esc,'Esc','выход' );
  ShowStatusLine;
  HideCursor;
  N:=1;
  FillBoxWith ( X0,Y0,X0+Xl-1,Y0+Yl-1,$20,AltAttr );
  DrawBox ( X0,Y0,X0+Xl-1,Y0+Yl-1,AltAttr,NormBoxString,true );
  WriteString ( '[■]',Y0,X0+2,AltAttr );
  Repeat
    WriteString ( CenterString('Меню помощи.',Xl-2),Y0+2,X0+1,AltAttr );
    For i:=1 to Max do
      begin
        If i=N then
          WriteString ( Items[i],Y0+3+i,X0+2,HighAttr )
         else
          WriteString ( Items[i],Y0+3+i,X0+2,AltAttr )
      end;
    WaitEvent;
    If (MouseButton=LeftMouseButton) and
       (MouseY=Y0+3+N) and
       (MouseX>=X0+2) and (MouseX<=X0+2+length(Items[N])) then
      begin
        ClearEvent;
        KeyEvent:=Key_Enter
      end;
    If (MouseButton=LeftMouseButton) and
       (MouseY>Y0+3) and (MouseY<=Y0+3+Max) and
       (MouseX>=X0+2) and (MouseX<=X0+2+length(Items[MouseY-Y0-3])) then
      begin
        ClearEvent;
        N:=MouseY-Y0-3
      end;
    Case KeyEvent of
         Key_Up : If N>1 then  Dec ( N )  else  N:=Max;
       Key_Down : If N<Max then  Inc ( N )  else  N:=1;
       Key_Home : N:=1;
        Key_End : N:=Max;
      Key_Enter : begin
                    FillBoxWith ( X0+1,Y0+1,X0+Xl-2,Y0+Yl-2,$20,AltAttr );
                    Case N of
                      1 : FileHelp;
                      2 : BlockHelp;
                      3 : FormatHelp;
                      4 : RestOfHelp;
                      5 : CommandLineHelp
                    end;
                    WaitEvent;
                    FillBoxWith ( X0+1,Y0+1,X0+Xl-2,Y0+Yl-2,$20,AltAttr );
                    KeyEvent:=0
                  end
    end
  until (KeyEvent=Key_Esc) or
        ((MouseButton=LeftMouseButton) and (MouseY=Y0) and (MouseX=X0+3))
end;

Type TextEditWindowPtr = ^TextEditWindow;
     TextEditWindow = object(FileEditObject)
                        WinNumber : word;
                        Procedure SetParameters;
                        Function  LeftUpMessage : string; virtual;
                        Function  BlockPointer : pointer;
                        Function  BlockLength : word;
                        Procedure WinBlockToCursor ( Window : TextEditWindowPtr );
                      end;

Procedure TextEditWindow.SetParameters;
begin
  NAttr:=NormAttr;
  HAttr:=HighAttr;
  DAttr:=AltAttr;
  MAttr:=MarkAttr;
  WAttr:=WaitMessageAttr;
  ErrAttr:=ErrorAttr
end;

Function TextEditWindow.LeftUpMessage : string;
begin
  LeftUpMessage:='Окно '+WordToStr(WinNumber)+Copy(Inherited LeftUpMessage,6,80)
end;

Function TextEditWindow.BlockLength : word;
begin
  If ShowMark and (MarkEnd>MarkBegin) then
    BlockLength:=MarkEnd-MarkBegin
   else
    BlockLength:=0
end;

Function TextEditWindow.BlockPointer : pointer;
begin
  BlockPointer:=Addr(Buffer^[MarkBegin])
end;

Procedure TextEditWindow.WinBlockToCursor ( Window : TextEditWindowPtr );
var i : word;
begin
  If Window^.BlockLength>0 then
    begin
      i:=LeftX+CurrCol-X1;
      While (i>LineLength[CurrLine]) and (CharCount<BufferSize) do
        begin
          InsertChar ( $20,LinePos[CurrLine]+LineLength[CurrLine] )
        end;
      InsertBlock ( Window^.BlockPointer,Window^.BlockLength,CursorPosition )
    end
end;

Const MaxWindow = 5;

Var TextWindowList : array[1..MaxWindow] of TextEditWindowPtr;

Var CurrentWindow : word;

Type WindowDescr = object(ListElement)
                     Number   : word;
                     FileName : string[56];
                     Constructor Init ( FName : string; N : word );
                   end;
     WindowDescrPtr = ^WindowDescr;

Constructor WindowDescr.Init ( FName : string; N : word );
begin
  Inherited Init;
  FileName:=FName;
  Number:=N
end;

Type WindowList = object(BrowseList)
                    Constructor Init ( N : word );
                    Procedure ShowOneLine ( N : word; Attr : byte ); virtual;
                  end;

Constructor WindowList.Init ( N : word );
var P : WindowDescrPtr;
    i : word;
begin
  Inherited Init ( 10,5,60,MaxWindow-1,AltAttr,AltAttr,HighAttr );
  For i:=1 to MaxWindow do
    begin
      If N<>TextWindowList[i]^.WinNumber then
        begin
          P:=New(WindowDescrPtr,Init(TextWindowList[i]^.FName,TextWindowList[i]^.WinNumber));
          AddElement ( P )
        end
    end;
  GoToElement ( 1 )
end;

Procedure WindowList.ShowOneLine ( N : word; Attr : byte );
var P : WindowDescrPtr;
begin
  P:=NextElementPointer(N-1);
  WriteString ( PadR(PadL(WordToStr(P^.Number),3)+' '+P^.FileName,4+High(P^.FileName)),Y1+N-1,X1,Attr )
end;

Function GetWindow ( N : word ) : TextEditWindowPtr;
var List : WindowList;
    P    : WindowDescrPtr;
begin
  List.Init ( N );
  List.Edit;
  List.Done;
  P:=Addr(List.CurrentElement^);
  If KeyEvent=Key_Enter then  GetWindow:=TextWindowList[P^.Number]  else  GetWindow:=nil
end;

Const Title : string[80] = '  Текстовый редактор для Люды.     Автор С.Поляков.     Версия 1.2              ';

Var X,Y      : byte;
    Scr      : BoxContType;
    FileName : string;

Var i       : byte;
    S       : string[120];
    Hlp     : boolean;
    CanExit : boolean;
    P       : pointer;

Var TheCalc    : Calculator;
    CalcLoaded : boolean;

Var TheCalendar    : Calendar;
    CalendarLoaded : boolean;

Procedure CallCalendar;
var P    : BoxContType;
    delX : byte;
    Err  : boolean;
begin
  HideCursor;
  ClearStatus;
  AddStatusKey ( 0,'Shift+стрелки','двигать' );
  AddStatusKey ( Key_PgUp,'PgUp','пред.месяц' );
  AddStatusKey ( Key_PgDn,'PgDn','след.месяц' );
  ShowStatusLine;
  Repeat
    SaveBoxContents ( P,TheCalendar.X1,TheCalendar.Y1,TheCalendar.X1+23,TheCalendar.Y1+11 );
    SetNoClockZone ( TheCalendar.X1,TheCalendar.Y1,TheCalendar.X1+23,TheCalendar.Y1+11 );
    TheCalendar.GetDayAndMonth;
    SetNoClockZone ( 0,0,0,0 );
    RestoreBoxContents ( P );
    With TheCalendar do
      begin
        Case KeyEvent of
             Key_ShiftUp : If Y1>1 then  Dec ( Y1 );
           Key_ShiftLeft : If X1>1 then  Dec ( X1 );
           Key_ShiftDown : If Y1<MaxTextY-10 then  Inc ( Y1 );
          Key_ShiftRight : If X1<MaxTextX-22 then  Inc ( X1 );
        end;
        If (MouseButton=LeftMouseButton) and
           (MouseX>=X1) and (MouseX<=X1+22) and
           (MouseY=Y1) then
          begin
            delX:=MouseX-X1;
            SaveBoxContents ( P,TheCalendar.X1,TheCalendar.Y1,TheCalendar.X1+23,TheCalendar.Y1+11 );
            Show;
            While MouseButtonPressed(LeftMouseButton) do
              begin
                If (WhereMouseY<>Y1) or (WhereMouseX<>X1+delX) then
                  begin
                    Y1:=WhereMouseY;
                    X1:=WhereMouseX;
                    If X1>delX then  X1:=X1-delX  else  X1:=0;
                    Err:=false;
                    If Y1>MaxTextY-10 then
                      begin
                        Y1:=MaxTextY-10;
                        Err:=true
                      end;
                    If X1>MaxTextX-22 then
                      begin
                        X1:=MaxTextX-22;
                        Err:=true
                      end;
                    If X1<1 then
                      begin
                        X1:=1;
                        Err:=true
                      end;
                    If Err then
                      begin
                        SetMouseXY ( X1+delX,Y1 )
                      end;
                    RestoreBoxContents ( P );
                    SaveBoxContents ( P,TheCalendar.X1,TheCalendar.Y1,TheCalendar.X1+23,TheCalendar.Y1+11 );
                    Show
                  end;
              end;
            RestoreBoxContents ( P )
          end
      end;
  until KeyEvent=Key_Esc
end;

Procedure CallTools; far; assembler;
Asm
  cmp    KeyEvent,Key_AltC
  jne    @NoCalc
  cmp    CalcLoaded,0
  jne    @NoCalc
  mov    CalcLoaded,1
  lea    di,TheCalc
  push   ds
  push   di
  call   Calculator.InsertNumberFromScreen
  lea    di,TheCalc
  push   ds
  push   di
  call   Calculator.Run
  mov    CalcLoaded,0
  mov    ax,0
@NoCalc:
  cmp    KeyEvent,Key_CtrlI
  jne    @NoInsert
  lea    di,TheCalc
  push   ds
  push   di
  call   Calculator.InsertNumberToKeyBuffer
@NoInsert:
  cmp    KeyEvent,Key_AltD
  jne    @NoCalendar
  cmp    CalendarLoaded,0
  jne    @NoCalendar
  mov    CalendarLoaded,1
  call   CallCalendar
  mov    CalendarLoaded,0
  call   ClearEvent
  mov    KeyEvent,$FFFF
@NoCalendar:
end;

begin
  CurrentWindow:=0;
  ProgName:=ParamStr(0);
  AlternatFieldEnter:=false;
  TextOptions.CreateBAKFiles:=true;
  SaveDir:='1';
  Color:=true;
  PrintInt:='6';
  PrintW:='P';
  LoadFont:=false;
  FileName:='';
  Hlp:=false;
  InitMouse;
  SetMouseXY ( MaxTextX-1,MaxTextY );
  X:=WhereX; Y:=WhereY;
  SaveBoxContents ( Scr,1,1,MaxTextX,MaxTextY );
  If FileExists('SPE.CFG') then
    ReadOptions ( 'SPE.CFG' )
   else
    If FileExists(PathFromFileName(ProgName)+'SPE.CFG') then
      ReadOptions (PathFromFileName(ProgName)+'SPE.CFG');
  SetMonoDisplay;
  For i:=1 to ParamCount do
    begin
      S:=UpperCase(ParamStr(i));
      If S[1]='-' then  S[1]:='/';
      If S[1]<>'/' then
        begin
          If CurrentWindow<MaxWindow then
            begin
              If MemAvail>100000 then
                begin
                  Inc ( CurrentWindow );
                  FileName:=S;
                  TextWindowList[CurrentWindow]:=New(TextEditWindowPtr,Init(FileName,1,2,MaxTextX,MaxTextY-2,
                                                                            NormAttr,MarkAttr,AltAttr,HighAttr,
                                                                            WaitMessageAttr,ErrorAttr,false));
                  If TextWindowList[CurrentWindow]=nil then
                    Dec ( CurrentWindow )
                   else
                    TextWindowList[CurrentWindow]^.WinNumber:=CurrentWindow
                end
               else
                begin
                  ShowMessage ( 'Не хватает памяти',ErrorAttr,ButtonAttr );
                  RestoreBoxContents ( Scr );
                  GoToXY ( X,Y );
                  Halt ( 1 )
                end
            end
        end;
      If S='/C' then  Color:=true;
      If S='/M' then  Color:=false;
      If S='/F+' then  LoadFont:=true;
      If S='/F-' then  LoadFont:=false;
      If S='/B+' then  TextOptions.CreateBAKFiles:=true;
      If S='/B-' then  TextOptions.CreateBAKFiles:=false;
      If (S='/?') or (S='/H') then  Hlp:=true
    end;
  If Hlp then
    begin
      WriteLn ( 'Use : SPE <file name> [/M] [/C] [/F]' );
      WriteLn ( '/M   black&white' );
      WriteLn ( '/C   color' );
      WriteLn ( '/F+  load font table (EGA/VGA)' );
      WriteLn ( '/F-  don''t load font table (EGA/VGA)' );
      WriteLn ( '/B+  create .BAK files' );
      WriteLn ( '/B-  don''t create .BAK files' );
      Halt ( 0 )
    end;
  If Color then  SetColorDisplay  else  SetMonoDisplay;
  If VideoMode=7 then  SetMonoDisplay;
  If LoadFont then  LoadFontTable;
  If Title[44]<>'П' then
    Asm
      pop ds
    end;
  For i:=1 to CurrentWindow do
    begin
      TextWindowList[i]^.SetParameters;
      If TextWindowList[i]^.FName<>'' then  TextWindowList[i]^.ReadDiskFile
    end;
  While CurrentWindow<MaxWindow do
    begin
      If MemAvail>100000 then
        begin
          Inc ( CurrentWindow );
          FileName:='';
          TextWindowList[CurrentWindow]:=New(TextEditWindowPtr,Init(FileName,1,2,MaxTextX,MaxTextY-2,
                                             NormAttr,MarkAttr,AltAttr,HighAttr,WaitMessageAttr,ErrorAttr,false));
          TextWindowList[CurrentWindow]^.SetParameters;
          TextWindowList[CurrentWindow]^.WinNumber:=CurrentWindow
        end
       else
        begin
          ShowMessage ( 'Не хватает памяти',ErrorAttr,ButtonAttr );
          RestoreBoxContents ( Scr );
          GoToXY ( X,Y );
          Halt ( 1 )
        end
    end;
  TheCalc.Init ( 56,MaxTextY-14,10,AltAttr,AltFieldAttr,HighAttr,true );
  CalcLoaded:=false;
  TheCalendar.Init ( MaxTextX-25,MaxTextY-14,AltAttr,AltFieldAttr,AltStornoAttr,HighAttr,SystemDate,Shadow );
  CalendarLoaded:=false;
  SetOnKeyProcedure ( @CallTools );
  ShowClock ( 73,1,AltAttr );
  CurrentWindow:=1;
  Repeat
    WriteString ( Title,1,1,AltAttr );
    ClearStatus;
    AddStatusKey ( Key_F1,'F1','помощь' );
    AddStatusKey ( Key_F2,'F2','сохранить' );
    AddStatusKey ( Key_F3,'F3','считать' );
    AddStatusKey ( Key_F7,'F7','искать' );
    AddStatusKey ( Key_AltO,'Alt+O','установки' );
    AddStatusKey ( Key_Esc,'Esc','выход' );
    ShowStatusLine;
    TextWindowList[CurrentWindow]^.Edit;
    Case KeyEvent of
         Key_F1 : begin
                    ShowHelp;
                    ClearEvent
                  end;
       Key_AltO : begin
                    ChangeEditOptions;
                    For i:=1 to MaxWindow do
                      begin
                        TextWindowList[i]^.SetParameters
                      end;
                    ClearEvent
                  end;
      Key_CtrlP : begin
                    PrinterMessAttr:=AltAttr;
                    PrinterHighAttr:=HighAttr;
                    PrinterMode:=0;
                    Case PrintW of
                      'P' : PrinterMode:=PrinterMode or PrPica;
                      'C' : PrinterMode:=PrinterMode or PrCondensed
                    end;
                    Case PrintInt of
                      '6' : PrinterMode:=PrinterMode or PrLineSp_6;
                      '8' : PrinterMode:=PrinterMode or PrLineSp_8
                    end;
                    TextWindowList[CurrentWindow]^.Print;
                    ClearEvent
                  end;
       Key_Alt1 : begin
                    If 1<=MaxWindow then
                      begin
                        CurrentWindow:=1
                      end;
                    ClearEvent
                  end;
       Key_Alt2 : begin
                    If 2<=MaxWindow then
                      begin
                        CurrentWindow:=2
                      end;
                    ClearEvent
                  end;
       Key_Alt3 : begin
                    If 3<=MaxWindow then
                      begin
                        CurrentWindow:=3
                      end;
                    ClearEvent
                  end;
       Key_Alt4 : begin
                    If 4<=MaxWindow then
                      begin
                        CurrentWindow:=4
                      end;
                    ClearEvent
                  end;
       Key_Alt5 : begin
                    If 5<=MaxWindow then
                      begin
                        CurrentWindow:=5
                      end;
                    ClearEvent
                  end;
        Key_Esc : begin
                    CanExit:=true;
                    For i:=1 to MaxWindow do
                      begin
                        CanExit:=TextWindowList[i]^.MakeExit;
                        If not CanExit then  break
                      end;
                    If CanExit then  break
                  end;
   Key_ShiftIns : begin
                    P:=GetWindow(CurrentWindow);
                    If P<>nil then
                      begin
                        TextWindowList[CurrentWindow]^.WinBlockToCursor(P)
                      end;
                     ClearEvent
                   end
    end
  until false;
  RestoreBoxContents ( Scr );
  GoToXY ( X,Y )
end.

