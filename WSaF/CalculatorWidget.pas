unit CalculatorWidget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, IniFiles, ExtCtrls, ShellAPI;

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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn0Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure btnclrClick(Sender: TObject);
    procedure btnundoClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
    procedure WMEXITSIZEMOVE(var message: TMessage); message WM_EXITSIZEMOVE;
  private
    { Private declarations }
  public
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
  end;

var
  CalcForm: TCalcForm;
  pathINI: string;
  sIniFile: TIniFile;

implementation

{$R *.dfm}

procedure TCalcForm.FormCreate(Sender: TObject);
begin
  pathINI := extractfilepath(application.ExeName) +
    '\WSaF\Settings\CalculatorSettings.ini';
end;

procedure TCalcForm.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    CalcForm.Top := sIniFile.ReadInteger('Position', 'Top', 0);
    CalcForm.Left := sIniFile.ReadInteger('Position', 'Left', 0);
  end;
end;

procedure TCalcForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  CalcForm.perform(WM_SysCommand, $F012, 0);
end;

procedure TCalcForm.btn0Click(Sender: TObject);
begin
  edt1.Text := edt1.Text + '1';
end;

procedure TCalcForm.btn2Click(Sender: TObject);
begin
  edt1.Text := edt1.Text + '2';
end;

procedure TCalcForm.btn3Click(Sender: TObject);
begin
  edt1.Text := edt1.Text + '3';
end;

procedure TCalcForm.btn4Click(Sender: TObject);
begin
  edt1.Text := edt1.Text + '4';
end;

procedure TCalcForm.btn5Click(Sender: TObject);
begin
  edt1.Text := edt1.Text + '5';
end;

procedure TCalcForm.btn6Click(Sender: TObject);
begin
  edt1.Text := edt1.Text + '6';
end;

procedure TCalcForm.btn7Click(Sender: TObject);
begin
  edt1.Text := edt1.Text + '7';
end;

procedure TCalcForm.btn8Click(Sender: TObject);
begin
  edt1.Text := edt1.Text + '8';
end;

procedure TCalcForm.btn9Click(Sender: TObject);
begin
  edt1.Text := edt1.Text + '9';
end;

procedure TCalcForm.btnclrClick(Sender: TObject);
begin
  edt1.Clear;
end;

procedure TCalcForm.btnundoClick(Sender: TObject);
begin
  edt1.Text := copy(edt1.Text, 1, length(edt1.Text) - 1);
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
  dir: string;
begin
  dir := extractfilepath(application.ExeName) +
    '\WSaF\Settings\CaclulatorSettings.ini';
  ans := PAnsiChar(dir);
  ShellExecute(Handle, 'open',
    'c:\windows\notepad.exe',
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
end.

