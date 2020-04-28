unit CalendarWidget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, sMonthCalendar, IniFiles, ComCtrls, Menus,
  ShellAPI;

type
  TCalendarForm = class(TForm)
    Calendar: TMonthCalendar;
    PopupMenu: TPopupMenu;
    W1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    TimerShow: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
    procedure WMEXITSIZEMOVE(var message: TMessage); message WM_EXITSIZEMOVE;
    procedure N3Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CalendarForm: TCalendarForm;
  pathINI: string;
  sIniFile: TIniFile;
implementation

{$R *.dfm}

procedure TCalendarForm.FormCreate(Sender: TObject);
begin
  pathINI := extractfilepath(application.ExeName) + '\Settings\CalendarSettings.ini';
end;

procedure TCalendarForm.N1Click(Sender: TObject);
begin
  CalendarForm.Destroy;
end;

procedure TCalendarForm.TimerShowTimer(Sender: TObject);
begin
  if AlphaBlendValue <> 255 then
    AlphaBlendValue := AlphaBlendValue + 5
  else
    TimerShow.Enabled := false;
end;

procedure TCalendarForm.N3Click(Sender: TObject);
var
  ans: PAnsiChar;
  dir: string;
begin
  dir := extractfilepath(application.ExeName) + '\Settings\CalendarSettings.ini';
  ans := PAnsiChar(dir);
  ShellExecute(Handle, 'open',
    'c:\windows\notepad.exe',
    ans, nil,
    SW_SHOWNORMAL);
end;

procedure TCalendarForm.WMEXITSIZEMOVE(var message: TMessage);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteInteger('Position', 'Top', CalendarForm.top);
  sIniFile.WriteInteger('Position', 'Left', CalendarForm.Left);
  sIniFile.Free;
end;

procedure TCalendarForm.WMMoving(var Msg: TWMMoving);
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

procedure TCalendarForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  CalendarForm.perform(WM_SysCommand, $F012, 0);
end;

end.

