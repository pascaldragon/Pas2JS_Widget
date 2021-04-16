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
unit StdCtrls;

{$I pas2js_widget.inc}

interface

uses
  Classes,
  SysUtils,
  Types,
  Web,
  WebExtra,
  Graphics,
  Controls,
  Forms;

type
  TEditCharCase = (ecNormal, ecUppercase, ecLowerCase);

  TScrollStyle = (ssNone, ssHorizontal, ssVertical, ssBoth,
    ssAutoHorizontal, ssAutoVertical, ssAutoBoth);

  { TCustomComboBox }

  TCustomComboBox = class(TWinControl)
    { TODO: DropDownCount, ItemHeight, ItemWidth...  }
  private
    FDropDownCount: integer;
    FItemHeight: NativeInt;
    FItemIndex: NativeInt;
    FItems: TStrings;
    FOnChange: TNotifyEvent;
    FSorted: boolean;
    procedure SetDropDownCount(AValue: integer);
    procedure SetItemHeight(AValue: NativeInt);
    procedure SetItemIndex(AValue: NativeInt);
    procedure SetItems(AValue: TStrings);
    procedure SetSorted(AValue: boolean);
  private
    procedure ItemsChange(ASender: TObject);
  protected
    procedure Change; virtual;
  protected
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  protected
    function HandleChange(AEvent: TJSEvent): boolean; virtual;
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
    procedure RegisterHandleEvents; override;
    procedure UnRegisterHandleEvents; override;
    function CheckChildClassAllowed(AChildClass: TClass): boolean; override;
    function RealGetText: string; override;
    procedure RealSetText(const AValue: string); override;
    procedure UpdateSorted; virtual;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddItem(const AItem: string; AObject: TObject); virtual;   
    procedure Append(const AItem: string);
    procedure Clear; virtual;
    property DropDownCount: integer read FDropDownCount write SetDropDownCount;
    property ItemHeight: NativeInt read FItemHeight write SetItemHeight;
    property ItemIndex: NativeInt read FItemIndex write SetItemIndex;
    property Items: TStrings read FItems write SetItems;
    property Sorted: boolean read FSorted write SetSorted;
  end;

  { TCustomListBox }

  TSelectionChangeEvent = procedure(Sender: TObject; User: boolean) of object;

  TCustomListBox = class(TWinControl)
  private
    FItemHeight: NativeInt;
    FItemIndex: NativeInt;
    FItems: TStrings;
    FMultiSelect: Boolean;
    FSelectionChanged: Boolean;
    FSelected: array of Boolean;
    FSorted: Boolean;
    FOnSelectionChange: TSelectionChangeEvent;
    function GetSelCount: integer;
    function GetSelected(Index: Integer): Boolean;
    procedure SetItemHeight(AValue: NativeInt);
    procedure SetItemIndex(AValue: NativeInt);
    procedure SetItems(AValue: TStrings);
    procedure SetMultiSelect(AValue: Boolean);
    procedure SetSelected(Index: Integer; AValue: Boolean);
    procedure SetSorted(AValue: Boolean);
  private
    procedure ItemsChanged(ASender: TObject);
  protected
    procedure SelectionChange(AUser: Boolean); virtual;
  protected
    function HandleChange(AEvent: TJSEvent): boolean; virtual;
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
    procedure RegisterHandleEvents; override;
    procedure UnRegisterHandleEvents; override;
    function CheckChildClassAllowed(AChildClass: TClass): boolean; override;
    procedure UpdateSorted; virtual;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddItem(const AItem: String; AObject: TObject); virtual;
    procedure Append(const AItem: String);
    procedure Clear;
    procedure ClearSelection;
    procedure SelectAll; virtual;
    procedure SelectRange(ALow, AHigh: Integer; ASelected: boolean); virtual;
    property ItemHeight: NativeInt read FItemHeight write SetItemHeight;
    property ItemIndex: NativeInt read FItemIndex write SetItemIndex default -1;
    property Items: TStrings read FItems write SetItems;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect default False;
    property SelCount: integer read GetSelCount;
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
    property Sorted: Boolean read FSorted write SetSorted default False;
    property OnSelectionChange: TSelectionChangeEvent read FOnSelectionChange write FOnSelectionChange;
  end;

  { TCustomEdit }

  TCustomEdit = class(TWinControl)
  private
    FAlignment: TAlignment;
    FCharCase: TEditCharCase;
    FMaxLength: NativeInt;
    FModified: boolean;
    FPasswordChar: char;
    FPattern: string;
    FReadOnly: boolean;
    FRequired: boolean;
    FSelLength: NativeInt;
    FSelStart: NativeInt;
    FText: string;
    FTextHint: string;
    FOnChange: TNotifyEvent;
    function GetSelLength: NativeInt;
    function GetSelStart: NativeInt;
    function GetSelText: string;
    procedure SetAlignment(AValue: TAlignment);
    procedure SetCharCase(AValue: TEditCharCase);
    procedure SetMaxLength(AValue: NativeInt);
    procedure SetModified(AValue: boolean);
    procedure SetPasswordChar(AValue: char);
    procedure SetPattern(AValue: string);
    procedure SetReadOnly(AValue: boolean);
    procedure SetRequired(AValue: boolean);
    procedure SetSelLength(AValue: NativeInt);
    procedure SetSelStart(AValue: NativeInt);
    procedure SetSelText(AValue: string);
    procedure SetTextHint(AValue: string);
  protected
    procedure Change; virtual;
    procedure DoEnter; override;
    procedure DoInput(ANewValue:string); virtual;
  protected
    function HandleInput(AEvent: TJSEvent): boolean; virtual;
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
    procedure RegisterHandleEvents; override;
    procedure UnRegisterHandleEvents; override;
    function CheckChildClassAllowed(AChildClass: TClass): boolean; override;
    function RealGetText: string; override;
    procedure RealSetText(const AValue: string); override;
    function InputType: string; virtual;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Clear;
    procedure SelectAll;
  public
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property CharCase: TEditCharCase read FCharCase write SetCharCase;
    property MaxLength: NativeInt read FMaxLength write SetMaxLength;
    property Modified: boolean read FModified write SetModified;
    property PasswordChar: char read FPasswordChar write SetPasswordChar;
    property Pattern: string read FPattern write SetPattern;
    property ReadOnly: boolean read FReadOnly write SetReadOnly;
    property Required: boolean read FRequired write SetRequired;
    property SelLength: NativeInt read GetSelLength write SetSelLength;
    property SelStart: NativeInt read GetSelStart write SetSelStart;
    property SelText: string read GetSelText write SetSelText;
    property TextHint: string read FTextHint write SetTextHint;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TCustomMemo }

  TCustomMemo = class(TWinControl)
    { TODO: WantTabs not work }
  private
    FAlignment: TAlignment;
    FCharCase: TEditCharCase;
    FLines: TStrings;
    FMaxLength: NativeInt;
    FModified: boolean;
    FReadOnly: boolean;
    FSelLength: NativeInt;
    FSelStart: NativeInt;
    FTextHint: string;
    FWantReturns: boolean;
    FWantTabs: boolean;
    FWordWrap: boolean;
    FOnChange: TNotifyEvent;
    function GetSelLength: NativeInt;
    function GetSelStart: NativeInt;
    function GetSelText: string;
    procedure SetAlignment(AValue: TAlignment);
    procedure SetCharCase(AValue: TEditCharCase);
    procedure SetLines(AValue: TStrings);
    procedure SetMaxLength(AValue: NativeInt);
    procedure SetModified(AValue: boolean);
    procedure SetReadOnly(AValue: boolean);
    procedure SetSelLength(AValue: NativeInt);
    procedure SetSelStart(AValue: NativeInt);
    procedure SetSelText(AValue: string);
    procedure SetTextHint(AValue: string);
    procedure SetWantReturns(AValue: boolean);
    procedure SetWantTabs(AValue: boolean);
    procedure SetWordWrap(AValue: boolean);
  protected
    procedure Change; virtual;
    procedure KeyDown(var Key: NativeInt; Shift: TShiftState); override;
  protected
    function HandleChange(AEvent: TJSEvent): boolean; virtual;
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
    procedure RegisterHandleEvents; override;
    procedure UnRegisterHandleEvents; override;
    function CheckChildClassAllowed(AChildClass: TClass): boolean; override;
    function RealGetText: string; override;
    procedure RealSetText(const AValue: string); override;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Append(const AValue: string);
    procedure Clear;
    procedure SelectAll;
  public
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property CharCase: TEditCharCase read FCharCase write SetCharCase;
    property Lines: TStrings read FLines write SetLines;
    property MaxLength: NativeInt read FMaxLength write SetMaxLength;
    property Modified: boolean read FModified write SetModified;
    property ReadOnly: boolean read FReadOnly write SetReadOnly;
    property SelLength: NativeInt read GetSelLength write SetSelLength;
    property SelStart: NativeInt read GetSelStart write SetSelStart;
    property SelText: string read GetSelText write SetSelText;
    property TextHint: string read FTextHint write SetTextHint;
    property WantReturns: boolean read FWantReturns write SetWantReturns;
    property WantTabs: boolean read FWantTabs write SetWantTabs;
    property WordWrap: boolean read FWordWrap write SetWordWrap;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TCustomButton }

  TCustomButton = class(TWinControl)
  private
    FCancel: boolean;
    FDefault: boolean;
    FModalResult: TModalResult;
    procedure SetCancel(AValue: boolean);
    procedure SetDefault(AValue: boolean);
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
    function CheckChildClassAllowed(AChildClass: TClass): boolean; override;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AdjustSize; override;
    procedure Click; override;
  public
    property Cancel: boolean read FCancel write SetCancel;
    property Default: boolean read FDefault write SetDefault;
    property ModalResult: TModalResult read FModalResult write FModalResult;
  end;

  TCheckBoxState = (cbUnchecked, cbChecked);
  TLeftRight = taLeftJustify..taRightJustify;

  { TCustomCheckbox }

  TCustomCheckbox = class(TWinControl)
  private
    FAlignment: TLeftRight;
    FLabelElement: TJSHTMLElement;
    FMarkElement: TJSHTMLInputElement;
    FState: TCheckBoxState;
    FOnChange: TNotifyEvent;
    function GetChecked: boolean;
    function GetState: TCheckBoxState;
    procedure SetAlignment(AValue: TLeftRight);
    procedure SetChecked(AValue: boolean);
    procedure SetState(AValue: TCheckBoxState);
  protected
    procedure DoOnChange; virtual;
  protected
    property MarkElement: TJSHTMLInputElement read FMarkElement;
    property LabelElement: TJSHTMLElement read FLabelElement;
    property Checked: boolean read GetChecked write SetChecked;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  protected
    function HandleClick(AEvent: TJSMouseEvent): boolean; override;
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
    function CreateMarkElement: TJSHTMLInputElement; virtual;
    function CreateLabelElement: TJSHTMLElement; virtual;
    function CheckChildClassAllowed(AChildClass: TClass): boolean; override;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
  public
    property Alignment: TLeftRight read FAlignment write SetAlignment default taRightJustify;
    property State: TCheckBoxState read GetState write SetState default cbUnchecked;
  end;

  { TCustomLabel }

  TCustomLabel = class(TWinControl)
  private
    FAlignment: TAlignment;
    FContentElement: TJSHTMLTableElement;
    FFocusControl: TWinControl;
    FLayout: TTextLayout;
    FTransparent: boolean;
    FWordWrap: boolean;
    procedure SetAlignment(AValue: TAlignment);
    procedure SetLayout(AValue: TTextLayout);
    procedure SetTransparent(AValue: boolean);
    procedure SetWordWrap(AValue: boolean);
  protected
    procedure DoEnter; override;
  protected
    property ContentElement: TJSHTMLTableElement read FContentElement;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property FocusControl: TWinControl read FFocusControl write FFocusControl;
    property Layout: TTextLayout read FLayout write SetLayout;
    property Transparent: boolean read FTransparent write SetTransparent;
    property WordWrap: boolean read FWordWrap write SetWordWrap;
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
    function CreateContentElement: TJSHTMLTableElement; virtual;
    function CheckChildClassAllowed(AChildClass: TClass): boolean; override;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AdjustSize; override;
    property AutoSize default True;
  end;

