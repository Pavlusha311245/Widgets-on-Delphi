library PhisicalMemory;

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
  PhisicalMemo in 'PhisicalMemo.pas' {PhisicalMemoryForm};

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

procedure ShowPhisicalMemory; stdcall;
var
  empty: boolean;
begin
  isEmpy(PhisicalMemoryForm, empty);
  if empty = true then
  begin
    Application.CreateHandle;
    PhisicalMemoryForm := TPhisicalMemoryForm.Create(Application);
    PhisicalMemoryForm.Show;
    if FileExists(pathINI) then
    begin
      sIniFile := TIniFile.Create(pathINI);
      sIniFile.WriteBool('State', 'Active', true);
      sIniFile.Free;
    end;
  end;

end;

procedure RefreshPhisicalMemory; stdcall;
var
  empty: boolean;
begin
  isEmpy(PhisicalMemoryForm, empty);
  if empty = false then
    PhisicalMemoryForm.Refresh;
end;

procedure ClosePhisicalMemory; stdcall;
var
  empty: Boolean;
begin
  isEmpy(PhisicalMemoryForm, empty);
  if empty = false then
  begin
//    PhisicalMemoryForm.Close;
    PhisicalMemoryForm.Destroy;
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', false);
    sIniFile.Free;
  end;
end;

procedure FormPos(x, y: integer); stdcall;
var
  empty: Boolean;
begin
  isEmpy(PhisicalMemoryForm, empty);
  if empty = false then
  begin
    PhisicalMemoryForm.Top := x;
    PhisicalMemoryForm.Left := y;
  end;
end;
exports ShowPhisicalMemory, RefreshPhisicalMemory, ClosePhisicalMemory, FormPos;
begin
end.

