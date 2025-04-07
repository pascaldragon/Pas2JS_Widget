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
unit Forms;

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
  TFormType = (ftModalForm, ftWindow);
  TCloseAction = (caNone, caHide, caFree);
  TCloseEvent = procedure(Sender: TObject; var CloseAction: TCloseAction) of object;
  TCloseQueryEvent = procedure(Sender: TObject; var CanClose: boolean) of object;

  TModalResult = low(integer)..high(integer);
  TModalResultProc = reference to procedure (Sender: TObject; ModalResult: TModalResult);

  { TCustomDataModule }

  TCustomDataModule = class(TControl)
  private
    FOldOrder: Boolean;
    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
  protected
    Procedure DoCreate; virtual;
    Procedure DoDestroy; virtual;
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public           
    constructor Create(AOwner: TComponent); override;
    Procedure AfterConstruction; override;
    Procedure BeforeDestruction; override;
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property OldCreateOrder: Boolean read FOldOrder write FOldOrder;
  end;

  { TCustomFrame }

  TCustomFrame = class(TCustomControl)
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
  end;
  TCustomFrameClass = class of TCustomFrame;

  { TCustomForm }

  TCustomForm = class(TCustomControl)
  private          
    FActiveControl: TWinControl; 
    FAlphaBlend: boolean;
    FAlphaBlendValue: byte;
    FChildForm: TCustomForm;
    FDesignTimePPI: Integer;
    FFormType: TFormType;
    FKeyPreview: boolean;   
    FModalResult: TModalResult;
    FModalResultProc: TModalResultProc;   
    FOverlay: TObject;
    FOnActivate: TNotifyEvent;
    FOnClose: TCloseEvent;
    FOnCloseQuery: TCloseQueryEvent;
    FOnCreate: TNotifyEvent;
    FOnDeactivate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    FOnHide: TNotifyEvent;
    FOnResize: TNotifyEvent;
    FOnScroll: TNotifyEvent;
    FOnShow: TNotifyEvent;
    procedure SetActiveControl(AValue: TWinControl);
    procedure SetAlphaBlend(AValue: boolean);
    procedure SetAlphaBlendValue(AValue: byte);
    procedure SetFormBorderStyle(AValue: TFormBorderStyle);
    procedure SetModalResult(AValue: TModalResult);
  protected
    property Overlay: TObject read FOverlay write FOverlay;
    property ChildForm: TCustomForm read FChildForm write FChildForm;
  protected
    fFormBorderStyle: TFormBorderStyle;
    procedure Activate; virtual;
    procedure Deactivate; virtual;
    procedure DoClose(var CloseAction: TCloseAction); virtual;
    procedure DoCreate; virtual;
    procedure DoDestroy; virtual;
    procedure DoHide; virtual;
    procedure DoResize; override;
    procedure DoShow; virtual;
  protected
    function HandleEnter(AEvent: TJSFocusEvent): boolean; override;
    function HandleExit(AEvent: TJSEvent): boolean; override;
  protected
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
    procedure ProcessResource; virtual;
  protected
    class function GetControlClassDefaultSize: TSize; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateNew(AOwner: TComponent; Num: Integer = 0); virtual;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure Close; virtual;
    function CloseQuery: boolean; virtual;
    procedure FocusControl(const AControl: TWinControl); virtual;
    procedure Hide; virtual;
    procedure Loaded; override;
    procedure Resize; virtual;
    procedure Show; virtual;
    procedure ShowModal(AModalResultProc: TModalResultProc); virtual;
  public
    property ActiveControl: TWinControl read FActiveControl write SetActiveControl;
    property AlphaBlend: boolean read FAlphaBlend write SetAlphaBlend;
    property AlphaBlendValue: byte read FAlphaBlendValue write SetAlphaBlendValue;
    property BorderStyle: TFormBorderStyle read fFormBorderStyle write SetFormBorderStyle default bsSizeable;
    property FormType: TFormType read FFormType;
    property KeyPreview: boolean read FKeyPreview write FKeyPreview;
    property DesignTimePPI: Integer read FDesignTimePPI write FDesignTimePPI;
    property ModalResult: TModalResult read FModalResult write SetModalResult;
    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
    property OnClose: TCloseEvent read FOnClose write FOnClose;
    property OnCloseQuery: TCloseQueryEvent read FOnCloseQuery write FOnCloseQuery;
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDeactivate: TNotifyEvent read FOnDeactivate write FOnDeactivate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    property OnScroll: TNotifyEvent read FOnScroll write FOnScroll;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
  end;
  TCustomFormClass = class of TCustomForm;

  { TApplication }

  TApplication = class(TComponent)
  private
    FModules: TJSArray;
    FActiveForm: TCustomForm;
    FMainForm: TCustomForm;
    FStopOnException: boolean;
    FTerminated: boolean;
    FTitle: string;
    FOnResize: TNotifyEvent;
    FOnUnload: TNotifyEvent;
    function GetApplicatioName: string;
    function GetModule(const AIndex: NativeInt): TControl;
    function GetModuleCount: NativeInt;
    function GetModuleIndex(const AModule: TControl): NativeInt;
    function GetTitle: string;
    procedure SetTitle(AValue: string);
  protected
    procedure DoResize; virtual;
    procedure DoUnload; virtual;
    procedure LoadIcon; virtual;
  protected
    procedure RegisterHandleEvents; virtual;
    procedure UnRegisterHandleEvents; virtual;
  protected
    function HandleError(AEvent: TJSErrorEvent): boolean;
    function HandleResize(AEvent: TJSEvent): boolean;
    function HandleUnload(AEvent: TJSUIEvent): boolean;
    procedure HandleException(AException: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateForm(AInstanceClass: TControlClass; out AReference); virtual;
    procedure Initialize; virtual;
    procedure Run; virtual;
    procedure Terminate; virtual;   
    procedure UpdateMainForm(AForm: TCustomForm);  
    procedure RegisterModule(AModule: TControl); virtual;
    procedure UnRegisterModule(AModule: TControl); virtual;
  public      
    property ActiveForm: TCustomForm read FActiveForm write FActiveForm;   
    property ApplicatioName: string read GetApplicatioName;
    property ModuleCount: NativeInt read GetModuleCount;        
    property ModuleIndex[const AModule: TControl]: NativeInt read GetModuleIndex;
    property Module[const AIndex: NativeInt]: TControl read GetModule;
    property MainForm: TCustomForm read FMainForm;
    property StopOnException: boolean read FStopOnException write FStopOnException;
    property Terminated: boolean read FTerminated;
    property Title: string read GetTitle write SetTitle;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    property OnUnload: TNotifyEvent read FOnUnload write FOnUnload;
  end;

  { TWForm }

  TWForm = class(TCustomForm)
  published
    property ActiveControl;
    property Align;
    property AlphaBlend;
    property AlphaBlendValue;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property DesignTimePPI;
    property Enabled;
    property Font;
    property HandleClass;
    property HandleID;
    property KeyPreview;
    property ShowHint;
    property Visible;
    property OnActivate;
    property OnClick;
    property OnClose;
    property OnCloseQuery;
    property OnCreate;
    property OnDblClick;
    property OnDeactivate;
    property OnDestroy;
    property OnHide;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnResize;
    property OnScroll;
    property OnShow;
  end;
  TWFormClass = class of TWForm;

  { TWFrame }

  TWFrame = class(TCustomFrame)
  private
    /// Fake
    FDesignLeft: LongInt;
    FDesignTop: LongInt;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnResize;
  published
    /// Fake
    property DesignLeft: LongInt read FDesignLeft write FDesignLeft;
    property DesignTop: LongInt read FDesignTop write FDesignTop;
  end;
  TWFrameClass = class of TWFrame;

{ TODO: TScreen }

function Application: TApplication;

implementation

uses
  WResources, WCLStrConsts, p2jsres;

{$push}
{$hints off}

procedure DefaultModalProc(Sender: TObject; ModalResult: TModalResult);
begin
  if (Assigned(Sender)) then
  begin
    Sender.Destroy;
    Sender := nil;
  end;
end;

{$pop}

var
  VAppInstance: TApplication;

function Application: TApplication;
begin
  if not (Assigned(VAppInstance)) then
  begin
    VAppInstance := TApplication.Create(nil);
  end;
  Result := VAppInstance;
end;


type

  { TOverlay }

  TOverlay = class
  private
    FForm: TCustomForm;
    FHandleElement: TJSHTMLElement;
  public
    constructor Create(const AForm: TCustomForm); reintroduce;
    destructor Destroy; override;
  end;   

{ TOverlay }

constructor TOverlay.Create(const AForm: TCustomForm);
begin
  FForm := AForm;
  if (Assigned(FForm)) then
  begin
    FHandleElement := TJSHTMLElement(Document.CreateElement('div'));
    with FHandleElement do
    begin
      /// Bounds
      Style.SetProperty('left', '0px');
      Style.SetProperty('top', '0px');
      Style.SetProperty('height', '100%');
      Style.SetProperty('width', '100%');
      /// Color
      Style.SetProperty('background', 'rgba(0, 0, 0, 0.6)');
      /// Position
      Style.SetProperty('position', 'absolute');
      /// Scroll
      Style.SetProperty('overflow', 'hidden');
    end;
    /// Register
    FForm.HandleElement.AppendChild(FHandleElement);
  end;
end;

destructor TOverlay.Destroy;
begin
  /// UnRegister
  if (Assigned(FForm)) then
  begin
    FForm.HandleElement.RemoveChild(FHandleElement);
  end;
  inherited Destroy;
end;



{ TCustomDataModule }

procedure TCustomDataModule.DoCreate;
begin
  if (Assigned(FOnCreate)) then
  begin
    FOnCreate(Self);
  end;
end;

procedure TCustomDataModule.DoDestroy;
begin
  if (Assigned(FOnDestroy)) then
  begin
    FOnDestroy(Self);
  end;
end;

procedure TCustomDataModule.Changed;
begin
  inherited Changed;  
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with HandleElement do
    begin
      /// Visibility
      Style.SetProperty('visibility', 'hidden');
      Style.SetProperty('display', 'none');
    end;
  end;
end;

function TCustomDataModule.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('div'));
end;

