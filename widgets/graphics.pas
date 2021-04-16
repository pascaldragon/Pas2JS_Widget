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
unit Graphics;

{$I pas2js_widget.inc}

interface

uses
  Classes,
  SysUtils,
  Types,
  Web;

type
  TColor = LongInt;

  TFontCharSet = 0..255;
  TFontName = string;
  TFontStyle = (fsBold, fsItalic, fsUnderline, fsStrikeOut);
  TFontStyles = set of TFontStyle;

  TTextLayout = (tlTop, tlCenter, tlBottom);

  TPenStyle = (psSolid, psDash, psDot, psDashDot, psDashDotDot, psInsideFrame, psPattern, psClear);
  TPenStyleSet = set of TPenStyle;

  TBrushStyle = (bsSolid, bsClear, bsHorizontal, bsVertical, bsFDiagonal, bsBDiagonal, bsCross, bsDiagCross, bsImage, bsPattern);

  { TFont }

  TFont = class(TPersistent)
  private
    FCharSet: TFontCharSet;
    FColor: TColor;
    FName: string;
    FSize: NativeInt;
    FStyle: TFontStyles;
    FUpdateCount: NativeInt;
    FOnChange: TNotifyEvent;
    function GetHeight: NativeInt;
    procedure SetCharSet(AValue: TFontCharSet);
    procedure SetColor(AValue: TColor);
    procedure SetHeight(AValue: NativeInt);
    procedure SetName(AValue: string);
    procedure SetSize(AValue: NativeInt);
    procedure SetStyle(AValue: TFontStyles);
  protected
    procedure Changed; virtual;
  public
    constructor Create; reintroduce;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    function IsEqual(AFont: TFont): boolean; virtual;
    function TextExtent(const AText: string): TSize; virtual;
    procedure TextSize(const AText: string; var W, H: NativeInt); virtual;
    function TextHeight(const AText: string): NativeInt; virtual;
    function TextWidth(const AText: string): NativeInt; virtual;
  published
    property CharSet: TFontCharSet read FCharSet write SetCharSet;
    property Color: TColor read FColor write SetColor;
    property Height: NativeInt read GetHeight write SetHeight;
    property Name: string read FName write SetName;
    property Size: NativeInt read FSize write SetSize;
    property Style: TFontStyles read FStyle write SetStyle;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TPen }

  TPen = class(TPersistent)
  private
    FColor: TColor;
    FStyle: TPenStyle;
    FWidth: NativeInt;
    FUpdateCount: NativeInt;
    FOnChange: TNotifyEvent;
    procedure SetColor(AValue: TColor);
    procedure SetStyle(AValue: TPenStyle);
    procedure SetWidth(AValue: NativeInt);
  protected
    procedure Changed; virtual;
  public
    constructor Create; reintroduce;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
  published
    property Color: TColor read FColor write SetColor;
    property Style: TPenStyle read FStyle write SetStyle;
    property Width: NativeInt read FWidth write SetWidth;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TBrush }

  TBrush = class(TPersistent)
  private
    FColor: TColor;
    FStyle: TBrushStyle;
    FUpdateCount: NativeInt;
    FOnChange: TNotifyEvent;
    procedure SetColor(AValue: TColor);
    procedure SetStyle(AValue: TBrushStyle);
  protected
    procedure Changed; virtual;
  public
    constructor Create; reintroduce;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
  published
    property Color: TColor read FColor write SetColor;
    property Style: TBrushStyle read FStyle write SetStyle;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TPicture }

  TPicture = class(TPersistent)
    { TODO: Load and save methods }
  private
    FData: string;
    FUpdateCount: NativeInt;
    FOnChange: TNotifyEvent;
    procedure SetData(AValue: string);
  protected
    procedure Changed; virtual;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    function IsEqual(APicture: TPicture): boolean; virtual;
  published
    property Data: string read FData write SetData;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TCanvas }

  TCanvas = class(TPersistent)
  private
    FBrush: TBrush;
    FFont: TFont;
    FPen: TPen;
    FUpdateCount: NativeInt;
    FOnChange: TNotifyEvent;
  protected
    FCanvasElement: TJSHTMLCanvasElement;
    FContextElement: TJSCanvasRenderingContext2D;
  protected
    procedure PrepareStyle; virtual;
    procedure PrepareText; virtual;
    procedure Changed; virtual;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    procedure Clear; virtual;
    procedure FillRect(const ARect: TRect); virtual; overload;
    procedure FillRect(const ALeft, ATop, AWidth, AHeight: double); virtual; overload;
    procedure LineTo(X, Y: double); virtual;
    procedure MoveTo(X, Y: double); virtual;
    procedure Rectangle(const ARect: TRect); virtual; overload;
    procedure Rectangle(const ALeft, ATop, AWidth, AHeight: double); virtual; overload;
    procedure TextOut(X, Y: double; const AText: string); virtual;
    function TextExtent(const AText: string): TSize; virtual;
    function TextHeight(const AText: string): NativeInt; virtual;
    function TextWidth(const AText: string): NativeInt; virtual;
    property CanvasElement: TJSHTMLCanvasElement read FCanvasElement;
    property ContextElement: TJSCanvasRenderingContext2D read FContextElement;
  published
    property Brush: TBrush read FBrush write FBrush;
    property Font: TFont read FFont write FFont;
    property Pen: TPen read FPen write FPen;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

