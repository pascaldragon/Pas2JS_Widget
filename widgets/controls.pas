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
unit Controls;

{$I pas2js_widget.inc}

interface

uses
  Classes,
  SysUtils,
  Types,
  JS,
  Web,
  Math,
  Graphics,
  Generics.Collections;

const
  /// Used for ModalResult
  mrNone = 0;
  mrOk = mrNone + 1;
  mrCancel = mrNone + 2;
  mrAbort = mrNone + 3;
  mrRetry = mrNone + 4;
  mrIgnore = mrNone + 5;
  mrYes = mrNone + 6;
  mrNo = mrNone + 7;
  mrAll = mrNone + 8;
  mrNoToAll = mrNone + 9;
  mrYesToAll = mrNone + 10;
  mrClose = mrNone + 11;
  mrLast = mrClose;

  /// String representation of ModalResult values
  ModalResultStr: array[mrNone..mrLast] of string = (
    'mrNone',
    'mrOk',
    'mrCancel',
    'mrAbort',
    'mrRetry',
    'mrIgnore',
    'mrYes',
    'mrNo',
    'mrAll',
    'mrNoToAll',
    'mrYesToAll',
    'mrClose');

const
  /// Cursor constants
  crDefault = 0;
  crNone = -1;
  crArrow = -2;
  crCross = -3;
  crIBeam = -4;
  crSize = -22;
  crSizeNESW = -6; /// Diagonal north east - south west
  crSizeNS = -7;
  crSizeNWSE = -8;
  crSizeWE = -9;
  crSizeNW = -23;
  crSizeN = -24;
  crSizeNE = -25;
  crSizeW = -26;
  crSizeE = -27;
  crSizeSW = -28;
  crSizeS = -29;
  crSizeSE = -30;
  crUpArrow = -10;
  crHourGlass = -11;
  crDrag = -12;
  crNoDrop = -13;
  crHSplit = -14;
  crVSplit = -15;
  crMultiDrag = -16;
  crSQLWait = -17;
  crNo = -18;
  crAppStart = -19;
  crHelp = -20;
  crHandPoint = -21;

type
  TIntegerList = TList<Integer>;

  /// Forward declaration
  TWinControl = class;
  TWinControlClass = class of TWinControl;
  TControl = class;
  TControlClass = class of TControl;

  TAlign = (alNone, alTop, alBottom, alLeft, alRight, alClient, alCustom);
  TAlignSet = set of TAlign;
  TAnchorKind = (akTop, akLeft, akRight, akBottom);
  TAnchors = set of TAnchorKind;

  TBevelCut = (bvNone, bvLowered, bvRaised, bvSpace);

  TFormBorderStyle = (bsNone, bsSingle, bsSizeable, bsDialog, bsToolWindow, bsSizeToolWin);
  TBorderStyle = bsNone..bsSingle;
  TControlBorderStyle = TBorderStyle;

  TCaption = type string;
  TCursor = -32768..32767;

  { TControlCanvas }

  TControlCanvas = class(TCanvas)
  private
    FControl: TControl;
    FHeight: NativeInt;
    FWidth: NativeInt;
    procedure SetHeight(AValue: NativeInt);
    procedure SetWidth(AValue: NativeInt);
  public
    constructor Create(AControl: TControl); reintroduce;
    property Height: NativeInt read FHeight write SetHeight;
    property Width: NativeInt read FWidth write SetWidth;
  end;

  TShiftStateEnum = (ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMIDdle, ssDouble);
  TShiftState = set of TShiftStateEnum;

  TKeyEvent = procedure(Sender: TObject; var Key: NativeInt; Shift: TShiftState) of object;
  TKeyPressEvent = procedure(Sender: TObject; var Key: char) of object;

  TMouseButton = (mbLeft, mbRight, mbMiddle);

  TMouseEvent = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: NativeInt) of object;
  TMouseMoveEvent = procedure(Sender: TObject; Shift: TShiftState; X, Y: NativeInt) of object;
  TMouseWheelEvent = procedure(Sender: TObject; Shift: TShiftState; WheelDelta: NativeInt; MousePos: TPoint; var Handled: boolean) of object;

  TFocusSearchDirection = (fsdFirst, fsdLast, fsdNext, fsdPrev);

  TControlFlag = (
    cfInAlignControls
  );
  TControlFlags = set of TControlFlag;

  { TControlBorderSpacing }

  TControlBorderSpacing = class(TPersistent)
  private
    FAround: NativeInt;
    FBottom: NativeInt;
    FLeft: NativeInt;
    FRight: NativeInt;
    FTop: NativeInt;
    FUpdateCount: NativeInt;
    FOnChange: TNotifyEvent;
    procedure SetAround(AValue: NativeInt);
    procedure SetBottom(AValue: NativeInt);
    procedure SetLeft(AValue: NativeInt);
    procedure SetRight(AValue: NativeInt);
    procedure SetTop(AValue: NativeInt);
  protected
    procedure Changed; virtual;
  public
    constructor Create; reintroduce;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
  published
    property Around: NativeInt read FAround write SetAround;
    property Bottom: NativeInt read FBottom write SetBottom;
    property Left: NativeInt read FLeft write SetLeft;
    property Right: NativeInt read FRight write SetRight;
    property Top: NativeInt read FTop write SetTop;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TControl }

  TControl = class(TComponent)
  private
    FAlign: TAlign;
    FAnchors: TAnchors;
    FAutoSize: boolean;
    FBorderSpacing: TControlBorderSpacing;
    FBorderStyle: TBorderStyle;
    FCaption: TCaption;
    FColor: TColor;
    FControlFlags: TControlFlags;
    FControls: TJSArray; /// The child controls
    FCursor: TCursor;
    FDesignRect: TRect;
    FEnabled: boolean;
    FFont: TFont;
    FHandleClass: string;
    FHandleElement: TJSHTMLElement;
    FHandleId: string;
    FHeight: NativeInt;
    FHint: string;
    FLeft: NativeInt;
    FParent: TWinControl;
    FParentColor: boolean;
    FParentFont: boolean;
    FParentShowHint: boolean;
    FShowHint: boolean;
    FTabOrder: NativeInt;
    FTabStop: boolean;
    FTop: NativeInt;
    FUpdateCount: NativeInt;
    FVisible: boolean;
    FWidth: NativeInt;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    FOnMouseWheel: TMouseWheelEvent;
    FOnResize: TNotifyEvent;
    FOnScroll: TNotifyEvent;
    function GetClientHeight: NativeInt;
    function GetClientOrigin: TPoint;
    function GetClientRect: TRect;
    function GetClientWidth: NativeInt;
    function GetText: TCaption;
    function IsAnchorsStored: Boolean;
    procedure SetAlign(AValue: TAlign);
    procedure SetAnchors(AValue: TAnchors);
    procedure SetAutoSize(AValue: boolean);
    procedure SetBorderSpacing(AValue: TControlBorderSpacing);
    procedure SetClientSize(AValue: TPoint);
    procedure SetClientHeight(AValue: NativeInt);
    procedure SetClientWidth(AValue: NativeInt);
    procedure SetColor(AValue: TColor);
    procedure SetCursor(AValue: TCursor);
    procedure SetEnabled(AValue: boolean);
    procedure SetFont(AValue: TFont);
    procedure SetHandleClass(AValue: string);
    procedure SetHandleId(AValue: string);
    procedure SetHeight(AValue: NativeInt);
    procedure SetHint(AValue: string);
    procedure SetLeft(AValue: NativeInt);
    procedure SetParent(AValue: TWinControl);
    procedure SetParentColor(AValue: boolean);
    procedure SetParentFont(AValue: boolean);
    procedure SetParentShowHint(AValue: boolean);
    procedure SetShowHint(AValue: boolean);
    procedure SetTabOrder(AValue: NativeInt);
    procedure SetTabStop(AValue: boolean);
    procedure SetText(AValue: TCaption);
    procedure SetTop(AValue: NativeInt);
    procedure SetVisible(AValue: boolean);
    procedure SetWidth(AValue: NativeInt);
  protected
    procedure SetBorderStyle(AValue: TBorderStyle);
  protected
    procedure Click; virtual;
    procedure DblClick; virtual;
    procedure DoResize; virtual;
    procedure DoScroll; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); virtual;
    procedure MouseEnter; virtual;
    procedure MouseLeave; virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); virtual;
    procedure MouseWeel(Shift: TShiftState; WheelDelta: NativeInt; MousePos: TPoint; var Handled: boolean);
  protected
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;
    property TabOrder: NativeInt read FTabOrder write SetTabOrder;
    property TabStop: boolean read FTabStop write SetTabStop;
    property Text: TCaption read GetText write SetText;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseWheel: TMouseWheelEvent read FOnMouseWheel write FOnMouseWheel;
    property OnScroll: TNotifyEvent read FOnScroll write FOnScroll;
  protected
    function HandleClick(AEvent: TJSMouseEvent): boolean; virtual;
    function HandleDblClick(AEvent: TJSMouseEvent): boolean; virtual;
    function HandleMouseDown(AEvent: TJSMouseEvent): boolean; virtual;
    function HandleMouseEnter(AEvent: TJSMouseEvent): boolean; virtual;
    function HandleMouseLeave(AEvent: TJSMouseEvent): boolean; virtual;
    function HandleMouseMove(AEvent: TJSMouseEvent): boolean; virtual;
    function HandleMouseUp(AEvent: TJSMouseEvent): boolean; virtual;
    function HandleMouseWheel(AEvent: TJSWheelEvent): boolean; virtual;
    function HandleResize(AEvent: TJSEvent): boolean; virtual;
    function HandleScroll(AEvent: TJSEvent): boolean; virtual;
  protected
    procedure Loaded; override;
    procedure Changed; virtual;
    function CreateHandleElement: TJSHTMLElement; virtual;
    procedure RegisterHandleEvents; virtual;
    procedure UnRegisterHandleEvents; virtual;
    function CheckChildClassAllowed(AChildClass: TClass): boolean; virtual;
    procedure CheckNewParent(AParent: TWinControl); virtual;
    procedure RegisterChild(AControl: TControl); virtual;
    procedure UnRegisterChild(AControl: TControl); virtual;
    procedure AlignControls; virtual;
    function RealGetText: string; virtual;
    procedure RealSetText(const AValue: string); virtual;
    procedure BorderSpacingChanged(Sender: TObject); virtual;
    procedure ColorChanged(Sender: TObject); virtual;
    procedure FontChanged(Sender: TObject); virtual;
    function TabOrderArray: TJSArray; virtual;
    function CompareTabOrder(A, B: JSValue): NativeInt; virtual;
    procedure UpdateTabOrder(const AValue: TControl); virtual;
    procedure SetParentComponent(AValue: TComponent); override;
  protected
    class function GetControlClassDefaultSize: TSize; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    procedure AdjustSize; virtual;
    function IsParentOf(AControl: TControl): boolean; virtual;
    function IsUpdating: boolean; virtual;
    function GetTopParent: TControl;
    function HasParent: boolean; override;
    procedure Invalidate; virtual;
    procedure ReAlign; virtual; /// Realign all children
    procedure BringToFront; virtual;
    procedure SendToBack; virtual;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: NativeInt); virtual;
  public
    property Align: TAlign read FAlign write SetAlign;
    property Anchors: TAnchors read FAnchors write SetAnchors stored IsAnchorsStored default [akLeft, akTop];
    property AutoSize: boolean read FAutoSize write SetAutoSize default False;
    property BorderSpacing: TControlBorderSpacing read FBorderSpacing write SetBorderSpacing;
    property Caption: TCaption read GetText write SetText;
    property ClientHeight: NativeInt read GetClientHeight write SetClientHeight;
    property ClientOrigin: TPoint read GetClientOrigin;
    property ClientRect: TRect read GetClientRect;
    property ClientWidth: NativeInt read GetClientWidth write SetClientWidth;
    property Color: TColor read FColor write SetColor;
    property Enabled: boolean read FEnabled write SetEnabled;
    property Font: TFont read FFont write SetFont;
    property HandleElement: TJSHTMLElement read FHandleElement;  
    property HandleClass: string read FHandleClass write SetHandleClass;
    property HandleId: string read FHandleId write SetHandleId;
    property Parent: TWinControl read FParent write SetParent;
    property ParentColor: boolean read FParentColor write SetParentColor;
    property ParentFont: boolean read FParentFont write SetParentFont;
    property ParentShowHint: boolean read FParentShowHint write SetParentShowHint;
    property ShowHint: boolean read FShowHint write SetShowHint;
    property Visible: boolean read FVisible write SetVisible;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
  published
    property Cursor: TCursor read FCursor write SetCursor;
    property Left: NativeInt read FLeft write SetLeft;
    property Height: NativeInt read FHeight write SetHeight;
    property Hint: string read FHint write SetHint;
    property Top: NativeInt read FTop write SetTop;
    property Width: NativeInt read FWidth write SetWidth;
  end;

  { TWinControl }

  TWinControl = class(TControl)
  private
    FOnEnter: TNotifyEvent;
    FOnExit: TNotifyEvent;
    FOnKeyDown: TKeyEvent;
    FOnKeyPress: TKeyPressEvent;
    FOnKeyUp: TKeyEvent;
    function GetControl(const AIndex: NativeInt): TControl;
    function GetControlCount: NativeInt;
    function GetControlIndex(const AControl: TControl): NativeInt;
  protected
    procedure DoEnter; virtual;
    procedure DoExit; virtual;
    procedure KeyDown(var Key: NativeInt; Shift: TShiftState); virtual;
    procedure KeyPress(var Key: char); virtual;
    procedure KeyUp(var Key: NativeInt; Shift: TShiftState); virtual;
  protected
    function HandleEnter(AEvent: TJSFocusEvent): boolean; virtual;
    function HandleExit(AEvent: TJSEvent): boolean; virtual;
    function HandleKeyDown(AEvent: TJSKeyBoardEvent): boolean; virtual;
    function HandleKeyUp(AEvent: TJSKeyBoardEvent): boolean; virtual;
    function HandleKeyPress(AEvent: TJSKeyBoardEvent): boolean; virtual;
  protected
    procedure RegisterHandleEvents; override;
    procedure UnRegisterHandleEvents; override;
    function CheckChildClassAllowed(AChildClass: TClass): boolean; override;
    function FindFocusControl(const AStartControl: TWinControl; ADirection: TFocusSearchDirection): TWinControl; virtual;
  public
    function Focused: boolean; virtual;
    function CanSetFocus: boolean; virtual;
    procedure SetFocus; virtual;
    function ContainsControl(const AControl: TControl): boolean; virtual;
    property ControlCount: NativeInt read GetControlCount;
    property ControlIndex[const AControl: TControl]: NativeInt read GetControlIndex;
    property Controls[const AIndex: NativeInt]: TControl read GetControl; default;
  public
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;
    property OnKeyDown: TKeyEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnKeyUp: TKeyEvent read FOnKeyUp write FOnKeyUp;
  end;

  { TCustomControl }

  TCustomControl = class(TWinControl)
  private
    FCanvas: TControlCanvas;
    FOnPaint: TNotifyEvent;
    function GetCanvas: TControlCanvas;
  protected
    procedure ColorChanged(Sender: TObject); override;
    procedure FontChanged(Sender: TObject); override;
    procedure Paint; virtual;
  public
    destructor Destroy; override;
    procedure Invalidate; override;
  public
    property Canvas: TControlCanvas read GetCanvas;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  end;

