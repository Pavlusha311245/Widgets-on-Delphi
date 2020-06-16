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
    TimerDisk1: TTimer;
    TimerDisk2: TTimer;
    TimerShow: TTimer;
    N5: TMenuItem;
    Seldisk1: TComboBox;
    Seldisk2: TComboBox;
    B1: TMenuItem;
    N6: TMenuItem;
    procedure PhisicalMemoryBackgroundMouseDown(Sender: TObject; Button:
      TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure TimerMesuareDiskSizeTimer(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WMEXITSIZEMOVE(var message: TMessage); message WM_EXITSIZEMOVE;

    procedure N3Click(Sender: TObject);
    procedure TimerDisk1Timer(Sender: TObject);
    procedure TimerDisk2Timer(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Seldisk1Change(Sender: TObject);
    procedure DiskNumber1DblClick(Sender: TObject);
    procedure DiskNumber2DblClick(Sender: TObject);
    procedure Seldisk2Change(Sender: TObject);
    procedure Seldisk1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Seldisk2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
  public
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
  end;

var
  PhisicalMemoryForm: TPhisicalMemoryForm;
  pathINI: string;
  sIniFile: TIniFile;

const
  BtoGb = 1073741824;

implementation

{$R *.dfm}

procedure TPhisicalMemoryForm.PhisicalMemoryBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PhisicalMemoryForm.perform(WM_SysCommand, $F012, 0);
end;

procedure TPhisicalMemoryForm.FormShow(Sender: TObject);
var
  letter_disk1: string;
  letter_disk2: string;
  path, pathMainApp: string;
begin
  ShowWindow(Handle, SW_HIDE);
  ShowWindow(Application.Handle, SW_HIDE);
  pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
  if FileExists(pathMainApp) then
  begin
    sIniFile := TIniFile.Create(pathMainApp);
    path := ExtractFilePath(Application.ExeName) + '\Images\background_240_' +
      sIniFile.ReadString('Theme', 'Color1', '') + '_' +
      sIniFile.ReadString('Theme',
      'Color2', '') + '.png';
    PhisicalMemoryBackground.Picture.LoadFromFile(path);
  end;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    PhisicalMemoryForm.Top := sIniFile.ReadInteger('Position', 'Top', 0);
    PhisicalMemoryForm.Left := sIniFile.ReadInteger('Position', 'Left', 0);
    letter_disk1 := sIniFile.ReadString('Disk', 'Disk1', '');
    letter_disk2 := sIniFile.ReadString('Disk', 'Disk2', '');
    sIniFile.Free;
  end
  else
    showmessage('File not found');
  DiskNumber1.Caption := letter_disk1 + ': 000/000 Gb';
  DiskNumber2.Caption := letter_disk2 + ': 000/000 Gb';
end;
const
  alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

procedure TPhisicalMemoryForm.TimerMesuareDiskSizeTimer(Sender: TObject);
var
  Disk1, Disk2, number_disk1, number_disk2, i: integer;
  letter_disk1, letter_disk2, pathMainApp: string;
begin
  pathMainApp := ExtractFilePath(Application.ExeName) + '\Settings.ini';
  number_disk1 := 0;
  number_disk2 := 0;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    letter_disk1 := sIniFile.ReadString('Disk', 'Disk1', '');
    letter_disk2 := sIniFile.ReadString('Disk', 'Disk2', '');
    sIniFile.Free;
  end;
  //Диск 1
  if (letter_disk1 = '') or (letter_disk1 = ' ') or (Length(letter_disk1) > 2)
    then
  begin
    DiskNumber1.Caption := 'Error';
    DiskNumber1.Font.Color := clRed;
    ProgressDisk1.Position := 0;
  end
  else
  begin
    if FileExists(pathMainApp) then
    begin
      sIniFile := TIniFile.Create(pathMainApp);
      if (sIniFile.ReadString('Theme', 'Color1', '') = 'white') or
        (sIniFile.ReadString('Theme', 'Color2', '') = 'white') then
      begin
        PhisicalMemoryForm.DiskNumber1.Font.Color := 0;
      end
      else
      begin
        PhisicalMemoryForm.DiskNumber1.Font.Color := 16777215;
      end;
    end;
    for i := 1 to Length(alphabet) do
    begin
      if alphabet[i] = letter_disk1 then
        number_disk1 := i;
    end;
    //Занятое дисковое пространство
    if DiskSize(number_disk1) >= 0 then
    begin
      Disk1 := Trunc((((DiskSize(number_disk1)
        div BtoGb) - (DiskFree(number_disk1)
        div BtoGb)) / (DiskSize(number_disk1)
        div BtoGb)) * 100);
      if ProgressDisk1.Position = Disk1 then
      begin
        DiskNumber1.Caption := letter_disk1 + ': ' +
          IntToStr((DiskSize(number_disk1)
          div BtoGb) -
          (DiskFree(number_disk1)
          div BtoGb)) + '/' + IntToStr(DiskSize(number_disk1) div BtoGb) +
          ' Gb';
        ProgressDisk1.Position := Trunc(100 - (((DiskFree(number_disk1) div
          BtoGb)
          /
          (DiskSize(number_disk1) div
          BtoGb)) * 100));
      end
      else if TimerDisk1.Enabled = False then
      begin
        DiskNumber1.Caption := letter_disk1 + ': 000/000 Gb';
        ProgressDisk1.Position := 0;
        TimerDisk1.Enabled := true;
      end;
    end
    else
    begin
      DiskNumber1.Caption := 'Error';
      DiskNumber1.Font.Color := clRed;
      ProgressDisk1.Position := 0;
    end;
  end;
  //диск 2
  if (letter_disk1 = '') or (letter_disk1 = ' ') or (Length(letter_disk1) > 2)
    then
  begin
    ProgressDisk2.Position := 0;
    DiskNumber2.Caption := 'Error';
    DiskNumber2.Font.Color := clRed;
  end
  else
  begin
    if FileExists(pathMainApp) then
    begin
      sIniFile := TIniFile.Create(pathMainApp);
      if (sIniFile.ReadString('Theme', 'Color1', '') = 'white') or
        (sIniFile.ReadString('Theme', 'Color2', '') = 'white') then
      begin
        PhisicalMemoryForm.DiskNumber2.Font.Color := 0;
      end
      else
      begin
        PhisicalMemoryForm.DiskNumber2.Font.Color := 16777215;
      end;
    end;
    for i := 1 to Length(alphabet) do
    begin
      if alphabet[i] = letter_disk2 then
        number_disk2 := i;
    end;
    if DiskSize(number_disk2) >= 0 then
    begin
      //Занятое дисковое пространство
      Disk2 := Trunc((((DiskSize(number_disk2)
        div BtoGb) - (DiskFree(number_disk2)
        div BtoGb)) / (DiskSize(number_disk2)
        div BtoGb)) * 100);
      if ProgressDisk2.Position = Disk2 then
      begin
        DiskNumber2.Caption := letter_disk2 + ': ' +
          IntToStr((DiskSize(number_disk2)
          div BtoGb) -
          (DiskFree(number_disk2)
          div BtoGb)) + '/' + IntToStr(DiskSize(number_disk2) div BtoGb) +
          ' Gb';
        ProgressDisk2.Position := Trunc(100 - (((DiskFree(number_disk2) div
          BtoGb)
          /
          (DiskSize(number_disk2) div
          BtoGb)) * 100));
      end
      else if TimerDisk2.Enabled = False then
      begin
        DiskNumber2.Caption := letter_disk2 + ': 000/000 Gb';
        ProgressDisk2.Position := 0;
        TimerDisk2.Enabled := true;
      end;
    end
    else
    begin
      DiskNumber2.Caption := 'Error';
      DiskNumber2.Font.Color := clRed;
      ProgressDisk2.Position := 0;
    end;
  end;
end;

procedure TPhisicalMemoryForm.N2Click(Sender: TObject);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteBool('State', 'Active', false);
  sIniFile.Free;
  PhisicalMemoryForm.Close;
end;

procedure TPhisicalMemoryForm.FormCreate(Sender: TObject);
begin
  pathINI := extractfilepath(application.ExeName) +
    '\WSaF\Settings\PhisicalMemorySettings.ini';
end;

procedure RetPos(x: Integer; y: integer); stdcall;
  external 'PaFWF.dll' name 'RetPos';

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
var
  ans: PAnsiChar;
  editor: PAnsiChar;
  dir: string;
  pathINIMainApp: string;
begin
  dir := extractfilepath(application.ExeName) +
    '\WSaF\Settings\PhisicalMemorySettings.ini';
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

procedure TPhisicalMemoryForm.TimerDisk1Timer(Sender: TObject);
var
  Disk1, number_disk, i: Integer;
  letter_disk, alphabet: string;
begin
  alphabet := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  number_disk := 0;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    letter_disk := sIniFile.ReadString('Disk', 'Disk1', '');
    sIniFile.Free;
  end;
  if (letter_disk = '') or (letter_disk = ' ') or (Length(letter_disk) > 2) then
  begin
    DiskNumber1.Caption := 'Error';
    DiskNumber1.Font.Color := clRed;
  end
  else
  begin
    for i := 1 to Length(alphabet) do
    begin
      if alphabet[i] = letter_disk then
        number_disk := i;
    end;
    if DiskSize(number_disk) >= 0 then
    begin
      Disk1 := Trunc((((DiskSize(number_disk)
        div BtoGb) - (DiskFree(number_disk)
        div BtoGb)) / (DiskSize(number_disk)
        div BtoGb)) * 100);
      if ProgressDisk1.Position <> Disk1 then
        ProgressDisk1.Position := ProgressDisk1.Position + 1
      else
        TimerDisk1.Enabled := False;
    end
    else
    begin
      DiskNumber1.Caption := 'Error';
      DiskNumber1.Font.Color := clRed;
      ProgressDisk1.Position := 0;
    end;
  end;
end;

procedure TPhisicalMemoryForm.TimerDisk2Timer(Sender: TObject);
var
  Disk2, number_disk, i: Integer;
  letter_disk, alphabet: string;
begin
  alphabet := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  number_disk := 0;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    letter_disk := sIniFile.ReadString('Disk', 'Disk2', '');
    sIniFile.Free;
  end;
  if (letter_disk = '') or (letter_disk = ' ') or (Length(letter_disk) > 2) then
  begin
    DiskNumber2.Caption := 'Error';
    DiskNumber2.Font.Color := clRed;
  end
  else
  begin
    for i := 1 to Length(alphabet) do
    begin
      if alphabet[i] = letter_disk then
        number_disk := i;
    end;
    if DiskSize(number_disk) >= 0 then
    begin
      Disk2 := Trunc((((DiskSize(number_disk)
        div BtoGb) - (DiskFree(number_disk)
        div BtoGb)) / (DiskSize(number_disk)
        div BtoGb)) * 100);
      if ProgressDisk2.Position <> Disk2 then
        ProgressDisk2.Position := ProgressDisk2.Position + 1
      else
        TimerDisk2.Enabled := False;
    end
    else
    begin
      DiskNumber2.Caption := 'Error';
      DiskNumber2.Font.Color := clRed;
      ProgressDisk2.Position := 0;
    end;
  end;
end;

procedure TPhisicalMemoryForm.TimerShowTimer(Sender: TObject);
begin
  if AlphaBlendValue <> 255 then
    AlphaBlendValue := AlphaBlendValue + 5
  else
  begin
    TimerShow.Enabled := false;
    TimerDisk1.Enabled := true;
    TimerDisk2.Enabled := true;
  end;
end;

procedure TPhisicalMemoryForm.N5Click(Sender: TObject);
begin
  if N5.Checked = True then
  begin
    N5.Checked := False;
    PhisicalMemoryForm.FormStyle := fsNormal;
  end
  else
  begin
    n5.Checked := True;
    PhisicalMemoryForm.FormStyle := fsStayOnTop;
  end;
end;

procedure TPhisicalMemoryForm.N4Click(Sender: TObject);
var
  letter_disk1: string;
  letter_disk2: string;
begin
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    letter_disk1 := sIniFile.ReadString('Disk', 'Disk1', '');
    letter_disk2 := sIniFile.ReadString('Disk', 'Disk2', '');
    sIniFile.Free;
  end;
  PhisicalMemoryForm.DiskNumber1.Caption := letter_disk1 + ': 000/000 Gb';
  PhisicalMemoryForm.DiskNumber2.Caption := letter_disk2 + ': 000/000 Gb';
  PhisicalMemoryForm.TimerMesuareDiskSize.Enabled := false;
  PhisicalMemoryForm.ProgressDisk1.Position := 0;
  PhisicalMemoryForm.ProgressDisk2.Position := 0;
  PhisicalMemoryForm.TimerDisk1.Enabled := True;
  PhisicalMemoryForm.TimerDisk2.Enabled := True;
  PhisicalMemoryForm.TimerMesuareDiskSize.Enabled := true;
end;

procedure TPhisicalMemoryForm.Seldisk1Change(Sender: TObject);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteString('Disk', 'Disk1', Seldisk1.Text);
  sIniFile.Free;
  Seldisk1.Visible := False;
end;

procedure TPhisicalMemoryForm.DiskNumber1DblClick(Sender: TObject);
begin
  Seldisk1.Visible := true;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    Seldisk1.Text := sIniFile.ReadString('Disk', 'Disk1', '');
    sIniFile.Free;
  end;
end;

procedure TPhisicalMemoryForm.DiskNumber2DblClick(Sender: TObject);
begin
  Seldisk2.Visible := true;
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    Seldisk2.Text := sIniFile.ReadString('Disk', 'Disk2', '');
    sIniFile.Free;
  end;
end;

procedure TPhisicalMemoryForm.Seldisk2Change(Sender: TObject);
begin
  sIniFile := TIniFile.Create(pathINI);
  sIniFile.WriteString('Disk', 'Disk2', Seldisk2.Text);
  sIniFile.Free;
  Seldisk2.Visible := False;
end;

procedure TPhisicalMemoryForm.Seldisk1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    Seldisk1Change(PhisicalMemoryForm);
  end;
end;

procedure TPhisicalMemoryForm.Seldisk2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    Seldisk2Change(PhisicalMemoryForm);
  end;
end;

end.

