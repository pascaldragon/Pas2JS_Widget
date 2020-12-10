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
unit ComCtrls;

{$I pas2js_widget.inc}

interface

uses
  Classes,
  SysUtils,
  Types,
  JS,
  Web,
  Graphics,
  Controls;

type
  /// Forward declaration
  TCustomPageControl = class;

  TTabPosition = (tpTop, tpBottom, tpLeft, tpRight);

  { TCustomTabSheet }

  TCustomTabSheet = class(TWinControl)
  private
    FTabVisible: boolean;
    function GetPageControl: TCustomPageControl;
    function GetPageIndex: nativeint;
    procedure SetPageControl(AValue: TCustomPageControl);
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
  public
    constructor Create(AOwner: TComponent); override;
    property PageIndex: nativeint read GetPageIndex;
    property PageControl: TCustomPageControl read GetPageControl write SetPageControl;
    property TabVisible: boolean read FTabVisible write FTabVisible;
  end;

  { TTabSheet }

  TTabSheet = class(TCustomTabSheet)
  published
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Enabled;
    property Font;
    property Height;
    property Left;
    property PageIndex;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property TabVisible;
    property Top;
    property Width;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
  end;

  { TCustomPageControl }

  TCustomPageControl = class(TWinControl)
    { TODO: Add event on show page }
  private
    FMultiLine: boolean;
    FPageIndex: nativeint;
    FPages: TJSArray;
    FShowTabs: boolean;
    FTabContainerElement: TJSHTMLElement;
    FTabHeight: smallint;
    FTabPosition: TTabPosition;
    FTabWidth: smallint;
    function GetActivePage: TCustomTabSheet;
    function GetPage(const AIndex: nativeint): TCustomTabSheet;
    function GetPageCount: nativeint;
    procedure SetActivePage(AValue: TCustomTabSheet);
    procedure SetMultiLine(AValue: boolean);
    procedure SetPageIndex(AValue: nativeint);
    procedure SetShowTabs(AValue: boolean);
    procedure SetTabHeight(AValue: smallint);
    procedure SetTabPosition(AValue: TTabPosition);
    procedure SetTabWidth(AValue: smallint);
  protected
    property TabIndex: nativeint read FPageIndex write SetPageIndex;
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
    function CreateTabContainerElement: TJSHTMLElement; virtual;
    procedure RegisterChild(AControl: TControl); override;
    procedure UnRegisterChild(AControl: TControl); override;
    function CalcTabHeight: nativeint; virtual;
    function CalcTabWidth(const AText: string): nativeint; virtual;
    function CalcMaxTabWidth: nativeint; virtual;
    function CalcSumTabsWidth: nativeint; virtual;
    function IndexOfTab(const ACaption: string): nativeint;
    function RenderTab(const ACaption: string;
      const ALeft, ATop, AWidth, AHeight: nativeint;
      const AEvent: JSValue): TJSHTMLElement; virtual;
    function RenderTabActive(const ACaption: string;
      const ALeft, ATop, AWidth, AHeight: nativeint;
      const AEvent: JSValue): TJSHTMLElement; virtual;
    function RenderTabLeft(const ALeft, ATop, AWidth, AHeight: nativeint;
      const AEvent: JSValue): TJSHTMLElement; virtual;
    function RenderTabRight(const ALeft, ATop, AWidth, AHeight: nativeint;
      const AEvent: JSValue): TJSHTMLElement; virtual;
    procedure RenderTabs; virtual;
    procedure TabClick(AEvent: TJSMouseEvent); virtual;
    procedure TabLeftClick(AEvent: TJSMouseEvent); virtual;
    procedure TabRightClick(AEvent: TJSMouseEvent); virtual;
    procedure UpdatePages; virtual;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddTabSheet: TCustomTabSheet;
    function IndexOf(APage: TCustomTabSheet): nativeint; virtual;
    property PageCount: nativeint read GetPageCount;
    property Pages[const AIndex: nativeint]: TCustomTabSheet read GetPage;
  public
    property ActivePage: TCustomTabSheet read GetActivePage write SetActivePage;
    property MultiLine: boolean read FMultiLine write SetMultiLine;
    property ShowTabs: boolean read FShowTabs write SetShowTabs;
    property TabHeight: smallint read FTabHeight write SetTabHeight;
    property TabPosition: TTabPosition read FTabPosition write SetTabPosition;
    property TabWidth: smallint read FTabWidth write SetTabWidth;
  end;

