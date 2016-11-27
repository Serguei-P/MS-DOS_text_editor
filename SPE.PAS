{$I-}

Uses SP_Types,SP_Intrf,SP_CRT,SP_DOS,SP_Scr,SP_Edit,SP_Print,SP_Rsrc,
     SP_Font;

{$I DEFINE.INC}

Var Color        : boolean;
    LoadFont     : boolean;
    SaveDir      : char;
    PrintInt     : char;
    PrintW       : char;
    TextFile     : FileEditObject;
    ProgName     : string;
    ScreenDelay  : byte;

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
                        ScreenDelay    : byte;
                        PrintMargine   : byte;
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
  TextOptionsCopy.PrintMargine:=PrintMargine;
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
          PrintMargine:=TextOptionsCopy.PrintMargine;
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
{$IFDEF Russian}
  If LoadFont then  LoadFontTable;
{$ENDIF}
  SetScreenBlankDelay ( ScreenDelay );
  With TextFile do
    begin
      NAttr:=NormAttr;
      HAttr:=HighAttr;
      DAttr:=AltAttr;
      MAttr:=MarkAttr;
      WAttr:=WaitMessageAttr;
      ErrAttr:=ErrorAttr
    end;
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
{$IFDEF Russian}
const Yl=20;
{$ELSE}
const Yl=19;
{$ENDIF}
begin
  Inherited Init ( MaxTextX div 2 - 21,MaxTextY div 2 - 9,43,Yl,
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
  AddPrintIntervalField ( @PrintInt,30,12 );
  AddPrintWidthField ( @PrintW,30,13 );
  AddByteField ( @PrintMargine,30,14,2 );
  AddByteField ( @ScreenDelay,30,15,1 );
  AddSaveDirField ( @SaveDir,30,16 );
{$IFDEF Russian}
  AddOnOffField ( @LoadFont,30,17 );
{$ENDIF}
end;

Procedure EditOptions.RunBeforeFieldEdit;
begin
  ClearStatus;
  AddStatusKey ( Key_Esc,'Esc','конец настройки' );
  Case CurrElementNumber of
    4,5,6,7,8,14 : AddStatusKey ( Key_Space,'Пробел','вкл/выкл' );
         9,10,13 : AddStatusKey ( Key_Space,'Пробел','изменить' );
     1,2,3,11,12 : AddStatusKey ( Key_Delete,'Delete','очистить' )
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
      If RightTextPos>255 then  RightTextPos:=255;
      If PrintMargine<0 then  PrintMargine:=0;
      If PrintMargine>100 then  PrintMargine:=100
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
  ShowString ( 'Интервал печати :',12,12 );
  ShowString ( 'Ширина печати :',14,13 );
  ShowString ( 'Отступ слева при печати :',4,14 );
  ShowString ( 'Задержка очистки экрана :',4,15 );
  ShowString ( 'Каталог файла настройки :',4,16 );
{$IFDEF Russian}
  ShowString ( 'Загружать шрифт (EGA/VGA) :',2,17 );
{$ENDIF}
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
  WriteString ( 'Shift+'#24#25' - отмечать блок',Y0+3,X0+2,AltAttr );
  WriteString ( 'Ctrl+K B - отметить начало блока',Y0+4,X0+2,AltAttr );
  WriteString ( 'Ctrl+K K - отметить конец блока',Y0+5,X0+2,AltAttr );
  WriteString ( 'Ctrl+K C - скопировать блок',Y0+6,X0+2,AltAttr );
  WriteString ( 'Ctrl+K V - перенести блок',Y0+7,X0+2,AltAttr );
  WriteString ( 'Ctrl+K Y - удалить блок',Y0+8,X0+2,AltAttr );
  WriteString ( 'Ctrl+K I - сдвинуть блок вправо',Y0+9,X0+2,AltAttr );
  WriteString ( 'Ctrl+K U - сдвинуть блок влево',Y0+10,X0+2,AltAttr );
  WriteString ( 'Ctrl+K F - форматировать блок',Y0+11,X0+2,AltAttr );
  WriteString ( 'Ctrl+K M - сделать из блока один параграф',Y0+12,X0+2,AltAttr )
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
  WriteString ( 'F7 - поиск    (или Ctrl+K F) ',Y0+2,X0+8,AltAttr );
  WriteString ( 'Shift+F7 - продолжить поиск    (или Ctrl+L)',Y0+3,X0+2,AltAttr );
  WriteString ( 'Alt+O - настройка',Y0+4,X0+5,AltAttr );
  WriteString ( 'Ctrl+P - печатать текст',Y0+5,X0+4,AltAttr );
  WriteString ( 'Esc - выход',Y0+6,X0+7,AltAttr );
  {$IFDEF Russian}
  WriteString ( 'F10 - переключение алфавита РУС/ЛАТ',Y0+7,X0+7,AltAttr )
  {$ENDIF}
end;

Procedure CommandLineHelp;
const X0=10; Y0=4; Xl=62; Yl=18; Max = 5;
begin
  WriteString ( CenterString('Параметры командной строки.',Xl-2),Y0+1,X0+1,AltAttr );
  WriteString ( '/M   черно-белый экран',Y0+3,X0+2,AltAttr );
  WriteString ( '/C   цветной экран',Y0+4,X0+2,AltAttr );
  WriteString ( '/B+  создавать архивные .BAK-файлы',Y0+5,X0+2,AltAttr );
  WriteString ( '/B-  не создавать архивные .BAK-файлы',Y0+6,X0+2,AltAttr );
  {$IFDEF Russian}
  WriteString ( '/F+  загружать кириллицу (EGA/VGA)',Y0+7,X0+2,AltAttr );
  WriteString ( '/F-  не загружать кириллицу (EGA/VGA)',Y0+8,X0+2,AltAttr )
  {$ENDIF}
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

{$IFDEF Russian}
Const Title : string[80] = '      Простой редактор текстов.     Автор С.Поляков.     Версия 2.05-R.         ';
{$ELSE}
Const Title : string[80] = '      Простой редактор текстов.     Автор С.Поляков.     Версия 2.05.           ';
{$ENDIF}

Var X,Y      : byte;
    Scr      : BoxContType;
    FileName : string;

Var i       : byte;
    S       : string[120];
    Hlp     : boolean;

begin
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
  If FileExists('SPE.CFG') then
    ReadOptions ( 'SPE.CFG' )
   else
    If FileExists(PathFromFileName(ProgName)+'SPE.CFG') then
      ReadOptions (PathFromFileName(ProgName)+'SPE.CFG');
  For i:=1 to ParamCount do
    begin
      S:=UpperCase(ParamStr(i));
      If S[1]='-' then  S[1]:='/';
      If (S[1]<>'/') and (FileName='') then  FileName:=S;
      If S='/C' then  Color:=true;
      If S='/M' then  Color:=false;
{$IFDEF Russian}
      If S='/F+' then  LoadFont:=true;
      If S='/F-' then  LoadFont:=false;
{$ENDIF}
      If S='/B+' then  TextOptions.CreateBAKFiles:=true;
      If S='/B-' then  TextOptions.CreateBAKFiles:=false;
      If (S='/?') or (S='/H') then  Hlp:=true
    end;
  If Hlp then
    begin
{$IFDEF Russian}
      WriteLn ( 'Use : SPE <file name> [/M] [/C] [/F]' );
{$ELSE}
      WriteLn ( 'Use : SPE <file name> [/M] [/C]' );
{$ENDIF}
      WriteLn ( '/M   black&white'#13#10'/C   color' );
{$IFDEF Russian}
      WriteLn ( '/F+  load font table (EGA/VGA)'#13#10'/F-  don''t load font table (EGA/VGA)' );
{$ENDIF}
      WriteLn ( '/B+  create .BAK files'#13#10'/B-  don''t create .BAK files' );
      Halt ( 0 )
    end;
  If Color then  SetColorDisplay  else  SetMonoDisplay;
  If VideoMode=7 then  SetMonoDisplay;
{$IFDEF Russian}
  If LoadFont then  LoadFontTable;
{$ENDIF}
  If Title[45]<>'П' then
    Asm
      pop ds
    end;
  With TextFile do
    begin
{$IFDEF Russian}
      Init ( FileName,1,2,MaxTextX,MaxTextY-2,NormAttr,MarkAttr,AltAttr,HighAttr,WaitMessageAttr,ErrorAttr,true );
{$ELSE}
      Init ( FileName,1,2,MaxTextX,MaxTextY-2,NormAttr,MarkAttr,AltAttr,HighAttr,WaitMessageAttr,ErrorAttr,false );
{$ENDIF}
      X:=WhereX; Y:=WhereY;
      SaveBoxContents ( Scr,1,1,MaxTextX,MaxTextY );
      If FName<>'' then  ReadDiskFile;
      If Buffer<>nil then
        Repeat
          ShowClock ( 73,1,AltAttr );
          WriteString ( Title,1,1,AltAttr );
          ClearStatus;
          AddStatusKey ( Key_F1,'F1','помощь' );
          AddStatusKey ( Key_F2,'F2','сохранить' );
          AddStatusKey ( Key_F3,'F3','считать' );
          AddStatusKey ( Key_F7,'F7','искать' );
          {$IFDEF Russian}
          AddStatusKey ( Key_F10,'F10','рус/лат' );
          {$ELSE}
          AddStatusKey ( Key_AltO,'Alt+O','установки' );
          {$ENDIF}
          AddStatusKey ( Key_Esc,'Esc','выход' );
          ShowStatusLine;
          Edit;
          Case KeyEvent of
               Key_F1 : begin
                          ShowHelp;
                          ClearEvent
                        end;
             Key_AltO : begin
                          ChangeEditOptions;
                          ClearEvent
                        end;
            Key_CtrlP : begin
                          PrinterMode:=0;
                          Case PrintW of
                            'P' : PrinterMode:=PrinterMode or PrPica;
                            'C' : PrinterMode:=PrinterMode or PrCondensed
                          end;
                          Case PrintInt of
                            '6' : PrinterMode:=PrinterMode or PrLineSp_6;
                            '8' : PrinterMode:=PrinterMode or PrLineSp_8
                          end;
                          Print;
                          ClearEvent
                        end
          end
        until (KeyEvent=Key_Esc) and MakeExit;
      RestoreBoxContents ( Scr );
      GoToXY ( X,Y )
    end
end.

