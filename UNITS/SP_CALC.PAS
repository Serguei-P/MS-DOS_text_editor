{$I defs.inc}

Unit SP_Calc;

Interface

Uses SP_CRT,SP_Types,SP_Intrf;

Const MaxCalcLine = 23;

Type Calculator = object
                   Private
                    L         : byte;
                    Operation : array[1..MaxCalcLine] of char;
                    Value     : array[1..MaxCalcLine] of float;
                    ValuePtr  : byte;
                    Save      : boolean;
                    Procedure MoveNext;
                   Public
                    X1,Y1  : byte;
                    NAttr,
                    FAttr,
                    HAttr  : byte;
                    Constructor Init ( X0,Y0,High,
                                       NormAttr,FieldAttr,HighAttr : byte;
                                       SaveBox : boolean );
                    Procedure Show;
                    Procedure InsertNumberFromScreen;
                    Procedure InsertNumberToKeyBuffer;
                    Procedure Run;
                  end;

Implementation

Const NumberLength = 15;

Constructor Calculator.Init ( X0,Y0,High,
                              NormAttr,FieldAttr,HighAttr : byte;
                              SaveBox : boolean );
var i : byte;
begin
  X1:=X0;
  Y1:=Y0;
  NAttr:=NormAttr;
  HAttr:=HighAttr;
  FAttr:=FieldAttr;
  L:=High;
  ValuePtr:=1;
  Save:=SaveBox;
  For i:=1 to MaxCalcLine do
    begin
      Value[i]:=0;
      Operation[i]:=' '
    end
end;

Procedure Calculator.Show;
var i : byte;
    S : string;
begin
  FillBoxWith ( X1,Y1,X1+NumberLength+5,Y1+L+1,$20,NAttr );
  DrawBox ( X1,Y1,X1+NumberLength+5,Y1+L+1,NAttr,NormBoxString,Shadow );
  WriteString ( '[ ]',Y1,X1+2,NAttr );
  WriteString ( '■',Y1,X1+3,FAttr );
  WriteString ( ' Калькулятор ',Y1,X1+6,NAttr );
  i:=1;
  While i<ValuePtr do
    begin
      WriteString ( Operation[i],Y1+i,X1+2,FAttr );
      WriteString ( FloatToStr(Value[i],NumberLength),Y1+i,X1+4,FAttr );
      Inc ( i )
    end;
  WriteString ( Operation[ValuePtr],Y1+i,X1+2,FAttr );
  S:=FloatToStr(Value[ValuePtr],NumberLength);
  If AllTrim(S)='0' then  S:=Replicate(' ',NumberLength);
  WriteString ( S,Y1+i,X1+4,HAttr )
end;

Procedure Calculator.MoveNext;
var i : byte;
begin
  If ValuePtr<L then
    Inc ( ValuePtr )
   else
    begin
      For i:=2 to L do
        begin
          Value[i-1]:=Value[i];
          Operation[i-1]:=Operation[i]
        end;
    end;
  Value[ValuePtr]:=0;
  Operation[ValuePtr]:=' '
end;

Procedure Calculator.InsertNumberFromScreen;
var S   : string;
    X,Y : byte;
    Ch  : char;
begin
  If Value[ValuePtr]<>0 then  MoveNext;
  X:=WhereX; Y:=WhereY;
  S:='';
  If (X>=1) and (X<=MaxTextX) and
     (Y>=1) and (Y<=MaxTextY) then
    begin
      While (X<MaxTextX) and (ScreenChar(X,Y) in ['0'..'9','.','e','E']) do  Inc ( X );
      If not ((X>1) and (ScreenChar(X,Y) in ['0'..'9','.','e','E'])) then  Dec ( X );
      Ch:=ScreenChar(X,Y);
      While (X>=1) and (Ch in ['0'..'9','.','e','E']) do
        begin
          S:=Ch+S;
          Dec ( X );
          If X>=1 then  Ch:=ScreenChar(X,Y)
        end
    end;
  Value[ValuePtr]:=StrToFloat(S)
end;

Procedure Calculator.InsertNumberToKeyBuffer;
var S : string;
    i : byte;
begin
  ClearEvent;
  If (WhereX>=1) and (WhereX<=MaxTextX) and
     (WhereY>=1) and (WhereY<=MaxTextY) then
    begin
      S:=LTrim(FloatToStr(Value[ValuePtr],NumberLength));
      For i:=1 to length(S) do  InsertInKeyBuffer ( ord(S[i]),0 )
    end
end;

Procedure InputMyFloat ( var V : float; Y0,X0,L,Attr : byte ); near;
var X : byte;
    S : string;
