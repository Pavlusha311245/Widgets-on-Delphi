unit CpuUsageWidget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, ExtCtrls, Menus, ShellAPI, acPNG, StdCtrls, adCpuUsage;

type
  TCpuUsageForm = class(TForm)
    CpuUsagebackground: TImage;
    PopupMenu: TPopupMenu;
    W1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Timer: TTimer;
    LabelPercentCpuUsage: TLabel;
    LabelCPU: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure CpuUsagebackgroundMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
    procedure N4Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CpuUsageForm: TCpuUsageForm;
  pathINI: string;
  sIniFile: TIniFile;
implementation

{$R *.dfm}

procedure TCpuUsageForm.FormCreate(Sender: TObject);
begin
  pathINI := extractfilepath(application.ExeName) + '\CPUUsageSettings.ini';

end;

procedure TCpuUsageForm.N3Click(Sender: TObject);
var
  ans: PAnsiChar;
  dir: string;
begin
  dir := extractfilepath(application.ExeName) + '\CPUUsageSettings.ini';
  ans := PAnsiChar(dir);
  ShellExecute(Handle, 'open',
    'c:\windows\notepad.exe',
    ans, nil,
    SW_SHOWNORMAL);
end;

procedure TCpuUsageForm.CpuUsagebackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  CpuUsageForm.perform(WM_SysCommand, $F012, 0);
end;

procedure TCpuUsageForm.FormShow(Sender: TObject);
begin
  CpuUsagebackground.Picture.LoadFromFile(extractfilepath(application.ExeName)
    + '\Images\background_120.png');
end;

procedure TCpuUsageForm.N4Click(Sender: TObject);
begin
  CpuUsageForm.Refresh;
end;

procedure TCpuUsageForm.TimerTimer(Sender: TObject);
var
  i: integer;
begin
  CollectCPUData;
  for i := 0 to GetCPUCount - 1 do
    LabelPercentCpuUsage.Caption := FloatToStr(Abs(Round(GetCPUUsage(i) * 100)))
      + '%'; //Function CPU Usage
end;

procedure TCpuUsageForm.N1Click(Sender: TObject);
begin
  CpuUsageForm.Free;
end;

procedure TCpuUsageForm.WMMoving(var Msg: TWMMoving);
var
  workArea: TRect;
begin
  workArea := Screen.WorkareaRect;
  with Msg.DragRect^ do
  begin
    if Left < workArea.Left then
      OffsetRect(Msg.DragRect^, workArea.Left - Left, 0);
    if Top < workArea.Top then
      OffsetRect(Msg.DragRect^, 0, workArea.Top - Top);
    if Right > workArea.Right then
      OffsetRect(Msg.DragRect^, workArea.Right - Right, 0);
    if Bottom > workArea.Bottom then
      OffsetRect(Msg.DragRect^, 0, workArea.Bottom - Bottom);
  end;
  inherited;
end;

end.

