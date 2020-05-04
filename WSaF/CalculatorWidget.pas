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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

end.

