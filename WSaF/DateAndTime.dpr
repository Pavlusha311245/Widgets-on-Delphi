library DateAndTime;
uses
  SysUtils,
  Windows,
  Forms,
  IniFiles,
  Classes,
  DateAndTimeWidget in 'DateAndTimeWidget.pas' {DateAndTimeForm};

{$R *.res}

procedure isEmpy(Obj: TObject; var empty: boolean);
begin
  if Obj <> nil then
    empty := false
  else
    empty := True;
end;

procedure ShowDateAndTime; stdcall;
begin
  Application.CreateHandle;
  DateAndTimeForm := TDateAndTimeForm.Create(Application);
  DateAndTimeForm.Show;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', true);
    sIniFile.Free;
  end;
end;

procedure RefreshDateAndTime; stdcall;
var
  path, pathmainApp: string;
  empty: Boolean;
begin
  isEmpy(DateAndTimeForm, empty);
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
      if (sIniFile.ReadString('Theme', 'Color1', '') = 'white') or
        (sIniFile.ReadString('Theme', 'Color2', '') = 'white') then
      begin
        DateAndTimeForm.Date.Font.Color := 0;
        DateAndTimeForm.Time.Font.Color := 0;
      end
      else
      begin
        DateAndTimeForm.Date.Font.Color := 16777215;
        DateAndTimeForm.Time.Font.Color := 16777215;
      end;
      DateAndTimeForm.DateAndTimeBackground.Picture.LoadFromFile(path);
    end;
  end;
end;

procedure CloseDateAndTime; stdcall;
begin
  DateAndTimeForm.Destroy;
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', False);
  sIniFile.Free;
end;

procedure FormPos(x, y: integer); stdcall;
var
  empty: Boolean;
begin
  isEmpy(DateAndTimeForm, empty);
  if empty = false then
  begin
    DateAndTimeForm.Top := x;
    DateAndTimeForm.Left := y;
  end;
end;
exports ShowDateAndTime, RefreshDateAndTime, CloseDateAndTime, FormPos;
begin
end.

