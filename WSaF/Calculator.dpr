library Calculator;

uses
  SysUtils,
  Classes,
  Forms,
  Windows,
  IniFiles,
  CalculatorWidget in 'CalculatorWidget.pas' {CalcForm};

{$R *.res}

procedure isEmpy(Obj: TObject; var empty: boolean);
var
  v: TClass;
begin
  //  try
  //    v := Obj.ClassParent;
  //    empty := false;
  //  except
  //    empty := true;
  //  end;
  if Obj <> nil then
    empty := false
  else
    empty := True;
end;

procedure ShowCalc; stdcall;
begin
  Application.CreateHandle;
  CalcForm := TCalcForm.Create(Application);
  CalcForm.Show;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', true);
    sIniFile.Free;
  end;
end;

procedure RefreshCalc; stdcall;
var
  empty: boolean;
begin
  isEmpy(CalcForm, empty);
  if empty = false then
    CalcForm.Refresh;
end;

procedure CloseCalc; stdcall;
var
  empty: Boolean;
begin
  isEmpy(CalcForm, empty);
  if empty = false then
  begin
    CalcForm.Destroy;
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', False);
    sIniFile.Free;
  end;
end;

procedure FormPos(x, y: integer); stdcall;
var
  empty: Boolean;
begin
  isEmpy(CalcForm, empty);
  if empty = false then
  begin
    CalcForm.Top := x;
    CalcForm.Left := y;
  end;
end;
exports ShowCalc, RefreshCalc, CloseCalc, FormPos;
begin
end.

