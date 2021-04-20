{
  MIT License

  Copyright (c) 2018 Hélio S. Ribeiro and Anderson J. Gado da Silva

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
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
