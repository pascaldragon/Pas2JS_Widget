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

type

  TNotifyWebSocketMessage = procedure(aSender: TObject; aData: String) of object;
  TNotifyWebSocketBinaryMessage = procedure(aSender: TObject; aData: TBytes) of object;
  TNotifyWebSocketClose = procedure(aSender: TObject; aCode: Cardinal; aReason: String) of object;

  { TCustomWebSocketClient }

  TCustomWebSocketClient = class(TComponent)
  private
    fOnBinaryMessage: TNotifyWebSocketBinaryMessage;
    fOnClose: TNotifyWebSocketClose;
    fOnError: TNotifyEvent;
    fOnMessage: TNotifyWebSocketMessage;
    fOnOpen: TNotifyEvent;
    fUrl: String;
  public
    property Url: String read fUrl write fUrl;
    property OnBinaryMessage: TNotifyWebSocketBinaryMessage read fOnBinaryMessage write fOnBinaryMessage;
    property OnClose: TNotifyWebSocketClose read fOnClose write fOnClose;
    property OnError: TNotifyEvent read fOnError write fOnError;
    property OnMessage: TNotifyWebSocketMessage read fOnMessage write fOnMessage;
    property OnOpen: TNotifyEvent read fOnOpen write fOnOpen;
  end;

implementation

end.
