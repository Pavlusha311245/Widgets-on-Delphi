library DateAndTime;
uses
  SysUtils,
  Windows,
  Forms,
  IniFiles,
  Classes,
  DateAndTimeWidget in 'DateAndTimeWidget.pas' {DateAndTimeForm};

{$R *.res}

//procedure isEmpy(Form: TObject; var empty: boolean); stdcall;
// external 'PaFWF.dll' name 'isEmpy';

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

procedure ShowDateAndTime; stdcall;
var
  empty: boolean;
begin
  isEmpy(DateAndTimeForm, empty);
  if empty = true then
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
  end
  else DateAndTimeForm.Show;
end;

procedure RefreshDateAndTime; stdcall;
var
  empty: boolean;
begin
  isEmpy(DateAndTimeForm, empty);
  if empty = false then
    DateAndTimeForm.Refresh;
end;

procedure CloseDateAndTime; stdcall;
var
  empty: Boolean;
begin
  isEmpy(DateAndTimeForm, empty);
  if empty = false then
  begin
    DateAndTimeForm.Close;
//    DateAndTimeForm.Destroy;
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', False);
    sIniFile.Free;
  end;
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