const
  /// Standard colors
  clBlack = $000000;
  clMaroon = $000080;
  clGreen = $008000;
  clOlive = $008080;
  clNavy = $800000;
  clPurple = $800080;
  clTeal = $808000;
  clGray = $808080;
  clSilver = $C0C0C0;
  clRed = $0000FF;
  clLime = $00FF00;
  clYellow = $00FFFF;
  clBlue = $FF0000;
  clFuchsia = $FF00FF;
  clAqua = $FFFF00;
  clLtGray = $C0C0C0; /// clSilver alias
  clDkGray = $808080; /// clGray alias
  clWhite = $FFFFFF;

  /// Extended colors
  clMoneyGreen = $C0DCC0;
  clSkyBlue = $F0CAA6;
  clCream = $F0FBFF;
  clMedGray = $A4A0A0;

  //// Special colors
  clNone = $1FFFFFFF;
  clDefault = $20000000;

  //// System colors
  clBase = LongInt($80000000);
  clScrollBar = clBase + 0;
  clBackground = clBase + 1;
  clActiveCaption = clBase + 2;
  clInactiveCaption = clBase + 3;
  clMenu = clBase + 4;
  clWindow = clBase + 5;
  clWindowFrame = clBase + 6;
  clMenuText = clBase + 7;
  clWindowText = clBase + 8;
  clCaptionText = clBase + 9;
  clActiveBorder = clBase + 10;
  clInactiveBorder = clBase + 11;
  clAppWorkspace = clBase + 12;
  clHighlight = clBase + 13;
  clHighlightText = clBase + 14;
  clBtnFace = clBase + 15;
  clBtnShadow = clBase + 16;
  clGrayText = clBase + 17;
  clBtnText = clBase + 18;
  clInactiveCaptionText = clBase + 19;
  clBtnHighlight = clBase + 20;
  cl3DDkShadow = clBase + 21;
  cl3DLight = clBase + 22;
  clInfoText = clBase + 23;
  clInfoBk = clBase + 24;

  /// Synonyms: do not show them in color lists
  clColorDesktop = clBackground;
  cl3DFace = clBtnFace;
  cl3DShadow = clBtnShadow;
  cl3DHiLight = clBtnHighlight;
  clBtnHiLight = clBtnHighlight;

  clFirstSpecialColor = clBtnHiLight;

  clMask = clWhite;
  clDontMask = clBlack;

const
  /// Safe Font
  ffMonospace = 'Consolas, monaco, monospace';
  ffSans = '"Arial Narrow", Arial, "Helvetica Condensed", Helvetica, sans-serif';
  ffTimes = '"Times New Roman", Times, serif';

function JSColor(const AColor: TColor): string;
function JSFont(const AFont: TFont): string;
function JSMeasureText(const AText: string; const AFontName: string; const AFontSize: NativeInt; const AFixedWidth: NativeInt = 0): TSize; overload;

function PenStyleToCSSBorderStyle(aStyle: TPenStyle): String;
function AlignmentToCSSAlignment(aAlignment: TAlignment): String;
function TextLayoutToCSSVerticalAlign(aLayout: TTextLayout): String;

