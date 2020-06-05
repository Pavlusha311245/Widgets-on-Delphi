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
begin
  if Obj <> nil then
    empty := false
  else
    empty := True;
end;

procedure ShowPhisicalMemory; stdcall;
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

procedure RefreshPhisicalMemory; stdcall;
var
  path, pathMainApp: string;
  empty: Boolean;
begin
  isEmpy(PhisicalMemoryForm, empty);
  if empty = false then
  begin
    phisicalmemoryform.n4click(phisicalmemoryform);
    pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
    if FileExists(pathMainApp) then
    begin
      sIniFile := TIniFile.Create(pathMainApp);
      path := ExtractFilePath(Application.ExeName) + '\Images\background_240_' +
        sIniFile.ReadString('Theme', 'Color1', '') + '_' +
        sIniFile.ReadString('Theme',
        'Color2', '') + '.png';
      if (sIniFile.ReadString('Theme', 'Color1', '') = 'white') or
        (sIniFile.ReadString('Theme', 'Color2', '') = 'white') then
      begin
        PhisicalMemoryForm.DiskNumber1.Font.Color := 0;
        PhisicalMemoryForm.DiskNumber2.Font.Color := 0;
      end
      else
      begin
        PhisicalMemoryForm.DiskNumber1.Font.Color := 16777215;
        PhisicalMemoryForm.DiskNumber2.Font.Color := 16777215;
      end;
      PhisicalMemoryForm.PhisicalMemoryBackground.Picture.LoadFromFile(path);
    end;
  end;
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

