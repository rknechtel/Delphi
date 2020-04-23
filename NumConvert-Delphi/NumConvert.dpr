program NumConvert;

uses
  QForms,
  NumCvt in 'NumCvt.pas' {frmHex2Dec};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmHex2Dec, frmHex2Dec);
  Application.Run;
end.
