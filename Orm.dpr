program Orm;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fmMain},
  uAtrib in 'uAtrib.pas',
  uConnection in 'uConnection.pas',
  uCFG in '..\Exemplo\uCFG.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