procedure ApplyScrollStyleToStyle(aStyle: TJSCSSStyleDeclaration; aScrollStyle: TScrollStyle);

implementation

uses
  RTLConsts;

procedure ApplyScrollStyleToStyle(aStyle: TJSCSSStyleDeclaration;
  aScrollStyle: TScrollStyle);
begin
  case aScrollStyle of
    ssNone: begin
      aStyle.removeProperty('overflow-x');
      aStyle.removeProperty('overflow-y');
      aStyle.setProperty('overflow', 'hidden');
    end;
    ssHorizontal: begin
      aStyle.removeProperty('overflow');
      aStyle.setProperty('overflow-y', 'hidden');
      aStyle.setProperty('overflow-x', 'scroll');
    end;
    ssVertical: begin
      aStyle.removeProperty('overflow');
      aStyle.setProperty('overflow-x', 'hidden');
      aStyle.setProperty('overflow-y', 'scroll');
    end;
    ssBoth: begin
      aStyle.removeProperty('overflow-x');
      aStyle.removeProperty('overflow-y');
      aStyle.setProperty('overflow', 'scroll');
    end;
    ssAutoHorizontal: begin
      aStyle.removeProperty('overflow');
      aStyle.setProperty('overflow-y', 'hidden');
      aStyle.setProperty('overflow-x', 'auto');
    end;
    ssAutoVertical: begin
      aStyle.removeProperty('overflow');
      aStyle.setProperty('overflow-x', 'hidden');
      aStyle.setProperty('overflow-x', 'scroll');
    end;
    ssAutoBoth: begin
      aStyle.removeProperty('overflow-x');
      aStyle.removeProperty('overflow-y');
      aStyle.setProperty('overflow', 'auto');
    end;
  end;