function IdentEntry(Entry: Longint; out MapEntry: TIdentMapEntry): boolean;
function ColorToIdent(Color: Longint; out Ident: String): Boolean;
function IdentToColor(const Ident: string; out Color: Longint): Boolean;
function ColorIndex(Color: Longint; out Index: Integer): Boolean;

implementation

function JSColor(const AColor: TColor): string;
var
  R, G, B: byte;
begin
  case AColor of
    //// System colors
    clScrollBar: Result := 'Scrollbar';
    clBackground: Result := 'Background';
    clActiveCaption: Result := 'ActiveCaption';
    clInactiveCaption: Result := 'InactiveCaption';
    clMenu: Result := 'Menu';
    clWindow: Result := 'Window';
    clWindowFrame: Result := 'WindowFrame';
    clMenuText: Result := 'MenuText';
    clWindowText: Result := 'WindowText';
    clCaptionText: Result := 'CaptionText';
    clActiveBorder: Result := 'ActiveBorder';
    clInactiveBorder: Result := 'InactiveBorder';
    clAppWorkspace: Result := 'AppWorkspace';
    clHighlight: Result := 'Highlight';
    clHighlightText: Result := 'HighlightText';
    clBtnFace: Result := 'ButtonFace';
    clBtnShadow: Result := 'ButtonShadow';
    clGrayText: Result := 'GrayText';
    clBtnText: Result := 'ButtonText';
    clInactiveCaptionText: Result := 'InactiveCaptionText';
    clBtnHighlight: Result := 'ButtonHighlight';
    cl3DDkShadow: Result := 'ThreeDDarkShadow';
    cl3DLight: Result := 'ThreeDHighlight';
    clInfoText: Result := 'InfoText';
    clInfoBk: Result := 'InfoBackground';
    else
    begin
      R := (AColor) and $FF;
      G := (AColor shr 8) and $FF;
      B := (AColor shr 16) and $FF;
      Result := '#' + IntToHex(R, 2) + IntToHex(G, 2) + IntToHex(B, 2);
    end;
  end;
end;

function JSFont(const AFont: TFont): string;
begin
  Result := '';
  if (Assigned(AFont)) then
  begin
    if (fsBold in AFont.Style) then
    begin
      Result := Result + 'bold ';
    end;
    if (fsItalic in AFont.Style) then
    begin
      Result := Result + 'italic ';
    end;
    Result := Result + (IntToStr(AFont.Size)) + 'px ' + AFont.Name;
  end;
end;

function JSMeasureText(const AText: string; const AFontName: string;  const AFontSize: NativeInt; const AFixedWidth: NativeInt): TSize;
var
  VDiv: TJSHTMLElement;
begin
  Result := Size(0, 0);
  if (AText <> '') then
  begin
    VDiv := TJSHTMLElement(Document.CreateElement('div'));
    with VDiv do
    begin
      Style.SetProperty('font-family', AFontName);
      Style.SetProperty('font-size', IntToStr(AFontSize) + 'px');
      Style.setProperty('overflow', 'scroll');
      if (AFixedWidth = 0) then
      begin
        Style.SetProperty('display', 'inline-block');
        Style.SetProperty('white-space', 'nowrap');
      end
      else
      begin
        Style.SetProperty('max-width', IntToStr(AFixedWidth) + 'px');
        Style.SetProperty('width', IntToStr(AFixedWidth) + 'px');
      end;
      InnerHTML := AText;
    end;
    Document.Body.AppendChild(VDiv);
    Result := Size(VDiv.ScrollWidth, VDiv.ScrollHeight);
    Document.Body.RemoveChild(VDiv);
  end;
end;

{ TFont }

function TFont.GetHeight: NativeInt;
begin                            
  /// https://stackoverflow.com/questions/139655/convert-pixels-to-points
  Result := Round((- FSize * 72) / 96);
end;

procedure TFont.SetCharSet(AValue: TFontCharSet);
begin
  if (FCharSet <> AValue) then
  begin
    FCharSet := AValue;
    Changed;
  end;
end;

procedure TFont.SetColor(AValue: TColor);
begin
  if (FColor <> AValue) then
  begin
    FColor := AValue;
    Changed;
  end;
end;

procedure TFont.SetHeight(AValue: NativeInt);
begin
  /// https://stackoverflow.com/questions/139655/convert-pixels-to-points
  SetSize(Round((- AValue * 96) / 72));
end;

