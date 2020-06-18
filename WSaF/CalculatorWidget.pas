unit CalculatorWidget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, IniFiles, ExtCtrls, ShellAPI, acPNG;

type
  TCalcForm = class(TForm)
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    btn7: TButton;
    edt1: TEdit;
    btn8: TButton;
    btn9: TButton;
    btn0: TButton;
    btnplus: TButton;
    btnminus: TButton;
    btnmul: TButton;
    btndiv: TButton;
    PopupMenu: TPopupMenu;
    W1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    btnclr: TButton;
    btnundo: TButton;
    TimerShow: TTimer;
    btnrez: TButton;
    Background: TImage;
    N5: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnclrClick(Sender: TObject);
    procedure btnundoClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
    procedure WMEXITSIZEMOVE(var message: TMessage); message WM_EXITSIZEMOVE;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn1Click(Sender: TObject);
    procedure btnplusClick(Sender: TObject);
    procedure btnminusClick(Sender: TObject);
    procedure btnmulClick(Sender: TObject);
    procedure btndivClick(Sender: TObject);
    procedure btnrezClick(Sender: TObject);
    procedure BackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  public
    stek1: double;
    stek2: double;
    operand: byte;
    edit: boolean;
    procedure Calculator(codekey: word);
    procedure saveStek;
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
  end;

var
  CalcForm: TCalcForm;
  pathINI: string;
  sIniFile: TIniFile;

implementation

{$R *.dfm}

procedure TCalcForm.Calculator(codekey: word);
begin
  case codekey of
    8: { бакспейс }
      begin
        edt1.text := copy(edt1.text, 1, length(edt1.text) - 1);
        saveStek;
      end;
    13: { Ёнтер }
      begin
        saveStek;
        case operand of
          1: {+ } stek2 := stek1 + stek2;
          2: {- } stek2 := stek1 - stek2;
          3: {* } stek2 := stek1 * stek2;
          4: {/ } stek2 := stek1 / stek2;
          0: exit;
        end;
        edt1.text := FormatFloat('0.00', stek2);
        edit := false;
      end;
    109: {-}
      begin
        saveStek;
        stek1 := stek2;
        operand := 2;
        edit := false;
      end;
    107: {+}
      begin
        saveStek;
        stek1 := stek2;
        operand := 1;
        edit := false;
      end;
    106: {*}
      begin
        saveStek;
        stek1 := stek2;
        operand := 3;
        edit := false;
      end;
    111: {/}
      begin
        saveStek;
        stek1 := stek2;
        operand := 4;
        edit := false;
      end;
    27: {esc C}
      begin
        operand := 0;
        edt1.text := '0';
      end;
    901: { CE btn } edt1.text := copy(edt1.Text, 1, length(edt1.Text) - 1);
  end;
  if codekey in [48..57, 96..105] then
  begin
    if codekey < 96 then
      codekey := codekey - 48
    else
      codekey := codekey - 96;
    if (edt1.text = '0') or (not edit) then
    begin
      edt1.text := '';
      edit := true;
    end;
    edt1.text := edt1.text + inttostr(codekey);
  end;
end;

procedure TCalcForm.saveStek;
begin
  if (length(edt1.text) > 0) and (edt1.text[length(edt1.text)] = ',') then
    edt1.text := copy(edt1.text, 1, length(edt1.text) - 1);
  if not tryStrToFloat(edt1.text, stek2) then
  begin
    stek2 := 0;
    edt1.text := '0';
  end;
end;

procedure TCalcForm.FormCreate(Sender: TObject);
const
  ots = 3;
var
  i: integer;
  path, pathMainApp: string;
begin
  pathINI := extractfilepath(application.ExeName) +
    '\WSaF\Settings\CalculatorSettings.ini';
  pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
  if FileExists(pathMainApp) then
  begin
    sIniFile := TIniFile.Create(pathMainApp);
    path := ExtractFilePath(Application.ExeName) + '\Images\background_170_' +
      sIniFile.ReadString('Theme', 'Color1', '') + '_' +
      sIniFile.ReadString('Theme',
      'Color2', '') + '.png';
    Background.Picture.LoadFromFile(path);
  end;
  ;
  edit := true;
  for i := 0 to self.ComponentCount - 1 do
    if self.Components[i] is TButton then
      TButton(self.Components[i]).OnKeyDown := self.FormKeyDown;
