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
unit ExtCtrls;

{$I pas2js_widget.inc}

interface

uses
  Classes,
  SysUtils,
  Types,
  Web,
  Graphics,
  Controls;

type

  { TCustomImage }

  TCustomImage = class(TCustomControl)
  private
    FCenter: boolean;
    FPicture: TPicture;
    FProportional: boolean;
    FStretch: boolean;
    FOnPictureChanged: TNotifyEvent;
    FStretchInEnabled: boolean;
    FStretchOutEnabled: boolean;
    FTransparent: boolean;
    FURL: String;
    procedure SetCenter(AValue: boolean);
    procedure SetPicture(AValue: TPicture);
    procedure SetProportional(AValue: boolean);
    procedure SetStretch(AValue: boolean);
    procedure SetStretchInEnabled(AValue: boolean);
    procedure SetStretchOutEnabled(AValue: boolean);
    procedure SetTransparent(AValue: boolean);
    procedure SetURL(AValue: String);
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
    function CheckChildClassAllowed(AChildClass: TClass): boolean; override;
    procedure PictureChanged(Sender: TObject); virtual;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
  public
    property Center: boolean read FCenter write SetCenter default False;
    property Picture: TPicture read FPicture write SetPicture;
    property Proportional: boolean read FProportional write SetProportional default False;
    property Stretch: boolean read FStretch write SetStretch default False;
    property StretchOutEnabled: boolean read FStretchOutEnabled write SetStretchOutEnabled default True;
    property StretchInEnabled: boolean read FStretchInEnabled write SetStretchInEnabled default True;
    property Transparent: boolean read FTransparent write SetTransparent default False;
    property URL: String read FURL write SetURL;
    property OnPictureChanged: TNotifyEvent read FOnPictureChanged write FOnPictureChanged;
  end;

  TPanelBevel = TBevelCut;
  TBevelWidth = 1..Maxint;

  { TCustomPanel }

  TCustomPanel = class(TCustomControl)
  private
    FAlignment: TAlignment;
    FBevelColor: TColor;
    FBevelInner: TPanelBevel;
    FBevelOuter: TPanelBevel;
    FBevelWidth: TBevelWidth;
    FLayout: TTextLayout;
    FWordWrap: boolean;
    procedure SetAlignment(AValue: TAlignment);
    procedure SetBevelColor(AValue: TColor);
    procedure SetBevelInner(AValue: TPanelBevel);
    procedure SetBevelOuter(AValue: TPanelBevel);
    procedure SetBevelWidth(AValue: TBevelWidth);
    procedure SetLayout(AValue: TTextLayout);
    procedure SetWordWrap(AValue: boolean);
  protected
    property Layout: TTextLayout read FLayout write SetLayout;
    property WordWrap: boolean read FWordWrap write SetWordWrap;
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
  public
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property BevelColor: TColor read FBevelColor write SetBevelColor default clDefault;
    property BevelInner: TPanelBevel read FBevelInner write SetBevelInner default bvNone;
    property BevelOuter: TPanelBevel read FBevelOuter write SetBevelOuter default bvRaised;
    property BevelWidth: TBevelWidth read FBevelWidth write SetBevelWidth default 1;
  end;

  { TCustomTimer }

  TCustomTimer = class(TComponent)
  private
    FEnabled: Boolean;
    FInterval: Cardinal;
    FTimerHandle: NativeUInt;
    FOnStartTimer: TNotifyEvent;
    FOnStopTimer: TNotifyEvent;
    FOnTimer: TNotifyEvent;
  protected
    procedure SetEnabled(AValue: Boolean); virtual;
    procedure SetInterval(AValue: Cardinal); virtual;
    procedure SetOnTimer(AValue: TNotifyEvent); virtual;
    procedure DoOnTimer; virtual;
    procedure UpdateTimer; virtual;
    procedure KillTimer; virtual;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
    property OnStartTimer: TNotifyEvent read FOnStartTimer write FOnStartTimer;
    property OnStopTimer: TNotifyEvent read FOnStopTimer write FOnStopTimer;
  end;

  { TCustomWebSocketClient }

  TOnMessage = procedure(Sender: TObject; Data: string) of object;

  TCustomWebSocketClient = class(TComponent)
  private
    FOnClose: TNotifyEvent;
    FOnError: TNotifyEvent;
    FOnMessage: TOnMessage;
    FOnOpen: TNotifyEvent;
    FUrl: String;
    FWebSocket: TJSWebSocket;
    function DoWebSocketClose(Event: TEventListenerEvent): boolean;
    function DoWebSocketError(Event: TEventListenerEvent): boolean;
    function DoWebSocketMessage(Event: TEventListenerEvent): boolean;
    function DoWebSocketOpen(Event: TEventListenerEvent): boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Send(Data: string);
    procedure Close;
  public
    property Url: String read FUrl write FUrl;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnError: TNotifyEvent read FOnError write FOnError;
    property OnMessage: TOnMessage read FOnMessage write FOnMessage;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
  end;