implementation

uses
  Forms;

{ TCustomTabSheet }

function TCustomTabSheet.GetPageControl: TCustomPageControl;
begin
  if (Parent is TCustomPageControl) then
  begin
    Result := TCustomPageControl(Parent);
  end
  else
  begin
    Result := nil;
  end;
end;

function TCustomTabSheet.GetPageIndex: nativeint;
begin
  if (Parent is TCustomPageControl) then
  begin
    Result := TCustomPageControl(Parent).IndexOf(Self);
  end
  else
  begin
    Result := -1;
  end;
end;

procedure TCustomTabSheet.SetPageControl(AValue: TCustomPageControl);
begin
  if (PageControl = AValue) then
  begin
    Parent := AValue;
  end;
end;

procedure TCustomTabSheet.Changed;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with HandleElement do
    begin
      /// Color
      Style.SetProperty('background-color', '#fff');
      /// Focus highlight
      Style.SetProperty('outline', 'none');
      /// Borders
      Style.SetProperty('border', '1px solid #c9c3ba');
      Style.SetProperty('border-top', '0px');
    end;
  end;
end;

function TCustomTabSheet.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('span'));
end;

constructor TCustomTabSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTabVisible := True;
  BeginUpdate;
  try
    Visible := False;
  finally
    EndUpdate;
  end;
end;

{ TCustomPageControl }

function TCustomPageControl.GetActivePage: TCustomTabSheet;
begin
  Result := GetPage(FPageIndex);
end;

function TCustomPageControl.GetPage(const AIndex: nativeint): TCustomTabSheet;
begin
  if (AIndex >= 0) and (AIndex < FPages.Length) then
  begin
    Result := TCustomTabSheet(FPages[AIndex]);
  end
  else
  begin
    Result := nil;
  end;
end;

function TCustomPageControl.GetPageCount: nativeint;
begin
  Result := FPages.Length;
end;

procedure TCustomPageControl.SetActivePage(AValue: TCustomTabSheet);
begin
  SetPageIndex(FPages.IndexOf(AValue));
end;

procedure TCustomPageControl.SetMultiLine(AValue: boolean);
begin
  if (FMultiLine <> AValue) then
  begin
    FMultiLine := AValue;
  end;
end;

procedure TCustomPageControl.SetPageIndex(AValue: nativeint);
begin
  if (AValue < 0) or (AValue >= FPages.Length) then
  begin
    AValue := 0;
  end;
  if (AValue <> FPageIndex) then
  begin
    FPageIndex := AValue;
    Changed;
  end;
end;

procedure TCustomPageControl.SetShowTabs(AValue: boolean);
begin
  if (FShowTabs <> AValue) then
  begin
    FShowTabs := AValue;
    Changed;
  end;
end;

procedure TCustomPageControl.SetTabHeight(AValue: smallint);
begin
  if (FTabHeight <> AValue) then
  begin
    FTabHeight := AValue;
    Changed;
  end;
end;

procedure TCustomPageControl.SetTabPosition(AValue: TTabPosition);
begin
  if (FTabPosition <> AValue) then
  begin
    FTabPosition := AValue;
  end;
end;

procedure TCustomPageControl.SetTabWidth(AValue: smallint);
begin
  if (FTabWidth <> AValue) then
  begin
    FTabWidth := AValue;
    Changed;
  end;
end;

procedure TCustomPageControl.Changed;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with HandleElement do
    begin
      /// Focus highlight
      Style.SetProperty('outline', 'none');
    end;
    RenderTabs;
    UpdatePages;
  end;
end;

function TCustomPageControl.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('div'));
end;

function TCustomPageControl.CreateTabContainerElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('span'));
  HandleElement.AppendChild(Result);
end;

procedure TCustomPageControl.RegisterChild(AControl: TControl);
var
  VIndex: nativeint;
