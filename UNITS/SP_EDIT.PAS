{$I defs.inc}
{$I-,V-}

Unit SP_EDIT;

Interface

Uses SP_Types,SP_CRT,SP_DOS,SP_Rsrc,SP_Intrf,SP_Scr,SP_Print;

{$I DEFINE.INC}

Const MaxTextBufferSize = $FFF0;

Type TextBufferType = array[0..MaxTextBufferSize] of byte;

Const MaxScrLine = 50;

Type TextBufferWorkArray = array[1..MaxScrLine] of word;

Type TextBufferObject = object
                         Private
                          Border       : boolean;
                          Restore      : boolean;
                          Shadow       : boolean;
                          DoEditConst  : boolean;
                          Status       : boolean;
                          MaxLine      : byte;
                          Up           : boolean;
                          ScrUpLineN   : word;
                          Procedure CalculateLineNumber;
                          Procedure InitVariables;
                         Public
                          X1,Y1,X2,Y2  : byte;
                          LeftX        : word;
                          BufferSize   : word;
                          LinePos      : TextBufferWorkArray;
                          LineLength   : TextBufferWorkArray;
                          NAttr        : byte;
                          MAttr        : byte;
                          CharCount    : word;
                          Changed      : boolean;
                          DiskError    : byte;
                          Buffer       : ^TextBufferType;
                          MarkBegin    : word;
                          MarkEnd      : word;
                          ShowMark     : boolean;
                          CurrLine     : byte;
                          CurrCol      : byte;
                          BuffPos      : word;
                          DoEdit       : boolean;
                          Constructor Init ( BuffSize      : word;
                                             X0,Y0,Xl,Yl   : byte;
                                             NormAttr      : byte;
                                             MarkAttr      : byte;
                                             LetEdit       : boolean;
                                             DrawBorder    : boolean;
                                             RestoreScreen : boolean;
                                             WithShadow    : boolean;
                                             ShowStatus    : boolean );
                          Destructor Done;
                          Procedure ShowLine ( Y : byte; Pos : word );
                          Procedure CalculateScreen ( Pos : word );
                          Procedure ShowScreen ( Pos : word );
                          Procedure Edit;
                          Function  LeftUpMessage : string; virtual;
                          Procedure ShowLeftUpMessage;
                          Function  LeftDownMessage : string; virtual;
                          Function  RightUpMessage : string; virtual;
                          Function  RightDownMessage : string; virtual;
                          Function  Translate ( Key : word ) : word; virtual;
                          Function  ReadFile ( FileName : string ) : boolean;
                          Function  WriteFile ( FileName : string ) : boolean;
                          Function  BufferAddr : pointer;
                          Procedure Print;
                          Procedure GoToPosition ( Pos : word );
                          Function  FindString ( S : string; Pos : word ) : boolean;
                          Function  CursorPosition : word;
                          Procedure InsertChar ( C : byte; Pos : word );
                          Procedure InsertBlock ( P0 : pointer; N : word; Pos : word );
                          Procedure DeleteChar ( Pos : word );
                          Procedure DeleteBlock ( Pos : word; N : word );
                          Procedure GoToMarked;
                          Procedure IndentBlock ( BlBeg,BlEnd : word );
                          Procedure UnindentBlock ( BlBeg,BlEnd : word );
                          Procedure ReformatParagraph ( BeginPos : word );
                          Procedure ReformatBlock;
                          Procedure BlockToParagraph;
                          Function  BeginOfParagraph ( Pos : word ) : word;
                          Procedure ReformatString ( var BeginPos : word;
                                                     var EndPos   : word;
                                                         LeftPos  : byte );
                          Function  EndOfParagraph ( Pos : word ) : word;
                          Function  WordOnCursor : string;
                          Procedure CenterString ( Pos : word );
                        end;

Type ExtendedTextObject = object(TextBufferObject)
                            Found        : boolean;
                            StrToLookFor : string[32];
                            DAttr        : byte;
                            HAttr        : byte;
                            WAttr        : byte;
                            ErrAttr      : byte;
                            Russ         : boolean;
                            Constructor Init ( X0,Y0,Xl,Yl : byte;
                                               NormAttr    : byte;
                                               MarkAttr    : byte;
                                               DialogAttr  : byte;
                                               HighAttr    : byte;
                                               WaitAttr    : byte;
                                               ErrorAttr   : byte;
                                               LetEdit     : boolean;
                                               Russian     : boolean );
                           {$IFDEF Russian}
                            Function  LeftUpMessage : string; virtual;
                           {$ENDIF}
                            Function  LeftDownMessage : string; virtual;
                            Function  RightUpMessage : string; virtual;
                            Function  Translate ( Key : word ) : word; virtual;
                            Procedure GetSearchString;
                            Procedure PutWaitMessage;
                            Procedure RemoveWaitMessage;
                            Procedure InputString ( var S0 : string; Y,X,L,Attr : byte );
                            Procedure MarkBlockBegin;
                            Procedure MarkBlockEnd;
                            Procedure HideBlockMark;
                            Procedure DeleteMarkedBlock;
                            Procedure CopyMarkedBlockToCursor;
                            Procedure MoveMarkedblockToCursor;
                            Procedure IntendMarkedBlock;
                            Procedure UnintendMarkedBlock;
                            Procedure ReformatMarkedBlock;
                            Procedure MakeParagraphOfBlock;
                            Procedure LookForAString;
                            Procedure ContinueStringSearch;
                            Procedure SwitchAlphabet;
                            Procedure ReformatParagraphAtCursor;
                            Procedure Edit;
                          end;

Type FileEditObject = object(ExtendedTextObject)
                        FName    : string[64];
                        PathName : string[64];
                        FileSave : FileSaveDialog;
                        FileRead : FileReadDialog;
                        Constructor Init ( FileName    : string;
                                           X0,Y0,Xl,Yl : byte;
                                           NormAttr    : byte;
                                           MarkAttr    : byte;
                                           DialogAttr  : byte;
                                           HighAttr    : byte;
                                           WaitAttr    : byte;
                                           ErrorAttr   : byte;
                                           Russian     : boolean );
                        Function  LeftUpMessage : string; virtual;
                        Procedure ReadDiskFile;
                        Function  WriteDiskFile : boolean;
                        Function  SaveTheFile : boolean;
                        Function  SaveFile : boolean; virtual;
                        Procedure ReadNewFile; virtual;
                        Function  MakeExit : boolean;
                        Procedure Edit;
                      end;

Procedure SetFormatParameters ( LeftMargin  : byte;
                                RightMargin : byte;
                                Paragraph   : byte;
                                AutoFormat  : boolean;
                                Justify     : boolean;
                                Perenos     : boolean );

Var TextOptions : record
                    LeftTextPos    : integer;
                    ParagraphPos   : integer;
                    RightTextPos   : integer;
                    DoFormat       : boolean;
                    DoJustify      : boolean;
                    DoPerenos      : boolean;
                    CreateBAKFiles : boolean
                  end;

Var PrinterMode : word;

Implementation

Var Mark : boolean;

Var CurrentCursorPosition : word;

Constructor TextBufferObject.Init ( BuffSize      : word;
                                    X0,Y0,Xl,Yl   : byte;
                                    NormAttr      : byte;
                                    MarkAttr      : byte;
                                    LetEdit       : boolean;
                                    DrawBorder    : boolean;
                                    RestoreScreen : boolean;
                                    WithShadow    : boolean;
                                    ShowStatus    : boolean );
var L : longint;
begin
  If BuffSize>MaxTextBufferSize then  BuffSize:=MaxTextBufferSize;
  L:=BuffSize;
  If MaxAvail<L+4000 then  Fail;
  GetMem ( Buffer,BuffSize );
  If Buffer=nil then  Fail;
  DiskError:=0;
  BufferSize:=BuffSize;
  Border:=DrawBorder;
  Restore:=RestoreScreen;
  Shadow:=WithShadow;
  NAttr:=NormAttr;
  MAttr:=MarkAttr;
  DoEdit:=LetEdit;
  DoEditConst:=LetEdit;
  Status:=ShowStatus;
  If DrawBorder then
    begin
      X1:=X0+1;
      Y1:=Y0+1;
      X2:=X0+Xl-2;
      Y2:=Y0+Yl-2
    end
   else
    begin
      X1:=X0;
      Y1:=Y0;
      X2:=X0+Xl-1;
      Y2:=Y0+Yl-1
    end;
  CharCount:=0;
  InitVariables
end;

Destructor TextBufferObject.Done;
begin
  FreeMem ( Buffer,BufferSize )
end;

Procedure TextBufferObject.InitVariables;
begin
  LeftX:=0;
  MarkBegin:=0;
  MarkEnd:=0;
  ShowMark:=false;
  Changed:=false;
  CurrCol:=X1;
  CurrLine:=Y1;
  BuffPos:=0
end;

Function TextBufferObject.ReadFile ( FileName : string ) : boolean;
var F : file;
begin
  Assign ( F,FileName );
  Reset ( F,1 );
  ReadFile:=false;
  If IOResult<>0 then
    begin
      ReadFile:=false;
      DiskError:=1;
      Exit
    end;
  InitVariables;
  BlockRead ( F,Buffer^,SizeOf(Buffer^),CharCount );
  If IOResult<>0 then
    begin
      ReadFile:=false;
      DiskError:=2;
      Close ( F );
      Exit
    end;
  If not EoF(F) then
    begin
      DiskError:=3;
      CharCount:=MaxTextBufferSize;
      Close ( F );
      Exit
    end;
  Close ( F );
  ReadFile:=true
end;

