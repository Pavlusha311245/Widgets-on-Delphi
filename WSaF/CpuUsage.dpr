library CpuUsage;

uses
  SysUtils,
  IniFiles,
  Windows,
  Forms,
  Classes,
  Messages,
  CpuUsageWidget in 'CpuUsageWidget.pas' {CpuUsageForm},
  adCpuUsage in 'WSaF\adCpuUsage.pas';

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
  empty:=false
  else empty:=True;
end;

procedure ShowCpuUsage; stdcall;
var
  empty: boolean;
begin
  isEmpy(CpuUsageForm, empty);
  if empty = true then
  begin
    Application.CreateHandle;
    CpuUsageForm := TCpuUsageForm.Create(Application);
    CpuUsageForm.Show;
    if FileExists(pathINI) then
    begin
      sIniFile := TIniFile.Create(pathINI);
      sIniFile.WriteBool('State', 'Active', true);
      sIniFile.Free;
    end;
  end
  else CpuUsageForm.Show;
end;

procedure RefreshCpuUsage; stdcall;
var
  empty: boolean;
begin
  isEmpy(CpuUsageForm, empty);
  if empty = false then
    CpuUsageForm.Refresh;
end;

procedure CloseCpuUsage; stdcall;
var
  empty: Boolean;
begin
  isEmpy(CpuUsageForm, empty);
  if empty = false then
  begin
//    CpuUsageForm.Close;
    CpuUsageForm.Destroy;
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', False);
    sIniFile.Free;
  end;
end;

procedure FormPos(x, y: integer); stdcall;
var
  empty: Boolean;
begin
  isEmpy(CpuUsageForm, empty);
  if empty = false then
  begin
    CpuUsageForm.Top := x;
    CpuUsageForm.Left := y;
  end;
end;
exports ShowCpuUsage, RefreshCpuUsage, CloseCpuUsage, FormPos;
begin
end.
 