end;

{ TCustomComboBox }

procedure TCustomComboBox.SetDropDownCount(AValue: integer);
begin
  if (FDropDownCount <> AValue) then
  begin
    FDropDownCount := AValue;
    Changed;
  end;
end;

procedure TCustomComboBox.SetItemHeight(AValue: NativeInt);
begin
  if (FItemHeight <> AValue) then
  begin
    FItemHeight := AValue;
    Change;
  end;
end;

procedure TCustomComboBox.SetItemIndex(AValue: NativeInt);
begin
  if (AValue > -1) and (AValue < FItems.Count) then
  begin
    FItemIndex := AValue;
    Changed;
  end;
end;

procedure TCustomComboBox.SetItems(AValue: TStrings);
begin
  FItems.Assign(AValue);
  Changed;
end;

procedure TCustomComboBox.SetSorted(AValue: boolean);
begin
  if (FSorted <> AValue) then
  begin
    FSorted := AValue;
    UpdateSorted;
  end;
end;

procedure TCustomComboBox.ItemsChange(ASender: TObject);
begin
  Changed;
end;

procedure TCustomComboBox.Change;
begin
  if (Assigned(FOnChange)) then
  begin
    FOnChange(Self);
  end;
end;

function TCustomComboBox.HandleChange(AEvent: TJSEvent): boolean;
begin
  AEvent.StopPropagation;
  FItemIndex := TJSHTMLSelectElement(HandleElement).SelectedIndex;
  Change();
  Result := True;
end;

procedure TCustomComboBox.Changed;
var
  VIndex: NativeInt;
  VOptionElement: TJSHTMLOptionElement;
  VValue: string;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    /// Remove old items
    for VIndex := (TJSHTMLSelectElement(HandleElement).Length - 1) downto 0 do
    begin
      TJSHTMLSelectElement(HandleElement).Remove(VIndex);
    end;
    /// Add new items
    for VIndex := 0 to (FItems.Count - 1) do
    begin
      VValue := FItems[VIndex];
      VOptionElement := TJSHTMLOptionElement(Document.CreateElement('option'));
      VOptionElement.Value := VValue;
      VOptionElement.Text := VValue;
      VOptionElement.Selected := (VIndex = FItemIndex);
      TJSHTMLSelectElement(HandleElement).Add(VOptionElement);
    end;
    { add dummy item at the end to avoid problems with the ItemIndex }
    if FItemIndex < 0 then begin
      VOptionElement := TJSHTMLOptionElement(Document.CreateElement('option'));
      VOptionElement.Value := '';
      VOptionElement.Text := '';
      VOptionElement.Selected := True;
      VOptionElement.Disabled := True;
      VOptionElement.style.setProperty('display', 'none');
      TJSHTMLSelectElement(HandleElement).Add(VOptionElement);
    end;
  end;
end;

function TCustomComboBox.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('select'));
end;

procedure TCustomComboBox.RegisterHandleEvents;
begin
  inherited RegisterHandleEvents;
  with HandleElement do
  begin
    AddEventListener('change', @HandleChange);
  end;
end;

procedure TCustomComboBox.UnRegisterHandleEvents;
begin
  inherited UnRegisterHandleEvents;
  with HandleElement do
  begin
    RemoveEventListener('change', @HandleChange);
  end;
end;

{$push}
{$hints off}

function TCustomComboBox.CheckChildClassAllowed(AChildClass: TClass): boolean;
begin
  Result := False;
end;

{$pop}

function TCustomComboBox.RealGetText: string;
begin
  Result := FItems[FItemIndex];
end;

procedure TCustomComboBox.RealSetText(const AValue: string);
var
  VIndex: NativeInt;
begin
  VIndex := FItems.IndexOf(AValue);
  if (VIndex > -1) and (VIndex < FItems.Count) then
  begin
    FItemIndex := VIndex;
    Changed;
  end;
end;

procedure TCustomComboBox.UpdateSorted;
var
  VText: string;
begin
  VText := RealGetText;
  TStringList(FItems).Sorted := FSorted;
  Text := VText;
end;

class function TCustomComboBox.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 100;
  Result.Cy := 25;
end;

constructor TCustomComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDropDownCount := 8;
  FItemHeight := 0;
  FItemIndex := -1;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChange;
  FSorted := False;
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

destructor TCustomComboBox.Destroy;
begin
  FItems.Destroy;
  FItems := nil;
  inherited Destroy;
end;

procedure TCustomComboBox.AddItem(const AItem: string; AObject: TObject);
begin
  FItems.AddObject(AItem, AObject);
  Changed;
end;

procedure TCustomComboBox.Append(const AItem: string);
begin
  FItems.Append(AItem);
  Changed;
end;

procedure TCustomComboBox.Clear;
begin
  FItems.Clear;
  FItemIndex := -1;
  Changed;
