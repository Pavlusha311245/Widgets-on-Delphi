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

procedure FormPos(x, y: integer; center: boolean); stdcall;
var
  empty: Boolean;
  modx, mody: integer;
begin
  isEmpy(PhisicalMemoryForm, empty);
  if empty = false then
  begin
    if center = true then
    begin
      PhisicalMemoryForm.top := Round((screen.Height / 2) -
        (PhisicalMemoryForm.clientheight / 2));
      PhisicalMemoryForm.left := Round((screen.width / 2) -
        (PhisicalMemoryForm.ClientWidth / 2));
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', Round((screen.width / 2) -
        (PhisicalMemoryForm.ClientWidth / 2)));
      sinifile.writeinteger('Position', 'Top', Round((screen.Height / 2) -
        (PhisicalMemoryForm.clientheight / 2)));
      sIniFile.Free;
    end
    else
    begin
      modx := Screen.width - PhisicalMemoryForm.width;
      mody := screen.height - PhisicalMemoryForm.height;
      if x < modx then
        PhisicalMemoryForm.left := x
      else
        PhisicalMemoryForm.left := modx;
      if y < mody then
        PhisicalMemoryForm.top := y
      else
        PhisicalMemoryForm.top := mody;
      sIniFile := TIniFile.Create(pathINI);
      sinifile.writeinteger('Position', 'Left', PhisicalMemoryForm.Left);
      sinifile.writeinteger('Position', 'Top', PhisicalMemoryForm.Top);
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
  isEmpy(PhisicalMemoryForm, empty);
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
          x := screen.width - PhisicalMemoryForm.clientwidth;
          y := 0
        end;
      2:
        begin
          x := 0;
          y := screen.height - PhisicalMemoryForm.clientheight;
        end;
      3:
        begin
          x := screen.width - PhisicalMemoryForm.clientwidth;
          y := screen.height - PhisicalMemoryForm.clientheight;
        end;
      4:
        begin
          y := Round((screen.height / 2) -
            (PhisicalMemoryForm.clientheight / 2));
          x := Round((screen.width / 2) -
            (PhisicalMemoryForm.clientwidth / 2));
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
              PhisicalMemoryForm.clientwidth) then
              left_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              PhisicalMemoryForm.clientheight) and
              (sinifile.readinteger('Position', 'Left', 0) <> 0) then
              right_top := false;
            if (sinifile.readinteger('Position', 'Top', 0) <> screen.height -
              PhisicalMemoryForm.clientheight) and
              (sinifile.readinteger('Position', 'Left', 0) <> screen.width -
              PhisicalMemoryForm.clientwidth) then
              right_bot := false;
            if (sinifile.readinteger('Position', 'Top', 0) <>
              Round((screen.height / 2) - (PhisicalMemoryForm.clientheight / 2)))
              and
              (sinifile.readinteger('Position', 'Left', 0) <> Round((screen.width
              / 2) - (PhisicalMemoryForm.clientwidth / 2))) then
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
exports ShowPhisicalMemory, RefreshPhisicalMemory, ClosePhisicalMemory, FormPos,
  FormCoord;
begin
end.