implementation

uses
  WCLStrConsts;

{ TCustomWebSocketClient }

function TCustomWebSocketClient.DoWebSocketMessage(Event: TEventListenerEvent
  ): boolean;
begin
  if Assigned(OnMessage) then
  begin
    if Event._type <> 'message' then
      exit;
    OnMessage(Self, string(TJSMessageEvent(event).Data));
  end;
end;

function TCustomWebSocketClient.DoWebSocketClose(Event: TEventListenerEvent): boolean;
begin
  if Assigned(OnClose) then
    OnClose(Self);
end;

function TCustomWebSocketClient.DoWebSocketError(Event: TEventListenerEvent): boolean;
begin
  if Assigned(OnError) then
    OnError(Self);
end;

function TCustomWebSocketClient.DoWebSocketOpen(Event: TEventListenerEvent): boolean;
begin
  if Assigned(OnOpen) then
    OnOpen(Self);
end;

constructor TCustomWebSocketClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCustomWebSocketClient.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TCustomWebSocketClient.Connect;
begin
  FWebSocket := TJSWebSocket.new(url);
  FWebSocket.onmessage := @DoWebSocketMessage;
  FWebSocket.onopen := @DoWebSocketOpen;
  FWebSocket.onclose := @DoWebSocketClose;
  FWebSocket.onerror := @DoWebSocketError;
end;

procedure TCustomWebSocketClient.Send(Data: string);
begin
  FWebSocket.send(Data);
end;

procedure TCustomWebSocketClient.Close;
begin
  FWebSocket.close;
end;

{ TCustomTimer }

procedure TCustomTimer.SetEnabled(AValue: Boolean);
begin
  if FEnabled = AValue then
    Exit;
  FEnabled := AValue;
  UpdateTimer;
end;

procedure TCustomTimer.SetInterval(AValue: Cardinal);
begin
  if FInterval = AValue then
    Exit;
  FInterval := AValue;
  UpdateTimer;
end;

procedure TCustomTimer.SetOnTimer(AValue: TNotifyEvent);
begin
  if FOnTimer = AValue then
    Exit;
  FOnTimer := AValue;
  UpdateTimer;
end;

procedure TCustomTimer.DoOnTimer;
begin
  if Assigned(FOnTimer) then
    FOnTimer(Self);
end;

procedure TCustomTimer.UpdateTimer;
begin
  KillTimer;
  if FEnabled and (FInterval > 0) and
      ([csLoading, csDestroying] * ComponentState = []) and Assigned(FOnTimer) then begin
    FTimerHandle := window.setInterval(procedure begin FOnTimer(Self); end, FInterval);
    if FTimerHandle = 0 then
      raise EOutOfResources.Create(rsNoTimers);
    if Assigned(FOnStartTimer) then
      FOnStartTimer(Self);
  end;
end;

procedure TCustomTimer.KillTimer;
begin
  if FTimerHandle <> 0 then begin
    window.clearInterval(FTimerHandle);
    if Assigned(FOnStopTimer) then
      FOnStopTimer(Self);
  end;
end;

procedure TCustomTimer.Loaded;
begin
  inherited Loaded;
  UpdateTimer;
