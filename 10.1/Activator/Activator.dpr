{ KOL MCK } // Do not remove this line!
program Activator;

uses
KOL,
  FileUtils in 'FileUtils.pas',
  PatchData in 'PatchData.pas',
  WinUtils in 'WinUtils.pas',

  AnsiStrings in '..\Keygen\AnsiStrings.pas',

  DllData in '..\Keygen\DllData.pas',
  FGInt in '..\Keygen\FGInt.pas',
  RadKeygen in '..\Keygen\RadKeygen.pas',
  Sha1 in '..\Keygen\Sha1.pas',

  MainFrm in 'MainFrm.pas' {MainForm};

{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IF Defined(KOL_MCK)} {$I Activator_0.inc} {$ELSE}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

{$IFEND}

end.
