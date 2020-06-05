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
var
  pathMainApp, path: string;
begin
  pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
  if FileExists(pathMainApp) then
  begin
    sIniFile := TIniFile.Create(pathMainApp);
    path := ExtractFilePath(Application.ExeName) + '\Images\background_120_' +
      sIniFile.ReadString('Theme', 'Color1', '') + '_' +
      sIniFile.ReadString('Theme',
      'Color2', '') + '.png';
    CpuUsageForm.CpuUsagebackground.Picture.LoadFromFile(path);
  end;
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
 
