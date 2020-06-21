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

procedure FormPos(x, y: integer; center: Boolean); stdcall;
var
  empty: Boolean;
  modx, mody: integer;
begin
  isEmpy(DateAndTimeForm, empty);
  if empty = false then
  begin
    if center = true then
    begin
      dateandtimeform.top := Round((screen.height / 2) -
        (dateandtimeform.clientheight / 2));
      dateandtimeform.left := Round((screen.width / 2) -
        (dateandtimeform.clientwidth / 2));
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', Round((screen.width / 2) -
        (dateandtimeform.clientwidth / 2)));
      sinifile.writeinteger('Position', 'Top', Round((screen.height / 2) -
        (dateandtimeform.clientheight / 2)));
      sIniFile.Free;
    end
    else
    begin
      modx := Screen.width - dateandtimeform.width;
      mody := screen.height - dateandtimeform.height;
      if x < modx then
        dateandtimeform.left := x
      else
        dateandtimeform.left := modx;
      if y < mody then
        dateandtimeform.top := y
      else
        dateandtimeform.top := mody;
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', DateAndTimeForm.Left);
      sinifile.writeinteger('Position', 'Top', DateAndTimeForm.Top);
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
  isEmpy(DateAndTimeForm, empty);
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
          x := screen.width - dateandtimeform.clientwidth;
          y := 0
        end;
      2:
        begin
          x := 0;
          y := screen.height - dateandtimeform.clientheight;
        end;
      3:
        begin
          x := screen.width - dateandtimeform.clientwidth;
          y := screen.height - dateandtimeform.clientheight;
        end;
      4:
        begin
          y := Round((screen.height / 2) -
            (dateandtimeform.clientheight / 2));
          x := Round((screen.width / 2) -
            (dateandtimeform.clientwidth / 2));
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
              dateandtimeform.clientwidth) then
              left_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              dateandtimeform.clientheight) and
              (sinifile.readinteger('Position', 'Left', 0) <> 0) then
              right_top := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              dateandtimeform.clientheight) and
              (sinifile.readinteger('Position', 'Left', 0) <> screen.width -
              dateandtimeform.clientwidth) then
              right_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <>
              Round((screen.height / 2) - (dateandtimeform.clientheight / 2)))
              and
              (sinifile.readinteger('Position', 'Left', 0) <> Round((screen.width
              / 2) - (dateandtimeform.clientwidth / 2))) then
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
exports ShowDateAndTime, RefreshDateAndTime, CloseDateAndTime, FormPos,
  FormCoord;
begin
end.

