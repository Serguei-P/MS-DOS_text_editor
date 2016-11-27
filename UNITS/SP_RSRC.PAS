Unit SP_Rsrc;

Interface

Var MenuNAttr       : byte;
    MenuHAttr       : byte;
    MenuMAttr       : byte;
    MenuDAttr       : byte;
    MenuStatAttr    : byte;
    ClockAttr       : byte;
    DeskTopAttr     : byte;
    NormAttr        : byte;
    NormDisableAttr : byte;
    FieldAttr       : byte;
    HighAttr        : byte;
    AltAttr         : byte;
    AltFieldAttr    : byte;
    MarkAttr        : byte;
    StornoAttr      : byte;
    AltStornoAttr   : byte;
    BlueFormAttr    : byte;
    ShowRAMAttr     : byte;
    ErrorAttr       : byte;     { Цвет сообщений об ошибке }
    ButtonAttr      : byte;     { Цвет экранной "кнопки" }
    StatusTextAttr  : byte;     { Цвет нижней строки экрана }
    StatusKeyAttr   : byte;     { Цвет названия клавиши в нижней строке экрана }
    WaitMessageAttr : byte;     { Цвет сообщения об ошибке }
    PrinterMessAttr : byte;
    PrinterHighAttr : byte;

Procedure SetColorDisplay;

Procedure SetMonoDisplay;

Implementation

Procedure SetColorDisplay;
begin
  MenuNAttr:=$70;
  MenuHAttr:=$47;
  MenuMAttr:=$07;
  MenuDAttr:=$73;
  MenuStatAttr:=$30;
  ShowRAMAttr:=$30;
  StatusTextAttr:=$30;
  StatusKeyAttr:=$34;
  ClockAttr:=$30;
  DeskTopAttr:=$70;
  NormAttr:=$70;
  NormDisableAttr:=$73;
  FieldAttr:=$71;
  HighAttr:=$47;
  AltAttr:=$30;
  AltFieldAttr:=$31;
  WaitMessageAttr:=$47;
  ButtonAttr:=$20;
  ErrorAttr:=$4F;
  PrinterMessAttr:=$30;
  PrinterHighAttr:=$47;
  MarkAttr:=$17;
  StornoAttr:=$74;
  AltStornoAttr:=$34;
  BlueFormAttr:=$17
end;

Procedure SetMonoDisplay;
begin
  MenuNAttr:=$70;
  MenuHAttr:=$07;
  MenuMAttr:=$07;
  MenuDAttr:=$70;
  MenuStatAttr:=$07;
  ShowRAMAttr:=$07;
  StatusTextAttr:=$07;
  StatusKeyAttr:=$0F;
  ClockAttr:=$07;
  DeskTopAttr:=$07;
  NormAttr:=$07;
  NormDisableAttr:=$07;
  FieldAttr:=$0F;
  HighAttr:=$70;
  AltAttr:=$07;
  AltFieldAttr:=$0F;
  ButtonAttr:=$0F;
  WaitMessageAttr:=$70;
  ErrorAttr:=$0F;
  PrinterMessAttr:=$07;
  PrinterHighAttr:=$70;
  MarkAttr:=$70;
  StornoAttr:=$0F;
  AltStornoAttr:=$0F;
  BlueFormAttr:=AltAttr
end;

end.