end;

{ TCustomListBox }

procedure TCustomListBox.SetItemHeight(AValue: NativeInt);
begin
  if FItemHeight <> AValue then begin
    FItemHeight := AValue;
    Changed;
  end;
end;

procedure TCustomListBox.SetItemIndex(AValue: NativeInt);
begin
  if (AValue > -1) and (AValue < FItems.Count) then begin
    BeginUpdate;
    try
      if FMultiSelect then
        ClearSelection;
      FItemIndex := AValue;
      Changed;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TCustomListBox.SetItems(AValue: TStrings);
begin
  FItems.Assign(AValue);
  Changed;
end;

procedure TCustomListBox.SetSorted(AValue: Boolean);
begin
  if FSorted <> AValue then begin
    FSorted := AValue;
    UpdateSorted;
  end;
end;

function TCustomListBox.GetSelCount: integer;
var
  b: Boolean;
begin
  Result := 0;
  if FMultiSelect then begin
    for b in FSelected do
      if b then
        Inc(Result);
  end else if ItemIndex <> -1 then
    Inc(Result);
end;

function TCustomListBox.GetSelected(Index: Integer): Boolean;
begin
  if (Index < 0) or (Index >= FItems.Count) then
    raise EListError.CreateFmt(SListIndexError, [Index]);
  Result := FSelected[Index];
end;

procedure TCustomListBox.ItemsChanged(ASender: TObject);
begin
  if Length(FSelected) <> FItems.Count then
    SetLength(FSelected, FItems.Count);
  Changed;
end;

procedure TCustomListBox.SetMultiSelect(AValue: Boolean);
begin
  if FMultiSelect <> AValue then begin
    ClearSelection;
    FMultiSelect := AValue;
    if not (csLoading in ComponentState) then
      FSelectionChanged := True;
    Changed;
  end;
end;

procedure TCustomListBox.SetSelected(Index: Integer; AValue: Boolean);
var
  i: NativeInt;
begin
  if Index > High(FSelected) then
    raise EListError.CreateFmt(SListIndexError, [Index]);
  if AValue and not FMultiSelect then begin
    for i := 0 to High(FSelected) do
      if FSelected[i] then
        FSelected[i] := False;
  end;
  FSelected[Index] := AValue;
  if AValue then
    FItemIndex := Index
  else begin
    FItemIndex := -1;
    if FMultiSelect then begin
      for i := 0 to High(FSelected) do
        if FSelected[i] then begin
          FItemIndex := i;
          Break;
        end;
    end;
  end;
  if not (csLoading in ComponentState) then
    FSelectionChanged := True;
  Changed;
end;

procedure TCustomListBox.SelectionChange(AUser: Boolean);
begin
  if Assigned(FOnSelectionChange) then
    FOnSelectionChange(Self, AUser);
end;

function TCustomListBox.HandleChange(AEvent: TJSEvent): boolean;
var
  i: NativeInt;
begin
  AEvent.StopPropagation;
  with TJSHTMLSelectElement(HandleElement) do begin
    FItemIndex := selectedIndex;
    for i := 0 to length - 1 do
      FSelected[i] := item(i).selected;
  end;
  SelectionChange(True);
  Result := True;
end;

procedure TCustomListBox.Changed;
var
  idx: NativeInt;
  v: String;
  opt: TJSHTMLOptionElement;
begin
  inherited Changed;
  if not IsUpdating and not (csLoading in ComponentState) then begin
    if FSelectionChanged then begin
      SelectionChange(False);
      FSelectionChanged := False;
    end;
    with TJSHTMLSelectElement(HandleElement) do begin
      multiple := FMultiSelect;
      { use 2, so that it isn't shown as a dropdown }
      size := 2;
      { remove old items }
      for idx := TJSHTMLSelectElement(HandleElement).Length - 1 downto 0 do
        Remove(idx);
      { add new items }
      for idx := 0 to FItems.Count - 1 do begin
        v := FItems[idx];
        opt := TJSHTMLOptionElement(Document.CreateElement('option'));
        opt.Value := v;
        opt.Text := v;
        if FMultiselect then
          opt.Selected := FSelected[idx]
        else
          opt.Selected := idx = FItemIndex;
        Add(opt);
      end;
    end;
  end;
end;

function TCustomListBox.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('select'));
end;

procedure TCustomListBox.RegisterHandleEvents;
begin
  inherited RegisterHandleEvents;
  with HandleElement do
  begin
    AddEventListener('change', @HandleChange);
  end;
end;

procedure TCustomListBox.UnRegisterHandleEvents;
begin
  inherited UnRegisterHandleEvents;
  with HandleElement do
  begin
    RemoveEventListener('change', @HandleChange);
  end;
end;

function TCustomListBox.CheckChildClassAllowed(AChildClass: TClass): boolean;
begin
  Result := False;
end;

procedure TCustomListBox.UpdateSorted;
begin
  TStringList(FItems).Sorted := FSorted;
end;

class function TCustomListBox.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 100;
  Result.Cy := 70;
end;

constructor TCustomListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItemHeight := 0;
  FItemIndex := -1;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := @ItemsChanged;
  FMultiSelect := False;
  FSorted := False;
  BeginUpdate;
  try
    with GetControlClassDefaultSize do begin
      SetBounds(0, 0, Cx, Cy);
    end;
  finally
    EndUpdate;
  end;
end;

destructor TCustomListBox.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TCustomListBox.AddItem(const AItem: String; AObject: TObject);
begin
  FItems.AddObject(AItem, AObject);
  Changed;
end;

procedure TCustomListBox.Append(const AItem: String);
begin
  FItems.Append(AItem);
  Changed;
end;

procedure TCustomListBox.Clear;
begin
  FItems.Clear;
  FItemIndex := -1;
  FSelected := Nil;
  Changed;
end;

procedure TCustomListBox.ClearSelection;
var
  i: Integer;
begin
  if FMultiSelect then begin
    BeginUpdate;
    try
      for i := 0 to FItems.Count - 1 do
        Selected[i] := False;
    finally
      EndUpdate;
    end;
  end else
    ItemIndex := -1;
end;

procedure TCustomListBox.SelectAll;
begin
  if not FMultiSelect then
    Exit;
  SelectRange(0, FItems.Count - 1, True);
end;

