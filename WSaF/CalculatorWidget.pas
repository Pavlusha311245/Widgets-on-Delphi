unit CalculatorWidget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, IniFiles;

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
  private
    { Private declarations }
  public
    { Public declarations }
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
    '\Settings\Calculator.ini';
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
  edt1.Text:=copy(edt1.Text,1,length(edt1.Text)-1);
end;

end.

