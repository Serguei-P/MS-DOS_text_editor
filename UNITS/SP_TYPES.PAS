{$I-,V-,B-}
{                                                            26 августа 1993г.
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║                     Функции преобразования данных                          ║
║                  для Turbo-Pascal ver. 5.5, 6.0, 7.0                       ║
║                                                                            ║
║                          Автор :  С.Поляков.                               ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝}

Unit SP_Types;

Interface

{$I define.inc}

Type DateType    = longint;
     DateTypePtr = ^DateType;
     TimeType    = longint;
     TimeTypePtr = ^TimeType;
{$IFDEF ExtendedFloat}
     Float       = extended;
{$ELSE}
     Float       = real;
{$ENDIF}
     FloatPtr    = ^Float;

{ Функция преобразует дату в строку }
Function DateToStr ( Value : DateType ) : string;

{ Функция возвращает год для даты, полученной функцией DateField }
Function Year ( Date : DateType ) : word;

{ Функция возвращает месяц для даты, полученной функцией DateField }
Function Month ( Date : DateType ) : byte;

{ Функция возвращает число для даты, полученной функцией DateField }
Function Day ( Date : DateType ) : byte;

{ Функция преобразует строку вида '29/05/1992' в дату }
Function StrToDate ( Str : string ) : DateType;

{ Функция возвращает число дней между двумя датами }
Function DateDistance ( D1,D2 : DateType ) : longint;

{ Функция возвращает дату дня, сдедующего за Date }
Function NextDay ( Date : DateType ) : DateType;

{ Функция возвращает дату дня, предшедствующего Date }
Function PrevDay ( Date : DateType ) : DateType;

{ Функция возвращает true, если дата Date правильная и false
  в противном случае }
Function DateValid ( Date : DateType ) : boolean;

{ Функция возвращает номер квартала, которому принадлежит дата Date }
Function QuaterOfDate ( Date : DateType ) : byte;

{ Преобразование байта в строку-шестнадцатеричное число }
Function ByteToHex ( V : byte ) : string;

{ Преобразование слова в строку-шестнадцатеричное число }
Function WordToHex ( V : word ) : string;

{ Преобразование двойного слова в строку-шестнадцатеричное число }
Function DWordToHex ( V : longint ) : string;

{ Преобразование троки-шестнадцатиричного числа в двойное слово }
Function HexToDWord ( S : string ) : longint;

{ Преобразование байта в строку }
Function ByteToStr ( V : byte ) : string;

{ Преобразование слова в строку }
Function WordToStr ( V : word ) : string;

{ Преобразование целого числа в строку }
Function IntToStr ( V : integer ) : string;

{ Преобразование длинного целого в строку }
Function LintToStr ( V : longint ) : string;

{ Преобразование строки в целое число }
Function StrToLint ( S : string ) : longint;

{ Преобразование действительного числа в строку }
Function FloatToStr ( V : float; L0 : byte ) : string;

{ Преобразование строки в действительное число }
Function StrToFloat ( S : string ) : float;

{ Преобразование строки в тип Comp }
Procedure StrToComp ( S : string; var Val : comp );

{ Преобразование времени в строку
    Code = 0  - 15:24:35    09:06:32
    Code = 1  - 15:24       09:06
    Code = 2  - 3:24p       9:06a
    Code = 3  - 15          09   }
Function TimeToStr ( Value : TimeType; Code : byte ) : string;

{ Преобразование строки в время }
Function StrToTime ( S : string ) : TimeType;

{ Удаление хвостовых и головных пробелов в строке }
Function AllTrim ( S : string ) : string;

{ Удаление хвостовых пробелов в строке }
Function RTrim ( S : string ) : string;

{ Удаление головных пробелов в строке }
Function LTrim ( S : string ) : string;

{ Добавление к строке S пробелов до длины L }
Function PadR ( S : string; L : byte ) : string;

{ Добавление к строке S символов C до длины L }
Function PadRCh ( S : string; L : byte; C : char ) : string;

{ Добавление пробелов в начало строки до длины L }
Function PadL ( S : string; { исходная строка }
                L : byte    { длина строки-результата } ) : string;

{ Добавление к строке S символов C до длины L }
Function PadLCh ( S : string; L : byte; C : char ) : string;

{ Строка из символов C длиной L }
Function Replicate ( C : char; L : byte ) : string;

