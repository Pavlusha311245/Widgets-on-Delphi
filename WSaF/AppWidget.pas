unit AppWidget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, IniFiles, acPNG, ExtCtrls, ShellAPI;

type
  TAppForm = class(TForm)
    PopupMenu: TPopupMenu;
    W1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    AppBackground: TImage;
    TimerShow: TTimer;
    AppFontground: TImage;
    N5: TMenuItem;
    DialogPathApp: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure AppBackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerShowTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
    procedure WMEXITSIZEMOVE(var message: TMessage); message WM_EXITSIZEMOVE;
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure AppFontgroundClick(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AppForm: TAppForm;
  pathINI: string;
  sIniFile: TIniFile;
implementation

{$R *.dfm}

procedure TAppForm.FormCreate(Sender: TObject);
begin
  pathINI := extractfilepath(application.ExeName) +
    '\WSaF\Settings\OpenAppSettings.ini';
end;

procedure TAppForm.N1Click(Sender: TObject);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', false);
  sIniFile.Free;
  AppForm.Close;
end;

procedure TAppForm.AppBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  AppForm.perform(WM_SysCommand, $F012, 0);
end;

procedure TAppForm.TimerShowTimer(Sender: TObject);
begin
  if AlphaBlendValue <> 255 then
    AlphaBlendValue := AlphaBlendValue + 5
  else
    TimerShow.Enabled := false;
end;

procedure TAppForm.FormShow(Sender: TObject);
var
  iconexe: TIcon;
  iconpath: string;
  i: TIcon;
begin
  ShowWindow(Application.Handle, SW_HIDE);
  AppBackground.Picture.LoadFromFile(extractfilepath(application.ExeName)
    + '\Images\background_120.png');
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    iconpath := sIniFile.ReadString('App', 'Path', '');
    i := tIcon.Create;
    i.Handle := ExtractIcon(HInstance, PAnsiChar(iconpath), 0);
    i.SaveToFile(extractfilepath(application.ExeName)
      + '\Images\AppIcon.ico');
    AppFontground.Picture.LoadFromFile(extractfilepath(application.ExeName)
      + '\Images\AppIcon.ico');
    AppForm.Top := sIniFile.ReadInteger('Position', 'Top', 0);
    AppForm.Left := sIniFile.ReadInteger('Position', 'Left', 0);
    i := nil;
    sIniFile.Free;
  end;
end;

procedure TAppForm.WMEXITSIZEMOVE(var message: TMessage);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteInteger('Position', 'Top', AppForm.top);
  sIniFile.WriteInteger('Position', 'Left', AppForm.Left);
  sIniFile.Free;
end;

procedure TAppForm.WMMoving(var Msg: TWMMoving);
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

procedure TAppForm.N4Click(Sender: TObject);
var
  iconexe: TIcon;
  iconpath: string;
  i: TIcon;
begin
  AppForm.Refresh;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    iconpath := sIniFile.ReadString('App', 'Path', '');
    i := tIcon.Create;
    i.Handle := ExtractIcon(HInstance, PAnsiChar(iconpath), 0);
    i.SaveToFile(extractfilepath(application.ExeName)
      + '\Images\AppIcon.ico');
    AppFontground.Picture.LoadFromFile(extractfilepath(application.ExeName)
      + '\Images\AppIcon.ico');
    i := nil;
    sIniFile.Free;
  end;
end;

procedure TAppForm.N3Click(Sender: TObject);
var
  ans: PAnsiChar;
  editor: PAnsiChar;
  dir: string;
  pathINIMainApp: string;
begin
  dir := extractfilepath(application.ExeName) +
    '\WSaF\Settings\OpenAppSettings.ini';
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

procedure TAppForm.AppFontgroundClick(Sender: TObject);
var
  pathFile: string;
begin
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    pathFile := sIniFile.ReadString('App', 'Path', '');
    sIniFile.Free;
  end;
  ShellExecute(0, 'open', PAnsiChar(pathFile), nil, nil, SW_SHOWNORMAL);
end;

procedure TAppForm.N5Click(Sender: TObject);
begin
  if DialogPathApp.Execute then
  begin
    sIniFile := TIniFile.Create(pathINI);
    sIniFile.WriteString('App', 'Path', DialogPathApp.FileName);
    sIniFile.Free;
  end;
  N4Click(AppForm);
  AppFontground.Enabled := false;
  AppFontground.Enabled := true;
end;

end.

