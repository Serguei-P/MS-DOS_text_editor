{                                                                  29/07/1993
******************************************************************************
*     Библиотека низкоуровневых процедур работы с экраном и клавиатурой      *
*                           Автор  С.Поляков                                 *
*                 Предназначена для Turbo Pascal 6.0, 7.0                    *
******************************************************************************}

Unit SP_CRT;

Interface

{$I define.inc}

Const Key_NoKey      = $0000;   { Константы - значения переменной KeyEvent }
      Key_Enter      = $1C0D;   {             при нажатии соответствующих  }
      Key_EnterGr    = $E00D;   {             клавиш                       }
      Key_Esc        = $011B;
      Key_Backspace  = $0E08;
      Key_Tab        = $0F09;
      Key_Up         = $4800;
      Key_Down       = $5000;
      Key_Right      = $4D00;
      Key_Left       = $4B00;
      Key_PgDn       = $5100;
      Key_PgUp       = $4900;
      Key_Home       = $4700;
      Key_End        = $4F00;
      Key_ShiftPgDn  = $51FF;
      Key_ShiftPgUp  = $49FF;
      Key_ShiftHome  = $47FF;
      Key_ShiftEnd   = $4FFF;
      Key_ShiftUp    = $48FF;
      Key_ShiftDown  = $50FF;
      Key_ShiftRight = $4DFF;
      Key_ShiftLeft  = $4BFF;
      Key_CtrlEnter  = $1C0A;
      Key_CtrlEnterGr= $E00A;
      Key_CtrlLeft   = $7300;
      Key_CtrlRight  = $7400;
      Key_CtrlEnd    = $7500;
      Key_CtrlHome   = $7700;
      Key_CtrlPgUp   = $8400;
      Key_CtrlPgDn   = $7600;
      Key_AltEnter   = $1C00;
      Key_AltEnterGr = $A600;
      Key_AltPgUp    = $9900;
      Key_AltPgDn    = $A100;
      Key_Insert     = $5200;
      Key_ShiftIns   = $52FF;
      Key_CtrlIns    = $9200;
      Key_Delete     = $5300;
      Key_CtrlDelete = $9300;
      Key_ShiftTab   = $0F00;
      Key_F1         = $3B00;
      Key_F2         = $3C00;
      Key_F3         = $3D00;
      Key_F4         = $3E00;
      Key_F5         = $3F00;
      Key_F6         = $4000;
      Key_F7         = $4100;
      Key_F8         = $4200;
      Key_F9         = $4300;
      Key_F10        = $4400;
      Key_F11        = $8500;
      Key_F12        = $8600;
      Key_ShiftF1    = $5400;
      Key_ShiftF2    = $5500;
      Key_ShiftF3    = $5600;
      Key_ShiftF4    = $5700;
      Key_ShiftF5    = $5800;
      Key_ShiftF6    = $5900;
      Key_ShiftF7    = $5A00;
      Key_ShiftF8    = $5B00;
      Key_ShiftF9    = $5C00;
      Key_ShiftF10   = $5D00;
      Key_ShiftF11   = $8800;
      Key_ShiftF12   = $8900;
      Key_AltF1      = $6800;
      Key_AltF2      = $6900;
      Key_AltF3      = $6A00;
      Key_AltF4      = $6B00;
      Key_AltF5      = $6C00;
      Key_AltF6      = $6D00;
      Key_AltF7      = $6E00;
      Key_AltF8      = $6F00;
      Key_AltF9      = $7000;
      Key_AltF10     = $7100;
      Key_AltF11     = $8B00;
      Key_AltF12     = $8C00;
      Key_CtrlF1     = $5E00;
      Key_CtrlF2     = $5F00;
      Key_CtrlF3     = $6000;
      Key_CtrlF4     = $6100;
      Key_CtrlF5     = $6200;
      Key_CtrlF6     = $6300;
      Key_CtrlF7     = $6400;
      Key_CtrlF8     = $6500;
      Key_CtrlF9     = $6600;
      Key_CtrlF10    = $6700;
      Key_CtrlF11    = $8900;
      Key_CtrlF12    = $8A00;
      Key_CtrlA      = $1E01;
      Key_CtrlB      = $3002;
      Key_CtrlC      = $2E03;
      Key_CtrlD      = $2004;
      Key_CtrlE      = $1205;
      Key_CtrlF      = $2106;
      Key_CtrlG      = $2207;
      Key_CtrlH      = $2308;
      Key_CtrlI      = $1709;
      Key_CtrlJ      = $240A;
      Key_CtrlK      = $250B;
      Key_CtrlL      = $260C;
      Key_CtrlM      = $320D;
      Key_CtrlN      = $310E;
      Key_CtrlO      = $180F;
      Key_CtrlP      = $1910;
      Key_CtrlQ      = $1011;
      Key_CtrlR      = $1312;
      Key_CtrlS      = $1F13;
      Key_CtrlT      = $1414;
      Key_CtrlU      = $1615;
      Key_CtrlV      = $2F16;
      Key_CtrlW      = $1117;
      Key_CtrlX      = $2D18;
      Key_CtrlY      = $1519;
      Key_CtrlZ      = $2C1A;
      Key_AltA       = $1E00;
      Key_AltB       = $3000;
      Key_AltC       = $2E00;
      Key_AltD       = $2000;
      Key_AltE       = $1200;
      Key_AltF       = $2100;
      Key_AltG       = $2200;
      Key_AltH       = $2300;
      Key_AltI       = $1700;
      Key_AltJ       = $2400;
      Key_AltK       = $2500;
      Key_AltL       = $2600;
      Key_AltM       = $3200;
      Key_AltN       = $3100;
      Key_AltO       = $1800;
      Key_AltP       = $1900;
      Key_AltQ       = $1000;
      Key_AltR       = $1300;
      Key_AltS       = $1F00;
      Key_AltT       = $1400;
      Key_AltU       = $1600;
      Key_AltV       = $2F00;
      Key_AltW       = $1100;
      Key_AltX       = $2D00;
      Key_AltY       = $1500;
      Key_AltZ       = $2C00;
      Key_Alt0       = $8100;
      Key_Alt1       = $7800;
      Key_Alt2       = $7900;
      Key_Alt3       = $7A00;
      Key_Alt4       = $7B00;
      Key_Alt5       = $7C00;
      Key_Alt6       = $7D00;
      Key_Alt7       = $7E00;
      Key_Alt8       = $7F00;
      Key_Alt9       = $8000;
      Key_AltMin     = $8200;
      Key_AltEq      = $8300;
      Key_Plus       = $002B;
      Key_Minus      = $002D;
      Key_Space      = $0020;