Function TextBufferObject.WriteFile ( FileName : string ) : boolean;
var F   : file;
    Res : word;
    S   : string;
begin
  DiskError:=0;
  If TextOptions.CreateBAKFiles and (UpperCase(FileNameExtention(FileName))<>'BAK') then
    begin
      If FileExists(FileName) then
        begin
          S:=NameWithoutExtention(FileName)+'.BAK';
          Assign ( F,S );
          If FileExists(S) then  Erase ( F );
          Assign ( F,FileName );
          Rename ( F,S );
          If IOResult<>0 then
            begin
              DiskError:=5;
              WriteFile:=false
            end
        end
    end;
  Assign ( F,FileName );
  Rewrite ( F,1 );
  If IOResult<>0 then
    begin
      DiskError:=1;
      WriteFile:=false;
      Exit
    end;
  BlockWrite ( F,Buffer^,CharCount,Res );
  If (Res<>CharCount) or (IOResult<>0) then
    begin
      WriteFile:=false;
      DiskError:=1
    end
   else
    begin
      WriteFile:=true;
      Changed:=false
    end;
  Close ( F )
end;

Procedure TextBufferObject.InsertChar ( C : byte; Pos : word );
var i : byte;
    P : pointer;
    L : word;
begin
  P:=Buffer;
  L:=CharCount;
  If L>=BufferSize then  Exit;
  Changed:=true;
  Asm
    push   ds
    mov    cx,L
    dec    cx
    les    di,P
    lds    si,P
    add    si,cx
    add    di,cx
    inc    di
    sub    cx,Pos
    inc    cx
    std
    repe   movsb
    mov    al,C
    stosb
    pop    ds
  end;
  Inc ( CharCount );
  For i:=Y1 to Y2+1 do  If LinePos[i]>Pos then  Inc ( LinePos[i] );
  Inc ( LineLength[CurrLine] );
  If MarkBegin>Pos then  Inc ( MarkBegin );
  If MarkEnd>Pos then  Inc ( MarkEnd );
end;

Procedure TextBufferObject.InsertBlock ( P0 : pointer; N : word; Pos : word );
label L1;
var i : byte;
    P : pointer;
    L : word;
    M : word;
begin
  P:=Buffer;
  L:=CharCount;
  M:=BufferSize;
  Asm
    mov    ax,L
    add    ax,N
    jnc    L1
    cmp    ax,M
    jb     L1
  end;
  Exit;
L1:
  Changed:=true;
  Asm
    push   ds
    mov    cx,L
    dec    cx
    les    di,P
    lds    si,P
    add    si,cx
    add    di,cx
    add    di,N
    sub    cx,Pos
    inc    cx
    std
    repe   movsb
    les    di,P
    add    di,Pos
    cld
    lds    si,P0
    mov    cx,N
    repe   movsb
    pop    ds
  end;
  CharCount:=CharCount+N;
  MarkBegin:=Pos;
  MarkEnd:=Pos+N;
  ShowMark:=true
end;

Procedure TextBufferObject.DeleteChar ( Pos : word );
var i : byte;
    P : pointer;
    L : word;
begin
  P:=Buffer;
  Changed:=true;
  L:=CharCount;
  Asm
    push   ds
    mov    cx,L
    dec    cx
    les    di,P
    lds    si,P
    add    di,Pos
    add    si,Pos
    inc    si
    sub    cx,Pos
    cld
    repe   movsb
    pop    ds
  end;
  Dec ( CharCount );
  For i:=Y1 to Y2+1 do  If i>CurrLine then  Dec ( LinePos[i] );
  Dec ( LineLength[CurrLine] );
  If MarkBegin>Pos then  Dec ( MarkBegin );
  If MarkEnd>Pos then  Dec ( MarkEnd );
end;

Procedure TextBufferObject.DeleteBlock ( Pos : word; N : word );
var i : byte;
    P : pointer;
    L : word;
begin
  P:=Buffer;
  Changed:=true;
  L:=CharCount;
  Asm
    push   ds
    lea    cx,P
    add    cx,L
    dec    cx
    les    di,P
    lds    si,P
    add    di,Pos
    add    si,Pos
    add    si,N
    sub    cx,si
    inc    cx
    cld
    repe   movsb
    pop    ds
  end;
  If MarkBegin>Pos+N-1 then
    MarkBegin:=MarkBegin-N
   else
    If MarkBegin>Pos then  MarkBegin:=Pos;
  If MarkEnd>Pos+N-1 then
    MarkEnd:=MarkEnd-N
   else
    If MarkEnd>Pos then  MarkEnd:=Pos;
  CharCount:=CharCount-N;
end;

Procedure TextBufferObject.IndentBlock ( BlBeg,BlEnd : word );
var Pos : word;
begin
  Pos:=BlBeg;
  While (Pos<BlEnd) and (CharCount<BufferSize) do
    begin
      InsertChar($20,Pos);
      Inc ( Pos );
      Inc ( BlEnd );
      While (Pos<BlEnd) and (Buffer^[Pos]<>$0D) do  Inc ( Pos );
      Inc ( Pos );
      If (Buffer^[Pos]=$0A) then  Inc ( Pos )
    end
end;

Procedure TextBufferObject.UnindentBlock ( BlBeg,BlEnd : word );
var Pos : word;
begin
  Pos:=BlBeg;
  While (Pos<BlEnd) and (CharCount<BufferSize) do
    begin
      If Buffer^[Pos]=$20 then
        begin
          DeleteChar(Pos);
          Dec ( BlEnd )
        end;
      While (Pos<BlEnd) and (Buffer^[Pos]<>$0D) do  Inc ( Pos );
      Inc ( Pos );
      If (Buffer^[Pos]=$0A) then  Inc ( Pos )
    end
end;

Procedure TextBufferObject.CalculateScreen ( Pos : word );
var i     : byte;
    P     : pointer;
    Count : word;
begin
  MaxLine:=Y2;
  Count:=CharCount;
  For i:=Y1 to Y2 do
    begin
      LinePos[i]:=Pos;
      If ((i>Y1) and (LinePos[i]=LinePos[i-1])) and (MaxLine=Y2) then  MaxLine:=i-1;
      If Count>0 then
        begin
{            While (Pos<=CharCount-1) and (Buffer^[Pos]<>$0D) do  Inc ( Pos );}
          P:=Buffer;
          Asm
            push   ds
            mov    cx,Pos
            mov    bx,Count
            dec    bx
            lds    si,P
            add    si,cx
            cld
@L1:
            cmp    cx,bx
            ja     @L2
            lodsb
            cmp    al,0Dh
            je     @L2
            inc    cx
            jmp    @L1
@L2:
            mov    Pos,cx
            pop   ds
          end;
          LineLength[i]:=Pos-LinePos[i];
          If Pos<=Count-1 then  Inc ( Pos );
          If (Buffer^[Pos]=$0A) and (Pos<=Count-1) then  Inc ( Pos )
        end
       else  LineLength[i]:=0
    end;
  If Mark then
    If not Up then  MarkEnd:=CursorPosition  else  MarkBegin:=CursorPosition;
  LinePos[Y2+1]:=Pos
end;

Procedure TextBufferObject.CalculateLineNumber;
var P : word;
    B : pointer;
begin
  If Status and (not AnyKeyInBuffer) then
    begin
      P:=LinePos[Y1];
      If P>0 then
        begin
          B:=Buffer;
          Asm
            mov    cx,P
            mov    dx,0
            les    di,B
            mov    al,0Dh
            cld
    @L:
            repne  scasb
            inc    dx
            cmp    cx,1
            jnb    @L
            mov    P,dx
          end;
          ScrUpLineN:=P
        end
       else  ScrUpLineN:=1
    end
end;

Procedure TextBufferObject.ShowScreen ( Pos : word );
var i : byte;
begin
  CalculateScreen ( Pos );
  CalculateLineNumber;
  For i:=Y1 to Y2 do  ShowLine ( i,LinePos[i] );
end;

Procedure TextBufferObject.ShowLine ( Y : byte; Pos : word );
var S        : string;
    L        : byte absolute S;
    i        : word;
    X        : byte;
    P        : pointer;
    Count    : word;
    NormAttr : byte;
    MarkAttr : byte;
    MB       : word;
    ME       : word;
    SM       : boolean;
begin
  Count:=CharCount;
  L:=X2-X1+1;
  X:=X1;
  i:=0;
  MB:=MarkBegin+Ofs(Buffer^);
  ME:=MarkEnd+Ofs(Buffer^);
  SM:=ShowMark;
  NormAttr:=NAttr;
  MarkAttr:=MAttr;
  If Count>0 then
    While ((i<LeftX) and (Buffer^[Pos]<>$0D)) and (Pos<Count-1) do
      begin
        Inc ( Pos );
        Inc ( i )
      end;
  P:=Buffer;
  Asm
    xor    ax,ax
    mov    al,Y
    dec    al
    mov    bl,80
    mul    bl
    add    al,X
    adc    ah,0
    dec    ax
    shl    ax,1
    mov    di,ax
    mov    ax,VRAMBase
    push   ax
    pop    es          { es:ax points to Video RAM }
    push   ds
    lds    si,P
    add    si,Pos      { ds:si points to line begin }
    mov    cx,1
    mov    dx,Pos
    mov    bx,Count
    mov    ah,NormAttr
    cmp    bx,0
    je     @L2
    dec    bx
    cld
@L0:
    cmp    SM,0
    je     @L1
    cmp    si,MB
    jb     @L1
    cmp    si,ME
    jnb    @L1
    mov    ah,MarkAttr
    jmp    @L11
@L1:
    mov    ah,NormAttr
