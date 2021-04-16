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

initialization
  RegisterInitComponentHandler(TComponent, @InitResourceComponent);
end.

