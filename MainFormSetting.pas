unit MainFormSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, sSkinManager, ImgList, acAlphaImageList,
  ExtCtrlsX, ComCtrls, sTreeView, StdCtrls, sLabel, sEdit, sComboBox,
  Buttons, sBitBtn, Menus, sComboBoxes, IniFiles, TeeProcs, acArcControls,
  sUpDown, Registry, sCalculator, IBExtract, ShellAPI;

type
  TMainForm = class(TForm)
    gradientMainForm: TsGradientPanel;
    skins: TsSkinManager;
    tray: TTrayIcon;
    imagesMainForm: TsAlphaImageList;
    TrayPopup: TPopupMenu;
    E1: TMenuItem;
    ActiveWidget: TsBitBtn;
    RefreshWidget: TsBitBtn;
    CloseWidget: TsBitBtn;
    selectWidgetMainForm: TsTreeView;
    settingPanelMainForm: TsPanel;
    lbl1: TsLabel;
    lbl3: TsLabel;
    edt1: TsEdit;
    cbb1: TsComboBox;
    edt3: TsEdit;
    sknslctr1: TsSkinSelector;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    sbtbtn4: TsBitBtn;
    spdwn1: TsUpDown;
    spdwn2: TsUpDown;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure E1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure ActiveWidgetClick(Sender: TObject);
    procedure CloseWidgetClick(Sender: TObject);
    procedure RefreshWidgetClick(Sender: TObject);
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  siniFile: TIniFile;
  pathINI,
    pathINIPhiscalMemory,
    pathINIDateAndTime,
    pathINIOpenFolder,
    pathINIOpenApp,
    pathINICPUUsage: string;
implementation

uses
  AboutApplication;

{$R *.dfm}
//procedure pathDLL(var path:string);
//begin
//  path:=extractfilepath(application.ExeName)+path;
//end;
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

procedure TMainForm.E1Click(Sender: TObject);
begin
  //Сохранение активного скина
  sIniFile := TIniFile.Create(pathINI);
  siniFile.WriteString('Main', 'Skin', skins.SkinName);
  siniFile.Free;
  MainForm.Close;
  ////////////////////////////////////////////////////////////////////////////////
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
  ////////////////////////////////////////////////////////////////////////////////
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
  ////////////////////////////////////////////////////////////////////////////////
//Загрузка скина и виджетов
  skins.SkinDirectory := extractfilepath(application.ExeName) + '\Skins';
  if FileExists(pathINI) then
  begin
    sIniFile := TIniFile.Create(pathINI);
    skins.SkinName := siniFile.ReadString('Main', 'Skin', '');
    sIniFile.Free;
  end
  else
    showmessage('*.ini File not found!');
  skins.Active := True;
  if FileExists(pathINIDateAndTime) then
  begin
    sIniFile := TIniFile.Create(pathINIDateAndTime);
    activeDate := sIniFile.ReadBool('State', 'Active', false);
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  if FileExists(pathINICPUUsage) then
  begin
    sIniFile := TIniFile.Create(pathINICPUUsage);
    activeCPU := sIniFile.ReadBool('State', 'Active', false);
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  if FileExists(pathINIPhiscalMemory) then
  begin
    sIniFile := TIniFile.Create(pathINIPhiscalMemory);
    activeMemory := sIniFile.ReadBool('State', 'Active', false);
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  if FileExists(pathINIOpenFolder) then
  begin
    sIniFile := TIniFile.Create(pathINIOpenFolder);
    activeFolder := sIniFile.ReadBool('State', 'Active', false);
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  if FileExists(pathINIOpenApp) then
  begin
    sIniFile := TIniFile.Create(pathINIOpenApp);
    activeApp := sIniFile.ReadBool('State', 'Active', false);
    sIniFile.Free;
  end
  else
    showmessage('File not found!');
  if activeDate = True then
    ShowDateAndTime;
  if activeCPU = True then
    ShowCpuUsage;
  if activeMemory = True then
    ShowPhisicalMemory;
  if activeFolder = True then
    ShowFolder;
  if activeApp = true then
    ShowApp;
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
  MainForm.Show;
end;

