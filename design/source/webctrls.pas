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
unit WebCtrls;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,{%H-}
  LResources,
  Graphics,
  Controls,
  Forms,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  NumCtrls,
  DttCtrls,
  BtnCtrls,
  DataGrid,
  CustomTimer,
  Grids;

type

  { TWForm }

  TWForm = class(TCustomForm)
  private
    FHandleClass: string;
    FHandleId: string;
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
    ///property FormType;  
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
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
    ///property OnScroll;
    property OnShow;
  end;
  TWFormClass = class of TWForm;

  { TWFrame }

  TWFrame = class(TCustomFrame)
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
  end;
  TWFrameClass = class of TWFrame;

  { TWDataModule }

  TWDataModule = class(TDataModule)
  end;   
  TWDataModuleClass = class of TWDataModule;

  { TWComboBox }

  TWComboBox = class(TCustomComboBox)
  private
    FHandleClass: string;
    FHandleId: string;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property ItemHeight;
    property ItemIndex;
    property Items;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
  end;

  { TWListBox }

  TWListBox = class(TCustomListBox)
  private
    FHandleClass: string;
    FHandleId: string;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property ItemHeight;
    property ItemIndex;
    property Items;
    property MultiSelect;
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
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnSelectionChange;
  end;

  { TWEdit }

  TWEdit = class(TCustomEdit)
  private
    FHandleClass: string;
    FHandleId: string;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BorderStyle;
    property CharCase;
    property Color;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property MaxLength;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property ReadOnly;
    property ShowHint;
    property TabStop;
    property TabOrder;
    property Text;
    property TextHint;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
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
  end;

  { TWMemo }

  TWMemo = class(TCustomMemo)
  private
    FHandleClass: string;
    FHandleId: string;
  published
    property Align;
    property Alignment;
    property Anchors;
    property BorderSpacing;
    property BorderStyle;
    property CharCase;
    property Color;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property Lines;
    property MaxLength;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TextHint;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
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
  end;

  { TWButton }

  TWButton = class(TCustomButton)
  private
    FHandleClass: string;
    FHandleId: string;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property Caption;
    property Color;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property Hint;
    property ModalResult;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnEnter;
    property OnExit;
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
  end;

  { TWCheckbox }

  TWCheckbox = class(TCustomCheckbox)
  private
    FHandleClass: string;
    FHandleId: string;
  published
    property Align;
    property Alignment;
    /// property AllowGrayed;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property Caption;
    property Checked;
    property Color;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property State;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnKeyPress;
    property OnKeyDown;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnResize;
  end;

  { TWLabel }

  TWLabel = class(TCustomLabel)
  private
    FHandleClass: string;
    FHandleId: string;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property Caption;
    property Color;
    property Enabled;
    property FocusControl;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property Layout;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Transparent;
    property Visible;
    property WordWrap;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnResize;
  end;

  { TWImage }

  TWImage = class(TCustomImage)
  private
    FHandleClass: string;
    FHandleId: string;
    FURL: String;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property Center;
    property Enabled;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property ParentShowHint;
    property Proportional;
    property ShowHint;
    property Stretch;
    property StretchOutEnabled;
    property StretchInEnabled;
    property Transparent;
    property URL: String read FURL write FURL;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnPaint;
    property OnPictureChanged;
    property OnResize;
  end;

  { TWPanel }

  TWPanel = class(TCustomPanel)
  private
    FHandleClass: string;
    FHandleId: string;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BevelColor;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderSpacing;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property Wordwrap;
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
    property OnPaint;
    property OnResize;
  end;

  { TWTimer }

  TWTimer = class(TCustomTimer)
  published
    property Enabled;
    property Interval;
    property OnTimer;
    property OnStartTimer;
    property OnStopTimer;
  end;

  { TWPageControl }

  TWPageControl = class(TPageControl)
  private
    FHandleClass: string;
    FHandleId: string;
  published
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
  end;

  { TWFloatEdit }

  TWFloatEdit = class(TCustomNumericEdit)
  private
    FHandleClass: string;
    FHandleId: string;
    function GetValue: double;
    procedure SetValue(AValue: double);
  protected
    procedure RealSetText(const AValue: TCaption); override;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property DecimalPlaces;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property ReadOnly;
    property ShowHint;
    property TabStop;
    property TabOrder;
    property Text;
    property TextHint;
    property Value: double read GetValue write SetValue;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
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
  end;

  { TWIntegerEdit }

  TWIntegerEdit = class(TCustomNumericEdit)
  private
    FHandleClass: string;
    FHandleId: string;
    function GetValue: NativeInt;
    procedure SetValue(AValue: NativeInt);
  protected
    procedure RealSetText(const AValue: TCaption); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property ReadOnly;
    property ShowHint;
    property TabStop;
    property TabOrder;
    property Text;
    property TextHint;
    property Value: NativeInt read GetValue write SetValue;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
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
  end;

  { TWDateEditBox }

  TWDateEditBox = class(TCustomDateTimeEdit)
  private
    FHandleClass: string;
    FHandleId: string;
    function GetValue: TDate;
    procedure SetValue(AValue: TDate);
  protected
    procedure RealSetText(const AValue: TCaption); override;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property ReadOnly;
    property ShowHint;
    property TabStop;
    property TabOrder;
    property Text;
    property TextHint;
    property Value: TDate read GetValue write SetValue;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
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
  end;

  { TWTimeEditBox }

  TWTimeEditBox = class(TCustomDateTimeEdit)
  private
    FHandleClass: string;
    FHandleId: string;
    function GetValue: TTime;
    procedure SetValue(AValue: TTime);
  protected
    procedure RealSetText(const AValue: TCaption); override;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property ReadOnly;
    property ShowHint;
    property TabStop;
    property TabOrder;
    property Text;
    property TextHint;
    property Value: TTime read GetValue write SetValue;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
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
  end;

  { TWFileButton }

  TWFileButton = class(TCustomFileButton)
  private
    FHandleClass: string;
    FHandleId: string;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property Caption;
    property Color;
    property Enabled;
    property Filter;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    //property ModalResult;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnEnter;
    property OnExit;
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
  end;

  { TWDataGrid }

  TWDataGrid = class(TCustomDataGrid)
  private
    FHandleClass: string;
    FHandleId: string;
  published
    property Align;
    property Anchors;
    property BorderSpacing;
    property Columns;
    property ColumnClickSorts;
    property DefaultColWidth;
    property DefaultRowHeight;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property SortOrder;
    property ShowHeader;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCellClick;
    property OnEnter;
    property OnExit;
    property OnHeaderClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
  end;

  { TWPagination }

  TWPagination = class(TCustomPagination)
  private
    FHandleClass: string;
    FHandleId: string;
  published
    property Align;
    property Anchors;
    property BorderSpacing;
    property CurrentPage;
    property Enabled;
    property Font;
    property HandleClass: string read FHandleClass write FHandleClass;
    property HandleId: string read FHandleId write FHandleId;
    property ParentFont;
    property ParentShowHint;
    property RecordsPerPage;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TotalPages;
    property TotalRecords;
    property Visible;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnPageClick;
  end;

  { TWStringGrid }

  TWStringGrid = class(TCustomStringGrid)
  public
    constructor Create(aOwner: TComponent); override;
  published
    property Anchors;
    property ColCount;
    property Columns;
    property DefaultColWidth;
    property DefaultRowHeight;
    property FixedCols;
    property FixedRows;
    property Options default [];
    property RowCount;

    property OnSelection;
  end;