end;

procedure TCalcForm.FormShow(Sender: TObject);
begin
  self.SetFocus;
  ShowWindow(Application.Handle, SW_HIDE);
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    CalcForm.Top := sIniFile.ReadInteger('Position', 'Top', 0);
    CalcForm.Left := sIniFile.ReadInteger('Position', 'Left', 0);
  end;
end;

procedure TCalcForm.btnclrClick(Sender: TObject);
begin
  Calculator(27);
end;

procedure TCalcForm.btnundoClick(Sender: TObject);
begin
  Calculator(901);
end;

procedure TCalcForm.N1Click(Sender: TObject);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', false);
  sIniFile.Free;
  CalcForm.Close;
end;

procedure TCalcForm.N3Click(Sender: TObject);
var
  ans: PAnsiChar;
  editor: PAnsiChar;
  dir: string;
  pathINIMainApp: string;
begin
  dir := extractfilepath(application.ExeName) +
    '\WSaF\Settings\CalculatorSettings.ini';
  ans := PAnsiChar(dir);
  pathINIMainApp := extractfilepath(application.ExeName) + '\Settings.ini';
  if FileExists(pathINIMainApp) then
  begin
    sIniFile := TIniFile.Create(pathINIMainApp);
    editor := PAnsiChar(sIniFile.readstring('Main', 'Editor', ''));
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  ShellExecute(Handle, 'open',
    editor,
    ans, nil,
    SW_SHOWNORMAL);
end;

procedure TCalcForm.TimerShowTimer(Sender: TObject);
begin
  if AlphaBlendValue <> 255 then
    AlphaBlendValue := AlphaBlendValue + 5
  else
    TimerShow.Enabled := false;
end;

procedure TCalcForm.WMEXITSIZEMOVE(var message: TMessage);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteInteger('Position', 'Top', CalcForm.top);
  sIniFile.WriteInteger('Position', 'Left', CalcForm.Left);
  sIniFile.Free;
end;

procedure TCalcForm.WMMoving(var Msg: TWMMoving);
var
  workArea: TRect;
begin
  workArea := Screen.WorkareaRect;
  with Msg.DragRect^ do
  begin
    if Left < workArea.Left then
      OffsetRect(Msg.DragRect^, workArea.Left - Left, 0);
    if Top < workArea.Top then
      OffsetRect(Msg.DragRect^, 0, workArea.Top - Top);
    if Right > workArea.Right then
      OffsetRect(Msg.DragRect^, workArea.Right - Right, 0);
    if Bottom > workArea.Bottom then
      OffsetRect(Msg.DragRect^, 0, workArea.Bottom - Bottom);
  end;
  inherited;
end;

procedure TCalcForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  self.Calculator(key);
end;

procedure TCalcForm.btn1Click(Sender: TObject);
begin
  Calculator(strtoint(TButton(Sender).caption) + 48);
end;

procedure TCalcForm.btnplusClick(Sender: TObject);
begin
  Calculator(107);
end;

procedure TCalcForm.btnminusClick(Sender: TObject);
begin
  Calculator(109);
end;

procedure TCalcForm.btnmulClick(Sender: TObject);
begin
  Calculator(106);
end;

procedure TCalcForm.btndivClick(Sender: TObject);
begin
  Calculator(111);
end;

procedure TCalcForm.btnrezClick(Sender: TObject);
begin
  Calculator(13);
end;

procedure TCalcForm.BackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  CalcForm.perform(WM_SysCommand, $F012, 0);
end;

procedure TCalcForm.N5Click(Sender: TObject);
begin
  if N5.Checked = True then
  begin
    N5.Checked := False;
    CalcForm.FormStyle := fsNormal;
  end
  else
  begin
    n5.Checked := True;
    CalcForm.FormStyle := fsStayOnTop;
  end;
end;

end.

