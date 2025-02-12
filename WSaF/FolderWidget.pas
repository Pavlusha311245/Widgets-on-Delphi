unit FolderWidget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, ExtCtrls, acPNG, Menus, ShellAPI, FileCtrl;

type
  TFolderForm = class(TForm)
    FolderBackground: TImage;
    FolderFontground: TImage;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    TimerShow: TTimer;
    N5: TMenuItem;
    DialogPathFolder: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
    procedure WMEXITSIZEMOVE(var message: TMessage); message WM_EXITSIZEMOVE;
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FolderFontgroundClick(Sender: TObject);
    procedure FolderBackgroundMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TimerShowTimer(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FolderForm: TFolderForm;
  pathINI: string;
  sIniFile: TIniFile;

implementation

{$R *.dfm}

procedure TFolderForm.FormCreate(Sender: TObject);
begin
  pathINI := extractfilepath(application.ExeName) +
    '\WSaF\Settings\OpenFolderSettings.ini';
end;

procedure TFolderForm.FormShow(Sender: TObject);
var
  path, pathMainApp: string;
begin
  ShowWindow(Handle, SW_HIDE);
  ShowWindow(Application.Handle, SW_HIDE);
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    FolderForm.Top := sIniFile.ReadInteger('Position', 'Top', 0);
    FolderForm.Left := sIniFile.ReadInteger('Position', 'Left', 0);
    sIniFile.Free;
  end;
  pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
  if FileExists(pathMainApp) then
  begin
    sIniFile := TIniFile.Create(pathMainApp);
    path := ExtractFilePath(Application.ExeName) + '\Images\background_120_' +
      sIniFile.ReadString('Theme', 'Color1', '') + '_' +
      sIniFile.ReadString('Theme',
      'Color2', '') + '.png';
    FolderBackground.Picture.LoadFromFile(path);
  end;
end;

procedure TFolderForm.WMEXITSIZEMOVE(var message: TMessage);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteInteger('Position', 'Top', FolderForm.top);
  sIniFile.WriteInteger('Position', 'Left', FolderForm.Left);
  sIniFile.Free;
end;

procedure TFolderForm.WMMoving(var Msg: TWMMoving);
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

procedure TFolderForm.N4Click(Sender: TObject);
begin
  FolderForm.Refresh;
end;

procedure TFolderForm.N3Click(Sender: TObject);
var
  ans: PAnsiChar;
  editor: PAnsiChar;
  dir: string;
  pathINIMainApp: string;
begin
  dir := extractfilepath(application.ExeName) +
    '\WSaF\Settings\OpenFolderSettings.ini';
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

procedure TFolderForm.N1Click(Sender: TObject);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', false);
  sIniFile.Free;
  FolderForm.Close;
end;

procedure TFolderForm.FolderFontgroundClick(Sender: TObject);
var
  pathFile: string;
begin
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    pathFile := sIniFile.ReadString('Folder', 'Path', '');
    sIniFile.Free;
  end;
  ShellExecute(0, 'open', PAnsiChar(pathFile), nil, nil, SW_SHOWNORMAL);
end;

procedure TFolderForm.FolderBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  FolderForm.perform(WM_SysCommand, $F012, 0);
end;

procedure TFolderForm.TimerShowTimer(Sender: TObject);
begin
  if AlphaBlendValue <> 255 then
    AlphaBlendValue := AlphaBlendValue + 5
  else
    TimerShow.Enabled := false;
end;

procedure TFolderForm.N5Click(Sender: TObject);
var
  SelectedDirName: string;
begin
  SelectDirectory('�������� �������', '', SelectedDirName);
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteString('Folder', 'Path', SelectedDirName);
  sIniFile.Free;
  FolderForm.FolderFontground.Hint := SelectedDirName;
end;

end.

