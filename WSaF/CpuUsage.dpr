library CpuUsage;

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
  try
    v := Obj.ClassParent;
    empty := false;
  except
    empty := true;
  end;
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
  end;
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
 