{ Центрирование строки }
Function CenterString ( S0 : string; { исходная строка }
                        L  : byte    { длина строки-результата } ) : string;

{ Преобразование символа в верхний регистр (аналогично одноименной функции
  модуля System, но с учетом кириллицы) }
Function UpCase ( C : char ) : char;

{ Замена маленьких букв в строке на большие }
Function UpperCase ( S : string ) : string;

{ Замена больших букв в строке на маленькие }
Function LowerCase ( S : string ) : string;

{ Преобразование адреса в строку }
Function AddrToStr ( P : pointer ) : string;

{Функция возвращает N-ое слово из строки Str}
Function GetOneWord ( Str : string; N : word ) : string;

{Округление действительного числа}
Function RoundFloat ( V : float ) : float;

{ Получить N-ое слово из строки S0 }
Function GetWord ( S0 : string; N : word ) : string;

{ Добавление нулей слева от строки }
Function PadLZero ( S : string; L : byte ) : string;

Implementation

{$L sp_types.obj}

Function ZeroStr ( S : string; L : byte ) : string;
begin
  While length(S)<L do  S:='0'+S;
  ZeroStr:=S
end;

Function Year ( Date : DateType ) : word;
begin
  Year:=Date div 10000;
end;

Function Month ( Date : DateType ) : byte;
begin
  Month:=(Date div 100) mod 100
end;

Function Day ( Date : DateType ) : byte;
begin
  Day:=Date mod 100
end;

Function StrToDate ( Str : string ) : DateType;
var Date  : longint;
    Year  : word;
    Month : byte;
    Day   : byte;
    S     : string;
    i     : byte;
    Err   : integer;
begin
  StrToDate:=0;
  S:='';
  i:=1;
  While (i<=length(Str)) and (not (Str[i] in ['/','.','-'])) do
    begin
      S:=S+Str[i];
      Inc ( i )
    end;
  Val ( S,Day,Err );
  If Err<>0 then  Exit;
  Inc ( i );
  S:='';
  While (i<=length(Str)) and (not (Str[i] in ['/','.','-'])) do
    begin
      S:=S+Str[i];
      Inc ( i )
    end;
  Val ( S,Month,Err );
  If Err<>0 then  Exit;
  Inc ( i );
  S:='';
  While (i<=length(Str)) and (not (Str[i] in ['/','.','-'])) do
    begin
      S:=S+Str[i];
      Inc ( i )
    end;
  S:=AllTrim(S);
  If length(S)=2 then  S:='19'+S;
  Val ( S,Year,Err );
  If Err<>0 then  Exit;
  Date:=Year;
  StrToDate:=Date*10000+Month*100+Day
end;

Function DateValid ( Date : DateType ) : boolean;
var DaysInMonth : byte;
begin
  DateValid:=true;
  If Month(Date)>12 then  DateValid:=false;
  If Month(Date)<1 then  DateValid:=false;
  If Year(Date)<1 then  DateValid:=false;
  If Day(Date)<1 then  DateValid:=false;
  Case Month(Date) of
    1,3,5,7,8,10,12 : DaysInMonth:=31;
    2               : begin
                        If Year(Date) mod 4 = 0 then  DaysInMonth:=29  else  DaysInMonth:=28
                      end;
    4,6,9,11        : DaysInMonth:=30;
   else  DaysInMonth:=0
  end;
  If Day(Date)>DaysInMonth then  DateValid:=false
end;

Function QuaterOfDate ( Date : DateType ) : byte;
var M : byte;
begin
  M:=Month(Date);
  Case M of
       1,2,3 : QuaterOfDate:=1;
       4,5,6 : QuaterOfDate:=2;
       7,8,9 : QuaterOfDate:=3;
    10,11,12 : QuaterOfDate:=4;
   else
    QuaterOfDate:=0
  end
end;

Function NextDayNear ( Date : DateType ) : DateType;
var DaysInMonth : byte;
    M,D         : byte;
    Y           : word;
    DD          : word;