@L11:
    lodsb
    cmp    al,0Dh
    je     @L2
    cmp    cl,L
    ja     @L3
    cmp    dx,bx
    ja     @L2
    stosw
    inc    cx
    inc    dx
    jmp    @L0

@L2:
    mov    al,0020h
@L22:
    cmp    cl,L
    ja     @L3
    stosw
    inc    cx
    jmp    @L22
@L3:
    pop    ds
  end;
 { WriteString ( S,Y,X1,NAttr )}
end;


Procedure TextBufferObject.Edit;

  procedure MoveUp;
  begin
    If BuffPos>0 then  Dec ( BuffPos );
    While (BuffPos>0) and (Buffer^[BuffPos]<>$0D) do  Dec ( BuffPos );
    If (BuffPos>0) then
      begin
        Dec ( BuffPos );
        While (BuffPos>0) and (Buffer^[BuffPos]<>$0D) do  Dec ( BuffPos );
        If Buffer^[BuffPos]=$0D then  Inc ( BuffPos );
        If Buffer^[BuffPos]=$0A then  Inc ( BuffPos )
      end
  end;

  procedure MoveDown;
  begin
    If (Y2=MaxLine) and (CharCount>LinePos[Y2+1]) then  BuffPos:=LinePos[Y1+1]
  end;

  procedure EditBuffer;
  var i  : word;
      S  : string;
      Sh : boolean;
      L  : word;
      N  : longint;
      X  : word;
      Y  : word;
      MB : word;
      ME : word;
  begin
    Up:=false;
    Mark:=false;
    Sh:=false;
    Repeat
      If Mark then
        If not Up then  MarkEnd:=CursorPosition  else  MarkBegin:=CursorPosition;
      ShowScreen ( BuffPos );
    {  Sh:=false;}
      Repeat
        If Mark then
          If not Up then  MarkEnd:=CursorPosition  else  MarkBegin:=CursorPosition;
        If Sh then
          begin
            L:=TextOptions.ParagraphPos;
            TextOptions.ParagraphPos:=1;
            i:=0;
            While (i<LineLength[CurrLine]) and (Buffer^[LinePos[CurrLine]+TextOptions.ParagraphPos-1]=$20) do
              Inc ( TextOptions.ParagraphPos );
            CurrentCursorPosition:=CursorPosition;
            ReformatParagraph ( LinePos[CurrLine] );
            TextOptions.ParagraphPos:=L;
            Repeat
              CalculateScreen ( BuffPos );
              i:=Y1;
              While (LinePos[i+1]<CurrentCursorPosition) and (i<=Y2) do  Inc ( i );
              If i>Y2 then  BuffPos:=LinePos[Y1+1]
            until  i<=Y2;
            CurrLine:=i;
            LeftX:=CurrentCursorPosition-LinePos[i];
            CurrCol:=X1;
            While  (LeftX>0) and (CurrCol<X2) do
              begin
                Dec ( LeftX );
                Inc ( CurrCol )
              end;
            ShowScreen ( BuffPos );
            Sh:=false
          end;
        ShowLine ( CurrLine,LinePos[CurrLine] );
        Repeat
          If CurrLine>MaxLine then  CurrLine:=MaxLine-1;
          If CurrLine<Y1 then  CurrLine:=Y1;
          If DoEdit then  GoToXY ( CurrCol,CurrLine );
          If Status then
            begin
              WriteString ( LeftDownMessage,Y2+1,X1,NAttr );
              S:=LIntToStr(BufferSize-CharCount);
              i:=length(S);
              S[0]:=#5;
              If Border then
                While i<5 do
                  begin
                    Inc ( i );
                    S[i]:='═'
                  end
                 else
                While i<5 do
                  begin
                    Inc ( i );
                    S[i]:=' '
                  end;
              WriteString ( S,Y1-1,X2-5,NAttr )
            end;
          If Mark then
            If not Up then  MarkEnd:=CursorPosition  else  MarkBegin:=CursorPosition;
          CalculateLineNumber;
          SetVerticalScrollBar ( X2+1,Y1,Y2-Y1+1,NAttr,(NAttr shr 4) or lo(NAttr shl 4) );
          SetHorizontalScrollBar ( X1+12,Y2+1,X2-X1-12,NAttr,(NAttr shr 4) or lo(NAttr shl 4) );
          N:=LinePos[CurrLine]+LeftX+CurrCol;
          If CharCount>0 then  N:=N*100 div CharCount  else  N:=0;
          ShowVerticalScrollBar ( N );
          ShowHorizontalScrollBar ( LeftX div 2 );
          WaitEvent;
          If TextOptions.DoFormat and
             ((KeyEvent>$0020) and (KeyEvent<=$00FF)) then
            begin
              i:=LinePos[CurrLine];
              While (i<CharCount) and (Buffer^[i]<>$0D) do  Inc ( i );
              If i-LinePos[CurrLine]>=TextOptions.RightTextPos then
                begin
                  Sh:=true
                end
            end;
          KeyEvent:=Translate(KeyEvent);
          If DoEdit then
            Case KeyEvent of
              Key_ShiftRight,
              Key_ShiftDown,
              Key_ShiftPgDn,
              Key_ShiftEnd  : begin
                                If not Mark then
                                  begin
                                    Mark:=true;
                                    ShowMark:=true;
                                    Up:=false;
                                    MarkBegin:=CursorPosition
                                  end;
                                If CursorPosition>=MarkEnd then
                                  begin
                                    MarkEnd:=CursorPosition;
                                    Up:=false
                                  end
                                 else  MarkBegin:=CursorPosition
                              end;
              Key_ShiftLeft,
              Key_ShiftUp,
              Key_ShiftPgUp,
              Key_ShiftHome : begin
                                If not Mark then
                                  begin
                                    Mark:=true;
                                    ShowMark:=true;
                                    Up:=true;
                                    MarkEnd:=CursorPosition;
                                    MarkBegin:=CursorPosition
                                  end;
                                If CursorPosition<=MarkBegin then
                                  begin
                                    MarkBegin:=CursorPosition;
                                    Up:=true
                                  end
                                 else
                                  MarkEnd:=CursorPosition
                              end;
             else  Mark:=false
            end;
            Case KeyEvent of
               Key_Left : If (CurrCol>X1) and DoEdit then
                             begin
                               Dec ( CurrCol );
                               ClearEvent
                             end;
               Key_Right : If (CurrCol<X2) and DoEdit then
                             begin
                               Inc ( CurrCol );
                               ClearEvent
                             end;
                  Key_Up : If (CurrLine>Y1) and DoEdit then
                             begin
                               Dec ( CurrLine );
                               ClearEvent
                             end;
                Key_Down : If (CurrLine<MaxLine) and DoEdit then
                             begin
                               If LinePos[CurrLine+1]<>LinePos[CurrLine+2] then  Inc ( CurrLine );
                               ClearEvent
                             end
            end
        until AnyEvent;
        If DoEdit then
          Case KeyEvent of
                    $000C,
             $0020..$00FF : If CurrCol<X2 then
                              begin
                                i:=LeftX+CurrCol-X1;
                                While (i>LineLength[CurrLine]) and (CharCount<BufferSize) do
                                  begin
                                    InsertChar ( $20,LinePos[CurrLine]+LineLength[CurrLine] )
                                  end;
                                If CharCount<BufferSize then InsertChar ( lo(KeyEvent),LinePos[CurrLine]+LeftX+CurrCol-X1 );
                                Inc ( CurrCol );
                                ClearEvent
                              end;
               Key_Delete : If (LineLength[CurrLine]>0) and (LeftX+CurrCol-X1+1<=LineLength[CurrLine]) then
                              begin
                                DeleteChar ( LinePos[CurrLine]+LeftX+CurrCol-X1 );
                                ClearEvent
                               end;
            Key_Backspace : If CurrCol>X1 then
                              begin
                                If LeftX+CurrCol-X1<LineLength[CurrLine]+1 then
                                  DeleteChar ( LinePos[CurrLine]+LeftX+CurrCol-X1-1 );
                                Dec ( CurrCol );
                                ClearEvent
                              end;
          end
      until AnyEvent;
      Case KeyEvent of
          Key_ShiftLeft : If CurrCol>X1 then
                            begin
                              Dec ( CurrCol );
                              ClearEvent
                            end;
         Key_ShiftRight : If CurrCol<X2 then
                            begin
                              Inc ( CurrCol );
                              ClearEvent
                            end;
            Key_ShiftUp : If CurrLine>Y1 then
                           begin
                             Dec ( CurrLine );
                             ClearEvent
                           end;
         Key_ShiftDown : If CurrLine<MaxLine then
                           begin
                             If LinePos[CurrLine+1]<>LinePos[CurrLine+2] then  Inc ( CurrLine );
                             ClearEvent
                           end;
      end;
      Case KeyEvent of
              Key_Left,
         Key_ShiftLeft : begin
                           If LeftX>0 then  Dec ( LeftX );
                           ClearEvent
                         end;
             Key_Right,
        Key_ShiftRight : begin
                           Inc ( LeftX );
                           ClearEvent
                         end;
                Key_Up,
           Key_ShiftUp : begin
                           MoveUp;
                           ClearEvent
                         end;
              Key_Down,
         Key_ShiftDown : begin
                           MoveDown;
                           ClearEvent
                         end;
              Key_PgUp,
         Key_ShiftPgUp : begin
                           CurrLine:=Y1;
                           For i:=Y1 to Y2 do  MoveUp;
                           ClearEvent
                         end;
              Key_PgDn,
         Key_ShiftPgDn : begin
                           If CharCount>LinePos[Y2+1] then  BuffPos:=LinePos[Y2+1];
                           CurrLine:=Y2;
                           ClearEvent
                         end;
          Key_CtrlPgUp : begin
                           CurrLine:=Y1;
                           BuffPos:=0;
                           ClearEvent
                         end;
          Key_CtrlPgDn : begin
                           CurrLine:=Y2-1;
                           If CharCount>0 then  BuffPos:=CharCount-1;
                           For i:=Y1 to Y2-2 do  MoveUp;
                           ClearEvent
                         end;
              Key_Home,
         Key_ShiftHome : begin
                           LeftX:=0;
                           CurrCol:=X1;
                           ClearEvent
                         end;
               Key_End,
          Key_ShiftEnd : begin
                           i:=LinePos[CurrLine];
                           While (i<CharCount) and (Buffer^[i]<>$0D) do  Inc ( i );
                           LeftX:=i-LinePos[CurrLine];
                           CurrCol:=X1;
                           While (CurrCol<X2) and (LeftX>0) do
                             begin
                               Inc ( CurrCol );
                               Dec ( LeftX )
                             end;
                           ClearEvent
                         end;
                 $000C,
          $0020..$00FF : begin
                           If DoEdit then
                             begin
                               i:=LeftX+CurrCol-X1;
                               While (i>LineLength[CurrLine]) and (CharCount<BufferSize) do
                                 begin
                                   InsertChar ( $20,LinePos[CurrLine]+LineLength[CurrLine] )
                                 end;
                               If CharCount<BufferSize then  InsertChar ( lo(KeyEvent),LinePos[CurrLine]+LeftX+CurrCol-X1 );
                               Inc ( LeftX )
                             end;
                           ClearEvent
                         end;
             Key_Enter : begin
                           If (CharCount<BufferSize-1) and DoEdit then
                             begin
                               i:=LeftX+CurrCol-X1;
                               While i>LineLength[CurrLine] do
                                 begin
                                   If CurrCol>X1 then  Dec ( CurrCol )  else  Dec ( LeftX );
                                   i:=LeftX+CurrCol-X1;
                                 end;
                               InsertChar ( $0A,LinePos[CurrLine]+LeftX+CurrCol-X1 );
                               InsertChar ( $0D,LinePos[CurrLine]+LeftX+CurrCol-X1 );
                               i:=LinePos[CurrLine]+LeftX+CurrCol-X1+2;
                               If CurrLine<Y2 then  Inc ( CurrLine )  else  BuffPos:=LinePos[Y1+1];
                               LeftX:=0;
                               CurrCol:=X1;
                               While LeftX+CurrCol-X1+1<TextOptions.ParagraphPos do
                                 begin
                                   If CurrCol<X2 then  Inc ( CurrCol )  else  Inc ( LeftX );
                                   InsertChar ( $20,i )
                                 end
                             end;
                             ClearEvent
                           end;
              Key_Delete :begin
                              If ((LinePos[CurrLine]+1<CharCount) and
                                 (Buffer^[LinePos[CurrLine]+LineLength[CurrLine]]=$0D)) and
                                 DoEdit then
                                begin
                                  DeleteChar ( LinePos[CurrLine]+LineLength[CurrLine] );
                                  If Buffer^[LinePos[CurrLine]+LineLength[CurrLine]+1]=$0A  then
                                      DeleteChar ( LinePos[CurrLine]+LineLength[CurrLine]+1 )
                                end;
                              ClearEvent
                            end;
           Key_Backspace :  begin
                              If (LeftX+CurrCol>X1) and DoEdit then
                                begin
                                  If LeftX+CurrCol-X1<LineLength[CurrLine]+1 then
                                    DeleteChar ( LinePos[CurrLine]+LeftX+CurrCol-X1-1 );
                                  If CurrCol>X1 then  Dec ( CurrCol )  else  Dec ( LeftX )
                                end;
                              ClearEvent
                            end;
                Key_CtrlY : begin
                              If DoEdit then
                                begin
                                  i:=LineLength[CurrLine];
                                  If LinePos[CurrLine]+i<CharCount then  Inc ( i );
                                  If (LinePos[CurrLine]+i<CharCount) and (Buffer^[LinePos[CurrLine]+i]=$0A) then  Inc ( i );
                                  If LinePos[CurrLine]+i=CharCount then  MoveUp;
                                  DeleteBlock ( LinePos[CurrLine],i )
                                end;
                              ClearEvent
                            end;
               cmMoveLeft : begin
                              If LeftX>0 then  Dec ( LeftX );
                              ClearEvent
                            end;
              cmMoveRight : begin
                              Inc ( LeftX );
                              ClearEvent
                            end;
               cmMoveDown : begin
                              MoveDown;
                              ClearEvent
                            end;
                 cmMoveUp : begin
                              MoveUp;
                              ClearEvent
                            end
      end;
      If MouseButton=LeftMouseButton then
        begin
          If (MouseY>=Y1) and (MouseY<=MaxLine) and
             (LinePos[MouseY]<CharCount) and
             (MouseX>=X1) and (MouseX<=X2) then
               begin
                 CurrCol:=MouseX;
                 CurrLine:=MouseY;
                 X:=MouseX;
                 Y:=MouseY;
                 While MouseButtonPressed(LeftMouseButton) do
                   begin
                     If (MouseX<>X) or (MouseY<>Y) then
                       begin
                         Mark:=true;
                         ShowMark:=true;
                         Up:=false;
                         If LineLength[Y]>=X+LeftX-1 then
                           MB:=LinePos[Y]+X+LeftX-2
                          else
                           MB:=LinePos[Y]+LineLength[Y]
                       end;
                     If Mark then
                       begin
                         CurrCol:=MouseX;
                         If CurrCol>X2 then  CurrCol:=X2;
                         CurrLine:=MouseY;
                         While (CurrLine>Y2) or
                               (LinePos[CurrLine]=CharCount) do  Dec ( CurrLine );
                         ME:=CursorPosition
                       end;
                     GoToXY ( CurrCol,CurrLine );
                     If MB<=ME then
                       begin
                         MarkBegin:=MB;
                         Up:=false;
                         MarkEnd:=ME
                       end
                      else
                       begin
                         MarkEnd:=MB;
                         Up:=true;
                         MarkBegin:=ME
                       end;
                     ShowScreen ( BuffPos )
                   end;
                 ClearEvent
               end
        end
    until AnyEvent
  end;

