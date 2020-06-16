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
      if x = 0 then
        calcform.Left := x
      else
        calcform.Left := x - calcform.clientwidth;
      if y = 0 then
        calcform.Top := y
      else
        calcform.Top := y - calcform.clientheight;
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', calcform.left);
      sinifile.writeinteger('Position', 'Top', calcform.top);
      sIniFile.Free;
    end;
  end;
end;
exports ShowCalc, RefreshCalc, CloseCalc, FormPos;
begin
end.

