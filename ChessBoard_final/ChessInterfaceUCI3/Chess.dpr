program Chess;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  EngineCommunication in 'EngineCommunication.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
