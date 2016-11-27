{$I-}
{*****************************************************************************
*                       Библиотека для работы с DOS.                         *
*                   Автор : Сергей Поляков, (c)  1993 г.                     *
*             Транслятор : Turbo-Pascal 7.0 (c) Borland Int.                 *
******************************************************************************}

Unit SP_DOS;

Interface

Type MCB_record = record
                    MCB_type  : char;
                    MCB_owner : word;
                    MCB_size  : word
                  end;

Type FindFileRecord = record
                       Disk       : byte;
                       Dummy1     : array[0..11] of byte;
                       DirRec     : word;
                       DirClustLo : word;
                       DirClustHi : word;
                       Dummy2     : word;
                       Attr       : byte;
                       Time       : word;
                       Date       : word;
                       Size       : longint;
                       Name       : array[1..13] of char
                     end;
     FindFileRecordPtr = ^FindFileRecord;

Type BootRecord = record
                    Jump              : byte;
                    JumpAddress       : word;
                    Version           : array[1..8] of char;
                    BytesPerSector    : word;
                    SectorsPerCluster : byte;
                    ReservedSectors   : word;
                    FATCount          : byte;
                    RootDirectorySize : word;
                    TotalSectorCount  : word;
                    Media             : byte;
                    SectorsPerFAT     : word;
                    SectorsPerTrack   : word;
                    HeadCount         : word;
                    HiddenSectorsLo   : word;
                    HiddenSectorsHi   : word;
                    LongTotalSectors  : longint;
                    PhisicalDriveNumb : byte;
                    ByteReserved      : byte;
                    ExtendedSignature : byte; {29h}
                    VolumeSerialNumb  : longint;
                    VolumeLabel       : array[1..$0B] of char;
                    Reserved          : array[1..8] of char;
                    Code              : array[1..512-62] of byte;
                  end;
     BootRecordPtr = ^BootRecord;

Type DirectoryEntry = record
                        Name      : array[1..8] of char;
                        Extention : array[1..3] of char;
                        Attribute : byte;
                        Reserved  : array[1..$0A] of byte;
                        Time      : word;
                        Date      : word;
                        Cluster   : word;
                        Size      : longint
                      end;

Type DOSVariableBlock = record
                          BaseMCB              : word;
                          FirstDPB             : pointer;
                          FirstSysFileTable    : pointer;
                          ClockDriverAddress   : pointer;
                          CONDriverAddress     : pointer;
                          MaxSectSizeForDevice : word;
                          CashHeadBuffAddress  : pointer;
                          DefaultDirListAddr   : pointer;
                          FCBFileTableAddress  : pointer;
                          FCBFileTableSize     : word;
                          DriveCount           : byte;
                          LastDrive            : byte;
                        end;

Type ExeFileHeader = record
                       Signature          : word;
                       PartialPageLength  : word;
                       PageCount          : word;
                       ReloTableItemCount : word;
                       HeaderSize         : word;
                       MinimumMemory      : word;
                       MaximumMemory      : word;
                       ReloSS             : word;
                       ExeSP              : word;
                       CheckSum           : word;
                       EntryIP            : word;
                       ReloEntryCS        : word;
                       FirstReloItemOffs  : word;
                       OverlayNumber      : word
                     end;

Var DosVariableBlockPtr : ^DosVariableBlock;

Function FindFirstFile ( Mask : string; Attrib : byte; var FindRecord : FindFileRecord ) : boolean;

Function FindNextFile : boolean;

Function ASCIIZtoPascal ( var ASCIIZ ) : string;

Function CurrentDirectory : string;

Function ChangeDirectory ( Dir : string ) : boolean;

Function MaxDiskCount : byte;

Function FDateToLongint ( Date : word ) : longint;

Function FTimeToLongint ( Time : word ) : longint;

Function SystemDate : longint;

Function SystemTime : longint;

Function TimerTickCount : longint;

{ Функция возвращает размер свободного дискового пространства в байтах
      Disk = 0  - текущий диск
      Disk = 1  - диск A:
      Disk = 2  - диск B:
      Disk = 3  - диск C:   и т.д. }