begin
  S:=AllTrim(FloatToStr(V,L));
  If S='0' then  S:='';
  X:=length(S)+1;
  Repeat
    WriteString ( PadR(S,L),Y0,X0,Attr );
    GoToXY ( X0+length(S),Y0 );
    WaitEvent;
    Case KeyEvent of
         Key_Delete : begin
                        S:='';
                        ClearEvent
                      end;
      Key_Backspace : begin
                        If length(S)>0 then  Dec ( S[0] );
                        ClearEvent
                      end
    end;
    Case char(lo(KeyEvent)) of
             '0'..'9' : begin
                          If length(S)<L then  S:=S+char(lo(KeyEvent));
                          ClearEvent
                        end;
      'E','e','У','у' : begin
                          If length(S)<L then  S:=S+'E';
                          ClearEvent
                        end;
                  '-' : If length(S)=0 then
                          begin
                            S:='-';
                            ClearEvent
                          end;
                  '.' : begin
                          If length(S)<L then  S:=S+'.';
                          ClearEvent
                        end
    end
  until AnyEvent;
  V:=StrToFloat(S)
end;

Procedure Calculator.Run;
var Scr   : BoxContType;
    S     : string;
    X,Y   : byte;
    X0,Y0 : byte;
begin
  Repeat
    If Save then  SaveBoxContents ( Scr,X1,Y1,X1+NumberLength+6,Y1+L+2 );
    SetNoClockZone ( X1,Y1,X1+NumberLength+6,Y1+L+2 );
    Repeat
      Show;
      InputMyFloat ( Value[ValuePtr],Y1+ValuePtr,X1+4,NumberLength,HAttr );
      If (MouseButton=LeftMouseButton) and (MouseX=X1+3) and (MouseY=Y1) then
        begin
          ClearEvent;
          KeyEvent:=Key_Esc
        end;
      If Save and (MouseButton=LeftMouseButton) and
         (MouseX>X1+6) and (MouseX<X1+NumberLength+6) and (MouseY=Y1) then
        begin
          X0:=WhereMouseX;  Y0:=WhereMouseY;
          HideCursor;
          While MouseButtonPressed(LeftMouseButton) do
            begin
              X:=WhereMouseX; Y:=WhereMouseY;
              If (X<>X0) or (Y<>Y0) then
                begin
                  If (X1+X-X0+NumberLength+5<=MaxTextX) and
                     (Y1+Y-Y0+L+1<=MaxTextY) and
                     (X1+X-X0>0) and (Y1+Y-Y0>0) then
                    begin
                      X1:=X1+X-X0;
                      Y1:=Y1+Y-Y0;
                      X0:=WhereMouseX;
                      Y0:=WhereMouseY;
                      RestoreBoxContents ( Scr );
                      SaveBoxContents ( Scr,X1,Y1,X1+NumberLength+6,Y1+L+2 );
                      SetNoClockZone ( X1,Y1,X1+NumberLength+6,Y1+L+2 );
                      Show
                    end
                   else
                    begin
                      SetMouseXY ( X0,Y0 )
                    end
                end
            end;
          ClearEvent
        end;
      If chr(lo(KeyEvent)) in ['+','-','*','/',#13,'='] then
        begin
          If ((ValuePtr>1) and (chr(lo(KeyEvent)) in ['+','-','*','/'])) and
             (((Operation[ValuePtr-1]='=') and (Operation[ValuePtr]=' ')) and
              (Value[ValuePtr]=0)) then
            Operation[ValuePtr]:=chr(lo(KeyEvent))
           else
            MoveNext;
          If Operation[ValuePtr-1] in ['+','-','*','/',#13] then
            begin
              Case Operation[ValuePtr-1] of
                '+' : Value[ValuePtr]:=Value[ValuePtr-2]+Value[ValuePtr-1];
                '-' : Value[ValuePtr]:=Value[ValuePtr-2]-Value[ValuePtr-1];
                '*' : If (Value[ValuePtr-2]<>0) and
                         (Value[ValuePtr-1]<>0) and
                         (ln(abs(Value[ValuePtr-2]))/ln(10)+ln(abs(Value[ValuePtr-1]))/ln(10)<38) then
                        Value[ValuePtr]:=Value[ValuePtr-2]*Value[ValuePtr-1];
                '/' : If Value[ValuePtr-1]<>0 then  Value[ValuePtr]:=Value[ValuePtr-2]/Value[ValuePtr-1]
              end;
              Operation[ValuePtr]:='=';
              If chr(lo(KeyEvent)) in ['+','-','*','/'] then  MoveNext
            end;
          If chr(lo(KeyEvent)) in ['+','-','*','/'] then  Operation[ValuePtr]:=chr(lo(KeyEvent));
          ClearEvent;
          ClearKeyBuffer
        end
    until AnyEvent;
    SetNoClockZone ( 0,0,0,0 );
    If Save then  RestoreBoxContents ( Scr );
    Case KeyEvent of
             Key_Left,
        Key_ShiftLeft : begin
                          If X1>1 then  Dec ( X1 );
                          ClearEvent
                        end;
            Key_Right,
       Key_ShiftRight : begin
                          If X1+NumberLength+5<MaxTextX then  Inc ( X1 );
                          ClearEvent
                        end;
               Key_Up,
          Key_ShiftUp : begin
                          If Y1>1 then  Dec ( Y1 );
                          ClearEvent
                        end;
             Key_Down,
        Key_ShiftDown : begin
                          If Y1+L+1<MaxTextY then  Inc ( Y1 );
                          ClearEvent
                        end
    end;
    ClearKeyBuffer
  until KeyEvent=Key_Esc;
  ClearEvent;
  HideCursor
end;

end.