class function TCustomDataModule.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 150;
  Result.Cy := 150;
end;

constructor TCustomDataModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);  
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

procedure TCustomDataModule.AfterConstruction;
begin
  inherited AfterConstruction;
  Application.RegisterModule(Self);
  Loaded;
  DoCreate;
end;

procedure TCustomDataModule.BeforeDestruction;
begin           
  inherited BeforeDestruction;   
  Application.UnRegisterModule(Self);
  //Destroying;
  DoDestroy;
end;

{ TCustomFrame }

procedure TCustomFrame.Changed;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with HandleElement do
    begin
      /// Focus highlight
      Style.SetProperty('outline', 'none');
      /// Scroll
      Style.SetProperty('overflow', 'auto');
    end;
  end;
end;

function TCustomFrame.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('div'));
end;

class function TCustomFrame.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 320;
  Result.Cy := 240;
end;

constructor TCustomFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if (ClassType<>TWFrame) and ([csDesignInstance, csDesigning]*ComponentState=[]) then begin
    if not InitResourceComponent(Self, TWFrame) then
      raise EResNotFound.CreateFmt(rsResourceNotFound, [ClassName]);
  end else begin
    BeginUpdate;
    try
      ParentFont := False;
      ParentShowHint := False;
      with GetControlClassDefaultSize do
      begin
        SetBounds(0, 0, Cx, Cy);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TCustomFrame.AfterConstruction;
