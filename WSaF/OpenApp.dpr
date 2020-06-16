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
begin
  if Obj <> nil then
    empty := false
  else
    empty := True;
end;

procedure ShowApp; stdcall;
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
end;

procedure RefreshApp; stdcall;
var
  path, pathMainApp: string;
  empty: Boolean;
begin
  isEmpy(AppForm, empty);
  if empty = false then
  begin
    pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
    if FileExists(pathMainApp) then
    begin
      sIniFile := TIniFile.Create(pathMainApp);
      path := ExtractFilePath(Application.ExeName) + '\Images\background_120_' +
        sIniFile.ReadString('Theme', 'Color1', '') + '_' +
        sIniFile.ReadString('Theme',
        'Color2', '') + '.png';
      AppForm.AppBackground.Picture.LoadFromFile(path);
    end;
  end;
end;

procedure CloseApp; stdcall;
begin
  AppForm.Destroy;
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', False);
  sIniFile.Free;
end;

procedure FormPos(x, y: integer; center: boolean); stdcall;
var
  empty: Boolean;
begin
  isEmpy(AppForm, empty);
  if empty = false then
  begin
    if center = true then
    begin
      AppForm.top := Round((screen.height / 2) - (AppForm.ClientHeight / 2));
      AppForm.left := Round((screen.width / 2) - (AppForm.ClientWidth / 2));
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', Round((screen.width / 2) -
        (AppForm.ClientWidth / 2)));
      sinifile.writeinteger('Position', 'Top', Round((screen.height / 2) -
        (AppForm.ClientHeight / 2)));
      sIniFile.Free;
    end
    else
    begin
      if x = 0 then
        AppForm.Left := x
      else
        AppForm.Left := x - AppForm.clientwidth;
      if y = 0 then
        AppForm.Top := y
      else
        AppForm.Top := y - AppForm.clientheight;
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', AppForm.Left);
      sinifile.writeinteger('Position', 'Top', AppForm.Top);
      sIniFile.Free;
    end;
  end;
end;
exports ShowApp, RefreshApp, CloseApp, FormPos;
begin
end.
 
