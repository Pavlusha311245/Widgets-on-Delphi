library OpenApp;

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
  AppWidget in 'AppWidget.pas' {AppForm};

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

procedure ShowApp; stdcall;
var
  empty: boolean;
begin
  isEmpy(AppForm, empty);
  if empty = true then
  begin
    Application.CreateHandle;
    AppForm := TAppForm.Create(Application);
    AppForm.Show;
    if FileExists(pathINI) then
    begin
      sIniFile := TIniFile.Create(pathINI);
      sIniFile.WriteBool('State', 'Active', true);
      sIniFile.Free;
    end;
  end
  else AppForm.Show;
end;

procedure RefreshApp; stdcall;
var
  empty: boolean;
begin
  isEmpy(AppForm, empty);
  if empty = false then
    AppForm.Refresh;
end;

procedure CloseApp; stdcall;
var
  empty: Boolean;
begin
  isEmpy(AppForm, empty);
  if empty = false then
  begin
    AppForm.Close;  
//    AppForm.Destroy;
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', False);
    sIniFile.Free;
  end;
end;

procedure FormPos(x, y: integer); stdcall;
var
  empty: Boolean;
begin
  isEmpy(AppForm, empty);
  if empty = false then
  begin
    AppForm.Top := x;
    AppForm.Left := y;
  end;
end;
exports ShowApp, RefreshApp, CloseApp, FormPos;
begin
end.
 