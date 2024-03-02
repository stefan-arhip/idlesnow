program Project1;

uses
  Forms,
  SnowFlake in 'SnowFlake.pas' {SnowFlakeForm},
  main in 'main.pas' {MainForm},
  ChristmasTree in 'ChristmasTree.pas' {ChristmasTreeForm};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.Title := 'Christmas 2012 - created by Stefan Arhip'#13+
                       'Will snow after 60 seconds of inactivity';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TChristmasTreeForm, ChristmasTreeForm);
  Application.Run;
end.