procedure TFont.SetName(AValue: string);
begin
  if (FName <> AValue) then
  begin
    FName := AValue;
    Changed;
  end;
end;

procedure TFont.SetSize(AValue: NativeInt);
begin
  if (FSize <> AValue) then
  begin
    FSize := AValue;
    Changed;
  end;
end;

procedure TFont.SetStyle(AValue: TFontStyles);
begin
  if (FStyle <> AValue) then
  begin
    FStyle := AValue;
    Changed;
  end;
end;

procedure TFont.Changed;
begin
  if (FUpdateCount = 0) and (Assigned(FOnChange)) then
  begin
    FOnChange(Self);
  end;
end;

constructor TFont.Create;
begin
  inherited Create;
  FColor := clBlack;
  FName := ffSans;
  FSize := 10;
  FStyle := [];
  FUpdateCount := 0;
end;

procedure TFont.Assign(Source: TPersistent);
var
  VFont: TFont;
begin
  if (Assigned(Source)) and (Source is TFont) then
  begin
    BeginUpdate;
    try
      VFont := TFont(Source);
      FCharSet := VFont.CharSet;
      FColor := VFont.Color;
      FName := VFont.Name;
      FSize := VFont.Size;
      FStyle := VFont.Style;
    finally
      EndUpdate;
    end;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

procedure TFont.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TFont.EndUpdate;
begin
  if (FUpdateCount > 0) then
  begin
    Dec(FUpdateCount);
    if (FUpdateCount = 0) then
    begin
      Changed;
    end;
  end;
end;

function TFont.IsEqual(AFont: TFont): boolean;
begin
  if (Assigned(AFont)) then
  begin
    if (FCharSet <> AFont.CharSet) or
      (FColor <> AFont.Color) or
      (FName <> AFont.Name) or
      (FSize <> AFont.Size) or
      (FStyle <> AFont.Style) then
    begin
      Result := False;
    end
    else
    begin
      Result := True;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

function TFont.TextExtent(const AText: string): TSize;
begin
  Result := JSMeasureText(AText, FName, FSize);
end;

procedure TFont.TextSize(const AText: string; var W, H: NativeInt);
var
  VSize: TSize;
begin
  VSize := TextExtent(AText);
  H := VSize.Cy;
  W := VSize.Cx;
end;

function TFont.TextHeight(const AText: string): NativeInt;
begin
  Result := TextExtent(AText).Cy;
end;

function TFont.TextWidth(const AText: string): NativeInt;
begin
  Result := TextExtent(AText).Cx;
end;

{ TPen }

procedure TPen.SetColor(AValue: TColor);
begin
  if (FColor <> AValue) then
  begin
    FColor := AValue;
    Changed;
  end;
end;

procedure TPen.SetStyle(AValue: TPenStyle);
begin
  if (FStyle <> AValue) then
  begin
    FStyle := AValue;
    Changed;
  end;
end;

procedure TPen.SetWidth(AValue: NativeInt);
begin
  if (FWidth <> AValue) then
  begin
    FWidth := AValue;
    Changed;
  end;
end;

procedure TPen.Changed;
begin
  if (FUpdateCount = 0) and (Assigned(FOnChange)) then
  begin
    FOnChange(Self);
  end;
end;

constructor TPen.Create;
begin
  inherited Create;
  FColor := clBlack;
  FStyle := psSolid;
  FWidth := 1;
  FUpdateCount := 0;
end;

procedure TPen.Assign(Source: TPersistent);
var
  VPen: TPen;
begin
  if (Assigned(Source)) and (Source is TPen) then
  begin
    BeginUpdate;
    try
      VPen := TPen(Source);
      FColor := VPen.Color;
      FStyle := VPen.Style;
      FWidth := VPen.Width;
    finally
      EndUpdate;
    end;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

procedure TPen.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TPen.EndUpdate;
begin
  if (FUpdateCount > 0) then
  begin
    Dec(FUpdateCount);
    if (FUpdateCount = 0) then
    begin
      Changed;
    end;
  end;
end;

{ TBrush }

procedure TBrush.SetColor(AValue: TColor);
begin
  if (FColor <> AValue) then
  begin
    FColor := AValue;
    Changed;
  end;
end;

procedure TBrush.SetStyle(AValue: TBrushStyle);
begin
  if (FStyle = AValue) then
  begin
    FStyle := AValue;
    Changed;
  end;