const
  AnchorAlign: array[TAlign] of TAnchors = (
    [akLeft, akTop],                   // alNone
    [akLeft, akTop, akRight],          // alTop
    [akLeft, akRight, akBottom],       // alBottom
    [akLeft, akTop, akBottom],         // alLeft
    [akRight, akTop, akBottom],        // alRight
    [akLeft, akTop, akRight, akBottom],// alClient
    [akLeft, akTop]                    // alCustom
    );

function FromCharCode(ACode: NativeInt): char; external Name 'String.fromCharCode';

function CompareString(A, B: string): integer; assembler;

function CompareValues(A, B: JSValue): NativeInt;

function IfThen(const AExpression: boolean; const AConsequence, AAlternative: boolean): boolean; overload;
function IfThen(const AExpression: boolean; const AConsequence, AAlternative: extended): extended; overload;
function IfThen(const AExpression: boolean; const AConsequence, AAlternative: NativeInt): NativeInt; overload;
function IfThen(const AExpression: boolean; const AConsequence, AAlternative: string): string; overload;

function ScrollbarWidth: NativeInt;

function OffSets(const AElement: TJSHTMLElement): TRect;
procedure UpdateHtmlElementFont(AElement: TJSHTMLElement; AFont: TFont; AClear: Boolean = False);

function ExtractKeyCode(const AEvent: TJSKeyBoardEvent): NativeInt;
function ExtractKeyChar(const AEvent: TJSKeyBoardEvent): char;
function ExtractShiftState(const AEvent: TJSKeyboardEvent): TShiftState; overload;
function ExtractShiftState(const AEvent: TJSMouseEvent): TShiftState; overload;
function ExtractMouseButton(const AEvent: TJSMouseEvent): TMouseButton;

function JSCursor(const ACursor: TCursor): string;

implementation

uses
  Forms;

function CompareString(A, B: string): integer; assembler;
asm
  return A.localeCompare(B, undefined, { numeric: true, sensitivity: 'base' });
end;

function CompareValues(A, B: JSValue): NativeInt;
begin
  if (JsTypeOf(A) = 'string') and (JsTypeOf(B) = 'string') then
  begin
    Result := CompareString(string(A), string(B));
  end
  else
  if (JsTypeOf(A) = 'number') and (JsTypeOf(B) = 'number') then
  begin
    Result := CompareValue(extended(A), extended(B));
  end
  else
  if (JsTypeOf(A) = 'boolean') and (JsTypeOf(B) = 'boolean') then
  begin
    if (boolean(A)) = (boolean(B)) then
    begin
      Result := 0;
    end
    else
    if (boolean(A)) then
    begin
      Result := 1;
    end
    else
    begin
      Result := -1;
    end;
  end
  else
  begin
    Result := 0;
  end;
end;

function IfThen(const AExpression: boolean; const AConsequence, AAlternative: boolean): boolean;
begin
  if (AExpression) then
  begin
    Result := AConsequence;
  end
  else
  begin
    Result := AAlternative;
  end;
end;

function IfThen(const AExpression: boolean; const AConsequence, AAlternative: extended): extended;
begin
  if (AExpression) then
  begin
    Result := AConsequence;
  end
  else
  begin
    Result := AAlternative;
  end;
end;

