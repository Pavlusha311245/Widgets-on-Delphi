unit MainFormSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, sSkinManager, ImgList, acAlphaImageList,
  ExtCtrlsX, ComCtrls, sTreeView, StdCtrls, sLabel, sEdit, sComboBox,
  Buttons, sBitBtn, Menus, sComboBoxes, IniFiles, TeeProcs, acArcControls,
  sUpDown, Registry, sCalculator, IBExtract, ShellAPI, acFloatCtrls, acMagn,
  sSpeedButton, sColorSelect, sPageControl, TntStdCtrls, acSlider;

type
  Tproc = procedure;
  TprocPos = procedure(pos: Integer; var x, y: integer; var userpos: Boolean);
  TMainForm = class(TForm)
    gradient: TsGradientPanel;
    skins: TsSkinManager;
    tray: TTrayIcon;
    images: TsAlphaImageList;
    trayPopup: TPopupMenu;
    E1: TMenuItem;
    ActiveWidget: TsBitBtn;
    RefreshWidget: TsBitBtn;
    selectWidget: TsTreeView;
    settingPanel: TsPanel;
    lbl1: TsLabel;
    lbl3: TsLabel;
    edt1: TsEdit;
    cbb1: TsComboBox;
    edt3: TsEdit;
    sknslctr1: TsSkinSelector;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    Author: TLabel;
    Version: TLabel;
    Info: TLabel;
    ShowSetting: TsBitBtn;
    N12: TMenuItem;
    topBtn: TsFloatButtons;
    Zoom: TsMagnifier;
    ShowZoom: TsBitBtn;
    editor: TsBitBtn;
    editorlbl: TLabel;
    editorStd: TOpenDialog;
    Selcolaccess: TsBitBtn;
    Selcolpanel: TsPanel;
    spgcntrl1: TsPageControl;
    stbsht1: TsTabSheet;
    stbsht2: TsTabSheet;
    Timer: TTimer;
    ActiveWidgLbl: TsLabel;
    UpdateWidget: TTimer;
    EditWidget: TsBitBtn;
    inforez: TTntLabel;
    verrez: TTntLabel;
    authorrez: TTntLabel;
    num_of_widgets: TsArcGauge;
    themes: TsComboBox;
    Pos: TTimer;
    PositionPanel: TsPanel;
    ChangePos: TsBitBtn;
    PreviewWidgets: TImage;
    FixPosiitionPanel: TsPanel;
    AnimSettingHide: TTimer;
    AnimSettingShow: TTimer;
    autorun: TsSlider;
    AutorunLbl: TsLabel;
    procedure E1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure ActiveWidgetClick(Sender: TObject);
    procedure trayDblClick(Sender: TObject);
    procedure sbtbtn4Click(Sender: TObject);
    procedure AddStart;
    procedure DelStart;
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure ShowSettingClick(Sender: TObject);
    procedure autorunClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N12Click(Sender: TObject);
    procedure selectWidgetClick(Sender: TObject);
    procedure sfltbtns1Items0Click(Sender: TObject);
    procedure sfltbtns1Items1Click(Sender: TObject);
    procedure ShowZoomClick(Sender: TObject);
    procedure editorClick(Sender: TObject);
    procedure SelcolaccessClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure UpdateWidgetTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure RefreshWidgetClick(Sender: TObject);
    procedure CheckWidget(path: string);
    procedure LoadingMetadata(path: string);
    function isPopupWidgetActive(path: string): boolean;
    procedure EditWidgetClick(Sender: TObject);
    procedure OpenWidgetSetting(path: string);
    procedure PosTimer(Sender: TObject);
    procedure ChangePosClick(Sender: TObject);
    procedure cbb1Change(Sender: TObject);
    procedure ChangeLocation(num: integer; path: string);
    procedure ChangePosFun;
    procedure ChangeTheme(numWidget: integer; color1, color2: string; R1, G1,
      B1: Integer; r2, g2, b2: integer; fontcolor: TColor);
    procedure LoadPosition(path: string; numWidget: integer);
    function isActive(path: string): boolean;
    procedure AnimSettingHideTimer(Sender: TObject);
    procedure AnimSettingShowTimer(Sender: TObject);
    procedure WriteCoord(pos: Integer; x, y: Integer; path: string);
    procedure ActiveCloseWidget(Proc_name_active, Proc_name_close: Pointer;
      path: string);
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
    procedure edt3KeyPress(Sender: TObject; var Key: Char);
    procedure N2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  siniFile: TIniFile;
  activeZoom: Boolean;
  pathINI,
    pathINIPhiscalMemory,
    pathINIDateAndTime,
    pathINIOpenFolder,
    pathINIOpenApp,
    pathINICPUUsage,
    pathINICalc,
    pathINICalendar: string;
implementation

{$R *.dfm}
////////////////////////////////////////////////////////////////////////////////
//DLL DateAndTime

procedure ShowDateAndTime; stdcall;
  external 'WSaF\DateAndTime.dll' name 'ShowDateAndTime';

procedure RefreshDateAndTime; stdcall;
  external 'WSaF\DateAndTime.dll' name 'RefreshDateAndTime';

procedure CloseDateAndTime; stdcall;
  external 'WSaF\DateAndTime.dll' name 'CloseDateAndTime';

procedure DateFormPos(x, y: integer; center: Boolean); stdcall;
  external 'WSaF\DateAndTime.dll' name 'FormPos';

procedure DateFormCoord(pos: Integer; var x, y: integer; var userpos: Boolean);
  stdcall;
  external 'WSaF\DateAndTime.dll' name 'FormCoord';

////////////////////////////////////////////////////////////////////////////////
//DLL CPUUsage

