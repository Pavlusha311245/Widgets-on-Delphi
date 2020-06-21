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
        sIniFile.ReadString('Theme', 'Color2', '') + '.png';
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
  modx, mody: integer;
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
        (FolderForm.ClientWidth / 2)));
      sinifile.writeinteger('Position', 'Top', Round((screen.height / 2) -
        (FolderForm.ClientHeight / 2)));
      sIniFile.Free;
    end
    else
    begin
      modx := Screen.width - FolderForm.width;
      mody := screen.height - FolderForm.height;
      if x < modx then
        FolderForm.left := x
      else
        FolderForm.left := modx;
      if y < mody then
        FolderForm.top := y
      else
        FolderForm.top := mody;
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', FolderForm.Left);
      sinifile.writeinteger('Position', 'Top', FolderForm.Top);
      sIniFile.Free;
    end;
  end;
end;

procedure FormCoord(pos: integer; var x, y: integer; var userpos: Boolean);
  stdcall;
var
  empty: boolean;
  left_top, right_top, left_bot, right_bot, centered: Boolean;
begin
  isEmpy(FolderForm, empty);
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
          x := screen.width - FolderForm.clientwidth;
          y := 0
        end;
      2:
        begin
          x := 0;
          y := screen.height - FolderForm.clientheight;
        end;
      3:
        begin
          x := screen.width - FolderForm.clientwidth;
          y := screen.height - FolderForm.clientheight;
        end;
      4:
        begin
          y := Round((screen.height / 2) - (FolderForm.clientheight / 2));
          x := Round((screen.width / 2) - (FolderForm.clientwidth / 2));
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
              FolderForm.clientwidth) then
              left_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              FolderForm.clientheight) and (sinifile.readinteger('Position',
              'Left', 0) <> 0) then
              right_top := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              FolderForm.clientheight) and (sinifile.readinteger('Position',
              'Left', 0) <> screen.width - FolderForm.clientwidth) then
              right_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <>
              Round((screen.height / 2) - (FolderForm.clientheight / 2))) and
              (sinifile.readinteger('Position', 'Left', 0) <> Round((screen.width
              / 2) - (FolderForm.clientwidth / 2))) then
              centered := false;
            if (left_top = false) and (left_bot = False) and (right_top = false)
              and (right_bot = false) and (centered = false) then
              userpos := true;
          end;
        end;
    end;
  end;
end;

exports
  ShowFolder,
  RefreshFolder,
  CloseFolder,
  FormPos,
  FormCoord;

begin
end.

