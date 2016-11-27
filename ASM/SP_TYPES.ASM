.Model TPascal

.Code

Public AllTrim,LTrim,RTrim,PadL,PadR,Replicate,UpCase,UpperCase,LowerCase,StrToComp

;Function AllTrim ( S : string ) : string;
AllTrim       Proc       far
    push    bp
    mov     bp,sp
    push    ds
    lds     si,[bp+6]
    les     di,[bp+10]
    cld
    push    di
    inc     di
    lodsb
    xor     cx,cx
    mov     cl,al
    cmp     cl,0
    jz      TrimNullStr
TrimL1:
    lodsb
    cmp     al,' '
    jne     TrimL2
    loop    TrimL1
    jmp     TrimNullStr
TrimL2:
    push    cx
    stosb
    dec     cx
    cmp     cx,0
    jz      TrimL4
    rep     movsb
TrimL4:
    pop     cx
    dec     di
    push    di
    pop     si
    push    es
    pop     ds
    std
TrimL5:
    lodsb
    cmp     al,' '
    jne     TrimL6
    loop    TrimL5
TrimNullStr:
    xor     cx,cx
TrimL6:
    mov     ax,cx
    pop     di
    stosb
    pop     ds
    pop     bp
    retf    4
AllTrim       EndP

;Function RTrim ( S : string ) : string;
RTrim      Proc      far
    push    bp
    mov     bp,sp
    push    ds
    lds     si,[bp+6]
    les     di,[bp+10]
    cld
    xor     ax,ax
    lodsb
    mov     cx,ax
    cmp     al,0
    je      RTrim21
    push    si
    mov     cx,ax
    add     si,ax
    dec     si
    std
RTrim1:
    lodsb
    cmp     al,20h
    jne     RTrim2
    cmp     cl,0
    je      RTrim2
    loop    RTrim1
RTrim2:
    pop     si
    cld
    mov     ax,cx
RTrim21:
    stosb
    cmp     cl,0
    je      RTrim3
rep movsb
RTrim3:
    pop     ds
    pop     bp
    retf    4
RTrim      EndP

;Function LTrim ( S : string ) : string;
LTrim      Proc      far
    push    bp
    mov     bp,sp
    push    ds
    lds     si,[bp+6]
    les     di,[bp+10]
    cld
    xor     ax,ax
    lodsb
    mov     cx,ax
    cmp     cl,0
    je      LTrim2
LTrim1:
    lodsb
    cmp     al,20h
    jne     LTrim12
    loop    LTrim1
LTrim12:
    dec     si
LTrim2:
    mov     ax,cx
    stosb
    cmp     cl,0
    je      LTrim3
rep movsb
LTrim3:    
    pop     ds
    pop     bp
    retf    4
LTrim      EndP

;Function PadR ( S : string; L : byte ) : string;
PadR       Proc      far
    push    bp
    mov     bp,sp
    push    ds
    lds     si,[bp+8]
    les     di,[bp+12]
    cld
    push    di
    push    si
    xor     ax,ax
    lodsb
    mov     cx,ax
    stosb
    rep     movsb
    pop     si
    lodsb
    xor     cx,cx
    mov     cl,[bp+6]
    cmp     cl,al
    jna     PadROK
    push    cx
    sub     cx,ax
    mov     ax,0020h
    rep     stosb
    pop     ax
    pop     di
    stosb
    jmp     PadREx
PadROK:
    pop     di
PadREx:
    pop     ds
    pop     bp
    retf    6
PadR         EndP

;Function PadL ( S : string; L : byte ) : string;
PadL       Proc      far
    push    bp
    mov     bp,sp
    push    ds
    xor     cx,cx
    mov     cl,[bp+6]
    lds     si,[bp+8]
    les     di,[bp+12]
    cld
    lodsb
    cmp     al,cl
    jnb     PadLNoAdd
    mov     bl,al
    mov     al,cl
    stosb
    sub     cl,bl
    mov     al,20h
rep stosb
    mov     cl,bl
    jmp     PadLCopyStr
PadLNoAdd:
    mov     cl,al
    stosb
PadLCopyStr:
rep movsb    
    pop     ds
    pop     bp
    retf    6
PadL         EndP

;Function UpCase ( C : char ) : char;
UpCase         Proc      far
      push  bp
      mov   bp,sp
      mov   al,[bp+6]
      cmp   al,61h
      jb    UpCaseEx
      cmp   al,7Ah
      ja    UpCaseL1
      sub   ax,20h
      jmp   UpCaseEx
UpCaseL1:
      cmp   al,0A0h
      jb    UpCaseEx
      cmp   al,0AFh
      ja    UpCaseL2
      sub   ax,20h
      jmp   UpCaseEx
UpCaseL2:
      cmp   al,0E0h
      jb    UpCaseEx
      cmp   al,0EFh
      ja    UpCaseEx
      sub   al,50h
UpCaseEx:
      pop   bp
      retf  2
UpCase        EndP

