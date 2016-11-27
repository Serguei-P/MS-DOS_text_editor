{$I defs.inc}
{$V-}
{                                                                 29/07/1993
******************************************************************************
*             Библиотека процедур ввода-вывода с клавиатуры.                 *
*                           Автор   С.Поляков                                *
*                  Предназначена для Turbo Pascal 6.0, 7.0                   *
******************************************************************************}


Unit SP_Intrf;

Interface

Uses SP_CRT,SP_Types,SP_Rsrc;

{ Байт статуса принтера ($90 если принтер готов) }
Function PrinterStatus : byte;

{ Функция для совместимости со старой версией библиотеки }
Function WasAnyEvent : boolean;

{ Редактирование строки }
Procedure InputString ( var S    : string; { строка }
                            Y,X  : byte;   { координаты поля ввода }
                            L    : byte;   { макс. длина строки }
                            Attr : byte    { аттрибут поля ввода } );

{ Редактирование строки со скроллиногом }
Procedure InputScrollString ( var S    : string; { строка }
                                  Y,X  : byte;   { координаты поля ввода }
                                  L    : byte;   { длина поля ввода }
                                  L0   : byte;   { длина строки }
                                  Attr : byte    { аттрибут поля ввода } );

{ Редактирование строки кириллицы }
Procedure InputRussianString ( var S    : string; { строка }
                                   Y,X  : byte;   { координаты поля ввода }
                                   L    : byte;   { макс. длина строки }
                                   Attr : byte    { аттрибут поля ввода } );

{ Редактирование строки кириллицы со скроллиногом }
Procedure InputRussianScrollString ( var S    : string; { строка }
                                         Y,X  : byte;   { координаты поля ввода }
                                         L    : byte;   { длина поля ввода }
                                         L0   : byte;   { длина строки }
                                         Attr : byte    { аттрибут поля ввода } );

{ Редактирование строки кириллицы верхнего регистра }
Procedure InputUpperCaseRussianString ( var S    : string; { строка }
                                            Y,X  : byte;   { координаты поля ввода }
                                            L    : byte;   { макс. длина строки }
                                            Attr : byte    { аттрибут поля ввода } );

{ Редактирование строки содержащей число }
Procedure InputNumericalString ( var S    : string; { строка }
                                     Y,X  : byte;   { координаты поля ввода }
                                     L    : byte;   { макс. длина строки }
                                     Attr : byte    { аттрибут поля ввода } );

{ Редактирование действительного числа }
Procedure InputFloat ( var Value : float; { Редактируемое число }
                           Y,X   : byte;  { координаты поля ввода }
                           L     : byte;  { длина поля ввода }
                           Attr  : byte   { аттрибут поля ввода } );

{ Редактирование денежной суммы }
Procedure InputMoneyFloat ( var Value : float; { Редактируемое число }
                                Y,X   : byte;  { координаты поля ввода }
                                L     : byte;  { длина поля ввода }
                                Attr  : byte   { аттрибут поля ввода } );

{ Редактирование действительного числа с обработкой минуса }
Procedure InputFloatSpecial ( var Value : float; { Редактируемое число }
                                  Y,X   : byte;  { координаты поля ввода }
                                  L     : byte;  { длина поля ввода }
                                  Attr  : byte   { аттрибут поля ввода } );

{ Редактирование длинного целого }
Procedure InputLongInt ( var Value : longint; { Редактируемое число }
                             Y,X   : byte;    { координаты поля ввода }
                             L     : byte;    { длина поля ввода }
                             Attr  : byte     { аттрибут поля ввода } );

{ Редактирование целого }
Procedure InputInteger ( var Value : integer; { Редактируемое число }
                             Y,X   : byte;    { координаты поля ввода }
                             L     : byte;    { длина поля ввода }
                             Attr  : byte     { аттрибут поля ввода } );

{ Редактирование даты }
Procedure InputDate ( var Value : longint; { Редактируемая дата }
                          Y,X   : byte;    { координаты поля ввода }
                          Attr  : byte     { аттрибут поля ввода } );

{ Редактирование времени }
Procedure InputTime ( var Value : longint; { Редактируемое время }
                          Y,X   : byte;    { координаты поля ввода }
                          Attr  : byte     { аттрибут поля ввода } );

{ Ввод пароля }
Procedure InputPassword ( var S    : string; { Вводимая строка }
                              L    : byte;   { Длина поля ввода }
                              NAttr: byte;   { Аттрибут окна }
                              HAttr: byte    { Аттрибут поля ввода } );

{ Ввод нового пароля }
Procedure InputNewPassword  ( var S    : string; { Вводимая строка }
                                  L    : byte;   { Длина поля ввода }
                                  NAttr: byte;   { Аттрибут окна }
                                  HAttr: byte    { Аттрибут поля ввода } );

{ Показать строку, используя несколько строк экрана}
Procedure MultiLineStringShow ( S    : string;
                                Y0   : byte;
                                X0   : byte;
                                X1   : byte;
                                Yl   : byte;
                                Xl   : byte;
                                Attr : byte );

{ Редактировать строку, используя несколько строк экрана}
Procedure MultiLineStringInput ( var S    : string;
                                     Y0   : byte;
                                     X0   : byte;
                                     X1   : byte;
                                     Yl   : byte;
                                     Xl   : byte;
                                     Attr : byte );

{ Показать сообщение }
Procedure ShowMessage ( Mess : string; { строка, содержащая сообщение }
                        Attr : byte    { аттрибут } );

{ Вывести сообщение "Подождите, пожалуйста" }
Procedure PutWaitMessage;

{ Убрать сообщение "Подождите, пожалуйста" }
Procedure RemoveWaitMessage;

{ Получить ответ Да или Нет }
Procedure GetYesNo ( Title1 : string; { первая строка сообщения }
                     Title2 : string; { вторая строка сообщения }
                     Title3 : string; { третья строка сообщения }
                     NAttr  : byte;   { нормальный аттрибут }
                     HAttr  : byte;   { аттрибут выделенного ответа }
                 var Yes : boolean    { ответ: true - да; false - нет } );

{ Вывод нижней строки экрана }
Procedure StatusLine ( S1 : string; { выделенная часть строки }
                       S2 : string  { нормальная часть строки } );

{ Кодировать содержимое буфера }
Procedure EncodeBuffer ( P : pointer; { указатель на буфер }
                         L : word     { длина буфера } );

{ Декодировать содержимое буфера }
Procedure DecodeBuffer ( P : pointer; { указатель на буфер }
                         L : word     { длина буфера } );

{ Контрольная сумма BIOS-а }
Function BiosSum : word;