function IfThen(const AExpression: boolean; const AConsequence, AAlternative: NativeInt): NativeInt;
begin
  if (AExpression) then
  begin
    Result := AConsequence;
  end
  else
  begin
    Result := AAlternative;
  end;
end;

function IfThen(const AExpression: boolean; const AConsequence, AAlternative: string): string;
begin
  if (AExpression) then
  begin
    Result := AConsequence;
  end
  else
  begin
    Result := AAlternative;
  end;
end;

function ScrollbarWidth: NativeInt;
var
  VDiv: TJSHTMLElement;
begin
  VDiv := TJSHTMLElement(Document.CreateElement('div'));
  with VDiv do
  begin
    Style.SetProperty('with', '100');
    Style.SetProperty('height', '100');
    Style.SetProperty('position', 'absolute');
    Style.SetProperty('top', '-9999');
    Style.SetProperty('overflow', 'scroll');
    Style.SetProperty('-ms-overflow-style', 'scrollbar');  
  end;
  Document.Body.AppendChild(VDiv);
  Result := Round(VDiv.OffsetWidth - VDiv.ClientWidth);
  if (Result < 0) then
  begin
    Result := 0;
  end;
  Document.Body.RemoveChild(VDiv);
end;

function OffSets(const AElement: TJSHTMLElement): TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if (Assigned(AElement)) then
  begin
    with (AElement.GetBoundingClientRect) do
    begin
      Result.Left := Trunc(Left + Window.ScrollX);
      Result.Top := Trunc(Top + Window.ScreenY);
    end;
  end;
end;

procedure UpdateHtmlElementFont(AElement: TJSHTMLElement; AFont: TFont; AClear: Boolean);
var
  s: String;
begin
  with AElement.style do begin
    if AClear then begin
      removeProperty('font-family');
      removeProperty('font-size');
      removeProperty('font-weight');
      removeProperty('font-style');
      removeProperty('text-decoration');
    end else begin
      setProperty('font-family', AFont.Name);
      setProperty('font-size', IntToStr(AFont.Size) + 'pt');
      if fsBold in AFont.Style then
        setProperty('font-weight', 'bold')
      else
        setProperty('font-weight', '');
      setProperty('font-style', 'normal');
      s := '';
      if fsItalic in AFont.Style then
        s := 'italic';
      if fsUnderline in AFont.Style then begin
        if s <> '' then
          s := s + ' ';
        s := s + 'underline';
      end;
      if fsStrikeOut in AFont.Style then begin
        if s <> '' then
          s := s + ' ';
        s := s + 'line-through';
      end;
      if s <> '' then
        setProperty('text-decoration', s)
      else
        removeProperty('text-decoration');
    end;
  end;
end;

function ExtractKeyCode(const AEvent: TJSKeyBoardEvent): NativeInt;
var
  VLocation: NativeInt;
  VKey: string;