begin
  inherited RegisterChild(AControl);
  if (Assigned(AControl)) and (AControl is TCustomTabSheet) then
  begin
    VIndex := FPages.IndexOf(AControl);
    if (VIndex < 0) then
    begin
      FPages.Push(AControl);
    end;
  end;
end;

procedure TCustomPageControl.UnRegisterChild(AControl: TControl);
var
  VIndex: nativeint;
begin
  inherited UnRegisterChild(AControl);
  if (Assigned(AControl)) and (AControl is TCustomTabSheet) then
  begin
    VIndex := FPages.IndexOf(AControl);
    if (VIndex >= 0) then
    begin
      FPages.Splice(VIndex, 1);
    end;
  end;
end;

function TCustomPageControl.CalcTabHeight: nativeint;
begin
  if (FShowTabs) then
  begin
    if (FTabHeight > 0) then
    begin
      Result := FTabHeight;
    end
    else
    begin
      Result := Font.TextHeight('Fj') + 10;
    end;
  end
  else
  begin
    Result := 0;
  end;
end;

function TCustomPageControl.CalcTabWidth(const AText: string): nativeint;
begin
  if (FTabWidth > 0) then
  begin
    Result := FTabWidth;
  end
  else
  begin
    Result := Font.TextWidth(AText) + 10;
  end;
end;

function TCustomPageControl.CalcMaxTabWidth: nativeint;
var
  VPage: TCustomTabSheet;
  VIndex: nativeint;
  VWidth: nativeint;
begin
  Result := 0;
  if (FTabWidth > 0) then
  begin
    Result := FTabWidth;
  end
  else
  begin
    for VIndex := 0 to (FPages.Length - 1) do
    begin
      VPage := TCustomTabSheet(FPages[VIndex]);
      if (Assigned(VPage)) and (VPage.TabVisible) then
      begin
        VWidth := CalcTabWidth(VPage.Caption);
        if (VWidth > Result) then
        begin
          Result := VWidth;
        end;
      end;
    end;
  end;
end;

function TCustomPageControl.CalcSumTabsWidth: nativeint;
var
  VIndex: nativeint;
  VPage: TCustomTabSheet;
begin
  Result := 0;
  for VIndex := 0 to (FPages.Length - 1) do
  begin
    VPage := TCustomTabSheet(FPages[VIndex]);
    if (Assigned(VPage)) and (VPage.TabVisible) then
    begin
      Result := Result + CalcTabWidth(VPage.Caption);
    end;
  end;
end;

function TCustomPageControl.IndexOfTab(const ACaption: string): nativeint;
var
  VIndex: nativeint;
  VPage: TCustomTabSheet;
begin
  Result := -1;
  for VIndex := 0 to (FPages.Length - 1) do
  begin
    VPage := TCustomTabSheet(FPages[VIndex]);
    if (Assigned(VPage)) and (VPage.TabVisible) and
      (SameText(VPage.Caption, ACaption)) then
    begin
      Result := VIndex;
    end;
  end;
end;

function TCustomPageControl.RenderTab(const ACaption: string;
  const ALeft, ATop, AWidth, AHeight: nativeint; const AEvent: JSValue): TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('button'));
  with Result do
  begin
    /// Bounds
    Style.SetProperty('left', IntToStr(ALeft) + 'px');
    Style.SetProperty('top', IntToStr(ATop) + 'px');
    Style.SetProperty('width', IntToStr(AWidth) + 'px');
    Style.SetProperty('height', IntToStr(AHeight) + 'px');
    /// Border
    Style.SetProperty('border', '1px solid #c9c3ba');
    Style.SetProperty('border-top-left-radius', '15px');
    Style.SetProperty('border-top-right-radius', '2px');
    /// Color
    Style.SetProperty('background-color', '#dddada');
    /// Font
    Style.SetProperty('color', JSColor(Font.Color));
    Style.SetProperty('font', JSFont(Font));
    /// Focus highlight
    Style.SetProperty('outline', 'none');
    /// Position
    Style.SetProperty('position', 'absolute');
    /// Scroll
    Style.SetProperty('overflow', 'hidden');
    /// Normalize caption
    Style.SetProperty('padding', '0');
    Style.SetProperty('white-space', 'nowrap');
    /// Click
    AddEventListener('click', AEvent);
    /// Caption
    InnerHTML := ACaption;
  end;