begin
  DD:=Date mod 10000;
  D:=DD mod 100;
  M:=DD div 100;
  Y:=Date div 10000;
  Case M of
    1,3,5,7,8,10,12 : DaysInMonth:=31;
    2               : begin
                        If Y mod 4 = 0 then  DaysInMonth:=29  else  DaysInMonth:=28
                      end;
    4,6,9,11        : DaysInMonth:=30
  end;
  If D<DaysInMonth then  NextDayNear:=Date+1
    else
     begin
       D:=1;
       If M<12 then  Inc ( M )
        else
         begin
           M:=1;
           Inc ( Y )
         end;
       Date:=Y;
       NextDayNear:=Date*10000+M*100+D
     end
end;

Function NextDay ( Date : DateType ) : DateType;
begin
  NextDay:=NextDayNear(Date)
end;

Function PrevDay ( Date : DateType ) : DateType;
var DaysInMonth : byte;
    M,D         : byte;
    Y           : word;
    DD          : word;
begin
  DD:=Date mod 10000;
  D:=DD mod 100;
  M:=DD div 100;
  Y:=Date div 10000;
  If D>1 then  Dec ( D )
   else
    If M>1 then
      begin
        Dec ( M );
        Case M of
          1,3,5,7,8,10,12 : D:=31;
          2               : begin
                              If Y mod 4 = 0 then  D:=29  else  D:=28
                            end;
          4,6,9,11        : D:=30
        end
      end
     else
      begin
        Dec ( Y );
        M:=12;
        D:=31
      end;
  Date:=Y;
  PrevDay:=Date*10000+M*100+D
end;

Function DateDistance ( D1,D2 : DateType ) : longint;
var R     : longint;
    Sign  : longint;
    M1,M2 : byte;
    D     : byte;
    Y1,Y2 : word;
begin
  Sign:=1;
  If D2<D1 then
    begin
      Sign:=-1;
      R:=D2;
      D2:=D1;
      D1:=R
    end;
  R:=0;
  If D2-D1>10000 then
    begin
      Y1:=D1 div 10000;
      Y2:=D2 div 10000;
      M1:=(D1 div 100) mod 100;
      M2:=(D2 div 100) mod 100;
      D:=D1 mod 100;
      If (M1=2) and (D=29) then
        begin
          M1:=3;
          D:=1;
          Inc ( R )
        end;
      Repeat
        If (M1<2) and (Y1 mod 4 = 0) then  Inc ( R );
        Inc ( Y1 );
        R:=R+365;
        If (M1>2) and (Y1 mod 4 = 0) then  Inc ( R )
      until (Y2-Y1<=1) and ((M2<=M1) or (Y2=Y1));
      D1:=Y1;
      D1:=(D1*10000)+M1*100+D
    end;
  While D2<>D1 do
    begin
      Inc ( R );
      D1:=NextDayNear(D1)
    end;
  DateDistance:=R*Sign
end;

Function ByteToHex ( V : byte ) : string;
Const HexSign : array [0..$F] of char =
             ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
begin
  ByteToHex:=HexSign[(V and $F0) div $10]+HexSign[V and $0F]
end;

Function WordToHex ( V : word ) : string;
begin
  WordToHex:=ByteToHex(hi(V))+ByteToHex(lo(V))
end;

Function DWordToHex ( V : longint ) : string;
begin
  DWordToHex:=WordToHex((V and $FFFF0000) shr 16)+WordToHex(V and $0000FFFF)
end;

Function HexToDWord ( S : string ) : longint;
var V : longint;
    i : word;
begin
  V:=0;
  S:=UpperCase(S);
  For i:=1 to length(S) do
    begin
      Case S[i] of
        '0'..'9' : begin
                     V:=V*16+ord(S[i])-ord('0')
                   end;
        'A'..'F' : begin
                     V:=V*16+ord(S[i])-ord('A')+10
                   end
      end
    end;
  HexToDWord:=V
end;

Function ByteToStr ( V : byte ) : string;
var S : string;
begin
  Str ( V,S );
  ByteToStr:=S
end;

Function WordToStr ( V : word ) : string;
var S : string;
begin
  Str ( V,S );
  WordToStr:=S
end;

Function IntToStr ( V : integer ) : string;
var S : string;
begin
  Str ( V,S );
  IntToStr:=S
end;

Function LIntToStr ( V : longint ) : string;
var S : string;
begin
  Str ( V,S );
  LIntToStr:=S
end;

Function FloatToStr ( V : float; L0 : byte ) : string;
var X,Y   : byte;
    i     : integer;
    R     : float;
    S     : string;
    L     : byte;
