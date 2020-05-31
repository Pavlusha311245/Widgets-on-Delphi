library Calendar;

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
  Classes,
  Forms,
  Windows,
  IniFiles,
  CalendarWidget in 'CalendarWidget.pas' {CalendarForm};

{$R *.res}

procedure isEmpy(Obj: TObject; var empty: boolean);
var
  v: TClass;
begin
  //  try
  //    v := Obj.ClassParent;
  //    empty := false;
  //  except
  //    empty := true;
  //  end;
  if Obj <> nil then
    empty := false
  else
    empty := True;
end;

procedure ShowCalendar; stdcall;
begin
  Application.CreateHandle;
  CalendarForm := TCalendarForm.Create(Application);
  CalendarForm.Show;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', true);
    sIniFile.Free;
  end;
end;

procedure RefreshCalendar; stdcall;
var
  empty: boolean;
begin
  isEmpy(CalendarForm, empty);
  if empty = false then
    CalendarForm.Refresh;
end;

procedure CloseCalendar; stdcall;
var
  empty: Boolean;
begin
  isEmpy(CalendarForm, empty);
  if empty = false then
  begin
    //    CalendarForm.Close;
    CalendarForm.Destroy;
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', False);
    sIniFile.Free;
  end;
end;

procedure FormPos(x, y: integer); stdcall;
var
  empty: Boolean;
begin
  isEmpy(CalendarForm, empty);
  if empty = false then
  begin
    CalendarForm.Top := x;
    CalendarForm.Left := y;
  end;
end;
exports ShowCalendar, RefreshCalendar, CloseCalendar, FormPos;
begin
end.