procedure TCustomListBox.SelectRange(ALow, AHigh: Integer; ASelected: boolean);
var
  i: Integer;
begin
  if not FMultiSelect then
    Exit;
  if ALow < 0 then
    ALow := 0;
  if AHigh >= FItems.Count then
    AHigh := FItems.Count - 1;
  if AHigh < ALow then
    Exit;
  BeginUpdate;
  try
    for i := ALow to AHigh do
      Selected[i] := ASelected;
  finally
    EndUpdate;
  end;
end;

{ TCustomEdit }

procedure TCustomEdit.SetAlignment(AValue: TAlignment);
begin
  if (FAlignment <> AValue) then
  begin
    FAlignment := AValue;
    Changed;
  end;
end;

function TCustomEdit.GetSelLength: NativeInt;
begin
  if (Assigned(HandleElement)) then
  begin
    with TJSHTMLInputElement(HandleElement) do
    begin
      FSelLength := (SelectionEnd - SelectionStart);
    end;
  end;
  Result := FSelLength;
end;

function TCustomEdit.GetSelStart: NativeInt;
begin
  if (Assigned(HandleElement)) then
  begin
    with TJSHTMLInputElement(HandleElement) do
    begin
      FSelLength := (SelectionStart);
    end;
  end;
  Result := FSelLength;
end;

function TCustomEdit.GetSelText: string;
begin
  Result := Copy(RealGetText, FSelStart + 1, FSelLength);
end;

procedure TCustomEdit.SetCharCase(AValue: TEditCharCase);
begin
  if (FCharCase <> AValue) then
  begin
    FCharCase := AValue;
    Changed;
  end;
end;

procedure TCustomEdit.SetMaxLength(AValue: NativeInt);
begin
  if (FMaxLength <> AValue) then
  begin
    FMaxLength := AValue;
    Changed;
  end;
end;

procedure TCustomEdit.SetModified(AValue: boolean);
begin
  if (FModified <> AValue) then
  begin
    FModified := AValue;
  end;
end;

procedure TCustomEdit.SetPasswordChar(AValue: char);
begin
  if (FPasswordChar <> AValue) then
  begin
    FPasswordChar := AValue;
    Changed;
  end;
end;

procedure TCustomEdit.SetPattern(AValue: string);
begin
  if (FPattern <> AValue) then
  begin
    FPattern := AValue;
    Changed;
  end;
end;

procedure TCustomEdit.SetReadOnly(AValue: boolean);
begin
  if (FReadOnly <> AValue) then
  begin
    FReadOnly := AValue;
    Changed;
  end;
end;

procedure TCustomEdit.SetRequired(AValue: boolean);
begin
  if (FRequired <> AValue) then
  begin
    FRequired := AValue;
    Changed;
  end;
end;

procedure TCustomEdit.SetSelLength(AValue: NativeInt);
begin
  if (AValue < 0) then
  begin
    AValue := 0;
  end;
  if (FSelLength <> AValue) then
  begin
    FSelLength := AValue;
    Changed;
  end;
end;

procedure TCustomEdit.SetSelStart(AValue: NativeInt);
begin
  if (FSelStart <> AValue) then
  begin
    FSelStart := AValue;
    Changed;
  end;
end;

procedure TCustomEdit.SetSelText(AValue: string);
var
  VText: string;
  VLength: NativeInt;
  VStart: NativeInt;
begin
  if (not ReadOnly) then
  begin
    VText := RealGetText;
    VLength := SelLength;
    VStart := SelStart;
    if (VLength = 0) then
    begin
      System.Insert(AValue, VText, VStart);
    end
    else
    begin
      System.Delete(VText, VStart + 1, VLength);
      System.Insert(AValue, VText, VStart + 1);
    end;
    if (MaxLength > 0) then
    begin
      VText := Copy(VText, 1, MaxLength);
    end;
    RealSetText(VText);
    { TODO: SelStart and SelLength }
  end;
end;

procedure TCustomEdit.SetTextHint(AValue: string);
begin
  if (FTextHint <> AValue) then
  begin
    FTextHint := AValue;
    Changed;
  end;
end;

procedure TCustomEdit.Change;
begin
  if (Assigned(FOnChange)) then
  begin
    FOnChange(Self);
  end;
end;

procedure TCustomEdit.DoEnter;
begin
  inherited DoEnter;
  SelectAll;
end;

procedure TCustomEdit.DoInput(ANewValue: string);
begin
  if (ANewValue <> RealGetText) then
  begin
    FText := ANewValue;
    FModified := True;
    Change;
  end;
end;

function TCustomEdit.HandleInput(AEvent: TJSEvent): boolean;
begin
  AEvent.StopPropagation;
  DoInput(TJSHTMLInputElement(HandleElement).Value);
  Result := True;
end;

procedure TCustomEdit.Changed;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with TJSHTMLInputElement(HandleElement) do
    begin
      /// Alignment
      case Alignment of
        taRightJustify: Style.SetProperty('text-align', 'right');
        taCenter: Style.SetProperty('text-align', 'center');
        else
          Style.RemoveProperty('text-align');
      end;
      /// CharCase
      case FCharCase of
        ecLowerCase: Style.SetProperty('text-transform', 'lowercase');
        ecUppercase: Style.SetProperty('text-transform', 'uppercase');
        else
          Style.RemoveProperty('text-transform');
      end;
      /// Max Length
      if (FMaxLength > 0) then
      begin
        MaxLength := FMaxLength;
      end
      else
      begin
        RemoveAttribute('maxlength');
      end;
      /// Pattern
      if (FPattern <> '') then
      begin
        Pattern := FPattern;
      end
      else
      begin
        RemoveAttribute('pattern');
      end;
      /// Placeholder
      if (FTextHint <> '') then
      begin
        Placeholder := FTextHint;
      end
      else
      begin
        RemoveAttribute('placeholder');
      end;
      /// ReadOnly
      ReadOnly := FReadOnly;
      /// Required
      Required := FRequired;
      /// Selection
      case InputType of
        'text',
        'search',
        'URL',
        'tel',
        'password':
        begin
          SetSelectionRange(FSelStart, FSelStart + FSelLength);
        end;
      end;
      /// Type
      _Type := InputType;
      /// Text
      Value := RealGetText;
    end;
  end;
end;

function TCustomEdit.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('input'));
end;

