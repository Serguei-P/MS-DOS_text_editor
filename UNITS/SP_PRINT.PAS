{$I defs.inc}

Unit SP_Print;

Interface

Uses SP_CRT,SP_Types,SP_DOS,SP_Rsrc,SP_Intrf,SP_Scr;

Const PrPica      = $0001;
      PrElite     = $0002;
      PrCondensed = $0004;
      PrLineSp_8  = $0008;
      PrLineSp_6  = $0010;

Var PrinterError   : word;
    PrinterNumber  : word;
    PrintMargine   : byte;
    StopAfterPage  : boolean;
    IbmPrinterMode : boolean;

Function SetPrinter ( Mode : word ) : boolean;

Function PrinterStatus : byte;

Function PrintLine ( S : string ) : boolean;

Function PrintFile ( FName : string; Mode : word ) : byte;

Function PutLine ( S : string ) : boolean;

Procedure MakeInitalizationString ( PrintInit : string );

Var NoDemoVersion : boolean;

Var InitialPrintString : string[25];

Implementation

Function PrinterStatus : byte; assembler;
Asm
  mov   ax,0200h
  mov   dx,PrinterNumber
  int   17h
  xchg  ah,al
end;

Function PrinterMessage ( Status : byte ) : string;
begin
  If Status and $20 <> 0 then  PrinterMessage:='Вставьте бумагу'
   else
    If Status and $10 <> 0 then  PrinterMessage:='Нажмите на принтере кнопку On-line'
     else
      PrinterMessage:='Проверьте принтер'
end;

Procedure CheckPrinter;
var Status : byte;
    Yes    : boolean;
    T,T1   : longint;
begin
  Status:=PrinterStatus;
  T:=TimerTickCount;
  While (Status<>$90) and
        (abs(TimerTickCount-T)<18) do
    begin
      Status:=PrinterStatus
    end;
  While (Status<>$90) and
        (Status and $10 > 0) and
        (Status and $20 = 0) and
        (Status and $08 = 0) and
        (abs(TimerTickCount-T)<36) do
    begin
      Status:=PrinterStatus
    end;
  While (PrinterError=0) and (Status<>$90) do
    begin
      Yes:=true;
      GetYesNo ( 'Принтер не готов !    Status = '+ByteToHex(Status)+'h',
                 PrinterMessage(Status),
                 'Повторить попытку ?',
                 PrinterMessAttr,ButtonAttr,PrinterHighAttr,Yes );
      If (not Yes) or (KeyEvent=Key_Esc) then  PrinterError:=Status
       else  Status:=PrinterStatus
    end
end;

Function PutLine ( S : string ) : boolean;
var C   : char;
    i   : byte;
    Yes : boolean;
begin
  PutLine:=false;
  CheckPrinter;
  If PrinterError=0 then
    begin
      For i:=1 to length(S) do
        begin
          C:=S[i];
          Asm
            mov   dx,PrinterNumber
            mov   ah,0
@repeat:
            mov   al,C
            int   17h
            test  ah,01h
            jz    @OK
            call  CheckPrinter
            cmp   PrinterError,0
            je    @repeat