end;

constructor TCustomTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  FInterval := 1000;
  FTimerHandle := 0;
end;

destructor TCustomTimer.Destroy;
begin
  KillTimer;
  inherited Destroy;
end;

{ TCustomImage }

procedure TCustomImage.SetCenter(AValue: boolean);
begin
  if (FCenter <> AValue) then
  begin
    FCenter := AValue;
    PictureChanged(Self);
  end;
end;

procedure TCustomImage.SetPicture(AValue: TPicture);
begin
  if (not FPicture.IsEqual(AValue)) then
  begin
    FPicture.Assign(AValue);
  end;
end;

procedure TCustomImage.SetProportional(AValue: boolean);
begin
  if (FProportional <> AValue) then
  begin
    FProportional := AValue;
    PictureChanged(Self);
  end;
end;

procedure TCustomImage.SetStretch(AValue: boolean);
begin
  if (FStretch <> AValue) then
  begin
    FStretch := AValue;
    PictureChanged(Self);
  end;
end;

procedure TCustomImage.SetStretchInEnabled(AValue: boolean);
begin
  if (FStretchInEnabled <> AValue) then;
  begin
    FStretchInEnabled := AValue;
    PictureChanged(Self);
  end;
end;

procedure TCustomImage.SetStretchOutEnabled(AValue: boolean);
begin
  if (FStretchOutEnabled <> AValue) then
  begin
    FStretchOutEnabled := AValue;
    PictureChanged(Self);
  end;
end;

procedure TCustomImage.SetTransparent(AValue: boolean);
begin
  if (FTransparent = AValue) then
  begin
    FTransparent := AValue;
  end;
end;

procedure TCustomImage.SetURL(AValue: String);
begin
  if FURL = AValue then
    Exit;
  FURL := AValue;
  PictureChanged(Self);
end;

procedure TCustomImage.Changed;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with HandleElement do
    begin
      /// Focus highlight
      Style.SetProperty('outline', 'none');
      /// Load image
      Style.SetProperty('background-image', Format('url(''%s'')', [FURL]));
      Style.SetProperty('background-repeat', 'no-repeat');
      /// Center
      if (FCenter) then
      begin
        Style.SetProperty('background-position', 'center  center');
      end
      else
      begin
        Style.RemoveProperty('background-position');
      end;
      /// Proportional
      if (FProportional) then
      begin
        Style.SetProperty('background-size', 'contain');
      end
      else
      /// Stretch
      if (FStretch) then
      begin
        if (FStretchInEnabled) and (FStretchOutEnabled) then
        begin
          Style.SetProperty('background-size', '100% 100%');
        end
        else
        if (FStretchInEnabled) then
        begin
          Style.SetProperty('background-size', 'auto 100%');
        end
        else
        if (FStretchOutEnabled) then
        begin
          Style.SetProperty('background-size', '100% auto');
        end;
      end
      else
      begin
        Style.SetProperty('background-size', 'auto');
      end;
    end;
  end;
end;

function TCustomImage.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('div'));
end;

{$push}
{$hints off}

function TCustomImage.CheckChildClassAllowed(AChildClass: TClass): boolean;
begin
  Result := False;
end;

{$pop}

{$push}
{$hints off}

procedure TCustomImage.PictureChanged(Sender: TObject);
begin
  Changed;
  if (Assigned(FOnPictureChanged)) then
  begin
    FOnPictureChanged(Self);
  end;
end;

{$pop}

class function TCustomImage.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 90;
  Result.Cy := 90;
end;

constructor TCustomImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPicture := TPicture.Create;
  FPicture.OnChange := @PictureChanged;
  FCenter := False;
  FProportional := False;
  FStretch := False;
  FStretchOutEnabled := True;
  FStretchInEnabled := True;
  FTransparent := False;
  BeginUpdate;
  try
    with GetControlClassDefaultSize do
    begin
      SetBounds(0, 0, Cx, Cy);
    end;
  finally
    EndUpdate;
  end;
end;

{ TCustomPanel }

