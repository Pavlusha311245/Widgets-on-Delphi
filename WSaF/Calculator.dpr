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
begin
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
  path, pathMainApp: string;
  empty: Boolean;
begin
  isEmpy(CalcForm, empty);
  if empty = false then
  begin
    pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
    if FileExists(pathMainApp) then
    begin
      sIniFile := TIniFile.Create(pathMainApp);
      path := ExtractFilePath(Application.ExeName) + '\Images\background_170_'
        +
        sIniFile.ReadString('Theme', 'Color1', '') + '_' +
        sIniFile.ReadString('Theme',
        'Color2', '') + '.png';
      CalcForm.Background.Picture.LoadFromFile(path);
    end;
  end;
end;

procedure CloseCalc; stdcall;
begin
  CalcForm.Destroy;
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', False);
  sIniFile.Free;
end;

procedure FormPos(x, y: integer; center: boolean); stdcall;
var
  empty: Boolean;
  Modx, mody: Integer;
begin
  isEmpy(CalcForm, empty);
  if empty = false then
  begin
    if center = true then
    begin
      CalcForm.top := Round((screen.height / 2) - (calcform.clientheight / 2));
      CalcForm.left := Round((screen.width / 2) - (calcform.clientwidth / 2));
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', Round((screen.width / 2) -
        (calcform.clientwidth / 2)));
      sinifile.writeinteger('Position', 'Top', Round((screen.height / 2) -
        (calcform.clientheight / 2)));
      sIniFile.Free;
    end
    else
    begin
      modx := Screen.width - CalcForm.width;
      mody := screen.height - CalcForm.height;
      if x < modx then
        CalcForm.left := x
      else
        CalcForm.left := modx;
      if y < mody then
        CalcForm.top := y
      else
        CalcForm.top := mody;
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', calcform.left);
      sinifile.writeinteger('Position', 'Top', calcform.top);
      sIniFile.Free;
    end;
  end;
end;

procedure FormCoord(pos: integer; var x, y: integer; var userpos: Boolean);
  stdcall;
var
  empty: Boolean;
  left_top, right_top, left_bot, right_bot, centered: Boolean;
begin
  isEmpy(calcform, empty);
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
          x := screen.width - calcform.clientwidth;
          y := 0
        end;
      2:
        begin
          x := 0;
          y := screen.height - calcform.clientheight;
        end;
      3:
        begin
          x := screen.width - calcform.clientwidth;
          y := screen.height - calcform.clientheight;
        end;
      4:
        begin
          y := Round((screen.height / 2) -
            (calcform.clientheight / 2));
          x := Round((screen.width / 2) -
            (calcform.clientwidth / 2));
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
              calcform.clientwidth) then
              left_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              calcform.clientheight) and
              (sinifile.readinteger('Position', 'Left', 0) <> 0) then
              right_top := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              calcform.clientheight) and
              (sinifile.readinteger('Position', 'Left', 0) <> screen.width -
              calcform.clientwidth) then
              right_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <>
              Round((screen.height / 2) - (calcform.clientheight / 2))) and
              (sinifile.readinteger('Position', 'Left', 0) <> Round((screen.width
              / 2) - (calcform.clientwidth / 2))) then
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
exports ShowCalc, RefreshCalc, CloseCalc, FormPos, FormCoord;
begin
end.