@OK:
          end;
          If (C=#12) and StopAfterPage then
            begin
              Yes:=true;
              Repeat
                GetYesNo ( 'Продолжить печать следующей страницы ?','','',
                           AltAttr,ButtonAttr,HighAttr,Yes );
              until KeyEvent=Key_Enter;
              ClearEvent;
              If not Yes then  Exit
            end
        end;
      PutLine:=true
    end
end;

Function SetPrinter ( Mode : word ) : boolean;
type DT = record
            F1 : word;
            F2 : boolean
          end;
var S  : string;
    OK : DT;
begin
  OK.F2:=true;
  S:=InitialPrintString; {#27'@'};
  Asm
    lea    di,@L1
    lea    ax,@L3
    lea    bx,@L2
    sub    ax,bx
    push   cs
    pop    es
    inc    di
    cld
    stosb
    cmp   OK.F2,0FFh
    je    @L2
    lea    ax,@L4
    lea    bx,@L2
    sub    ax,bx
    lea    di,@L2
    dec    di
    cld
    stosb
@L1:
    jmp    @L4
@L2:
    mov   al,OK.F2
    jmp   @L1
@L3:
    push   ss
    mov   al,NoDemoVersion
    lea   dx,OK
    add   dx,2
    xchg  di,dx
    pop   es
    stosb
@L4:
  end;
  If Mode and PrLineSp_8 > 0 then S:=S+#27'0';
  If Mode and PrLineSp_6 > 0 then  S:=S+#27'2';
  If not IbmPrinterMode then
    begin
      If Mode and PrPica > 0 then  S:=S+#18#27'P';
      If Mode and PrElite > 0 then  S:=S+#18#27'M'
    end
   else
    begin
      If Mode and PrPica > 0 then  S:=S+#18;
      If Mode and PrElite > 0 then  S:=S+#27#58
    end;
  If Mode and PrCondensed > 0 then  S:=S+#15;
  PrinterError:=0;
  If PutLine(S) then  SetPrinter:=true  else  SetPrinter:=false;
  If (not OK.F2) and (PrinterError=0) then
    begin
      ShowMessage ( 'Демо-версия. Функция печати отключена.',PrinterMessAttr,PrinterHighAttr );
      PrinterError:=100;
      SetPrinter:=false
    end
end;

Function PrintLine ( S : string ) : boolean;
var i : byte;
begin
  For i:=1 to PrintMargine do S:=' '+S;
  PrintLine:=PutLine(S+#13#10)
end;

Function PrintFile ( FName : string; Mode : word ) : byte;
var F  : text;
    S  : string;
    PE : boolean;
begin
  SetPrinter ( Mode );
  Assign ( F,FName );
  Reset ( F );
  If IOResult<>0 then
    begin
      PrintFile:=$10;
      Exit
    end;
  While not EoF(F) do
    begin
      ReadLn ( F,S );
      If IOResult<>0 then
        begin
          PrintFile:=$10;
          Exit
        end;
      If S[length(S)]=#12 then
        begin
          PE:=true;
          Dec ( S[0] )
        end
       else
        PE:=false;
      If (S<>'') or (not PE) then
        If not PrintLine(S) then
          begin
            PrintFile:=1;
            Exit
          end;
      If PE then
        begin
          If not PutLine(#12) then
            begin
              PrintFile:=1;
              Exit
            end
        end
    end;
  Close ( F );
  PrintFile:=0
end;

Procedure MakeInitalizationString ( PrintInit : string );
var i  : word;
    S  : string;
    S0 : string;
begin
  i:=1;
  S0:='';
  While i<=length(PrintInit) do
    begin
      While (i<=length(PrintInit)) and (PrintInit[i]=' ') do  Inc ( i );
      S:='';
      If (i<=length(PrintInit)) and (PrintInit[i]='''') then
        begin
          Inc ( i );
          While (i<=length(PrintInit)) and (PrintInit[i]<>'''') do
            begin
              S:=S+PrintInit[i];
              Inc ( i )
            end;
          Inc ( i );
          S0:=S0+S
        end
       else If (i<=length(PrintInit)) then
        begin
          While (i<=length(PrintInit)) and (PrintInit[i]<>',') do
            begin
              S:=S+PrintInit[i];
              Inc ( i )
            end;
          Inc ( i );
          S0:=S0+chr(StrToLint(S))
        end
    end;
  InitialPrintString:=S0
end;

begin
  PrinterError:=0;
  PrinterNumber:=0;
  PrinterMessAttr:=$07;
  PrinterHighAttr:=$70;
  PrintMargine:=0;
  StopAfterPage:=false;
  NoDemoVersion:=true;
  IbmPrinterMode:=false;
  InitialPrintString:=''
end.