procedure TCustomEdit.RegisterHandleEvents;
begin
  inherited RegisterHandleEvents;
  with HandleElement do
  begin
    AddEventListener('input', @HandleInput);
  end;
end;

procedure TCustomEdit.UnRegisterHandleEvents;
begin
  inherited UnRegisterHandleEvents;
  with HandleElement do
  begin
    RemoveEventListener('input', @HandleInput);
  end;
end;

function TCustomEdit.CheckChildClassAllowed(AChildClass: TClass): boolean;
begin
  Result := inherited CheckChildClassAllowed(AChildClass);
end;

function TCustomEdit.RealGetText: string;
begin
  Result := FText;
end;

procedure TCustomEdit.RealSetText(const AValue: string);
begin
  FText := AValue;
  FModified := False;
  Changed;
end;

function TCustomEdit.InputType: string;
begin
  Result := IfThen((FPasswordChar <> #0), 'password', 'text');
end;

class function TCustomEdit.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 80;
  Result.Cy := 25;
end;

constructor TCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMaxLength := 0;
  FModified := False;
  FPasswordChar := #0;
  FPattern := '';
  FReadOnly := False;
  FTextHint := '';
  FText := '';
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

procedure TCustomEdit.Clear;
begin
  FText := '';
  Changed;
end;

procedure TCustomEdit.SelectAll;
begin
  if (RealGetText <> '') then
  begin
    BeginUpdate;
    try
      SetSelStart(0);
      SetSelLength(Length(RealGetText));
    finally
      EndUpdate;
    end;
  end;
end;

type
  TCustomMemoStrings = class(TStringList)
  protected
    procedure DoReadData(Reader: TReader); virtual;
    procedure DoWriteData(Writer: TWriter); virtual;
    procedure DefineProperties(Filer: TFiler); override;
  end;

{ TCustomMemoStrings }

procedure TCustomMemoStrings.DoReadData(Reader: TReader);
begin
  Reader.ReadListBegin;
  BeginUpdate;
  try
    Clear;
    while not Reader.EndOfList do
      Add(Reader.ReadString);
  finally
    EndUpdate;
  end;
  Reader.ReadListEnd;
end;

procedure TCustomMemoStrings.DoWriteData(Writer: TWriter);
var
  i: Integer;
  lStringsNoWordWrap: TStringList;
begin
  lStringsNoWordWrap := TStringList.Create;
  try
    lStringsNoWordWrap.Text := Text;

    Writer.WriteListBegin;
    for i := 0 to lStringsNoWordWrap.Count - 1 do
      Writer.WriteString(lStringsNoWordWrap.Strings[i]);
    Writer.WriteListEnd;
  finally
    lStringsNoWordWrap.Free;
  end;
end;

procedure TCustomMemoStrings.DefineProperties(Filer: TFiler);
var
  HasData: Boolean;
begin
  HasData := Count > 0;
  Filer.DefineProperty('Strings', @DoReadData, @DoWriteData, HasData);
end;


{ TCustomMemo }

procedure TCustomMemo.SetAlignment(AValue: TAlignment);
begin
  if (FAlignment <> AValue) then
  begin
    FAlignment := AValue;
    Changed;
  end;
end;

function TCustomMemo.GetSelLength: NativeInt;
begin
  if (Assigned(HandleElement)) then
  begin
    with TJSHTMLTextAreaElement(HandleElement) do
    begin
      FSelLength := (SelectionEnd - SelectionStart);
    end;
  end;
  Result := FSelLength;
end;

function TCustomMemo.GetSelStart: NativeInt;
begin
  if (Assigned(HandleElement)) then
  begin
    with TJSHTMLInputElement(HandleElement) do
    begin
      FSelLength := (SelectionStart);
    end;
  end;
  Result := FSelLength;
end;

function TCustomMemo.GetSelText: string;
begin
  Result := Copy(RealGetText, FSelStart + 1, FSelLength);
end;

procedure TCustomMemo.SetCharCase(AValue: TEditCharCase);
begin
  if (FCharCase <> AValue) then
  begin
    FCharCase := AValue;
    Changed;
  end;
end;

procedure TCustomMemo.SetLines(AValue: TStrings);
begin
  FLines.Assign(AValue);
  Changed;
end;

procedure TCustomMemo.SetMaxLength(AValue: NativeInt);
begin
  if (FMaxLength <> AValue) then
  begin
    FMaxLength := AValue;
    Changed;
  end;
end;

procedure TCustomMemo.SetModified(AValue: boolean);
begin
  if (FModified <> AValue) then
  begin
    FModified := AValue;
  end;
end;

procedure TCustomMemo.SetReadOnly(AValue: boolean);
begin
  if (FReadOnly <> AValue) then
  begin
    FReadOnly := AValue;
    Changed;
  end;
end;

procedure TCustomMemo.SetSelLength(AValue: NativeInt);
begin
  if (AValue < 0) then
  begin
    AValue := 0;
  end;
  if (FSelLength <> AValue) then
  begin
    FSelLength := AValue;
    Changed;
  end;
end;

procedure TCustomMemo.SetSelStart(AValue: NativeInt);
begin
  if (FSelStart <> AValue) then
  begin
    FSelStart := AValue;
    Changed;
  end;
end;

procedure TCustomMemo.SetSelText(AValue: string);
var
  VText: string;
  VLength: NativeInt;
  VStart: NativeInt;
begin
  if (not ReadOnly) then
  begin
    VText := RealGetText;
    VLength := SelLength;
    VStart := SelStart;
    if (VLength = 0) then
    begin
      System.Insert(AValue, VText, VStart);
    end
    else
    begin
      System.Delete(VText, VStart + 1, VLength);
      System.Insert(AValue, VText, VStart + 1);
    end;
    if (MaxLength > 0) then
    begin
      VText := Copy(VText, 1, MaxLength);
    end;
    RealSetText(VText);
    { TODO: SelStart and SelLength }
  end;
end;

procedure TCustomMemo.SetTextHint(AValue: string);
begin
  if (FTextHint <> AValue) then
  begin
    FTextHint := AValue;
  end;
end;

procedure TCustomMemo.SetWantReturns(AValue: boolean);
begin
  if (FWantReturns <> AValue) then
  begin
    FWantReturns := AValue;
  end;
end;

procedure TCustomMemo.SetWantTabs(AValue: boolean);
begin
  if (FWantTabs <> AValue) then
  begin
    FWantTabs := AValue;
  end;
end;

procedure TCustomMemo.SetWordWrap(AValue: boolean);
begin
  if (FWordWrap <> AValue) then
  begin
    FWordWrap := AValue;
    Changed;
  end;
end;

procedure TCustomMemo.Change;
begin
  if (Assigned(FOnChange)) then
  begin
    FOnChange(Self);
  end;
end;

procedure TCustomMemo.KeyDown(var Key: NativeInt; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (not FWantReturns) and (Key = 13) then
  begin
    Key := 0;
  end;
end;

function TCustomMemo.HandleChange(AEvent: TJSEvent): boolean;
var
  VNewText: string;
  VOldText: string;
begin
  AEvent.StopPropagation;
  VNewText := TJSHTMLTextAreaElement(HandleElement).Value;
  VOldText := RealGetText;
  if (VNewText <> VOldText) then
  begin
    FLines.Text := VNewText;
    FModified := True;
    Change;
  end;
  Result := True;
end;

procedure TCustomMemo.Changed;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with TJSHTMLTextAreaElement(HandleElement) do
    begin
      /// Alignment
      case Alignment of
        taRightJustify: Style.SetProperty('text-align', 'right');
        taCenter: Style.SetProperty('text-align', 'center');
        else
          Style.RemoveProperty('text-align');
      end;
      /// CharCase
      case FCharCase of
        ecLowerCase: Style.SetProperty('text-transform', 'lowercase');
        ecUppercase: Style.SetProperty('text-transform', 'uppercase');
        else
          Style.RemoveProperty('text-transform');
      end;
      /// Max Length
      if (FMaxLength > 0) then
      begin
        MaxLength := FMaxLength;
      end
      else
      begin
        RemoveAttribute('maxlength');
      end;
      /// Placeholder
      if (FTextHint <> '') then
      begin
        Placeholder := FTextHint;
      end
      else
      begin
        RemoveAttribute('placeholder');
      end;
      /// ReadOnly
      ReadOnly := FReadOnly;
      /// Resize
      Style.SetProperty('resize', 'none');
      /// WordWrap
      if (FWordWrap) then
      begin
        RemoveAttribute('wrap');
      end
      else
      begin
        Wrap := 'off';
      end;
      /// Scroll
      Style.SetProperty('overflow', 'auto');
      /// Text
      Value := RealGetText;
    end;
  end;
end;

function TCustomMemo.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('textarea'));
end;

procedure TCustomMemo.RegisterHandleEvents;
begin
  inherited RegisterHandleEvents;
  with HandleElement do
  begin
    AddEventListener('input', @HandleChange);
  end;
end;

procedure TCustomMemo.UnRegisterHandleEvents;
begin
  inherited UnRegisterHandleEvents;
  with HandleElement do
  begin
    RemoveEventListener('input', @HandleChange);
  end;
end;

{$push}
{$hints off}

function TCustomMemo.CheckChildClassAllowed(AChildClass: TClass): boolean;
begin
  Result := False;
end;

{$pop}

function TCustomMemo.RealGetText: string;
begin
  Result := FLines.Text;
end;

procedure TCustomMemo.RealSetText(const AValue: string);
begin
  FLines.Text := AValue;
  FModified := False;
  Changed;
end;

class function TCustomMemo.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 150;
  Result.Cy := 90;
end;

constructor TCustomMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLines := TCustomMemoStrings.Create;
  FMaxLength := 0;
  FModified := False;
  FReadOnly := False;
  FTextHint := '';
  FWantReturns := True;
  FWantTabs := False;
  FWordWrap := True;
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

destructor TCustomMemo.Destroy;
begin
  FLines.Destroy;
  FLines := nil;
  inherited Destroy;
end;

procedure TCustomMemo.Append(const AValue: string);
begin
  FLines.Append(AValue);
  Changed;
end;

procedure TCustomMemo.Clear;
begin
  FLines.Clear;
  Changed;
end;

procedure TCustomMemo.SelectAll;
begin
  if (RealGetText <> '') then
  begin
    BeginUpdate;
    try
      SetSelStart(0);
      SetSelLength(Length(RealGetText));
    finally
      EndUpdate;
    end;
  end;
end;

{ TCustomButton }

procedure TCustomButton.SetCancel(AValue: boolean);
begin
  if (FCancel <> AValue) then
  begin
    FCancel := AValue;
  end;
end;

procedure TCustomButton.SetDefault(AValue: boolean);
begin
  if (FDefault <> AValue) then
  begin
    FDefault := AValue;
  end;
end;

procedure TCustomButton.Changed;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with HandleElement do
    begin
      /// Normalize
      Style.SetProperty('padding', '0');
      /// Caption
      InnerHTML := Self.Caption;
    end;
  end;
end;

function TCustomButton.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('button'));
end;

{$push}
{$hints off}

function TCustomButton.CheckChildClassAllowed(AChildClass: TClass): boolean;
begin
  Result := False;
end;

{$pop}

class function TCustomButton.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 80;
  Result.Cy := 25;
end;

constructor TCustomButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FModalResult := mrNone;
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

procedure TCustomButton.AdjustSize;
var
  VSize: TSize;
begin
  inherited AdjustSize;
  VSize := Font.TextExtent(Caption);
  SetBounds(Left, Top, VSize.Cx, VSize.Cy);
end;

procedure TCustomButton.Click;
var
  VParent: TControl;
begin
  if (FModalResult <> mrNone) then
  begin
    VParent := Parent;
    while (Assigned(VParent)) do
    begin
      if (VParent is TCustomForm) then
      begin
        TCustomForm(VParent).ModalResult := FModalResult;
        Break;
      end;
      VParent := VParent.Parent;
    end;
  end;
  inherited Click;
end;

{ TCustomCheckbox }

function TCustomCheckbox.GetChecked: boolean;
begin
  Result := (GetState = cbChecked);
end;

function TCustomCheckbox.GetState: TCheckBoxState;
begin
  Result := FState;
end;

procedure TCustomCheckbox.SetAlignment(AValue: TLeftRight);
begin
  if (FAlignment <> AValue) then
  begin
    FAlignment := AValue;
    //Changed;
  end;
end;

procedure TCustomCheckbox.SetChecked(AValue: boolean);
begin
  if (AValue) then
  begin
    SetState(cbChecked);
  end
  else
  begin
    SetState(cbUnchecked);
  end;
end;

procedure TCustomCheckbox.SetState(AValue: TCheckBoxState);
begin
  if (FState <> AValue) then
  begin
    FState := AValue;
    Changed;
    DoOnChange;
  end;
end;

procedure TCustomCheckbox.DoOnChange;
begin
  if (Assigned(FOnChange)) then
  begin
    FOnChange(Self);
  end;
end;

function TCustomCheckbox.HandleClick(AEvent: TJSMouseEvent): boolean;
begin
  SetChecked(FState <> cbChecked);
  Result := inherited HandleClick(AEvent);
end;

procedure TCustomCheckbox.Changed;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with HandleElement do
    begin
      /// Prevent text selection
      Style.SetProperty('user-select', 'none');
      Style.SetProperty('-moz-user-select', 'none');
      Style.SetProperty('-ms-user-select', 'none');
      Style.SetProperty('-khtml-user-select', 'none');
      Style.SetProperty('-webkit-user-select', 'none');
      /// Position
      Style.SetProperty('display', 'flex');
      Style.SetProperty('align-items', 'center');
    end;
    /// Mark
    with FMarkElement do
    begin
      Checked := (FState = cbChecked);
      _type := 'checkbox';
    end;
    /// Label
    with FLabelElement do
    begin
      innerHTML := Caption;
    end;
  end;
end;

function TCustomCheckbox.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('span'));
end;