{ Значения, которые принимает переменная MouseButton }
Const LeftMouseButton  = 1;    { Левая кнопка мыши  }
      RightMouseButton = 2;    { Правая кнопка мыши }

Var MDAinstalled  : boolean;   { true если установлен MDA-адаптер }
    ColorMonitor  : boolean;
    FDDcount      : byte;      { Количество Floppy-дисководов }
    PrintersCount : byte;      { Количество принтеров }
    VRAMbase      : word;      { Сегментный адрес начала видеопамяти }

Var KeyEvent      : word;      { Код нажатой клавиши (уст. процедурой WaitEvent) }
    MouseX,MouseY : word;      { Положение мыши в момент нажатия кнопки мыши }
    MouseButton   : word;      { Нажатая кнопка мыши }

Var MouseInstalled   : boolean;  { инсталлирована ли мышь процедурой InitializeMouse }
    MouseButtonCount : byte;     { количество кнопок мыши }

Var EventWaitTime : word;        { Время ожидания при последнем вызове процедуры WaitEvent }

Var MaxTextY : byte;      { Количетво строк экрана }
    MaxTextX : byte;      { Количество столбцов экрана }

Type BoxStringType = string[6]; { Тип переменной, передаваемой в DrawBox и
                           содержащей символы для рисования рамки }

Const NormBoxString   : BoxStringType = '╒═╕│╛╘';  { Константы для использования }
      AltBoxString    : BoxStringType = '╓─╖║╜╙';  { в процедуре DrawBox         }
      SingleBoxString : BoxStringType = '┌─┐│┘└';
      DoubleBoxString : BoxStringType = '╔═╗║╝╚';

Const Shadow   = true;
      NoShadow = false;

Const AuthorName : string[14] = 'Cергей Поляков';

 { Тип, используемый процедурами  SaveBoxContents и RestoreBoxContents 
   для хранения содержимого области экрана }
Type BoxContType = record            
                     Ptr   : pointer;
                     X1,Y1 : byte;
                     X2,Y2 : byte
                   end;

{ Процедура ожидания события связанного с клавиатурой,
  после нажатия клавиши устанавливаются переменные KeyEvent (всегда),
  MouseX,MouseY,MouseBotton (если инициализирована мышь)  }
Procedure WaitEvent;

{ То же самое, но без очистки буфера клавиатуры }
Procedure OnlyWaitEvent;

{ Проверка наличия символа в буфере клавиатуры }
Function AnyKeyInBuffer : boolean;

{ Добавить символ в буфер клавиатуры }
Procedure InsertInKeyBuffer ( ASCII : byte; Scan : byte );

{ Очистка переменных KeyEvent,MouseButton }
Procedure ClearEvent;

{ Очистка переменной KeyEvent }
Procedure ClearKeyEvent;

{ Проверка установлено ли значение какой-нибудь из переменных:
  KeyEvent,MouseX,MouseY,MouseButton }
Function AnyEvent : boolean;

{ Очистка буфера клавиатуры }
Procedure ClearKeyBuffer;

{ Вывод строки S в позиции X0,Y0 и аттрибутом Attr }
Procedure WriteString ( S : string; Y0,X0,Attr : byte );

{ Функция возвращает символ, находящийся в позиции X,Y экрана }
Function ScreenChar ( X,Y : byte ) : char;

{ Функция возвращает аттрибут символа, находящегося в позиции X,Y экрана }
Function ScreenCharAttr ( X,Y : byte ) : byte;

{ Выводить показание часов во время ожидания ввода процедурой WaitEvent в
  позици X0,Y0 с аттрибутом Attr }
Procedure ShowClock ( X0,Y0,Attr : byte );

{ Задание области экрана, в которой не выводятся показания часов }
Procedure SetNoClockZone ( X1,Y1,X2,Y2 : byte );

{ Отменить вывод времени, установленный процедурой ShowClock }
Procedure HideClock;

{ Функция возвращает номер текущего видеорежима }
Function VideoMode : byte;

{ Установка видеорежима }
Procedure SetVideoMode ( Mode : byte );

{ Функция возвращфет номер текущей видеостраницы }
Function VideoPage : byte;

{ Установить номер текущей видеостраницы }
Procedure SetVideoPage ( Page : byte );

{ Установить курсор в позицию X,Y }
Procedure GoToXY ( X,Y : byte );

{ Спрятать курсор }
Procedure HideCursor;

{ Инициализировать мышь }
Procedure InitMouse;

{ Показать мышь }
Procedure ShowMouse;

{ Спрятать мышь }
Procedure HideMouse;

{ Коодината X курсора }
Function WhereX : byte;

{ Координата Y курсора }
Function WhereY : byte;

{ Проверка нажата ли кнопка мыши с номером Button }
Function MouseButtonPressed ( Button : word ) : boolean;

{ Коодината X положения мыши }
Function WhereMouseX : byte;

{ Коодината Y положения мыши }
Function WhereMouseY : byte;

{ Установить указатель мыши в координаты X,Y }
Procedure SetMouseXY ( X,Y : byte );

{ Сохранить содержимое области экрана с координатами X1,Y1,X2,Y2 в
  переменную P (только текстовые режимы) }
Procedure SaveBoxContents ( var P : BoxContType; X1,Y1,X2,Y2 : byte );

{ Восстановление содержимого области экрана, сохраненной процедурой
  SaveBoxContents }
Procedure RestoreBoxContents ( var P : BoxContType );

{ Заполнить область экрана с координатами X1,Y1,X2,Y2 символами
  с кодом Chr и аттрибутом Attr }