end;

procedure TBrush.Changed;
begin
  if (FUpdateCount = 0) and (Assigned(FOnChange)) then
  begin
    FOnChange(Self);
  end;
end;

constructor TBrush.Create;
begin
  inherited Create;
  FColor := clWhite;
  FStyle := bsSolid;
  FUpdateCount := 0;
end;

procedure TBrush.Assign(Source: TPersistent);
var
  VBrush: TBrush;
begin
  if (Assigned(Source)) and (Source is TBrush) then
  begin
    BeginUpdate;
    try
      VBrush := TBrush(Source);
      FColor := VBrush.Color;
      FStyle := VBrush.Style;
    finally
      EndUpdate;
    end;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

procedure TBrush.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TBrush.EndUpdate;
begin
  if (FUpdateCount > 0) then
  begin
    Dec(FUpdateCount);
    if (FUpdateCount = 0) then
    begin
      Changed;
    end;
  end;
end;

{ TPicture }

procedure TPicture.SetData(AValue: string);
begin
  if (FData <> AValue) then
  begin
    FData := AValue;
    Changed;
  end;
end;

procedure TPicture.Changed;
begin
  if (FUpdateCount = 0) and (Assigned(FOnChange)) then
  begin
    FOnChange(Self);
  end;
end;

constructor TPicture.Create;
begin
  FData := '';
  FUpdateCount := 0;
  FOnChange := nil;
end;

procedure TPicture.Assign(Source: TPersistent);
var
  VPicture: TPicture;
begin
  if (Assigned(Source)) and (Source is TPicture) then
  begin
    BeginUpdate;
    try
      VPicture := TPicture(Source);
      FData := VPicture.Data;
    finally
      EndUpdate;
    end;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

procedure TPicture.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TPicture.EndUpdate;
begin
  if (FUpdateCount > 0) then
  begin
    Dec(FUpdateCount);
    if (FUpdateCount = 0) then
    begin
      Changed;
    end;
  end;
end;

function TPicture.IsEqual(APicture: TPicture): boolean;
begin
  if (Assigned(APicture)) then
  begin
    if (Self = APicture) then
    begin
      Result := True;
      Exit;
    end;
    if (FData <> APicture.Data) then
    begin
      Result := False;
    end
    else
    begin
      Result := True;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

{ TCanvas }

procedure TCanvas.PrepareStyle;
begin
  /// Specifies the color or style to use inside shapes
  FContextElement.FillStyle := JSColor(FBrush.Color);
  /// Sets the thickness of lines in space units
  FContextElement.LineWidth := FPen.Width;
  /// Specifies the color or style to use for the lines around shapes.
  FContextElement.StrokeStyleAsColor := JSColor(FPen.Color);
  /// Sets the line dash pattern used when stroking lines
  case FPen.Style of
    psDash: FContextElement.SetLineDash([8, 2]);
    psDot: FContextElement.SetLineDash([1, 2]);
    else
      FContextElement.SetLineDash([]);
      { TODO: Do the other types }
  end;
end;

procedure TCanvas.PrepareText;
begin
  /// Specifies the current text style being used when drawing text
  FContextElement.Font := JSFont(FFont);
  /// Specifies the color or style to use inside shapes
  FContextElement.FillStyle := JSColor(FFont.Color);
  /// Specifies the current text baseline being used when drawing text => "top"||"hanging"||"middle"||"alphabetic"||"ideographic"||"bottom"
  FContextElement.TextBaseline := 'hanging';
end;

procedure TCanvas.Changed;
begin
  if (FUpdateCount = 0) and (Assigned(FOnChange)) then
  begin
    FOnChange(Self);
  end;
end;

constructor TCanvas.Create;
begin
  inherited Create;
  FCanvasElement := TJSHTMLCanvasElement(Document.CreateElement('canvas'));
  FContextElement := FCanvasElement.GetContextAs2DContext('2d');
  FBrush := TBrush.Create;
  FFont := TFont.Create;
  FPen := TPen.Create;
  FUpdateCount := 0;
end;

destructor TCanvas.Destroy;
begin
  FBrush.Destroy;
  FFont.Destroy;
  FPen.Destroy;
  FBrush := nil;
  FFont := nil;
  FPen := nil;
  inherited Destroy;
end;

