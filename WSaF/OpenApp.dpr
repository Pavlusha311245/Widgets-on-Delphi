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

procedure FormCoord(pos: integer; var x, y: integer; var userpos: Boolean);
  stdcall;
var
  empty: Boolean;
  left_top, right_top, left_bot, right_bot, centered: Boolean;
begin
  isEmpy(AppForm, empty);
  if empty = false then
  begin
    left_top := true;
    right_top := True;
    left_bot := true;
    right_bot := true;
    centered := true;
    case pos of
      0:
        begin
          x := 0;
          y := 0;
        end;
      1:
        begin
          x := screen.width - AppForm.clientwidth;
          y := 0
        end;
      2:
        begin
          x := 0;
          y := screen.height - AppForm.clientheight;
        end;
      3:
        begin
          x := screen.width - AppForm.clientwidth;
          y := screen.height - AppForm.clientheight;
        end;
      4:
        begin
          y := Round((screen.height / 2) -
            (AppForm.clientheight / 2));
          x := Round((screen.width / 2) -
            (AppForm.clientwidth / 2));
        end;
      5:
        begin
          if fileexists(pathINI) then
          begin
            sinifile := tinifile.create(pathINI);
            if (sinifile.readinteger('Position', 'Top', 0) <> 0) and
              (sinifile.readinteger('Position', 'Left', 0) <> 0) then
              left_top := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> 0) and
              (sinifile.readinteger('Position', 'Left', 0) <> screen.width -
              AppForm.clientwidth) then
              left_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              AppForm.clientheight) and
              (sinifile.readinteger('Position', 'Left', 0) <> 0) then
              right_top := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              AppForm.clientheight) and
              (sinifile.readinteger('Position', 'Left', 0) <> screen.width -
              AppForm.clientwidth) then
              right_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <>
              Round((screen.height / 2) - (AppForm.clientheight / 2))) and
              (sinifile.readinteger('Position', 'Left', 0) <> Round((screen.width
              / 2) - (AppForm.clientwidth / 2))) then
              centered := false;
            if (left_top = false) and (left_bot = False) and (right_top =
              false) and
              (right_bot = false) and (centered = false) then
              userpos := true;
          end;
        end;
    end;
  end;
end;
exports ShowApp, RefreshApp, CloseApp, FormPos, FormCoord;
begin
end.
 
