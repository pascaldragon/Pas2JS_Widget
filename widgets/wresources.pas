{
 /***************************************************************************
                                wresources.pas
                                --------------

                   Initial Revision : Mon Jan 13 CST 2020

 ***************************************************************************/

 *****************************************************************************
  This file is part of the Web Component Library (WCL)

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}
unit WResources;

{$mode objfpc}{$H+}

interface

uses
  Classes;

function InitResourceComponent(Instance: TComponent;
  RootAncestor: TClass):Boolean;
function ConvertForm(AData: string): string;

implementation

uses
  Web, SysUtils, p2jsres,
  WCLStrConsts;

function InitResourceComponent(Instance: TComponent; RootAncestor: TClass
  ): Boolean;

  function InitComponent(ClassType: TClass): Boolean;
  var
    data, ResName: String;
    Stream: TStream;
    BinStream: TMemoryStream;
    Reader: TReader;
    info: TResourceInfo;
  begin
    Result := False;
    if (ClassType = TComponent) or (ClassType = RootAncestor) then
      Exit;
    if Assigned(ClassType.ClassParent) then
      Result := InitComponent(ClassType.ClassParent);

    Stream := nil;
    //ResName := ClassType.ClassName;
    ResName := ClassType.UnitName;

    if not GetResourceInfo(ResName, info) then
      Exit;

    data := window.atob(info.data);
    data := ConvertForm(data);
    if data <> '' then
      Stream := TStringStream.Create(data);

    if not Assigned(Stream) then
      Exit;

    try
      try
        BinStream := TMemoryStream.Create;
        try
          ObjectTextToBinary(Stream, BinStream);

          BinStream.Position := 0;

          Reader := TReader.Create(BinStream);
          try
            Reader.ReadRootComponent(Instance);
          finally
            Reader.Free;
          end;
        finally
          BinStream.Free;
        end;
      except
        on E: Exception do begin
          Writeln(Format(rsFormStreamingError,[ClassType.ClassName,E.Message]));
          raise;
        end;
      end;
    finally
      Stream.Free;
    end;
    Result := True;
  end;

begin
  if Instance.ComponentState * [csLoading, csInline] <> [] then begin
    // global loading not needed
    Result := InitComponent(Instance.ClassType);
  end else
    try
      //BeginGlobalLoading;
      Result := InitComponent(Instance.ClassType);
      //NotifyGlobalLoading;
    finally
      //EndGlobalLoading;
    end;
end;

function ConvertForm(AData: string): string;

  function StrCursorToNumber(AValue: string): string;
  begin
    case AValue of
      'crDefault': Result := '0';
      'crNone': Result := '-1';
      'crCross': Result := '-3';
      'crIBeam': Result := '-4';
      'crSize': Result := '-22';
      'crSizeNESW': Result := '-6';
      'crSizeNS': Result := '-7';
      'crSizeNWSE': Result := '-8';
      'crSizeWE': Result := '-9';
      'crSizeNW': Result := '-23';
      'crSizeN': Result := '-24';
      'crSizeNE': Result := '-25';
      'crSizeW': Result := '-26';
      'crSizeE': Result := '-27';
      'crSizeSW': Result := '-28';
      'crSizeS': Result := '-29';
      'crSizeSE': Result := '-30';
      'crHourGlass': Result := '-11';
      'crNoDrop': Result := '-13';
      'crHSplit': Result := '-14';
      'crVSplit': Result := '-15';
      'crSQLWait': Result := '-17';
      'crNo': Result := '-18';
      'crAppStart': Result := '-19';
      'crHelp': Result := '-20';
      'crHandPoint': Result := '-21';
    else
      Result := '0';
    end;
  end;

var
  strList: TStringList;
  i: integer;
  str: string;
begin
  strList := TStringList.Create;
  try
    strList.Text := AData;
    for i := 0 to strList.Count - 1 do
      if Pos('Cursor = ', strList[i]) > 0 then
      begin
        str := trim(copy(strList[i], Pos('Cursor = ', strList[i]) + 8, Length(strList[i])));
        strList[i] := StringReplace(strList[i], str, StrCursorToNumber(str), [rfReplaceAll]);
      end;
    str := strList.Text;
  finally
    strList.Free;
  end;
  Result := str;
end;

initialization
  RegisterInitComponentHandler(TComponent, @InitResourceComponent);
end.

