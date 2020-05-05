library Calculator;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

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
  try
    v := Obj.ClassParent;
    empty := false;
  except
    empty := true;
  end;
end;

procedure ShowCalc; stdcall;
var
  empty: boolean;
begin
  isEmpy(CalcForm, empty);
  if empty = true then
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
  end
  else CalcForm.Show;
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
    CalcForm.Close;
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
