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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CalcForm: TCalcForm;

implementation

{$R *.dfm}

end.