end;

function TCustomPageControl.RenderTabActive(const ACaption: string;
  const ALeft, ATop, AWidth, AHeight: nativeint; const AEvent: JSValue): TJSHTMLElement;
begin
  Result := RenderTab(ACaption, ALeft, ATop, AWidth, AHeight, AEvent);
  with Result do
  begin
    /// Border
    Style.SetProperty('border-bottom', '0px');
    /// Color
    Style.SetProperty('background-color', '#fff');
  end;
end;

function TCustomPageControl.RenderTabLeft(const ALeft, ATop, AWidth, AHeight: nativeint;
  const AEvent: JSValue): TJSHTMLElement;
begin
  Result := RenderTab('‹', ALeft, ATop, AWidth, AHeight, AEvent);
  with Result do
  begin
    /// Color
    Style.SetProperty('background-color', '#fff');
  end;
end;

function TCustomPageControl.RenderTabRight(const ALeft, ATop, AWidth, AHeight: nativeint;
  const AEvent: JSValue): TJSHTMLElement;
begin
  Result := RenderTab('›', ALeft, ATop, AWidth, AHeight, AEvent);
  with Result do
  begin
    /// Color
    Style.SetProperty('background-color', '#fff');
  end;
end;

procedure TCustomPageControl.RenderTabs;
var
  form: TCustomForm;

  function AdjustWithPPI(aValue: integer): integer;
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
      Result := nil;
  end;

var
  VPage: TCustomTabSheet;
  VIndex: nativeint;
  VStartIndex: nativeint;
  VEndIndex: nativeint;
  VTabCaption: string;
  VTabHeight: nativeint;
  VTabLeft: nativeint;
  VTabWidth: nativeint;
  VSumTabsWidth: nativeint;
  VMaxTabWidth: nativeint;
  VTabsCount: nativeint;
begin
  form := FindParentForm;
  VTabHeight := CalcTabHeight;
  VSumTabsWidth := CalcSumTabsWidth;
  /// Containter
  with FTabContainerElement do
  begin
    /// Clean
    InnerHTML := '';
    /// Bounds
    Style.SetProperty('left', '0px');
    Style.SetProperty('top', '0px');
    Style.SetProperty('width',
      IntToStr(AdjustWithPPI(IfThen((VSumTabsWidth > Width), VSumTabsWidth,
      Width))) + 'px');
    Style.SetProperty('height', IntToStr(AdjustWithPPI(VTabHeight)) + 'px');
    /// Position
    Style.SetProperty('position', 'absolute');
    /// Scroll
    Style.SetProperty('overflow', 'hidden');
  end;
  /// Tabs
  if (FPageIndex > -1) and (FPageIndex < FPages.Length) then
  begin
    /// Quantity of tabs greater than the container
    if (VSumTabsWidth > Width) then
    begin
      VTabLeft := 40;
      VMaxTabWidth := CalcMaxTabWidth;
      VTabsCount := Trunc((Width - 80) div VMaxTabWidth);
      if (VTabsCount = 0) then
      begin
        VTabsCount := 1;
      end;
      if ((FPageIndex - VTabsCount) >= 0) then
      begin
        VStartIndex := (FPageIndex - VTabsCount) + 1;
        VEndIndex := FPageIndex;
      end
      else
      begin
        VStartIndex := 0;
        VEndIndex := VTabsCount - 1;
      end;
      VMaxTabWidth := Trunc((Width - 80) div VTabsCount);
      /// Tab
      for VIndex := VStartIndex to VEndIndex do
      begin
        VPage := TCustomTabSheet(FPages[VIndex]);
        if (Assigned(VPage)) and (VPage.TabVisible) then
        begin
          VTabCaption := VPage.Caption;
          VTabWidth := VMaxTabWidth;
          if (VIndex = FPageIndex) then
          begin
            /// Register tab
            FTabContainerElement.AppendChild(RenderTabActive(VTabCaption,
              AdjustWithPPI(VTabLeft), 0, AdjustWithPPI(VTabWidth),
              AdjustWithPPI(VTabHeight), @TabClick));
          end
          else
          begin
            /// Register tab
            FTabContainerElement.AppendChild(RenderTab(VTabCaption,
              AdjustWithPPI(VTabLeft), 0, AdjustWithPPI(VTabWidth),
              AdjustWithPPI(VTabHeight), @TabClick));
          end;
          /// Calculate the next position of the tab
          VTabLeft := VTabLeft + VTabWidth;
        end;
      end;
      /// Register navigation tabs
      with FTabContainerElement do // First and Last Tabs
      begin
        AppendChild(RenderTabLeft(0, 0, 40, AdjustWithPPI(VTabHeight), @TabLeftClick));
        AppendChild(RenderTabRight(AdjustWithPPI(Width - 40), 0, 40,
          AdjustWithPPI(VTabHeight), @TabRightClick));
      end;
    end
    else
    begin
      VTabLeft := 0;
      VStartIndex := 0;
      VEndIndex := (FPages.Length - 1);
      VTabWidth := (Width div FPages.Length);
      /// Tab
      for VIndex := VStartIndex to VEndIndex do
      begin
        VPage := TCustomTabSheet(FPages[VIndex]);
        if (Assigned(VPage)) and (VPage.TabVisible) then
        begin
          VTabCaption := VPage.Caption;
          if (VIndex = FPageIndex) then
          begin
            /// Register tab
            FTabContainerElement.AppendChild(RenderTabActive(VTabCaption,
              AdjustWithPPI(VTabLeft), 0, AdjustWithPPI(VTabWidth),
              AdjustWithPPI(VTabHeight), @TabClick));
          end
          else
          begin
            /// Register tab
            FTabContainerElement.AppendChild(RenderTab(VTabCaption,
              AdjustWithPPI(VTabLeft), 0, AdjustWithPPI(VTabWidth),
              AdjustWithPPI(VTabHeight), @TabClick));
          end;
          /// Calculate the next position of the tab
          VTabLeft := VTabLeft + VTabWidth;
        end;
      end;
    end;
  end;