var Scr : BoxContType;
    X,Y : byte;
    i   : byte;

begin
  If Restore then
    begin
      X:=WhereX;
      Y:=WhereY;
      If Shadow then
        SaveBoxContents ( Scr,X1-1,Y1-1,X2+2,Y2+2 )
       else
        SaveBoxContents ( Scr,X1-1,Y1-1,X2+1,Y2+1 )
    end;
  If Border then
    begin
      DrawBox ( X1-1,Y1-1,X2+1,Y2+1,NAttr,NormBoxString,Shadow );
    end;
  If Status then
    begin
      ShowLeftUpMessage;
      WriteString ( RightUpMessage,Y1-1,X2-length(RightUpMessage)-5,NAttr );
      {WriteString ( LeftDownMessage,Y2+1,X1+1,NAttr );}
      WriteString ( RightDownMessage,Y2+1,X2-length(RightDownMessage)-2,NAttr )
    end;
  EditBuffer;
  ClearMouseKeys ( 'H' );
  ClearMouseKeys ( 'V' );
  If Restore then
    begin
      RestoreBoxContents ( Scr );
      GoToXY ( X,Y )
    end
end;

Function TextBufferObject.Translate ( Key : word ) : word;
begin
  Translate:=Key
end;

Function TextBufferObject.BufferAddr : pointer;
begin
  BufferAddr:=Buffer
end;

Procedure TextBufferObject.Print;
var i  : word;
    S  : string;
    OK : boolean;
begin
  If PrinterMode<>0 then  SetPrinter ( PrinterMode );
  i:=0;
  OK:=true;
  While (i<CharCount) and OK do
    begin
      S:='';
      While (i<CharCount) and (Buffer^[i]<>$0D) do
        begin
          S:=S+char(Buffer^[i]);
          Inc ( i )
        end;
      If i<CharCount then  Inc ( i );
      If (i<CharCount) and (Buffer^[i]=$0A) then  Inc ( i );
      OK:=PrintLine(S)
    end;
end;

Procedure TextBufferObject.GoToMarked;
begin
  If (MarkBegin<BuffPos) or (MarkBegin>LinePos[Y2]) then
    begin
      BuffPos:=MarkBegin;
      LeftX:=0;
      CurrCol:=X1;
      CurrLine:=Y1;
      While (BuffPos>0) and (Buffer^[BuffPos]<>$0D) do
        begin
          Dec ( BuffPos );
          If CurrCol<X2 then  Inc ( CurrCol )  else  Inc ( LeftX )
        end;
      If BuffPos>0 then
        begin
          Dec ( BuffPos );
          While (BuffPos>0) and (Buffer^[BuffPos]<>$0D) do
            begin
              Dec ( BuffPos );
            end;
          Inc ( CurrLine )
        end;
      If (Buffer^[BuffPos]=$0D) and (BuffPos<CharCount) then
        begin
          Inc ( BuffPos );
          If CurrCol>X1 then  Dec ( CurrCol )  else  If LeftX>0 then Dec ( LeftX );
          If (Buffer^[BuffPos]=$0A) and (BuffPos<CharCount) then
            begin
              Inc ( BuffPos );
              If CurrCol>X1 then  Dec ( CurrCol )  else  If LeftX>0 then Dec ( LeftX )
            end
        end
    end
end;