procedure ShowCpuUsage; stdcall;
  external 'WSaF\CpuUsage.dll' name 'ShowCpuUsage';

procedure RefreshCpuUsage; stdcall;
  external 'WSaF\CpuUsage.dll' name 'RefreshCpuUsage';

procedure CloseCpuUsage; stdcall;
  external 'WSaF\CpuUsage.dll' name 'CloseCpuUsage';

procedure CpuFormPos(x, y: integer; center: Boolean); stdcall;
  external 'WSaF\CpuUsage.dll' name 'FormPos';

procedure CPUFormCoord(pos: Integer; var x, y: integer; var userpos: Boolean);
  stdcall;
  external 'WSaF\CpuUsage.dll' name 'FormCoord';
////////////////////////////////////////////////////////////////////////////////
//DLL PhisicalMemory

procedure ShowPhisicalMemory; stdcall;
  external 'WSaF\PhisicalMemory.dll' name 'ShowPhisicalMemory';

procedure RefreshPhisicalMemory; stdcall;
  external 'WSaF\PhisicalMemory.dll' name 'RefreshPhisicalMemory';

procedure ClosePhisicalMemory; stdcall;
  external 'WSaF\PhisicalMemory.dll' name 'ClosePhisicalMemory';

procedure MemoryFormPos(x, y: integer; center: Boolean); stdcall;
  external 'WSaF\PhisicalMemory.dll' name 'FormPos';

procedure MemoryFormCoord(pos: Integer; var x, y: integer; var userpos:
  Boolean);
  stdcall;
  external 'WSaF\PhisicalMemory.dll' name 'FormCoord';
////////////////////////////////////////////////////////////////////////////////
//DLL OpenFolder

procedure ShowFolder; stdcall;
  external 'WSaF\OpenFolder.dll' name 'ShowFolder';

procedure RefreshFolder; stdcall;
  external 'WSaF\OpenFolder.dll' name 'RefreshFolder';

procedure CloseFolder; stdcall;
  external 'WSaF\OpenFolder.dll' name 'CloseFolder';

procedure FolderFormPos(x, y: integer; center: Boolean); stdcall;
  external 'WSaF\OpenFolder.dll' name 'FormPos';

procedure FolderFormCoord(pos: integer; var x, y: integer; var userpos:
  Boolean);
  stdcall;
  external 'WSaF\OpenFolder.dll' name 'FormCoord';
///////////////////////////////////////////////////////////////////////////////
//DLL OpenApp

procedure ShowApp; stdcall;
  external 'WSaF\OpenApp.dll' name 'ShowApp';

procedure RefreshApp; stdcall;
  external 'WSaF\OpenApp.dll' name 'RefreshApp';

procedure CloseApp; stdcall;
  external 'WSaF\OpenApp.dll' name 'CloseApp';

procedure AppFormPos(x, y: integer; center: Boolean); stdcall;
  external 'WSaF\OpenApp.dll' name 'FormPos';

procedure AppFormCoord(pos: Integer; var x, y: integer; var userpos: Boolean);
  stdcall;
  external 'WSaF\OpenApp.dll' name 'FormCoord';
////////////////////////////////////////////////////////////////////////////////
//DLL Calendar

procedure ShowCalendar; stdcall;
  external 'WSaF\Calendar.dll' name 'ShowCalendar';

procedure RefreshCalendar; stdcall;
  external 'WSaF\Calendar.dll' name 'RefreshCalendar';

procedure CloseCalendar; stdcall;
  external 'WSaF\Calendar.dll' name 'CloseCalendar';

procedure CalendarFormPos(x, y: integer; center: Boolean); stdcall;
  external 'WSaF\Calendar.dll' name 'FormPos';

procedure CalendarFormCoord(pos: Integer; var x, y: integer; var userpos:
  Boolean); stdcall;
  external 'WSaF\Calendar.dll' name 'FormCoord';
////////////////////////////////////////////////////////////////////////////////
//DLL Calculator

procedure ShowCalc; stdcall;
  external 'WSaF\Calculator.dll' name 'ShowCalc';

procedure RefreshCalc; stdcall;
  external 'WSaF\Calculator.dll' name 'RefreshCalc';

procedure CloseCalc; stdcall;
  external 'WSaF\Calculator.dll' name 'CloseCalc';

procedure CalculatorFormPos(x, y: integer; center: Boolean); stdcall;
  external 'WSaF\Calculator.dll' name 'FormPos';

procedure CalcFormCoord(pos: Integer; var x, y: integer; var userpos: Boolean);
  stdcall;
  external 'WSaF\Calculator.dll' name 'FormCoord';
////////////////////////////////////////////////////////////////////////////////

function RGB(r, g, b: Byte): COLORREF;
begin
  Result := r + g * 256 + b * 256 * 256;
end;

procedure TMainForm.E1Click(Sender: TObject);
begin
  //���������� ��������� �����
  sIniFile := TIniFile.Create(pathINI);
  siniFile.WriteString('Main', 'Skin', skins.SkinName);
  siniFile.Free;
  MainForm.Close;
end;

procedure TMainForm.AddStart;
var
  reg: tregistry;
begin
  //���������� ���������� � ������������
  reg := tregistry.create;
  reg.rootkey := HKEY_CURRENT_USER;
  reg.lazywrite := false;
  reg.openkey('software\microsoft\windows\currentversion\run', false);
  reg.writestring(Application.Title, Application.ExeName);
  reg.closekey;
  reg.free;
end;

procedure TMainForm.DelStart;
var
  reg: tregistry;
