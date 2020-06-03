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
begin
  if Obj <> nil then
    empty := false
  else
    empty := True;
end;

procedure ShowCpuUsage; stdcall;
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
end;

procedure RefreshCpuUsage; stdcall;
begin
  CpuUsageForm.close;
  cpuusageform.show;
end;

procedure CloseCpuUsage; stdcall;
begin
  CpuUsageForm.Destroy;
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', False);
  sIniFile.Free;
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
 
