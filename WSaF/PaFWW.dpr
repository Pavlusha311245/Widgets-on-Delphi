library PaFWW;

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
  IniFiles,
  Windows,
  Forms,
  Classes,
  Messages,
  Variants,
  CpuUsageWidget in 'CpuUsageWidget.pas' {CpuUsageForm},
  CalculatorWidget in 'CalculatorWidget.pas' {CalcForm},
  DateAndTimeWidget in 'DateAndTimeWidget.pas' {DateAndTimeForm},
  AppWidget in 'AppWidget.pas' {AppForm},
  FolderWidget in 'FolderWidget.pas' {FolderForm},
  PhisicalMemo in 'PhisicalMemo.pas' {PhisicalMemoryForm},
  CalendarWidget in 'CalendarWidget.pas' {CalendarForm},
  adCpuUsage in 'WSaF\adCpuUsage.pas';

{$R *.res}

procedure FindClassName(NameForm: string; var classname: string);
var
  winclass: array[0..1024] of char;
  i: integer;
  hndl: HWND;
  nameclass: string;
begin
  hndl := FindWindow(nil, PAnsiChar(NameForm));
  for i := 0 to GetClassName(hndl, @winclass, 1024) do
    classname := classname + winclass[i];
end;

procedure ShowForm(Form: string; pathINI: string); stdcall;
begin
  Application.CreateHandle;
  Application.CreateForm(TDateAndTimeForm, DateAndTimeForm);
  AppForm.Show;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteBool('State', 'Active', true);
    sIniFile.Free;
  end;
end;
exports ShowForm;
begin
end.

