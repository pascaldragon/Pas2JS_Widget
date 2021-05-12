{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit WCLDsgn;

{$warn 5023 off : no warning about unused units}
interface

uses
  BtnCtrls, DataGrid, DttCtrls, NumCtrls, WebCtrls, Pas2JS_IDE_Descriptor, 
  websocket, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('WebCtrls', @WebCtrls.Register);
  RegisterUnit('Pas2JS_IDE_Descriptor', @Pas2JS_IDE_Descriptor.Register);
end;

initialization
  RegisterPackage('WCLDsgn', @Register);
end.