procedure Register;

implementation

procedure Register;
begin
  {$I webctrls.lrs}
  RegisterComponents('WCL', [
    TWComboBox,
    TWListBox,
    TWEdit,
    TWMemo,
    TWButton,
    TWCheckbox,
    TWLabel,
    TWImage,
    TWPanel,
    TWTimer,
    TWPageControl,
    TWFloatEdit,
    TWIntegerEdit,
    TWDateEditBox,
    TWTimeEditBox,
    TWFileButton,
    TWDataGrid,
    TWPagination,
    TWStringGrid
    ]);
end;

{ TWStringGrid }

constructor TWStringGrid.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  Options := [];
end;

{ TWComboBox }

constructor TWComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := csDropDownList;
end;

{ TWFloatEdit }

function TWFloatEdit.GetValue: double;
begin
  Result := StrToFloatDef(RealGetText, 0);
end;

procedure TWFloatEdit.SetValue(AValue: double);
begin
  RealSetText(FloatToStrF(AValue, ffFixed, 20, DecimalPlaces));
end;

procedure TWFloatEdit.RealSetText(const AValue: TCaption);
begin
  inherited RealSetText(FloatToStrF(StrToFloatDef(AValue, 0), ffFixed, 20, DecimalPlaces));
end;

{ TWIntegerEdit }

function TWIntegerEdit.GetValue: NativeInt;
begin
  Result := StrToIntDef(RealGetText, 0);
end;

procedure TWIntegerEdit.SetValue(AValue: NativeInt);
begin
  RealSetText(FloatToStrF(AValue, ffFixed, 20, DecimalPlaces));
end;

procedure TWIntegerEdit.RealSetText(const AValue: TCaption);
begin
  inherited RealSetText(FloatToStrF(StrToFloatDef(AValue, 0), ffFixed, 20, DecimalPlaces));
end;

constructor TWIntegerEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DecimalPlaces := 0;
end;

{ TWDateEditBox }

function TWDateEditBox.GetValue: TDate;
begin
  Result := StrToDateDef(RealGetText, 0);
end;

procedure TWDateEditBox.SetValue(AValue: TDate);
begin
  RealSetText(DateToStr(AValue));
end;

procedure TWDateEditBox.RealSetText(const AValue: TCaption);
begin
  inherited RealSetText(FormatDateTime(DefaultFormatSettings.ShortDateFormat, StrToDateDef(AValue, 0)));
end;

{ TWTimeEditBox }

function TWTimeEditBox.GetValue: TTime;
begin
  Result := StrToTimeDef(RealGetText, 0);
end;

procedure TWTimeEditBox.SetValue(AValue: TTime);
begin
  RealSetText(TimeToStr(AValue));
end;

procedure TWTimeEditBox.RealSetText(const AValue: TCaption);
begin
  inherited RealSetText(FormatDateTime(DefaultFormatSettings.ShortTimeFormat, StrToTimeDef(AValue, 0)));
end;

end.