Function DiskFreeSize ( Disk : byte ) : longint;

{ Функция возвращает true, если файл FName существует и false если нет }
Function FileExists ( FName : string ) : boolean;

{ Функция возвращает размер файла в байтах и 0, если файл не найден }
Function SizeOfFile ( FName : string ) : longint;

Function TemporaryFileName ( Path : string ) : string;

Function FileNameExtention ( Path : string ) : string;

Function FileNameOnly ( Path : string ) : string;

Function NameWithoutExtention ( Path : string ) : string;

Function PathFromFileName ( FName : string ) : string;

Function RenameOrMove ( var F : file; FName : string ) : integer;

Function ReadBootSector ( Drive : char; Buffer : BootRecordPtr ) : word;

Function ClusterToSector ( Cluster : word; Disk : char ) : longint;

Function DirectorySector ( Path : string ) : longint;

Function GetDefence ( FileName : string; var Sector : longint; var Disk : char ) : boolean;

Function CreateDirectory ( Path : string ) : boolean;

Function FirstMemoryControlBlock : pointer;

Function NextMemoryControlBlock ( P : pointer ) : pointer;

Function CutLastBlock ( Size : word ) : pointer;

Function CopyFile ( OldFile, NewFile : string ) : boolean;

Procedure ReplaceInFile ( FileName,S1,S2 : string );

Function EraseFile ( FileName : string ) : boolean;

Function ReadEntryPoint ( FileName : string;
                          Buffer   : pointer;
                          Count    : word ) : boolean;

Procedure ReadAbsoluteSector ( Drive,Head,Track,Sector : byte; Buffer : pointer );

Function PartitionControlSum : word;

Function EnvironmentString ( Name : string ) : string;

Function EnvironmentStr ( Number : word ) : string;

Function FileDate ( FileName : string ) : longint;

Function FileTime ( FileName : string ) : longint;

Implementation

Var FindFile_DTA_Address : pointer;

Function FindFirstFile ( Mask : string; Attrib : byte; var FindRecord : FindFileRecord ) : boolean;
begin
  FindFile_DTA_Address:=Addr(FindRecord);
  Asm
    push  ds
    lds   dx,FindRecord
    mov   ax,1A00h
    int   21h
    lea   dx,Mask
    push  ss
    pop   ds
    xor   ax,ax
    mov   si,dx
    cld
    lodsb
    inc   dx
    add   si,ax
    mov   al,0
    mov   ds:[si],al
    xor   cx,cx
    mov   cl,Attrib
    mov   ax,4E00h
    int   21h
    jc    @L1
    mov   @Result,1
    jmp   @L2
@L1:
    mov   @Result,0
@L2:
    pop   ds
  end
end;

Function FindNextFile : boolean;
begin
  Asm
    push   ds
    lds    dx,FindFile_DTA_Address
    mov    ax,4F00h
    int    21h
    jc     @L1
    mov    @Result,1
    jmp    @L2
@L1:
    mov    @Result,0
@L2:
    pop    ds
  end
end;

Function ASCIIZtoPascal ( var ASCIIZ ) : string;
var S : string;
    A : array[0..$FF] of char absolute ASCIIZ;
    i : word;