begin
  inherited AfterConstruction;
  Loaded;
end;

{ TCustomForm }

procedure TCustomForm.SetActiveControl(AValue: TWinControl);
begin
  if (FActiveControl <> AValue) then
  begin
    FActiveControl := AValue;
  end;
end;

procedure TCustomForm.SetAlphaBlend(AValue: boolean);
begin
  if (FAlphaBlend <> AValue) then
  begin
    FAlphaBlend := AValue;
    Changed;
  end;
end;

procedure TCustomForm.SetAlphaBlendValue(AValue: byte);
begin
  if (FAlphaBlendValue <> AValue) then
  begin
    FAlphaBlendValue := AValue;
    Changed;
  end;
end;

procedure TCustomForm.SetFormBorderStyle(AValue: TFormBorderStyle);
var
  bs: TBorderStyle;
begin
  if fFormBorderStyle = AValue then
    Exit;

  fFormBorderStyle := AValue;

  if AValue in [Low(TBorderStyle)..High(TBorderStyle)] then
    bs := AValue
  else
    bs := bsNone;

  inherited SetBorderStyle(bs);
end;

procedure TCustomForm.SetModalResult(AValue: TModalResult);
begin
  if (FModalResult <> AValue) then
  begin
    FModalResult := AValue;
    if (FModalResult <> mrNone) and (Assigned(FModalResultProc)) then
    begin
      Close;
    end;
  end;
