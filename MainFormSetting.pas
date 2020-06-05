unit MainFormSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, sSkinManager, ImgList, acAlphaImageList,
  ExtCtrlsX, ComCtrls, sTreeView, StdCtrls, sLabel, sEdit, sComboBox,
  Buttons, sBitBtn, Menus, sComboBoxes, IniFiles, TeeProcs, acArcControls,
  sUpDown, Registry, sCalculator, IBExtract, ShellAPI, acFloatCtrls, acMagn,
  sSpeedButton, sColorSelect, sPageControl, TntStdCtrls;

type
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
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    spdwn1: TsUpDown;
    spdwn2: TsUpDown;
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
    autorun: TCheckBox;
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
    procedure E1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure ActiveWidgetClick(Sender: TObject);
    procedure trayDblClick(Sender: TObject);
    procedure sbtbtn4Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure AddStart;
    procedure DelStart;
    procedure edt1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure gradientClick(Sender: TObject);
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

uses
  AboutApplication;

{$R *.dfm}
////////////////////////////////////////////////////////////////////////////////
//DLL DateAndTime

procedure ShowDateAndTime; stdcall;
  external 'WSaF\DateAndTime.dll' name 'ShowDateAndTime';

procedure RefreshDateAndTime; stdcall;
  external 'WSaF\DateAndTime.dll' name 'RefreshDateAndTime';

procedure CloseDateAndTime; stdcall;
  external 'WSaF\DateAndTime.dll' name 'CloseDateAndTime';

procedure DateFormPos(x, y: integer); stdcall;
  external 'WSaF\DateAndTime.dll' name 'FormPos';

////////////////////////////////////////////////////////////////////////////////
//DLL CPUUsage

procedure ShowCpuUsage; stdcall;
  external 'WSaF\CpuUsage.dll' name 'ShowCpuUsage';

procedure RefreshCpuUsage; stdcall;
  external 'WSaF\CpuUsage.dll' name 'RefreshCpuUsage';

procedure CloseCpuUsage; stdcall;
  external 'WSaF\CpuUsage.dll' name 'CloseCpuUsage';

procedure CpuFormPos(x, y: integer); stdcall;
  external 'WSaF\CpuUsage.dll' name 'FormPos';
////////////////////////////////////////////////////////////////////////////////
//DLL PhisicalMemory

procedure ShowPhisicalMemory; stdcall;
  external 'WSaF\PhisicalMemory.dll' name 'ShowPhisicalMemory';

procedure RefreshPhisicalMemory; stdcall;
  external 'WSaF\PhisicalMemory.dll' name 'RefreshPhisicalMemory';

procedure ClosePhisicalMemory; stdcall;
  external 'WSaF\PhisicalMemory.dll' name 'ClosePhisicalMemory';

procedure MemoryFormPos(x, y: integer); stdcall;
  external 'WSaF\PhisicalMemory.dll' name 'FormPos';
////////////////////////////////////////////////////////////////////////////////
//DLL OpenFolder

procedure ShowFolder; stdcall;
  external 'WSaF\OpenFolder.dll' name 'ShowFolder';

procedure RefreshFolder; stdcall;
  external 'WSaF\OpenFolder.dll' name 'RefreshFolder';

procedure CloseFolder; stdcall;
  external 'WSaF\OpenFolder.dll' name 'CloseFolder';

procedure FolderFormPos(x, y: integer); stdcall;
  external 'WSaF\OpenFolder.dll' name 'FormPos';
///////////////////////////////////////////////////////////////////////////////
//DLL OpenApp

procedure ShowApp; stdcall;
  external 'WSaF\OpenApp.dll' name 'ShowApp';

procedure RefreshApp; stdcall;
  external 'WSaF\OpenApp.dll' name 'RefreshApp';

procedure CloseApp; stdcall;
  external 'WSaF\OpenApp.dll' name 'CloseApp';

procedure AppFormPos(x, y: integer); stdcall;
  external 'WSaF\OpenApp.dll' name 'FormPos';
////////////////////////////////////////////////////////////////////////////////
//DLL Calendar

procedure ShowCalendar; stdcall;
  external 'WSaF\Calendar.dll' name 'ShowCalendar';

