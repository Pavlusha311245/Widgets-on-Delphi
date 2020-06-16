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
  empty: Boolean;
begin
  isEmpy(CpuUsageForm, empty);
  if empty = false then
  begin
    pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
    if FileExists(pathMainApp) then
    begin
      sIniFile := TIniFile.Create(pathMainApp);
      path := ExtractFilePath(Application.ExeName) + '\Images\background_120_' +
        sIniFile.ReadString('Theme', 'Color1', '') + '_' +
        sIniFile.ReadString('Theme',
        'Color2', '') + '.png';
      if (sinifile.readstring('Theme', 'Color1', '') = 'white') or
        (sinifile.readstring('Theme', 'Color2', '') = 'white') then
      begin
        cpuusageform.labelCPU.font.color := 0;
        cpuusageform.LabelPercentCpuUsage.font.color := 0;
      end
      else
      begin
        cpuusageform.labelCPU.font.color := 16777215;
        cpuusageform.LabelPercentCpuUsage.font.color := 16777215;
      end;
      CpuUsageForm.CpuUsagebackground.Picture.LoadFromFile(path);
    end;
  end;
end;

procedure CloseCpuUsage; stdcall;
begin
  CpuUsageForm.Destroy;
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', False);
  sIniFile.Free;
end;

procedure FormPos(x, y: integer; center: boolean); stdcall;
var
  empty: Boolean;
begin
  isEmpy(CpuUsageForm, empty);
  if empty = false then
  begin
    if center = true then
    begin
      CpuUsageForm.top := Round((screen.Height / 2) - (CpuUsageForm.clientheight
        / 2));
      CpuUsageForm.Left := Round((screen.Width / 2) - (CpuUsageForm.ClientWidth
        / 2));
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', Round((screen.Width / 2) -
        (CpuUsageForm.ClientWidth / 2)));
      sinifile.writeinteger('Position', 'Top', Round((screen.Height / 2) -
        (CpuUsageForm.clientheight / 2)));
      sIniFile.Free;
    end
    else
    begin
      CpuUsageForm.Left := x;
      CpuUsageForm.Top := y;
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', x);
      sinifile.writeinteger('Position', 'Top', y);
      sIniFile.Free;
    end;
  end;
end;
exports ShowCpuUsage, RefreshCpuUsage, CloseCpuUsage, FormPos;
begin
end.

