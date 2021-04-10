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
unit Dialogs;

{$I pas2js_widget.inc}

interface

uses
  Classes,
  SysUtils,
  Types,
  Graphics,
  Controls,
  StdCtrls,
  ExtCtrls,
  Forms,
  WebCtrls;

type
  TMsgDlgType = (mtWarning, mtError, mtInformation, mtConfirmation, mtCustom);
  TMsgDlgBtn = (mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore, mbAll, mbNoToAll, mbYesToAll, mbHelp, mbClose);
  TMsgDlgButtons = set of TMsgDlgBtn;

const
  mbYesNoCancel = [mbYes, mbNo, mbCancel];
  mbYesNo = [mbYes, mbNo];
  mbOKCancel = [mbOK, mbCancel];
  mbAbortRetryIgnore = [mbAbort, mbRetry, mbIgnore];

procedure MessageDlg(AOwner: TCustomForm; const ACaption, AMessage: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons; ADefaultButton: TMsgDlgBtn; AModalResultProc: TModalResultProc); overload;
procedure MessageDlg(AOwner: TCustomForm; const AMessage: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons; ADefaultButton: TMsgDlgBtn; AModalResultProc: TModalResultProc); overload;
procedure MessageDlg(AOwner: TCustomForm; const ACaption, AMessage: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons; AModalResultProc: TModalResultProc); overload;
procedure MessageDlg(AOwner: TCustomForm; const AMessage: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons; AModalResultProc: TModalResultProc); overload;

procedure ShowMessage(AOwner: TCustomForm; const AMessage: string); overload;
procedure ShowMessage(const AMessage: string); overload;   
procedure ShowMessageFmt(const AMessage: string; const AArguments: array of JSValue); overload;

procedure QuestionDlg(const ACaption, AMessage: string; AModalResultProc: TModalResultProc); overload;   
procedure QuestionDlg(const AMessage: string; AModalResultProc: TModalResultProc); overload;

implementation