Procedure TextBufferObject.GoToPosition ( Pos : word );
begin
  BuffPos:=Pos;
  LeftX:=0;
  CurrCol:=X1;
  CurrLine:=Y1;
  While (BuffPos>0) and (Buffer^[BuffPos]<>$0D) do
    begin
      Dec ( BuffPos );
      If CurrCol<X2 then  Inc ( CurrCol )  else  Inc ( LeftX )
    end;
  If (Buffer^[BuffPos]=$0D) and (BuffPos<CharCount) then
    begin
      Inc ( BuffPos );
      If CurrCol>X1 then  Dec ( CurrCol )  else  If LeftX>0 then Dec ( LeftX );
      If (Buffer^[BuffPos]=$0A) and (BuffPos<CharCount) then
        begin
          Inc ( BuffPos );
          If CurrCol>X1 then  Dec ( CurrCol )  else  If LeftX>0 then Dec ( LeftX )
        end
    end
end;

Function TextBufferObject.FindString ( S : string; Pos : word ) : boolean;
var L     : byte;
    N     : byte;
    Count : word;
    OK    : boolean;
    Buff  : pointer;
begin
  N:=1;
  L:=length(S);
  S:=UpperCase(S);
  Count:=CharCount;
  Buff:=Buffer;
{  While (Pos<CharCount) and (N<=L) do
    begin
      If UpCase(char(Buffer^[Pos]))<>S[N] then  N:=1  else  Inc ( N );
      Inc ( Pos )
    end;}
  Asm
    push    ds
    lds     si,Buff
    add     Count,si    { ds:Count - end of buffer }
    add     si,Pos      { ds:si = Addr(Buffer^[Pos]) }
    lea     di,S
    push    ss
    pop     es          { es:di = S }
    xor     ax,ax
    mov     al,es:[di]
    inc     di
    push    di
    add     ax,di
    mov     bx,ax       { bx = Offset(S)+L }
    push    ss
    pop     es
    cld
@L1:
    cmp     si,Count
    ja      @L4
    cmp     di,bx
    jnb      @L4
    lodsb
    push    ax
    call    UpCase
    cmp     al,es:[di]
    je      @L2
    pop     di
    push    di
    jmp     @L1
@L2:
    inc     di
    jmp     @L1
@L4:
    pop     ax
    pop     ds
    mov     OK,1
    les     ax,Buff
    sub     si,ax
    mov     Pos,si
    cmp     di,bx
    jnb     @L5
    mov     OK,0
@L5:
  end;
  If not OK {N<=L} then  FindString:=false
   else
    begin
      FindString:=true;
      GoToPosition ( Pos-L );
    end
end;

Function TextBufferObject.CursorPosition : word;
begin
  If LineLength[CurrLine]>=CurrCol+LeftX-1 then
    CursorPosition:=LinePos[CurrLine]+CurrCol+LeftX-2
   else
    CursorPosition:=LinePos[CurrLine]+LineLength[CurrLine]
end;

Function TextBufferObject.LeftUpMessage : string;
begin
  LeftUpMessage:=''
end;

Procedure TextBufferObject.ShowLeftUpMessage;
begin
  WriteString ( LeftUpMessage,Y1-1,X1+1,NAttr )
end;

Function TextBufferObject.LeftDownMessage : string;
begin
  LeftDownMessage:=''
end;

Function TextBufferObject.RightUpMessage : string;
begin
  RightUpMessage:='Free:'
end;

Function TextBufferObject.RightDownMessage : string;
begin
  RightDownMessage:=''
end;

