unit EngineCommunication;

interface

uses
  Windows, Classes, SyncObjs;

type
  TOnStringRecieved = procedure (Str: AnsiString) of object;
  TEngineCommunication = class (TThread)
  private
    FReadPipe,FWritePipe: THandle;
    FReadPipe1,FWritePipe1: THandle;
    FProcessInformation : TProcessInformation;
    FEnginCreationFailed: Boolean;
    FEnginOutputList: TStringList;
    FEngineOutputCriticalSection: TCriticalSection;
    FInputFromEngine: AnsiString;
    FOnStringRecieved: TOnStringRecieved;
    procedure ProcessEngineInputData(Buffer: Pointer; Size: Integer);
  protected
    procedure Execute; override;
  public
    procedure EngineCommand(Str: AnsiString);
    property OnStringRecieved: TOnStringRecieved read FOnStringRecieved write FOnStringRecieved;
    property EnginCreationFailed: Boolean read FEnginCreationFailed;
    constructor Create(CreateSuspended: Boolean; UCIEngineFileName: string);
    destructor Destroy; override;
  end;

implementation

{ TEngineCommunication }

constructor TEngineCommunication.Create(CreateSuspended: Boolean; UCIEngineFileName: string);
var
  SecurityAtributes: TSecurityAttributes;
  StartUpInfo: TStartUpInfo;
begin
  inherited Create(CreateSuspended);
  FInputFromEngine := '';
  FEnginOutputList := TStringList.Create;
  FEngineOutputCriticalSection := TCriticalSection.Create;
  SecurityAtributes.nLength := SizeOf(_SECURITY_ATTRIBUTES);
  SecurityAtributes.lpSecurityDescriptor := nil;
  SecurityAtributes.bInheritHandle := True;
  if CreatePipe(FReadPipe,FWritePipe,@SecurityAtributes,0) and
     CreatePipe(FReadPipe1,FWritePipe1,@SecurityAtributes,0) then
  begin
    ZeroMemory(@StartUpInfo,Sizeof(TStartUpInfo));
    StartUpInfo.cb := SizeOf(TStartUpInfo);
    StartUpInfo.hStdOutput := FWritePipe1;
    StartUpInfo.hStdError := FWritePipe1;
    StartUpInfo.hStdInput := FReadPipe;
    StartUpInfo.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
    StartUpInfo.wShowWindow := SW_HIDE;
    if not CreateProcess(nil,PChar(UCIEngineFileName),@SecurityAtributes,@SecurityAtributes,
                  True,CREATE_NEW_CONSOLE,nil,nil,StartUpInfo,FProcessInformation) then
    begin
      FEnginCreationFailed := True;
      CloseHandle(FReadPipe) ;
      CloseHandle(FWritePipe);
    end;
  end
  else
    FEnginCreationFailed := True;
end;

destructor TEngineCommunication.Destroy;
begin
  FEngineOutputCriticalSection.Free;
  FEnginOutputList.Free;
  if not FEnginCreationFailed then
  begin
    TerminateProcess(FProcessInformation.hProcess,0);
    CloseHandle(FProcessInformation.hProcess) ;
    CloseHandle(FProcessInformation.hThread) ;
    CloseHandle(FReadPipe) ;
    CloseHandle(FWritePipe);
  end;
  inherited;
end;

procedure TEngineCommunication.EngineCommand(Str: AnsiString);
begin
  FEngineOutputCriticalSection.Enter;
  FEnginOutputList.Add(string(Str));
  FEngineOutputCriticalSection.Leave;
end;

procedure TEngineCommunication.Execute;
var
  Res: LongBool;
  AvailBytes: Cardinal;
  ActualReadBytes: Cardinal;
  ActualWriteBytes: Cardinal;
  Buffer: Pointer;
  PipeReadBuf: array[0..1024] of AnsiChar;
begin
  inherited;
  while not Terminated do
  begin
    Sleep(1);
    Res := PeekNamedPipe(FReadPipe1,@PipeReadBuf[0],1024,@ActualReadBytes,@AvailBytes,nil);
    if Res=true then
    begin
      if AvailBytes>0 then
      begin
        GetMem(Buffer,AvailBytes);
        ReadFile(FReadPipe1,Buffer^,AvailBytes,ActualReadBytes,nil);
        ProcessEngineInputData(Buffer,ActualReadBytes);
        FreeMem(Buffer);
      end
    end
    else
      MessageBox(0, 'Engine pipe read failed.', 'ChessBoard UCI Demo', MB_OK);

    FEngineOutputCriticalSection.Enter;
    while FEnginOutputList.Count>0 do
    begin
      Buffer := PAnsiChar(AnsiString(FEnginOutputList.Strings[0]));
      WriteFile(FWritePipe, Buffer^, Length(AnsiString(FEnginOutputList.Strings[0])), ActualWriteBytes, nil);
      FEnginOutputList.Delete(0);
    end;
    FEngineOutputCriticalSection.Leave;
  end;
end;

procedure TEngineCommunication.ProcessEngineInputData(Buffer: Pointer;
  Size: Integer);
var
  Incoming: AnsiString;
  LineEnd: Integer;
  Line: AnsiString;
begin
  if (Buffer = nil) or (Size <= 0) then
    Exit;

  SetString(Incoming, PAnsiChar(Buffer), Size);
  FInputFromEngine := FInputFromEngine + Incoming;

  repeat
    LineEnd := Pos(AnsiChar(#10), FInputFromEngine);
    if LineEnd = 0 then
      LineEnd := Pos(AnsiChar(#13), FInputFromEngine);

    if LineEnd > 0 then
    begin
      Line := Copy(FInputFromEngine, 1, LineEnd - 1);

      { Remove CR/LF pair if the engine sent Windows-style line endings. }
      Delete(FInputFromEngine, 1, LineEnd);
      while (Length(FInputFromEngine) > 0) and
            ((FInputFromEngine[1] = #10) or (FInputFromEngine[1] = #13)) do
        Delete(FInputFromEngine, 1, 1);

      if (Line <> '') and Assigned(FOnStringRecieved) then
        FOnStringRecieved(Line);
    end;
  until LineEnd = 0;
end;

end.