begin
  //�������� �� ������������
  reg := tregistry.create;
  reg.rootkey := HKEY_CURRENT_USER;
  if reg.openkey('software\microsoft\windows\currentversion\run', false) then
    reg.DeleteValue(Application.Title);
  reg.closekey;
  reg.free;
  //////////////////////////////////////////////////////////////////////////////
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  activeautorun: Boolean;
begin
  settingPanel.Top := 587;
  //���� � ���������� �������� � ������� �����
  pathINI := extractfilepath(application.ExeName) + '\Settings.ini';
  pathINIDateAndTime :=
    extractfilepath(application.ExeName) +
    '\WSaF\Settings\DateAndTimeSettings.ini';
  pathINICPUUsage :=
    extractfilepath(application.ExeName) +
    '\WSaF\Settings\CPUUsageSettings.ini';
  pathINIPhiscalMemory := extractfilepath(application.ExeName) +
    '\WSaF\Settings\PhisicalMemorySettings.ini';
  pathINIOpenFolder := extractfilepath(application.ExeName) +
    '\WSaF\Settings\OpenFolderSettings.ini';
  pathINIOpenApp := extractfilepath(application.ExeName) +
    '\WSaF\Settings\OpenAppSettings.ini';
  pathINICalc := extractfilepath(application.ExeName) +
    '\WSaF\Settings\CalculatorSettings.ini';
  pathINICalendar := extractfilepath(application.ExeName) +
    '\WSaF\Settings\CalendarSettings.ini';
  ////////////////////////////////////////////////////////////////////////////////
  //�������� �������� ��������
  skins.SkinDirectory := extractfilepath(application.ExeName) + '\Skins';
  editor.Glyph.LoadFromFile(extractfilepath(application.ExeName)
    + '\Images\EditorIcon.bmp');
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    //�������� ����
    skins.SkinName := siniFile.ReadString('Main', 'Skin', '');
    //  ���� �������� � �������� ����
    gradient.PaintData.Color1.Color := siniFile.ReadInteger('Theme',
      'ColorGradient1', 0000000);
    gradient.PaintData.Color2.Color := siniFile.ReadInteger('Theme',
      'ColorGradient2', 0000000);
    selectWidget.Color := siniFile.ReadInteger('Theme', 'ColorGradient1',
      0000000);
    themes.ItemIndex := sinifile.ReadInteger('Theme', 'NumTheme', 0);
    if (sinifile.ReadString('Theme', 'Color1', '') = 'black') or
      (siniFile.readstring('Theme', 'Color2', '') = 'black') then
      selectwidget.Font.Color := clwhite;
    //  �������� �� ���������� ���������� � ������������
    activeautorun := siniFile.ReadBool('Main', 'Autorun', false);
    if activeautorun = True then
    begin
      autorun.SliderOn := true;
      AddStart;
    end
    else
    begin
      autorun.SliderOn := false;
      DelStart;
    end;
    sIniFile.Free;
  end
  else
    showmessage('*.ini File not found!');
  skins.Active := True;
  num_of_widgets.Progress := 0;
  if FileExists(pathINIDateAndTime) then
  begin
    sIniFile := TIniFile.Create(pathINIDateAndTime);
    if sIniFile.ReadBool('State', 'Active', false) = True then
    begin
      ShowDateAndTime;
      num_of_widgets.Progress := num_of_widgets.Progress + 1;
      cbb1.ItemIndex := siniFile.ReadInteger('State', 'Active', 0);
    end;
    authorrez.Caption := siniFile.ReadString('Metadata', 'Author', '');
    verrez.Caption := siniFile.ReadString('Metadata', 'Version', '');
    inforez.Caption := siniFile.ReadString('Metadata', 'Info', '');
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  if FileExists(pathINICPUUsage) then
  begin
    sIniFile := TIniFile.Create(pathINICPUUsage);
    if sIniFile.ReadBool('State', 'Active', false) = True then
    begin
      ShowCpuUsage;
      num_of_widgets.Progress := num_of_widgets.Progress + 1;
    end;
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  if FileExists(pathINIPhiscalMemory) then
  begin
    sIniFile := TIniFile.Create(pathINIPhiscalMemory);
    if sIniFile.ReadBool('State', 'Active', false) = True then
    begin
      ShowPhisicalMemory;
      num_of_widgets.Progress := num_of_widgets.Progress + 1;
    end;
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  if FileExists(pathINIOpenFolder) then
  begin
    sIniFile := TIniFile.Create(pathINIOpenFolder);
    if sIniFile.ReadBool('State', 'Active', false) = True then
    begin
      ShowFolder;
      num_of_widgets.Progress := num_of_widgets.Progress + 1;
    end;
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  if FileExists(pathINIOpenApp) then
  begin
    sIniFile := TIniFile.Create(pathINIOpenApp);
    if sIniFile.ReadBool('State', 'Active', false) = True then
    begin
      ShowApp;
      num_of_widgets.Progress := num_of_widgets.Progress + 1;
    end;
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  if FileExists(pathINICalendar) then
  begin
    sIniFile := TIniFile.Create(pathINICalendar);
    if sIniFile.ReadBool('State', 'Active', false) = True then
    begin
      ShowCalendar;
      num_of_widgets.Progress := num_of_widgets.Progress + 1;
    end;
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  if FileExists(pathINICalc) then
  begin
    sIniFile := TIniFile.Create(pathINICalc);
    if sIniFile.ReadBool('State', 'Active', false) = True then
    begin
      ShowCalc;
      num_of_widgets.Progress := num_of_widgets.Progress + 1;
    end;
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
  MainForm.Show;
end;

procedure TMainForm.ActiveCloseWidget(Proc_name_active, Proc_name_close:
  Pointer; path: string);