end;

procedure TCustomForm.Activate;
begin
  if (Assigned(FOnActivate)) then
  begin
    FOnActivate(Self);
  end;
end;

procedure TCustomForm.Deactivate;
begin
  if (Assigned(FOnDeactivate)) then
  begin
    FOnDeactivate(Self);
  end;
end;

{$hints off}

procedure TCustomForm.DoClose(var CloseAction: TCloseAction);
begin
  if (Assigned(FOnDeactivate)) then
  begin
    FOnDeactivate(Self);
  end;
end;

{$hints on}

procedure TCustomForm.DoCreate;
begin
  if (Assigned(FOnCreate)) then
  begin
    FOnCreate(Self);
  end;
end;

procedure TCustomForm.DoDestroy;
begin
  if (Assigned(FOnDestroy)) then
  begin
    FOnDestroy(Self);
  end;
end;

procedure TCustomForm.DoHide;
begin
  if (Assigned(FOnHide)) then
  begin
    FOnHide(Self);
  end;
end;

procedure TCustomForm.DoResize;
begin
  inherited DoResize;
  if (Assigned(OnResize)) then
  begin
    FOnResize(Self);
  end;
end;

procedure TCustomForm.DoShow;
begin
  if (Assigned(FOnShow)) then
  begin
    FOnShow(Self);
  end;
end;

function TCustomForm.HandleEnter(AEvent: TJSFocusEvent): boolean;
var
  VControl: TWinControl;
begin
  Result := inherited HandleEnter(AEvent);
  if (Assigned(FChildForm)) and (FChildForm.FormType = ftModalForm) then
  begin
    FChildForm.Show;
  end
  else
  begin
    if (Assigned(FActiveControl)) then
    begin
      VControl := FActiveControl;
    end
    else
    begin
      VControl := FindFocusControl(nil, fsdFirst);
    end;
    FocusControl(VControl);
    Activate;
  end;
end;

function TCustomForm.HandleExit(AEvent: TJSEvent): boolean;
begin
  Result := inherited HandleExit(AEvent);
  Deactivate;
end;

procedure TCustomForm.Changed;
begin
  inherited Changed;
  if (not IsUpdating) and not (csLoading in ComponentState) then
  begin
    with HandleElement do
    begin
      /// Focus highlight
      Style.SetProperty('outline', 'none');
      /// AphaBlend/Opacity
      if (FAlphaBlend) then
      begin
        Style.SetProperty('opacity', FloatToStr(FAlphaBlendValue div 255));
      end
      else
      begin
        Style.RemoveProperty('opacity');
      end;
      /// Scroll
      Style.SetProperty('overflow', 'auto');
    end;
  end;
end;

function TCustomForm.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('div'));
end;

procedure TCustomForm.ProcessResource;
begin
  if not InitResourceComponent(Self, TWForm) then
    raise EResNotFound.CreateFmt(
      rsFormResourceSNotFoundForResourcelessFormsCreateNew, [ClassName]);
end;

class function TCustomForm.GetControlClassDefaultSize: TSize;
begin
  Result.Cx := 320;
  Result.Cy := 240;
