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
  CpuUsageWidget in 'CpuUsageWidget.pas' {CpuUsageForm},
  CalculatorWidget in 'CalculatorWidget.pas' {CalcForm},
  DateAndTimeWidget in 'DateAndTimeWidget.pas' {DateAndTimeForm},
  AppWidget in 'AppWidget.pas' {AppForm},
  FolderWidget in 'FolderWidget.pas' {FolderForm},
  PhisicalMemo in 'PhisicalMemo.pas' {PhisicalMemoryForm},
  CalendarWidget in 'CalendarWidget.pas' {CalendarForm},
  adCpuUsage in 'WSaF\adCpuUsage.pas';

{$R *.res}
procedure ShowForm(Form:string);
var
  WinClass: array[0..255] of Char;
begin
  
end;
begin
end.

