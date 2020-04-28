library OpenFolder;

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
  Classes,
  IniFiles,
  FolderWidget in 'FolderWidget.pas' {FolderForm};

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

procedure ShowFolder; stdcall;
var
  empty: boolean;
begin
  isEmpy(FolderForm, empty);
  if empty = true then
  begin
    Application.CreateHandle;
    FolderForm := TFolderForm.Create(Application);
    FolderForm.Show;
    if FileExists(pathINI) then
    begin
      sIniFile := TIniFile.Create(pathINI);
      sIniFile.WriteBool('State', 'Active', true);
      sIniFile.Free;
    end;
  end;
end;

procedure RefreshFolder; stdcall;
var
  empty: boolean;
begin
  isEmpy(FolderForm, empty);
  if empty = false then
    FolderForm.Refresh;
end;

procedure CloseFolder; stdcall;
var
  empty: Boolean;
begin
  isEmpy(FolderForm, empty);
  if empty = false then
  begin
    FolderForm.Destroy;
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', False);
    sIniFile.Free;
  end;
end;

procedure FormPos(x, y: integer); stdcall;
var
  empty: Boolean;
begin
  isEmpy(FolderForm, empty);
  if empty = false then
  begin
    FolderForm.Top := x;
    FolderForm.Left := y;
  end;
end;
exports ShowFolder, RefreshFolder, CloseFolder, FormPos;
begin
end.
 