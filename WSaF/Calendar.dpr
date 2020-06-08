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
begin
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
  path, pathMainApp: string;
  empty: boolean;
begin
  isEmpy(CalendarForm, empty);
  if empty = False then
  begin
    pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
    if FileExists(pathMainApp) then
    begin
      sIniFile := TIniFile.Create(pathMainApp);
      path := ExtractFilePath(Application.ExeName) + '\Images\background_180_' +
        sIniFile.ReadString('Theme', 'Color1', '') + '_' +
        sIniFile.ReadString('Theme',
        'Color2', '') + '.png';
      CalendarForm.Background.Picture.LoadFromFile(path);
    end;
  end;
end;

procedure CloseCalendar; stdcall;
begin
  CalendarForm.Destroy;
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', False);
  sIniFile.Free;
end;

procedure FormPos(x, y: integer); stdcall;
var
  empty: Boolean;
begin
  isEmpy(CalendarForm, empty);
  if empty = false then
  begin
    CalendarForm.Left := x;
    CalendarForm.Top := y;
    sIniFile := TIniFile.Create(pathINI);
    sinifile.writeinteger('Position', 'Left', x);
    sinifile.writeinteger('Position', 'Top', y);
    sIniFile.Free;
  end;
end;
exports ShowCalendar, RefreshCalendar, CloseCalendar, FormPos;
begin
end.

