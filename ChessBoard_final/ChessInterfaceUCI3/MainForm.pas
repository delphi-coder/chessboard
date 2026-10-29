unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EngineCommunication, ExtCtrls, Buttons, ComCtrls,
  SyncObjs, Menus, IniFiles, Spin, ChessBoard, ChessTypes;

const
  ENG_STR_RECIEVED = WM_USER + 1;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    ClearScreen1: TMenuItem;
    EngineOutputMemo: TMemo;
    OpenDialog: TOpenDialog;
    ChessBoard: TChessBoard;
    Panel1: TPanel;
    LogGUIEngineActivityCheckBox: TCheckBox;
    Button1: TButton;
    MoveListEdit: TEdit;
    SpinEdit1: TSpinEdit;
    PositionEdit: TEdit;
    FilterUnwantedlogs: TCheckBox;
    UndoButton: TButton;
    NewGameButton: TButton;
    InitUCIButton: TButton;
    ComputerPlaysBlackCheckBox: TRadioButton;
    WhiteOnTop: TCheckBox;
    ComputerPlaysWhiteCheckBox: TRadioButton;
    ChangeEngineButton: TButton;
    SendCmdToEngineButton: TButton;
    Edit1: TEdit;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button12: TButton;
    Button13: TButton;
    chkWCastleQueenSide: TCheckBox;
    chkWCastleKingSide: TCheckBox;
    chkBCastleKingSide: TCheckBox;
    chkBCastleQueenSide: TCheckBox;
    RadioGroup1: TRadioGroup;
    Button11: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    EngineMoveButton: TButton;
    chkPlayWithEngine: TCheckBox;
    HighLightPVCheckBox: TCheckBox;
    StayOnTopCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SendGoToEngineButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendCmdToEngineButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure MinimizeButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure LogGUIEngineActivityCheckBoxClick(Sender: TObject);
    procedure ClearScreen1Click(Sender: TObject);
    procedure ChangeEngineButtonClick(Sender: TObject);
    procedure WhiteOnTopClick(Sender: TObject);
    procedure InitUCIButtonClick(Sender: TObject);
    procedure NewGameButtonClick(Sender: TObject);
    procedure UndoButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PieceButtonsClick(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure EngineMoveButtonClick(Sender: TObject);
    procedure HighLightPVCheckBoxClick(Sender: TObject);
    procedure StayOnTopCheckBoxClick(Sender: TObject);
    procedure ChessBoardLegalMove(Sender: TObject; MoveStr: string);
  private
    { Private declarations }
    EngineStrList: TStringList;
    EngineStrListCriticalSection: TCriticalSection;
    EnginCommunicator: TEngineCommunication;
    LogFileCriticalSection: TCriticalSection;
    LogFileStream: TFileStream;
    FMoveList: TStringList;
    FLogCommunication: Boolean;
    FPromotionPiece: AnsiChar;
    procedure EngineStringRecieved(var Msg: TMessage); message ENG_STR_RECIEVED;
    procedure OnEngineStringRecieved(Str: AnsiString);
    procedure AddToLogFile(Str: AnsiString);
    procedure SetLogCommunication(const Value: Boolean);
    procedure DoEngineMove(Str: AnsiString);
  protected
  public
    { Public declarations }
    GameMode: Integer;
    StartFen: AnsiString;
    FLastPosCommand: AnsiString;
    FLastBestMove: AnsiString;
    FLastPonder: AnsiString;
    Started: Boolean;
    FIgnoreBestMoveFromEngine: Boolean;
    EngineFileName: string;
    FLastEngineMove: AnsiString;
    FHashSize: Integer;
    FThreads: Integer;
    property LogCommunication: Boolean read FLogCommunication write SetLogCommunication;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function AsciiLowerText(const S: AnsiString): AnsiString;
var
  I: Integer;
begin
  Result := S;
  for I := 1 to Length(Result) do
    if (Result[I] >= 'A') and (Result[I] <= 'Z') then
      Result[I] := AnsiChar(Ord(Result[I]) + 32);
end;

procedure StartEngineThread(AThread: TThread);
begin
{$IFDEF UNICODE}
  AThread.Start;
{$ELSE}
  AThread.Resume;
{$ENDIF}
end;

procedure TForm1.FormShow(Sender: TObject);
var
  IniFile: TIniFile;
begin
  GameMode := 1;
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  EngineFileName := IniFile.ReadString('UCIIntermediator','Engine',ExtractFilePath(Application.ExeName) + '..\engines\Pawnora.exe');
  FHashSize := IniFile.ReadInteger('Engine','Hash',32);
  FThreads := IniFile.ReadInteger('Engine','Threads',1);
  IniFile.Free;
  EnginCommunicator := TEngineCommunication.Create(True,EngineFileName);
  EnginCommunicator.OnStringRecieved := OnEngineStringRecieved;
  StartEngineThread(EnginCommunicator);

  EngineStrList := TStringList.Create;
  EngineStrListCriticalSection := TCriticalSection.Create;
  FMoveList := TStringList.Create;
  FMoveList.Delimiter := ' ';
  Started := True;
  InitUCIButtonClick(Self);
  ChessBoard.PVHighLight := HighLightPVCheckBox.Checked;
end;

procedure TForm1.HighLightPVCheckBoxClick(Sender: TObject);
begin
  ChessBoard.PVHighLight := HighLightPVCheckBox.Checked;
end;

procedure TForm1.InitUCIButtonClick(Sender: TObject);
begin
  Sleep(10);
  EnginCommunicator.EngineCommand('uci' + #13 + #10);
  EnginCommunicator.EngineCommand('isready' + #13 + #10);
  EnginCommunicator.EngineCommand('ucinewgame' + #13 + #10);
  EnginCommunicator.EngineCommand('setoption name Hash value ' + AnsiString(IntToStr(FHashSize)) + #13 + #10);
  EnginCommunicator.EngineCommand('setoption name Threads value ' + AnsiString(IntToStr(FThreads)) + #13 + #10);
  EnginCommunicator.EngineCommand('setoption name Ponder value false' + #13 + #10);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Started then Exit;
  FMoveList.Free;
  EngineStrListCriticalSection.Free;
  EngineStrList.Free;
  EnginCommunicator.FreeOnTerminate := True;
  EnginCommunicator.Terminate;
  Sleep(20);
end;

procedure TForm1.OnEngineStringRecieved(Str: AnsiString);
begin
  EngineStrListCriticalSection.Enter;
  EngineStrList.Add(string(Str));
  EngineStrListCriticalSection.Leave;
  PostMessage(Handle,ENG_STR_RECIEVED,0,0);
end;

procedure TForm1.SendGoToEngineButtonClick(Sender: TObject);
begin
  EnginCommunicator.EngineCommand('stop' + #13 + #10);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Str: AnsiString;
  Data: array [0..1024] of AnsiChar;
  BytesRead: Cardinal;
  AvailBytes: Cardinal;
  Hnd: THandle;
begin
  if not Started then Exit;
  FillMemory(@Data[0],1024,0);
  Hnd := GetStdHandle(STD_INPUT_HANDLE);
  PeekNamedPipe(Hnd,@Data[0],1024,@BytesRead,@AvailBytes,nil);
  if AvailBytes>0 then
  begin
    ReadFile(Hnd,Data,AvailBytes,BytesRead,nil);
    Str := AnsiString(Data);
    if Str = '' then Exit;
    EnginCommunicator.EngineCommand(Str);
    EngineOutputMemo.Lines.Add(string('G2E>>>' + Copy(Str, 1, Length(Str) - 2)));
  end;
end;

procedure TForm1.UndoButtonClick(Sender: TObject);
begin
  if FMoveList.Count>0 then
  begin
    FMoveList.Delete(FMoveList.Count-1);
    ChessBoard.MoveBackward;
  end;
end;

procedure TForm1.WhiteOnTopClick(Sender: TObject);
begin
  ChessBoard.WhiteOnTop := WhiteOnTop.Checked;
end;

procedure TForm1.SendCmdToEngineButtonClick(Sender: TObject);
begin
  EnginCommunicator.EngineCommand(AnsiString(Edit1.Text) + #13 + #10);
end;

procedure TForm1.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.DoEngineMove(Str: AnsiString);
begin
  if Length(Str)>4 then
    FPromotionPiece := Str[5];

  FMoveList.Add(Trim(string(Str)));
  Str := AnsiString(UpperCase(Trim(string(Str))));
  if Length(Str)>0 then
    FPromotionPiece := Str[3];

  ChessBoard.OnLegalMove := nil;
  ChessBoard.Move(AnsiString(Str));
  ChessBoard.OnLegalMove := ChessBoardLegalMove;

  ChessBoard.Refresh;
  PositionEdit.Text := string(ChessBoard.FENPosition);
end;

procedure TForm1.MinimizeButtonClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TForm1.NewGameButtonClick(Sender: TObject);
begin
  GameMode := 1;
  ChessBoard.NewGame;
  FMoveList.Clear;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (MessageBox(Handle,'Are you sure you want to close UCI Intermediator?','Warning',MB_YESNO)=ID_YES);
end;

procedure TForm1.EngineStringRecieved(var Msg: TMessage);
var
  i: Integer;
  Str: AnsiString;
  pv: AnsiString;
begin
  EngineStrListCriticalSection.Enter;
  while EngineStrList.Count>0 do
  begin
    Str := AnsiString(EngineStrList.Strings[0]);
    Str := Trim(Str);
    i := Pos(AnsiString(' pv '),Str);
    if i<>0 then
    begin
      pv := AnsiString(Copy(Str, i + 4, 4));
      ChessBoard.PV := pv;
    end;
    if Pos(AnsiString('score cp'),Str)<>0 then
    begin
      if Length(Str)>136 then
        Str := Copy(Str, 1, 136) + AnsiString('...');
    end;
    if FilterUnwantedlogs.Checked then
    begin
      if (Pos(AnsiString('score cp'),Str)<>0) or (Pos(AnsiString('bestmove'),Str)<>0) then
        EngineOutputMemo.Lines.Add(string(Str));
    end
    else
      EngineOutputMemo.Lines.Add(string(Str));

    AddToLogFile(AnsiString(AnsiChar(69)) + AnsiChar(62) +
      AnsiChar(85) + AnsiChar(58) + Str);
    if Copy(Str, 1, 8) = AnsiString('bestmove') then
    begin
      Delete(Str,1,9);
      if Length(Str)>5 then // if there is ponder after bestmove, if its mate move and there is no extra thing after bestmove no need to do this
        Str := Copy(Str, 1, Pos(AnsiString(' '), Str));
      DoEngineMove(Str);
    end;
    EngineStrList.Delete(0);
  end;
  EngineStrListCriticalSection.Leave;
end;

procedure TForm1.LogGUIEngineActivityCheckBoxClick(Sender: TObject);
begin
  LogCommunication := LogGUIEngineActivityCheckBox.Checked;
end;

procedure TForm1.AddToLogFile(Str: AnsiString);
begin
  if (LogFileStream <> nil) and FLogCommunication then
  begin
    LogFileCriticalSection.Enter;
    try
      Str := Str + #13 + #10;
      if Length(Str) > 0 then
        LogFileStream.WriteBuffer(PAnsiChar(Str)^, Length(Str));
    finally
      LogFileCriticalSection.Leave;
    end;
  end;
end;

procedure TForm1.SetLogCommunication(const Value: Boolean);
begin
  FLogCommunication := Value;
  if Value then
  begin
    LogFileStream := TFileStream.Create(ChangeFileExt(Application.ExeName,'.log'),fmCreate);
    LogFileCriticalSection := TCriticalSection.Create;
  end
  else
  begin
    LogFileStream.Free;
    LogFileCriticalSection.Free;
  end;
end;

procedure TForm1.ClearScreen1Click(Sender: TObject);
begin
  EngineOutputMemo.Clear;
end;

procedure TForm1.StayOnTopCheckBoxClick(Sender: TObject);
begin
  if StayOnTopCheckBox.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TForm1.ChessBoardLegalMove(Sender: TObject; MoveStr: string);
var
  Str: AnsiString;
begin
  FMoveList.Add(MoveStr);
  if chkPlayWithEngine.Checked then
    if (ChessBoard.IsWhiteToMove and ComputerPlaysWhiteCheckBox.Checked) or
       ((not ChessBoard.IsWhiteToMove) and  (ComputerPlaysBlackCheckBox.Checked)) then
    begin
      if GameMode = 1 then
      begin
        Str := 'position startpos moves ' + AsciiLowerText(AnsiString(FMoveList.DelimitedText)) + #13 + #10;
      end
      else
      begin
        Str := 'position fen ' + StartFEN + ' moves ' + AsciiLowerText(AnsiString(FMoveList.DelimitedText)) + #13 + #10;
      end;

      AddToLogFile('U>E:' + Str);
      EngineOutputMemo.Lines.Add(string(Str));
      EnginCommunicator.EngineCommand(Str);
      Str := AnsiString('go movetime ' + IntToStr(SpinEdit1.Value)) + #13 + #10;
      AddToLogFile('U>E:' + Str);
      EngineOutputMemo.Lines.Add(string(Str));
      EnginCommunicator.EngineCommand(Str);
    end;
  PositionEdit.Text := string(ChessBoard.FENPosition);
end;

