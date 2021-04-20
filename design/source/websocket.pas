{
 /***************************************************************************
                                websocket.pas
                                -------------

                   Initial Revision : Wed Apr 20 CST 2021

 ***************************************************************************/

 *****************************************************************************
  This file is part of the Web Component Library (WCL)

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}
unit websocket;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  CONNECTING = 0;
  Open = 1;
  CLOSING = 2;
  CLOSED = 3;


type

  TOnMessage = procedure(Sender: TObject; Data: string) of object;

  { TCustomWebSocketClient }

  TCustomWebSocketClient = class(TComponent)
  private
    FOnClose: TNotifyEvent;
    FOnError: TNotifyEvent;
    FOnMessage: TOnMessage;
    FOnOpen: TNotifyEvent;
    FUrl: string;
    function GetUrl: string;
  public
    constructor Create(AOwner: TComponent); override;
    // property BufferedAmount
    // property Extensions
    // property Protocol
    // property
    procedure Close;
    procedure Send(Data: string);
  public
    // property BinaryType
    property Url: string read FUrl write FUrl;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnError: TNotifyEvent read FOnError write FOnError;
    property OnMessage: TOnMessage read FOnMessage write FOnMessage;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
  end;

implementation

{ TCustomWebSocket }

function TCustomWebSocketClient.GetUrl: string;
begin

end;

constructor TCustomWebSocketClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TCustomWebSocketClient.Close;
begin

end;

procedure TCustomWebSocketClient.Send(Data: string);
begin

end;

end.
