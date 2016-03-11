program PpFloodPipe;

uses
  Vcl.Forms,
  FloodPipe in 'FloodPipe.pas' {Form1},
  USettings in 'USettings.pas' {Form2},
  UConfig in 'UConfig.pas',
  URanking in 'URanking.pas' {Form3},
  ULogic in 'ULogic.pas',
  UDraw in 'UDraw.pas',
  UData in 'UData.pas',
  URankingData in 'URankingData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Main);
  Application.CreateForm(TForm2, Settings);
  Application.CreateForm(TForm3, Ranking);
  Application.Run;
end.