const
  {$ifdef lang_en}
  DialogCaption: array[TMsgDlgType] of string = (
    'Warning',
    'Error',
    'Information',
    'Confirmation',
    ''
    );
  ButtonCaption: array[TMsgDlgBtn] of string = (
    'Yes',
    'No',
    'Ok',
    'Cancel',
    'Abort',
    'Retry',
    'Ignore',
    'All',
    'No to All',
    'Yes to All',
    'Help',
    'Close');
  {$endif}
  {$ifdef lang_pt}
  DialogCaption: array[TMsgDlgType] of string = (
    'Atenção',
    'Erro',
    'Informação',
    'Confirmação',
    ''
    );
  ButtonCaption: array[TMsgDlgBtn] of string = (
    'Sim',
    'Não',
    'Ok',
    'Cancelar',
    'Abortar',
    'Retentar',
    'Ignorar',
    'Todos',
    'Não para todos',
    'Sim para todos',
    'Ajuda',
    'Fechar');
  {$endif}
  DialogIcon: array[TMsgDlgType] of string = (
    'data:image/png;base64,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',
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAMV0lEQVR42uxaBXQbxxbdz2QHZDnM5drl1iSOLTRzmJmZmZmZ+fMPlRvGsimKJGMSRSaRUaE30p9X+FBJIe+U95x7zpyZt3PfvQtvdiTu5+Png+0xh+N+O4Xjnpz561/LNgkEg3a2bLl6d5s2BymO7GnT5j0EtrFvR8uWqzAGY2dw3BNbOe43P1TRAVSEaEeLFksOduhw8kRUVGFOaurt/AEDiGXKFGJdsIA4V64kNevXI7CNfV+MYUw2jf0gKqrgQPv2J7Y3b754zq9/HYVzfu+F0yvdYYNQOPFQp05nP9LpHDfGjCHVq1aRmsWLSdXkyaRq5Ehw9u8Pju7dwZ6ZCfa0tC+AbezDMYzBWDynhp6Lc1ymc+GcGwWCCdM5rv33Tji9XTuuFwrnHH3hhWxT//6kevlyUj1rFnEOGgS29HSwpaQ8FvBc5+DBgHPhnKZ+/cixl17Sbw4OXjCHmv2dC5/EcYFrGjcefDg0NLdw0CBSs2wZcYweTWwZGWBNTuYVOKcD7yjKUTBwIDkSEpKztnHjQZjDd/Wch+5p2+5Ydkqqy7FoEXGOHAXW1DSwJiUzBXIgl5Nyfp6U7NrTtu3RmRwX8m0K//XygIAuR0ND9ZYJE4hz6lRipc9wZVLStwrkRO6b48eToyEhV1YGBGRibkzFr+O4361t2nTqObnCZp8zl9jo81mRmPSdAnPAXM7KZFaa25SRNEcm4idw3J/WBwUt+lijrXbOmUMqu3SFioTE7wWsXbuBY/Ycclmlrt0sFC7FXHm/8huCgpZ8npDockyfQSroc1gen/C9QkVaOjhmzCSfxse7aK6L8E7g7ZnH2/4jtbrGPnU6KU9KgbK4hAahvE9fcF246CYulwfhunzZXTF4SIPnxdzs06aTSzGqGnwc/sZxv2qwAfjCOyuRWHHi8pRUShTfMPTuA6SmxvPNg9TWenCsofNjjrap08gZkbhySUBARoNL3eHnnsurmDiJlNFbrDQ2rkG4qYuF+vMX3B4/R925c26MaShPeXoGYM40dz3V8PxjL3J2t259rGTQEFLeqw9YdHENxnW1Fkh9vcffQerqPRjDBxfmXDxwMNnVqtWRx/qOWBnQePAnak19xdDhxKKNBT5wTaUB9927/g24c8eDMXzxVQwbQT5WqepXBQb2f+S1/T+efjqnbOxYYqG19qZWxwtKlCq453T6NeCuze7BGL74LLREltPl89+feirrkT6iNgiC5l9JSyelPXqBWaPjDcVKNdw2m/0acPv6dQ/G8MlZ1rM3XElJI+sFgjkP++Lr8M+nnskrGzGKmOltZFZreUNxjApcRqPfl6DLYHBjDJ+cX5gwYiTBO/qh7oJ1TZtOzIlPJJZu3eGGSsMriqKVUHP5sl8DqunaoJjG8M2LWrLjE8i6Jk3G37/m0yXk/rZtz94cPJTc0MTCdaWGV6A4+9Fjfg2wHTniRpP45kUtqIluv52+b0WYR7exzkRE2Cy9+tAT1bwDDajYuZP4M6Bi+w6CMSy4UdOZ8Agb3aqL9GvApqDgJYakVLiRmALXYtS8o6izEixLlvo1wLJoMSmmMSy4b1BdV5NSYHNQ0AKf4nEHdneLVifMffpDCT2hJFrFO4pQ3PgJfg24NnYcwRiM5R30UbhJte1q2eoDn7vNuHV9/PmQfHP3noBXgQWKFDFQ2KM3+DOgqEcvjGHGb+7eC44/F2LCLXcvA3Av/kKU+Nb15HQoViiZoEgeAyalxrcBbrcHxzCGFT9qOx8pctFtdqmXAWvo0vfTaCUpiU3Aq8AEhRQGqRzuOhzeq0C73WOUKjCGGX9JXCJ8qoghqwIb9/d+AQqDV+tj46BIpYVCeTQzGCVyqNPrvUph3RW9G8dYcqM2vS4ONgqEK7wM2C5sdig/MRWKOqugUBbNDEaxHBwnTnoZYH//AzSAKTdqMyWkwBZhswNeBmwTNjtaSEtFAXWqQNqZGQzUgLJ9B7wMKNuzz41jLLm/0EZL/FZhs8O+DPigKDkV8mWdIV+qYAaDWAbmpcu9SqGZrg9wjCU3akON24Kbve/bAHp75EsUTGGkIgtHj/MyoGj0WGISy9nyS6kBCcm+DdgqFB7N1yWAiQZhIqxgFMnAmNnVqxQaM7rgGFPuL7RRjVuCfDwCWwTCQ3qlFozUKUyEFQwUuZQD6/5/DtrGPhxjyY3aqEZqgPCAdxkUCFdn4UJFGg3GKBkzGChyw8Vwx2r7j/47lZUe7MMxltwmWQxk02qwsYlghY89wIDBl8OjiEmhpIlIWYIaIILa3Nz/3AI1OTlu7GPNi9ouUY0+9whncpzs9Euvuoy0Vl6NlDAFirW+8+5/DLDRNvax5kVtp6hGqlXi82PocKenjCalDq5GSJgiN0wElh27/mMAtrGPNS9q+2fHJw1Uayefn8PbaSk0qnSgp8H6cDEz5IRFQcm8hf8phdjGPpacqMmg1MK2oOD3B/n789XGxk0XfxwphatiBejDxMyQ94YIPn45DM6FvoLANvYx5URNqG1dE8F8zt9Bnw3RO8+GVhoUKnqSiBnyKLJfj4Cs174AtrGPKSdqevuZ561zfvObiPtuim4Pbn5GT4PzwvFKRf0ogFpQ0w5h81MP/JlsTWDgxHOvhoFe3BlyX4/6UQC1nH017N7qPwWOe6j/+h1o3TZXL1d+OcFrkbzDoE2EqpOn3UB/DEVUnT7rNqVkMuFCDajlQKs2WfTqt+Me5lgb0Gj2+dfCIC9KBjmvRfAKvTYe7lVVe+0I3auu9uAY33yo4dwrrxPU9Cj/C+iwt2WbrFxpDGRTB7NfjeAFWa+Eg+PEKb8/jDjeP+HGGL74MPccaTT8u1izgG0cicLwLAXsctUrLucaZidl5qorOGYGwTEzMzOz4HiZmTfkZlF0wmPG5R239/7WkY5h4mhH+iRr4L3/PT9PwPNGRZV6Pe7+/2mPWKSLVjk9e3c2tfPtEGUAqj/C+d69o3/X+C97RzHHKH/QvoJieMginSd04Pm5otIF8QhVAH2OpgPRrEn6lH9MwJGffxnFHCN8QTO0P19UOvdh0VNjOIH5Vnn1jnRDO5VvPR/2R7Mi4VX4N/g/8G/a1/SbAHOy9ZMONXBofrOiZrd+REa83W+ynjxvhu2rdGM7V/UyFoQSEOapwTn88F9sgofp4ESsoxtzsvIBjWkq/bkzZn95v8l0PMu24ajZw1b52kU2x/fbG9vGnfgUIVIU3DZ3gG+j/+a+WrZi5AidDANfLV0+srW1g8doDHNE7asofdK4eHbtj49Y5eugnRnRcOiQvkTct8zu3pdu7OApf5SEKkLEPZQEZ4BvqPXwNTYnwDX6MCZsF5qgbSlpfJS0UumbDD8q+5iUf+9Cm/2HYSoxOEySYBES7hCPOYO/BX3C9qAFmhbZ7D89IeffT8FLLAdtYi8l4QGLdNNc2hPUpk6uhpt40h0+qkBDirTMnT77ywct8o1zxoOfaHjwxGTC5KMk3GoynfZqecWObfQjY7ixAx9vuIN/jSuoZcXf2IVP+N5KGl4rr9xzs8lyejlpg0ZoNTIJE4hJxBTCTFiJvPMZiz5ZULxkqcOzT23r5ikSEqcNLO4O8rgroOUC2IYP+ILPxXb3XtKw6BzGItCkazPrWqF5Qs4SQBQ0MFZ9s9l82ctlFTvXBBRtuL2Pp6LNJDSkxZ0BQ4FNNdoy5mONX9FeKivfeYvZfGkTY1XQIpYAgUeAsBBSJglESR9Vw01m+bEXysp3rfGHj6gdfZra1KUlgvVajMo45vALgbWwAVuwucoXosArPrrdKj/ZP37XS34TPDRZxB4B8STIRCFRTkxvZqz9KrP10ccLS1IfzKr9YWOkQVO7B0h8r5ZqaNUSSoMWD0S0mCekbaOS3ub0j0PX6MMY5mAu1mDtBqVee39m7Q+Pks0rzdZH6skHfMGn7lsWCN7QRFh/k4RpxLGVjCm0G59znSS/8UBBUeqN6mmfLLJ7Dq2i0t1c36rF23rGgkv3DgFcj/VtoTHMWWh3H3qtauonDxYUJa+X5NcGyRZswjZ8/CZ4q/GBi+0NmWQUEccQNcQswkG3JtjA2NAQYxdebLI8cKNVfucOuWDVPXn5m+6VC5IA1+i7gcYuMpnux1yswVrY0G3V6LaLMkGLP+u5TchkXWABUUqU6+Kn6YHYCLse2G+x62Oz9Lk1+tpS3ZYFtnMfcG4Sk3lsMp8i8m82UYBr+Te7uF7OuQ/0V0d+0gAdXWmtAAAAAElFTkSuQmCC',
    'data:image/png;base64,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',
    'data:image/png;base64,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',
    'data:image/png;base64,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');
  ButtonModalResult: array[TMsgDlgBtn] of TModalResult = (
    mrYes,
    mrNo,
    mrOk,
    mrCancel,
    mrAbort,
    mrRetry,
    mrIgnore,
    mrAll,
    mrNoToAll,
    mrYesToAll,
    mrNone,
    mrClose);