begin
  if FileExists(path) then
  begin
    siniFile := TIniFile.Create(path);
    if siniFile.ReadBool('State', 'Active', false) = False then
    begin
      TProc(Proc_name_active);
      ActiveWidgLbl.Caption := '������ �������';
      timer.Enabled := true;
      cbb1.Enabled := true;
      cbb1.ItemIndex := siniFile.ReadInteger('Position', 'Location', 0);
//      edt1.Enabled := true;
//      edt3.Enabled := true;
    end
    else
    begin
      TProc(Proc_name_close);
      ActiveWidgLbl.Caption := '������ ������';
      timer.Enabled := true;
      cbb1.Text := '';
      cbb1.Enabled := false;
      edt1.Enabled := false;
      edt3.Enabled := false;
    end;
  end;
end;

procedure TMainForm.ActiveWidgetClick(Sender: TObject);
begin
  case selectWidget.Selected.AbsoluteIndex of
    0: ActiveCloseWidget(@ShowDateAndTime, @CloseDateAndTime,
        pathINIDateAndTime);
    1: ActiveCloseWidget(@ShowCpuUsage, @Closecpuusage, pathINICPUUsage);
    2: ActiveCloseWidget(@ShowPhisicalMemory, @ClosePhisicalMemory,
        pathINIPhiscalMemory);
    3: ActiveCloseWidget(@ShowFolder, @CloseFolder, pathINIOpenFolder);
    4: ActiveCloseWidget(@ShowApp, @CloseApp, pathINIOpenApp);
    5: ActiveCloseWidget(@ShowCalendar, @CloseCalendar, pathINICalendar);
    6: ActiveCloseWidget(@ShowCalc, @CloseCalc, pathINICalc);
  end;
end;

procedure TMainForm.trayDblClick(Sender: TObject);
begin
  MainForm.Show;
end;

procedure TMainForm.sbtbtn4Click(Sender: TObject);
begin
  MainForm.Visible := false;
end;

function TMainForm.isPopupWidgetActive(path: string): boolean;
begin
  if FileExists(path) then
  begin
    sIniFile := TIniFile.Create(path);
    result := sIniFile.ReadBool('State', 'Active', false);
    sIniFile.Free;
  end;
end;

procedure TMainForm.N5Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINIDateAndTime) = False then
  begin
    ShowDateAndTime;
    num_of_widgets.Progress := num_of_widgets.Progress + 1;
  end
  else
  begin
    CloseDateAndTime;
    num_of_widgets.Progress := num_of_widgets.Progress - 1;
  end;
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINICPUUsage) = False then
  begin
    ShowCpuUsage;
    num_of_widgets.Progress := num_of_widgets.Progress + 1;
  end
  else
  begin
    num_of_widgets.Progress := num_of_widgets.Progress - 1;
    CloseCpuUsage;
  end;
end;

procedure TMainForm.N7Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINIPhiscalMemory) = False then
  begin
    ShowPhisicalMemory;
    num_of_widgets.Progress := num_of_widgets.Progress + 1;
  end
  else
  begin
    ClosePhisicalMemory;
    num_of_widgets.Progress := num_of_widgets.Progress - 1;
  end;
end;

procedure TMainForm.N8Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINIOpenFolder) = False then
  begin
    ShowFolder;
    num_of_widgets.Progress := num_of_widgets.Progress + 1;
  end
  else
  begin
    CloseFolder;
    num_of_widgets.Progress := num_of_widgets.Progress - 1;
  end;
end;

procedure TMainForm.N9Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINIOpenApp) = False then
  begin
    ShowApp;
    num_of_widgets.Progress := num_of_widgets.Progress + 1;
  end
  else
  begin
    CloseApp;
    num_of_widgets.Progress := num_of_widgets.Progress - 1;
  end;
end;

procedure TMainForm.N10Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINICalendar) = False then
  begin
    ShowCalendar;
    num_of_widgets.Progress := num_of_widgets.Progress + 1;
  end
  else
  begin
    CloseCalendar;
    num_of_widgets.Progress := num_of_widgets.Progress - 1;
  end;
end;

procedure TMainForm.N11Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINICalc) = False then
    ShowCalc
  else
    CloseCalc;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  selectwidget.Selected := selectWidget.Items[0];
end;

procedure TMainForm.ShowSettingClick(Sender: TObject);
begin
  if settingPanel.Top = 463 then
  begin
    AnimSettingHide.Enabled := true;
    ShowSetting.Caption := '��������';
    sknslctr1.Enabled := false;
    themes.Enabled := False;
    cbb1.Enabled := false;
    edt1.Text := '';
    edt3.Text := '';
    edt1.Enabled := False;
    edt3.Enabled := false;
    Pos.Enabled := False;
  end;
  if settingPanel.Top = 587 then
  begin
    AnimSettingShow.Enabled := true;
    ShowSetting.Caption := '������';
  end;
end;

procedure TMainForm.autorunClick(Sender: TObject);
begin
  if autorun.SliderOn = false then
    AddStart
  else
    DelStart;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  siniFile := TInifile.Create(pathINI);
  siniFile.writeBool('Main', 'Autorun', autorun.SliderOn);
  siniFile.Free;
end;

procedure TMainForm.N12Click(Sender: TObject);
begin
  mainform.Show;
  if settingPanel.Top = 587 then
  begin
    AnimSettingShow.Enabled := true;
    ShowSetting.Caption := '������';
  end;
end;