{ Включение режима ввода кириллицы процедурами InputRussianString и т.п.
  (по умолчанию)  }
Procedure SetTranslationOn;

{ Выключение режима ввода кириллицы процедурами InputRussianString и т.п. }
Procedure SetTranslationOff;

{ Переключение ввода кириллица }
Procedure SwitchTranslation;

{ Установка области экрана, нажатие в которой левой кнопки мыши вызывает
событие, аналогичное вызываемому нажатием на клавишу с кодом KeyCode }
Procedure AddMouseKey ( KeyCode : word; { Код события }
                        X0,Y0   : byte; { Координаты начала области экрана }
                        L0      : byte; { Длина области экрана }
                        Code    : char  { Код для процдуры ClearMouseKeys } );

{ Очистка областей установленных процедурой AddMouseKey с кодом Code }
Procedure ClearMouseKeys ( Code : char );

{ Очистка всех областей, установленных процедурой AddMouseKey }
Procedure ClearAllMouseKeys;

{ Расширенная процедура ожидания нажатия клавиши или кнопки мыши
  (см. модуль SP_CRT). Отличается дополнительной обработкой событий от
  мыши, установленной процедурой AddMouseKey }
Procedure WaitEvent;

{ Добавление описания новой клавиши в нижнюю строку экрана }
Procedure AddStatusKey ( KeyCode     : word;   { Код клавиши }
                         KeyText     : string; { Название клавиши }
                         Description : string  { Описание действия, вызываемого} );
                                               { нажатием на клавишу KeyCode }
{ Очистка содержимого нижней строки экрана (без перерисовки изображения) }
Procedure ClearStatus;

{ Показать нижнюю строку экрана }
Procedure ShowStatusLine;

{ Установка параметров вертикальной полосы прокрутки }
Procedure SetVerticalScrollBar ( X0,Y0    : byte; { Координаты верхней точки }
                                 L        : byte; { Длина полосы прокрутки }
                                 BarAttr  : byte; { Аттрибут цвета полосы прокрутки }
                                 IconAttr : byte  { Аттрибут цвета "иконки" для мыши } );

{ Установка параметров горизонтальной полосы прокрутки }
Procedure SetHorizontalScrollBar ( X0,Y0    : byte; { Координаты левой точка }
                                   L        : byte; { Длина полосы прокрутки }
                                   BarAttr  : byte; { Аттрибут цвета полосы прокрутки }
                                   IconAttr : byte  { Аттрибут цвета "иконки" для мыши } );

{ Показать вертикальную полосу прокрутки }
Procedure ShowVerticalScrollBar ( Procent : integer { Положение указателя в процентах } );

{ Показать горизонтальную полосу прокрутки }
Procedure ShowHorizontalScrollBar ( Procent : integer { Положение указателя в процентах } );

{ Звуковой сигнал }
Procedure Bell;

Function ConvertToRussian ( Ch : char ) : char;

Function FloatMoneyString ( Value : float; L0 : byte ) : string;

Var RussianVersion  : boolean;  { Русский язык сообщений программы }

Var BellOnError : boolean; { Звуковой сигнал при ошибке }

Const TheCompany = ' г.Новокубанск '#4' тел. (86195) 3-20-55 (раб)';

Const cmMoveDown  = $FF01; { Содержимое переменной KeyEvent после нажатия мыши }
      cmMoveUp    = $FF02; { на "иконке" полосы прокрутки }
      cmMoveLeft  = $FF03;
      cmMoveRight = $FF04;

Var LastWasCommand : boolean; { Последнее событие - нажатие на "иконку" }

Var CodeString : string; { Кодовая строка, используемая процедурами
                           DecodeBuffer и EncodeBuffer }

Const LatinLetters      : string[73] = 'F<DULT:PBQRKVYJGHCNEA{WXIO}SM">Zf,dult;pbqrkvyjghcnea[wxio]sm''.z%^&)(~`*@';
      AltLatinLetters   : string[73] = 'F<DULT:PBQRKVYJGHCNEA{WXIO}SM">ZАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ:,.%?();"';

Var RussianLetters    : string[73];
    AltRussianLetters : string[73];

{ Заставка программы }
Procedure ProgInfo ( Title      : string;  { Название программы }
                     Version    : string;  { Версии программы }
                     CopyNumber : longint; { Номер копии программы }
                     Owner      : string;  { Владелец копии программы }
                     Attr       : byte;    { Цвет заставки }
                     BAttr      : byte     { Цвет кнопки OK } );

Implementation

Type SetOfByte = set of byte;

Const AnyCharacter         : SetOfByte = [$20..$FF];
      FloatNumberCharacter : SetOfByte = [ $2D,$2E,$30..$39,$45];
      IntNumberCharacter   : SetOfByte = [$2D,$30..$39];

Procedure Bell;
begin
  If BellOnError then
    Asm
      mov  ah,02h
      mov  dl,7
      int  21h
    end
end;

Procedure InputAnyString ( var S0 : string; Y0,X0,L0,Attr : byte; CS : SetOfByte; var S1,S2 : string );
var S,Ss : string;
    X    : byte;
    N    : byte;
    C    : char;