type

  { TMessageDialog }

  TMessageDialog = class(TWForm)
  private
    const
      CControlsSpacing = 2;
      CMinDialogHeight = 200;
      CMinDialogWidth = 300;
      CMinButtonHeight = 25;
      CMinButtonWidth = 100;
      CMinImageHeight = 70;
      CMinImageWidth = 70;
  private
    FButtons: TMsgDlgButtons;
    FDefaultButton: TMsgDlgBtn;
    FDialogType: TMsgDlgType;
    FMessage: string;
  protected
    FButtonPanel: TWPanel;
    FInfoImage: TWImage;
    FMessageText: TWLabel;
  protected
    procedure PrepareButtons; virtual;
    procedure PrepareImage; virtual;
    procedure PrepareText; virtual;
    procedure PrepareTitle; virtual;
    procedure PrepareLayout; virtual;
  protected
    procedure KeyDown(var Key: NativeInt; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Buttons: TMsgDlgButtons read FButtons write FButtons;
    property DefaultButton: TMsgDlgBtn read FDefaultButton write FDefaultButton;
    property DialogType: TMsgDlgType read FDialogType write FDialogType;
    property Message: string read FMessage write FMessage;
  end;

{ TMessageDialog }

procedure TMessageDialog.PrepareButtons;
var
  VMsgDlgBtn: TMsgDlgBtn;
  VButton: TWButton;
  VButtonCount: NativeInt;
  VButtonHeight: NativeInt;
  VButtonWidth: NativeInt;
  VFormWidth: NativeInt;
  VSize: TSize;
  buttonofs: NativeInt;
begin
  VButtonCount := 0;
  buttonofs := 0;
  VButtonHeight := CMinButtonHeight;
  VButtonWidth := CMinButtonWidth;
  BeginUpdate;
  try
    /// Calculate the average of the buttons
    for VMsgDlgBtn := Low(TMsgDlgButtons) to High(TMsgDlgButtons) do
    begin
      if VMsgDlgBtn in FButtons then
      begin
        Inc(VButtonCount);
        VSize := JSMeasureText(ButtonCaption[VMsgDlgBtn], Font.Name, Font.Size);
        if (VSize.Cy > VButtonHeight) then
        begin
          VButtonHeight := VSize.Cy;
        end;
        if (VSize.Cx > VButtonWidth) then
        begin
          VButtonWidth := VSize.Cx;
        end;
      end;
    end;
    /// Create buttons
    for VMsgDlgBtn := Low(TMsgDlgButtons) to High(TMsgDlgButtons) do
    begin
      if VMsgDlgBtn in FButtons then
      begin
        VButton := TWButton.Create(FButtonPanel);
        VButton.BeginUpdate;
        try
          VButton.Parent := FButtonPanel;
          VButton.BorderSpacing.Around := CControlsSpacing;
          VButton.SetBounds(buttonofs, 0, VButtonWidth, VButtonHeight);
          VButton.ModalResult := ButtonModalResult[VMsgDlgBtn];
          VButton.Caption := ButtonCaption[VMsgDlgBtn];
          VButton.Align := alRight;
        finally
          VButton.EndUpdate;
        end;
        /// Default button
        if (VMsgDlgBtn = FDefaultButton) then
        begin
          ActiveControl := VButton;
        end;
      end;
      buttonofs := buttonofs + VButtonWidth;
    end;
    /// Calculate panel button width
    FButtonPanel.Height := VButtonHeight + (CControlsSpacing * 2);
    /// Calculate form width
    VFormWidth := ((VButtonWidth + (CControlsSpacing * 2)) * VButtonCount) + (CControlsSpacing * 2);
    if (VFormWidth < CMinDialogWidth) then
    begin
      VFormWidth := CMinDialogWidth;
    end;
    Self.Width := VFormWidth;
  finally
    EndUpdate;
  end;
end;

procedure TMessageDialog.PrepareImage;
begin
  FInfoImage.URL := DialogIcon[FDialogType];
end;

procedure TMessageDialog.PrepareText;
begin
  FMessageText.Caption := FMessage;
end;

procedure TMessageDialog.PrepareTitle;
begin
  Caption := IfThen((Caption <> ''), Caption, DialogCaption[FDialogType]);
end;

procedure TMessageDialog.PrepareLayout;
begin
  PrepareTitle;
  PrepareText;
  PrepareImage;
  PrepareButtons;
end;

procedure TMessageDialog.KeyDown(var Key: NativeInt; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  case Key of
    27: /// Esc cancels the dialog
    begin
      ModalResult := mrCancel;
      Close;
    end;
  end;
end;

constructor TMessageDialog.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner, 1);
  BeginUpdate;
  try
    KeyPreview := True;
    SetBounds(0, 0, CMinDialogWidth, CMinDialogHeight);
    FButtonPanel := TWPanel.Create(Self);
    FButtonPanel.BeginUpdate;
    try
      FButtonPanel.Parent := Self;
      FButtonPanel.BorderSpacing.Around := CControlsSpacing;
      FButtonPanel.BevelOuter := bvNone;
      FButtonPanel.SetBounds(0, 0, CMinDialogWidth, CMinButtonHeight);
      FButtonPanel.Align := alBottom;
    finally
      FButtonPanel.EndUpdate;
    end;
    FInfoImage := TWImage.Create(Self);
    FInfoImage.BeginUpdate;
    try
      FInfoImage.Parent := Self;
      FInfoImage.BorderSpacing.Around := CControlsSpacing;
      FInfoImage.SetBounds(0, 0, CMinImageWidth, CMinImageHeight);
      FInfoImage.Center := True;
      FInfoImage.Align := alLeft;
    finally
      FInfoImage.EndUpdate;
    end;
    FMessageText := TWLabel.Create(Self);
    FMessageText.BeginUpdate;
    try
      FMessageText.Parent := Self;
      FMessageText.BorderSpacing.Around := CControlsSpacing;
      FMessageText.WordWrap := True;
      FMessageText.Align := alClient;
    finally
      FMessageText.EndUpdate;
    end;
  finally
    EndUpdate;
  end;
end;


function ModalDefaultButton(const AButtons: TMsgDlgButtons): TMsgDlgbtn;
begin
  if (mbYes in AButtons) then
  begin
    Result := mbYes;
  end
  else
  if (mbOK in AButtons) then
  begin
    Result := mbOK;
  end
  else
  if (mbYesToAll in AButtons) then
  begin
    Result := mbYesToAll;
  end
  else
  if (mbAll in AButtons) then
  begin
    Result := mbAll;
  end
  else
  if (mbRetry in AButtons) then
  begin
    Result := mbRetry;
  end
  else
  if (mbHelp in AButtons) then
  begin
    Result := mbHelp;
  end
  else
  if (mbCancel in AButtons) then
  begin
    Result := mbCancel;
  end
  else
  if (mbNo in AButtons) then
  begin
    Result := mbNo;
  end
  else
  if (mbNoToAll in AButtons) then
  begin
    Result := mbNoToAll;
  end
  else
  if (mbAbort in AButtons) then
  begin
    Result := mbAbort;
  end
  else
  if (mbIgnore in AButtons) then
  begin
    Result := mbIgnore;
  end
  else
  if (mbClose in AButtons) then
  begin
    Result := mbClose;
  end
  else
  begin
    Result := mbOK;
  end;
end;

procedure MessageDlg(AOwner: TCustomForm; const ACaption, AMessage: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons; ADefaultButton: TMsgDlgBtn; AModalResultProc: TModalResultProc);
var
  VMessageDialog: TMessageDialog;
begin
  if not Assigned(AOwner) then
    AOwner := Application.ActiveForm;
  VMessageDialog := TMessageDialog.Create(AOwner);
  with VMessageDialog do
  begin
    Buttons := AButtons;
    Caption := ACaption;
    DefaultButton := ADefaultButton;
    DialogType := ADlgType;
    Message := AMessage;
    PrepareLayout;
    ShowModal(AModalResultProc);
  end;
end;

procedure MessageDlg(AOwner: TCustomForm; const AMessage: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons; ADefaultButton: TMsgDlgBtn; AModalResultProc: TModalResultProc);
begin
  MessageDlg(AOwner, '', AMessage, ADlgType, AButtons, ADefaultButton, AModalResultProc);
end;

procedure MessageDlg(AOwner: TCustomForm; const ACaption, AMessage: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons; AModalResultProc: TModalResultProc);
begin
  MessageDlg(AOwner, ACaption, AMessage, ADlgType, AButtons, ModalDefaultButton(AButtons), AModalResultProc);
end;

procedure MessageDlg(AOwner: TCustomForm; const AMessage: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons; AModalResultProc: TModalResultProc);
begin
  MessageDlg(AOwner, '', AMessage, ADlgType, AButtons, ModalDefaultButton(AButtons), AModalResultProc);
end;

procedure ShowMessage(AOwner: TCustomForm; const AMessage: string);
begin
  MessageDlg(AOwner, '', AMessage, mtInformation, [mbOK], nil);
end;

procedure ShowMessage(const AMessage: string);
begin
  MessageDlg(Application.ActiveForm, '', AMessage, mtInformation, [mbOK], nil);
end;

procedure ShowMessageFmt(const AMessage: string; const AArguments: array of JSValue);
begin
  ShowMessage(Format(AMessage, AArguments));
end;

procedure QuestionDlg(const ACaption, AMessage: string; AModalResultProc: TModalResultProc);
begin
  MessageDlg(Application.ActiveForm, ACaption, AMessage, mtConfirmation, mbYesNo, AModalResultProc);
end;

procedure QuestionDlg(const AMessage: string; AModalResultProc: TModalResultProc);
begin
  QuestionDlg('', AMessage, AModalResultProc);
end;


end.