function TCustomCheckbox.CreateMarkElement: TJSHTMLInputElement;
begin
  Result := TJSHTMLInputElement(HandleElement.AppendChild(Document.CreateElement('input')));
end;

function TCustomCheckbox.CreateLabelElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(HandleElement.AppendChild(Document.CreateElement('span')));
end;

{$push}
{$hints off}

function TCustomCheckbox.CheckChildClassAllowed(AChildClass: TClass): boolean;
begin
  Result := False;
end;

{$pop}

class function TCustomCheckbox.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 90;
  Result.Cy := 23;
end;

constructor TCustomCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarkElement := CreateMarkElement;
  FLabelElement := CreateLabelElement;
  FAlignment := taRightJustify;
  FState := cbUnchecked;
  try
    with GetControlClassDefaultSize do
    begin
      SetBounds(0, 0, Cx, Cy);
    end;
  finally
    EndUpdate;
  end;
end;

{ TCustomLabel }

procedure TCustomLabel.SetAlignment(AValue: TAlignment);
begin
  if (FAlignment <> AValue) then
  begin
    FAlignment := AValue;
    Changed;
  end;
end;

procedure TCustomLabel.SetLayout(AValue: TTextLayout);
begin
  if (FLayout <> AValue) then
  begin
    FLayout := AValue;
    Changed;
  end;
