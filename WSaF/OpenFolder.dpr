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
begin
  if Obj <> nil then
    empty := false
  else
    empty := True;
end;

procedure ShowFolder; stdcall;
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

procedure RefreshFolder; stdcall;
var
  path, pathMainApp: string;
  empty: Boolean;
begin
  isEmpy(FolderForm, empty);
  if empty = False then
  begin
    pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
    if FileExists(pathMainApp) then
    begin
      sIniFile := TIniFile.Create(pathMainApp);
      path := ExtractFilePath(Application.ExeName) + '\Images\background_120_' +
        sIniFile.ReadString('Theme', 'Color1', '') + '_' +
        sIniFile.ReadString('Theme',
        'Color2', '') + '.png';
      FolderForm.FolderBackground.Picture.LoadFromFile(path);
    end;
  end;
end;

procedure CloseFolder; stdcall;
begin
  FolderForm.Destroy;
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', False);
  sIniFile.Free;
end;

procedure FormPos(x, y: integer; center: boolean); stdcall;
var
  empty: Boolean;
begin
  isEmpy(FolderForm, empty);
  if empty = false then
  begin
    if center = true then
    begin
      FolderForm.top := Round((screen.height / 2) - (FolderForm.ClientHeight /
        2));
      FolderForm.left := Round((screen.width / 2) - (FolderForm.ClientWidth /
        2));
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', Round((screen.width / 2) -
        (FolderForm.ClientWidth /
        2)));
      sinifile.writeinteger('Position', 'Top', Round((screen.height / 2) -
        (FolderForm.ClientHeight /
        2)));
      sIniFile.Free;
    end
    else
    begin
      if x = 0 then
        FolderForm.Left := x
      else
        FolderForm.Left := x - FolderForm.clientwidth;
      if y = 0 then
        FolderForm.Top := y
      else
        FolderForm.Top := y - FolderForm.clientheight;
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', FolderForm.Left);
      sinifile.writeinteger('Position', 'Top', FolderForm.Top);
      sIniFile.Free;
    end;
  end;
end;
exports ShowFolder, RefreshFolder, CloseFolder, FormPos;
begin
end.
 