Const Set1 = [#13,#10,#32,#9];
      Set2 = [',','.',';','!','?','-',#12];
      Set4 = ['B','C','D','F','G','H','J','K','L','M',
              'N','P','Q','R','S','T','V','W','X','Z',
              'Б','В','Г','Д','Ж','З','К','Л','М','Н',
              'П','Р','С','Т','Ф','Х','Ц','Ч','Ш','Щ' ];
      Set5 = ['A','E','I','O','U','Y',')',
              'А','Е','И','О','У','Ы','Э','Ю','Я','"',''''];

Procedure TextBufferObject.ReformatString ( var BeginPos : word;
                                            var EndPos   : word;
                                                LeftPos  : byte );
var P,P1,P0 : word;
    Set3    : set of char;
    Set6    : set of char;
    i,j     : word;
    OK      : boolean;
    WCnt    : byte;
    S       : string;
    Peren   : boolean;
    Sogl    : boolean;
begin
  WCnt:=0;
  If EndPos<=BeginPos then  Exit;
  P:=BeginPos;
  Set3:=Set1+Set2;
  Set6:=Set4+Set5;
  {Формирование отступа слева}
  While (P-BeginPos<LeftPos-1) and (CharCount<BufferSize) do
    begin
      InsertChar ( $20,P );
      If P<CurrentCursorPosition then  Inc ( CurrentCursorPosition );
      Inc ( EndPos );
      Inc ( P )
    end;
  P1:=P;
  {Формирование строки}
  Peren:=false;
  While ((P1<EndPos) and (P1-BeginPos<TextOptions.RightTextPos)) and (not Peren) do
    begin
      {Удалить пробелы и символы конца строки}
      While ((P1<EndPos) and (EndPos>0)) and (char(Buffer^[P1]) in Set1) do
        begin
          DeleteChar ( P1 );
          If P1<CurrentCursorPosition then  Dec ( CurrentCursorPosition );
          Dec ( EndPos )
        end;
      {Выделить следующее слово}
      S[0]:=#0;
      While (not (char(Buffer^[P1]) in Set3)) and (P1<EndPos) do
        begin
          If S[0]<#255 then
            begin
              Inc ( S[0] );
              S[ord(S[0])]:=char(Buffer^[P1])
            end;
          Inc ( P1 );
          If (char(Buffer^[P1])='-') and (Buffer^[P1+1]=$0D) then {Символ переноса ?}
            begin
              DeleteChar ( P1 );
              If P1<CurrentCursorPosition then  Dec ( CurrentCursorPosition );
              Dec ( EndPos );
              DeleteChar ( P1 );
              If P1<CurrentCursorPosition then  Dec ( CurrentCursorPosition );
              Dec ( EndPos );
              If Buffer^[P1]=$0A then
                begin
                  DeleteChar ( P1 );
                  If P1<CurrentCursorPosition then  Dec ( CurrentCursorPosition );
                  Dec ( EndPos )
                end;
              While (Buffer^[P1]=$20) and (P1<CharCount) do
                begin
                  DeleteChar ( P1 );
                  If P1<CurrentCursorPosition then  Dec ( CurrentCursorPosition );
                  Dec ( EndPos )
                end
            end
        end;
      If not (char(Buffer^[P1]) in Set1) then  Inc ( P1 );
      {Добавить слово}
      i:=length(S);
      S:=UpperCase(S);
      Sogl:=false;
      If (P1-BeginPos>=TextOptions.RightTextPos+1) and TextOptions.DoPerenos then
        { Перенос }
        begin
          P0:=P1;
          While ((P0-BeginPos>=TextOptions.RightTextPos) and (i>1)) and (not Peren) do
            begin
              If i>0 then  Dec ( i );
              While (i>0) and
                    (
                      (
                        (not (S[i] in Set4)) or
                        (not (S[i+1] in Set5))
                      )  or
                      (i<3) )
                           do  Dec ( i );
              If (i>1) and (P0-length(S)+i-BeginPos<TextOptions.RightTextPos) then
                begin
                  j:=1;
                  While j<=i do
                    begin
                      If S[j] in Set5 then  Peren:=true;
                      Inc ( j )
                    end;
                  If Peren then
                    begin
                      Peren:=false;
                      j:=1;
                      While j<=i do
                        begin
                          If S[j] in Set4 then  Peren:=true;
                          Inc ( j )
                        end;
                      If Peren then  P0:=P+i-1
                    end
                end
            end
        end;
      If Peren then  P1:=P0;
      If (P1-BeginPos<TextOptions.RightTextPos+1) or (WCnt=0) then
        begin
          If Peren then
            begin
              InsertChar ( ord('-'),P1 );
              If P1<CurrentCursorPosition then  Inc ( CurrentCursorPosition );
              Inc ( P1 );
              Inc ( EndPos )
            end;
          P:=P1;
          Inc ( WCnt );
          If ((P<CharCount) and (P-BeginPos<TextOptions.RightTextPos+1)) and
             (not
               (
                 (char(Buffer^[P-1]) in Set2) and
                 (not
                   (char(Buffer^[P]) in Set1)
                 )
               )
             ) then
            begin
              InsertChar ( $20,P );
              If P<CurrentCursorPosition then  Inc ( CurrentCursorPosition );
              Inc ( P );
              Inc ( EndPos );
              Inc ( P1 )
            end
        end;
    end;
  If Buffer^[P-1]=$20 then
    begin
      DeleteChar ( P-1 );
      If P-1<CurrentCursorPosition then  Dec ( CurrentCursorPosition );
      Dec ( EndPos );
      Dec ( P )
    end;
  {Выравнивание правого края}
  If  TextOptions.DoJustify then
    begin
      i:=1;
      OK:=true;
      While ((P-BeginPos<TextOptions.RightTextPos) and (P<EndPos)) and OK do
        begin
          OK:=false;
          P1:=P-1;
          While (P1>=BeginPos+LeftPos) and (P-BeginPos<TextOptions.RightTextPos) do
            begin
              While (Buffer^[P1]<>$20) and (P1>=BeginPos+LeftPos) do  Dec ( P1 );
              If P1>=BeginPos+LeftPos then
                begin
                  InsertChar ( $20,P1 );
                  If P1<CurrentCursorPosition then  Inc ( CurrentCursorPosition );
                  OK:=true;
                  Inc ( EndPos );
                  Inc ( P );
                  While (Buffer^[P1]=$20) and (P1>=BeginPos+LeftPos) do  Dec ( P1 )
                end;
            end
        end
    end;
  {Установка Pos в начало следующей строки}
  BeginPos:=P;
  If BeginPos<EndPos then
    begin
      InsertChar ( $0D,BeginPos );
      If BeginPos<CurrentCursorPosition then  Inc ( CurrentCursorPosition );
      Inc ( EndPos );
      Inc ( BeginPos );
      InsertChar ( $0A,BeginPos );
      If BeginPos<CurrentCursorPosition then  Inc ( CurrentCursorPosition );
      Inc ( EndPos );
      Inc ( BeginPos )
    end
end;

Function TextBufferObject.BeginOfParagraph ( Pos : word ) : word;
var N  : word;
    P  : word;
    OK : boolean;
begin
  P:=Pos;
  OK:=false;
  While not OK do
    begin
      If P>0 then  Dec ( P );
      If (P>0) and (Buffer^[P]=$0A) then  Dec ( P );
      If Buffer^[P]=$0D then  OK:=true;
      While (P>0) and (Buffer^[P]<>$0D) do  Dec ( P );
      If P>0 then
        begin
          Inc ( P );
          If Buffer^[P]=$0A then  Inc ( P );
          N:=0;
          While (P+1<CharCount) and (Buffer^[P+N]=$20) do  Inc ( N );
          If (N>=TextOptions.LeftTextPos) or (Buffer^[P]=$0D) then  OK:=true;
          If not OK then
            begin
              Dec ( P );
              If Buffer^[P]=$0A then  Dec ( P )
            end
        end
       else  OK:=true
    end;
  BeginOfParagraph:=P
end;

Function TextBufferObject.EndOfParagraph ( Pos : word ) : word;
var N  : word;
    P  : word;
    OK : boolean;
begin
  P:=Pos;
  OK:=false;
  While not OK do
    begin
      While (P+1<CharCount) and (Buffer^[P]<>$0D) do  Inc ( P );
      If (P+1<CharCount) and (Buffer^[P]=$0D) then
        begin
          N:=1;
          Inc ( P );
          If Buffer^[P]=$0A then  Inc ( P );
          While (P+N+2<CharCount) and
                (Buffer^[P+N-1]=$20) do  Inc ( N );
          If (P+N+2>=CharCount) or
             ((Buffer^[P+N-1]=$0D) or (N>TextOptions.LeftTextPos)) then
            begin
              OK:=true;
              If P>0 then  Dec ( P );
              If (Buffer^[P]=$0A) and (P>0) then  Dec ( P );
              If P>0 then  Dec ( P )
            end
        end
       else  OK:=true
      end;
  EndOfParagraph:=P
end;

Procedure TextBufferObject.CenterString ( Pos : word );
var Pos1,Pos2 : word;
    L         : word;
begin
  Pos1:=Pos;
  While (Pos1>0) and (Buffer^[Pos1]<>$0D) do  Dec ( Pos1 );
  If (Pos1<CharCount) and (Buffer^[Pos1]=$0D) then  Inc ( Pos1 );
  If (Pos1<CharCount) and (Buffer^[Pos1]=$0A) then  Inc ( Pos1 );
  While (Pos1+1<CharCount) and (Buffer^[Pos1] in [$20,$9]) do
    begin
      If Pos1<CurrentCursorPosition then  Dec ( CurrentCursorPosition );
      DeleteChar ( Pos1 );
    end;
  Pos2:=Pos1;
  While (Pos2+1<CharCount) and (Buffer^[Pos2]<>$0D) do  Inc ( Pos2 );
  While (Pos2-1>Pos1) and (Buffer^[Pos2-1] in [$20,$9]) do  Dec ( Pos2 );
  While (Pos2<CharCount) and (Buffer^[Pos2-1] in [$20,$9]) do
    begin
      If Pos2-1<CurrentCursorPosition then  Dec ( CurrentCursorPosition );
      DeleteChar ( Pos2-1 );
    end;
  L:=TextOptions.RightTextPos-TextOptions.LeftTextPos;
  If L>Pos2-Pos1 then
    begin
      L:=L-(Pos2-Pos1);
      While L>0 do
        begin
          InsertChar ( $20,Pos1 );
          Dec ( L );
          If L>0 then  Dec ( L )
        end
    end
end;

Procedure TextBufferObject.ReformatParagraph ( BeginPos : word );
var EndPos   : word;
    P        : word;
    i        : word;
    OK       : boolean;
    BP       : word;
    S        : string;
begin
  If not DoEdit then  Exit;
  While (BeginPos+1<CharCount) and (Buffer^[BeginPos] in [$20,$9]) do
    begin
      If BeginPos<CurrentCursorPosition then  Dec ( CurrentCursorPosition );
      DeleteChar ( BeginPos );
    end;
  EndPos:=EndOfParagraph(BeginPos);
  ReformatString ( BeginPos,EndPos,TextOptions.ParagraphPos );
  S:='';
  i:=0;
  While (i<CharCount) and (Buffer^[i]<>$0D) do
    begin
      S:=S+char(Buffer^[i]);
      Inc ( i )
    end;
  BP:=BuffPos;
  While BeginPos<EndPos do
    begin
      If (BeginPos>LinePos[Y2]) then  BuffPos:=LinePos[Y1+1];
      ReformatString ( BeginPos,EndPos,TextOptions.LeftTextPos );
      ShowScreen ( BuffPos )
    end;
  BuffPos:=BP;
end;

Procedure TextBufferObject.BlockToParagraph;
var BeginPos : word;
    EndPos   : word;
    P        : word;
begin
  If not DoEdit then  Exit;
  BeginPos:=MarkBegin;
  While (BeginPos+1<CharCount) and (Buffer^[BeginPos] in [$20,$9]) do  DeleteChar ( BeginPos );
  EndPos:=MarkEnd;
  If Buffer^[EndPos-1]=$0A then  Dec ( EndPos );
  If Buffer^[EndPos-1]=$0D then  Dec ( EndPos );
  ReformatString ( BeginPos,EndPos,TextOptions.ParagraphPos );
  While BeginPos<EndPos do
    begin
      P:=BeginPos;
      ReformatString ( BeginPos,EndPos,TextOptions.LeftTextPos );
      ShowScreen ( P )
    end
end;

Procedure TextBufferObject.ReformatBlock;
var BeginPos : word;
    EndPos   : word;
    P        : word;
    BlockEnd : word;
begin
  If not DoEdit then  Exit;
  BeginPos:=MarkBegin;
  While (BeginPos+1<CharCount) and (Buffer^[BeginPos] in [$20,$9]) do  DeleteChar ( BeginPos );
  BlockEnd:=MarkEnd;
  If Buffer^[BlockEnd-1]=$0A then  Dec ( BlockEnd );
  If Buffer^[BlockEnd-1]=$0D then  Dec ( BlockEnd );
  Repeat
    EndPos:=EndOfParagraph(BeginPos);
    ReformatString ( BeginPos,EndPos,TextOptions.ParagraphPos );
    While BeginPos<EndPos do
      begin
        P:=BeginPos;
        ReformatString ( BeginPos,EndPos,TextOptions.LeftTextPos );
        ShowScreen ( P )
      end;
    Inc ( BeginPos );
  until  BeginPos>=BlockEnd
end;

Function TextBufferObject.WordOnCursor : string;
var S : string;
    P : word;
begin
  P:=CursorPosition;
  While (P>0) and (not (chr(Buffer^[P-1]) in Set1+Set2)) do  Dec ( P );
  S:='';
  While (P+1<CharCount) and
        (not (chr(Buffer^[P]) in Set1+Set2)) and
        (length(S)<255) do
    begin
      S:=S+chr(Buffer^[P]);
      Inc ( P )
    end;
  WordOnCursor:=S
end;

Procedure SetFormatParameters ( LeftMargin  : byte;
                                RightMargin : byte;
                                Paragraph   : byte;
                                AutoFormat  : boolean;
                                Justify     : boolean;
                                Perenos     : boolean );
begin
  With TextOptions do
    begin
      LeftTextPos:=LeftMargin;
      RightTextPos:=RightMargin;
      ParagraphPos:=Paragraph;
      DoFormat:=AutoFormat;
      DoJustify:=Justify;
      DoPerenos:=Perenos
    end
end;


Constructor ExtendedTextObject.Init ( X0,Y0,Xl,Yl : byte;
                                      NormAttr    : byte;
                                      MarkAttr    : byte;
                                      DialogAttr  : byte;
                                      HighAttr    : byte;
                                      WaitAttr    : byte;
                                      ErrorAttr   : byte;
                                      LetEdit     : boolean;
                                      Russian     : boolean );
begin
  Buffer:=nil;
  Inherited Init ( $FFF0,X0,Y0,Xl,Yl,NormAttr,MarkAttr,LetEdit,true,false,NoShadow,true );
  StrToLookFor:='';
  DAttr:=DialogAttr;
  HAttr:=HighAttr;
  WAttr:=WaitAttr;
  ErrAttr:=ErrorAttr;
  Russ:=Russian;
  If Buffer=nil then  ShowMessage ( 'Не хватает памяти',ErrAttr,ButtonAttr )
end;

Function ExtendedTextObject.Translate ( Key : word ) : word;
var i : byte;
begin
  If Russ then
    begin
      If (hi(Key)=0) then
        begin
          i:=pos(char(lo(Key)),LatinLetters);
          If i>0 then  Key:=ord(RussianLetters[i])
        end
    end;
  Translate:=Key
end;

Procedure ExtendedTextObject.InputString ( var S0 : string; Y,X,L,Attr : byte );
var S  : string;
    P  : byte;
    Ed : boolean;
begin
  P:=0;
  Ed:=false;
  Repeat
    S:=S0;
    While length(S)<L do  S:=S+#177;
    WriteString ( S,Y,X,Attr );
    GoToXY ( X+P,Y );
    WaitEvent;
    KeyEvent:=Translate(KeyEvent);
    Case KeyEvent of
           $20..$FF : begin
                        If not Ed then  S0:='';
                        S0:=Copy(S0,1,P)+chr(lo(KeyEvent))+Copy(S0,P+1,length(S0));
                        Inc ( P );
                        ClearEvent
                      end;
          Key_Right : begin
                        If length(S0)>P then  Inc ( P );
                        ClearEvent
                      end;
           Key_Left : begin
                        If P>0 then  Dec ( P );
                        ClearEvent
                      end;
      Key_Backspace : begin
                        If P>0 then
                          begin
                            Delete ( S0,P,1 );
                            Dec ( P )
                          end;
                        ClearEvent
                      end;
         Key_Delete : begin
                        If length(S0)>0 then  Delete ( S0,P+1,1 );
                        ClearEvent
                      end;
           Key_Home : begin
                        P:=0;
                        ClearEvent
                      end;
            Key_End : begin
                        P:=length(S0);
                        ClearEvent
                      end
    end;
    Ed:=true
  until AnyEvent
end;

Procedure ExtendedTextObject.GetSearchString;
const Xb1=12; Yb1=10; Xb2=68; Yb2=12;
var Box : BoxContType;
begin
  SaveBoxContents ( Box,Xb1,Yb1,Xb2+1,Yb2+1 );
  FillBoxWith ( Xb1,Yb1,Xb2,Yb2,$20,DAttr );
  DrawBox ( Xb1,Yb1,Xb2,Yb2,DAttr,NormBoxString,true );
  WriteString ( 'Строка для поиска : ',Yb1+1,Xb1+2,DAttr );
  {StrToLookFor:=WordOnCursor;}
  InputString ( StrToLookFor,Yb1+1,Xb1+22,32,HAttr );
  RestoreBoxContents ( Box )
end;

Procedure ExtendedTextObject.PutWaitMessage;
begin
  WriteString ( 'Работаю ',1,73,WAttr )
end;

Procedure ExtendedTextObject.RemoveWaitMessage;
begin
  WriteString ( '        ',1,73,WAttr )
end;

{$IfDEF Russian}
Function ExtendedTextObject.LeftUpMessage : string;
begin
  If Russ and (RussianLetters[1]='А') then  LeftUpMessage:='Рус'  else  LeftUpMessage:='Лат'
end;
{$ENDIF}

Function ExtendedTextObject.LeftDownMessage : string;
var S : string;
    i : byte;
begin
  If Border then
    If Changed then  S:='*═'  else  S:='══'
   else
    If Changed then  S:='* '  else  S:='  ';
  S:=S+LIntToStr(ScrUpLineN+CurrLine-Y1)+':'+LIntToStr(LeftX+CurrCol-X1+1);
  i:=length(S);
  S[0]:=#11;
  If Border then
    While i<11 do
      begin
        Inc ( i );
        S[i]:='═'
      end
    else
     While i<11 do
       begin
         Inc ( i );
         S[i]:=' '
       end;
  LeftDownMessage:=S
end;

Function ExtendedTextObject.RightUpMessage : string;
begin
  RightUpMessage:='Свободно:'
end;

Procedure ExtendedTextObject.MarkBlockBegin;
begin
  MarkBegin:=CursorPosition;
  ShowMark:=true
end;

Procedure ExtendedTextObject.MarkBlockEnd;
begin
  MarkEnd:=CursorPosition;
  ShowMark:=true
end;

Procedure ExtendedTextObject.HideBlockMark;
begin
  ShowMark:= not ShowMark;
  If ShowMark and (MarkEnd>MarkBegin) then  GoToMarked
end;

Procedure ExtendedTextObject.DeleteMarkedBlock;
begin
  If ShowMark and (MarkEnd>MarkBegin) then
    begin
      GoToMarked;
      DeleteBlock ( MarkBegin,MarkEnd-MarkBegin );
      MarkEnd:=MarkBegin
    end
end;

Procedure ExtendedTextObject.CopyMarkedBlockToCursor;
var P : ^char;
    i : word;
begin
  If (ShowMark and (MarkEnd>MarkBegin)) and
     ((LinePos[CurrLine]+CurrCol+LeftX-2<=MarkBegin) or (LinePos[CurrLine]+CurrCol+LeftX-2>=MarkEnd)) then
    begin
      i:=LeftX+CurrCol-X1;
      While (i>LineLength[CurrLine]) and (CharCount<BufferSize) do
        begin
          InsertChar ( $20,LinePos[CurrLine]+LineLength[CurrLine] )
        end;
      If CursorPosition<MarkBegin then
        P:=Addr(Buffer^[MarkEnd])
       else
        P:=Addr(Buffer^[MarkBegin]);
      InsertBlock ( P,MarkEnd-MarkBegin,LinePos[CurrLine]+CurrCol+LeftX-2 );
      GoToMarked
    end
end;

Procedure ExtendedTextObject.MoveMarkedBlockToCursor;
var P : ^char;
    i : word;
    M : boolean;
    L : longint;
begin
  If (ShowMark and (MarkEnd>MarkBegin)) and
     ((LinePos[CurrLine]+CurrCol+LeftX-2<MarkBegin) or
     (LinePos[CurrLine]+CurrCol+LeftX-2>MarkEnd)) then
    begin
      If (LinePos[CurrLine]<=MarkBegin) and
         (LinePos[CurrLine]+CurrCol+LeftX-2>MarkBegin) and
         (LinePos[CurrLine+1]>MarkEnd) then
        M:=true
       else
        M:=false;
      i:=LeftX+CurrCol-X1;
      While (i>LineLength[CurrLine]) and (CharCount<BufferSize) do
        begin
          InsertChar ( $20,LinePos[CurrLine]+LineLength[CurrLine] )
        end;
      If CursorPosition<MarkBegin then
        P:=Addr(Buffer^[MarkEnd])
       else
        P:=Addr(Buffer^[MarkBegin]);
      L:=CharCount;
      L:=L+(MarkEnd-MarkBegin);
      If L<BufferSize then
        begin
          InsertBlock ( P,MarkEnd-MarkBegin,LinePos[CurrLine]+CurrCol+LeftX-2 );
          DeleteBlock ( Ofs(P^)-Ofs(Buffer^),MarkEnd-MarkBegin );
          If M then  CurrCol:=CurrCol-(MarkEnd-MarkBegin);
          GoToMarked
        end
    end
end;

Procedure ExtendedTextObject.IntendMarkedBlock;
begin
  If (ShowMark and (MarkEnd>MarkBegin)) then
     begin
       IndentBlock ( MarkBegin,MarkEnd );
       GoToMarked
     end
end;

Procedure ExtendedTextObject.UnintendMarkedBlock;
begin
  If (ShowMark and (MarkEnd>MarkBegin)) then
    begin
      UnIndentBlock ( MarkBegin,MarkEnd );
      GoToMarked
    end
end;

Procedure ExtendedTextObject.ReformatMarkedBlock;
begin
  If (ShowMark and (MarkEnd>MarkBegin)) then
    begin
      ReformatBlock;
      GoToMarked
    end
end;

Procedure ExtendedTextObject.MakeParagraphOfBlock;
begin
  If (ShowMark and (MarkEnd>MarkBegin)) then
    begin
      BlockToParagraph;
      GoToMarked
    end
end;

Procedure ExtendedTextObject.LookForAString;
begin
  GetSearchString;
  If (KeyEvent<>Key_Esc) and (StrToLookFor<>'') then
    begin
      PutWaitMessage;
      Found:=FindString(StrToLookFor,CursorPosition+1);
      RemoveWaitMessage;
      If not Found then
        begin
          ShowMessage ( 'Строка не найдена...',ErrAttr,ButtonAttr )
        end
    end
end;

Procedure ExtendedTextObject.ContinueStringSearch;
begin
  If StrToLookFor='' then
    begin
      {GetSearchString;}
      If (KeyEvent<>Key_Esc) and (StrToLookFor<>'') then
        begin
          PutWaitMessage;
          Found:=FindString(StrToLookFor,CursorPosition+1);
          RemoveWaitMessage;
          If not Found then
            begin
              ShowMessage ( 'Строка не найдена...',ErrAttr,ButtonAttr )
            end
        end;
    end
   else
    If not FindString(StrToLookFor,CursorPosition+1) then
      ShowMessage ( 'Строка не найдена...',ErrAttr,ButtonAttr );
end;

Procedure ExtendedTextObject.SwitchAlphabet;
begin
  Russ:=not Russ;
  ShowLeftUpMessage
end;

Procedure ExtendedTextObject.ReformatParagraphAtCursor;
begin
  ReformatParagraph ( LinePos[CurrLine] );
end;

Procedure ExtendedTextObject.Edit;
var L,i : word;
begin
  Repeat
    Inherited Edit;
    Case KeyEvent of
        Key_CtrlK : begin
                      WaitEvent;
                      If MarkEnd>CharCount then  MarkEnd:=CharCount;
                      If MarkBegin>CharCount then  MarkBegin:=CharCount;
                      Case KeyEvent of
                        ord('B'),ord('b'),Key_CtrlB : MarkBlockBegin;
                        ord('K'),ord('k'),Key_CtrlK : MarkBlockEnd;
                        ord('H'),ord('h'),Key_CtrlH : HideBlockMark;
                        ord('Y'),ord('y'),Key_CtrlY : DeleteMarkedBlock;
                        ord('C'),ord('c'),Key_CtrlC : CopyMarkedBlockToCursor;
                        ord('V'),ord('v'),Key_CtrlV : MoveMarkedBlockToCursor;
                        ord('I'),ord('i'),Key_CtrlI : IntendMarkedBlock;
                        ord('U'),ord('u'),Key_CtrlU : UnintendMarkedBlock;
                        ord('F'),ord('f'),Key_CtrlF : ReformatMarkedBlock;
                        ord('M'),ord('m'),Key_CtrlM : MakeParagraphOfBlock;
                      end;
                      ClearEvent
                    end;
        Key_CtrlQ : begin
                      WaitEvent;
                      Case KeyEvent of
                        ord('F'),ord('f'),Key_CtrlF : begin
                                                        Repeat
                                                          LookForAString;
                                                         {$IFDEF Russian}
                                                          If KeyEvent=Key_F10 then
                                                            begin
                                                              SwitchAlphabet;
                                                              ClearEvent
                                                            end
                                                         {$ENDIF}
                                                        until AnyEvent;
                                                        ClearEvent
                                                      end
                      end;
                      ClearEvent
                    end;
           Key_F7 : begin
                      Repeat
                        LookForAString;
                       {$IFDEF Russian}
                        If KeyEvent=Key_F10 then
                          begin
                            SwitchAlphabet;
                            ClearEvent
                          end
                       {$ENDIF}
                      until AnyEvent;
                      ClearEvent
                    end;
      Key_ShiftF7 : begin
                      ContinueStringSearch;
                      ClearEvent
                    end;
        Key_CtrlL : begin
                      ContinueStringSearch;
                      ClearEvent
                    end;
          {$IFDEF Russian}
           Key_F10 : begin
                      SwitchAlphabet;
                      ClearEvent
                    end;
          {$ENDIF}
         Key_AltR : begin
                      ReformatParagraphAtCursor;
                      ClearEvent
                    end;
         Key_AltM : begin
                      CenterString ( LinePos[CurrLine] );
                      ClearEvent
                    end;
         Key_AltF : begin
                      L:=TextOptions.ParagraphPos;
                      TextOptions.ParagraphPos:=1;
                      i:=0;
                      While (i<LineLength[CurrLine]) and (Buffer^[LinePos[CurrLine]+TextOptions.ParagraphPos-1]=$20) do
                        Inc ( TextOptions.ParagraphPos );
                      CurrentCursorPosition:=CursorPosition;
                      ReformatParagraph ( LinePos[CurrLine] );
                      TextOptions.ParagraphPos:=L;
                      ClearEvent
                    end
    end
  until AnyEvent
end;


Constructor FileEditObject.Init ( FileName    : string;
                                  X0,Y0,Xl,Yl : byte;
                                  NormAttr    : byte;
                                  MarkAttr    : byte;
                                  DialogAttr  : byte;
                                  HighAttr    : byte;
                                  WaitAttr    : byte;
                                  ErrorAttr   : byte;
                                  Russian     : boolean );
begin
  Inherited Init ( X0,Y0,Xl,Yl,NormAttr,MarkAttr,DialogAttr,HighAttr,WaitAttr,ErrorAttr,true,Russian );
  FName:=FileName;
  PathName:=FileName
end;

Procedure FileEditObject.ReadDiskFile;
var FileRecord : FindFileRecord;
begin
  If FindFirstFile(FName,$21,FileRecord) then
    begin
      If FileRecord.Attr and $01 > 0 then
        begin
          ShowMessage ( 'Файл : '+FName+' защищен от записи.',ErrAttr,ButtonAttr );
          DoEdit:=false
        end;
      If not ReadFile(FName) then
        begin
          If DiskError=3 then
            begin
              ShowMessage ( 'Файл слишком длинный. Максимальный размер - 64К',ErrAttr,ButtonAttr );
              DoEdit:=false
            end
           else
            begin
              ShowMessage ( 'Не могу читать файл : '+FName,ErrAttr,ButtonAttr );
              FName:=''
            end
        end
       else  DoEdit:=DoEditConst
    end
   else
    begin
      DoEdit:=DoEditConst;
      ShowMessage ( 'Файл : '+FName+' - новый.',DAttr,ButtonAttr );
      InitVariables;
      CharCount:=0
    end
end;

Function FileEditObject.WriteDiskFile : boolean;
begin
  If FName='' then  Exit;
  If not WriteFile(FName) then
    begin
      ShowMessage ( 'Ошибка при записи файла : '+FName,ErrAttr,ButtonAttr );
      WriteDiskFile:=false
    end
   else
    begin
      If DiskError=5 then
        ShowMessage ( 'Ошибка при  создании .BAK файла.',ErrAttr,ButtonAttr );
      WriteDiskFile:=true
    end
end;

Function FileEditObject.SaveFile : boolean;
var Yes : boolean;
begin
  SaveFile:=false;
  FName:='';
  FileSave.Init ( Addr(FName),DAttr,DAttr,HAttr );
  FileSave.Edit;
  FileSave.Done;
  Yes:=false;
  If (KeyEvent<>Key_Esc) and (FName<>'') then
    begin
      If FileExists(FName) then
        begin
          GetYesNo ( 'Файл : '+FName+' существует.',
                     'Записать ?','',
                     DAttr,ButtonAttr,HAttr,Yes )
        end
       else  Yes:=true
    end;
  If Yes then  SaveFile:=WriteDiskFile
end;


Function FileEditObject.SaveTheFile : boolean;
var Yes : boolean;
begin
  SaveTheFile:=false;
  Yes:=true;
  If length(FName)=0 then
    begin
      FileSave.Init ( Addr(FName),DAttr,DAttr,HAttr );
      FileSave.Edit;
      FileSave.Done;
      Yes:=false;
      If (KeyEvent<>Key_Esc) and (FName<>'') then
        begin
          If FileExists(FName) then
            begin
              GetYesNo ( 'Файл : '+FName+' существует.',
                         'Записать ?','',
                         DAttr,ButtonAttr,HAttr,Yes )
            end
           else  Yes:=true
        end
    end;
  If Yes then  SaveTheFile:=WriteDiskFile
end;

Procedure FileEditObject.ReadNewFile;
var OK  : boolean;
    Yes : boolean;
begin
  OK:=true;
  Yes:=true;
  If Changed then
    begin
      GetYesNo ( 'Внимание !','Файл : "'+FName+'" редактировался.',
                 'Записать изменения ?',
                 DAttr,ButtonAttr,HAttr,Yes );
      If KeyEvent=Key_Esc then  OK:=false
       else
        If Yes then
          begin
            ClearEvent;
            OK:=SaveTheFile
          end
    end;
  If OK then
    begin
      PathName:='*.*';
      FileRead.Init ( Addr(PathName),DAttr,DAttr,HAttr );
      FileRead.Edit;
      FileRead.Done;
      PathName:=UpperCase(PathName);
      If (KeyEvent<>Key_Esc) and (PathName<>'') then
        begin
          FName:=PathName;
          ReadDiskFile
        end
    end;
end;

Function FileEditObject.MakeExit : boolean;
var Yes : boolean;
begin
  MakeExit:=true;
  If Changed then
    begin
      Yes:=true;
      GetYesNo ( 'Внимание !','Файл : "'+FName+'" редактировался.',
                 'Записать изменения ?',
                 DAttr,ButtonAttr,HAttr,Yes );
      If KeyEvent=Key_Esc then
        MakeExit:=false
       else
        If Yes then
          begin
            ClearEvent;
            If FName='' then
              begin
                FileSave.Init ( Addr(PathName),DAttr,DAttr,HAttr );
                FileSave.Edit;
                FileSave.Done;
                FName:=PathName;
                If FileExists(FName) then
                  begin
                    GetYesNo ( 'Файл : '+FName+' существует.',
                               'Записать ?','',
                               DAttr,ButtonAttr,HAttr,Yes );
                  end;
              end;
            If (KeyEvent=Key_Esc) or (FName='') then
              MakeExit:=false
             else
              If Yes then  MakeExit:=WriteDiskFile
          end
    end
end;

Procedure FileEditObject.Edit;
begin
  Repeat
    Inherited Edit;
    Case KeyEvent of
          Key_F2 : begin
                     If DoEdit then  SaveTheFile;
                     ClearEvent
                   end;
       Key_AltF2 : begin
                     SaveFile;
                     ClearEvent
                   end;
          Key_F3 : begin
                     ReadNewFile;
                     ClearEvent
                   end
    end
  until AnyEvent;
end;

Function FileEditObject.LeftUpMessage : string;
const L = 42;
var S : string;
    i : byte;
begin
  If length(FName)<=L then
    S:=FName
   else
    begin
      S:=FName;
      While length(S)>L do
        begin
          i:=1;
          Inc ( i );
          While S[i]<>'\' do  Inc ( i );
          Delete ( S,1,i )
        end;
    end;
  While length(S)<60 do
    begin
      S:='═'+S;
      If length(S)<60 then  S:=S+'═'
    end;
  {$IFDEF Russian}
  If Russ then  S:='РУС══'+S  else  S:='ЛАТ══'+S;
  {$ELSE}
  S:='═════'+S;
  {$ENDIF}
  LeftUpMessage:=S
end;

begin
  SetFormatParameters ( 1,70,1,false,true,true );
  TextOptions.CreateBAKFiles:=false;
  PrinterMode:=0
end.