end;

procedure TCustomLabel.SetTransparent(AValue: boolean);
begin
  if (FTransparent <> AValue) then
  begin
    FTransparent := AValue;
    BeginUpdate;
    try
      if (FTransparent) then
      begin
        Color := clNone;
      end
      else
      if (Color = clNone) then
      begin
        Color := clBackground;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TCustomLabel.SetWordWrap(AValue: boolean);
begin
  if (FWordWrap <> AValue) then
  begin
    FWordWrap := AValue;
    Changed;
  end;
end;

procedure TCustomLabel.DoEnter;
begin
  inherited DoEnter;
  if (Assigned(FFocusControl)) and (FFocusControl.CanSetFocus) then
  begin
    FFocusControl.SetFocus;
  end;
end;

procedure TCustomLabel.Changed;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with HandleElement do
    begin
      /// Transparent
      if (FTransparent) then
      begin
        Style.SetProperty('background-color', 'transparent');
      end;
      /// Focus highlight
      Style.SetProperty('outline', 'none');
      /// Prevent text selection
      Style.SetProperty('user-select', 'none');
      Style.SetProperty('-moz-user-select', 'none');
      Style.SetProperty('-ms-user-select', 'none');
      Style.SetProperty('-khtml-user-select', 'none');
      Style.SetProperty('-webkit-user-select', 'none');
      if AutoSize then begin
        Style.removeProperty('height');
        Style.removeProperty('width');
      end;
    end;
    with FContentElement do
    begin
      /// Clear
      InnerHTML := '';
      /// Aligment
      case FAlignment of
        taCenter: Style.SetProperty('text-align', 'center');
        taLeftJustify: Style.SetProperty('text-align', 'left');
        taRightJustify: Style.SetProperty('text-align', 'right');
      end;
      /// Layout
      case FLayout of
        tlBottom: Style.SetProperty('vertical-align', 'bottom');
        tlCenter: Style.SetProperty('vertical-align', 'middle');
        tlTop: Style.SetProperty('vertical-align', 'top');
      end;
      /// WordWrap
      if (FWordWrap) then
      begin
        Style.SetProperty('word-wrap', 'break-word');
      end
      else
      begin
        Style.removeProperty('word-wrap');
      end;
      /// Scroll
      Style.SetProperty('overflow', 'hidden');
      /// Specifies how overflowed content
      Style.SetProperty('text-overflow', 'ellipsis');
      /// Caption
      InnerHTML := Self.Caption;
    end;
  end;
end;

function TCustomLabel.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('div'));
end;

function TCustomLabel.CreateContentElement: TJSHTMLTableElement;
begin
  Result := TJSHTMLTableElement(HandleElement.AppendChild(Document.CreateElement('label')));
end;

{$push}
{$hints off}

function TCustomLabel.CheckChildClassAllowed(AChildClass: TClass): boolean;
begin
  Result := False;
end;

{$pop}

class function TCustomLabel.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 65;
  Result.Cy := 17;
end;

constructor TCustomLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FContentElement := CreateContentElement;
  FAlignment := taLeftJustify;
  FFocusControl := nil;
  FLayout := tlTop;
  FTransparent := True;
  FWordWrap := False;
  BeginUpdate;
  try
    TabStop := False;
    AutoSize := True;
    with GetControlClassDefaultSize do
    begin
      SetBounds(0, 0, Cx, Cy);
    end;
  finally
    EndUpdate;
  end;
end;

procedure TCustomLabel.AdjustSize;
begin
  inherited AdjustSize;
  Changed;
end;

end.