end;

constructor TCustomForm.Create(AOwner: TComponent);
begin
  CreateNew(AOwner, 1);
  if (ClassType <> TWForm) and not (csDesigning in ComponentState) then begin
    ProcessResource;
  end;
end;

constructor TCustomForm.CreateNew(AOwner: TComponent; Num: Integer);
begin
  inherited Create(AOwner);
  FActiveControl := nil;
  FAlphaBlend := False;
  FAlphaBlendValue := 255;
  FDesignTimePPI := 96;
  FChildForm := nil;
  FFormType := ftWindow;
  FKeyPreview := False;
  FModalResult := mrNone;
  FModalResultProc := nil;
  FOverlay := nil;
  BorderStyle := bsSizeable;
  BeginUpdate;
  try
    ParentFont := False;
    ParentShowHint := False;
    Visible := False;
    with GetControlClassDefaultSize do
    begin
      SetBounds(0, 0, Cx, Cy);
    end;
  finally
    EndUpdate;
  end;
end;

destructor TCustomForm.Destroy;
begin                   
  FActiveControl := nil;
  FChildForm := nil;
  inherited Destroy;
end;

procedure TCustomForm.AfterConstruction;
begin
  inherited AfterConstruction;
  Application.UpdateMainForm(Self);
  Application.RegisterModule(Self);
  Loaded;
  DoCreate;
end;

procedure TCustomForm.BeforeDestruction;
begin
  inherited BeforeDestruction;
  Application.UnRegisterModule(Self);
  DoDestroy;
end;

procedure TCustomForm.Close;
var
  VAction: TCloseAction;   
  VIndex: NativeInt;
  VOwnerForm: TCustomForm;
  VModule: TControl;
begin
  if (CloseQuery) then
  begin
    VAction := caHide;
    DoClose(VAction);
    if (VAction <> caNone) then
    begin
      if (Application.MainForm = Self) then
      begin
        Application.Terminate;
      end
      else
      begin
        Hide;  
        if (FFormType = ftModalForm) then
        begin
          if (Assigned(Owner)) and (Owner is TCustomForm) then
          begin    
            VOwnerForm := TCustomForm(Owner);
            VOwnerForm.ChildForm := nil;
            if (Assigned(VOwnerForm.Overlay)) then
            begin
              VOwnerForm.Overlay.Destroy;
              VOwnerForm.Overlay := nil;
            end; 
            VOwnerForm.Show;
          end;
          /// Execute Modal Proc
          if (Assigned(FModalResultProc)) then
          begin
            FModalResultProc(Self, FModalResult);
          end;
        end
        else
        begin
          /// Last active form
          for VIndex := (Application.ModuleCount - 1) downto 0 do
          begin
            VModule := Application.Module[VIndex];
            if (Assigned(VModule)) and (VModule.Visible) and (VModule <> Self) and (VModule.InheritsFrom(TCustomForm)) then
            begin
              TCustomForm(VModule).Show;
              Exit;
            end;
          end;
          if (Assigned(Application.MainForm)) then
          begin
            Application.MainForm.Show;
          end;
        end;
      end;
    end;
  end;
end;

function TCustomForm.CloseQuery: boolean;
begin
  Result := True;
  if (Assigned(FOnCloseQuery)) then
  begin
    FOnCloseQuery(Self, Result);
  end;
end;

procedure TCustomForm.FocusControl(const AControl: TWinControl);
begin
  if (Assigned(AControl)) and (AControl.CanSetFocus) then
  begin
    AControl.SetFocus;
  end;
end;

procedure TCustomForm.Hide;
begin
  Visible := False;
  DoHide;
end;

procedure TCustomForm.Loaded;
begin
  inherited Loaded;
  /// Used only for forms (for controls created at runtime)
end;

procedure TCustomForm.Resize;
var
  VHeight: NativeInt;
  VLeft: NativeInt;
  VTop: NativeInt;
  VWidth: NativeInt;
  VWindowHeight: NativeInt;
  VWindowWidth: NativeInt;
