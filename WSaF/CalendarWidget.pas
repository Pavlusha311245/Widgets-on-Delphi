unit CalendarWidget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, sMonthCalendar, IniFiles, ComCtrls, Menus,
  ShellAPI, acPNG;

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
    Background: TImage;
    N5: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
    procedure WMEXITSIZEMOVE(var message: TMessage); message WM_EXITSIZEMOVE;
    procedure N3Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure BackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N5Click(Sender: TObject);
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
  pathINI := extractfilepath(application.ExeName) +
    '\WSaF\Settings\CalendarSettings.ini';
end;

procedure TCalendarForm.N1Click(Sender: TObject);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', false);
  sIniFile.Free;
  CalendarForm.Close;
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
  editor: PAnsiChar;
  dir: string;
  pathINIMainApp: string;
begin
  dir := extractfilepath(application.ExeName) +
    '\WSaF\Settings\CalendarSettings.ini';
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

procedure TCalendarForm.FormShow(Sender: TObject);
var
  path, pathMainApp: string;
begin
  ShowWindow(Handle, SW_HIDE);
  ShowWindow(Application.Handle, SW_HIDE);
  pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
  if FileExists(pathMainApp) then
  begin
    sIniFile := TIniFile.Create(pathMainApp);
    path := ExtractFilePath(Application.ExeName) + '\Images\background_180_' +
      sIniFile.ReadString('Theme', 'Color1', '') + '_' +
      sIniFile.ReadString('Theme',
      'Color2', '') + '.png';
    Background.Picture.LoadFromFile(path);
  end;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    CalendarForm.Top := sIniFile.ReadInteger('Position', 'Top', 0);
    CalendarForm.Left := sIniFile.ReadInteger('Position', 'Left', 0);
    sIniFile.Free;
  end
  else
    showmessage('File not found');
end;

procedure TCalendarForm.BackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  CalendarForm.perform(WM_SysCommand, $F012, 0);
end;

procedure TCalendarForm.N5Click(Sender: TObject);
begin
  if N5.Checked = True then
  begin
    N5.Checked := False;
    CalendarForm.FormStyle := fsNormal;
  end
  else
  begin
    N5.Checked := True;
    CalendarForm.FormStyle := fsStayOnTop;
  end;
end;

end.