begin
  S:='';
  i:=0;
  While (i<$FF) and (A[i]<>#0) do
    begin
      S:=S+A[i];
      Inc ( i )
    end;
  ASCIIZtoPascal:=S
end;

Function CurrentDirectory : string;
var S  : string[64];
    OK : boolean;
    D  : byte;
begin
  OK:=false;
  Asm
    push   ds
    lea    si,S[1]
    push   ss
    pop    ds
    xor    dx,dx
    mov    ax,4700h
    int    21h
    jc     @L
    mov    OK,1
    cld
    push   ds
    pop    es
    mov    di,si
    mov    cx,64
    repnz  scasb
    sub    di,si
    mov    ax,di
    dec    ax
    mov    ds:[si-1],al
    mov    ax,1900h
    int    21h
    mov    D,al
@L:
    pop    ds
  end;
  If OK then
    CurrentDirectory:=char(D+ord('A'))+':'+'\'+S
   else
    CurrentDirectory:=''
end;

Function ChangeDirectory ( Dir : string ) : boolean;
begin
  Asm
    push   ds
    lea    dx,Dir
    mov    si,dx
    push   ss
    pop    ds
    xor    ax,ax
    cld
    lodsb
    cmp    al,2
    jne    @L000
    mov    cl,[si+1]
    cmp    cl,':'
    je     @L00
@L000:
    add    si,ax
    mov    ds:[si],ah
    inc    dx
    mov    ax,3B00h
    int    21h
    jc     @L1
    mov    si,dx
    mov    al,ds:[si+1]
    cmp    al,':'
    jne    @L1
@L00:
    mov    al,ds:[si]
    cmp    al,'a'
    jb     @L0
    cmp    al,'z'
    ja     @L0
    sub    al,'a'-'A'
@L0:
    sub    al,'A'
    mov    dl,al
    mov    ax,1900h
    int    21h
    cmp    al,dl
    je     @L3
    mov    ax,0E00h
    int    21h
@L3:
    mov    @Result,1
    jmp    @L2
@L1:
    mov    @Result,0
@L2:
    pop    ds
  end
end;

Function MaxDiskCount : byte;
begin
  Asm
    mov    ax,1900h
    int    21h
    mov    dl,al
    mov    ax,0E00h
    int    21h
    mov    @Result,al
  end
end;

Function FDateToLongint ( Date : word ) : longint;
var MyDate : longint;
begin
  MyDate:=(Date and $FE00) shr 9;
  FDateToLongint:=(MyDate+1980)*10000+((Date and $01E0) shr 5)*100+(Date and $001F)
end;

Function FTimeToLongint ( Time : word ) : longint;
var MyTime : longint;
begin
  MyTime:=(Time and $F800) shr 11;
  FTimeToLongint:=MyTime*10000+((Time and $07E0) shr 5)*100+(Time and $001F)
end;

Function FileExists ( FName : string ) : boolean;
var FindFile : FindFileRecord;
begin
  If FindFirstFile(FName,$23,FindFile) then  FileExists:=true  else  FileExists:=false
end;


Function DiskFreeSize ( Disk : byte ) : longint; assembler;
var DiskS : record
              DLo : word;
              DHi : word
            end;
    Size  : longint absolute DiskS;
Asm
  mov   ax,3600h
  mov   dl,Disk
  int   21h
  cmp   ax,0FFFFh
  jne   @OK
  xor   ax,ax
@OK:
  mul   cx
  mul   bx
end;

Function SizeOfFile ( FName : string ) : longint;
var F : file;
begin
  Assign ( F,FName );
  ReSet ( F,1 );
  If IOResult<>0 then
    begin
      SizeOfFile:=0;
      Exit
    end;
  SizeOfFile:=FileSize(F);
  Close ( F )
end;

Procedure TranslateOneByte; assembler;
Asm
  mov    ah,al
  and    ax,0FF0h
  shr    al,1
  shr    al,1
  shr    al,1
  shr    al,1
  add    al,'0'
  cmp    al,'9'
  jna    @L1
  add    al,7
@L1:
  stosb
  mov    al,ah
  add    al,'0'
  cmp    al,'9'
  jna    @L2
  add    al,7
@L2:
  stosb
end;

Function TemporaryFileName ( Path : string ) : string;
var Arr : array[1..8] of char;
    S   : string;
    i   : byte;
begin
  If (length(Path)>2) and (not (Path[length(Path)] in ['\',':'])) then  Path:=Path+'\';
  Repeat
    Asm
      xor    ax,ax
      lea    di,Arr
      push   ss
      pop    es
      cld
      mov    ax,$2C00
      int    $21
      mov    al,ch
      call   TranslateOneByte
      mov    al,cl
      call   TranslateOneByte
      mov    al,dh
      call   TranslateOneByte
      mov    al,dl
      call   TranslateOneByte
    end;
    S:=Path;
    For i:=1 to 8 do
      S:=S+Arr[i]
  until  not FileExists(S+'.*');
  TemporaryFileName:=S
end;

Function SystemDate : longint;
var Year  : word;
    Month : byte;
    Day   : byte;
    Date  : longint;
begin
  Asm
    mov   ah,2Ah
    int   21h
    mov   Year,cx
    mov   Month,dh
    mov   Day,dl
  end;
  Date:=Year;
  SystemDate:=Date*10000+Month*100+Day
end;

Function SystemTime : longint;
var Hours   : byte;
    Minutes : byte;
    Seconds : byte;
    R       : longint;
begin
  Asm
    mov    ah,2Ch
    int    21h
    mov    Hours,ch
    mov    Minutes,cl
    mov    Seconds,dh
  end;
  R:=Hours;
  SystemTime:=R*10000+Minutes*100+Seconds
end;

Function TimerTickCount : longint; assembler;
Asm
  mov    ah,0
  int    1Ah
  mov    ax,dx
  mov    dx,cx
end;

Function FileNameExtention ( Path : string ) : string;
var i : word;
begin
  i:=length(Path);
  While (i>0) and (not (Path[i] in ['.','\',':'])) do  Dec ( i );
  If (i>0) and (Path[i]='.') then
    FileNameExtention:=Copy(Path,i+1,3)
   else
    FileNameExtention:=''
end;

Function FileNameOnly ( Path : string ) : string;
var n1,n2 : word;
begin
  n2:=length(Path);
  While (n2>0) and (not (Path[n2] in ['.','\',':'])) do  Dec ( n2 );
  If (n2>0) and (Path[n2]='.') then
    begin
      Dec ( n2 );
      n1:=n2;
      While (n1>0) and (not (Path[n1] in ['\',':'])) do  Dec ( n1 );
      Inc ( n1 )
    end
   else
    begin
      n1:=n2;
      If n1>0 then  Inc ( n1 );
      n2:=length(Path)
    end;
  If (n2>=n1) and (n1>0) then
    FileNameOnly:=Copy(Path,n1,n2-n1+1)
   else
    FileNameOnly:=''
end;

Function NameWithoutExtention ( Path : string ) : string;
var i : word;
begin
  i:=length(Path);
  While (i>0) and (not (Path[i] in ['.','\',':'])) do  Dec ( i );
  If (i>0) and (Path[i]='.') then
    NameWithoutExtention:=Copy(Path,1,i-1)
   else
    NameWithoutExtention:=Path
end;

Function PathFromFileName ( FName : string ) : string;
var i : byte;
begin
  i:=length(FName);
  While (i>0) and (not (FName[i] in ['\',':']) ) do  Dec ( i );
  PathFromFileName:=Copy(FName,1,i)
end;

Function RenameOrMove ( var F : file; FName : string ) : integer;
type BufferType = array[0..$FF00] of byte;
var IOError : integer;
    F1      : file;
    Buffer  : ^BufferType;
    R,R1    : word;
begin
  Rename ( F,FName );
  IOError:=IOResult;
  If IOError=17 then
    begin
      If MaxAvail<SizeOf(Buffer^) then
        begin
          RenameOrMove:=-1;
          Exit
        end;
      New ( Buffer );
      Reset ( F,1 );
      IOError:=IOResult;
      If IOError=0 then
        begin
          Assign ( F1,FName );
          Rewrite ( F1,1 );
          IOError:=IOResult;
          If IOError=0 then
            begin
              While not EoF(F) do
                begin
                  BlockRead ( F,Buffer^,SizeOf(Buffer^),R );
                  BlockWrite ( F1,Buffer^,R,R1 )
                end;
              IOError:=IOResult;
              Close ( F1 );
              Close ( F );
              Erase ( F )
            end
           else Close ( F );
          Dispose ( Buffer )
        end
    end;
  RenameOrMove:=IOError
end;

Function ReadBootSector ( Drive : char; Buffer : BootRecordPtr ) : word;
begin
  Drive:=char(ord(UpCase(Drive))-ord('A'));
  Asm
    push   ds
    push   bp
    mov    al,Drive
    mov    cx,1
    lds    bx,Buffer
    xor    dx,dx
    int    25h
    pop    dx
    pop    bp
    pop    ds
    jc     @Error
    mov    @Result,0
    jmp    @Exit
@Error:
    mov    @Result,ax
@Exit:
  end
end;

Function ClusterToSector ( Cluster : word; Disk : char ) : longint;
var Buffer : BootRecord;
    L      : longint;
begin
  If ReadBootSector(Disk,@Buffer)=0 then
    begin
      With Buffer do
        begin
          L:=ReservedSectors;
          L:=L+FATCount*SectorsPerFAT;
          L:=L+RootDirectorySize div (BytesPerSector div $20);
          L:=L+(Cluster-2)*SectorsPerCluster;
          ClusterToSector:=L
        end
    end
   else  ClusterToSector:=0
end;

Function DirectorySector ( Path : string ) : longint;
Var FindRecord : FindFileRecord;
    Disk       : char;
begin
  If FindFirstFile(Path,$3F,FindRecord) then
    begin
      If (length(Path)>=2) and (Path[2]=':') then
        Disk:=Path[1]
       else
        Asm
          mov    ah,19h
          int    21h
          add    al,'A'
          mov    Disk,al
        end;
      DirectorySector:=ClusterToSector(FindRecord.DirClustLo,Disk)
    end
end;

Function GetDefence ( FileName : string; var Sector : longint; var Disk : char ) : boolean;
var DirSector   : word;
    FindFile    : FindFileRecord;
    Buffer      : array[0..511] of char;
    DirEntryPtr : ^DirectoryEntry;
    D           : byte;
begin
  GetDefence:=true;
  DirSector:=DirectorySector(FileName);
  If DirSector=0 then  GetDefence:=false;
  FindFirstFile ( FileName,$3F,FindFile );
  If (length(FileName)>=2) and (FileName[2]=':') then
    D:=ord(UpCase(FileName[1]))
   else
    Asm
      mov    ah,19h
      int    21h
      add    al,'A'
      mov    D,al
    end;
  Disk:=char(D);
  D:=D-ord('A');
  If FindFile.DirRec>$10 then
    begin
      GetDefence:=false;
      Exit
    end;
  Asm
    push  ds
    push  bp
    mov   al,D
    lea   bx,Buffer
    push  ss
    pop   ds
    mov   dx,DirSector
    mov   cx,1
    int   25h
    pop   dx
    pop   bp
    pop   ds
    jnc   @OK
    mov   @Result,0
@OK:
  end;
  DirEntryPtr:=Addr(Buffer[FindFile.DirRec*$20]);
  Sector:=DirEntryPtr^.Cluster
end;

Function CreateDirectory ( Path : string ) : boolean;
var S,S1    : string;
    i       : byte;
    Disk    : byte;
    Error   : boolean;
    OldPath : string;
begin
  S:='';
  OldPath:=CurrentDirectory;
  Error:=false;
  For i:=1 to length(Path) do  If Path[i]<>' ' then  S:=S+Path[i];
  If S='' then
    begin
      CreateDirectory:=true;
      Exit
    end;
  If (length(S)>=2) and (S[2]=':') then
    begin
      Disk:=ord(UpCase(S[1]))-ord('A');
      Asm
        mov   ah,0Eh
        mov   dl,Disk
        int   21h
        mov   ah,19h
        int   21h
        cmp   al,Disk
        je    @OK
        mov   Error,1
       @OK:
    end;
    If Error then
      begin
        CreateDirectory:=false;
        ChangeDirectory ( OldPath );
        Exit
      end;
    Delete ( S,1,2 )
  end;
  i:=1;
  While i<length(S) do
    begin
      S1:='';
      Repeat
        S1:=S1+S[i];
        Inc ( i )
      until (i>length(S)) or (S[i]='\');
      Inc ( i );
      S1:=S1+#0;
      Asm
        push    ds
        push    ss
        pop     ds
        lea     dx,S1[1]
        mov     ah,3Bh
        int     21h
        jnc     @OK
        mov     ah,39h
        int     21h
        mov     ah,3Bh
        int     21h
        jnc     @OK
        mov     Error,1
       @OK:
        pop     ds
      end;
      If Error then
        begin
          CreateDirectory:=false;
          ChangeDirectory ( OldPath );
          Exit
        end
    end;
  ChangeDirectory ( OldPath );
  CreateDirectory:=true
end;

Function FirstMemoryControlBlock : pointer; assembler;
Asm
    mov    ah,52h
    int    21h
    mov    dx,es:[bx-2]
    xor    ax,ax
end;

Function NextMemoryControlBlock ( P : pointer ) : pointer;
type MCB = record
             BlockType : char;
             Owner     : word;
             Size      : word
           end;
var MCBptr : ^MCB absolute P;
begin
  If MCBptr^.BlockType<>'M' then
    begin
      NextMemoryControlBlock:=nil;
      Exit
    end;
  NextMemoryControlBlock:=Ptr(Seg(P^)+MCBptr^.Size+1,0)
end;

Function CutLastBlock ( Size : word ) : pointer;
type MCB = record
             BlockType : char;
             Owner     : word;
             Size      : word
           end;
var P  : pointer;
    P0 : ^MCB;
begin
  P:=FirstMemoryControlBlock;
  P0:=nil;
  While P<>nil do
    begin
      P0:=P;
      P:=NextMemoryControlBlock(P)
    end;
  If (P0<>nil) and (P0^.Size>Size) then
    begin
      P0^.Size:=P0^.Size-Size;
      CutLastBlock:=Ptr(Seg(P0^)+P0^.Size+1,0)
    end
   else  CutLastBlock:=nil
end;

Function CopyFile ( OldFile,NewFile : string ) : boolean;
type BufferType = array[0..$FF00] of byte;
var  Buffer : ^BufferType;
     F1,F2  : file;
     N,R    : word;
     Size   : word;
begin
  Size:=$FF00;
  CopyFile:=false;
  Assign ( F1,OldFile );
  Reset ( F1,1 );
  If IOResult<>0 then
    begin
      Exit
    end;
  Assign ( F2,NewFile );
  Rewrite ( F2,1 );
  If IOResult<>0 then
    begin
      Close ( F1 );
      Exit
    end;
  While (MaxAvail<Size) and (Size>$500) do  Size:=Size-$500;
  If MaxAvail<Size then
    begin
      Close ( F1 );
      Close ( F2 );
      Exit
    end;
  GetMem ( Buffer,Size );
  While not EoF(F1) do
    begin
      BlockRead ( F1,Buffer^,Size,N );
      If IOResult<>0 then
        begin
          FreeMem ( Buffer,Size );
          Close ( F2 );
          Close ( F1 );
          Exit
        end;
      BlockWrite ( F2,Buffer^,N,R );
      If (IOResult<>0) or (R<>N) then
        begin
          FreeMem ( Buffer,Size );
          Close ( F2 );
          Close ( F1 );
          Exit
        end;
    end;
  FreeMem ( Buffer,Size );
  Close ( F2 );
  Close ( F1 );
  CopyFile:=true
end;

Procedure ReplaceInFile ( FileName,S1,S2 : string );
type Buffer = array[0..64000] of byte;
var F    : file;
    Buff : ^Buffer;
    Ch   : char;
    i    : word;
    N    : word;
    N1   : longint;
    R    : word;
begin
  Assign ( F,FileName );
  New ( Buff );
  Reset ( F,1 );
  i:=1;
  N1:=0;
  While (not EoF(F)) and (i<=length(S1)) do
    begin
      N:=0;
      BlockRead ( F,Buff^,SizeOf(Buff^),R );
      While (i<=length(S1)) and (N<R) do
        begin
          If Buff^[N]=ord(S1[i]) then
            begin
              Inc ( i );
              Inc ( N )
            end
           else
            begin
              i:=1;
              Inc ( N )
            end
        end;
      If i<=length(S1) then  N1:=N1+N
    end;
  Dispose ( Buff );
  If i>length(S1) then
    begin
      Seek ( F,N1+N-i+1 );
      BlockWrite ( F,S2[1],length(S2) )
    end;
  Close ( F )
end;

Function EraseFile ( FileName : string ) : boolean;
var F : file;
begin
  If FileExists(FileName) then
    begin
      Assign ( F,FileName );
      Erase ( F );
      If IOResult<>0 then
        EraseFile:=false
       else
        EraseFile:=true
    end
   else
    EraseFile:=true
end;

Function ReadEntryPoint ( FileName : string;
                          Buffer   : pointer;
                          Count    : word ) : boolean;
var Header : ExeFileHeader;
    F      : file;
    R      : word;
    Offs   : longint;
begin
  ReadEntryPoint:=false;
  Assign ( F,FileName );
  Reset ( F,1 );
  If IOResult<>0 then  Exit;
  BlockRead ( F,Header,SizeOf(Header),R );
  If (IOResult<>0) or (R<>SizeOf(Header)) then  Exit;
  If Header.Signature=$5A4D then
    begin
      Offs:=Header.HeaderSize;
      Offs:=Offs*16+Header.ReloEntryCS*16+Header.EntryIP;
      Seek ( F,Offs )
    end
   else
    begin
      Seek ( F,0 )
    end;
  BlockRead ( F,Buffer^,Count,R );
  If IOResult<>0 then  Exit;
  ReadEntryPoint:=true
end;

Procedure ReadAbsoluteSector ( Drive,Head,Track,Sector : byte; Buffer : pointer ); assembler;
Asm
  mov   dl,Drive
  mov   dh,Head
  mov   ch,Track
  mov   cl,Sector
  mov   ax,0201h
  les   bx,Buffer
  int   13h
end;

Function PartitionControlSum : word;
var Buffer : array [1..512] of byte;
    i      : word;
    Sum    : word;
begin
  ReadAbsoluteSector ( $80,0,0,1,@Buffer );
  Sum:=0;
  For i:=1 to 512 do  Sum:=Sum+Buffer[i];
  PartitionControlSum:=Sum
end;

Function EnvironmentString ( Name : string ) : string;
var P  : ^char;
    W  : ^word;
    S  : string;
begin
  EnvironmentString:='';
  W:=Ptr(PrefixSeg,$2C);
  P:=Ptr(W^,0);
  While true do
    begin
      S:='';
      While not (P^ in [#0,'=']) do
        begin
          S:=S+P^;
          Inc ( P )
        end;
      If (P^='=') and (S=Name) then
        begin
          Inc ( P );
          S:='';
          While not (P^=#0) do
            begin
              S:=S+P^;
              Inc ( P )
            end;
          EnvironmentString:=S;
          break
        end;
      While P^<>#0 do
        Inc ( P );
      Inc ( P );
      If P^=#0 then  break
    end
end;

Function EnvironmentStr ( Number : word ) : string;
var P  : ^char;
    W  : ^word;
    S  : string;
    N  : word;
begin
  N:=0;
  EnvironmentStr:='';
  W:=Ptr(PrefixSeg,$2C);
  P:=Ptr(W^,0);
  While true do
    begin
      S:='';
      While not (P^ in [#0,'=']) do
        begin
          S:=S+P^;
          Inc ( P )
        end;
      Inc ( N );
      If (P^='=') and (N=Number) then
        begin
          Inc ( P );
          S:=S+'=';
          While not (P^=#0) do
            begin
              S:=S+P^;
              Inc ( P )
            end;
          EnvironmentStr:=S;
          break
        end;
      While P^<>#0 do
        Inc ( P );
      Inc ( P );
      If P^=#0 then  break
    end
end;

Function FileDate ( FileName : string ) : longint;
var FindRecord : FindFileRecord;
begin
  If FindFirstFile(FileName,$3F,FindRecord) then
    FileDate:=FDateToLongint(FindRecord.Date)
   else
    FileDate:=0
end;

Function FileTime ( FileName : string ) : longint;
var FindRecord : FindFileRecord;
begin
  If FindFirstFile(FileName,$3F,FindRecord) then
    FileTime:=FTimeToLongint(FindRecord.Time)
   else
    FileTime:=0
end;

begin
  Asm
    mov    ah,52h
    int    21h
    dec    bx
    dec    bx
    mov    ax,es
    mov    word ptr DOSVariableBlockPtr,bx
    mov    word ptr DOSVariableBlockPtr+2,ax
  end
end.