Procedure FillBoxWith ( X1,Y1,X2,Y2,Chr,Attr : byte );

{ Нарисовать прямоугольник с координатами X1,Y1,X2,Y2, аттрибутом Attr;
  BoxChar - строка, содержащая символы для рисования прямоугольника -
            см. для примера константу NormBoxString;
  Shadow - рисовать ли тень }
Procedure DrawBox ( X1,Y1,X2,Y2,Attr : byte;
                    BoxChar : BoxStringType;
                    Shadow : boolean );

{ Звук с частотой Freq и длительностью Time (0.01c) }
Procedure Sound ( Freq : word; Time : word );

Procedure ConstSound ( Freq : word );

{ Пауза в работе компьютера }
Procedure Pause ( T : word );

{ Установка времени бездействия клавиатуры до сохранения экрана }
Procedure SetScreenBlankDelay ( Minutes : word );

{ Установить очистку буфера клавиатуры перед выполнением процедуры WaitEvent }
Procedure SetClearKeyBuffer ( Clear : boolean );

{ Установить адрес процедуры пользователя, выполняющеейся после ввода
  клавиши процедурой WaitEvent }
Procedure SetOnKeyProcedure ( P : pointer );

Var LeftHandMouse : boolean;

Const ShadowChar = ' ';
      ShadowAttr = $00;

{****************************************************************************}

Var ScreenWasBlanked : boolean;

Var CurrentVideoMode : byte;
    CurrentVideoPage : byte;

{ Указатель, устанавливаемый процедурой SetOnKeyProcedure }
Var OnKeyProcedure : pointer;

Implementation

Const EmptyTime = '        ';

Var TimeOfDay   : record
                    Hour    : byte;
                    Minutes : byte;
                    Seconds : byte
                  end;

Var TimeStrX    : word;
    TimeStrY    : word;
    NoTimeX1    : word;
    NoTimeY1    : word;
    NoTimeX2    : word;
    NoTimeY2    : word;
    TimeStrAttr : byte;

Var ClearKeys    : boolean;
    ClearKeysTmp : boolean;

Var OldExitProc       : pointer;
    OldMouseHandler   : pointer;
    OldMouseEventMask : word;
    MouseEvent        : boolean;

Var SavedTime : longint;

Var SaveDisplayDelay : longint;

Procedure StarSky;
const StarCount = 20;
var StarsX : array[0..StarCount] of word;
    StarsY : array[0..StarCount] of word;
    OK     : boolean;
    i      : word;
    Mode   : byte;
begin
  OK:=false;
  For i:=0 to StarCount do
    begin
      StarsX[i]:=0;
      StarsY[i]:=0
    end;
  i:=0;
  While not OK do
    begin
      Asm
        lea   di,StarsX
        add   di,i
        add   di,i
        mov   cx,ss:[di]
        lea   di,StarsY
        add   di,i
        add   di,i
        mov   dx,ss:[di]
        mov   bh,0
        mov   al,0
        mov   ah,0Ch
        int   10h
      end;
      StarsX[i]:=Random(319);
      StarsY[i]:=Random(199);
      Asm
        lea   di,StarsX
        add   di,i
        add   di,i
        mov   cx,ss:[di]
        lea   di,StarsY
        add   di,i
        add   di,i
        mov   dx,ss:[di]
        mov   bh,0
        mov   al,1
        mov   ah,0Ch
        int   10h
        mov   ah,1
        mov   ah,0
        int   1Ah
        mov   bx,dx
        mov   di,0
       @Rep:
        mov   ah,1
        int   16h
        jnz   @OK
        mov   ah,0
        int   1Ah
        cmp   dx,bx
        je    @Rep
        mov   bx,dx
        inc   di
        cmp   di,5
        jb    @Rep
        jmp   @Cont
       @OK:
        mov   OK,1
       @Cont:
      end;
      If i<StarCount then  Inc ( i )  else  i:=0
    end
end;

Procedure TextSky;
const StarCount = 25;
var StarsX  : array[0..StarCount] of word;
    StarsY  : array[0..StarCount] of word;
    i,j     : word;
    OK      : boolean;
    M_x,M_y : byte;
