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
begin
  isEmpy(CalcForm, empty);
  if empty = false then
  begin
    if center = true then
    begin
      CalcForm.position := poDesktopCenter;
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', x);
      sinifile.writeinteger('Position', 'Top', y);
      sIniFile.Free;
    end
    else
    begin
      CalcForm.Left := x;
      CalcForm.Top := y;
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', x);
      sinifile.writeinteger('Position', 'Top', y);
      sIniFile.Free;
    end;
  end;
end;
exports ShowCalc, RefreshCalc, CloseCalc, FormPos;
begin
end.

