program Widgets;

uses
  Forms,
  Windows,
  MainFormSetting in 'MainFormSetting.pas' {MainForm},
  AboutApplication in 'AboutApplication.pas' {About};

{$R *.res}
function Check: boolean;
var
  HM :THandle;
begin
  HM:=OpenMutex(MUTEX_ALL_ACCESS, false, '�����_���_�������');
  Result:=(HM<>0);
  if HM=0 then CreateMutex(nil, false, '�����_���_�������');
end;
begin
  if Check then
    begin
      MessageBox (0, '��������� ��� ��������', '����������',
                  MB_OK or MB_ICONINFORMATION);
      exit;
    end;
  Application.Initialize;
  Application.ShowMainForm:=false;
  ShowWindow(Application.Handle, SW_HIDE);
  Application.Title := 'Widgets';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAbout, About);
  Application.Run;
end.