begin
  MouseEvent:=false;
  For i:=0 to StarCount do
    begin
      StarsX[i]:=0;
      StarsY[i]:=0
    end;
  i:=0;
  j:=0;
  OK:=false;
  M_x:=WhereMouseX; M_y:=WhereMouseY;
  While (not OK) and (not MouseEvent) and (M_x=WhereMouseX) and (M_y=WhereMouseY) do
    begin
      If StarsX[i]<>0 then
        begin
          WriteString ( #7,StarsY[i],StarsX[i],$07 );
          Asm
            mov   ah,0
            int   1Ah
            mov   bx,dx
            mov   di,0
           @Rep:
            mov   ah,1
            int   16h
            jnz   @OK
            mov   ah,0
            int   1Ah
            cmp   dx,bx
            je    @Rep
            inc   di
            mov   bx,dx
            cmp   di,2
            jb    @Rep
           @OK:
          end;
          WriteString ( #15,StarsY[i],StarsX[i],$07 );
          If not MouseEvent then
            Asm
              mov   ah,0
              int   1Ah
              mov   bx,dx
              mov   di,0
             @Rep:
              mov   ah,1
              int   16h
              jnz   @OK
              mov   ah,0
              int   1Ah
              cmp   dx,bx
              je    @Rep
              inc   di
              mov   bx,dx
              cmp   di,4
              jb    @Rep
             @OK:
            end;
          WriteString ( ' ',StarsY[i],StarsX[i],$07 )
        end;
      StarsX[i]:=Random(79)+1;
      StarsY[i]:=Random(24)+1;
      WriteString ( '.',StarsY[i],StarsX[i],$07 );
      If i<StarCount then  Inc ( i )  else  i:=0;
      If not MouseEvent then
        Asm
          mov   ah,0
          int   1Ah
          mov   bx,dx
          mov   di,0
         @Rep:
          mov   ah,1
          int   16h
          jnz   @OK
          mov   ah,0
          int   1Ah
          cmp   dx,bx
          je    @Rep
          mov   bx,dx
          inc   di
          cmp   di,18
          jb    @Rep
          jmp   @Cont
         @OK:
          mov   OK,1
          mov   ah,0
          int   16h
         @Cont:
        end
    end;
end;

Procedure MoveChar;
var X,Y   : byte;
    X0,Y0 : byte;
    X1,Y1 : byte;
    OK    : boolean;
begin
  FillBoxWith ( 1,1,MaxTextX,MaxTextY,$20,$07 );
  X0:=1; Y0:=1;
  X:=2; Y:=2;
  WriteString ( #15,Y,X,$07 );
  OK:=false;
  While not OK do
    begin
      WriteString ( ' ',Y,X,$07 );
      X1:=X; Y1:=Y;
      If (X=1) or (X=MaxTextX) then
        X:=X-(X-X0)
       else
        X:=X+(X-X0);
      If (Y=1) or (Y=MaxTextY) then
        Y:=Y-(Y-Y0)
       else
        Y:=Y+(Y-Y0);
      X0:=X1;  Y0:=Y1;
      WriteString ( #15,Y,X,$07 );
      Asm
        mov   ah,0
        int   1Ah
        mov   bx,dx
        mov   di,0
       @Rep:
        mov   ah,1
        int   16h
        jnz   @OK
        mov   ah,0
        int   1Ah
        cmp   dx,bx
        je    @Rep
        mov   bx,dx
        inc   di
        cmp   di,1
        jb    @Rep
        jmp   @Cont
       @OK:
        mov   OK,1
       @Cont:
      end
    end
end;

Procedure ShowTime;
var S0   : string[8];
    S    : string[2];
    T    : longint;
    Scr  : BoxContType;
    Mode : byte;
    X,Y  : byte;
begin
  Asm
    mov    ah,0
    int    1Ah
    mov    word ptr T,dx
    mov    word ptr T+2,cx
  end;
  If (SaveDisplayDelay>0) and
     ( ( (WhereMouseX=MaxTextX) and (WhereMouseY=1) ) or
       ( (abs(T-SavedTime)>SaveDisplayDelay) and
         (WhereMouseY<>MaxTextY) and (WhereMouseX<>MaxTextX) ) ) then
    begin
      X:=WhereX; Y:=WhereY;
      HideMouse;
      SaveBoxContents ( Scr,1,1,MaxTextX,MaxTextY );
      Mode:=VideoMode;
      HideCursor;
      ScreenWasBlanked:=true;
      FillBoxWith ( 1,1,MaxTextX,MaxTextY,$20,$07 );
      TextSky;
      Asm
        mov  ah,0
        int  1Ah
        mov  word ptr SavedTime,dx
        mov  word ptr SavedTime+2,cx
      end;
      If (WhereMouseX=MaxTextX) and (WhereMouseY=1) then  SetMouseXY ( MaxTextX-1,1 );
      ClearEvent;
      RestoreBoxContents ( Scr );
      ShowMouse;
      GoToXY ( X,Y )
    end;
  If TimeStrY or TimeStrX = 0 then  Exit;
  If NoTimeX1<>NoTimeX2 then
    begin
      If ((TimeStrX<=NoTimeX2) and (TimeStrX+8>NoTimeX1)) and
         ((TimeStrY<=NoTimeY2) and (TimeStrY>=NoTimeY1)) then  Exit
    end;
  Str ( TimeOfDay.Hour:2,S0 );
  If S0[1]=' ' then  S0[1]:='0';
  Str ( TimeOfDay.Minutes:2,S );
  If S[1]=' ' then  S[1]:='0';
  S0:=S0+':'+S;
  Str ( TimeOfDay.Seconds:2,S );
  If S[1]=' ' then  S[1]:='0';
  S0:=S0+':'+S;
  WriteString ( S0,TimeStrY,TimeStrX,TimeStrAttr );
end;

Procedure HideTime;
begin
  If NoTimeX1<>NoTimeX2 then
    begin
      If ((TimeStrX<=NoTimeX2) and (TimeStrX+8>NoTimeX1)) and
         ((TimeStrY<=NoTimeY2) and (TimeStrY>=NoTimeY1)) then  Exit
    end;
  WriteString ( EmptyTime,TimeStrY,TimeStrX,TimeStrAttr )
end;

Procedure CheckTime;
begin
  Asm
    mov  ax,$2C00
    int  $21
    cmp  TimeOfDay.Seconds,dh
    jz   @AllDone
    mov  TimeOfDay.Hour,ch
    mov  TimeOfDay.Minutes,cl
    mov  TimeOfDay.Seconds,dh
    inc  EventWaitTime
    call ShowTime
   @AllDone:
  end
end;

Procedure ShowClock ( X0,Y0,Attr : byte );
begin
  TimeStrY:=Y0;
  TimeStrX:=X0;
  TimeStrAttr:=Attr
end;

Procedure SetNoClockZone ( X1,Y1,X2,Y2 : byte );
begin
  NoTimeX1:=X1;
  NoTimeY1:=Y1;
  NoTimeX2:=X2;
  NoTimeY2:=Y2
end;

Procedure HideClock;
begin
  TimeStrY:=0;
  TimeStrX:=0
end;

Var KeysInserted : byte;

Procedure OnlyWaitEvent; assembler;
Asm
    call ShowMouse
    mov  ScreenWasBlanked,0
    mov  ah,0
    int  1Ah
    mov  word ptr SavedTime,dx
    mov  word ptr SavedTime+2,cx
    cmp  ClearKeys,1
    jne  @NoClear
    cmp  KeysInserted,0
    je   @Clear
    dec  KeysInserted
    jmp  @NoClear
   @Clear:
    call ClearKeyBuffer
   @Noclear:
    mov  EventWaitTime,0
    mov  TimeOfDay.Hour,ch
    mov  TimeOfDay.Minutes,cl
    mov  TimeOfDay.Seconds,dh
    call ShowTime
    mov  KeyEvent,0
    mov  MouseButton,0
    mov  MouseX,0
    mov  MouseY,0
   @RepeatRead:
{$IFDEF ExtendedKeyboard}
    mov  ax,1100h
{$ELSE}
    mov  ax,0100h
{$ENDIF}
    int  16h
    jnz  @ReadChar
    call CheckTime
    cmp  MouseButton,0
    je   @RepeatRead
    jmp  @AllDone
   @ReadChar:
    cmp  al,20h
    jb   @L1
    cmp  al,0E0h
    jne  @L2
    cmp  ah,0
    je   @L2
    xor  al,al
    jmp  @L1
   @L2:
    xor  ah,ah
   @L1:
    cmp  ax,4800h
    je   @Errows
    cmp  ax,5000h
    je   @Errows
    cmp  ax,4D00h
    je   @Errows
    cmp  ax,4B00h
    je   @Errows
    cmp  ax,4F00h
    je   @Errows
    cmp  ax,4700h
    je   @Errows
    cmp  ax,5100h
    je   @Errows
    cmp  ax,4900h
    je   @Errows
    cmp  ax,5200h
    je   @Errows
    jmp  @NoErrows
   @Errows:
    push ax
    mov  ah,02h
    int  16h
    test al,03h
    pop  ax
    jz   @NoErrows
    or   ax,00FFh
   @NoErrows:
    mov  KeyEvent,ax
   @AllDone:
    call HideTime
    mov  ClearKeys,0
    call HideMouse
end;

Procedure WaitEvent; assembler;
Asm
    call   OnlyWaitEvent
    cmp    KeyEvent,0
    je     @NotClear
{$IFDEF ExtendedKeyboard}
    mov    ax,1000h
{$ELSE}
    mov    ax,0000h
{$ENDIF}
    int    16h
@NotClear:
    mov    al,ClearKeysTmp
    mov    ClearKeys,al
    cmp    word ptr OnKeyProcedure,0
    jne    @ProcL
    cmp    word ptr OnKeyProcedure+2,0
    je     @NoProcL
@ProcL:
    call   dword ptr OnKeyProcedure
@NoProcL:
end;

Function AnyKeyInBuffer : boolean; assembler;
Asm
{$IFDEF ExtendedKeyboard}
    mov    ax,1100h
{$ELSE}
    mov    ax,0100h
{$ENDIF}
  mov  ax,0100h
  int  16h
  jnz  @AnyKey
  mov  ax,0
  jmp  @Ex
@AnyKey:
  mov  ax,1
@Ex:
end;

Procedure ClearEvent;
begin
  KeyEvent:=0;
  MouseButton:=0
end;

Procedure ClearKeyEvent;
begin
  KeyEvent:=0
end;

Function AnyEvent;
begin
  If (KeyEvent>0) or (MouseButton>0) then  AnyEvent:=true  else  AnyEvent:=false
end;

Procedure ClearKeyBuffer; assembler;
Asm
@L1:
{$IFDEF ExtendedKeyboard}
    mov   ah,11h
{$ELSE}
    mov   ah,01h
{$ENDIF}
    mov   ah,01h
    int   16h
    jz    @L2
    mov   ah,00h
    int   16h
    jmp   @L1
@L2:
end;

Procedure MouseEventHandler; far; assembler;
Asm
  push  ds
  push  ax
  mov   ax,seg MouseEvent
  mov   ds,ax
  mov   MouseEvent,1
  pop   ax
  push  ax
  cmp   ax,0
  je    @L
  cmp   bx,0
  je    @L
  push  bx
  cmp   LeftHandMouse,1
  jne   @NoLeftHand
  cmp   bx,LeftMouseButton
  jne   @NotLeft
  mov   bx,RightMouseButton
  jmp   @NoLeftHand
@NotLeft:
  cmp   bx,RightMouseButton
  jne   @NoLeftHand
  mov   bx,LeftMouseButton
@NoLeftHand:
  mov   MouseButton,bx
  mov   bl,8
  mov   ax,dx
  div   bl
  inc   ax
  mov   MouseY,ax
  mov   ax,cx
  div   bl
  inc   ax
  mov   MouseX,ax
  pop   bx
@L:
  pop   ax
  pop   ds
  retf
end;

Procedure SetMouseHandler;
begin
  Asm
    mov   ax,0014h
    lea   dx,MouseEventHandler
    push  cs
    pop   es
    mov   cx,007Eh
    int   33h
    mov   OldMouseEventMask,cx
    mov   ax,Seg(OldExitProc)
    push  ds
    mov   ds,ax
    lea   di,OldMouseHandler
    mov   ds:[di],dx
    mov   ax,es
    mov   ds:[di+2],ax
    pop   ds

    mov   ax,000Ch
    lea   dx,MouseEventHandler
    push  cs
    pop   es
    mov   cx,007Eh
    int   33h
  end
end;

Procedure RestoreMouseHandler;
begin
  Asm
    les   dx,OldMouseHandler
    mov   cx,0
    mov   ax,0014h
    int   33h
  end
end;

Procedure MyExitProc; far;
begin
  ExitProc:=OldExitProc;
  HideMouse;
  RestoreMouseHandler
end;

Procedure SetExitProcedure;
begin
  OldExitProc:=ExitProc;
  ExitProc:=@MyExitProc
end;

Procedure InitMouse;
begin
  MouseEvent:=false;
  If MouseInstalled then  Exit;
  Asm
    mov   ax,0000h
    int   33h
    and   ax,0001h
    mov   MouseInstalled,al
    mov   MouseButtonCount,bl
  end;
  If MouseInstalled then
    begin
      SetMouseHandler;
      SetExitProcedure
    end
end;

Procedure ShowMouse;
begin
  If not MouseInstalled then  Exit;
  Asm
    mov   ax,0001h
    int   33h
  end
end;

Procedure HideMouse;
begin
  If not MouseInstalled then  Exit;
  Asm
    mov   ax,0002h
    int   33h
  end
end;

Procedure SetMouseXY ( X,Y : byte );
begin
  If not MouseInstalled then  Exit;
  Asm
    mov   bl,8
    mov   al,X
    dec   al
    mul   bl
    mov   cx,ax
    mov   al,Y
    dec   al
    mul   bl
    mov   dx,ax
    mov   ax,4
    int   33h
  end
end;

Function MouseButtonPressed ( Button : word ) : boolean;
begin
  MouseButtonPressed:=false;
  If LeftHandMouse then
    begin
      Case Button of
         LeftMouseButton : Button:=RightMouseButton;
        RightMouseButton : Button:=LeftMouseButton
      end
    end;
  If not MouseInstalled then  Exit;
  Asm
    mov    ax,0003h
    int    33h
    test   bx,Button
    jz     @L1
    mov    @Result,1
    jmp    @L2
@L1:
    mov    @Result,0
@L2:
  end
end;

Function WhereMouseX : byte;
begin
  If not MouseInstalled then
    begin
      WhereMouseX:=0;
      Exit
    end;
  Asm
    mov    ax,0003h
    int    33h
    mov    ax,cx
    mov    bl,8
    div    bl
    inc    al
    mov    @Result,al
  end
end;

Function WhereMouseY : byte;
begin
  If not MouseInstalled then
    begin
      WhereMouseY:=0;
      Exit
    end;
  Asm
    mov    ax,0003h
    int    33h
    mov    ax,dx
    mov    bl,8
    div    bl
    inc    al
    mov    @Result,al
  end
end;


Procedure TranslateColors ( var Attr : byte );
begin
  If (not ColorMonitor) or (CurrentVideoMode in [4,5,6,7,$0F]) then
    begin
      If (Attr and $70) > (Attr and $0F) then
        Attr:=(Attr and $80) or $70
       else
        Attr:=(Attr and $80) or $0F
    end
end;


Procedure WriteString ( S : string; Y0,X0,Attr : byte ); assembler;
Asm
    push  ss
    mov   ax,bp
    add   ax,6
    push  ax
    call  TranslateColors
    cmp   CurrentVideoMode,4
    jb    @L0
    cmp   CurrentVideoMode,7
    je    @L0
    xor   bx,bx           { If we are in graphic mode }
    mov   ah,03h
    int   10h
    push  dx
    mov   dl,X0
    dec   dl
    mov   dh,Y0
    dec   dh
    mov   ah,02h
    int   10h
    pop   dx
    push  ds
    lds   si,[bp+0Ch]
    cld
    lodsb
    xor   cx,cx
    mov   cl,al
    cmp   cl,0
    je    @La
    mov   bl,Attr
    and   bl,0Fh
    mov   ah,0Eh
@L:
    lodsb
    int   10h
    loop  @L
@La:
    pop   ds
    mov   ah,02h
    int   10h
    jmp   @L2
@L0:
    xor   ax,ax           { if we are in text mode }
    mov   al,X0
    cmp   al,MaxTextX
    ja    @L2
    mov   al,Y0
    cmp   al,MaxTextY
    ja    @L2
    dec   al              { Calculate offset in video RAM }
    shl   al,1
    mov   bl,MaxTextX
    mul   bl
    xor   bx,bx
    mov   bl,X0
    dec   bx
    shl   bx,1
    add   ax,bx
    mov   di,ax
    mov   ax,0
    mov   es,ax
    add   di,es:[044Eh]   { Add video page offset }
    mov   ax,VRAMbase
    mov   es,ax           { now es:di points to video RAM }
    push  ds
    mov   bl,MaxTextX
    lds   si,[bp+0Ch]     { now ds:si points to first byte of the string }
    mov   al,X0
    add   al,[si]
    cmp   al,bl           { check if string don't exceeds line }
    jna   @OK
    mov   al,bl
    sub   al,X0
    inc   al
    inc   si
    xor   ah,ah
    cld
    jmp   @OK1
@OK:
    xor   ax,ax
    cld
    lodsb
@OK1:
    cmp   al,0
    je    @L1a
    mov   cx,ax           { string length in cx }
    mov   ah,Attr
@L1:
    lodsb                 { load string char }
    stosw                 { store string char }
    loop  @L1
@L1a:
    pop   ds
@L2:
end;

Function ScreenChar ( X,Y : byte ) : char; assembler;
Asm
    mov   al,Y
    cmp   al,MaxTextY
    ja    @L2
    dec   al              { Calculate offset in video RAM }
    shl   al,1
    mov   bl,MaxTextX
    mul   bl
    xor   bx,bx
    mov   bl,X
    dec   bx
    shl   bx,1
    add   ax,bx
    mov   di,ax
    mov   ax,0
    mov   es,ax
    add   di,es:[044Eh]   { Add video page offset }
    mov   ax,VRAMbase
    mov   es,ax           { now es:di points to video RAM }
    mov   ax,es:[di]
   @L2:
end;

Function ScreenCharAttr ( X,Y : byte ) : byte; assembler;
Asm
    mov   al,Y
    cmp   al,MaxTextY
    ja    @L2
    dec   al              { Calculate offset in video RAM }
    shl   al,1
    mov   bl,MaxTextX
    mul   bl
    xor   bx,bx
    mov   bl,X
    dec   bx
    shl   bx,1
    add   ax,bx
    inc   ax
    mov   di,ax
    mov   ax,0
    mov   es,ax
    add   di,es:[044Eh]   { Add video page offset }
    mov   ax,VRAMbase
    mov   es,ax           { now es:di points to video RAM }
    mov   ax,es:[di]
   @L2:
end;


Procedure TestHardware;
begin
  Asm
    int   11h
    push  ax
    and   ax,0030h
    cmp   ax,0030h
    je    @L1
    mov   ColorMonitor,1
    mov   MDAinstalled,0
    mov   VRAMbase,0B800h
    jmp   @L2
@L1:
    mov   MDAinstalled,1
    mov   ColorMonitor,0
    mov   VRAMbase,0B000h
@L2:
    pop   ax
    push  ax
    and   ax,00C0h
    mov   bl,40h
    div   bl
    inc   al
    mov   FDDcount,al
    pop   ax
    push  ax
    mov   al,ah
    and   ax,00C0h
    mov   bl,40
    div   bl
    mov   PrintersCount,al
    pop   ax
  end
end;

Function VideoMode : byte;
begin
  Asm
    mov   ah,0Fh
    int   10h
    mov   MaxTextX,ah
    mov   CurrentVideoMode,al
    mov   CurrentVideoPage,bh
    mov   @Result,al
    cmp   al,7
    jne   @L1
    mov   ax,0B000h
    jmp   @L2
@L1:
    mov   ax,0B800h
@L2:
    mov   VRAMbase,ax
  end
end;

Procedure SetVideoMode ( Mode : byte );
begin
  Asm
    xor  ax,ax
    mov  al,Mode
    int  10h
    mov  ah,0Fh
    int  10h
    mov  MaxTextX,ah
    mov  CurrentVideoMode,al
    cmp  al,7
    jne  @L1
    mov  ax,0B000h
    jmp  @L2
@L1:
    mov  ax,0B800h
@L2:
    mov  VRAMbase,ax
  end
end;


Function VideoPage : byte;
begin
  Asm
    mov   ah,0Fh
    int   10h
    mov   MaxTextX,ah
    mov   CurrentVideoMode,al
    mov   CurrentVideoPage,bh
    mov   @Result,bh
  end
end;

Procedure SetVideoPage ( Page : byte );
begin
  Asm
    mov   ah,05h
    mov   al,Page
    int   10h
  end
end;


Procedure GoToXY ( X,Y : byte );
begin
  Asm
    mov   ah,0Fh
    int   10h
    mov   dl,X
    dec   dl
    mov   dh,Y
    dec   dh
    mov   ax,0200h
    int   10h
  end
end;

Procedure HideCursor;
begin
  Asm
    mov   dx,5050h
    mov   ax,0200h
    mov   bx,0
    int   10h
  end
end;

Function WhereX : byte;
begin
  Asm
    mov   ah,0Fh
    int   10h
    mov   ah,3
    mov   bh,0
    int   10h
    inc   dl
    mov   @Result,dl
  end
end;

Function WhereY : byte;
begin
  Asm
    mov   ah,0Fh
    int   10h
    mov   ah,3
    mov   bh,0
    int   10h
    inc   dh
    mov   @Result,dh
  end
end;

Function MemoryNeeded ( X1,Y1,X2,Y2 : byte ) : word;
begin
  Asm
    xor   ax,ax    { Memory, necessary to save screen }
    mov   al,Y2
    sub   al,Y1
    inc   al
    mov   bl,X2
    sub   bl,X1
    inc   bl
    mul   bl
    shl   ax,1
    mov   @Result,ax
  end;
end;

Procedure SaveBoxContents ( var P : BoxContType; X1,Y1,X2,Y2 : byte );
var L  : word;
    L0 : word;
begin
  If (Y2<Y1) or (X2<X1) then
    begin
      P.Ptr:=nil;
      Exit
    end;
  P.X1:=X1;
  P.Y1:=Y1;
  P.X2:=X2;
  P.Y2:=Y2;
  L:=MemoryNeeded(X1,Y1,X2+1,Y2+1);
  If MaxAvail<L then
    begin
      P.Ptr:=nil;
      Exit
    end;
  GetMem ( P.Ptr,L );
  If P.Ptr<>nil then
    Asm
      xor   ax,ax
      mov   al,MaxTextX
      shl   ax,1
      mov   L0,ax
      push  ds
      lds   bx,P
      mov   ax,ds:[bx+2]
      mov   es,ax
      mov   di,ds:[bx]      { es:di points to window copy }
      pop   ds
      xor   bx,bx
      mov   bl,Y2
      sub   bl,Y1
      inc   bx              { bx = Y2-Y1+1 }
      xor   ax,ax
      mov   al,Y1
      dec   ax
      xor   cx,cx
      mov   cl,MaxTextX
      mul   cl
      add   al,X1
      adc   ah,0
      dec   ax
      shl   ax,1
      mov   si,ax
      mov   ax,VRAMbase
      push  ds
      push  ax
      mov   ax,0
      mov   ds,ax
      add   si,ds:[044Eh]   { Add video page offset }
      pop   ax
      mov   ds,ax           { ds:si points to source VRAM }
@L1:
      mov   cl,X2
      inc   cl
      sub   cl,X1           { cx = X2-X1+1 }
      push  si
@L2:
      lodsw
      stosw
      loop  @L2
      pop   si
      add   si,L0
      dec   bx
      cmp   bl,0
      ja    @L1
      pop   ds
    end
end;

Procedure RestoreBoxContents ( var P : BoxContType );
var L0 : word;
begin
  If P.Ptr<>nil then
    begin
      Asm
        push  ds
        xor   ax,ax
        mov   al,MaxTextX
        shl   al,1
        mov   L0,ax
        les   bx,P
        mov   si,es:[bx]
        mov   ax,es:[bx+2]     { ax:si - points to source }
        push  ax
        mov   al,es:[bx+5]
        dec   al
        mov   cl,MaxTextX
        mul   cl
        add   al,es:[bx+4]
        adc   ah,0
        dec   ax
        shl   ax,1
        mov   di,ax
        xor   cx,cx
        mov   cl,es:[bx+6]
        sub   cl,es:[bx+4]
        inc   cx               { cx = X2-X1+1 }
        xor   ax,ax
        mov   al,es:[bx+7]
        sub   al,es:[bx+5]
        inc   al
        mov   bx,ax            { bx = Y2-Y1+1 }
        mov   ax,0
        mov   es,ax
        add   di,es:[044Eh]   { Add video page offset }
        mov   ax,VRAMbase
        mov   es,ax            { es:di - points to destination VRAM }
        pop   ds               { ds:si - points to source }
        cld
        push  di
@L1:
        push  cx
@L2:
        lodsw
        stosw
        loop  @L2
        pop   cx
        pop   di
        add   di,L0
        push  di
        dec   bx
        cmp   bx,0
        ja    @L1
        pop   di
        pop   ds
      end;
      With P do
        begin
          L0:=MemoryNeeded(X1,Y1,X2+1,Y2+1);
          FreeMem ( Ptr,L0 );
          Ptr:=nil
        end
  end
end;

Procedure FillBoxWith ( X1,Y1,X2,Y2,Chr,Attr : byte );
var L0 : word;
begin
  TranslateColors ( Attr );
  Asm
    xor   ax,ax
    mov   al,MaxTextX
    shl   al,1
    mov   L0,ax
    mov   al,Y1
    dec   ax
    mov   bl,MaxTextX
    mul   bl
    add   al,X1
    adc   ah,0
    dec   ax
    shl   ax,1
    mov   di,ax
    mov   ax,0
    mov   es,ax
    add   di,es:[044Eh]   { Add video page offset }
    mov   ax,VRAMbase
    mov   es,ax          { es:di - VRAM destination address }
    xor   cx,cx
    mov   cl,X2
    sub   cl,X1
    inc   cl             { cx = X2-X1+1 }
    xor   bx,bx
    mov   bl,Y2
    sub   bl,Y1
    inc   bx             { bx = Y2-Y1+1 }
    mov   al,Chr
    mov   ah,Attr
    cld
@L1:
    push  cx
    push  di
rep stosw
    pop   di
    pop   cx
    add   di,L0
    dec   bx
    cmp   bx,0
    ja    @L1
  end
end;

Procedure DrawBox ( X1,Y1,X2,Y2,Attr : byte;
                    BoxChar : BoxStringType;
                    Shadow : boolean );
var S : string[80];
    i : byte;
begin
  WriteString ( BoxChar[1],Y1,X1,Attr );
  S:='';
  For i:=X2-1 downto X1+1 do  S:=S+BoxChar[2];
  WriteString ( S,Y1,X1+1,Attr );
  WriteString ( BoxChar[3],Y1,X2,Attr );
  For i:=Y1+1 to Y2-1 do
    begin
      WriteString ( BoxChar[4],i,X1,Attr );
      WriteString ( BoxChar[4],i,X2,Attr );
      If Shadow then  WriteString ( ShadowChar,i,X2+1,ShadowAttr )
    end;
  WriteString ( BoxChar[6],Y2,X1,Attr );
  If Shadow then  WriteString ( ShadowChar,Y2,X2+1,ShadowAttr );
  WriteString ( S,Y2,X1+1,Attr );
  WriteString ( BoxChar[5],Y2,X2,Attr );
  If Shadow then
    begin
      S:='';
      For i:=X2+1 downto X1+1 do  S:=S+ShadowChar;
      WriteString ( S,Y2+1,X1+1,ShadowAttr )
    end
end;


Procedure ConstSound ( Freq : word );
begin
  Asm
   { Set frequency }
    cmp    Freq,0
    je     @NoSound
    mov    al,0B6h
    out    43h,al
    mov    dx,14h
    mov    ax,4F38h
    div    Freq
    out    42h,al
    mov    al,ah
    out    42h,al
   { Speaker on }
    or     al,3
    out    61h,al
@NoSound:
  end
end;


Procedure Sound ( Freq : word; Time : word );
var Old61port : byte;
    T1,T2     : real;
begin
  T1:=1193180;
  T1:=T1*Time;
  T1:=T1/$640000;
  Time:=round(T1);
  Asm
    in     al,61h
    mov    Old61port,al
   { Set time }
    mov    bx,Time
    mov    ah,0
    int    1Ah
    mov    di,dx
    mov    si,cx
   { Set frequency }
    cmp    Freq,0
    je     @NoSound
    mov    al,0B6h
    out    43h,al
    mov    dx,14h
    mov    ax,4F38h
    div    Freq
    out    42h,al
    mov    al,ah
    out    42h,al
   { Speaker on }
    or     al,3
    out    61h,al
@NoSound:
   { Wait }
@Next:
    mov    ah,0
    int    1Ah
    cmp    dx,di
    je     @Next
    push   di
    sub    dx,di
    cmp    dx,bx
    jnb    @Cont
    pop    di
    jmp    @Next
@Cont:
    pop    dx
   { Speaker off }
    mov    al,Old61port
    out    61h,al
  end
end;

Procedure Pause ( T : word ); assembler;
Asm
    mov    bx,[bp+6]
    mov    ah,0
    int    1Ah
    mov    di,dx
    mov    si,cx
@Next:
    mov    ah,0
    int    1Ah
    cmp    dx,di
    je     @Next
    push   di
    sub    dx,di
    cmp    dx,bx
    jnb    @Cont
    pop    di
    jmp    @Next
@Cont:
    pop    di
end;

Procedure SetClearKeyBuffer ( Clear : boolean );
begin
  KeysInserted:=0;
  ClearKeys:=Clear;
  ClearKeysTmp:=Clear
end;

Procedure SetOnKeyProcedure ( P : pointer );
begin
  OnKeyProcedure:=P
end;

Procedure InsertInKeyBuffer ( ASCII : byte; Scan : byte );
begin
  Asm
    inc    KeysInserted
    mov    cl,ASCII
    mov    ch,Scan
    mov    ah,5
    int    16h
  end
end;

Procedure SetScreenBlankDelay ( Minutes : word );
var L : longint;
begin
  L:=Minutes;
  SaveDisplayDelay:=L*1092
end;

Procedure EmptyProc; assembler;
Asm
  iret
end;

begin
  TestHardware;
  CurrentVideoMode:=VideoMode;
  MaxTextY:=25;
  HideClock;
  KeyEvent:=0;
  MouseButton:=0;
  MouseX:=0;
  MouseY:=0;
  NoTimeX1:=0;
  NoTimeY1:=0;
  NoTimeX2:=0;
  NoTimeY2:=0;
  Asm
    push    ds
    push    cs
    pop     ds
    lea     dx,EmptyProc
    mov     ax,2523h
    int     21h
    pop     ds
  end;
  If AuthorName[8]<>'П' then
    begin
      Asm
        push   cs
        pop    ds
        lea    dx,@L
        mov    ah,9
        int    21h
        mov    ax,4C01h
        int    21h
       @L:
        db     'Don''t do that any more ...',13,10,'$'
      end;
      Halt ( 1 )
    end;
  ClearKeys:=true;
  OnKeyProcedure:=nil;
  SaveDisplayDelay:=0;
  MouseInstalled:=false;
  KeysInserted:=0;
  LeftHandMouse:=false;
  ClearKeyBuffer
end.
