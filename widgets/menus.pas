unit Menus;

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

  { TCustomMenuItem }

  TCustomMenuItem = class(TWinControl)
  private
    procedure OnMenuClick(Sender: TObject);
    procedure OnMenuMouseEnter(Sender: TObject);
    procedure OnMenuMouseLeave(Sender: TObject);

  protected
    procedure Click; override;
    procedure Changed; override;
    function CreateHandleElement: TJSHTMLElement; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  { TMenuItem }

  TMenuItem = class(TCustomMenuItem)
  published
    property Caption;
    property OnClick;
  end;

implementation

{ TCustomMenuItem }

procedure TCustomMenuItem.OnMenuClick(Sender: TObject);
begin
  inherited OnClick;
end;

procedure TCustomMenuItem.OnMenuMouseEnter(Sender: TObject);
begin
  inherited OnMouseEnter;
  HandleElement.style.setProperty('background-color', '#ddd');
end;

procedure TCustomMenuItem.OnMenuMouseLeave(Sender: TObject);
begin
  inherited OnMouseLeave;
  HandleElement.style.setProperty('background-color', '#f1f1f1');
end;

procedure TCustomMenuItem.Click;
begin
  inherited Click;
  Parent.Visible := False;
end;

procedure TCustomMenuItem.Changed;
begin
  inherited Changed;
  HandleElement.InnerHTML := Self.Caption;
  HandleElement.style.setProperty('color', 'black');
  HandleElement.style.setProperty('padding', '6px 16px');
  HandleElement.style.setProperty('text-decoration', 'none');
end;

function TCustomMenuItem.CreateHandleElement: TJSHTMLElement;
begin
  Result := TJSHTMLElement(Document.CreateElement('a'));
end;

constructor TCustomMenuItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 200, 20);
  OnMouseEnter := @OnMenuMouseEnter;
  OnMouseLeave := @OnMenuMouseLeave;
  OnClick := @OnMenuClick;
end;

end.

