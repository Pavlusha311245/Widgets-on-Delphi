unit AboutApplication;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, sSkinProvider;

type
  TAbout = class(TForm)
    lbl1: TTntLabel;
    lbl2: TTntLabel;
    lbl3: TTntLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  About: TAbout;

implementation

{$R *.dfm}

end.
