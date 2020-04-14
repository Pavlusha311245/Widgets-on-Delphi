library DateAndTime;

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
  Windows,
  Forms,
  IniFiles,
  Classes,
  DateAndTimeWidget in 'DateAndTimeWidget.pas' {DateAndTimeForm};

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
  end;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', true);
    sIniFile.Free;
  end;
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
    DateAndTimeForm.Free;
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