function pow ( N : integer ) : float;
var R : float;
    i : integer;
begin
  R:=1;
  If N>0 then
    For i:=1 to N do  R:=R*10.0
   else
    begin
      N:=abs(N);
      For i:=1 to N do  R:=R*0.1
    end;
  pow:=R
end;
begin
  R:=abs(V);
  L:=L0;
  If L>20 then  L:=20;
  If (R>pow(L)) or ((V<0) and (R>pow(L-1))) or ((R<pow(4-L)) and (L>3)) then
    begin
      If V>0 then
        begin
          Str ( V:L+1,S );
          If S[1]=' ' then  Delete ( S,1,1 )
        end
       else  Str( V:L,S );
      If S[length(S)-5]='E' then
        begin
          If S[length(S)-2]='0' then  Delete ( S,length(S)-2,1 );
          If S[length(S)-2]='0' then  Delete ( S,length(S)-2,1 )
        end
    end
   else
    begin
      If R>=1 then
        begin
          If R<1000 then
            begin
              If R<10 then
                I:=1
               else
                If R<100 then
                  I:=2
                 else
                  I:=3
            end
           else
            If R<1000000 then
              begin
                If R<10000 then
                  I:=4
                 else
                  If R<100000 then
                    I:=5
                   else
                    I:=6
              end
             else
              If R<1000000000 then
                begin
                  If R<10000000 then
                    I:=7
                   else
                    If R<100000000 then
                      I:=8
                     else
                      I:=9
                end
               else
                I:=trunc(ln(R)/ln(10))+1;
          X:=L;
          If V<0 then  Dec ( X );
          Y:=X-I;
          If Y>0 then  Dec ( Y )
        end
       else
        begin
          X:=L;
          If V<0 then  Dec ( X );
          Y:=X-2
        end;
      If (Abs(V)<2147483647) and (R=trunc(R)) then
        Str ( V:L:0,S )
       else
        Str ( V:X:Y,S )
    end;
  If (Pos('.',S)>0) and (Pos('E',S)=0) then
    While (length(S)>0) and (S[length(S)]='0') do  Dec ( S[0] );
  If S[length(S)]='.' then  Dec ( S[0] );
  If V=0 then  S:='0';
  FloatToStr:=PadL(S,L0);
end;

Function StrToFloat ( S : string ) : float;
var R   : float;
    Err : integer;
begin
  Val ( S,R,Err );
  If Err<>0 then  R:=0;
  StrToFloat:=R
end;

Function StrToLint ( S : string ) : longint;
var R   : longint;
    Err : integer;
begin
  Val ( S,R,Err );
  If Err<>0 then  R:=0;
  StrToLint:=R
end;

Function DateToStr ( Value : DateType ) : string;
var DS,MS,YS : string;
begin
  If Value>0 then
    begin
      Str ( Value mod 100,DS );
      Str ( (Value div 100) mod 100,MS );
      Str ( Value div 10000,YS );
      DateToStr:=ZeroStr(DS,2)+'/'+ZeroStr(MS,2)+'/'+ZeroStr(YS,4)
    end
   else  DateToStr:='  /  /    '
end;

Function TimeToStr ( Value : TimeType; Code : byte ) : string;
var H,M,S : string[2];
    R     : string;
    i     : byte;
begin
  If Value>240000 then  Value:=999999;
  If (Code<>2) or (Value<130000) then
    begin
      H:=ByteToStr(Value div 10000);
      If length(H)<2 then  H:='0'+H
    end
   else
    H:=ByteToStr(Value div 10000 - 12);
  M:=ByteToStr((Value mod 10000) div 100);
  S:=ByteToStr(Value mod 100);
  If length(M)<2 then  M:='0'+M;
  If length(S)<2 then  S:='0'+S;
  Case Code of
    0 : R:=H+':'+M+':'+S;
    1 : R:=H+':'+M;
    2 : begin
          R:=H+':'+M;
          If Value<130000 then  R:=R+'a'  else  R:=R+'p'
        end;
    3 : R:=H;
   else  R:=''
  end;
  TimeToStr:=R
end;

Function GetWord ( S0 : string; N : word ) : string;
var S : string;
    i : word;
    m : word;