procedure TMainForm.LoadingMetadata(path: string);
begin
  if FileExists(path) then
  begin
    sIniFile := TIniFile.Create(path);
    authorrez.Caption := siniFile.ReadString('metadata', 'Author',
      'unknown');
    verrez.Caption := siniFile.ReadString('metadata', 'version',
      'unknown');
    inforez.Caption := siniFile.ReadString('metadata', 'Info', 'unknown');
    if siniFile.ReadBool('State', 'Active', False) = true then
    begin
      cbb1.Enabled := true;
      cbb1.ItemIndex := siniFile.ReadInteger('Position', 'Location', 0);
    end
    else
    begin
      cbb1.ItemIndex := -1;
      cbb1.Enabled := false;
    end;

  end
  else
    showmessage('File not found!');
end;

procedure TMainForm.selectWidgetClick(Sender: TObject);
begin
  case selectWidget.Selected.AbsoluteIndex of
    0: LoadingMetadata(pathINIDateAndTime);
    1: LoadingMetadata(pathINICPUUsage);
    2: LoadingMetadata(pathINIPhiscalMemory);
    3: LoadingMetadata(pathINIOpenFolder);
    4: LoadingMetadata(pathINIOpenApp);
    5: LoadingMetadata(pathINICalendar);
    6: LoadingMetadata(pathINICalc);
  end;
end;

procedure TMainForm.sfltbtns1Items0Click(Sender: TObject);
begin
  MainForm.Visible := false;
end;