;Function Replicate ( C : char; L : byte ) : string;
Replicate       Proc       far
      push    bp
      mov     bp,sp
      xor     cx,cx
      mov     cl,[bp+6]
      les     di,[bp+10]
      cld
      mov     al,cl
      stosb
      mov     al,[bp+8]
rep   stosb
      pop     bp
      retf    4
Replicate       EndP

;Functon UpperCase ( S : string ) : string;
UpperCase       Proc        far
      push    bp
      mov     bp,sp
      push    ds
      lds     si,[bp+6]
      les     di,[bp+10]
      cld
      lodsb
      xor     cx,cx
      mov     cl,al
      stosb
      cmp     cx,0
      je      UpperCaseExit
UpperCaseL1:
      lodsb
      cmp     al,61h
      jb      UpperCaseL10
      cmp     al,7Ah
      ja      UpperCaseL2
      xor     al,20h
      jmp     UpperCaseL10
UpperCaseL2:
      cmp     al,0A0h
      jb      UpperCaseL10
      cmp     al,0AFh
      ja      UpperCaseL3
      xor     al,20h
      jmp     UpperCaseL10
UpperCaseL3:
      cmp     al,0E0h
      jb      UpperCaseL10
      cmp     al,0EFh
      ja      UpperCaseL10
      xor     al,70h
UpperCaseL10:
      stosb
      loop    UpperCaseL1
UpperCaseExit:
      pop     ds
      pop     bp
      retf    4
UpperCase       EndP

;Functon LowerCase ( S : string ) : string;
LowerCase       Proc        far
      push    bp
      mov     bp,sp
      push    ds
      lds     si,[bp+6]
      les     di,[bp+10]
      cld
      lodsb
      xor     cx,cx
      mov     cl,al
      stosb
      cmp     cx,0
      je      LowerCaseExit
LowerCaseL1:
      lodsb
      cmp     al,41h
      jb      LowerCaseL10
      cmp     al,5Ah
      ja      LowerCaseL2
      or      al,20h
      jmp     LowerCaseL10
LowerCaseL2:
      cmp     al,80h
      jb      LowerCaseL10
      cmp     al,8Fh
      ja      LowerCaseL3
      or      al,20h
      jmp     LowerCaseL10
LowerCaseL3:
      cmp     al,90h
      jb      LowerCaseL10
      cmp     al,9Fh
      ja      LowerCaseL10
      xor     al,70h
LowerCaseL10:
      stosb
      loop    LowerCaseL1
LowerCaseExit:
      pop     ds
      pop     bp
      retf    4
LowerCase       EndP


; Procedure StrToComp ( S : string; var Val : comp );
StrToComp      Proc       far
  push   bp
  mov    bp,sp
  sub    sp,2
  mov    byte ptr [bp-2],0
  push   ds
  lds    si,[bp+10]
  les    di,[bp+6]
  cld

  mov    cx,4                  ; Set Val:=0
  xor    ax,ax
  push   di
  rep    stosw

  pop    di
  lodsb
  mov    cx,ax
  cmp    cx,0
  jne    StrToComp_Blank
  jmp    StrToComp_Ex

StrToComp_Blank:
  cmp    byte ptr [si],' '     ; Remove header blanks
  jne    StrToComp_Cont
  inc    si
  cmp    cx,1
  je     StrToComp_Ex
  loop   StrToComp_Blank
StrToComp_Cont:

  mov    bx,10

  cmp    byte ptr [si],'-'     ; Check if negative
  jne    StrToComp_Pr
  mov    byte ptr [bp-2],1
  inc    si
  dec    cx
  cmp    cx,0
  je     StrToComp_Ex

StrToComp_L:
  cmp    byte ptr [si],' '     ; Do not proceed blanks
  jne    StrToComp_L2
  inc    si
  cmp    cx,1
  je     StrToComp_Neg
  loop   StrToComp_L
StrToComp_L2:

  push   di                    ; Multiply by 10
  push   cx

  mov    ax,es:[di]
  mul    bx
  stosw
  mov    cx,dx

  mov    ax,es:[di]
  mul    bx
  add    ax,cx
  adc    dx,0
  stosw
  mov    cx,dx

  mov    ax,es:[di]
  mul    bx
  add    ax,cx
  adc    dx,0
  stosw
  mov    cx,dx

  mov    ax,es:[di]
  mul    bx
  add    ax,cx
  stosw

  pop    cx
  pop    di

StrToComp_Pr:
  xor    ax,ax                 ; Proceed one character
  lodsb
  sub    al,'0'
  add    es:[di],ax
  xor    ax,ax
  adc    es:[di+2],ax
  adc    es:[di+4],ax
  adc    es:[di+6],ax
  loop   StrToComp_L

StrToComp_Neg:
  cmp    byte ptr [bp-2],1     ; If negative then change sign
  jne    StrToComp_Ex
  les    di,[bp+6]
  mov    cx,4
  clc
StrToComp_L1:
  mov    ax,0
  sbb    ax,es:[di]
  stosw
  loop   StrToComp_L1

StrToComp_Ex:
  pop    ds
  mov    sp,bp
  pop    bp
  retf
StrToComp     EndP

End