procedure RefreshCalendar; stdcall;
  external 'WSaF\Calendar.dll' name 'RefreshCalendar';

procedure CloseCalendar; stdcall;
  external 'WSaF\Calendar.dll' name 'CloseCalendar';

procedure CalendarFormPos(x, y: integer); stdcall;
  external 'WSaF\Calendar.dll' name 'FormPos';
////////////////////////////////////////////////////////////////////////////////
//DLL Calculator

procedure ShowCalc; stdcall;
  external 'WSaF\Calculator.dll' name 'ShowCalc';

procedure RefreshCalc; stdcall;
  external 'WSaF\Calculator.dll' name 'RefreshCalc';

procedure CloseCalc; stdcall;
  external 'WSaF\Calculator.dll' name 'CloseCalc';

procedure CalculatorFormPos(x, y: integer); stdcall;
  external 'WSaF\Calculator.dll' name 'FormPos';
////////////////////////////////////////////////////////////////////////////////

function RGB(r, g, b: Byte): COLORREF;
begin
  Result := r + g * 256 + b * 256 * 256;
end;

procedure TMainForm.E1Click(Sender: TObject);
begin
  //Сохранение активного скина
  sIniFile := TIniFile.Create(pathINI);
  siniFile.WriteString('Main', 'Skin', skins.SkinName);
  siniFile.Free;
  MainForm.Close;
end;

procedure TMainForm.AddStart;
var
  reg: tregistry;
begin
  //Добавление приложения в автозагрузку
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
  //Удаление из автозагрузки
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
  activeDate: Boolean;
  activeCPU: Boolean;
  activeMemory: Boolean;
  activeFolder: Boolean;
  activeApp: Boolean;
  activeCalendar: Boolean;
  activeCalc: Boolean;
  activeautorun: Boolean;
begin
  //Путь к настройкам виджетов и главной формы
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
  //Загрузка основных настроек
  skins.SkinDirectory := extractfilepath(application.ExeName) + '\Skins';
  editor.Glyph.LoadFromFile(extractfilepath(application.ExeName)
    + '\Images\EditorIcon.bmp');
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    skins.SkinName := siniFile.ReadString('Main', 'Skin', '');
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
    activeautorun := siniFile.ReadBool('Main', 'Autorun', false);
    if activeautorun = True then
    begin
      autorun.Checked := True;
      AddStart;
    end
    else
    begin
      autorun.Checked := false;
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