procedure TMainForm.sfltbtns1Items1Click(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TMainForm.ShowZoomClick(Sender: TObject);
begin
  Zoom.Execute();
end;

procedure TMainForm.editorClick(Sender: TObject);
var
  iconexe: TIcon;
  iconpath: string;
  i: TIcon;
  b: TBitmap;
begin
  if EditorStd.Execute then
    if FileExists(pathINI) then
    begin
      siniFile := TIniFile.Create(pathINI);
      siniFile.WriteString('Main', 'Editor', EditorStd.FileName);
      iconpath := EditorStd.FileName;
      i := tIcon.Create;
      b := tbitmap.Create;
      i.Handle := ExtractIcon(HInstance, PAnsiChar(iconpath), 0);
      b.Width := i.Width;
      b.Height := i.Height;
      b.Canvas.Draw(0, 0, i);
      b.SaveToFile(extractfilepath(application.ExeName)
        + '\Images\EditorIcon.bmp');
      editor.Glyph.LoadFromFile(extractfilepath(application.ExeName)
        + '\Images\EditorIcon.bmp');
      i := nil;
      b := nil;
      siniFile.Free;
    end;
end;

procedure TMainForm.ChangeTheme(numWidget: integer; color1, color2: string; R1,
  G1, B1: Integer; r2, g2, b2: integer; fontcolor: TColor);
begin
  siniFile := TIniFile.Create(pathINI);
  siniFile.WriteInteger('Theme', 'NumTheme', numWidget);
  siniFile.WriteString('Theme', 'Color1', color1);
  siniFile.WriteString('Theme', 'Color2', color2);
  siniFile.WriteInteger('Theme', 'ColorGradient1', RGB(r1, g1, b1));
  siniFile.WriteInteger('Theme', 'ColorGradient2', RGB(r2, g2, b2));
  siniFile.Free;
  gradient.PaintData.Color1.Color := RGB(r1, g1, b1);
  gradient.PaintData.Color2.Color := RGB(r2, g2, b2);
  selectWidget.Color := RGB(r1, g1, b1);
  selectwidget.Font.Color := fontcolor;
end;

procedure RefreshAll;
begin
  RefreshDateAndTime;
  RefreshCpuUsage;
  RefreshPhisicalMemory;
  RefreshFolder;
  RefreshApp;
  RefreshCalendar;
  RefreshCalc;
end;

procedure TMainForm.SelcolaccessClick(Sender: TObject);
begin
  case themes.ItemIndex of
    0: ChangeTheme(0, 'pink', 'purple', 255, 0, 255, 147, 39, 143, clblack);
    1: ChangeTheme(1, 'blue', 'purple', 0, 255, 255, 147, 39, 143, clblack);
    2: ChangeTheme(2, 'blue', 'white', 0, 255, 255, 255, 255, 255, clblack);
    3: ChangeTheme(3, 'black', 'red', 0, 0, 0, 255, 0, 0, clWhite);
    4: ChangeTheme(4, 'black', 'pink', 0, 0, 0, 212, 20, 90, clWhite);
    5: ChangeTheme(5, 'green', 'yellow', 0, 255, 0, 255, 255, 0, clblack);
    6: ChangeTheme(6, 'red', 'yellow', 255, 0, 0, 255, 255, 0, clblack);
    7: ChangeTheme(7, 'yellow', 'pink', 255, 255, 0, 255, 0, 255, clblack);
    8: ChangeTheme(8, 'white', 'red', 255, 255, 255, 255, 0, 0, clblack);
  end;
  RefreshAll;
  if spgcntrl1.ActivePageIndex = 0 then
  begin
    spgcntrl1.ActivePageIndex := 1;
    spgcntrl1.ActivePageIndex := 0;
  end
  else
  begin
    spgcntrl1.ActivePageIndex := 0;
    spgcntrl1.ActivePageIndex := 1;
  end;
  settingPanel.Visible := False;
  settingPanel.Visible := true;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  ActiveWidgLbl.Caption := '';
  if (ActiveWidgLbl.Caption = '') then
    timer.Enabled := false;
end;

procedure TMainForm.CheckWidget(path: string);
begin
  if FileExists(path) then
  begin
    sIniFile := TIniFile.Create(path);
    if siniFile.ReadBool('State', 'Active', false) = True then
    begin
      RefreshWidget.Enabled := True;
      ActiveWidget.Kind := bkAbort;
      ActiveWidget.Caption := '������� ������';
      //      edt1.Enabled := true;
      //      edt3.Enabled := true;
      cbb1.Enabled := true;
      ChangePos.Enabled := true;
    end
    else
    begin
      RefreshWidget.Enabled := False;
      ActiveWidget.Kind := bkYes;
      ActiveWidget.Caption := '������������ ������';
      cbb1.Text := '';
      edt1.Text := '';
      edt3.Text := '';
      cbb1.Enabled := false;
      edt1.Enabled := false;
      edt3.Enabled := false;
      ChangePos.Enabled := false;
    end;
  end
  else
    showmessage('File not found!');
end;

procedure TMainForm.UpdateWidgetTimer(Sender: TObject);
begin
  if selectWidget.Selected.AbsoluteIndex <> -1 then
  begin
    case selectWidget.Selected.AbsoluteIndex of
      0: CheckWidget(pathINIDateAndTime);
      1: CheckWidget(pathINICPUUsage);
      2: CheckWidget(pathINIPhiscalMemory);
      3: CheckWidget(pathINIOpenFolder);
      4: CheckWidget(pathINIOpenApp);
      5: CheckWidget(pathINICalendar);
      6: CheckWidget(pathINICalc);
    end;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  UpdateWidget.Enabled := true;
end;

procedure TMainForm.FormHide(Sender: TObject);
begin
  UpdateWidget.Enabled := false;
  settingPanel.top := 587;
  ShowSetting.Caption := '��������';
end;

procedure TMainForm.RefreshWidgetClick(Sender: TObject);
begin
  case selectwidget.Selected.AbsoluteIndex of
    0: RefreshDateAndTime;
    1: RefreshCpuUsage;
    2: RefreshPhisicalMemory;
    3: RefreshFolder;
    4: RefreshApp;
    5: RefreshCalendar;
    6: RefreshCalc;
  end;
end;

procedure TMainForm.OpenWidgetSetting(path: string);
var
  ans: PAnsiChar;
  editor: PAnsiChar;
begin
  ans := PAnsiChar(path);
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
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

procedure TMainForm.EditWidgetClick(Sender: TObject);
begin
  case selectWidget.Selected.AbsoluteIndex of
    0: OpenWidgetSetting(pathINIDateAndTime);
    1: OpenWidgetSetting(pathINICPUUsage);
    2: OpenWidgetSetting(pathINIPhiscalMemory);
    3: OpenWidgetSetting(pathINIOpenFolder);
    4: OpenWidgetSetting(pathINIOpenApp);
    5: OpenWidgetSetting(pathINICalendar);
    6: OpenWidgetSetting(pathINICalc);
  end;
end;

procedure TMainForm.WriteCoord(pos: Integer; x, y: Integer; path: string);
begin
  if FileExists(path) then
  begin
    siniFile := TIniFile.Create(path);
    if (siniFile.ReadInteger('Position', 'Left',
      0) = x) and (siniFile.ReadInteger('Position', 'Top',
      0) = y) then
    begin
      cbb1.ItemIndex := pos;
      siniFile.WriteInteger('Position', 'Location', pos);
    end;
  end;
end;

procedure TMainForm.LoadPosition(path: string; numWidget: integer);
var
  x, y: integer;
  userpos: Boolean;
begin
  if FileExists(path) then
  begin
    siniFile := TIniFile.Create(path);
    edt1.Text := IntToStr(siniFile.ReadInteger('Position', 'Left',
      0));
    edt3.Text := IntToStr(siniFile.ReadInteger('Position', 'Top',
      0));
    case numWidget of
      0:
        begin
          if isActive(pathINIDateAndTime) = true then
          begin
            DateFormCoord(5, x, y, userpos);
            if userpos <> true then
            begin
              DateFormCoord(0, x, y, userpos);
              Writecoord(0, x, y, pathINIDateAndTime);
              DateFormCoord(1, x, y, userpos);
              Writecoord(1, x, y, pathINIDateAndTime);
              DateFormCoord(2, x, y, userpos);
              Writecoord(2, x, y, pathINIDateAndTime);
              DateFormCoord(3, x, y, userpos);
              Writecoord(3, x, y, pathINIDateAndTime);
              DateFormCoord(4, x, y, userpos);
              Writecoord(4, x, y, pathINIDateAndTime);
            end
            else
            begin
              siniFile := TIniFile.Create(pathINIDateAndTime);
              cbb1.ItemIndex := 5;
              siniFile.WriteInteger('Position', 'Location', 5);
              siniFile.Free;
            end;
          end;
        end;
      1:
        begin
          if isActive(pathINICPUUsage) = true then
          begin
            CPUFormCoord(5, x, y, userpos);
            if userpos <> true then
            begin
              CPUFormCoord(0, x, y, userpos);
              Writecoord(0, x, y, pathINICPUUsage);
              CPUFormCoord(1, x, y, userpos);
              Writecoord(1, x, y, pathINICPUUsage);
              CPUFormCoord(2, x, y, userpos);
              Writecoord(2, x, y, pathINICPUUsage);
              CPUFormCoord(3, x, y, userpos);
              Writecoord(3, x, y, pathINICPUUsage);
              CPUFormCoord(4, x, y, userpos);
              Writecoord(4, x, y, pathINICPUUsage);
            end
            else
            begin
              siniFile := TIniFile.Create(pathINICPUUsage);
              cbb1.ItemIndex := 5;
              siniFile.WriteInteger('Position', 'Location', 5);
              siniFile.Free;
            end;
          end;
        end;
      2:
        begin
          if isActive(pathINIPhiscalMemory) = true then
          begin
            MemoryFormCoord(5, x, y, userpos);
            if userpos <> true then
            begin
              MemoryFormCoord(0, x, y, userpos);
              Writecoord(0, x, y, pathINIPhiscalMemory);
              MemoryFormCoord(1, x, y, userpos);
              Writecoord(1, x, y, pathINIPhiscalMemory);
              MemoryFormCoord(2, x, y, userpos);
              Writecoord(2, x, y, pathINIPhiscalMemory);
              MemoryFormCoord(3, x, y, userpos);
              Writecoord(3, x, y, pathINIPhiscalMemory);
              MemoryFormCoord(4, x, y, userpos);
              Writecoord(4, x, y, pathINIPhiscalMemory);
            end
            else
            begin
              siniFile := TIniFile.Create(pathINIPhiscalMemory);
              cbb1.ItemIndex := 5;
              siniFile.WriteInteger('Position', 'Location', 5);
              siniFile.Free;
            end;
          end;
        end;
      3:
        begin
          if isActive(pathINIOpenFolder) = true then
          begin
            FolderFormCoord(5, x, y, userpos);
            if userpos <> true then
            begin
              FolderFormCoord(0, x, y, userpos);
              Writecoord(0, x, y, pathINIOpenFolder);
              FolderFormCoord(1, x, y, userpos);
              Writecoord(1, x, y, pathINIOpenFolder);
              FolderFormCoord(2, x, y, userpos);
              Writecoord(2, x, y, pathINIOpenFolder);
              FolderFormCoord(3, x, y, userpos);
              Writecoord(3, x, y, pathINIOpenFolder);
              FolderFormCoord(4, x, y, userpos);
              Writecoord(4, x, y, pathINIOpenFolder);
            end
            else
            begin
              siniFile := TIniFile.Create(pathINIOpenFolder);
              cbb1.ItemIndex := 5;
              siniFile.WriteInteger('Position', 'Location', 5);
              siniFile.Free;
            end;
          end;
        end;
      4:
        begin
          if isActive(pathINIOpenApp) = true then
          begin
            AppFormCoord(5, x, y, userpos);
            if userpos <> true then
            begin
              AppFormCoord(0, x, y, userpos);
              Writecoord(0, x, y, pathINIOpenApp);
              AppFormCoord(1, x, y, userpos);
              Writecoord(1, x, y, pathINIOpenApp);
              AppFormCoord(2, x, y, userpos);
              Writecoord(2, x, y, pathINIOpenApp);
              AppFormCoord(3, x, y, userpos);
              Writecoord(3, x, y, pathINIOpenApp);
              AppFormCoord(4, x, y, userpos);
              Writecoord(4, x, y, pathINIOpenApp);
            end
            else
            begin
              siniFile := TIniFile.Create(pathINIOpenApp);
              cbb1.ItemIndex := 5;
              siniFile.WriteInteger('Position', 'Location', 5);
              siniFile.Free;
            end;
          end;
        end;
      5:
        begin
          if isActive(pathINICalendar) = true then
          begin
            CalendarFormCoord(5, x, y, userpos);
            if userpos <> true then
            begin
              CalendarFormCoord(0, x, y, userpos);
              Writecoord(0, x, y, pathINICalendar);
              CalendarFormCoord(1, x, y, userpos);
              Writecoord(1, x, y, pathINICalendar);
              CalendarFormCoord(2, x, y, userpos);
              Writecoord(2, x, y, pathINICalendar);
              CalendarFormCoord(3, x, y, userpos);
              Writecoord(3, x, y, pathINICalendar);
              CalendarFormCoord(4, x, y, userpos);
              Writecoord(4, x, y, pathINICalendar);
            end
            else
            begin
              siniFile := TIniFile.Create(pathINICalendar);
              cbb1.ItemIndex := 5;
              siniFile.WriteInteger('Position', 'Location', 5);
              siniFile.Free;
            end;
          end;
        end;
      6:
        begin
          if isActive(pathINICalc) = true then
          begin
            CalcFormCoord(5, x, y, userpos);
            if userpos <> true then
            begin
              CalcFormCoord(0, x, y, userpos);
              Writecoord(0, x, y, pathINICalc);
              CalcFormCoord(1, x, y, userpos);
              Writecoord(1, x, y, pathINICalc);
              CalcFormCoord(2, x, y, userpos);
              Writecoord(2, x, y, pathINICalc);
              CalcFormCoord(3, x, y, userpos);
              Writecoord(3, x, y, pathINICalc);
              CalcFormCoord(4, x, y, userpos);
              Writecoord(4, x, y, pathINICalc);
            end
            else
            begin
              siniFile := TIniFile.Create(pathINICalc);
              cbb1.ItemIndex := 5;
              siniFile.WriteInteger('Position', 'Location', 5);
              siniFile.Free;
            end;
          end;
        end;
    end;
  end;
end;

function TMainForm.isActive(path: string): boolean;
begin
  if FileExists(path) then
  begin
    siniFile := TIniFile.Create(path);
    if siniFile.ReadBool('State', 'Active', false) = True then
      result := True
    else
      result := False;
  end;
end;

procedure TMainForm.PosTimer(Sender: TObject);
var
  countActive: Integer;
begin
  if MainForm.Visible = True then
  begin
    if cbb1.focused = False then
    begin
      case selectWidget.Selected.AbsoluteIndex of
        0: LoadPosition(pathINIDateAndTime, 0);
        1: LoadPosition(pathinicpuusage, 1);
        2: LoadPosition(pathINIPhiscalMemory, 2);
        3: LoadPosition(pathINIOpenFolder, 3);
        4: LoadPosition(pathINIOpenApp, 4);
        5: LoadPosition(pathINICalendar, 5);
        6: LoadPosition(pathINICalc, 6);
      end;
    end;
  end;
  //  end;
  countActive := 0;
  if isActive(pathINIDateAndTime) = True then
    countActive := countActive + 1;
  if isActive(pathINICPUUsage) = True then
    countActive := countActive + 1;
  if isActive(pathINIPhiscalMemory) = True then
    countActive := countActive + 1;
  if isActive(pathINIOpenFolder) = True then
    countActive := countActive + 1;
  if isActive(pathINIOpenApp) = True then
    countActive := countActive + 1;
  if isActive(pathINICalendar) = True then
    countActive := countActive + 1;
  if isActive(pathINICalc) = True then
    countActive := countActive + 1;
  num_of_widgets.Progress := countActive;
end;

procedure TMainForm.ChangePosClick(Sender: TObject);
begin
  if pos.Enabled = true then
  begin
    ChangePos.Caption := '��������� ���������';
    pos.Enabled := False;
    edt1.ReadOnly := false;
    edt3.ReadOnly := false;
    edt1.Enabled := true;
    edt3.Enabled := true;
    cbb1.Enabled := False;
  end
  else
  begin
    if (StrToInt(edt1.Text) < 0) or (StrToInt(edt1.Text) > Screen.Width) and
      (StrToInt(edt3.Text) < 0) or (StrToInt(edt3.Text) > Screen.Height) then
    begin
      ShowMessage('����� �� ������� ������!');
      if StrToInt(edt1.Text) > Screen.Width then
        edt1.Text := IntToStr(0);
      if StrToInt(edt3.Text) > Screen.Height then
        edt3.Text := IntToStr(0);
    end
    else
    begin
      ChangePosFun;
      Pos.Enabled := true;
      ChangePos.Caption := '�������� ����������';
      edt1.ReadOnly := true;
      edt3.ReadOnly := true;
      edt1.Enabled := false;
      edt3.Enabled := false;
      cbb1.Enabled := true;
    end;
  end;
end;

procedure LocateFormPos(x, y: Integer; center: Boolean; status: integer;
  path: string; numWidget: integer);
begin
  case numWidget of
    0: DateFormPos(x, y, center);
    1: CpuFormPos(x, y, center);
    2: MemoryFormPos(x, y, center);
    3: FolderFormPos(x, y, center);
    4: AppFormPos(x, y, center);
    5: CalendarFormPos(x, y, center);
    6: CalculatorFormPos(x, y, center);
  end;
  siniFile := TIniFile.Create(path);
  siniFile.WriteInteger('Position', 'Location', status);
  siniFile.Free;
end;

procedure TMainForm.edt3KeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    '0'..'9': ;
    #8: ;
    #13: changepos.SetFocus;
  else
    Key := Chr(0);
  end;
end;

procedure TMainForm.ChangeLocation(num: integer; path: string);
begin
  if FileExists(path) then
  begin
    siniFile := TIniFile.Create(path);
    if siniFile.ReadBool('State', 'Active', false) = true then
    begin
      case cbb1.ItemIndex of
        0: LocateFormPos(0, 0, false, 0, path, num);
        1: LocateFormPos(Screen.Width, 0, False, 1,
            path, num);
        2:
          LocateFormPos(0, Screen.Height, False, 2,
            path, num);
        3:
          LocateFormPos(Screen.Width, Screen.Height, False,
            3, path, num);
        4: LocateFormPos(0, 0, true, 4,
            path, num);
        5:
          begin
            siniFile := TIniFile.Create(path);
            siniFile.WriteInteger('Position', 'Location', 5);
            siniFile.Free;
          end;
      end;
    end;
  end;
end;

procedure TMainForm.cbb1Change(Sender: TObject);
begin
  case selectWidget.Selected.AbsoluteIndex of
    0: ChangeLocation(0, pathINIDateAndTime);
    1: ChangeLocation(1, pathINICPUUsage);
    2: ChangeLocation(2, pathINIPhiscalMemory);
    3: ChangeLocation(3, pathINIOpenFolder);
    4: ChangeLocation(4, pathINIOpenApp);
    5: ChangeLocation(5, pathINICalendar);
    6: ChangeLocation(6, pathINICalc);
  end;
  selectWidget.SetFocus;
end;

procedure TMainForm.ChangePosFun;
begin
  case selectWidget.Selected.AbsoluteIndex of
    0: DateFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text), false);
    1: CpuFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text), false);
    2: MemoryFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text), false);
    3: FolderFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text), false);
    4: AppFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text), false);
    5: CalendarFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text), false);
    6: CalculatorFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text), false);
  end;
end;

procedure TMainForm.AnimSettingHideTimer(Sender: TObject);
begin
  if settingPanel.Top <> 587 then
    settingPanel.Top := settingPanel.Top + 4
  else
    AnimSettingHide.Enabled := False;
end;

procedure TMainForm.AnimSettingShowTimer(Sender: TObject);
begin
  if settingPanel.Top <> 463 then
    settingPanel.Top := settingPanel.Top - 4
  else
  begin
    AnimSettingShow.Enabled := False;
    sknslctr1.Enabled := True;
    themes.Enabled := True;
    cbb1.Enabled := true;
//    edt1.Enabled := true;
//    edt3.Enabled := true;
    Pos.Enabled := True;
  end;
end;

procedure TMainForm.edt1KeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    '0'..'9': ;
    #8: ;
    #13: edt3.SetFocus;
  else
    Key := Chr(0);
  end;
end;

procedure TMainForm.N2Click(Sender: TObject);
var
  ans: PAnsiChar;
  dir: string;
begin
  dir := extractfilepath(application.ExeName) +
    '\help.chm';
  ans := PAnsiChar(dir);
  ShellExecute(Handle, 'open', ans, nil, nil,
    SW_SHOW);
end;

end.