begin
  S:='';
  i:=1;
  m:=0;
  While i<=length(S0) do
    begin
      While S0[i] in [' ',#9] do  Inc ( i );
      If i<=length(S0) then
        begin
          Inc ( m );
          S:='';
          While (not (S0[i] in [' ',#9])) and (i<=length(S0)) do
            begin
              S:=S+S0[i];
              If S0[i] in ['+','-','*','/','^','.',',',':',';'] then
                begin
                  Inc ( i );
                  break
                end;
              Inc ( i )
            end;
          If m=N then
            begin
              GetWord:=S;
              Exit
            end
        end
    end;
  GetWord:=''
end;

Function GetWordFromStr ( S : string; var Pos : byte) : word;
var i    : byte;
    Stmp : string;
    R    : word;
    Code : integer;
begin
  Stmp:='';
  While (Pos<=length(S)) and (not (S[Pos] in ['0'..'9'])) do  Inc ( Pos );
  While (Pos<=length(S)) and (S[Pos] in ['0'..'9']) do
    begin
      Stmp:=Stmp+S[Pos];
      Inc ( Pos )
    end;
  Val ( Stmp,R,Code );
  If Code<>0 then  R:=0;
  GetWordFromStr:=R
end;

Function StrToTime ( S : string ) : TimeType;
var P : byte;
    R : longint;
    W : word;
begin
  P:=1;
  R:=GetWordFromStr(S,P);
  W:=GetWordFromStr(S,P);
  If W>59 then  R:=100;
  R:=R*100+W;
  W:=GetWordFromStr(S,P);
  If W>59 then  R:=10000;
  R:=R*100+W;
  If R>240000 then  R:=999999;
  StrToTime:=R
end;

Function AllTrim ( S : string ) : string; external;

Function LTrim ( S : string ) : string; external;

Function RTrim ( S : string ) : string; external;

Function PadR ( S : string; L : byte ) : string; external;

Function PadL ( S : string; L : byte ) : string; external;

Function Replicate ( C : char; L : byte ) : string; external;

Function CenterString ( S0 : string; L : byte ) : string;
var S : string;
    N : byte;
    i : byte;
begin
  If L>length(S0) then
    begin
      S:='';
      N:=(L-length(S0)) div 2;
      S[0]:=char(N);
      For i:=1 to N do S[i]:=' ';
      S:=S+S0+S;
      If length(S)<L then  S:=' '+S;
      CenterString:=S
    end
   else  CenterString:=Copy(S0,1,L)
end;

Function AddrToStr ( P : pointer ) : string;
begin
  AddrToStr:=WordToHex(Seg(P^))+':'+WordToHex(Ofs(P^))
end;

Function GetOneWord ( Str : string; N : word ) : string;
var S : string;
    i : word;
    W : word;
    L : word;
begin
  i:=1;
  W:=1;
  S:='';
  L:=length(Str);
  While (i<=L) and (W<=N) do
    begin
      While (i<=L) and (Str[i]=' ') do  Inc ( i );
      If W=N then
        begin
          While (i<=L) and (Str[i]<>' ') do
            begin
              Inc ( S[0] );
              S[ord(S[0])]:=Str[i];
              Inc ( i )
            end
        end
       else
        begin
          While (i<=L) and (Str[i]<>' ') do  Inc ( i )
        end;
      Inc ( W )
    end;
  GetOneWord:=S
end;

Function UpCase ( C : char ) : char; external;

Function UpperCase ( S : string ) : string; external;

Function LowerCase ( S : string ) : string; external;

Procedure StrToComp ( S : string; var Val : comp ); external;

Function RoundFloat ( V : float ) : float;
begin
  If frac(V)>=0.5 then  RoundFloat:=int(V)+1  else  RoundFloat:=int(V)
end;

Function PadLZero ( S : string; L : byte ) : string;
begin
  If length(S)<L then
    PadLZero:=replicate('0',L-length(S))+S
   else
    PadLZero:=S
end;

Function PadRCh ( S : string; L : byte; C : char ) : string;
begin
  S:=RTrim(S);
  If length(S)<L then
    PadRCh:=S+replicate(C,L-length(S))
   else
    PadRCh:=S
end;

Function PadLCh ( S : string; L : byte; C : char ) : string;
begin
  S:=LTrim(S);
  If length(S)<L then
    PadLCh:=replicate(C,L-length(S))+S
   else
    PadLCh:=S
end;

end.