begin
  VLocation := AEvent.Location;
  VKey := LowerCase(AEvent.Key);
  Result := -1;
  case VKey of
    'backspace': Result := 8;
    'tab': Result := 9;
    'enter': Result := 13;
    'shift': Result := 16;
    'control': Result := 17;
    'alt': Result := 18;
    'altgraph': Result := 18;
    'pause': Result := 19;
    'capslock': Result := 20;
    'escape': Result := 27;
    'pageup': Result := 33;
    'pagedown': Result := 34;
    'end': Result := 35;
    'home': Result := 36;
    'arrowleft': Result := 37;
    'arrowup': Result := 38;
    'arrowright': Result := 39;
    'arrowdown': Result := 40;
    'insert': Result := 45;
    'delete': Result := 46;
    'f1': Result := 112;
    'f2': Result := 113;
    'f3': Result := 114;
    'f4': Result := 115;
    'f5': Result := 116;
    'f6': Result := 117;
    'f7': Result := 118;
    'f8': Result := 119;
    'f9': Result := 120;
    'f10': Result := 121;
    'f11': Result := 122;
    'f12': Result := 123;
    'f13': Result := 124;
    'f14': Result := 125;
    'f15': Result := 126;
    'f16': Result := 127;
    'f17': Result := 128;
    'f18': Result := 129;
    'f19': Result := 130;
    'f20': Result := 131;
    'numlock': Result := 144;
    'scrolllock': Result := 145;
  end;
  if (VLocation = 3) then
  begin
    case VKey of
      '0': Result := 96;
      '1': Result := 97;
      '2': Result := 98;
      '3': Result := 99;
      '4': Result := 100;
      '5': Result := 101;
      '6': Result := 102;
      '7': Result := 103;
      '8': Result := 104;
      '9': Result := 105;
      '*': Result := 106;
      '+': Result := 107;
      '-': Result := 109;
      ',': Result := 110;
      '/': Result := 111;
      '.': Result := 194;
    end;
  end
  else
  begin
    case VKey of
      '0': Result := 48;
      '1': Result := 49;
      '2': Result := 50;
      '3': Result := 51;
      '4': Result := 52;
      '5': Result := 53;
      '6': Result := 54;
      '7': Result := 55;
      '8': Result := 56;
      '9': Result := 57;
      'ç': Result := 63;
      'a': Result := 65;
      'b': Result := 66;
      'c': Result := 67;
      'd': Result := 68;
      'e': Result := 69;
      'f': Result := 70;
      'g': Result := 71;
      'h': Result := 72;
      'i': Result := 73;
      'j': Result := 74;
      'k': Result := 75;
      'l': Result := 76;
      'm': Result := 77;
      'n': Result := 78;
      'o': Result := 79;
      'p': Result := 80;
      'q': Result := 81;
      'r': Result := 82;
      's': Result := 83;
      't': Result := 84;
      'u': Result := 85;
      'v': Result := 86;
      'w': Result := 87;
      'x': Result := 88;
      'y': Result := 89;
      'z': Result := 90;
      '=': Result := 187;
      ',': Result := 188;
      '-': Result := 189;
      '.': Result := 190;
      '''': Result := 192;
      '/': Result := 193;
      ']': Result := 220;
      '[': Result := 221;
    end;
  end;
end;

function ExtractKeyChar(const AEvent: TJSKeyBoardEvent): char;
var
  VKey: string;
begin
  VKey := LowerCase(AEvent.Key);
  Result := #0;
  if (Length(VKey) = 1) then
  begin
    Result := VKey[1];
  end
  else
  begin
    case VKey of
      'backspace': Result := #8;
      'tab': Result := #9;
      'enter': Result := #13;
      'escape': Result := #27;
    end;
  end;
end;

function ExtractShiftState(const AEvent: TJSKeyboardEvent): TShiftState;
begin
  Result := [];
  if (AEvent.AltKey) then
  begin
    Result := Result + [ssAlt];
  end;
  if (AEvent.CtrlKey) then
  begin
    Result := Result + [ssCtrl];
  end;
  if (AEvent.ShiftKey) then
  begin
    Result := Result + [ssShift];
  end;
end;

function ExtractShiftState(const AEvent: TJSMouseEvent): TShiftState;
begin
  Result := [];
  if (AEvent.AltKey) then
  begin
    Result := Result + [ssAlt];
  end;
  if (AEvent.CtrlKey) then
  begin
    Result := Result + [ssCtrl];
  end;
  if (AEvent.ShiftKey) then
  begin
    Result := Result + [ssShift];
  end;
end;

function ExtractMouseButton(const AEvent: TJSMouseEvent): TMouseButton;
begin
  case AEvent.button of
    1: Result := mbMiddle;
    2: Result := mbRight;
    else
      Result := mbMiddle;
  end;
end;

function JSCursor(const ACursor: TCursor): string;
begin
  /// https://www.w3schools.com/cssref/tryit.asp?filename=trycss_cursor
  case ACursor of
    crNone: Result := 'none';
    crCross: Result := 'crosshair';
    crIBeam: Result := 'text';
    crSize: Result := 'move';
    crSizeNESW: Result := 'nesw-resize';
    crSizeNS: Result := 'ns-resize';
    crSizeNWSE: Result := 'nwse-resize';
    crSizeWE: Result := 'ew-resize';
    crSizeNW: Result := 'nwse-resize';
    crSizeN: Result := 'ns-resize';
    crSizeNE: Result := 'nesw-resize';
    crSizeW: Result := 'col-resize';
    crSizeE: Result := 'col-resize';
    crSizeSW: Result := 'nesw-resize';
    crSizeS: Result := 'ns-resize';
    crSizeSE: Result := 'nwse-resize';
    crHourGlass: Result := 'wait';
    crNoDrop: Result := 'no-drop';
    crHSplit: Result := 'col-resize';
    crVSplit: Result := 'row-resize';
    crSQLWait: Result := 'progress';
    crNo: Result := 'not-allowed';
    crAppStart: Result := 'wait';
    crHelp: Result := 'help';
    crHandPoint: Result := 'pointer';
    else
      Result := '';
  end;
end;

{ TControlCanvas }

procedure TControlCanvas.SetHeight(AValue: NativeInt);
begin
  if (FHeight <> AValue) then
  begin
    FHeight := AValue;
    FCanvasElement.Height := FHeight;
  end;
end;

procedure TControlCanvas.SetWidth(AValue: NativeInt);
begin
  if (FWidth <> AValue) then
  begin
    FWidth := AValue;
    FCanvasElement.Width := FWidth;
  end;
end;

constructor TControlCanvas.Create(AControl: TControl);
begin
  inherited Create;
  if (Assigned(AControl)) then
  begin
    Height := AControl.Height;
    Width := AControl.Width;
    Font.Assign(AControl.Font);
    Brush.Color := AControl.Color;
    Pen.Color := AControl.Font.Color;
    FControl := AControl;
    FControl.HandleElement.InsertBefore(FCanvasElement, AControl.HandleElement.FirstChild);
    FControl.Invalidate;
  end;
end;

{ TControlBorderSpacing }

procedure TControlBorderSpacing.SetAround(AValue: NativeInt);
begin
  if (FAround <> AValue) then
  begin
    FAround := AValue;
    Changed;
  end;
end;

procedure TControlBorderSpacing.SetBottom(AValue: NativeInt);
begin
  if (FBottom <> AValue) then
  begin
    FBottom := AValue;
    Changed;
  end;
end;

procedure TControlBorderSpacing.SetLeft(AValue: NativeInt);
begin
  if (FLeft <> AValue) then
  begin
    FLeft := AValue;
    Changed;
  end;
end;

procedure TControlBorderSpacing.SetRight(AValue: NativeInt);
begin
  if (FRight <> AValue) then
  begin
    FRight := AValue;
    Changed;
  end;
end;

procedure TControlBorderSpacing.SetTop(AValue: NativeInt);
begin
  if (FTop <> AValue) then
  begin
    FTop := AValue;
    Changed;
  end;
end;

procedure TControlBorderSpacing.Changed;
begin
  if (FUpdateCount = 0) and (Assigned(FOnChange)) then
  begin
    FOnChange(Self);
  end;
end;

constructor TControlBorderSpacing.Create;
begin
  inherited Create;
  FBottom := 0;
  FLeft := 0;
  FRight := 0;
  FTop := 0;
  FUpdateCount := 0;
end;

procedure TControlBorderSpacing.Assign(Source: TPersistent);
var
  VSpacing: TControlBorderSpacing;
begin
  if (Assigned(Source)) and (Source is TControlBorderSpacing) then
  begin
    BeginUpdate;
    try
      VSpacing := TControlBorderSpacing(Source);
      FAround := VSpacing.Around;
      FBottom := VSpacing.Bottom;
      FLeft := VSpacing.Left;
      FRight := VSpacing.Right;
      FTop := VSpacing.Top;
    finally
      EndUpdate;
    end;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

procedure TControlBorderSpacing.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TControlBorderSpacing.EndUpdate;
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

{ TControl }

function TControl.GetClientHeight: NativeInt;
begin
  Result := ClientRect.Bottom;
end;

function TControl.GetClientOrigin: TPoint;
begin
  if (Assigned(FParent)) then
  begin
    Result := Parent.ClientOrigin;
    Inc(Result.X, FLeft);
    Inc(Result.Y, FTop);
  end
  else
  begin
    raise TJSError.New(Format('Control ''%s'' has no parent window', [Name]));
  end;
end;

function TControl.GetClientRect: TRect;
begin
  Result := Rect(0, 0, FWidth - 1, FHeight - 1);
end;

function TControl.GetClientWidth: NativeInt;
begin
  Result := ClientRect.Right;
end;

function TControl.GetText: TCaption;
begin
  Result := RealGetText;
end;

function TControl.IsAnchorsStored: Boolean;
begin
  Result := Anchors <> AnchorAlign[Align];
end;

procedure TControl.SetAlign(AValue: TAlign);
var
  oldalign: TAlign;
begin
  if (FAlign <> AValue) then
  begin
    oldalign := FAlign;
    FAlign := AValue;
    { as long as Anchors were the default for the previous Align keep them as
      the default values for the new Align }
    if (Anchors = AnchorAlign[oldalign]) and (Anchors <> AnchorAlign[FAlign]) then
      Anchors := AnchorAlign[FAlign];
    { if we have a parent we need to get our new size which the parent needs to
      calculate first }
    if Assigned(FParent) then
      FParent.ReAlign
    else
      ReAlign;
  end;
end;

procedure TControl.SetAnchors(AValue: TAnchors);
begin
  if FAnchors = AValue then
    Exit;
  FAnchors := AValue;
  { changing the anchors per se does not change the position of any control
    inside of it }
  //ReAlign;
end;

procedure TControl.SetAutoSize(AValue: boolean);
begin
  if (FAutoSize <> AValue) then
  begin
    FAutoSize := AValue;
    if (FAutoSize) then
    begin
      AdjustSize;
    end;
  end;
end;

procedure TControl.SetBorderSpacing(AValue: TControlBorderSpacing);
begin
  FBorderSpacing.Assign(AValue);
end;

procedure TControl.SetBorderStyle(AValue: TBorderStyle);
begin
  if (FBorderStyle <> AValue) then
  begin
    FBorderStyle := AValue;
    Changed;
  end;
end;

procedure TControl.SetClientSize(AValue: TPoint);
var
  VClient: TRect;
begin
  VClient := GetClientRect;
  SetBounds(FLeft, FTop, (FWidth - VClient.Right + AValue.X), (FHeight - VClient.Bottom + AValue.Y));
end;

procedure TControl.SetClientHeight(AValue: NativeInt);
begin
  SetClientSize(Point(ClientWidth, AValue));
end;

procedure TControl.SetClientWidth(AValue: NativeInt);
begin
  SetClientSize(Point(AValue, ClientHeight));
end;

procedure TControl.SetColor(AValue: TColor);
begin
  if (FColor <> AValue) then
  begin
    FColor := AValue;
    FParentColor := False;
    ColorChanged(Self);
  end;
end;

procedure TControl.SetCursor(AValue: TCursor);
begin
  if (FCursor <> AValue) then
  begin
    FCursor := AValue;
    Changed;
  end;
end;

procedure TControl.SetEnabled(AValue: boolean);
begin
  if (FEnabled <> AValue) then
  begin
    FEnabled := AValue;
    Changed;
  end;
end;

procedure TControl.SetFont(AValue: TFont);
begin
  if (not FFont.IsEqual(AValue)) then
  begin
    FFont.Assign(AValue);
  end;
end;

procedure TControl.SetHandleClass(AValue: string);
begin
  if (FHandleClass <> AValue) then
  begin
    FHandleClass := AValue;
    Changed;
  end;
end;

procedure TControl.SetHandleId(AValue: string);
begin
  if (FHandleId <> AValue) then
  begin
    FHandleId := AValue;
    Changed;
  end;
end;

procedure TControl.SetHeight(AValue: NativeInt);
begin
  SetBounds(FLeft, FTop, FWidth, AValue);
end;

procedure TControl.SetHint(AValue: string);
begin
  if (FHint <> AValue) then
  begin
    FHint := AValue;
    Changed;
  end;
end;

procedure TControl.SetLeft(AValue: NativeInt);
begin
  SetBounds(AValue, FTop, FWidth, FHeight);
end;

procedure TControl.SetParent(AValue: TWinControl);
begin
  if (Assigned(FParent)) then
  begin
    FParent.UnRegisterChild(Self);
  end;
  CheckNewParent(AValue);
  FParent := AValue;
  if (Assigned(FParent)) then
  begin
    FParent.RegisterChild(Self);
    BeginUpdate;
    try
      if (FParentColor) then
      begin
        FColor := FParent.Color;
      end;
      if (FParentFont) then
      begin
        FFont.Assign(FParent.FFont);
      end;
      if (FParentShowHint) then
      begin
        FShowHint := FParent.ShowHint;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TControl.SetParentColor(AValue: boolean);
begin
  if (FParentColor <> AValue) then
  begin
    FParentColor := AValue;
    if (FParentColor) and (Assigned(FParent)) then
    begin
      FColor := FParent.Color;
      Changed;
    end;
  end;
end;

procedure TControl.SetParentFont(AValue: boolean);
begin
  if (FParentFont <> AValue) then
  begin
    FParentFont := AValue;
    if (FParentFont) and (Assigned(FParent)) and (not FFont.IsEqual(FParent.Font)) then
    begin
      FFont.Assign(FParent.Font);
    end;
  end;
end;

procedure TControl.SetParentShowHint(AValue: boolean);
begin
  if (FParentShowHint <> AValue) then
  begin
    FParentShowHint := AValue;
    if (FParentShowHint) and (Assigned(FParent)) then
    begin
      FShowHint := FParent.ShowHint;
      Changed;
    end;
  end;
end;

procedure TControl.SetShowHint(AValue: boolean);
begin
  if (FShowHint <> AValue) then
  begin
    FShowHint := AValue;
    FParentShowHint := False;
    Changed;
  end;
end;

procedure TControl.SetTabOrder(AValue: NativeInt);
begin
  if (FTabOrder <> AValue) then
  begin
    FTabOrder := AValue;
    if (Assigned(FParent)) then
    begin
      FParent.UpdateTabOrder(Self);
    end;
  end;
end;

procedure TControl.SetTabStop(AValue: boolean);
begin
  if (FTabStop <> AValue) then
  begin
    FTabStop := AValue;
    Changed;
  end;
end;

procedure TControl.SetText(AValue: TCaption);
begin
  RealSetText(AValue);
end;

procedure TControl.SetTop(AValue: NativeInt);
begin
  SetBounds(FLeft, AValue, FWidth, FHeight);
end;

procedure TControl.SetVisible(AValue: boolean);
begin
  if (FVisible <> AValue) then
  begin
    FVisible := AValue;
    ReAlign;
  end;
end;

procedure TControl.SetWidth(AValue: NativeInt);
begin
  SetBounds(FLeft, FTop, AValue, FHeight);
end;

procedure TControl.Click;
begin
  if (Assigned(FOnClick)) then
  begin
    FOnClick(Self);
  end;
end;

procedure TControl.DblClick;
begin
  if (Assigned(FOnDblClick)) then
  begin
    FOnDblClick(Self);
  end;
end;

procedure TControl.DoResize;
begin
  if (Assigned(FOnResize)) then
  begin
    FOnResize(Self);
  end;
end;

procedure TControl.DoScroll;
begin
  if (Assigned(FOnScroll)) then
  begin
    FOnScroll(Self);
  end;
end;

procedure TControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if (Assigned(FOnMouseDown)) then
  begin
    FOnMouseDown(Self, Button, Shift, X, Y);
  end;
end;

procedure TControl.MouseEnter;
begin
  if (Assigned(FOnMouseEnter)) then
  begin
    FOnMouseEnter(Self);
  end;
end;

procedure TControl.MouseLeave;
begin
  if (Assigned(FOnMouseLeave)) then
  begin
    FOnMouseLeave(Self);
  end;
end;

procedure TControl.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  if (Assigned(FOnMouseMove)) then
  begin
    FOnMouseMove(Self, Shift, X, Y);
  end;
end;

procedure TControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if (Assigned(FOnMouseUp)) then
  begin
    FOnMouseUp(Self, Button, Shift, X, Y);
  end;
end;

procedure TControl.MouseWeel(Shift: TShiftState; WheelDelta: NativeInt; MousePos: TPoint; var Handled: boolean);
begin
  if (Assigned(FOnMouseWheel)) then
  begin
    FOnMouseWheel(Self, Shift, WheelDelta, MousePos, Handled);
  end;
end;

function TControl.HandleClick(AEvent: TJSMouseEvent): boolean;
begin
  AEvent.StopPropagation;
  Click();
  Result := True;
end;

function TControl.HandleDblClick(AEvent: TJSMouseEvent): boolean;
begin
  AEvent.StopPropagation;
  DblClick();
  Result := True;
end;

function TControl.HandleMouseDown(AEvent: TJSMouseEvent): boolean;
var
  VButton: TMouseButton;
  VOffSets: TRect;
  VShift: TShiftState;
  X, Y: NativeInt;
begin
  VButton := ExtractMouseButton(AEvent);
  VOffSets := OffSets(FHandleElement);
  VShift := ExtractShiftState(AEvent);
  X := Trunc(AEvent.ClientX - VOffSets.Left);
  Y := Trunc(AEvent.ClientY - VOffSets.Top);
  AEvent.StopPropagation;
  MouseDown(VButton, VShift, X, Y);
  Result := True;
end;

function TControl.HandleMouseEnter(AEvent: TJSMouseEvent): boolean;
begin
  AEvent.StopPropagation;
  MouseEnter();
  Result := True;
end;

function TControl.HandleMouseLeave(AEvent: TJSMouseEvent): boolean;
begin
  AEvent.StopPropagation;
  MouseLeave();
  Result := True;
end;

function TControl.HandleMouseMove(AEvent: TJSMouseEvent): boolean;
var
  VOffSets: TRect;
  VShift: TShiftState;
  X, Y: NativeInt;
begin
  VOffSets := OffSets(FHandleElement);
  VShift := ExtractShiftState(AEvent);
  X := Trunc(AEvent.ClientX - VOffSets.Left);
  Y := Trunc(AEvent.ClientY - VOffSets.Top);
  AEvent.StopPropagation;
  MouseMove(VShift, X, Y);
  Result := True;
end;

function TControl.HandleMouseUp(AEvent: TJSMouseEvent): boolean;
var
  VButton: TMouseButton;
  VOffSets: TRect;
  VShift: TShiftState;
  X, Y: NativeInt;
begin
  VButton := ExtractMouseButton(AEvent);
  VOffSets := OffSets(FHandleElement);
  VShift := ExtractShiftState(AEvent);
  X := Trunc(AEvent.ClientX - VOffSets.Left);
  Y := Trunc(AEvent.ClientY - VOffSets.Top);
  AEvent.StopPropagation;
  MouseUp(VButton, VShift, X, Y);
  Result := True;
end;

function TControl.HandleMouseWheel(AEvent: TJSWheelEvent): boolean;
var
  VDelta: NativeInt;
  VHandled: boolean;
  VMousePos: TPoint;
  VShift: TShiftState;
  VOffSets: TRect;
begin
  VDelta := Trunc(-AEvent.deltaY);
  VHandled := False;
  VOffSets := OffSets(FHandleElement);
  VMousePos := Point(VOffSets.Left, VOffSets.Top);
  VShift := ExtractShiftState(AEvent);
  AEvent.StopPropagation;
  MouseWeel(VShift, VDelta, VMousePos, VHandled);
  Result := True;
end;

function TControl.HandleResize(AEvent: TJSEvent): boolean;
begin
  AEvent.StopPropagation;
  DoResize();
  Result := True;
end;

function TControl.HandleScroll(AEvent: TJSEvent): boolean;
begin
  AEvent.StopPropagation;
  DoScroll();
  Result := True;
end;

procedure TControl.Loaded;
begin
  inherited Loaded;
  FDesignRect := Rect(Left, Top, Left + Width - 1, Top + Height - 1);
  Changed;
end;

procedure TControl.Changed;
var
  form: TCustomForm;

  function AdjustWithPPI(aValue: Integer): Integer;
  begin
    if Assigned(form) then
      Result := Trunc(96 * aValue / form.DesignTimePPI)
    else
      Result := aValue;
  end;

  function FindParentForm: TCustomForm;
  var
    p: TWinControl;
  begin
    p := Parent;
    while Assigned(p) and not (p is TCustomForm) do
      p := p.Parent;
    if p is TCustomForm then
      Result := TCustomForm(p)
    else
      Result := Nil;
  end;

begin
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    form := FindParentForm;

    with FHandleElement do
    begin
      /// Id
      if (FHandleId <> '') then
      begin
        SetAttribute('id', FHandleId);
      end
      else
      begin
        RemoveAttribute('id');
      end;

      /// Class
      if (FHandleClass <> '') then
      begin
        SetAttribute('class', FHandleClass);
      end
      else
      begin
        RemoveAttribute('class');
      end;
                    
      /// Style
      if (FHandleClass = '') and (FHandleId = '') then
      begin      
        /// Font
        Style.SetProperty('color', JSColor(FFont.Color));
        UpdateHtmlElementFont(FHandleElement, FFont, False);
        /// Color
        if (FColor in [clDefault, clNone]) then
        begin
          Style.RemoveProperty('background-color');
        end
        else
        begin
          Style.SetProperty('background-color', JSColor(FColor));
        end;
      end;

      /// Bounds
      Style.SetProperty('left', IntToStr(AdjustWithPPI(FLeft)) + 'px');
      Style.SetProperty('top', IntToStr(AdjustWithPPI(FTop)) + 'px');
      Style.SetProperty('width', IntToStr(AdjustWithPPI(FWidth)) + 'px');
      Style.SetProperty('height', IntToStr(AdjustWithPPI(FHeight)) + 'px');

      /// Cursor
      Style.SetProperty('cursor', JSCursor(FCursor));

      /// Enabled
      if (FEnabled) then
      begin
        RemoveAttribute('disabled');    
        Style.RemoveProperty('opacity');
      end
      else
      begin
        SetAttribute('disabled', 'true'); 
        Style.SetProperty('opacity','0.5');
      end;

      /// Visibility
      if (FVisible) then
      begin
        Style.SetProperty('visibility', 'visible');
        Style.SetProperty('display', 'block');
      end
      else
      begin
        Style.SetProperty('visibility', 'hidden');
        Style.SetProperty('display', 'none');
      end;

      /// Hint
      if (FHint <> '') and (FShowHint) then
      begin
        SetAttribute('title', FHint);
      end
      else
      begin
        RemoveAttribute('title');
      end;

      /// Border Style
      if (FBorderStyle = bsNone) then
      begin
        Style.SetProperty('border-style', 'none');
      end
      else
      begin
        Style.RemoveProperty('border-style');
      end;

      /// Tab
      SetAttribute('tabindex', IfThen(FTabStop, '1', '-1'));

      /// Position
      Style.SetProperty('position', 'absolute');

      /// Scroll
      Style.SetProperty('overflow', 'hidden');

      /// Defines how the width and height of an element are calculated
      Style.SetProperty('-webkit-box-sizing', 'border-box');
      Style.SetProperty('-moz-box-sizing', 'border-box');
      Style.SetProperty('box-sizing', 'border-box');
    end;
  end;
end;

{$push}
{$hints off}

function TControl.CreateHandleElement: TJSHTMLElement;
begin
  raise TJSError.New(Format('%s.CreateHandleElement=nil', [ClassName]));
end;

{$pop}

procedure TControl.RegisterHandleEvents;
begin
  with FHandleElement do
  begin
    AddEventListener('click', @HandleClick);
    AddEventListener('dblclick', @HandleDblClick);
    AddEventListener('mousedown', @HandleMouseDown);
    AddEventListener('mouseenter', @HandleMouseEnter);
    AddEventListener('mouseleave', @HandleMouseLeave);
    AddEventListener('mousemove', @HandleMouseMove);
    AddEventListener('mouseup', @HandleMouseUp);
    AddEventListener('scroll', @HandleScroll);
    AddEventListener('resize', @HandleResize);
    AddEventListener('wheel', @HandleMouseWheel);
  end;
end;

procedure TControl.UnRegisterHandleEvents;
begin
  with FHandleElement do
  begin
    RemoveEventListener('click', @HandleClick);
    RemoveEventListener('dblclick', @HandleDblClick);
    RemoveEventListener('mousedown', @HandleMouseDown);
    RemoveEventListener('mouseenter', @HandleMouseEnter);
    RemoveEventListener('mouseleave', @HandleMouseLeave);
    RemoveEventListener('mousemove', @HandleMouseMove);
    RemoveEventListener('mouseup', @HandleMouseUp);
    RemoveEventListener('scroll', @HandleScroll);
    RemoveEventListener('resize', @HandleResize);
    RemoveEventListener('wheel', @HandleMouseWheel);
  end;
end;

{$push}
{$hints off}

function TControl.CheckChildClassAllowed(AChildClass: TClass): boolean;
begin
  Result := False;
end;

{$pop}

procedure TControl.CheckNewParent(AParent: TWinControl);
begin
  if (Assigned(AParent)) and (not AParent.CheckChildClassAllowed(Self.ClassType)) then
  begin
    raise TJSError.New(Format('Control of class ''%s'' can''t have control of class ''%s'' as a child', [AParent.ClassType, Self.ClassName]));
  end;
  if (Self is TCustomForm) and (AParent is TCustomForm) then
  begin
    raise TJSError.New('A "Form" can''t have another "Form" as parent');
  end;
  if (Self = AParent) then
  begin
    raise TJSError.New('A "Control" can''t have itself as a Parent');
  end;
end;

procedure TControl.RegisterChild(AControl: TControl);
var
  VIndex: NativeInt;
begin
  if (Assigned(AControl)) then
  begin
    VIndex := FControls.IndexOf(AControl);
    if (VIndex < 0) then
    begin
      FControls.Push(AControl);
      if (not FHandleElement.Contains(AControl.HandleElement)) then
      begin
        FHandleElement.AppendChild(AControl.HandleElement);
      end;
      ReAlign;
      /// Update tab order
      AControl.SetTabOrder(FControls.Length); /// New order
    end;
  end;
end;

procedure TControl.UnRegisterChild(AControl: TControl);
var
  VIndex: NativeInt;
begin
  if (Assigned(AControl)) then
  begin
    VIndex := FControls.IndexOf(AControl);
    if (VIndex >= 0) then
    begin
      FControls.Splice(VIndex, 1);
      if (FHandleElement.Contains(AControl.HandleElement)) then
      begin
        FHandleElement.RemoveChild(AControl.HandleElement);
      end;
      ReAlign;
      /// Update tab order
      UpdateTabOrder(nil);
    end;
  end;
end;

procedure TControl.AlignControls;

  function AnchorsToStr(const aAnchors: TAnchors): String;
  const
    AnchorStr: array[TAnchorKind] of String = (
      'Top', 'Left', 'Right', 'Bottom'
    );
  var
    anchor: TAnchorKind;
  begin
    Result := '';
    for anchor := Low(TAnchorKind) to High(TAnchorKind) do
      if anchor in aAnchors then begin
        if Result <> '' then
          Result := Result + ', ';
        Result := Result + AnchorStr[anchor];
      end;
  end;

var
  VControl: TControl;
  VSpacing: TControlBorderSpacing;
  VIndex: NativeInt;
  VLeft: NativeInt;
  VTop: NativeInt;
  VRight: NativeInt;
  VBotton: NativeInt;
  VWidth: NativeInt;
  newleft, newtop, newright, newbottom: NativeInt;
begin
  if cfInAlignControls in FControlFlags then
    Exit;
  Include(FControlFlags, cfInAlignControls);
  BeginUpdate;
  try
    VLeft := 0;
    VTop := 0;
    VRight := FWidth;
    VBotton := FHeight;
    VWidth := FWidth;
    /// Top
    for VIndex := 0 to (FControls.Length - 1) do
    begin
      VControl := TControl(FControls[VIndex]);
      if (Assigned(VControl)) and (VControl.Align = alTop) and (VControl.Visible) then
      begin
        VControl.BeginUpdate;
        try
          VSpacing := VControl.BorderSpacing;
          VControl.Left := VLeft + VSpacing.Left + VSpacing.Around;
          VControl.Top := VTop + VSpacing.Top + VSpacing.Around;
          VControl.Width := VWidth - VSpacing.Left - VSpacing.Right - (VSpacing.Around * 2);
          VControl.Height := VControl.Height;
        finally
          VControl.EndUpdate;
        end;
        VTop := VTop + VControl.Height + VSpacing.Top + VSpacing.Bottom + (VSpacing.Around * 2);
      end;
    end;
    if (VTop < 0) then
    begin
      VTop := 0;
    end;
    /// Bottom
    for VIndex := 0 to (FControls.Length - 1) do
    begin
      VControl := TControl(FControls[VIndex]);
      if (Assigned(VControl)) and (VControl.Align = alBottom) and (VControl.Visible) then
      begin
        VControl.BeginUpdate;
        try
          VSpacing := VControl.BorderSpacing;
          { a control with bottom alignment and top anchor set keeps its
            position and enlarges its size instead of keeping its size }
          VControl.Left := VLeft + VSpacing.Left + VSpacing.Around;
          if not (akTop in VControl.Anchors) then
            VControl.Top := VBotton - VControl.Height - VSpacing.Bottom - VSpacing.Around
          else
            VControl.Top := VControl.Top;
          VControl.Width := VWidth - VSpacing.Left - VSpacing.Right - (VSpacing.Around * 2);
          if not (akTop in VControl.Anchors) then
            VControl.Height := VControl.Height
          else
            VControl.Height := VBotton - VControl.Top;
        finally
          VControl.EndUpdate;
        end;
        VBotton := VBotton - VControl.Height - VSpacing.Top - VSpacing.Bottom - (VSpacing.Around * 2);
      end;
    end;
    if (VBotton < 0) then
    begin
      VBotton := 0;
    end;
    /// Left
    for VIndex := 0 to (FControls.Length - 1) do
    begin
      VControl := TControl(FControls[VIndex]);
      if (Assigned(VControl)) and (VControl.Align = alLeft) and (VControl.Visible) then
      begin
        VControl.BeginUpdate;
        try
          VSpacing := VControl.BorderSpacing;
          VControl.Left := VLeft + VSpacing.Left + VSpacing.Around;
          VControl.Top := VTop + VSpacing.Top + VSpacing.Around;
          VControl.Width := VControl.Width;
          VControl.Height := VBotton - VTop - VSpacing.Top - VSpacing.Bottom - (VSpacing.Around * 2);
        finally
          VControl.EndUpdate;
        end;
        VLeft := VLeft + VControl.Width + VSpacing.Left + VSpacing.Right + (VSpacing.Around * 2);
      end;
    end;
    if (VLeft < 0) then
    begin
      VLeft := 0;
    end;
    /// Right
    for VIndex := 0 to (FControls.Length - 1) do
    begin
      VControl := TControl(FControls[VIndex]);
      if (Assigned(VControl)) and (VControl.Align = alRight) and (VControl.Visible) then
      begin
        VControl.BeginUpdate;
        try
          VSpacing := VControl.BorderSpacing;
          { a control with right alignment and left anchor set keeps its
            position and enlarges its size instead of keeping its size }
          if not (akLeft in Anchors) then
            VControl.Left := VRight - VControl.Width - VSpacing.Right - VSpacing.Around
          else
            VControl.Left := VControl.Left;
          VControl.Top := VTop + VSpacing.Top + VSpacing.Around;
          if not (akLeft in Anchors) then
            VControl.Width := VControl.Width
          else
            VControl.Width := VRight - VControl.Left;
          VControl.Height := VBotton - VTop - VSpacing.Top - VSpacing.Bottom - (VSpacing.Around * 2);
        finally
          VControl.EndUpdate;
        end;
        VRight := VRight - VControl.Width - VSpacing.Left - VSpacing.Right - (VSpacing.Around * 2);
      end;
    end;
    if (VRight < 0) then
    begin
      VRight := 0;
    end;
    /// Client
    for VIndex := 0 to (FControls.Length - 1) do
    begin
      VControl := TControl(FControls[VIndex]);
      if (Assigned(VControl)) and (VControl.Align = alClient) and (VControl.Visible) then
      begin
        VControl.BeginUpdate;
        try
          VSpacing := VControl.BorderSpacing;
          VControl.Left := VLeft + VSpacing.Left + VSpacing.Around;
          VControl.Top := VTop + VSpacing.Top + VSpacing.Around;
          VControl.Width := VRight - VLeft - VSpacing.Left - VSpacing.Right - (VSpacing.Around * 2);
          VControl.Height := VBotton - VTop - VSpacing.Top - VSpacing.Bottom - (VSpacing.Around * 2);
        finally
          VControl.EndUpdate;
        end;
      end;
    end;
    { alNone, but anchored }
    for VIndex := 0 to (FControls.Length - 1) do begin
      VControl := TControl(FControls[VIndex]);
      if Assigned(VControl) and (VControl.Align = alNone) and VControl.Visible and (VControl.Anchors <> []) then begin
        VControl.BeginUpdate;
        try
          if akLeft in VControl.Anchors then
            newleft := VControl.Left;
          if akTop in VControl.Anchors then
            newtop := VControl.Top;
          if akBottom in VControl.Anchors then
            newbottom := Height - (FDesignRect.Bottom - VControl.FDesignRect.Bottom);
          if akRight in VControl.Anchors then
            newright := Width - (FDesignRect.Right - VControl.FDesignRect.Right);

          if [akLeft, akRight] <= VControl.Anchors then begin
            VControl.Left := newleft;
            VControl.Width := newright - newleft + 1;
          end else if akLeft in VControl.Anchors then
            VControl.Left := newleft
          else if akRight in VControl.Anchors then
            VControl.Left := newright - VControl.Width;

          if [akTop, akBottom] <= VControl.Anchors then begin
            VControl.Top := newtop;
            VControl.Height := newbottom - newtop + 1;
          end else if akTop in VControl.Anchors then
            VControl.Top := newtop
          else if akBottom in VControl.Anchors then
            VControl.Top := newbottom - VControl.Height;
        finally
          VControl.EndUpdate;
        end;
      end;
    end;
  finally
    Exclude(FControlFlags, cfInAlignControls);
    EndUpdate;
  end;
end;

function TControl.RealGetText: string;
begin
  Result := FCaption;
end;

procedure TControl.RealSetText(const AValue: string);
begin
  if (FCaption <> AValue) then
  begin
    FCaption := AValue;
    Changed;
  end;
end;

{$push}
{$hints off}

procedure TControl.BorderSpacingChanged(Sender: TObject);
begin
  if (Assigned(FParent)) then
  begin
    FParent.AlignControls;
  end;
end;

{$pop}

{$push}
{$hints off}

procedure TControl.ColorChanged(Sender: TObject);
begin
  Changed;
end;

{$pop}

{$push}
{$hints off}

procedure TControl.FontChanged(Sender: TObject);
begin
  Changed;
end;

{$pop}

function TControl.TabOrderArray: TJSArray;
begin
  Result := FControls.Slice(0).Sort(@CompareTabOrder);
end;

function TControl.CompareTabOrder(A, B: JSValue): NativeInt;
begin
  if (Assigned(A)) and (Assigned(B)) and (A is TControl) and (B is TControl) then
  begin
    Result := (TControl(A).TabOrder - TControl(B).TabOrder);
  end
  else
  begin
    Result := 0;
  end;
end;

procedure TControl.UpdateTabOrder(const AValue: TControl);
var
  VControl: TControl;
  VArray: TJSArray;
  VIndex: NativeInt;
begin
  /// Increment
  if (Assigned(AValue)) then
  begin
    for VIndex := 0 to (FControls.Length - 1) do
    begin
      VControl := TControl(FControls[VIndex]);
      if (Assigned(VControl)) and (VControl <> AValue) and (VControl.TabOrder >= AValue.TabOrder) then
      begin
        Inc(VControl.FTabOrder);
      end;
    end;
  end;
  /// Sort
  VArray := TabOrderArray;
  try
    for VIndex := 0 to (VArray.Length - 1) do
    begin
      VControl := TControl(VArray[VIndex]);
      if (Assigned(VControl)) then
      begin
        VControl.BeginUpdate;
        try
          VControl.FTabOrder := VIndex; /// New order
        finally
          VControl.EndUpdate;
        end;
      end;
    end;
  finally
    VArray.Length := 0;
  end;
end;

procedure TControl.SetParentComponent(AValue: TComponent);
begin
  if AValue is TWinControl then
    SetParent(TWinControl(AValue));
end;

class function TControl.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 75;
  Result.Cy := 50;
end;

constructor TControl.Create(AOwner: TComponent);
var
  sz: TSize;
begin
  inherited Create(AOwner);
  FHandleElement := CreateHandleElement;
  FHandleClass := '';
  FHandleId := '';
  RegisterHandleEvents;
  FControls := TJSArray.New;
  FBorderSpacing := TControlBorderSpacing.Create;
  FBorderSpacing.OnChange := @BorderSpacingChanged;
  FBorderStyle := bsSingle;
  FFont := TFont.Create;
  FFont.OnChange := @FontChanged;
  FAlign := alNone;
  FAnchors := [akLeft, akTop];
  FAutoSize := False;
  FCaption := '';
  FColor := clDefault;
  FCursor := crDefault;
  sz := GetControlClassDefaultSize;
  FDesignRect := Rect(0, 0, sz.cx - 1, sz.cy - 1);
  FEnabled := True;
  FLeft := 0;
  FParent := nil;
  FParentColor := False;
  FParentFont := True;
  FParentShowHint := True;
  FShowHint := False;
  FTabOrder := 0;
  FTabStop := True;
  FTop := 0;
  FUpdateCount := 0;
  FVisible := True;
end;

destructor TControl.Destroy;
begin
  DestroyComponents;
  if Assigned(FHandleElement) then
    UnRegisterHandleEvents;
  if (Assigned(FParent)) then
  begin
    FParent.UnRegisterChild(Self);
  end;
  if Assigned(FControls) then
    FControls.Length := 0;
  FBorderSpacing.Free;
  FBorderSpacing := nil;
  FFont.Free;
  FFont := nil;
  inherited Destroy;
end;

procedure TControl.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TControl.EndUpdate;
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

procedure TControl.AdjustSize;
begin
  /// At the moment it does nothing
end;

function TControl.IsParentOf(AControl: TControl): boolean;
begin
  Result := False;
  while Assigned(AControl) do
  begin
    AControl := AControl.Parent;
    if (Self = AControl) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TControl.IsUpdating: boolean;
begin
  Result := (FUpdateCount > 0);
end;

function TControl.GetTopParent: TControl;
begin
  Result := Self;
  while (Assigned(Result.Parent)) do
  begin
    Result := Result.Parent;
  end;
end;

function TControl.HasParent: boolean;
begin
  Result := (FParent <> nil);
end;

procedure TControl.Invalidate;
begin
  /// At the moment it does nothing
end;

procedure TControl.ReAlign;
begin
  AlignControls;
  if (Assigned(FParent)) then
  begin
    FParent.ReAlign;
  end;
  Invalidate;
end;

procedure TControl.BringToFront;
var
  VParentElement: TJSElement;
begin
  VParentElement := FHandleElement.ParentElement;
  if (Assigned(VParentElement)) then
  begin
    VParentElement.RemoveChild(FHandleElement);
    VParentElement.AppendChild(FHandleElement);
  end;
end;

procedure TControl.SendToBack;
var
  VNode: TJSNode;
  VParentElement: TJSElement;
  VIndex: NativeInt;
begin
  VParentElement := FHandleElement.ParentElement;
  if (Assigned(VParentElement)) then
  begin
    for VIndex := 0 to (VParentElement.ChildNodes.Length - 1) do
    begin
      VNode := VParentElement.ChildNodes[VIndex];
      if not (VNode is TJSHTMLCanvasElement) then
      begin
        VParentElement.RemoveChild(FHandleElement);
        VParentElement.InsertBefore(FHandleElement, VParentElement.ChildNodes[VIndex]);
        Exit;
      end;
    end;
  end;
end;

procedure TControl.SetBounds(ALeft, ATop, AWidth, AHeight: NativeInt);
begin
  { TODO: Constraint max min width and height }
  if (FLeft <> ALeft) or (FTop <> ATop) or (FWidth <> AWidth) or (FHeight <> AHeight) then
  begin
    FLeft := ALeft;
    FTop := ATop;
    if (AWidth > 0) then
    begin
      FWidth := AWidth;
    end
    else
    begin
      FWidth := 0;
    end;
    if (AHeight > 0) then
    begin
      FHeight := AHeight;
    end
    else
    begin
      FHeight := 0;
    end;
    Changed;
    ReAlign;
  end;
end;

{ TWinControl }

function TWinControl.GetControl(const AIndex: NativeInt): TControl;
begin
  Result := TControl(FControls[AIndex]);
end;

function TWinControl.GetControlCount: NativeInt;
begin
  Result := FControls.Length;
end;

function TWinControl.GetControlIndex(const AControl: TControl): NativeInt;
begin
  Result := FControls.IndexOf(AControl);
end;

procedure TWinControl.DoEnter;
begin
  if (Assigned(FOnEnter)) then
  begin
    FOnEnter(Self);
  end;
end;

procedure TWinControl.DoExit;
begin
  if (Assigned(FOnExit)) then
  begin
    FOnExit(Self);
  end;
end;

procedure TWinControl.KeyDown(var Key: NativeInt; Shift: TShiftState);
begin
  if (Assigned(FOnKeyDown)) then
  begin
    FOnKeyDown(Self, Key, Shift);
  end;
end;

procedure TWinControl.KeyPress(var Key: char);
begin
  if (Assigned(FOnKeyPress)) then
  begin
    FOnKeyPress(Self, Key);
  end;
end;

procedure TWinControl.KeyUp(var Key: NativeInt; Shift: TShiftState);
begin
  if (Assigned(FOnKeyUp)) then
  begin
    FOnKeyUp(Self, Key, Shift);
  end;
end;

function TWinControl.HandleEnter(AEvent: TJSFocusEvent): boolean;
var
  VParent: TControl;
begin
  VParent := FParent;
  while (Assigned(VParent)) do
  begin
    if (VParent is TCustomForm) then
    begin
      TCustomForm(VParent).ActiveControl := Self;
      Break;
    end;
    VParent := VParent.Parent;
  end;
  AEvent.StopPropagation;
  DoEnter();
  Result := True;
end;

function TWinControl.HandleExit(AEvent: TJSEvent): boolean;
begin
  AEvent.StopPropagation;
  DoExit();
  Result := True;
end;

function TWinControl.HandleKeyDown(AEvent: TJSKeyBoardEvent): boolean;
var
  VControl: TWinControl;
  VForm: TCustomForm;
  VKey: NativeInt;
  VParent: TControl;
  VShift: TShiftState;
begin
  /// Let each parent form with keypreview handle the key
  VParent := FParent;
  while (Assigned(VParent)) do
  begin
    if (VParent is TCustomForm) then
    begin
      VForm := TCustomForm(VParent);
      if (VForm.KeyPreview) and (VForm.HandleKeyDown(AEvent)) then
      begin
        Result := True;
        Exit;
      end;
    end;
    VParent := VParent.Parent;
  end;
  /// Handle the key
  VKey := ExtractKeyCode(AEvent);
  VShift := ExtractShiftState(AEvent);
  AEvent.StopPropagation;
  KeyDown(VKey, VShift);
  if (VKey = 0) then
  begin
    /// Consumed
    AEvent.PreventDefault;
  end
  else
  begin
    case VKey of
      { TODO: Use the navigation keys to change control. }
      /// Tab
      9:
      begin
        if (Assigned(FParent)) then
        begin
          if (ssShift in VShift) then
          begin
            VControl := FParent.FindFocusControl(Self, fsdPrev);
            if (not Assigned(VControl)) then
            begin
              VControl := FParent.FindFocusControl(nil, fsdLast);
            end;
          end
          else
          begin
            VControl := FParent.FindFocusControl(Self, fsdNext);
            if (not Assigned(VControl)) then
            begin
              VControl := FParent.FindFocusControl(nil, fsdFirst);
            end;
          end;
          /// backward/forward control
          if (Assigned(VControl)) and (VControl.CanSetFocus) then
          begin
            VControl.SetFocus;
          end;
          /// Consumed
          AEvent.PreventDefault;
        end;
      end;
    end;
  end;
  Result := True;
end;

function TWinControl.HandleKeyUp(AEvent: TJSKeyBoardEvent): boolean;
var
  VForm: TCustomForm;
  VKey: NativeInt;
  VParent: TControl;
  VShift: TShiftState;
begin
  /// Let each parent form with keypreview handle the key
  VParent := FParent;
  while (Assigned(VParent)) do
  begin
    if (VParent is TCustomForm) then
    begin
      VForm := TCustomForm(VParent);
      if (VForm.KeyPreview) and (VForm.HandleKeyUp(AEvent)) then
      begin
        Result := True;
        Exit;
      end;
    end;
    VParent := VParent.Parent;
  end;
  /// Handle the key
  VKey := ExtractKeyCode(AEvent);
  VShift := ExtractShiftState(AEvent);
  AEvent.StopPropagation;
  KeyUp(VKey, VShift);
  if (VKey = 0) then
  begin
    /// Consumed
    AEvent.PreventDefault;
  end;
  Result := True;
end;

function TWinControl.HandleKeyPress(AEvent: TJSKeyBoardEvent): boolean;
var
  VForm: TCustomForm;
  VKey: char;
  VParent: TControl;
begin
  /// Let each parent form with keypreview handle the key
  VParent := FParent;
  while (Assigned(VParent)) do
  begin
    if (VParent is TCustomForm) then
    begin
      VForm := TCustomForm(VParent);
      if (VForm.KeyPreview) and (VForm.HandleKeyPress(AEvent)) then
      begin
        Result := True;
        Exit;
      end;
    end;
    VParent := VParent.Parent;
  end;
  AEvent.StopPropagation;
  VKey := ExtractKeyChar(AEvent);
  if (VKey = #0) then
  begin
    /// Consumed
    AEvent.PreventDefault;
  end
  else
  begin
    KeyPress(VKey);
    if (VKey = #0) then
    begin
      /// Consumed
      AEvent.PreventDefault;
    end;
  end;
  Result := True;
end;

procedure TWinControl.RegisterHandleEvents;
begin
  inherited RegisterHandleEvents;
  with FHandleElement do
  begin
    AddEventListener('focus', @HandleEnter);
    AddEventListener('blur', @HandleExit);
    AddEventListener('keydown', @HandleKeyDown);
    AddEventListener('keypress', @HandleKeyPress);
    AddEventListener('keyup', @HandleKeyUp);
  end;
end;

procedure TWinControl.UnRegisterHandleEvents;
begin
  inherited UnRegisterHandleEvents;
  with FHandleElement do
  begin
    RemoveEventListener('focus', @HandleEnter);
    RemoveEventListener('blur', @HandleExit);
    RemoveEventListener('keydown', @HandleKeyDown);
    RemoveEventListener('keypress', @HandleKeyPress);
    RemoveEventListener('keyup', @HandleKeyUp);
  end;
end;

function TWinControl.CheckChildClassAllowed(AChildClass: TClass): boolean;
begin
  Result := (Assigned(AChildClass)) and (AChildClass.InheritsFrom(TControl));
end;

function TWinControl.FindFocusControl(const AStartControl: TWinControl; ADirection: TFocusSearchDirection): TWinControl;
var
  VControl: TControl;
  VArray: TJSArray;
  VIndex: NativeInt;
  VTabOrder: NativeInt;
begin
  Result := nil;
  VArray := TabOrderArray;
  if (VArray.Length = 0) then
  begin
    Exit;
  end;
  try   
    VTabOrder := VArray.IndexOf(AStartControl);  
    if (VTabOrder < 0) then
    begin
      if (ADirection in [fsdFirst]) then
      begin
        VTabOrder := VArray.Length-1;
      end
      else
      begin
        VTabOrder := 0;
      end
    end;
    /// Directions
    case ADirection of
      fsdFirst:
      begin
        VControl := TControl(VArray[0]);   
        if (Assigned(VControl)) and (VControl is TWinControl) and
           (VControl.Enabled) and (VControl.Visible) and (VControl.TabStop) then
        begin
          Exit(TWinControl(VControl));
        end;
      end;
      fsdLast:
      begin
        VControl := TControl(VArray[VArray.Length-1]);
        if (Assigned(VControl)) and (VControl is TWinControl) and
           (VControl.Enabled) and (VControl.Visible) and (VControl.TabStop) then
        begin
          Exit(TWinControl(VControl));
        end;
      end;
      fsdNext:
      begin
        if (VTabOrder < (VArray.Length-1)) then
        begin    
          for VIndex := (VTabOrder+1) to (VArray.Length - 1) do
          begin
            VControl := TControl(VArray[VIndex]);
            if (Assigned(VControl)) and (VControl is TWinControl) and
               (VControl.Enabled) and (VControl.Visible) and (VControl.TabStop) then
            begin
              Exit(TWinControl(VControl));
            end;
          end;
        end;
      end;
      fsdPrev:
      begin
        if (VTabOrder > 0) then
        begin
          for VIndex := (VTabOrder-1) downto 0 do
          begin
            VControl := TControl(VArray[VIndex]);
            if (Assigned(VControl)) and (VControl is TWinControl) and
               (VControl.Enabled) and (VControl.Visible) and (VControl.TabStop) then
            begin
              Exit(TWinControl(VControl));
            end;
          end;
        end;
      end
   end
  finally
    VArray.Length := 0;
  end;
end;

function TWinControl.Focused: boolean;
begin
  Result := (FHandleElement = Document.ActiveElement);
end;

function TWinControl.CanSetFocus: boolean;
var
  VControl: TControl;
begin
  VControl := Self;
  while True do
  begin
    if (not VControl.Visible) and (VControl.Enabled) then
    begin
      Result := False;
      Exit;
    end;
    if (Assigned(VControl.Parent)) then
    begin
      VControl := VControl.Parent;
    end
    else
    begin
      Break;
    end;
  end;
  /// The very top parent must be a form
  Result := (Assigned(VControl)) and (VControl is TCustomForm);
end;

procedure TWinControl.SetFocus;
begin
  FHandleElement.Focus();
end;

function TWinControl.ContainsControl(const AControl: TControl): boolean;
begin
  Result := (FControls.IndexOf(AControl) > -1);
end;

{ TCustomControl }

function TCustomControl.GetCanvas: TControlCanvas;
begin
  if (not Assigned(FCanvas)) then
  begin
    FCanvas := TControlCanvas.Create(Self);
  end;
  Result := FCanvas;
end;

procedure TCustomControl.ColorChanged(Sender: TObject);
begin
  if (Assigned(FCanvas)) then
  begin
    FCanvas.Brush.Color := Color;
  end;
  inherited ColorChanged(Sender);
end;

procedure TCustomControl.FontChanged(Sender: TObject);
begin
  if (Assigned(FCanvas)) then
  begin
    FCanvas.Font.Assign(Font);
  end;
  inherited FontChanged(Sender);
end;

procedure TCustomControl.Paint;
begin
  if (Assigned(FOnPaint)) then
  begin
    FOnPaint(Self);
  end;
end;

destructor TCustomControl.Destroy;
begin
  if (Assigned(FCanvas)) then
  begin
    FCanvas.Destroy;
    FCanvas := nil;
  end;
  inherited Destroy;
end;

procedure TCustomControl.Invalidate;
begin
  inherited Invalidate;
  Paint;
end;

end.
