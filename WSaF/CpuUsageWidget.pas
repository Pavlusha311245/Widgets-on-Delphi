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
    LabelCPU: TLabel;
    LabelPercentCpuUsage: TLabel;
    TimerShow: TTimer;
    g1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure CpuUsagebackgroundMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
    procedure WMEXITSIZEMOVE(var message: TMessage); message WM_EXITSIZEMOVE;
    procedure N4Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
    procedure g1Click(Sender: TObject);
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
  pathINI := extractfilepath(application.ExeName) +
    '\WSaF\Settings\CPUUsageSettings.ini';
end;

procedure TCpuUsageForm.N3Click(Sender: TObject);
var
  ans: PAnsiChar;
  editor: PAnsiChar;
  dir: string;
  pathINIMainApp: string;
begin
  dir := extractfilepath(application.ExeName) +
    '\WSaF\Settings\CPUUsageSettings.ini';
  ans := PAnsiChar(dir);
  pathINIMainApp := extractfilepath(application.ExeName) + '\Settings.ini';
  if FileExists(pathINIMainApp) then
  begin
    sIniFile := TIniFile.Create(pathINIMainApp);
    editor := PAnsiChar(sIniFile.readstring('Main', 'Editor', ''));
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  ShellExecute(Handle, 'open',
    editor,
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
var
  path, pathMainApp: string;
begin
  ShowWindow(Application.Handle, SW_HIDE);
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    CpuUsageForm.Top := sIniFile.ReadInteger('Position', 'Top', 0);
    CpuUsageForm.Left := sIniFile.ReadInteger('Position', 'Left', 0);
  end;
  pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
  if FileExists(pathMainApp) then
  begin
    sIniFile := TIniFile.Create(pathMainApp);
    path := ExtractFilePath(Application.ExeName) + '\Images\background_120_' +
      sIniFile.ReadString('Theme', 'Color1', '') + '_' +
      sIniFile.ReadString('Theme',
      'Color2', '') + '.png';
    if (sinifile.readstring('Theme', 'Color1', '') = 'white') or
      (sinifile.readstring('Theme', 'Color2', '') = 'white') then
    begin
      cpuusageform.labelCPU.font.color := 0;
      cpuusageform.LabelPercentCpuUsage.font.color := 0;
    end
    else
    begin
      cpuusageform.labelCPU.font.color := 16777215;
      cpuusageform.LabelPercentCpuUsage.font.color := 16777215;
    end;
    CpuUsagebackground.Picture.LoadFromFile(path);
  end;
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
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', false);
  sIniFile.Free;
  CpuUsageForm.close;
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

procedure TCpuUsageForm.WMEXITSIZEMOVE(var message: TMessage);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteInteger('Position', 'Top', CpuUsageForm.top);
  sIniFile.WriteInteger('Position', 'Left', CpuUsageForm.Left);
  sIniFile.Free;
end;

procedure TCpuUsageForm.TimerShowTimer(Sender: TObject);
begin
  if AlphaBlendValue <> 255 then
    AlphaBlendValue := AlphaBlendValue + 5
  else
    TimerShow.Enabled := false;
end;

procedure TCpuUsageForm.g1Click(Sender: TObject);
begin
  if g1.Checked = True then
  begin
    g1.Checked := False;
    CpuUsageForm.FormStyle := fsNormal;
  end
  else
  begin
    g1.Checked := True;
    CpuUsageForm.FormStyle := fsStayOnTop;
  end;
end;

end.