procedure TMainForm.ActiveWidgetClick(Sender: TObject);
begin
  case selectWidget.Selected.AbsoluteIndex of
    0:
      begin
        if FileExists(pathINIDateAndTime) then
        begin
          siniFile := TIniFile.Create(pathINIDateAndTime);
          if siniFile.ReadBool('State', 'Active', false) = False then
          begin
            ShowDateAndTime;
            ActiveWidgLbl.Caption := 'Виджет запущен';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress + 1;
          end
          else
          begin
            CloseDateAndTime;
            ActiveWidgLbl.Caption := 'Виджет закрыт';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress - 1;
          end;
          siniFile.Free;
        end;
      end;
    1:
      begin
        if FileExists(pathINICPUUsage) then
        begin
          siniFile := TIniFile.Create(pathINICPUUsage);
          if siniFile.ReadBool('State', 'Active', false) = False then
          begin
            ShowCpuUsage;
            ActiveWidgLbl.Caption := 'Виджет запущен';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress + 1;
          end
          else
          begin
            CloseCpuUsage;
            ActiveWidgLbl.Caption := 'Виджет закрыт';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress - 1;
          end;
          siniFile.Free;
        end;
      end;
    2:
      begin
        if FileExists(pathINIPhiscalMemory) then
        begin
          siniFile := TIniFile.Create(pathINIPhiscalMemory);
          if siniFile.ReadBool('State', 'Active', false) = False then
          begin
            ShowPhisicalMemory;
            ActiveWidgLbl.Caption := 'Виджет запущен';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress + 1;
          end
          else
          begin
            ClosePhisicalMemory;
            ActiveWidgLbl.Caption := 'Виджет закрыт';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress - 1;
          end;
          siniFile.Free;
        end;
      end;
    3:
      begin
        if FileExists(pathINIOpenFolder) then
        begin
          siniFile := TIniFile.Create(pathINIOpenFolder);
          if siniFile.ReadBool('State', 'Active', false) = False then
          begin
            ShowFolder;
            ActiveWidgLbl.Caption := 'Виджет запущен';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress + 1;
          end
          else
          begin
            CloseFolder;
            ActiveWidgLbl.Caption := 'Виджет закрыт';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress - 1;
          end;
          siniFile.Free;
        end;
      end;
    4:
      begin
        if FileExists(pathINIOpenApp) then
        begin
          siniFile := TIniFile.Create(pathINIOpenApp);
          if siniFile.ReadBool('State', 'Active', false) = False then
          begin
            ShowApp;
            ActiveWidgLbl.Caption := 'Виджет запущен';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress + 1;
          end
          else
          begin
            CloseApp;
            ActiveWidgLbl.Caption := 'Виджет закрыт';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress - 1;
          end;
          siniFile.Free;
        end;
      end;
    5:
      begin
        if FileExists(pathINICalendar) then
        begin
          siniFile := TIniFile.Create(pathINICalendar);
          if siniFile.ReadBool('State', 'Active', false) = False then
          begin
            ShowCalendar;
            ActiveWidgLbl.Caption := 'Виджет запущен';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress + 1;
          end
          else
          begin
            CloseCalendar;
            ActiveWidgLbl.Caption := 'Виджет закрыт';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress - 1;
          end;
          siniFile.Free;
        end;
      end;
    6:
      begin
        if FileExists(pathINICalc) then
        begin
          siniFile := TIniFile.Create(pathINICalc);
          if siniFile.ReadBool('State', 'Active', false) = False then
          begin
            ShowCalc;
            ActiveWidgLbl.Caption := 'Виджет запущен';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress + 1;
          end
          else
          begin
            CloseCalc;
            ActiveWidgLbl.Caption := 'Виджет закрыт';
            timer.Enabled := true;
            num_of_widgets.Progress := num_of_widgets.Progress - 1;
          end;
          siniFile.Free;
        end;
      end;
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

procedure TMainForm.N1Click(Sender: TObject);
begin
  AboutApplication.About.Show;
end;

procedure TMainForm.edt1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //изменение координат виджета по оси X
  if Key = 13 then
  begin
    case selectWidget.Selected.AbsoluteIndex of
      0: DateFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      1: CpuFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      2: MemoryFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      3: FolderFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      4: AppFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      5: CalendarFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      6: CalculatorFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
    end;
  end;
end;

procedure TMainForm.edt3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //изменение координат виджета по оси Y
  if Key = 13 then
  begin
    case selectWidget.Selected.AbsoluteIndex of
      0: DateFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      1: CpuFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      2: MemoryFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      3: FolderFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      4: AppFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      5: CalendarFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
      6: CalculatorFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
    end;
  end;
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
    ShowDateAndTime
  else
    CloseDateAndTime;
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINICPUUsage) = False then
    ShowCpuUsage
  else
    CloseCpuUsage;
end;

procedure TMainForm.N7Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINIPhiscalMemory) = False then
    ShowPhisicalMemory
  else
    ClosePhisicalMemory;
end;

procedure TMainForm.N8Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINIOpenFolder) = False then
    ShowFolder
  else
    CloseFolder;
end;

procedure TMainForm.N9Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINIOpenApp) = False then
    ShowApp
  else
    CloseApp;
end;

procedure TMainForm.N10Click(Sender: TObject);
begin
  if isPopupWidgetActive(pathINICalendar) = False then
    ShowCalendar
  else
    CloseCalendar;
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
  if settingPanel.Visible = True then
  begin
    settingPanel.Visible := False;
    ShowSetting.caption := 'Показать';
  end
  else
  begin
    settingPanel.Visible := True;
    ShowSetting.Caption := 'Скрыть';
  end;
end;