begin
  VWindowWidth := Window.InnerWidth;
  VWindowHeight := Window.InnerHeight;
  case FFormType of
    ftModalForm:
    begin
      VWidth := Width;
      VHeight := Height;
      VLeft := (VWindowWidth - VWidth) div 2;
      VTop := (VWindowHeight - VHeight) div 2;
      SetBounds(VLeft, VTop, VWidth, VHeight);
    end;
    ftWindow:
    begin
      SetBounds(0, 0, VWindowWidth, VWindowHeight);
    end;
  end;
  DoResize;
end;

procedure TCustomForm.Show;
begin          
  Application.ActiveForm := Self;
  Application.Title := Caption;
  BeginUpdate;
  try
    Visible := True;
    Resize;
  finally
    EndUpdate;
  end;
  BringToFront;
  SetFocus;               
  DoShow;
end;

procedure TCustomForm.ShowModal(AModalResultProc: TModalResultProc);
Var
  VForm: TCustomForm;
begin
  if (not(Assigned(Owner))) then
  begin
   raise TJSError.New('Owner not found.');
  end;
  if (not(Owner is TCustomForm)) then
  begin
    raise TJSError.New('Invalid owner.');
  end;
  VForm := TCustomForm(Owner);
  if (Assigned(VForm.ChildForm)) then
  begin
    raise TJSError.New('Modal form already exists.');
  end;
  VForm.ChildForm := Self;
  VForm.Overlay := TOverlay.Create(VForm);
  FFormType := ftModalForm;
  FModalResult := mrNone;
  if (Assigned(AModalResultProc)) then
  begin
    FModalResultProc := AModalResultProc;
  end
  else
  begin
    FModalResultProc := @DefaultModalProc;
  end;
  Show;
end;

{ TApplication }

function TApplication.GetApplicatioName: string;
begin
  Result := Window.Location.PathName;
end;

function TApplication.GetModule(const AIndex: NativeInt): TControl;
begin
  Result := TControl(FModules[AIndex]);
end;

function TApplication.GetModuleCount: NativeInt;
begin
  Result := FModules.Length;
end;

function TApplication.GetModuleIndex(const AModule: TControl): NativeInt;
begin
  Result := FModules.IndexOf(AModule);
end;

function TApplication.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TApplication.SetTitle(AValue: string);
begin
  if (FTitle <> AValue) then
  begin
    FTitle := AValue;
    Document.Title := FTitle;
  end;
end;

procedure TApplication.DoResize;
begin
  if (Assigned(FOnResize)) then
  begin
    FOnResize(Self);
  end;
end;

procedure TApplication.DoUnload;
begin
  if (Assigned(FOnUnload)) then
  begin
    FOnUnload(Self);
  end;
end;

procedure TApplication.LoadIcon;
begin
  /// Add an icon logo to the title bar
  with TJSHTMLElement(Document.Head.AppendChild(Document.CreateElement('link'))) do
  begin
    SetAttribute('rel', 'icon');
    SetAttribute('type', 'image/icon');
    SetAttribute('href',  TJSString(ApplicatioName).Replace('html', 'ico'));
  end;
end;

procedure TApplication.RegisterHandleEvents;
begin
  with Window do
  begin
    AddEventListener('error', @HandleError);
    AddEventListener('resize', @HandleResize);
    AddEventListener('unload', @HandleUnload);
  end;
end;

procedure TApplication.UnRegisterHandleEvents;
begin
  with Window do
  begin
    RemoveEventListener('error', @HandleError);
    RemoveEventListener('resize', @HandleResize);
    RemoveEventListener('unload', @HandleUnload);
  end;
end;

function TApplication.HandleError(AEvent: TJSErrorEvent): boolean;
const
  CLE = LineEnding;
  CError = 'Error Message: %s ' + CLE + 'Line Nro: %d ' + CLE + 'Column Nro: %d ' + CLE;
begin
  if (TJSString(TJSString(AEvent.Message).ToLowerCase).IndexOf('script error') > -1) then
  begin
    Window.Alert('Script Error: See Browser Console for Detail');
  end
  else
  begin
    Window.Alert(Format(CError, [AEvent.Message, AEvent.LineNo, AEvent.ColNo]))
  end;
  if (FStopOnException) then
  begin
    Terminate;
  end;
  AEvent.StopPropagation;
  Result := False;
