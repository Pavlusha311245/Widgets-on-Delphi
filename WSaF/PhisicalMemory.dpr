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
  letter_disk1: string;
  letter_disk2: string;
begin
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    letter_disk1 := sIniFile.ReadString('Disk', 'Disk1', '');
    letter_disk2 := sIniFile.ReadString('Disk', 'Disk2', '');
    sIniFile.Free;
  end;
  PhisicalMemoryForm.DiskNumber1.Caption := letter_disk1 + ': 000/000 Gb';
  PhisicalMemoryForm.DiskNumber2.Caption := letter_disk2 + ': 000/000 Gb';
  PhisicalMemoryForm.Close;
  PhisicalMemoryForm.Show;
  PhisicalMemoryForm.TimerMesuareDiskSize.Enabled := false;
  PhisicalMemoryForm.ProgressDisk1.Position := 0;
  PhisicalMemoryForm.ProgressDisk2.Position := 0;
  PhisicalMemoryForm.TimerDisk1.Enabled := True;
  PhisicalMemoryForm.TimerDisk2.Enabled := True;
  PhisicalMemoryForm.TimerMesuareDiskSize.Enabled := true;
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