procedure TCanvas.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TCanvas.EndUpdate;
begin
  if (FUpdateCount > 0) then
  begin
    Dec(FUpdateCount);
    if (FUpdateCount = 0) then
    begin
      Changed;
    end;
  end;
end;

procedure TCanvas.Clear;
begin
  FContextElement.ClearRect(0, 0, FCanvasElement.Width, FCanvasElement.Height);
end;

procedure TCanvas.FillRect(const ARect: TRect);
begin
  FillRect(ARect.Left, ARect.Top, (ARect.Bottom - ARect.Top), (ARect.Right - ARect.Left));
end;

procedure TCanvas.FillRect(const ALeft, ATop, AWidth, AHeight: double);
begin
  PrepareStyle;
  if (FBrush.Style <> bsClear) then
  begin
    /// Draws a filled rectangle whose starting point is at the coordinates
    FContextElement.FillRect(ALeft, ATop, AWidth, AHeight);
  end;
end;

procedure TCanvas.LineTo(X, Y: double);
begin
  PrepareStyle;
  /// Connects the last point in the sub-path to the x, y coordinates with a straight line (but does not actually draw it).
  FContextElement.LineTo(X, Y);
  if (FPen.Style <> psClear) then
  begin
    /// Strokes the current or given path with the current stroke style
    FContextElement.Stroke();
  end;
end;

procedure TCanvas.MoveTo(X, Y: double);
begin
  /// Starts a new path by emptying the list of sub-paths.
  FContextElement.BeginPath;
  /// Moves the starting point of a new sub-path to the (x, y) coordinates
  FContextElement.MoveTo(X, Y);
end;

procedure TCanvas.Rectangle(const ARect: TRect);
begin
  Rectangle(ARect.Left, ARect.Top, (ARect.Bottom - ARect.Top), (ARect.Right - ARect.Left));
end;

procedure TCanvas.Rectangle(const ALeft, ATop, AWidth, AHeight: double);
begin
  /// Starts a new path by emptying the list of sub-paths.
  FContextElement.BeginPath;
  PrepareStyle;
  // Creates a path for a rectangle at position (x, y)
  FContextElement.Rect(ALeft, ATop, AWidth, AHeight);
  if (FBrush.Style <> bsClear) then
  begin
    /// Fills the current or given path with the current fill style.
    FContextElement.Fill();
  end;
  if (FPen.Style <> psClear) then
  begin
    /// Strokes the current or given path with the current stroke style
    FContextElement.Stroke();
  end;
end;

procedure TCanvas.TextOut(X, Y: double; const AText: string);
begin
  PrepareText;
  if (FPen.Style <> psClear) then
  begin
    /// Draws a text string at the specified coordinates
    FContextElement.FillText(AText, X, Y);
  end;
end;

function TCanvas.TextExtent(const AText: string): TSize;
begin
  Result := JSMeasureText(AText, FFont.Name, FFont.Size);
end;

function TCanvas.TextHeight(const AText: string): NativeInt;
begin
  Result := TextExtent(AText).Cy;
end;

function TCanvas.TextWidth(const AText: string): NativeInt;
begin
  Result := TextExtent(AText).Cx;
end;