begin
  S:=S0;
  While  (S[0]>#0) and (S[ord(S[0])]=' ') do  Dec ( S[0] );
  S:=Copy(S,1,L0);
  X:=length(S);
  Repeat
    Ss:=S;
    While length(Ss)<L0 do  Ss:=Ss+' ';
    WriteString ( Ss,Y0,X0,Attr );
    GoToXY ( X0+X,Y0 );
    WaitEvent;
    Case KeyEvent of
      Key_Backspace : begin
                        If S[0]>#0 then
                          begin
                            S[0]:=chr(ord(S[0])-1);
                            Dec ( X )
                          end
                         else  Bell;
                        ClearEvent
                      end;
         Key_Delete : begin
                        S[0]:=#0;
                        ClearEvent;
                        X:=0
                      end;
     else
      begin
        If (lo(KeyEvent)>=$20) and (hi(KeyEvent)=0) then
          begin
            If length(S)<L0 then
              begin
                C:=chr(lo(KeyEvent));
                N:=pos(C,S1);
                If N>0 then C:=S2[N];
                If ord(C) in CS then
                  begin
                    S:=S+C;
                    ClearEvent;
                    Inc ( X )
                  end
                 else  Bell
              end
             else  Bell;
            ClearEvent
          end
      end
    end;
  until AnyEvent;
  S0:=S;
  HideCursor
end;

Procedure InputAnyScrollString ( var S             : string;
                                     Y,X,L,L0,Attr : byte;
                                     CS            : SetOfByte;
                                 var S1,S2         : string );
var Pos,X0,i  : byte;
    Stmp      : string;
    Character : char;
    CharPos   : byte;
    Ed        : boolean;
begin
  Pos:=1;
  X0:=1;
  S:=Copy(AllTrim(S),1,L0);
  Ed:=false;
  If L0<L then  L:=L0;
  Repeat
    Stmp:=Copy(S,Pos,L);
    While length(Stmp)<L do  Stmp:=Stmp+{#177}#32;
    WriteString ( Stmp,Y,X,Attr );
    GoToXY ( X+X0-1,Y );
    WaitEvent;
    HideCursor;
    If (hi(KeyEvent)=0) and (lo(KeyEvent) in CS) then
      begin
        {If not Ed then  S:='';}
        If length(S)<L0 then
          begin
            Stmp:=Copy(S,1,Pos+X0-2);
            While length(Stmp)<Pos+X0-2 do  Stmp:=Stmp+' ';
            Character:=char(lo(KeyEvent));
            CharPos:=system.pos(Character,S1);
            If CharPos>0 then  Character:=S2[CharPos];
            S:=Stmp+Character+Copy(S,Pos+X0-1,length(S)-Pos-X0+2);
            If (X0<L) or (L=L0) then  Inc ( X0 )  else  Inc ( Pos )
          end
         else  Bell;
        ClearEvent
      end;
    Ed:=true;
    Case KeyEvent of
           Key_Left : begin
                        If X0>1 then
                          begin
                            Dec ( X0 );
                            ClearEvent
                          end
                         else
                          If Pos>1 then
                            begin
                              Dec ( Pos );
                              ClearEvent
                            end
                         {  else
                            ClearEvent}
                      end;
          Key_Right : begin
                        If X0<=L then
                          begin
                            If (X0<L) and (X0<=length(S)) then
                              Inc ( X0 )
                             else  If Pos+L-1<=length(S) then  Inc ( Pos )
                          end;
                        ClearEvent
                      end;
           Key_Home : begin
                        Pos:=1;
                        X0:=1;
                        ClearEvent
                       end;
            Key_End : begin
                        Pos:=1;
                        X0:=length(S);
                        While (X0>0) and (S[X0]=' ') do  Dec ( X0 );
                        Inc ( X0 );
                        While X0>=L do
                          begin
                            Inc ( Pos );
                            Dec ( X0 )
                          end;
                        ClearEvent
                      end;
      Key_Backspace : begin
                        If (X0>1) or (Pos>1) then
                          begin
                            Delete ( S,Pos+X0-2,1 );
                            If X0>1 then  Dec ( X0 )  else  Dec ( Pos )
                          end
                         else  Bell;
                        ClearEvent
                      end;
         Key_Delete : begin
                        If X0+Pos-1<=length(S) then  Delete ( S,Pos+X0-1,1 );
                        ClearEvent
                      end
    end
  until  AnyEvent;
  WriteString ( PadR(Copy(S,1,L),L),Y,X,Attr )
end;

Procedure InputString ( var S : string; Y,X,L,Attr : byte );
var EmptyString : string;
begin
  EmptyString:='';
  InputAnyString ( S,Y,X,L,Attr,AnyCharacter,EmptyString,EmptyString )
end;

Procedure InputScrollString ( var S : string; Y,X,L,L0,Attr : byte );
var EmptyString : string;
begin
  EmptyString:='';
  InputAnyScrollString ( S,Y,X,L,L0,Attr,AnyCharacter,EmptyString,EmptyString )
end;

Procedure InputRussianString ( var S : string; Y,X,L,Attr : byte );
begin
  InputAnyString ( S,Y,X,L,Attr,AnyCharacter,LatinLetters,RussianLetters )
end;

Procedure InputRussianScrollString ( var S : string; Y,X,L,L0,Attr : byte );
begin
  InputAnyScrollString ( S,Y,X,L,L0,Attr,AnyCharacter,LatinLetters,RussianLetters )
end;

Procedure InputUpperCaseRussianString ( var S : string; Y,X,L,Attr : byte );
var SStr1,SStr2 : string;
begin
  SStr1:=LatinLetters+RussianLetters;
  SStr2:=AltLatinLetters+AltRussianLetters;
  InputAnyString ( S,Y,X,L,Attr,AnyCharacter,SStr1,SStr2 )
end;

Procedure InputNumericalString ( var S : string; Y,X,L,Attr : byte );
var EmptyString : string;
begin
  EmptyString:='';
  InputAnyString ( S,Y,X,L,Attr,IntNumberCharacter,EmptyString,EmptyString )
end;

Procedure InputFloat ( var Value : float; Y,X,L,Attr : byte );
var S    : string;
    Err  : integer;
    Str1 : string;
    Str2 : string;
begin
  If Value<>0 then
    S:=AllTrim(FloatToStr(Value,L))
   else
    S:=replicate(' ',L);
  Str1:='EeУу';
  Str2:='EEEE';
  InputAnyString ( S,Y,X,L,Attr,FloatNumberCharacter,Str1,Str2 );
  Val ( S,Value,Err );
  If Err<>0 then  Value:=0;
  WriteString ( FloatToStr(Value,L),Y,X,Attr )
end;

Function FloatMoneyString ( Value : float; L0 : byte ) : string;
var S    : string;
    Sign : boolean;
    P    : integer;
    L    : byte;
begin
  If Value<0 then
    begin
      Sign:=true;
      Dec ( L0 );
      Value:=abs(Value)
    end
   else
    Sign:=false;
  L:=L0;
  Repeat
    S:=AllTrim(FloatToStr(Value,L));
    P:=pos('.',S);
    If P=0 then  P:=length(S)  else  Dec ( P );
    While P>0 do
      begin
        P:=P-3;
        If P>0 then
          S:=Copy(S,1,P)+','+Copy(S,P+1,L)
      end;
    If length(S)>L0 then  Dec ( L )
  until (length(S)<=L0) or (L=0);
  If Sign then
    FloatMoneyString:=PadL('-'+S,L0+1)
   else
    FloatMoneyString:=PadL(S,L0)
end;

Procedure InputMoneyFloat ( var Value : float; Y,X,L,Attr : byte );
var S     : string;
    P     : byte;
    Sign  : boolean;
    Point : boolean;
    Zero  : byte;
begin
  S:=AllTrim(FloatMoneyString(Value,L));
  If pos('E',S)>0 then
    begin
      InputFloat ( Value,Y,X,L,Attr );
      Exit
    end;
  If pos('.',S)>0 then  Point:=true  else  Point:=false;
  If Value<0 then
    begin
      Sign:=true;
      Value:=abs(Value)
    end
   else
    Sign:=false;
  Zero:=0;
  Repeat
    S:=AllTrim(FloatMoneyString(Value,L));
    If S='0' then  S:='';
    If Point and (pos('.',S)=0) then  S:=S+'.';
    If Zero>0 then  S:=S+replicate('0',Zero);
    If Sign then  S:='-'+S;
    WriteString ( PadL(S,L),Y,X,Attr );
    GoToXY ( X+L,Y );
    WaitEvent;
    Case KeyEvent of
      ord('0')..ord('9') : begin
                             If length(S)<L then  S:=S+chr(lo(KeyEvent));
                             ClearEvent
                           end;
                ord('.') : begin
                             If (length(S)<L) and (pos('.',S)=0) then
                               begin
                                 S:=S+'.';
                                 Point:=true
                               end;
                             ClearEvent
                           end;
           Key_Backspace : begin
                             If length(S)>0 then
                               begin
                                 If S[length(S)]='.' then  Point:=false;
                                 If S[length(S)]='-' then  Sign:=false;
                                 Dec ( S[0] );
                               end;
                             ClearEvent
                           end;
              Key_Delete : begin
                             S:='0';
                             Point:=false;
                             Sign:=false;
                             ClearEvent
                           end;
                ord('-') : begin
                             If S='0' then  Sign:=true;
                             ClearEvent
                           end;
            $0020..$00FF : ClearEvent;
      end;
    P:=pos(',',S);
    While P>0 do
      begin
        Delete ( S,P,1 );
        P:=pos(',',S)
      end;
    P:=pos('-',S);
    If P>0 then  Delete ( S,P,1 );
    Zero:=0;
    If pos('.',S)>0 then
      begin
        P:=length(S);
        While S[P]='0' do
          begin
            Inc ( Zero );
            Dec ( P )
          end
      end;
    Value:=StrToFloat(S)
  until AnyEvent;
  If Sign then  Value:=-Value;
  WriteString ( FloatMoneyString(Value,L),Y,X,Attr );
  HideCursor
end;

Procedure InputFloatSpecial ( var Value : float; Y,X,L,Attr : byte );
var S    : string;
    Err  : integer;
    Str1 : string;
    Str2 : string;
begin
  If Value<>0 then  S:=AllTrim(FloatToStr(Value,L))
   else
    begin
      S:=replicate(' ',L);
      WriteString ( S,Y,X,Attr );
      GoToXY ( X,Y );
      OnlyWaitEvent;
      If KeyEvent=Key_NoKey then  WaitEvent;
      If chr(lo(KeyEvent))='-' then  S:='-'
    end;
  Str1:='EeУу';
  Str2:='EEEE';
  If (MouseButton=0) or ((MouseY=Y) and (MouseX>=X) and (MouseX<X+L)) then
    Repeat
      InputAnyString ( S,Y,X,L,Attr,FloatNumberCharacter,Str1,Str2 );
      If (chr(lo(KeyEvent))='-') and (S='') then  S:='-'
    until (chr(lo(KeyEvent))<>'-') or (S<>'');
  Val ( S,Value,Err );
  If Err<>0 then  Value:=0;
  WriteString ( FloatToStr(Value,L),Y,X,Attr )
end;

Procedure InputLongInt ( var Value : longint; Y,X,L,Attr : byte );
var S        : string;
    Err      : integer;
    EmptyStr : string;
begin
  EmptyStr:='';
  If Value<>0 then  S:=AllTrim(FloatToStr(Value,L))  else  S:='';
  InputAnyString ( S,Y,X,L,Attr,IntNumberCharacter,EmptyStr,EmptyStr );
  Val ( S,Value,Err );
  If Err<>0 then  Value:=0;
  S:=LIntToStr(Value);
  While length(S)<L do  S:=' '+S;
  WriteString ( S,Y,X,Attr )
end;

Procedure InputInteger ( var Value : integer; Y,X,L,Attr : byte );
var S   : string;
    Err : integer;
    S0  : string;
begin
  S0:='';
  If Value<>0 then  S:=LIntToStr(Value)  else  S:='';
  InputAnyString ( S,Y,X,L,Attr,IntNumberCharacter,S0,S0 );
  Val ( S,Value,Err );
  If Err<>0 then  Value:=0;
  S:=LIntToStr(Value);
  While length(S)<L do  S:=' '+S;
  WriteString ( S,Y,X,Attr )
end;

Procedure InputDate ( var Value : longint; Y,X,Attr : byte );
var S : string;
    i : byte;
begin
  S:=DateToStr(Value);
  i:=1;
  While (i<=10) and (S[i]<>' ') do  Inc ( i );
  Repeat
    WriteString ( S,Y,X,Attr );
    GoToXY ( X+i-1,Y );
    WaitEvent;
    Case KeyEvent of
      Key_Backspace : begin
                        If i>1 then
                          begin
                            Repeat
                              Dec ( i )
                            until S[i]<>'/';
                            S[i]:=' '
                          end
                         else  Bell;
                        ClearEvent
                      end;
         Key_Delete : begin
                        S:='  /  /    ';
                        i:=1;
                        ClearEvent
                      end;
           Key_Plus : begin
                        Value:=StrToDate(S);
                        Value:=NextDay(Value);
                        S:=DateToStr(Value);
                        i:=1;
                        While (i<=10) and (S[i]<>' ') do  Inc ( i );
                        ClearEvent
                      end;
          Key_Minus : begin
                        Value:=StrToDate(S);
                        Value:=PrevDay(Value);
                        S:=DateToStr(Value);
                        i:=1;
                        While (i<=10) and (S[i]<>' ') do  Inc ( i );
                        ClearEvent
                      end;
    end;
    If lo(KeyEvent) in [$20..$FF] then
      begin
        If (lo(KeyEvent) in [ord('0')..ord('9')]) and (i<11) then
          begin
            S[i]:=char(lo(KeyEvent));
            Repeat
              Inc ( i )
            until S[i]<>'/'
          end
         else  Bell;
        ClearEvent
      end
  until AnyEvent;
  Value:=StrToDate(S);
  HideCursor
end;

Procedure InputTime ( var Value : longint; Y,X,Attr : byte );
var S : string;
    i : byte;
begin
  S:=TimeToStr(Value,1);
  Repeat
    WriteString ( S,Y,X,Attr );
    i:=5;
    While (i>0) and (S[i] in [' ','.']) do  Dec ( i );
    Inc ( i );
    If i=3 then  Inc ( i );
    GoToXY ( X+i-1,Y );
    WaitEvent;
    Case KeyEvent of
      ord('0')..ord('9') : begin
                             If ((i=1) and (KeyEvent<ord('3'))) or
                                 (i=2) or
                                 ((i=4) and (KeyEvent<ord('6'))) or
                                 (i=5) then
                               begin
                                 S[i]:=chr(KeyEvent);
                                 Inc ( i )
                               end;
                             ClearEvent
                           end;
           Key_Backspace : begin
                             If i>1 then
                               begin
                                 Dec ( i );
                                 If i=3 then  Dec ( i );
                                 S[i]:=' '
                               end;
                             ClearEvent
                           end;
              Key_Delete : begin
                             S:='  .  ';
                             ClearEvent
                           end
    end
  until AnyEvent;
  Value:=StrToTime(S)
end;


Procedure MultiLineStringShow ( S : string; Y0,X0,X1,Yl,Xl,Attr : byte );
var S1  : string;
    X,Y : byte;
    i   : word;
    L   : word;
begin
  L:=(Yl-1)*Xl+(Xl-(X1-X0));
  If L>255 then  L:=255;
  S:=PadR(S,L);
  Y:=Y0;
  X:=X1;
  i:=1;
  For Y:=Y0 to Y0+Yl-1 do
    begin
      WriteString (  Copy(S,i,Xl-(X-X0)),Y,X,Attr );
      i:=i+Xl-(X-X0);
      X:=X0
    end
end;

Procedure MultiLineStringInput ( var S : string; Y0,X0,X1,Yl,Xl,Attr : byte );
var S1  : string;
    X,Y : byte;
    Pos : word;
    i   : word;
    L   : word;
    Ch  : char;
begin
  Pos:=1;
  L:=(Yl-1)*Xl+(Xl-(X1-X0));
  If L>255 then  L:=255;
  S:=PadR(S,L);
  Repeat
    MultiLineStringShow ( S,Y0,X0,X1,Yl,Xl,Attr );
    X:=X1-1;
    Y:=Y0;
    For i:=1 to Pos do
      If X<X0+Xl-1 then  Inc ( X )
       else
        If Y<Y0+Yl-1 then
          begin
            Inc ( Y );
            X:=X0
          end
         else  Inc ( X );
    GoToXY ( X,Y );
    WaitEvent;
    If (MouseButton=LeftMouseButton) and
       (MouseX>=X0) and (MouseX<X0+Xl) and
       (MouseY>=Y0) and (MouseY<Y0+Yl) and
       ((MouseY>Y0) or (MouseX>X1)) then
      begin
        X:=MouseX;
        Y:=MouseY;
        Pos:=0;
        While Y>Y0 do
          begin
            Dec ( Y );
            Pos:=Pos+Xl;
            Pos:=Pos+X-X1
          end;
        ClearEvent
      end;
    Case KeyEvent of
           Key_Left : begin
                        If Pos>1 then
                          begin
                            Dec ( Pos );
                            ClearEvent
                          end
                      end;
          Key_Right : begin
                        If Pos<length(S)+1 then
                          begin
                            Inc ( Pos );
                            ClearEvent
                          end
                      end;
             Key_Up : begin
                        If Y>Y0 then
                          begin
                            If (Y>Y0+1) or (X>X1) then  Pos:=Pos-Xl  else  Pos:=1;
                            ClearEvent
                          end
                      end;
           Key_Down : begin
                        If Y<Y0+Yl-1 then
                          begin
                            Pos:=Pos+Xl;
                            If Pos>length(S)+1 then  Pos:=length(S)+1;
                            ClearEvent
                          end
                      end;
           Key_Home : begin
                        Pos:=1;
                        ClearEvent
                      end;
            Key_End : begin
                        Pos:=length(RTrim(S))+1;
                        ClearEvent
                      end;
       $0020..$00FF : begin
                        If (Pos<=length(S)) and (S[length(S)]=' ') then
                          begin
                            Ch:=chr(lo(KeyEvent));
                            If system.pos(Ch,LatinLetters)>0 then  Ch:=RussianLetters[system.pos(Ch,LatinLetters)];
                            S:=Copy(S,1,Pos-1)+Ch+Copy(S,Pos,length(S)-Pos);
                            Inc ( Pos )
                          end;
                        ClearEvent
                      end;
      Key_Backspace : begin
                        If Pos>1 then
                          begin
                            Delete ( S,Pos-1,1 );
                            Dec ( Pos );
                            S:=S+' '
                          end;
                        ClearEvent
                      end;
         Key_Delete : begin
                        If Pos<=length(S) then
                          begin
                            Delete ( S,Pos,1 );
                            S:=S+' '
                          end;
                        ClearEvent
                      end
    end
  until AnyEvent
end;


Procedure GetPassword ( var S    : string; { Редактируемый пароль }
                            Mess : string; { Сообщение }
                            L    : byte;   { Длина поля ввода }
                            NAttr: byte;   { Аттрибут окна }
                            HAttr: byte    { Аттрибут поля ввода } );
const Y1=10; Y2=12;
var Ch  : char;
    S1  : string;
    S2  : string;
    Scr : BoxContType;
    X1  : byte;
    X2  : byte;
begin
  X1:=(MaxTextX-length(Mess)-4-L) div 2;
  X2:=X1+L+length(Mess)+4;
  SaveBoxContents ( Scr,X1,Y1,X2+1,Y2+1 );
  FillBoxWith ( X1,Y1,X2,Y2,$20,NAttr );
  DrawBox ( X1,Y1,X2,Y2,NAttr,NormBoxString,true );
  S:=RTrim(S);
  S1:='QWERTYUIOP{}[]ASDFGHJKL:";''ZXCVBNM<>,.@#$%^&*()`~';
  S2:='ЙЦУКЕНГШЩЗХЪХЪФЫВАПРОЛДЖЭЖЭЯЧСМИТЬБЮБЮ"/$:,.;?%()';
  WriteString ( Mess,Y1+1,X1+2,NAttr );
  Repeat
    WriteString ( PadR(Replicate('*',length(S)),L),Y1+1,X1+length(Mess)+2,HAttr );
    GoToXY ( X1+length(Mess)+2+length(S),Y1+1 );
    WaitEvent;
    HideCursor;
    Case KeyEvent of
      Key_Backspace : begin
                        If length(S)>0 then  Dec ( S[0] );
                        ClearEvent
                      end;
         Key_Delete : begin
                        S:='';
                        ClearEvent
                      end
    end;
    Ch:=UpCase(char(lo(KeyEvent)));
    If pos(Ch,S2)>0 then  Ch:=S1[pos(Ch,S2)];
    If (Ch>=' ') and (length(S)<L) then  S:=S+Ch
  until (KeyEvent=Key_Enter) or (KeyEvent=Key_EnterGr) or (KeyEvent=Key_Esc);
  RestoreBoxContents ( Scr )
end;

Procedure InputPassword ( var S    : string; { Редактируемый пароль }
                              L    : byte;   { Длина поля ввода }
                              NAttr: byte;   { Аттрибут окна }
                              HAttr: byte    { Аттрибут поля ввода } );
begin
  S:='';
  GetPassword ( S,'Введите пароль : ',L,NAttr,HAttr )
end;

Procedure InputNewPassword ( var S    : string; { Редактируемый пароль }
                                 L    : byte;   { Длина поля ввода }
                                 NAttr: byte;   { Аттрибут окна }
                                 HAttr: byte    { Аттрибут поля ввода } );
var Pass1 : string;
    Pass2 : string;
begin
  Pass1:='';
  Pass2:='';
  GetPassword ( Pass1,'Введите новый пароль : ',L,NAttr,HAttr );
  GetPassword ( Pass2,'Повторите ввод нового пароля : ',L,NAttr,HAttr );
  If Pass1=Pass2 then
    S:=Pass1
   else
    ShowMessage ( 'Вы ошиблись при повторном вводе пароля',ErrorAttr )
end;


Procedure ShowMessage ( Mess : string; Attr : byte );
const Y1 = 10; Y2 = 12;
var X1,X2 : byte;
    P     : BoxContType;
begin
  If length(Mess)>74 then  Mess[0]:=#74;
  X1:=(80-length(Mess)-4) div 2;
  X2:=X1+length(Mess)+3;
  SaveBoxContents ( P,X1,Y1,X2+1,Y2+1 );
  FillBoxWith ( X1,Y1,X2,Y2,$20,Attr );
  DrawBox ( X1,Y1,X2,Y2,Attr,NormBoxString,Shadow );
  WriteString ( Mess,Y1+1,X1+2,Attr );
  Bell;
  WaitEvent;
  RestoreBoxContents ( P )
end;

Procedure GetYesNo ( Title1,Title2,Title3 : string; NAttr,HAttr : byte; var Yes : boolean );
var P           : BoxContType;
    X1,Y1,X2,Y2 : byte;
    L           : byte;
    N           : byte;
begin
  Y1:=10;  Y2:=15;  N:=4;
  L:=ord(Title1[0]);
  If L<14 then  L:=14;
  If ord(Title2[0])>L then  L:=ord(Title2[0]);
  If ord(Title3[0])>L then  L:=ord(Title3[0]);
  X1:=(80-L-2) div 2;
  X2:=X1+L+2;
  If MaxAvail<1000 then  Halt ( 0 );
  If Title3='' then
    begin
      Dec ( Y2 );
      Dec ( N );
      If Title2='' then
        begin
          Dec ( Y2 );
          Dec ( N )
        end
    end;
  SaveBoxContents ( P,X1-1,Y1,X2+1,Y2+1 );
  FillBoxWith ( X1-1,Y1,X2,Y2,$20,NAttr );
  DrawBox ( X1-1,Y1,X2,Y2,NAttr,NormBoxString,Shadow );
  WriteString ( Title1,Y1+1,(L-ord(Title1[0])) div 2+X1+1,NAttr );
  If Title2<>'' then  WriteString ( Title2,Y1+2,(L-ord(Title2[0])) div 2+X1+1,NAttr );
  If Title3<>'' then  WriteString ( Title3,Y1+3,(L-ord(Title3[0])) div 2+X1+1,NAttr );
  If RussianVersion then
    WriteString ( ' Да      Нет',Y1+N,(L div 2)+X1-6,NAttr )
   else
    WriteString ( 'Yes      No ',Y1+N,(L div 2)+X1-6,NAttr );
  Bell;
  Repeat
    If Yes then
      begin
        If RussianVersion then
          WriteString ( ' Да',Y1+N,(L div 2)+X1-6,HAttr )
         else
          WriteString ( 'Yes',Y1+N,(L div 2)+X1-6,HAttr );
      end
     else
      begin
        If RussianVersion then
          WriteString ( 'Нет',Y1+N,(L div 2)+X1+9-6,HAttr )
         else
          WriteString ( ' No',Y1+N,(L div 2)+X1+9-6,HAttr );
      end;
    WaitEvent;
  If RussianVersion then
    WriteString ( ' Да      Нет',Y1+N,(L div 2)+X1-6,NAttr )
   else
    WriteString ( 'Yes      No ',Y1+N,(L div 2)+X1-6,NAttr );
    Case lo(KeyEvent) of
      ord('Y'),ord('y') : Yes:=true;
      ord('N'),ord('n') : Yes:=false
    end;
    If (KeyEvent=Key_Right) or (KeyEvent=Key_Left) then
      begin
        If Yes then  Yes:=false  else  Yes:=true
      end
  until (lo(KeyEvent) in [ord('Y'),ord('y'),ord('N'),ord('n')]) or ((KeyEvent=Key_Enter) or (KeyEvent=Key_Esc));
  RestoreBoxContents ( P )
end;

Procedure ProgInfo ( Title,Version : string;
                     CopyNumber    : longint;
                     Owner         : string;
                     Attr,BAttr    : byte );
Const Yupper=10; Yl=9;
var P     : BoxContType;
    Xleft : byte;
    Xl    : byte;
    S1    : string;
    S2    : string;
begin
  Xl:=20;
  If CopyNumber=1 then
    S1:='Специально для : '+Owner
   else
    S1:='Копия : '+LIntToStr(CopyNumber)+'   Владелец : '+Owner;
  S2:=TheCompany;
  If length(Title)>Xl then  Xl:=length(Title);
  If length(Version)>Xl then  Xl:=length(Version);
  If length(S1)>Xl then  Xl:=length(S1);
  If length(S2)>Xl then  Xl:=length(S2);
  If Xl>74 then  Xl:=74;
  Xl:=Xl+2;
  Xleft:=(80-Xl) div 2;
  SaveBoxContents ( P,Xleft,Yupper,Xleft+Xl+2,Yupper+Yl+2 );
  FillBoxWith ( Xleft,Yupper,Xleft+Xl+1,Yupper+Yl+1,$20,Attr );
  DrawBox ( Xleft,Yupper,Xleft+Xl+1,Yupper+Yl+1,Attr,NormBoxString,Shadow );
  If AuthorName[1]<>'C' then
    Asm
      push   ds
      call   ClearEvent
    end;
  WriteString ( CenterString(AuthorName,Xl),Yupper+1,Xleft+1,Attr );
  WriteString ( CenterString(Title,Xl),Yupper+3,Xleft+1,Attr );
  WriteString ( CenterString(Version,Xl),Yupper+5,Xleft+1,Attr );
  WriteString ( CenterString(S1,Xl),Yupper+7,Xleft+1,Attr );
  WriteString ( CenterString(S2,Xl),Yupper+8,Xleft+1,Attr );
  WriteString ( ' OK ',Yupper+9,Xleft+1+(Xl-4) div 2,BAttr );
  Bell;
  WaitEvent;
  ClearEvent;
  RestoreBoxContents ( P )
end;

Function PrinterStatus : byte;
begin
  Asm
    mov  ah,2
    mov  dx,0
    int  $17
    mov  @Result,ah
  end
end;

Function WasAnyEvent : boolean;
begin
  Asm
    mov    ah,01h
    int    16h
    jz     @NoKey
    mov    @Result,1
    jmp    @Exit
@NoKey:
    mov    @Result,0
@Exit:
  end
end;

Procedure StatusLine ( S1,S2 : string );
var i : byte;
begin
  If StatusTextAttr or StatusKeyAttr = 0 then  Exit;
  WriteString ( PadR(S2,80),25,1,StatusTextAttr );
  For i:=1 to length(S1) do
    If S1[i]<>' ' then  WriteString ( S1[i],25,i,StatusKeyAttr )
end;

Type Buffer = array[0..$FFF0] of byte;

Procedure EncodeBuffer ( P : pointer; L : word );
var A   : ^Buffer absolute P;
    i,j : word;
begin
  j:=1;
  For i:=0 to L-1 do
    begin
      A^[i]:=A^[i]-ord(CodeString[j]);
      If j<length(CodeString) then  Inc ( j )  else  j:=1
    end;
end;

Procedure DecodeBuffer ( P : pointer; L : word );
var A   : ^Buffer absolute P;
    i,j : word;
    C,B : byte;
begin
  j:=1;
  If L=0 then  Exit;
  For i:=0 to L-1 do
    begin
      C:=ord(CodeString[j]);
      B:=A^[i];
      Asm
        mov  al,B
        add  al,C
        mov  B,al
      end;
      A^[i]:=B;
{      A^[i]:=A^[i]+ord(CodeString[j]);}
      If j<length(CodeString) then  Inc ( j )  else  j:=1
    end;
end;

Function BiosSum : word;
var N : word;
    P : ^byte;
    i : word;
begin
  P:=Ptr($F000,0);
  N:=0;
  i:=0;
  Repeat
    Inc ( P );
    N:=N+P^;
    Inc ( i )
  until i=$FFFF;
  BiosSum:=N
end;

Var WaitScr : BoxContType;

Procedure PutWaitMessage;
begin
  SaveBoxContents ( WaitScr,26,10,55,13 );
  FillBoxWith ( 26,10,54,12,$20,WaitMessageAttr );
  DrawBox ( 26,10,54,12,WaitMessageAttr,NormBoxString,Shadow );
  WriteString ( 'Подождите, пожалуйста ...',11,28,WaitMessageAttr or $80);
  Bell
end;

Procedure RemoveWaitMessage;
begin
  RestoreBoxContents ( WaitScr )
end;

Procedure SetTranslationOn;
begin
  RussianLetters:='АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя:,.%?)(;"';
  AltRussianLetters:='F<DULT:PBQRKVYJGHCNEA{WXIO}SM">ZАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ:,.%?)(;"'
end;

Procedure SetTranslationOff;
begin
  RussianLetters:=LatinLetters;
  AltRussianLetters:=AltLatinLetters
end;

Procedure SwitchTranslation;
begin
  If RussianLetters=LatinLetters then
    begin
      RussianLetters:='АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя:,.%?)(;"';
      AltRussianLetters:='F<DULT:PBQRKVYJGHCNEA{WXIO}SM">ZАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ:,.%?)(;"'
    end
   else
    begin
      RussianLetters:=LatinLetters;
      AltRussianLetters:=AltLatinLetters
    end
end;

Function ConvertToRussian ( Ch : char ) : char;
const S : string = 'АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя:,.%?)(;"';
var P : word;
begin
  P:=pos(Ch,LatinLetters);
  If P>0 then  Ch:=S[P];
  ConvertToRussian:=Ch
end;


Type StatusKeyDescriptionPtr = ^StatusKeyDescription;
     StatusKeyDescription = record
                              Key     : word;
                              KeyName : string[12];
                              Text    : string[25];
                              X,Y,L   : byte;
                              Code    : char;
                              Next    : StatusKeyDescriptionPtr
                            end;

Var StatusKeys : StatusKeyDescriptionPtr;

Type BarPoint = record
                  X : byte;
                  Y : byte
                end;

Var UpBarPoint    : BarPoint;
    DownBarPoint  : BarPoint;
    LeftBarPoint  : BarPoint;
    RightBarPoint : BarPoint;

Procedure WaitEvent;
var P : StatusKeyDescriptionPtr;
begin
  If not LastWasCommand then
    SP_CRT.WaitEvent
   else
    begin
      LastWasCommand:=false;
      If MouseButtonPressed(LeftMouseButton) then
        MouseButton:=LeftMouseButton
       else
        SP_CRT.WaitEvent
    end;
  If MouseButton=LeftMouseButton then
    begin
      P:=StatusKeys;
      While P<>nil do
        begin
          If (MouseX>=P^.X) and (MouseX<P^.X+P^.L) and (MouseY=P^.Y) then  break;
          P:=P^.Next
        end;
      If P<>nil then
        begin
          MouseButton:=0;
          KeyEvent:=P^.Key;
          If OnKeyProcedure<>nil then
            Asm
              call    dword  ptr  OnKeyProcedure
            end
        end
    end;
  If KeyEvent>$FF00 then  LastWasCommand:=true
end;

Procedure ClearMouseKeys ( Code : char );
var P,P1,P2 : StatusKeyDescriptionPtr;
begin
  If StatusKeys=nil then  Exit;
  P1:=StatusKeys;
  P2:=StatusKeys^.Next;
  While P2<>nil do
    begin
      P:=P2;
      P2:=P2^.Next;
      If P^.Code=Code then
        begin
          P1^.Next:=P2;
          Dispose ( P )
        end
       else  P1:=P
    end;
  If StatusKeys^.Code=Code then
    begin
      P:=StatusKeys;
      StatusKeys:=StatusKeys^.Next;
      Dispose ( P )
    end
end;

Procedure ClearStatus;
begin
  ClearMouseKeys ( 'S' )
end;

Procedure ClearAllMouseKeys;
var P : StatusKeyDescriptionPtr;
begin
  P:=StatusKeys;
  While StatusKeys<>nil do
    begin
      P:=StatusKeys;
      StatusKeys:=StatusKeys^.Next;
      Dispose ( P )
    end
end;

Procedure AddMouseKey ( KeyCode : word; X0,Y0,L0 : byte; Code : char );
var P0,P : StatusKeyDescriptionPtr;
begin
  P:=StatusKeys;
  While (P<>nil) and (P^.Next<>nil) do  P:=P^.Next;
  New ( P0 );
  If P<>nil then  P^.Next:=P0  else  StatusKeys:=P0;
  With P0^ do
    begin
      X:=X0;
      Y:=Y0;
      L:=L0;
      Key:=KeyCode;
      Next:=nil
    end;
  P0^.Code:=Code
end;

Procedure AddStatusKey ( KeyCode : word; KeyText : string; Description : string );
var P0,P : StatusKeyDescriptionPtr;
    X0   : byte;
begin
  P:=StatusKeys;
  X0:=2;
  If P<>nil then
    begin
      If P^.Y=MaxTextY then  X0:=X0+P^.L+2;
      While (P<>nil) and (P^.Next<>nil) do
        begin
          P:=P^.Next;
          If P^.Y=MaxTextY then  X0:=X0+P^.L+2
        end
    end;
  New ( P0 );
  If P<>nil then  P^.Next:=P0  else  StatusKeys:=P0;
  With P0^ do
    begin
      Next:=nil;
      Key:=KeyCode;
      KeyName:=KeyText;
      L:=length(KeyText)+1+length(Description);
      X:=X0;
      Y:=MaxTextY;
      Code:='S';
      Text:=Description
    end
end;

Procedure ShowStatusLine;
var P : StatusKeyDescriptionPtr;
begin
  If (StatusTextAttr=0) or (StatusKeyAttr=0) then  Exit;
  WriteString ( replicate(' ',MaxTextX),MaxTextY,1,StatusTextAttr );
  P:=StatusKeys;
  While P<>nil do
    begin
      If P^.Code='S' then
        begin
          WriteString ( P^.KeyName,MaxTextY,P^.X,StatusKeyAttr );
          WriteString ( P^.Text,MaxTextY,P^.X+length(P^.KeyName)+1,StatusTextAttr )
        end;
      P:=P^.Next
    end
end;

Var VerticalScrollBar : record
                          BarAttr  : byte;
                          IconAttr : byte
                        end;

Var HorizontalScrollBar : record
                            BarAttr  : byte;
                            IconAttr : byte
                          end;

Procedure SetVerticalScrollBar ( X0,Y0,L,BarAttr,IconAttr : byte  );
begin
  ClearMouseKeys ( 'V' );
  UpBarPoint.X:=X0;
  UpBarPoint.Y:=Y0;
  DownBarPoint.X:=X0;
  DownBarPoint.Y:=Y0+L-1;
  VerticalScrollBar.BarAttr:=BarAttr;
  VerticalScrollBar.IconAttr:=IconAttr;
  AddMouseKey ( cmMoveUp,X0,Y0,1,'V' );
  AddMouseKey ( cmMoveDown,X0,Y0+L-1,1,'V' )
end;

Procedure SetHorizontalScrollBar ( X0,Y0,L,BarAttr,IconAttr : byte  );
begin
  ClearMouseKeys ( 'H' );
  LeftBarPoint.X:=X0;
  LeftBarPoint.Y:=Y0;
  RightBarPoint.X:=X0+L-1;
  RightBarPoint.Y:=Y0;
  HorizontalScrollBar.BarAttr:=BarAttr;
  HorizontalScrollBar.IconAttr:=IconAttr;
  AddMouseKey ( cmMoveLeft,X0,Y0,1,'H' );
  AddMouseKey ( cmMoveRight,X0+L-1,Y0,1,'H' )
end;

Procedure ShowVerticalScrollBar ( Procent : integer );
var i : byte;
begin
  If (UpBarPoint.X>0) and (UpBarPoint.Y>0) and
     (DownBarPoint.X>0) and (DownBarPoint.Y>0) then
    begin
      WriteString ( '',UpBarPoint.Y,UpBarPoint.X,VerticalScrollBar.IconAttr );
      For i:=UpBarPoint.Y+1 to DownBarPoint.Y-1 do
        WriteString ( '▒',i,UpBarPoint.X,VerticalScrollBar.BarAttr );
      WriteString ( '',DownBarPoint.Y,DownBarPoint.X,VerticalScrollBar.IconAttr );
      If (Procent>=0) and (Procent<=100) then
        WriteString ( '■',UpBarPoint.Y+1+((DownBarPoint.Y-UpBarPoint.Y-2)*Procent) div 100,
                      UpBarPoint.X,VerticalScrollBar.IconAttr )
    end
end;

Procedure ShowHorizontalScrollBar ( Procent : integer );
begin
  If (LeftBarPoint.X>0) and (LeftBarPoint.Y>0) and
     (RightBarPoint.X>0) and (RightBarPoint.Y>0) then
    begin
      WriteString ( #17,LeftBarPoint.Y,LeftBarPoint.X,HorizontalScrollBar.IconAttr );
      WriteString ( replicate('▒',RightBarPoint.X-LeftBarPoint.X-1),
                    LeftBarPoint.Y,LeftBarPoint.X+1,HorizontalScrollBar.BarAttr );
      WriteString ( #16,RightBarPoint.Y,RightBarPoint.X,HorizontalScrollBar.IconAttr );
      If (Procent>=0) and (Procent<=100) then
        WriteString ( '■',LeftBarPoint.Y,
                      LeftBarPoint.X+1+((RightBarPoint.X-LeftBarPoint.X-2)*Procent) div 100,
                      HorizontalScrollBar.IconAttr )
    end
end;

begin
  StatusTextAttr:=$07;
  StatusKeyAttr:=$0F;
  ErrorAttr:=$0F;
  ButtonAttr:=$70;
  WaitMessageAttr:=$70;
  CodeString:=TheCompany;
  SetTranslationOn;
  RussianVersion:=true;
  StatusKeys:=nil;
  UpBarPoint.X:=0;
  UpBarPoint.Y:=0;
  DownBarPoint.X:=0;
  DownBarPoint.Y:=0;
  LeftBarPoint.X:=0;
  LeftBarPoint.Y:=0;
  RightBarPoint.X:=0;
  RightBarPoint.Y:=0;
  LastWasCommand:=false;
  BellOnError:=false;
  WaitScr.Ptr:=nil
end.
