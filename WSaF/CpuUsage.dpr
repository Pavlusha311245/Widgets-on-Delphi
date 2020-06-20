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
        sIniFile.ReadString('Theme', 'Color2', '') + '.png';
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
      if x = 0 then
        CpuUsageForm.Left := x
      else
        CpuUsageForm.Left := x - CpuUsageForm.clientwidth;
      if y = 0 then
        CpuUsageForm.Top := y
      else
        CpuUsageForm.Top := y - CpuUsageForm.clientheight;
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', CpuUsageForm.Left);
      sinifile.writeinteger('Position', 'Top', CpuUsageForm.Top);
      sIniFile.Free;
    end;
  end;
end;

procedure FormCoord(pos: integer; var x, y: integer; var userpos: Boolean);
  stdcall;
var
  empty: boolean;
  left_top, right_top, left_bot, right_bot, centered: Boolean;
begin
  isEmpy(CpuUsageForm, empty);
  if empty = false then
  begin
    left_top := true;
    right_top := True;
    left_bot := true;
    right_bot := true;
    centered := true;
    case pos of
      0:
        begin
          x := 0;
          y := 0;
        end;
      1:
        begin
          x := screen.width - CpuUsageForm.clientwidth;
          y := 0
        end;
      2:
        begin
          x := 0;
          y := screen.height - CpuUsageForm.clientheight;
        end;
      3:
        begin
          x := screen.width - CpuUsageForm.clientwidth;
          y := screen.height - CpuUsageForm.clientheight;
        end;
      4:
        begin
          y := Round((screen.height / 2) -
            (CpuUsageForm.clientheight / 2));
          x := Round((screen.width / 2) -
            (CpuUsageForm.clientwidth / 2));
        end;
      5:
        begin
          if fileexists(pathINI) then
          begin
            sinifile := tinifile.create(pathINI);
            if (sinifile.readinteger('Position', 'Top', 0) <> 0) and
              (sinifile.readinteger('Position', 'Left', 0) <> 0) then
              left_top := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> 0) and
              (sinifile.readinteger('Position', 'Left', 0) <> screen.width -
              CpuUsageForm.clientwidth) then
              left_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              CpuUsageForm.clientheight) and
              (sinifile.readinteger('Position', 'Left', 0) <> 0) then
              right_top := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              CpuUsageForm.clientheight) and
              (sinifile.readinteger('Position', 'Left', 0) <> screen.width -
              CpuUsageForm.clientwidth) then
              right_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <>
              Round((screen.height / 2) - (CpuUsageForm.clientheight / 2)))
              and
              (sinifile.readinteger('Position', 'Left', 0) <> Round((screen.width
              / 2) - (CpuUsageForm.clientwidth / 2))) then
              centered := false;
            if (left_top = false) and (left_bot = False) and (right_top =
              false) and
              (right_bot = false) and (centered = false) then
              userpos := true;
          end;
        end;
    end;
  end;
end;

exports
  ShowCpuUsage,
  RefreshCpuUsage,
  CloseCpuUsage,
  FormPos,
  FormCoord;

begin
end.