const
  Colors: array[0..46] of TIdentMapEntry = (
    // standard colors
    (Value: clBlack; Name: 'clBlack'),
    (Value: clMaroon; Name: 'clMaroon'),
    (Value: clGreen; Name: 'clGreen'),
    (Value: clOlive; Name: 'clOlive'),
    (Value: clNavy; Name: 'clNavy'),
    (Value: clPurple; Name: 'clPurple'),
    (Value: clTeal; Name: 'clTeal'),
    (Value: clGray; Name: 'clGray'),
    (Value: clSilver; Name: 'clSilver'),
    (Value: clRed; Name: 'clRed'),
    (Value: clLime; Name: 'clLime'),
    (Value: clYellow; Name: 'clYellow'),
    (Value: clBlue; Name: 'clBlue'),
    (Value: clFuchsia; Name: 'clFuchsia'),
    (Value: clAqua; Name: 'clAqua'),
    (Value: clWhite; Name: 'clWhite'),

    // extended colors
    (Value: clMoneyGreen; Name: 'clMoneyGreen'),
    (Value: clSkyBlue; Name: 'clSkyBlue'),
    (Value: clCream; Name: 'clCream'),
    (Value: clMedGray; Name: 'clMedGray'),

    // special colors
    (Value: clNone; Name: 'clNone'),
    (Value: clDefault; Name: 'clDefault'),

    // system colors
    (Value: clScrollBar; Name: 'clScrollBar'),
    (Value: clBackground; Name: 'clBackground'),
    (Value: clActiveCaption; Name: 'clActiveCaption'),
    (Value: clInactiveCaption; Name: 'clInactiveCaption'),
    (Value: clMenu; Name: 'clMenu'),
    //(Value: clMenuBar; Name: 'clMenuBar'),
    //(Value: clMenuHighlight; Name: 'clMenuHighlight'),
    (Value: clMenuText; Name: 'clMenuText'),
    (Value: clWindow; Name: 'clWindow'),
    (Value: clWindowFrame; Name: 'clWindowFrame'),
    (Value: clWindowText; Name: 'clWindowText'),
    (Value: clCaptionText; Name: 'clCaptionText'),
    (Value: clActiveBorder; Name: 'clActiveBorder'),
    (Value: clInactiveBorder; Name: 'clInactiveBorder'),
    (Value: clAppWorkspace; Name: 'clAppWorkspace'),
    (Value: clHighlight; Name: 'clHighlight'),
    (Value: clHighlightText; Name: 'clHighlightText'),
    (Value: clBtnFace; Name: 'clBtnFace'),
    (Value: clBtnShadow; Name: 'clBtnShadow'),
    (Value: clGrayText; Name: 'clGrayText'),
    (Value: clBtnText; Name: 'clBtnText'),
    (Value: clInactiveCaptionText; Name: 'clInactiveCaptionText'),
    (Value: clBtnHighlight; Name: 'clBtnHighlight'),
    (Value: cl3DDkShadow; Name: 'cl3DDkShadow'),
    (Value: cl3DLight; Name: 'cl3DLight'),
    (Value: clInfoText; Name: 'clInfoText'),
    (Value: clInfoBk; Name: 'clInfoBk')

    //(Value: clHotLight; Name: 'clHotLight'),
    //(Value: clGradientActiveCaption; Name: 'clGradientActiveCaption'),
    //(Value: clGradientInactiveCaption; Name: 'clGradientInactiveCaption'),

    // one our special color
    //(Value: clForm; Name: 'clForm')
    );

function PenStyleToCSSBorderStyle(aStyle: TPenStyle): String;
begin
  case aStyle of
    psSolid:
      Result := 'solid';
    psDash:
      Result := 'dashed';
    psDot:
      Result := 'dotted';
    psClear:
      Result := 'hidden';
    else
      Result := 'none';
    {psDashDot: ;
    psDashDotDot: ;
    psInsideFrame: ;
    psPattern: ;}
  end;
end;

function AlignmentToCSSAlignment(aAlignment: TAlignment): String;
begin
  case aAlignment of
    taLeftJustify:
      Result := 'left';
    taRightJustify:
      Result := 'right';
    taCenter:
      Result := 'center';
  end;
end;

function TextLayoutToCSSVerticalAlign(aLayout: TTextLayout): String;
begin
  case aLayout of
    tlTop:
      Result := 'text-top';
    tlCenter:
      Result := 'baseline';
    tlBottom:
      Result := 'text-bottom';
  end;
end;

function IdentEntry(Entry: Longint; out MapEntry: TIdentMapEntry): boolean;
begin
  Result := False;
  if (Entry >= 0) and (Entry <= High(Colors)) then
  begin
    MapEntry := Colors[Entry];
    Result := True;
  end;
end;

function ColorToIdent(Color: Longint; out Ident: String): Boolean;
begin
  Result := IntToIdent(Color, Ident, Colors);
end;

function IdentToColor(const Ident: string; out Color: Longint): Boolean;
begin
  Result := IdentToInt(Ident, Color, Colors);
end;

function ColorIndex(Color: Longint; out Index: Integer): Boolean;
var
  i: integer;
begin
  for i := Low(Colors) to High(Colors) do
    if Colors[i].Value = Color then
    begin
      Result := True;
      Index := i;
      exit;
    end;
  Result := False;
end;

initialization
  RegisterIntegerConsts(TypeInfo(TColor), TIdentToInt(@IdentToColor), TIntToIdent(@ColorToIdent));
end.