procedure TCustomPanel.SetAlignment(AValue: TAlignment);
begin
  if (FAlignment <> AValue) then
  begin
    FAlignment := AValue;
    Changed;
  end;
end;

procedure TCustomPanel.SetBevelColor(AValue: TColor);
begin
  if (FBevelColor <> AValue) then
  begin
    FBevelColor := AValue;
    Changed;
  end;
end;

procedure TCustomPanel.SetBevelInner(AValue: TPanelBevel);
begin
  if (FBevelInner <> AValue) then
  begin
    FBevelInner := AValue;
    Changed;
  end;
end;

procedure TCustomPanel.SetBevelOuter(AValue: TPanelBevel);
begin
  if (FBevelOuter <> AValue) then
  begin
    FBevelOuter := AValue;
    Changed;
  end;
end;

procedure TCustomPanel.SetBevelWidth(AValue: TBevelWidth);
begin
  if (FBevelWidth <> AValue) then
  begin
    FBevelWidth := AValue;
    Changed;
  end;
end;

procedure TCustomPanel.SetLayout(AValue: TTextLayout);
begin
  if (FLayout <> AValue) then
  begin
    FLayout := AValue;
    Changed;
  end;
end;

procedure TCustomPanel.SetWordWrap(AValue: boolean);
begin
  if (FWordWrap <> AValue) then
  begin
    FWordWrap := AValue;
    Changed;
  end;
end;

procedure TCustomPanel.Changed;
var
  VTopColor: TColor;
  VBottomColor: TColor;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with HandleElement do
    begin
      /// Bevel/Border
      if (FBevelOuter = bvNone) then
      begin
        Style.RemoveProperty('border-width');
        Style.RemoveProperty('border-left-color');
        Style.RemoveProperty('border-left-style');
        Style.RemoveProperty('border-top-color');
        Style.RemoveProperty('border-top-style');
        Style.RemoveProperty('border-right-color');
        Style.RemoveProperty('border-right-style');
        Style.RemoveProperty('border-bottom-color');
        Style.RemoveProperty('border-bottom-style');
      end
      else
      begin
        if (FBevelColor = clDefault) then
        begin
          case FBevelOuter of
            bvLowered:
            begin
              VTopColor := clGray; /// dark
              VBottomColor := clWhite;
            end;
            bvRaised:
            begin
              VTopColor := clWhite;
              VBottomColor := clGray; /// dark
            end;
            else
            begin
              VTopColor := Self.Color;
              VBottomColor := Self.Color;
            end;
          end;
        end
        else
        begin
          VTopColor := FBevelColor;
          VBottomColor := FBevelColor;
        end;
        Style.SetProperty('border-width', IntToStr(FBevelWidth) + 'px');
        Style.SetProperty('border-style', 'solid');
        Style.SetProperty('border-left-color', JSColor(VTopColor));
        Style.SetProperty('border-top-color', JSColor(VTopColor));
        Style.SetProperty('border-right-color', JSColor(VBottomColor));
        Style.SetProperty('border-bottom-color', JSColor(VBottomColor));
      end;
      /// Focus highlight
      Style.SetProperty('outline', 'none');
      /// Prevent text selection
      Style.SetProperty('user-select', 'none');
      Style.SetProperty('-moz-user-select', 'none');
      Style.SetProperty('-ms-user-select', 'none');
      Style.SetProperty('-khtml-user-select', 'none');
      Style.SetProperty('-webkit-user-select', 'none');
    end;
  end;
end;

function TCustomPanel.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('div'));
end;

class function TCustomPanel.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 170;
  Result.Cy := 50;
end;

constructor TCustomPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlignment := taCenter;
  FBevelColor := clDefault;
  FBevelOuter := bvRaised;
  FBevelInner := bvNone;
  FBevelWidth := 1;
  FLayout := tlCenter;
  FWordWrap := False;
  BeginUpdate;
  try
    TabStop := False;
    with GetControlClassDefaultSize do
    begin
      SetBounds(0, 0, Cx, Cy);
    end;
  finally
    EndUpdate;
  end;
end;

end.
