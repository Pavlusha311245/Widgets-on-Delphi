unit PhisicalMemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, acPNG, ExtCtrls, StdCtrls, ComCtrls, acProgressBar, TntComCtrls,
  Menus, IniFiles, ShellAPI;

type
  TPhisicalMemoryForm = class(TForm)
    TimerMesuareDiskSize: TTimer;
    PopupMenu: TPopupMenu;
    W1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    PhisicalMemoryBackground: TImage;
    DiskNumber1: TLabel;
    DiskNumber2: TLabel;
    ProgressDisk1: TProgressBar;
    ProgressDisk2: TProgressBar;
    procedure PhisicalMemoryBackgroundMouseDown(Sender: TObject; Button:
      TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure TimerMesuareDiskSizeTimer(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WMEXITSIZEMOVE(var message: TMessage); message WM_EXITSIZEMOVE;
    procedure N3Click(Sender: TObject);

  private
    { Private declarations }
  public
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
  end;

var
  PhisicalMemoryForm: TPhisicalMemoryForm;
  pathINI: string;
  sIniFile: TIniFile;

implementation

{$R *.dfm}

procedure TPhisicalMemoryForm.PhisicalMemoryBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PhisicalMemoryForm.perform(WM_SysCommand, $F012, 0);
end;

procedure TPhisicalMemoryForm.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  PhisicalMemoryBackground.Picture.LoadFromFile(extractfilepath(application.ExeName) + '\Images\background_240.png');
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    PhisicalMemoryForm.Top := sIniFile.ReadInteger('Position', 'Top', 0);
    PhisicalMemoryForm.Left := sIniFile.ReadInteger('Position', 'Left', 0);
    sIniFile.Free;
  end
  else
    showmessage('File not found');

end;

procedure TPhisicalMemoryForm.TimerMesuareDiskSizeTimer(Sender: TObject);
begin
  DiskNumber1.Caption := 'C: ' + IntToStr((DiskSize(3) div 1073741824) -
    (DiskFree(3)
    div 1073741824)) + '/' + IntToStr(DiskSize(3) div 1073741824) + ' Gb';
  ProgressDisk1.Position := Trunc(100 - (((DiskFree(3) div 1073741824) /
    (DiskSize(3) div
    1073741824)) * 100));
  DiskNumber2.Caption := 'D: ' + IntToStr((DiskSize(4) div 1073741824) -
    (DiskFree(4)
    div 1073741824)) + '/' + IntToStr(DiskSize(4) div 1073741824) + ' Gb';
  ProgressDisk2.Position := Trunc(100 - (((DiskFree(4) div 1073741824) /
    (DiskSize(4) div
    1073741824)) * 100));
end;

procedure TPhisicalMemoryForm.N2Click(Sender: TObject);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', false);
  sIniFile.Free;
  PhisicalMemoryForm.free;
end;

procedure TPhisicalMemoryForm.FormCreate(Sender: TObject);
begin
  pathINI := extractfilepath(application.ExeName) +
    '\PhisicalMemorySettings.ini';
end;

procedure TPhisicalMemoryForm.WMEXITSIZEMOVE(var message: TMessage);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteInteger('Position', 'Top', PhisicalMemoryForm.top);
  sIniFile.WriteInteger('Position', 'Left', PhisicalMemoryForm.Left);
  sIniFile.Free;
end;

procedure TPhisicalMemoryForm.WMMoving(var Msg: TWMMoving);
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

procedure TPhisicalMemoryForm.N3Click(Sender: TObject);
var ans:PAnsiChar; dir:string;
begin
  dir:=extractfilepath(application.ExeName) +
    '\PhisicalMemorySettings.ini';
  ans:=PAnsiChar(dir);
  ShellExecute(Handle, 'open',
    'c:\windows\notepad.exe',
    ans, nil,
    SW_SHOWNORMAL);
end;

end.