procedure TMainForm.ActiveWidgetClick(Sender: TObject);
begin
  case selectWidgetMainForm.Selected.AbsoluteIndex of
    0: ShowDateAndTime;
    1: ShowCpuUsage;
    2: ShowPhisicalMemory;
    3: ShowFolder;
    4: ShowApp;
    5: ShowCalendar;
    6: ShowCalc;
  end;
end;

procedure TMainForm.RefreshWidgetClick(Sender: TObject);
begin
  case selectWidgetMainForm.Selected.AbsoluteIndex of
    0: RefreshDateAndTime;
    1: RefreshCpuUsage;
    2: RefreshPhisicalMemory;
    3: RefreshFolder;
    4: RefreshApp;
    5: RefreshCalendar;
    6: RefreshCalc;
  end;
end;

procedure TMainForm.CloseWidgetClick(Sender: TObject);
begin
  case selectWidgetMainForm.Selected.AbsoluteIndex of
    0: CloseDateAndTime;
    1: CloseCpuUsage;
    2: ClosePhisicalMemory;
    3: CloseFolder;
    4: CloseApp;
    5: CloseCalendar;
    6: CloseCalc;
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
  if Key = 13 then
  begin
    case selectWidgetMainForm.Selected.AbsoluteIndex of
      0:
        begin
          DateFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
        end;
      1:
        begin
          CpuFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
        end;
      2:
        begin
          MemoryFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
        end;
      3:
        begin
          FolderFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
        end;
      4:
        begin
          AppFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
        end;
    end;
  end;
end;

procedure TMainForm.edt3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
  begin
    case selectWidgetMainForm.Selected.AbsoluteIndex of
      0:
        begin
          DateFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
        end;
      1:
        begin
          CpuFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
        end;
      2:
        begin
          MemoryFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
        end;
      3:
        begin
          FolderFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
        end;
      4:
        begin
          AppFormPos(StrToInt(edt1.Text), StrToInt(edt3.Text));
        end;
    end;
  end;
end;

procedure TMainForm.N5Click(Sender: TObject);
var
  active: Boolean;
begin
  if FileExists(pathINIDateAndTime) then
  begin
    sIniFile := TIniFile.Create(pathINIDateAndTime);
    active := sIniFile.ReadBool('State', 'Active', false);
    sIniFile.Free;
  end;
  if active = False then
    ShowDateAndTime
  else
    CloseDateAndTime;
end;

procedure TMainForm.N6Click(Sender: TObject);
var
  active: boolean;
begin
  if FileExists(pathINICPUUsage) then
  begin
    sIniFile := TIniFile.Create(pathINICPUUsage);
    active := sIniFile.ReadBool('State', 'Active', false);
    sIniFile.Free;
  end;
  if active = False then
    ShowCpuUsage
  else
    CloseCpuUsage;
end;

procedure TMainForm.N7Click(Sender: TObject);
var
  active: boolean;
begin
  if FileExists(pathINIPhiscalMemory) then
  begin
    sIniFile := TIniFile.Create(pathINIPhiscalMemory);
    active := sIniFile.ReadBool('State', 'Active', false);
    sIniFile.Free;
  end;
  if active = False then
    ShowPhisicalMemory
  else
    ClosePhisicalMemory;
end;

procedure TMainForm.N8Click(Sender: TObject);
var
  active: boolean;
begin
  if FileExists(pathINIOpenFolder) then
  begin
    sIniFile := TIniFile.Create(pathINIOpenFolder);
    active := sIniFile.ReadBool('State', 'Active', false);
    sIniFile.Free;
  end;
  if active = False then
    ShowFolder
  else
    CloseFolder;
end;

procedure TMainForm.N9Click(Sender: TObject);
var
  active: boolean;
begin
  if FileExists(pathINIOpenApp) then
  begin
    sIniFile := TIniFile.Create(pathINIOpenApp);
    active := sIniFile.ReadBool('State', 'Active', false);
    sIniFile.Free;
  end;
  if active = False then
    ShowApp
  else
    CloseApp;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  selectwidgetmainform.Selected:=selectWidgetMainForm.Items[0];
  selectWidgetMainForm.SetFocus;
end;

end.