procedure TMainForm.autorunClick(Sender: TObject);
begin
  if autorun.Checked = True then
    AddStart
  else
    DelStart;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  siniFile := TInifile.Create(pathINI);
  siniFile.writeBool('Main', 'Autorun', autorun.Checked);
  siniFile.Free;
end;

procedure TMainForm.N12Click(Sender: TObject);
begin
  mainform.Show;
  if settingPanel.Visible = False then
  begin
    settingPanel.Visible := True;
    ShowSetting.caption := 'Скрыть';
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
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
end;

procedure TMainForm.selectWidgetClick(Sender: TObject);
begin
  settingPanel.Visible := false;
  ShowSetting.Caption := 'Показать';
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

procedure TMainForm.SelcolaccessClick(Sender: TObject);
begin
  case themes.ItemIndex of
    0:
      begin
        siniFile := TIniFile.Create(pathINI);
        siniFile.WriteInteger('Theme', 'NumTheme', 0);
        siniFile.WriteString('Theme', 'Color1', 'pink');
        siniFile.WriteString('Theme', 'Color2', 'purple');
        siniFile.WriteInteger('Theme', 'ColorGradient1', RGB(255, 0, 255));
        siniFile.WriteInteger('Theme', 'ColorGradient2', RGB(147, 39, 143));
        siniFile.Free;
        gradient.PaintData.Color1.Color := RGB(255, 0, 255);
        gradient.PaintData.Color2.Color := RGB(147, 39, 143);
        selectWidget.Color := RGB(255, 0, 255);
        selectwidget.Font.Color := clblack;
      end;
    1:
      begin
        siniFile := TIniFile.Create(pathINI);
        siniFile.WriteInteger('Theme', 'NumTheme', 1);
        siniFile.WriteString('Theme', 'Color1', 'blue');
        siniFile.WriteString('Theme', 'Color2', 'purple');
        siniFile.WriteInteger('Theme', 'ColorGradient1', RGB(0, 255, 255));
        siniFile.WriteInteger('Theme', 'ColorGradient2', RGB(147, 39, 143));
        siniFile.Free;
        gradient.PaintData.Color1.Color := RGB(0, 255, 255);
        gradient.PaintData.Color2.Color := RGB(147, 39, 143);
        selectWidget.Color := RGB(0, 255, 255);
        selectwidget.Font.Color := clblack;
      end;
    2:
      begin
        siniFile := TIniFile.Create(pathINI);
        siniFile.WriteInteger('Theme', 'NumTheme', 2);
        siniFile.WriteString('Theme', 'Color1', 'blue');
        siniFile.WriteString('Theme', 'Color2', 'white');
        siniFile.WriteInteger('Theme', 'ColorGradient1', RGB(0, 255, 255));
        siniFile.WriteInteger('Theme', 'ColorGradient2', RGB(255, 255, 255));
        siniFile.Free;
        gradient.PaintData.Color1.Color := RGB(0, 255, 255);
        gradient.PaintData.Color2.Color := RGB(255, 255, 255);
        selectWidget.Color := RGB(0, 255, 255);
        selectwidget.Font.Color := clblack;
      end;
    3:
      begin
        siniFile := TIniFile.Create(pathINI);
        siniFile.WriteInteger('Theme', 'NumTheme', 3);
        siniFile.WriteString('Theme', 'Color1', 'black');
        siniFile.WriteString('Theme', 'Color2', 'red');
        siniFile.WriteInteger('Theme', 'ColorGradient1', RGB(0, 0, 0));
        siniFile.WriteInteger('Theme', 'ColorGradient2', RGB(255, 0, 0));
        siniFile.Free;
        gradient.PaintData.Color1.Color := RGB(0, 0, 0);
        gradient.PaintData.Color2.Color := RGB(255, 0, 0);
        selectWidget.Color := RGB(0, 0, 0);
        selectwidget.Font.Color := clwhite;
      end;
    4:
      begin
        siniFile := TIniFile.Create(pathINI);
        siniFile.WriteInteger('Theme', 'NumTheme', 4);
        siniFile.WriteString('Theme', 'Color1', 'black');
        siniFile.WriteString('Theme', 'Color2', 'pink');
        siniFile.WriteInteger('Theme', 'ColorGradient1', RGB(0, 0, 0));
        siniFile.WriteInteger('Theme', 'ColorGradient2', RGB(212, 20, 90));
        siniFile.Free;
        gradient.PaintData.Color1.Color := RGB(0, 0, 0);
        gradient.PaintData.Color2.Color := RGB(212, 20, 90);
        selectWidget.Color := RGB(0, 0, 0);
        selectwidget.Font.Color := clWhite;
      end;
    5:
      begin
        siniFile := TIniFile.Create(pathINI);
        siniFile.WriteInteger('Theme', 'NumTheme', 5);
        siniFile.WriteString('Theme', 'Color1', 'green');
        siniFile.WriteString('Theme', 'Color2', 'yellow');
        siniFile.WriteInteger('Theme', 'ColorGradient1', RGB(0, 255, 0));
        siniFile.WriteInteger('Theme', 'ColorGradient2', RGB(255, 255, 0));
        siniFile.Free;
        gradient.PaintData.Color1.Color := RGB(0, 255, 0);
        gradient.PaintData.Color2.Color := RGB(255, 255, 0);
        selectWidget.Color := RGB(0, 255, 0);
        selectwidget.Font.Color := clblack;
      end;
    6:
      begin
        siniFile := TIniFile.Create(pathINI);
        siniFile.WriteInteger('Theme', 'NumTheme', 6);
        siniFile.WriteString('Theme', 'Color1', 'red');
        siniFile.WriteString('Theme', 'Color2', 'yellow');
        siniFile.WriteInteger('Theme', 'ColorGradient1', RGB(255, 0, 0));
        siniFile.WriteInteger('Theme', 'ColorGradient2', RGB(255, 255, 0));
        siniFile.Free;
        gradient.PaintData.Color1.Color := RGB(255, 0, 0);
        gradient.PaintData.Color2.Color := RGB(255, 255, 0);
        selectWidget.Color := RGB(255, 0, 0);
        selectwidget.Font.Color := clblack;
      end;
    7:
      begin
        siniFile := TIniFile.Create(pathINI);
        siniFile.WriteInteger('Theme', 'NumTheme', 7);
        siniFile.WriteString('Theme', 'Color1', 'yellow');
        siniFile.WriteString('Theme', 'Color2', 'pink');
        siniFile.WriteInteger('Theme', 'ColorGradient1', RGB(255, 255, 0));
        siniFile.WriteInteger('Theme', 'ColorGradient2', RGB(255, 0, 255));
        siniFile.Free;
        gradient.PaintData.Color1.Color := RGB(255, 255, 0);
        gradient.PaintData.Color2.Color := RGB(255, 0, 255);
        selectWidget.Color := RGB(255, 255, 0);
        selectwidget.Font.Color := clblack;
      end;
    8:
      begin
        siniFile := TIniFile.Create(pathINI);
        siniFile.WriteInteger('Theme', 'NumTheme', 8);
        siniFile.WriteString('Theme', 'Color1', 'white');
        siniFile.WriteString('Theme', 'Color2', 'red');
        siniFile.WriteInteger('Theme', 'ColorGradient1', RGB(255, 255, 255));
        siniFile.WriteInteger('Theme', 'ColorGradient2', RGB(255, 0, 0));
        siniFile.Free;
        gradient.PaintData.Color1.Color := RGB(255, 255, 255);
        gradient.PaintData.Color2.Color := RGB(255, 0, 0);
        selectWidget.Color := RGB(255, 255, 255);
        selectwidget.Font.Color := clblack;
      end;
  end;
  RefreshDateAndTime;
  RefreshCpuUsage;
  RefreshPhisicalMemory;
  RefreshFolder;
  RefreshApp;
  RefreshCalendar;
  RefreshCalc;
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
      ActiveWidget.Caption := 'Закрыть виджет';
    end
    else
    begin
      RefreshWidget.Enabled := False;
      ActiveWidget.Kind := bkYes;
      ActiveWidget.Caption := 'Активировать виджет';
    end;
    sIniFile.Free;
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

procedure TMainForm.gradientClick(Sender: TObject);
begin
  settingPanel.Visible := false;
  ShowSetting.Caption := 'Показать';
end;

end.