end;

procedure TApplication.HandleException(AException: TObject);
begin
  if AException is Exception then begin
    Window.Alert(Format(rsErrUncaughtException, [AException.ClassName, Exception(AException).Message]));
  end else begin
    Window.Alert(Format(rsErrUncaughtObject, [AException.ClassName]));
  end;
  if FStopOnException then
    Terminate;
end;

function TApplication.HandleResize(AEvent: TJSEvent): boolean;
var
  VControl: TControl;
  VIndex: NativeInt;
begin
  AEvent.StopPropagation;
  DoResize();
  Result := True;
  /// Notify all of forms resize
  for VIndex := 0 to (FModules.Length - 1) do
  begin
    VControl := TControl(FModules[VIndex]);
    if (Assigned(VControl)) and (VControl.Visible) and (VControl.InheritsFrom(TCustomForm)) then
    begin
      TCustomForm(VControl).Resize;
    end
  end;
end;

function TApplication.HandleUnload(AEvent: TJSUIEvent): boolean;
begin
  AEvent.StopPropagation;
  Result := True;
  try
    DoUnload();
  finally
    Terminate;
  end;
end;

procedure DoUncaughtPascalException(E: TObject);
begin
  Application.HandleException(E);
end;

constructor TApplication.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetResourceSource(rsJS);
{$if PAS2JS_FULLVERSION >= 10501}
  SetOnUnCaughtExceptionHandler(@DoUncaughtPascalException);
  asm
    rtl.showUncaughtExceptions=true;
  end;
{$endif}
  FModules := TJSArray.New;
  FMainForm := nil;
  FStopOnException := True;
  FTerminated := False;
  FTitle := '';
end;

destructor TApplication.Destroy;
begin
  FModules.Length := 0;
  inherited Destroy;
end;

procedure TApplication.CreateForm(AInstanceClass: TControlClass; out AReference);
begin
  try
    AReference := AInstanceClass.Create(Self);
  except
    AReference := Nil;
    raise;
  end;
end;

procedure TApplication.Initialize;
begin
end;

procedure TApplication.Run;
begin
  { TODO: Add a background to the application }
  RegisterHandleEvents;
  LoadIcon;
  if (Assigned(FMainForm)) then
  begin
    FMainForm.Show;
  end;
end;

procedure TApplication.Terminate;
var
  VModule: TControl;
  VIndex: NativeInt;
begin
  if (not FTerminated) then
  begin
    UnRegisterHandleEvents;
    FTerminated := True;
    for VIndex := (FModules.Length - 1) downto 0 do
    begin
      VModule := TControl(FModules[VIndex]);
      if (Assigned(VModule)) then
      begin
        VModule.Destroy;
        VModule := nil;
      end;
    end;
  end;
end;

procedure TApplication.UpdateMainForm(AForm: TCustomForm);
begin
  if (not Assigned(FMainForm)) then
  begin
    FMainForm := AForm;
    FActiveForm := AForm;
  end;
end;

procedure TApplication.RegisterModule(AModule: TControl);
begin
  if (Assigned(AModule)) then
  begin
    if (FModules.IndexOf(AModule) = -1) then
    begin
      FModules.Push(AModule);
      if (not Document.Body.Contains(AModule.HandleElement)) then
      begin
        Document.Body.AppendChild(AModule.HandleElement);
      end;
    end;
  end;
end;

procedure TApplication.UnRegisterModule(AModule: TControl);
var
  VIndex: NativeInt;
begin
  if (Assigned(AModule)) then
  begin
    VIndex := FModules.IndexOf(AModule);
    if (VIndex >= 0) then
    begin
      FModules.Splice(VIndex, 1);
      if (Document.Body.Contains(AModule.HandleElement)) then
      begin
        Document.Body.RemoveChild(AModule.HandleElement);
      end;
    end;
  end;
end;

end.