end;

procedure TCustomPageControl.TabClick(AEvent: TJSMouseEvent);
begin
  SetPageIndex(IndexOfTab(AEvent.targetElement.InnerHTML));
end;

procedure TCustomPageControl.TabLeftClick(AEvent: TJSMouseEvent);
begin
  SetPageIndex(FPageIndex - 1);
end;

procedure TCustomPageControl.TabRightClick(AEvent: TJSMouseEvent);
begin
  SetPageIndex(FPageIndex + 1);
end;

procedure TCustomPageControl.UpdatePages;
var
  VIndex: nativeint;
  VPage: TCustomTabSheet;
  VTabHeight: nativeint;
begin
  VTabHeight := CalcTabHeight;
  for VIndex := 0 to (FPages.Length - 1) do
  begin
    VPage := TCustomTabSheet(FPages[VIndex]);
    if (Assigned(VPage)) and (VPage.TabVisible) then
    begin
      VPage.BeginUpdate;
      try
        if (VIndex = FPageIndex) then
        begin
          VPage.SetBounds(0, VTabHeight, (Width), ((Height) - VTabHeight));
          VPage.Visible := True;
        end
        else
        begin
          VPage.Visible := False;
        end;
      finally
        VPage.EndUpdate;
      end;
    end;
  end;
end;

class function TCustomPageControl.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 200;
  Result.Cy := 200;
end;

constructor TCustomPageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTabContainerElement := CreateTabContainerElement;
  FPages := TJSArray.New();
  FPageIndex := -1;
  FShowTabs := True;
  FTabPosition := tpTop;
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

destructor TCustomPageControl.Destroy;
begin
  FPages.Length := 0;
  inherited Destroy;
end;

function TCustomPageControl.AddTabSheet: TCustomTabSheet;
begin
  Result := TCustomTabSheet.Create(Self);
  Result.PageControl := Self;
end;

function TCustomPageControl.IndexOf(APage: TCustomTabSheet): nativeint;
begin
  Result := FPages.IndexOf(APage);
end;

end.

