unit DateAndTimeWidget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, acPNG, ExtCtrls, StdCtrls, IniFiles, Menus, ShellAPI;

type
  TDateAndTimeForm = class(TForm)
    TimePickerNow: TTimer;
    PopupMenu: TPopupMenu;
    E1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    W1: TMenuItem;
    Time: TLabel;
    DateAndTimeBackground: TImage;
    TimerShow: TTimer;
    Date: TLabel;
    procedure DateAndTimeBackgroundMouseDown(Sender: TObject; Button:
      TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimePickerNowTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure WMEXITSIZEMOVE(var message: TMessage); message WM_EXITSIZEMOVE;
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
    procedure TimeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerShowTimer(Sender: TObject);
  private
  public
    { Public declarations }
  end;
var
  DateAndTimeForm: TDateAndTimeForm;
  pathINI: string;
  sIniFile: TIniFile;

implementation

{$R *.dfm}

function GMT: TTime;
var
  TZ: _TIME_ZONE_INFORMATION;
  dif: Integer;
  h, m, s, ms: Word;
  T: TTime;
begin
  T := Now;
  DecodeTime(T, h, m, s, ms);
  GetTimeZoneInformation(TZ);
  dif := TZ.Bias div 60;
  h := h + dif + 3;
  Result := EncodeTime(h, m, s, ms);
end;

procedure TDateAndTimeForm.DateAndTimeBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  DateAndTimeForm.perform(WM_SysCommand, $F012, 0);
end;

procedure TDateAndTimeForm.TimePickerNowTimer(Sender: TObject);
begin
  Time.Caption := TimeToStr(GMT);
  date.Caption := DateToStr(now);
end;

procedure TDateAndTimeForm.FormCreate(Sender: TObject);
begin
  pathINI := extractfilepath(application.ExeName) +
    '\WSaF\Settings\DateAndTimeSettings.ini';
end;

procedure TDateAndTimeForm.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  DateAndTimeBackground.Picture.LoadFromFile(extractfilepath(application.ExeName)
    + '\Images\background_120.png');
  Time.Caption := TimeToStr(now);
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    DateAndTimeForm.Top := sIniFile.ReadInteger('Position', 'Top', 0);
    DateAndTimeForm.Left := sIniFile.ReadInteger('Position', 'Left', 0);
  end;
end;

procedure TDateAndTimeForm.E1Click(Sender: TObject);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', false);
  sIniFile.Free;
  DateAndTimeForm.Close;
end;

procedure TDateAndTimeForm.N3Click(Sender: TObject);
begin
  DateAndTimeForm.Refresh;
end;

procedure TDateAndTimeForm.N2Click(Sender: TObject);
var
  ans: PAnsiChar;
  dir: string;
begin
  dir := extractfilepath(application.ExeName) +
    '\WSaF\Settings\DateAndTimeSettings.ini';
  ans := PAnsiChar(dir);
  ShellExecute(Handle, 'open',
    'c:\windows\notepad.exe',
    ans, nil,
    SW_SHOWNORMAL);
end;

procedure TDateAndTimeForm.WMEXITSIZEMOVE(var message: TMessage);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteInteger('Position', 'Top', DateAndTimeForm.top);
  sIniFile.WriteInteger('Position', 'Left', DateAndTimeForm.Left);
  sIniFile.Free;
end;

procedure TDateAndTimeForm.WMMoving(var Msg: TWMMoving);
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

procedure TDateAndTimeForm.TimeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  DateAndTimeForm.perform(WM_SysCommand, $F012, 0);
end;

procedure TDateAndTimeForm.TimerShowTimer(Sender: TObject);
begin
  if AlphaBlendValue <> 255 then
    AlphaBlendValue := AlphaBlendValue + 5
  else
    TimerShow.Enabled := false;
end;

end.

