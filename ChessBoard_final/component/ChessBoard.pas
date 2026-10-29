unit ChessBoard;

interface

uses
  Windows, SysUtils, Classes, Controls, Graphics, Math, StdCtrls, LegalMoves, ChessTypes, IMgList,
  StrUtils, Types;

{$R 'ChessBoard.dcr'}

type

  TBorderLabel = (blLeft, blTop, blRight, blBottom);
  TBorderLabels = set of TBorderLabel;

  TChessBoard = class(TGraphicControl)
  private
    FDefaultBitmap: TBitmap;
    FBlackPawnBitmap: TBitmap;
    FBlackQueenBitmap: TBitmap;
    FBlackRookBitmap: TBitmap;
    FBlackKnightBitmap: TBitmap;
    FBlackBishopBitmap: TBitmap;
    FBlackKingBitmap: TBitmap;
    FWhiteQueenBitmap: TBitmap;
    FWhitePawnBitmap: TBitmap;
    FWhiteRookBitmap: TBitmap;
    FWhiteKnightBitmap: TBitmap;
    FWhiteBishopBitmap: TBitmap;
    FWhiteKingBitmap: TBitmap;
    FBorderSize: Integer;
    FSquareSize: Integer;
    FBorderColor: TColor;
    FSquareColorDark: TColor;
    FSquareColorLight: TColor;
    FDbgLabel: TLabel;
    FPositionStrList: TStringList;
    FMoveList: TStringList;
    FCurrentPositionIndex: Integer;
    FPiecesImageList: TDragImageList;
    FWhiteOnTop: Boolean;
    FClick1Sq: AnsiString;
    FBorderLabels: TBorderLabels;
    FBLFont: TFont;
    FDraggingPiece: Integer;
    FLegalMoveList: TStringList;
    FOnWhiteCastle: TOnMove;
    FOnIllegalMove: TOnMove;
    FOnBlackCastle: TOnMove;
    FLastDragSq: AnsiString;
    FLegalMoves: TLegalMoves;
    FOnLegalMove: TOnMove;
    FOnPromotion: TOnPromotion;
    FPromotionPiece: AnsiChar;
    FOnCheckMate: TOnMove;
    FOnStaleMate: TOnMove;
    FOnInsufficientMaterial: TOnMove;
    FOnThreefoldRepeatation: TOnMove;
    FFENPosition: AnsiString;
    FHighLightLastMove: Boolean;
    FLastMoveSq1,FLastMoveSq2: AnsiString;
    FIsWhiteToMove: Boolean;
    FHighLightColor: TColor;
    FUpdating: Integer;
    FSetupMode: Boolean;
    FSetupDeleteMode: Boolean;
    FPVHighLightColor: TColor;
    FPVHighLight: Boolean;
    FPV: AnsiString;
    procedure SetBorderSize(const Value: Integer);
    procedure SetBlackPawnBitmap(const Value: TBitmap);
    procedure SetBlackBishopBitmap(const Value: TBitmap);
    procedure SetBlackKingBitmap(const Value: TBitmap);
    procedure SetBlackKnightBitmap(const Value: TBitmap);
    procedure SetBlackQueenBitmap(const Value: TBitmap);
    procedure SetWhiteBishopBitmap(const Value: TBitmap);
    procedure SetWhiteKingBitmap(const Value: TBitmap);
    procedure SetWhiteKnightBitmap(const Value: TBitmap);
    procedure SetWhitePawnBitmap(const Value: TBitmap);
    procedure SetWhiteQueenBitmap(const Value: TBitmap);
    procedure LoadMediumBitmaps;
    procedure LoadSmallBitmaps;
    procedure FreeBitmaps;
    procedure SetSquareSize(const Value: Integer);
    procedure DrawBorder;
    procedure DrawBoard;
    procedure DrawPieces;
    procedure SetBorderColor(const Value: TColor);
    procedure SetSquareColorDark(const Value: TColor);
    procedure SetSquareColorLight(const Value: TColor);
    procedure SetWhiteRookBitmap(const Value: TBitmap);
    procedure SetBlackRookBitmap(const Value: TBitmap);
    function SquareToStr(x,y: Integer): AnsiString;
    procedure SetWhiteOnTop(const Value: Boolean);
    procedure SetBorderLabels(const Value: TBorderLabels);
    procedure ClearSrcSquare(Sq: AnsiString);
    procedure DrawSquare(Sq: AnsiString);
    procedure SetOnBlackCastle(const Value: TOnMove);
    procedure SetOnWhiteCastle(const Value: TOnMove);
    procedure SetOnPromotion(const Value: TOnPromotion);
    procedure SetOnLegalMove(const Value: TOnMove);
    procedure SetFENPosition(const Value: AnsiString);
    function GetFENPosition: AnsiString;
    function PositionString(Board: TChessBoardState): AnsiString;
    procedure DoHighLightLastMove;
    function GetIsWhiteToMove: Boolean;
    procedure SetIsWhiteToMove(const Value: Boolean);
    procedure SetHighLightColor(const Value: TColor);
    procedure LoadTinyBitmaps;
    function IsBlackCastleMove(MoveStr: AnsiString; Board: TChessBoardState): Boolean;
    function IsWhiteCastleMove(MoveStr: AnsiString; Board: TChessBoardState): Boolean;
    procedure SetPVHighLightColor(const Value: TColor);
    procedure HighLightPV;
    procedure SetPV(const Value: AnsiString);
  protected
    procedure Paint; override;
    procedure Resize; override;
    function CanResize(var NewWidth: Integer; var NewHeight: Integer): Boolean;
      override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    function GetBoardSquareFromPoint(P: TPoint; var x,y: Integer): Boolean;
    procedure DragOver(Source: TObject; X: Integer; Y: Integer;
      State: TDragState; var Accept: Boolean); override;
    procedure DragCanceled; override;
  public
    CurrentBoard: TChessBoardState;
    function GetBoardKeyAfterMoveCalc(Board: TChessBoardState; PreKey: UInt64;
      Move: AnsiString): UInt64;
    function GetBoardKeyFromMoveAndPreKey(Board: TChessBoardState; PreKey: UInt64;
      Move: AnsiString): UInt64;
    function GetBoardKey(Board: TChessBoardState): UInt64;
    procedure BeginUpdate;
    procedure EndUpdate;
    function Move(MoveStr: AnsiString): Boolean;
    function MoveBackward: Boolean;
    function MoveForward: Boolean;
    procedure NewGame;
    procedure LoadBoard(FileName: string);
    function FENString(Board: TChessBoardState): AnsiString;
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    procedure DragDrop(Source: TObject; X: Integer; Y: Integer); override;
    procedure DragPiece(Piece: Byte);
    procedure ClearBoard;
    procedure InvalidateBoard; // should be called after setting up board
  published
    property BorderLabels: TBorderLabels read FBorderLabels write SetBorderLabels;

    property SquareColorLight: TColor read FSquareColorLight write SetSquareColorLight;
    property SquareColorDark: TColor read FSquareColorDark write SetSquareColorDark;
    property SquareSize: Integer  read FSquareSize write SetSquareSize default 15;
    property BorderSize: Integer read FBorderSize write SetBorderSize;

    property PV: AnsiString read FPV write SetPV;
    property PVHighLight: Boolean read FPVHighLight write FPVHighLight;
    property PVHighLightColor: TColor  read FPVHighLightColor write SetPVHighLightColor;
    property HighLightLastMove: Boolean read FHighLightLastMove write FHighLightLastMove;
    property HighLightColor: TColor  read FHighLightColor write SetHighLightColor;
    property WhiteOnTop: Boolean read FWhiteOnTop write SetWhiteOnTop;
    property BorderColor: TColor read FBorderColor write SetBorderColor default $0062000F;
    property Constraints;
    property Anchors;
    property OnClick;
    property OnResize;
    {$IFNDEF VER150} // Delphi 7 TCustomControl does not publish these properties
    property OnMouseEnter;
    property OnMouseLeave;
    {$ENDIF}
    property DbgLabel: TLabel read FDbgLabel write FDbgLabel;
    property OnIllegalMove: TOnMove read FOnIllegalMove write FOnIllegalMove;
    property OnLegalMove: TOnMove read FOnLegalMove write SetOnLegalMove;
    property OnWhiteCastle: TOnMove read FOnWhiteCastle write SetOnWhiteCastle;
    property OnBlackCastle: TOnMove read FOnBlackCastle write SetOnBlackCastle;
    property OnPromotion: TOnPromotion read FOnPromotion write SetOnPromotion;
    property OnStaleMate: TOnMove read FOnStaleMate write FOnStaleMate;
    property OnCheckMate: TOnMove read FOnCheckMate write FOnCheckMate;
    property OnInsufficientMaterial: TOnMove read FOnInsufficientMaterial write FOnInsufficientMaterial;
    property OnThreefoldRepeatation: TOnMove read FOnThreefoldRepeatation write FOnThreefoldRepeatation;
    property FENPosition: AnsiString read GetFENPosition write SetFENPosition;
    property IsWhiteToMove: Boolean read GetIsWhiteToMove write SetIsWhiteToMove;
    property SetupMode: Boolean read FSetupMode write FSetupMode;
    property SetupDeleteMode: Boolean read FSetupDeleteMode write FSetupDeleteMode;
  end;

procedure Register;

implementation


function ChessBoardResourceModule: HINST;
begin
  Result := FindClassHInstance(TChessBoard);
  if Result = 0 then
    Result := HInstance;
end;

function LoadChessBoardBitmap(const ResName: PChar): HBITMAP;
begin
  Result := LoadBitmap(ChessBoardResourceModule, ResName);
  if Result = 0 then
    Result := LoadBitmap(HInstance, ResName);
end;

procedure AssignChessBoardBitmap(Bitmap: TBitmap; const ResName: PChar);
begin
  Bitmap.Handle := LoadChessBoardBitmap(ResName);
  if Bitmap.Handle = 0 then
    raise EInvalidOperation.CreateFmt('ChessBoard bitmap resource "%s" could not be loaded.', [ResName]);
end;

procedure Register;
begin
  RegisterComponents('ALTEK', [TChessBoard]);
end;

{ TChessBoard }

procedure TChessBoard.BeginUpdate;
begin
  Inc(FUpdating);
end;

procedure TChessBoard.InvalidateBoard;
begin
  CurrentBoard.EnpasantPosX := -1;
  PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex])^ := CurrentBoard;
end;


function TChessBoard.IsBlackCastleMove(MoveStr: AnsiString; Board: TChessBoardState): Boolean;
begin
  Result := ((AsciiLowerMove(MoveStr) = 'e8g8') and (Board.Board[4, 7] = BlackKing)
      and Board.BlackCanCastleKingSide and (Board.Board[7, 7] = BlackRook) and
      (Board.Board[5, 7] = 0) and (Board.Board[6, 7] = 0)) or
    ((AsciiLowerMove(MoveStr) = 'e8c8') and (Board.Board[4, 7] = BlackKing)
      and Board.BlackCanCastleQueenSide and (Board.Board[0, 7] = BlackRook) and
      (Board.Board[1, 7] = 0) and (Board.Board[2, 7] = 0) and
      (Board.Board[3, 7] = 0))
end;

function TChessBoard.IsWhiteCastleMove(MoveStr: AnsiString; Board: TChessBoardState)
  : Boolean;
begin
  Result := ((AsciiLowerMove(MoveStr) = 'e1g1') and (Board.Board[4, 0] = WhiteKing)
      and Board.WhiteCanCastleKingSide and (Board.Board[7, 0] = WhiteRook) and
      (Board.Board[5, 0] = 0) and (Board.Board[6, 0] = 0)) or
    ((AsciiLowerMove(MoveStr) = 'e1c1') and (Board.Board[4, 0] = WhiteKing)
      and Board.WhiteCanCastleQueenSide and (Board.Board[0, 0] = WhiteRook) and
      (Board.Board[1, 0] = 0) and (Board.Board[2, 0] = 0) and
      (Board.Board[3, 0] = 0))
end;

function TChessBoard.GetBoardKeyAfterMoveCalc(Board: TChessBoardState; PreKey: UInt64; Move: AnsiString): UInt64;
var
  i: Integer;
begin
  if IsWhiteCastleMove(Move,Board) or IsBlackCastleMove(Move,Board) then
  begin
    Result := GetBoardKey(Board);
    Exit;
  end;
  Result := PreKey;
  if Board.IsWhiteToMove then  //because we do this after calling of move function
    Result := Result xor ZobristValue(RandomTurnOffset);

  if Board.WhiteCanCastleKingSide then
      Result := Result xor ZobristValue(RandomCastleOffset+0);
  if Board.WhiteCanCastleQueenSide then
    Result := Result xor ZobristValue(RandomCastleOffset+1);
  if Board.BlackCanCastleKingSide then
    Result := Result xor ZobristValue(RandomCastleOffset+2);
  if Board.BlackCanCastleQueenSide then
    Result := Result xor ZobristValue(RandomCastleOffset+3);

  // we have to apply empasant xor only if its poosible
  i := Board.EnpasantPosX;
  if i<>-1 then
  begin
    if Board.IsWhiteToMove then
    begin
      if ((i>0) and (Board.Board[i-1,4]=1)) or
         ((i<7) and (Board.Board[i+1,4]=1)) then
        Result := Result xor ZobristValue(RandomEnPassantOffset+i)
    end
    else
    begin
      if ((i>0) and (Board.Board[i-1,3]=129)) or
         ((i<7) and (Board.Board[i+1,3]=129)) then
        Result := Result xor ZobristValue(RandomEnPassantOffset+i)
    end;
  end;
end;

function TChessBoard.GetBoardKeyFromMoveAndPreKey(Board: TChessBoardState; PreKey: UInt64; Move: AnsiString): UInt64;
var
  i,x,y: Integer;
  PieceNo: Integer;
  DestSqPoint: TPoint;
  SourceSqPoint: TPoint;
begin
  PieceNo := 0;
  x := Byte(AnsiChar(Move[1]))-Byte(AnsiChar('a'));
  y := Byte(AnsiChar(Move[2]))-Byte(AnsiChar('1'));
  SourceSqPoint.X := X;
  SourceSqPoint.Y := Y;

  x := Byte(AnsiChar(Move[3]))-Byte(AnsiChar('a'));
  y := Byte(AnsiChar(Move[4]))-Byte(AnsiChar('1'));
  DestSqPoint.X := X;
  DestSqPoint.Y := Y;

  if Board.Board[SourceSqPoint.X,SourceSqPoint.Y]<>0 then
  begin
    case Board.Board[SourceSqPoint.X,SourceSqPoint.Y] of
      WhitePawn:   PieceNo := 1;
      BlackPawn:   PieceNo := 0;
      WhiteRook:   PieceNo := 7;
      BlackRook:   PieceNo := 6;
      WhiteKnight: PieceNo := 3;
      BlackKnight: PieceNo := 2;
      WhiteBiShop: PieceNo := 5;
      BlackBiShop: PieceNo := 4;
      WhiteKing:   PieceNo := 11;
      BlackKing:   PieceNo := 10;
      WhiteQueen:  PieceNo := 9;
      BlackQueen:  PieceNo := 8;
    end;
    PreKey := PreKey xor ZobristValue(PieceNo*64+8*SourceSqPoint.Y+SourceSqPoint.X);
  end;

  PreKey := PreKey xor ZobristValue(PieceNo*64+8*DestSqPoint.Y+DestSqPoint.X);

  if Board.Board[DestSqPoint.X,DestSqPoint.Y]<>0 then
  begin
    case Board.Board[DestSqPoint.X,DestSqPoint.Y] of
      WhitePawn:   PieceNo := 1;
      BlackPawn:   PieceNo := 0;
      WhiteRook:   PieceNo := 7;
      BlackRook:   PieceNo := 6;
      WhiteKnight: PieceNo := 3;
      BlackKnight: PieceNo := 2;
      WhiteBiShop: PieceNo := 5;
      BlackBiShop: PieceNo := 4;
      WhiteKing:   PieceNo := 11;
      BlackKing:   PieceNo := 10;
      WhiteQueen:  PieceNo := 9;
      BlackQueen:  PieceNo := 8;
    end;
    PreKey := PreKey xor ZobristValue(PieceNo*64+8*DestSqPoint.Y+DestSqPoint.X)
  end;

  Result := PreKey;

  if Board.IsWhiteToMove then
    Result := Result xor ZobristValue(RandomTurnOffset);

  if Board.WhiteCanCastleKingSide then
      Result := Result xor ZobristValue(RandomCastleOffset+0);
  if Board.WhiteCanCastleQueenSide then
    Result := Result xor ZobristValue(RandomCastleOffset+1);
  if Board.BlackCanCastleKingSide then
    Result := Result xor ZobristValue(RandomCastleOffset+2);
  if Board.BlackCanCastleQueenSide then
    Result := Result xor ZobristValue(RandomCastleOffset+3);

  // we have to apply empasant xor only if its poosible
  i := Board.EnpasantPosX;
  if i<>-1 then
  begin
    if Board.IsWhiteToMove then
    begin
      if ((i>0) and (AnsiChar(Board.Board[i-1,4])=#1)) or
         ((i<7) and (AnsiChar(Board.Board[i+1,4])=#1)) then
        Result := Result xor ZobristValue(RandomEnPassantOffset+i)
    end
    else
    begin
      if ((i>0) and (AnsiChar(Board.Board[i-1,3])=#129)) or
         ((i<7) and (AnsiChar(Board.Board[i+1,3])=#129)) then
        Result := Result xor ZobristValue(RandomEnPassantOffset+i)
    end;
  end;
end;

function TChessBoard.GetBoardKey(Board: TChessBoardState): UInt64;
var
  i,x,y: Integer;
  PieceNo: Integer;
begin
  Result := 0;
  PieceNo := 0;

  for y:= 0 to 7 do
  begin
    for x := 0 to 7 do
    begin
      if Board.Board[x,y]<>0 then
      begin
        case Board.Board[x,y] of
          1:   PieceNo := 1;//'P';
          2:   PieceNo := 7;//'R';
          3:   PieceNo := 3;//'N';
          4:   PieceNo := 5;//'B';
          5:   PieceNo := 11;//'K';
          6:   PieceNo := 9;//'Q';
          129: PieceNo := 0;//'p';
          130: PieceNo := 6;//'r';
          131: PieceNo := 2;//'n';
          132: PieceNo := 4;//'b';
          133: PieceNo := 10;//'k';
          134: PieceNo := 8;//'q';
        end;
        Result := Result xor ZobristValue(PieceNo*64+8*y+x);
      end;
    end;
  end;

  if Board.IsWhiteToMove then
    Result := Result xor ZobristValue(RandomTurnOffset);
  if Board.WhiteCanCastleKingSide then
      Result := Result xor ZobristValue(RandomCastleOffset+0);
  if Board.WhiteCanCastleQueenSide then
    Result := Result xor ZobristValue(RandomCastleOffset+1);
  if Board.BlackCanCastleKingSide then
    Result := Result xor ZobristValue(RandomCastleOffset+2);
  if Board.BlackCanCastleQueenSide then
    Result := Result xor ZobristValue(RandomCastleOffset+3);

  // we have to apply empasant xor only if its poosible
  i := Board.EnpasantPosX;
  if i<>-1 then
  begin
    if Board.IsWhiteToMove then
    begin
      if ((i>0) and (AnsiChar(Board.Board[i-1,4])='P')) or
         ((i<7) and (AnsiChar(Board.Board[i+1,4])='P')) then
        Result := Result xor ZobristValue(RandomEnPassantOffset+i)
    end
    else
    begin
      if ((i>0) and (AnsiChar(Board.Board[i-1,3])='p')) or
         ((i<7) and (AnsiChar(Board.Board[i+1,3])='p')) then
        Result := Result xor ZobristValue(RandomEnPassantOffset+i)
    end;
  end;
end;

function TChessBoard.CanResize(var NewWidth, NewHeight: Integer): Boolean;
begin
  if NewWidth<>Width then
  begin
    NewWidth := Round((NewWidth - BorderSize*2)/8)*8+BorderSize*2;
    NewHeight := NewWidth;
  end
  else
  if NewHeight<>Height then
  begin
    NewHeight := Round((NewHeight - BorderSize*2)/8)*8+BorderSize*2;
    NewWidth := NewHeight;
  end;
  FSquareSize := (NewHeight - BorderSize*2) shr 3;

  { Delphi 7 does not allow calling a Boolean inherited method as a
    standalone statement here. Return the inherited CanResize result. }
  Result := inherited CanResize(NewWidth, NewHeight);
end;

procedure TChessBoard.ClearBoard;
begin
  ZeroMemory(@CurrentBoard,SizeOf(TChessBoardState));
  PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex])^ := CurrentBoard;
  DrawBoard;
  DrawPieces;
  DoHighLightLastMove;
end;

procedure TChessBoard.ClearSrcSquare(Sq: AnsiString);
var
  x,y: Integer;
  Cl: Integer;
begin
  if WhiteOnTop then
  begin
    x := 7- (Byte(Sq[1]) - 65);
    y := Byte(Sq[2]) - 49;
  end
  else
  begin
    x := Byte(Sq[1]) - 65;
    y := 7-(Byte(Sq[2]) - 49);
  end;
  if ((x+y) and 1=0) then
    Cl := FSquareColorLight
  else
    Cl := FSquareColorDark;
  Canvas.Brush.Color := cl;
  Canvas.FillRect(Rect(BorderSize+x*FSquareSize,BorderSize+y*FSquareSize,BorderSize+x*FSquareSize+SquareSize,BorderSize+y*FSquareSize+SquareSize));
end;

constructor TChessBoard.Create(AOwner: TComponent);
var
  ChBoard: PChessBoardState;
  i,j: Integer;
begin
  inherited;
  Width := 170;
  Height := 170;
  FBLFont := TFont.Create;
  FBLFont.Name := 'Arial';
  FBLFont.Size := 7;
  FBLFont.Color := clWhite;
  FBLFont.Pitch := fpDefault;
  FDefaultBitmap := TBitmap.Create;
  FPositionStrList := TStringList.Create;
  FLegalMoves := TLegalMoves.Create;
  FMoveList := TStringList.Create;
  GetMem(ChBoard,SizeOf(TChessBoardState));
  for i := 0 to 7 do
    for j := 0 to 7 do
      ChBoard.Board[i,j] := StartPos[j,i];
  ChBoard.WhiteCanCastleKingSide := True;
  ChBoard.WhiteCanCastleQueenSide := True;
  ChBoard.BlackCanCastleKingSide := True;
  ChBoard.BlackCanCastleQueenSide := True;
  ChBoard.FiftyMoveVariable := 0;
  ChBoard.EnpasantPosX := -1;
  ChBoard.EnpasantPosY := -1;
  ChBoard.IsWhiteToMove := True;
  CurrentBoard := ChBoard^;
  FLegalMoveList := TStringList.Create;
  FLegalMoves.GetMoveList(ChBoard^,FLegalMoveList);
  FPositionStrList.AddObject('rnbqkbnrpppppppp                                PPPPPPPPRNBQKBNR',TObject(ChBoard));
  FCurrentPositionIndex := 0;
  FPiecesImageList := TDragImageList.Create(Self);
  LoadSmallBitmaps;
  FSquareSize := (Height - BorderSize*2) shr 3;
  SquareColorDark := clGreen;
  SquareColorLight := clSkyBlue;
  FBorderColor := $0087493A;
  FBorderSize := 20;
  FBorderLabels := [blLeft,blBottom];
  Resize;
end;

destructor TChessBoard.Destroy;
begin
  while FPositionStrList.Count>0 do
  begin
    FreeMem(Pointer(FPositionStrList.Objects[0]));
    FPositionStrList.Delete(0);
  end;

  FWhiteQueenBitmap.Free;
  FWhitePawnBitmap.Free;
  FWhiteRookBitmap.Free;
  FWhiteKnightBitmap.Free;
  FWhiteBishopBitmap.Free;
  FWhiteKingBitmap.Free;
  FBlackQueenBitmap.Free;
  FBlackPawnBitmap.Free;
  FBlackRookBitmap.Free;
  FBlackKnightBitmap.Free;
  FBlackBishopBitmap.Free;
  FBlackKingBitmap.Free;


  FLegalMoveList.Free;
  FLegalMoves.Free;
  FPiecesImageList.Free;
  FMoveList.Free;
  FPositionStrList.Free;
  FDefaultBitmap.Free;
  FBLFont.Free;
  inherited;
end;

procedure TChessBoard.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FLastDragSq := '';
  if not GetBoardSquareFromPoint(Point(x,y),x,y) then
    Exit;
  if FSetupDeleteMode then
  begin

  end
  else
  begin
    if assigned(DbgLabel) then
      DbgLabel.Caption := 'x='+IntToStr(x)+' y='+IntToStr(y);
    FClick1Sq := SquareToStr(x,y);
    DbgLabel.Caption := DbgLabel.Caption + '---->'+string(FClick1Sq);
    if WhiteOnTop then
      FDraggingPiece := PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex]).Board[7-x,y]
    else
      FDraggingPiece := PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex]).Board[x,7-y];
    DbgLabel.Caption := DbgLabel.Caption +' Piece='+IntToStr(FDraggingPiece);
    if FDraggingPiece<>0 then
      BeginDrag(False);
  end;
end;

function TChessBoard.Move(MoveStr: AnsiString): Boolean;
var
  i: Integer;
  NewBoard: PChessBoardState;
begin
  Result := False;
  if Length(MoveStr)<4 then
    Exit;

  for i := 0 to FLegalMoveList.Count - 1 do
    if  AsciiLowerMove(Copy(MoveStr, 1, 4)) = AsciiLowerMove(AnsiString(Copy(FLegalMoveList.Strings[i], 1, 4))) then
    begin
      // remove anything after FCurrentPositionIndex
      // No RedoList should be available
      while FCurrentPositionIndex+1<FPositionStrList.Count do
      begin
        FreeMem(Pointer(FPositionStrList.Objects[FCurrentPositionIndex+1]));
        FPositionStrList.Delete(FCurrentPositionIndex+1);
        FMoveList.Delete(FCurrentPositionIndex+1);
      end;
      FMoveList.Add(string(MoveStr));
      FLastMoveSq1 := Copy(MoveStr, 1, 2);
      FLastMoveSq2 := Copy(MoveStr, 3, 2);
      GetMem(NewBoard,SizeOf(TChessBoardState));
      FIsWhiteToMove := not FIsWhiteToMove;
      NewBoard^ := FLegalMoves.DoMove(MoveStr,PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex])^);
      FPositionStrList.AddObject(string(PositionString(NewBoard^)),TObject(NewBoard));
      CurrentBoard := NewBoard^;
      FCurrentPositionIndex := FPositionStrList.Count - 1;
      FLegalMoveList.Clear;
      FLegalMoves.GetMoveList(NewBoard^,FLegalMoveList);
      if Assigned(FOnLegalMove) then
        OnLegalMove(Self,string(MoveStr));
      Result := True;
      break;
    end;
  FPV := '';
  DrawBoard;
  DrawPieces;
  DoHighLightLastMove;
end;

function TChessBoard.MoveBackward: Boolean;
begin
  Result := False;
  if FCurrentPositionIndex>0 then
  begin
    FCurrentPositionIndex := FCurrentPositionIndex - 1;
    FLegalMoveList.Clear;
    FLegalMoves.GetMoveList(PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex])^,FLegalMoveList);
    if FCurrentPositionIndex>0 then
    begin
      FLastMoveSq1 := AnsiString(Copy(FMoveList.Strings[FCurrentPositionIndex], 1, 2));
      FLastMoveSq2 := AnsiString(Copy(FMoveList.Strings[FCurrentPositionIndex], 3, 2));
    end
    else
    begin
      FLastMoveSq1 := '';
      FLastMoveSq2 := '';
    end;
    FIsWhiteToMove := PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex]).IsWhiteToMove;

    Paint;
    Result := True;
  end;
end;

function TChessBoard.MoveForward: Boolean;
begin
  Result := False;
  if FCurrentPositionIndex<FPositionStrList.Count then
  begin
    FCurrentPositionIndex := FCurrentPositionIndex + 1;
    FLegalMoveList.Clear;
    FLegalMoves.GetMoveList(PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex])^,FLegalMoveList);
    if FCurrentPositionIndex>0 then
    begin
      FLastMoveSq1 := AnsiString(Copy(FMoveList.Strings[FCurrentPositionIndex], 1, 2));
      FLastMoveSq2 := AnsiString(Copy(FMoveList.Strings[FCurrentPositionIndex], 3, 2));
    end
    else
    begin
      FLastMoveSq1 := '';
      FLastMoveSq2 := '';
    end;
    FIsWhiteToMove := PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex]).IsWhiteToMove;
    Paint;
    Result := True;
  end;
end;

procedure TChessBoard.NewGame;
var
  i,j: Integer;
  ChBoard: PChessBoardState;
begin
  FMoveList.Clear;
  while FPositionStrList.Count>0 do
  begin
    FreeMem(Pointer(FPositionStrList.Objects[0]));
    FPositionStrList.Delete(0);
  end;

  GetMem(ChBoard,SizeOf(TChessBoardState));
  for i := 0 to 7 do
    for j := 0 to 7 do
      ChBoard.Board[i,j] := StartPos[j,i];
  ChBoard.WhiteCanCastleKingSide := True;
  ChBoard.WhiteCanCastleQueenSide := True;
  ChBoard.BlackCanCastleKingSide := True;
  ChBoard.BlackCanCastleQueenSide := True;
  ChBoard.FiftyMoveVariable := 0;
  ChBoard.EnpasantPosX := -1;
  ChBoard.EnpasantPosY := -1;
  ChBoard.IsWhiteToMove := True;
  FLegalMoveList.Clear;
  FLegalMoves.GetMoveList(ChBoard^,FLegalMoveList);
  FPositionStrList.AddObject(string(PositionString(ChBoard^)),TObject(ChBoard));
  FIsWhiteToMove := True;
  FCurrentPositionIndex := 0;
  FLastMoveSq1 := '';
  FLastMoveSq2 := '';
  Paint;
end;

procedure TChessBoard.DragCanceled;
begin
  inherited;
  FPiecesImageList.HideDragImage;
  FPiecesImageList.EndDrag;
  DrawSquare(FClick1Sq);
  if Assigned(FOnIllegalMove) then
    FOnIllegalMove(Self,string(FClick1Sq+FLastDragSq));
  FClick1Sq := '';
end;

procedure TChessBoard.DragDrop(Source: TObject; X, Y: Integer);
var
  CurrSqStr: AnsiString;
  bx,by: Integer;
  i,j,cnt: Integer;
  NewBoard: PChessBoardState;
  WMtv,BMtv: Integer;
  PosStr: AnsiString;
begin
  inherited;
  cnt := 0;
  if FSetupMode then
  begin
    GetBoardSquareFromPoint(Point(x,y),bx,by);
    CurrSqStr := SquareToStr(bx,by);
    if WhiteOnTop then
    begin
      PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex])^.Board[7-bx,by] := FDraggingPiece;
      CurrentBoard.Board[7-bx,by] := FDraggingPiece;
    end
    else
    begin
      PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex])^.Board[bx,7-by] := FDraggingPiece;
      CurrentBoard.Board[bx,7-by] := FDraggingPiece;
    end;
    DrawBoard;
    DrawPieces;
    DoHighLightLastMove;
  end
  else
  begin
    if FPiecesImageList.Dragging then
    begin
      FPiecesImageList.HideDragImage;
      FPiecesImageList.EndDrag;
    end;

    if GetBoardSquareFromPoint(Point(x,y),bx,by) then
    begin
      CurrSqStr := SquareToStr(bx,by);
      DbgLabel.Caption := string(CurrSqStr);
      if CurrSqStr<>FClick1Sq then
      begin
        for i := 0 to FLegalMoveList.Count - 1 do
          if AnsiString(Copy(FLegalMoveList.Strings[i], 1, 4))=FClick1Sq+CurrSqStr then
          begin
            GetMem(NewBoard,SizeOf(TChessBoardState));
            // We have to Set this right before doing the move the program may need this on OnLegalMoveEventHandler
            FIsWhiteToMove := not FIsWhiteToMove;
            NewBoard^ := FLegalMoves.DoMove(FClick1Sq+CurrSqStr,PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex])^);
            PosStr := PositionString(NewBoard^);
            FLastMoveSq1 := FClick1Sq;
            FLastMoveSq2 := CurrSqStr;
            FMoveList.Add(string(FClick1Sq+CurrSqStr));
            // remove anything after FCurrentPositionIndex
            // No RedoList should be available
            while FCurrentPositionIndex+1<FPositionStrList.Count do
            begin
              FreeMem(Pointer(FPositionStrList.Objects[FCurrentPositionIndex+1]));
              FPositionStrList.Delete(FCurrentPositionIndex+1);
              FMoveList.Delete(FCurrentPositionIndex+1);
            end;

            FPositionStrList.AddObject(string(PosStr),TObject(NewBoard));
            CurrentBoard := NewBoard^;
            for j := 0 to FPositionStrList.Count - 1 do
            begin
              if string(PosStr)=FPositionStrList.Strings[j] then
                cnt := cnt+1;
              if cnt=3 then
                if Assigned(OnThreefoldRepeatation) then
                  OnThreefoldRepeatation(Self,string(FClick1Sq+CurrSqStr));
            end;
            FLegalMoveList.Clear;
            FLegalMoves.GetMoveList(NewBoard^,FLegalMoveList);
            FCurrentPositionIndex := FPositionStrList.Count - 1;
            DrawBoard;
            DrawPieces;
            DoHighLightLastMove;
            BMtv := 0;
            WMtv := 0;
            for bx := 0 to 7 do
              for by := 0 to 7 do
              begin
                case NewBoard.Board[bx,by] of
                  BlackRook: BMtv := BMtv + 5;
                  BlackQueen: BMtv := BMtv + 5;
                  BlackPawn: BMtv := BMtv + 5;
                  BlackBiShop: BMtv := BMtv + 3;
                  BlackKnight: BMtv := BMtv + 2;
                  WhiteRook: WMtv := WMtv + 5;
                  WhiteQueen: WMtv := WMtv + 5;
                  WhitePawn: WMtv := WMtv + 5;
                  WhiteBiShop: WMtv := WMtv + 3;
                  WhiteKnight: WMtv := WMtv + 2;
                end;
              end;
            if (WMtv<5) and (BMtv<5) then
              if Assigned(OnInsufficientMaterial) then
                OnInsufficientMaterial(Self,string(FClick1Sq+CurrSqStr));

            if FLegalMoveList.Count=0 then
            begin
              if NewBoard.IsWhiteToMove then
              begin
                if FLegalMoves.IsWhiteKingInCheck(NewBoard^) then
                begin
                  if Assigned(OnCheckMate) then
                    OnCheckMate(Self,string(FClick1Sq+CurrSqStr));
                end
                else
                begin
                  if Assigned(OnStaleMate) then
                    OnStaleMate(Self,string(FClick1Sq+CurrSqStr));
                end;
              end
              else
              begin
                if FLegalMoves.IsBlackKingInCheck(NewBoard^) then
                begin
                  if Assigned(OnCheckMate) then
                    OnCheckMate(Self,string(FClick1Sq+CurrSqStr));
                end
                else
                begin
                  if Assigned(OnStaleMate) then
                    OnStaleMate(Self,string(FClick1Sq+CurrSqStr));
                end;
              end;
            end;
            break;
          end;
      end;
    end;
  end;
end;

procedure TChessBoard.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  DragImageIndex: Integer;
  CurrSqStr: AnsiString;
  bx,by: Integer;
  i: Integer;
begin
  inherited;
  if not FSetupMode then
  begin
    if not FPiecesImageList.Dragging then
    begin
      DragImageIndex := 0;
      case FDraggingPiece of
      WhitePawn: DragImageIndex := 0;
      WhiteRook: DragImageIndex := 1;
      WhiteKnight: DragImageIndex := 2;
      WhiteBiShop: DragImageIndex := 3;
      WhiteQueen: DragImageIndex := 4;
      WhiteKing: DragImageIndex := 5;
      BlackPawn: DragImageIndex := 6;
      BlackRook: DragImageIndex := 7;
      BlackKnight: DragImageIndex := 8;
      BlackBiShop: DragImageIndex := 9;
      BlackQueen: DragImageIndex := 10;
      BlackKing: DragImageIndex := 11;
      end;
      ClearSrcSquare(FClick1Sq);
      FPiecesImageList.SetDragImage(DragImageIndex, 0,0);
      FPiecesImageList.BeginDrag (Parent.Handle,0,0);
    end;

    Accept := False;

    if GetBoardSquareFromPoint(Point(x,y),bx,by) then
    begin
      CurrSqStr := SquareToStr(bx,by);
      DbgLabel.Caption := string(CurrSqStr);
      FLastDragSq := CurrSqStr;
      if CurrSqStr<>FClick1Sq then
      begin
        for i := 0 to FLegalMoveList.Count - 1 do
          if AnsiString(Copy(FLegalMoveList.Strings[i], 1, 4))=FClick1Sq+CurrSqStr then
          begin
            Accept := True;
            break;
          end;
      end;
    end;
    FPiecesImageList.DragMove(X+Left-FSquareSize shr 1,Y+Top-FSquareSize shr 1);
  end
  else
    Accept := True;
end;

procedure TChessBoard.DragPiece(Piece: Byte);
begin
  if FSetupMode then
  begin
    FDraggingPiece := Piece;
      BeginDrag(False);
  end;
end;

procedure TChessBoard.DrawBoard;
var
  x,y: Integer;
  Cl: Integer;
begin
  if FUpdating<1 then
  begin
    FSquareSize := (Width - BorderSize * 2) div 8;
    for y := 0 to 7 do
      for x := 0 to 7 do
      begin
        if ((x+y) and 1=0) then
          Cl := FSquareColorLight
        else
          Cl := FSquareColorDark;
        Canvas.Brush.Color := cl;
        Canvas.FillRect(Rect(BorderSize+x*FSquareSize,BorderSize+y*FSquareSize,BorderSize+x*FSquareSize+SquareSize,BorderSize+y*FSquareSize+SquareSize));
      end;
  end;
end;

procedure TChessBoard.DrawBorder;
var
  ColChars: AnsiString;
  RowChars: AnsiString;
  i,x,y: Integer;
begin
  if FUpdating<1 then
  begin
    if WhiteOnTop then
    begin
      ColChars := 'HGFEDCBA';
      RowChars := '12345678'
    end
    else
    begin
      ColChars := 'ABCDEFGH';
      RowChars := '87654321'
    end;
    Canvas.Brush.Color := BorderColor;
    Canvas.FillRect(Rect(0,0,BorderSize,Height));
    Canvas.FillRect(Rect(Width-BorderSize,0,Width,Height));
    Canvas.FillRect(Rect(0,0,Width,BorderSize));
    Canvas.FillRect(Rect(0,Height-BorderSize,Width,Height));
    Canvas.Font.Name := 'Arial';
    Canvas.Font.Color := clWhite;
    Canvas.Font.Size := 7;
    Canvas.Font.Pitch := fpDefault;
    Canvas.Font := FBLFont;
    if blTop in BorderLabels then
    begin
      for i := 0 to 7 do
      begin
        x := FBorderSize+(FSquareSize*i)+(FSquareSize-Canvas.TextWidth(string(ColChars[i+1]))) div 2;
        y := (FBorderSize-Canvas.TextHeight(string(ColChars[i+1]))) div 2;
        Canvas.TextOut(x,y,string(ColChars[i+1]));
      end;
    end;
    if blLeft in BorderLabels then
    begin
      for i := 0 to 7 do
      begin
        x := (FBorderSize-Canvas.TextWidth(string(RowChars[i+1]))) div 2;
        y := FBorderSize+(FSquareSize*i)+(FSquareSize-Canvas.TextHeight(string(RowChars[i+1]))) div 2;
        Canvas.TextOut(x,y,string(RowChars[i+1]));
      end;
    end;
    if blBottom in BorderLabels then
    begin
      for i := 0 to 7 do
      begin
        x := FBorderSize+(FSquareSize*i)+(FSquareSize-Canvas.TextWidth(string(ColChars[i+1]))) div 2;
        y := Height-FBorderSize+(FBorderSize-Canvas.TextHeight(string(ColChars[i+1]))) div 2;
        Canvas.TextOut(x,y,string(ColChars[i+1]));
      end;
    end;
    if blRight in BorderLabels then
    begin
      for i := 0 to 7 do
      begin
        x := Width-FBorderSize+(FBorderSize-Canvas.TextWidth(string(ColChars[i+1]))) div 2;
        y := FBorderSize+(FSquareSize*i)+(FSquareSize-Canvas.TextHeight(String(RowChars[i+1]))) div 2;
        Canvas.TextOut(x,y,string(RowChars[i+1]));
      end;
    end;
  end;
end;

procedure TChessBoard.DrawPieces;
var
  i,j: Integer;
  X,Y: Integer;
  MidVar: Integer;
begin
  if FUpdating<1 then
  begin
    MidVar := (FSquareSize-FPiecesImageList.Width) div 2;
    for i := 0 to 7 do
      for j := 0 to 7 do
      begin
        if WhiteOnTop then
        begin
          x := FBorderSize+(7-i)*FSquareSize+MidVar;
          Y := FBorderSize+j*FSquareSize+MidVar;
        end
        else
        begin
          x := FBorderSize+i*FSquareSize+MidVar;
          Y := FBorderSize+(7-j)*FSquareSize+MidVar;
        end;
        case PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex]).Board[i,j] of
        BlackPawn:   FPiecesImageList.Draw(Canvas,X,Y,6);
        BlackRook:   FPiecesImageList.Draw(Canvas,X,Y,7);
        BlackKnight: FPiecesImageList.Draw(Canvas,X,Y,8);
        BlackBiShop: FPiecesImageList.Draw(Canvas,X,Y,9);
        BlackQueen:  FPiecesImageList.Draw(Canvas,X,Y,10);
        BlackKing:   FPiecesImageList.Draw(Canvas,X,Y,11);

        WhitePawn:   FPiecesImageList.Draw(Canvas,X,Y,0);
        WhiteRook:   FPiecesImageList.Draw(Canvas,X,Y,1);
        WhiteKnight: FPiecesImageList.Draw(Canvas,X,Y,2);
        WhiteBiShop: FPiecesImageList.Draw(Canvas,X,Y,3);
        WhiteQueen:  FPiecesImageList.Draw(Canvas,X,Y,4);
        WhiteKing:   FPiecesImageList.Draw(Canvas,X,Y,5);
        end;
      end;
  end;
end;

procedure TChessBoard.DrawSquare(Sq: AnsiString);
var
  i,j: Integer;
  X,Y: Integer;
  MidVar: Integer;
begin
  if Sq = '' then
    Exit;
  i := Byte(Sq[1]) - 65;
  j := Byte(Sq[2]) - 49;
  MidVar := (FSquareSize-FPiecesImageList.Width) div 2;

  if WhiteOnTop then
  begin
    x := FBorderSize+(7-i)*FSquareSize+MidVar;
    Y := FBorderSize+j*FSquareSize+MidVar;
  end
  else
  begin
    x := FBorderSize+i*FSquareSize+MidVar;
    Y := FBorderSize+(7-j)*FSquareSize+MidVar;
  end;

  case PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex]).Board[i,j] of
  BlackPawn:   FPiecesImageList.Draw(Canvas,X,Y,6);
  BlackRook:   FPiecesImageList.Draw(Canvas,X,Y,7);
  BlackKnight: FPiecesImageList.Draw(Canvas,X,Y,8);
  BlackBiShop: FPiecesImageList.Draw(Canvas,X,Y,9);
  BlackQueen:  FPiecesImageList.Draw(Canvas,X,Y,10);
  BlackKing:   FPiecesImageList.Draw(Canvas,X,Y,11);

  WhitePawn:   FPiecesImageList.Draw(Canvas,X,Y,0);
  WhiteRook:   FPiecesImageList.Draw(Canvas,X,Y,1);
  WhiteKnight: FPiecesImageList.Draw(Canvas,X,Y,2);
  WhiteBiShop: FPiecesImageList.Draw(Canvas,X,Y,3);
  WhiteQueen:  FPiecesImageList.Draw(Canvas,X,Y,4);
  WhiteKing:   FPiecesImageList.Draw(Canvas,X,Y,5);
  end;
end;

procedure TChessBoard.EndUpdate;
begin
  Dec(FUpdating);
  Paint;
end;

function TChessBoard.FENString(Board: TChessBoardState): AnsiString;
var
  x,y,i: Integer;
  CastleStr: AnsiString;
begin
  for y := 7 downto 0 do
  begin
    i := 0;
    for x := 0 to 7 do
    begin
      if (i<>0) and (Board.Board[x,y]<>0) then
      begin
        Result := Result+AnsiString(IntToStr(i));
        i := 0;
      end;

      if Board.Board[x,y]<>0 then
        Result := Result+FLegalMoves.PieceToAnsiChar(Board.Board[x,y])
      else
        i := i+1;
    end;
    if i<>0 then
      Result := Result+AnsiString(IntToStr(i));
    if y>0 then
      Result := Result +'/';
  end;
  if Board.IsWhiteToMove then
    Result := Result + ' w'
  else
    Result := Result + ' b';

  Result := Result + ' ';

  CastleStr := '';
  if Board.WhiteCanCastleKingSide then
    CastleStr := CastleStr + 'K';
  if Board.WhiteCanCastleQueenSide then
    CastleStr := CastleStr + 'Q';
  if Board.BlackCanCastleKingSide then
    CastleStr := CastleStr + 'k';
  if Board.BlackCanCastleQueenSide then
    CastleStr := CastleStr + 'q';

  if CastleStr<>'' then
    Result := Result + CastleStr
  else
    Result := Result + '-';


  if Board.EnpasantPosX=-1 then
    Result := Result + ' -'
  else
  begin
    Result := Result + ' '+AnsiChar(Byte('a')+Board.EnpasantPosX);

    if Board.EnpasantPosY = 4 then
      Result := Result + '3'
    else
      Result := Result + '6'
  end;

  Result := Result + ' '+AnsiString(IntToStr(Board.FiftyMoveVariable));
end;

procedure TChessBoard.FreeBitmaps;
begin
  FWhiteQueenBitmap.Free;
  FWhitePawnBitmap.Free;
  FWhiteRookBitmap.Free;
  FWhiteKnightBitmap.Free;
  FWhiteBishopBitmap.Free;
  FWhiteKingBitmap.Free;
  FBlackQueenBitmap.Free;
  FBlackPawnBitmap.Free;
  FBlackRookBitmap.Free;
  FBlackKnightBitmap.Free;
  FBlackBishopBitmap.Free;
  FBlackKingBitmap.Free;
  FPiecesImageList.Clear;
end;

function TChessBoard.GetBoardSquareFromPoint(P: TPoint; var x,
  y: Integer): Boolean;
begin
  if (P.X<BorderSize) or (P.X>Width-BorderSize) or (P.Y<BorderSize) or (P.Y>Height-BorderSize) then
  begin
    Result := False;
    Exit;
  end
  else
  begin
    Result := True;
    x := (P.X-FBorderSize) div FSquareSize;
    y := (P.Y-FBorderSize) div FSquareSize;
  end;
end;

function TChessBoard.GetFENPosition: AnsiString;
begin
  Result := FENString(PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex])^);
end;

function TChessBoard.GetIsWhiteToMove: Boolean;
begin
  Result := FIsWhiteToMove;
end;

procedure TChessBoard.DoHighLightLastMove;
var
  x,y,x1,y1: Integer;
begin
  if FUpdating<1 then
  begin
    if (FLastMoveSq1='') or (FLastMoveSq2='') or (not HighLightLastMove) then
      Exit;

    Canvas.Brush.Color := HighLightColor;
    x1 := Byte(UpCase(FLastMoveSq1[1])) - 65;
    y1 := Byte(FLastMoveSq1[2]) - 49;

    if WhiteOnTop then
    begin
      x := FBorderSize+(7-x1)*FSquareSize;
      Y := FBorderSize+y1*FSquareSize;
    end
    else
    begin
      x := FBorderSize+x1*FSquareSize;
      Y := FBorderSize+(7-y1)*FSquareSize;
    end;

    Canvas.FrameRect(Rect(x,y,x+FSquareSize,y+FSquareSize));
    Canvas.FrameRect(Rect(x+1,y+1,x+FSquareSize-1,y+FSquareSize-1));

    x1 := Byte(UpCase(FLastMoveSq2[1])) - 65;
    y1 := Byte(FLastMoveSq2[2]) - 49;

    if WhiteOnTop then
    begin
      x := FBorderSize+(7-x1)*FSquareSize;
      Y := FBorderSize+y1*FSquareSize;
    end
    else
    begin
      x := FBorderSize+x1*FSquareSize;
      Y := FBorderSize+(7-y1)*FSquareSize;
    end;
    Canvas.FrameRect(Rect(x,y,x+FSquareSize,y+FSquareSize));
    Canvas.FrameRect(Rect(x+1,y+1,x+FSquareSize-1,y+FSquareSize-1));
  end;
end;

procedure TChessBoard.HighLightPV;
var
  x,y,x1,y1: Integer;
begin
  if not PVHighLight then
    Exit;
  if FUpdating<1 then
  begin
    if (PV='') or (not FPVHighLight) then
      Exit;

    Canvas.Brush.Color := FPVHighLightColor;
    x1 := Byte(UpCase(FPV[1])) - 65;
    y1 := Byte(FPV[2]) - 49;

    if WhiteOnTop then
    begin
      x := FBorderSize+(7-x1)*FSquareSize;
      Y := FBorderSize+y1*FSquareSize;
    end
    else
    begin
      x := FBorderSize+x1*FSquareSize;
      Y := FBorderSize+(7-y1)*FSquareSize;
    end;

    Canvas.FrameRect(Rect(x+2,y+2,x+FSquareSize-2,y+FSquareSize-2));

    x1 := Byte(UpCase(FPV[3])) - 65;
    y1 := Byte(FPV[4]) - 49;

    if WhiteOnTop then
    begin
      x := FBorderSize+(7-x1)*FSquareSize;
      Y := FBorderSize+y1*FSquareSize;
    end
    else
    begin
      x := FBorderSize+x1*FSquareSize;
      Y := FBorderSize+(7-y1)*FSquareSize;
    end;
    Canvas.FrameRect(Rect(x+2,y+2,x+FSquareSize-2,y+FSquareSize-2));
  end;
end;

procedure TChessBoard.LoadBoard(FileName: string);
var
  i,j: Integer;
  ChBoard: PChessBoardState;
  FileStream: TFileStream;
begin
  FMoveList.Clear;
  while FPositionStrList.Count>0 do
  begin
    FreeMem(Pointer(FPositionStrList.Objects[0]));
    FPositionStrList.Delete(0);
  end;
  GetMem(ChBoard,SizeOf(TChessBoardState));
  for i := 0 to 7 do
    for j := 0 to 7 do
      ChBoard.Board[i,j] := StartPos[j,i];
  ChBoard.WhiteCanCastleKingSide := True;
  ChBoard.WhiteCanCastleQueenSide := True;
  ChBoard.BlackCanCastleKingSide := True;
  ChBoard.BlackCanCastleQueenSide := True;
  ChBoard.FiftyMoveVariable := 0;
  ChBoard.EnpasantPosX := -1;
  ChBoard.EnpasantPosY := -1;
  ChBoard.IsWhiteToMove := True;

  FileStream := TFileStream.Create(FileName,fmOpenRead);
  FileStream.Read(ChBoard^,SizeOf(TChessBoardState));
  FileStream.Free;

  FLegalMoveList.Clear;
  FLegalMoves.GetMoveList(ChBoard^,FLegalMoveList);
  FPositionStrList.AddObject(string(PositionString(ChBoard^)),TObject(ChBoard));
  FIsWhiteToMove := True;
  FCurrentPositionIndex := 0;
  FLastMoveSq1 := '';
  FLastMoveSq2 := '';
  Paint;
end;

procedure TChessBoard.LoadMediumBitmaps;
begin
  FBlackPawnBitmap := TBitmap.Create;
  FBlackRookBitmap := TBitmap.Create;
  FBlackKnightBitmap := TBitmap.Create;
  FBlackBishopBitmap := TBitmap.Create;
  FBlackQueenBitmap := TBitmap.Create;
  FBlackKingBitmap := TBitmap.Create;

  FWhitePawnBitmap := TBitmap.Create;
  FWhiteRookBitmap := TBitmap.Create;
  FWhiteKnightBitmap := TBitmap.Create;
  FWhiteBishopBitmap := TBitmap.Create;
  FWhiteQueenBitmap := TBitmap.Create;
  FWhiteKingBitmap := TBitmap.Create;
  AssignChessBoardBitmap(FBlackPawnBitmap,'BlackPawn');
  AssignChessBoardBitmap(FBlackRookBitmap,'BlackRook');
  AssignChessBoardBitmap(FBlackKingBitmap,'BlackKing');
  AssignChessBoardBitmap(FBlackQueenBitmap,'BlackQueen');
  AssignChessBoardBitmap(FBlackKnightBitmap,'BlackKnight');
  AssignChessBoardBitmap(FBlackBishopBitmap,'BlackBishop');

  AssignChessBoardBitmap(FWhitePawnBitmap,'WhitePawn');
  AssignChessBoardBitmap(FWhiteRookBitmap,'WhiteRook');
  AssignChessBoardBitmap(FWhiteKingBitmap,'WhiteKing');
  AssignChessBoardBitmap(FWhiteQueenBitmap,'WhiteQueen');
  AssignChessBoardBitmap(FWhiteKnightBitmap,'WhiteKnight');
  AssignChessBoardBitmap(FWhiteBishopBitmap,'WhiteBishop');

  FPiecesImageList.Width := 40;
  FPiecesImageList.Height := 40;

  FPiecesImageList.AddMasked(FWhitePawnBitmap,FWhitePawnBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteRookBitmap,FWhiteRookBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteKnightBitmap,FWhiteKnightBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteBishopBitmap,FWhiteBishopBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteQueenBitmap,FWhiteQueenBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteKingBitmap,FWhiteKingBitmap.Canvas.Pixels[0,0]);

  FPiecesImageList.AddMasked(FBlackPawnBitmap,FBlackPawnBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackRookBitmap,FBlackRookBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackKnightBitmap,FBlackKnightBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackBishopBitmap,FBlackBishopBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackQueenBitmap,FBlackQueenBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackKingBitmap,FBlackKingBitmap.Canvas.Pixels[0,0]);

  FPiecesImageList.Masked := True;
  FPiecesImageList.DrawingStyle := dsTransparent;
end;

procedure TChessBoard.LoadTinyBitmaps;
begin
  FBlackPawnBitmap := TBitmap.Create;
  FBlackRookBitmap := TBitmap.Create;
  FBlackKnightBitmap := TBitmap.Create;
  FBlackBishopBitmap := TBitmap.Create;
  FBlackQueenBitmap := TBitmap.Create;
  FBlackKingBitmap := TBitmap.Create;

  FWhitePawnBitmap := TBitmap.Create;
  FWhiteRookBitmap := TBitmap.Create;
  FWhiteKnightBitmap := TBitmap.Create;
  FWhiteBishopBitmap := TBitmap.Create;
  FWhiteQueenBitmap := TBitmap.Create;
  FWhiteKingBitmap := TBitmap.Create;
  AssignChessBoardBitmap(FBlackPawnBitmap,'BlackPawn22x22');
  AssignChessBoardBitmap(FBlackRookBitmap,'BlackRook22x22');
  AssignChessBoardBitmap(FBlackKingBitmap,'BlackKing22x22');
  AssignChessBoardBitmap(FBlackQueenBitmap,'BlackQueen22x22');
  AssignChessBoardBitmap(FBlackKnightBitmap,'BlackKnight22x22');
  AssignChessBoardBitmap(FBlackBishopBitmap,'BlackBishop22x22');

  AssignChessBoardBitmap(FWhitePawnBitmap,'WhitePawn22x22');
  AssignChessBoardBitmap(FWhiteRookBitmap,'WhiteRook22x22');
  AssignChessBoardBitmap(FWhiteKingBitmap,'WhiteKing22x22');
  AssignChessBoardBitmap(FWhiteQueenBitmap,'WhiteQueen22x22');
  AssignChessBoardBitmap(FWhiteKnightBitmap,'WhiteKnight22x22');
  AssignChessBoardBitmap(FWhiteBishopBitmap,'WhiteBishop22x22');

  FPiecesImageList.Width := 22;
  FPiecesImageList.Height := 22;

  FPiecesImageList.AddMasked(FWhitePawnBitmap,FWhitePawnBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteRookBitmap,FWhiteRookBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteKnightBitmap,FWhiteKnightBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteBishopBitmap,FWhiteBishopBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteQueenBitmap,FWhiteQueenBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteKingBitmap,FWhiteKingBitmap.Canvas.Pixels[0,0]);

  FPiecesImageList.AddMasked(FBlackPawnBitmap,FBlackPawnBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackRookBitmap,FBlackRookBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackKnightBitmap,FBlackKnightBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackBishopBitmap,FBlackBishopBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackQueenBitmap,FBlackQueenBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackKingBitmap,FBlackKingBitmap.Canvas.Pixels[0,0]);

  FPiecesImageList.Masked := True;
  FPiecesImageList.DrawingStyle := dsTransparent;
end;

procedure TChessBoard.LoadSmallBitmaps;
begin
  FBlackPawnBitmap := TBitmap.Create;
  FBlackRookBitmap := TBitmap.Create;
  FBlackKnightBitmap := TBitmap.Create;
  FBlackBishopBitmap := TBitmap.Create;
  FBlackQueenBitmap := TBitmap.Create;
  FBlackKingBitmap := TBitmap.Create;

  FWhitePawnBitmap := TBitmap.Create;
  FWhiteRookBitmap := TBitmap.Create;
  FWhiteKnightBitmap := TBitmap.Create;
  FWhiteBishopBitmap := TBitmap.Create;
  FWhiteQueenBitmap := TBitmap.Create;
  FWhiteKingBitmap := TBitmap.Create;
  AssignChessBoardBitmap(FBlackPawnBitmap,'BlackPawn30x30');
  AssignChessBoardBitmap(FBlackRookBitmap,'BlackRook30x30');
  AssignChessBoardBitmap(FBlackKingBitmap,'BlackKing30x30');
  AssignChessBoardBitmap(FBlackQueenBitmap,'BlackQueen30x30');
  AssignChessBoardBitmap(FBlackKnightBitmap,'BlackKnight30x30');
  AssignChessBoardBitmap(FBlackBishopBitmap,'BlackBishop30x30');

  AssignChessBoardBitmap(FWhitePawnBitmap,'WhitePawn30x30');
  AssignChessBoardBitmap(FWhiteRookBitmap,'WhiteRook30x30');
  AssignChessBoardBitmap(FWhiteKingBitmap,'WhiteKing30x30');
  AssignChessBoardBitmap(FWhiteQueenBitmap,'WhiteQueen30x30');
  AssignChessBoardBitmap(FWhiteKnightBitmap,'WhiteKnight30x30');
  AssignChessBoardBitmap(FWhiteBishopBitmap,'WhiteBishop30x30');

  FPiecesImageList.Width := 30;
  FPiecesImageList.Height := 30;

  FPiecesImageList.AddMasked(FWhitePawnBitmap,FWhitePawnBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteRookBitmap,FWhiteRookBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteKnightBitmap,FWhiteKnightBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteBishopBitmap,FWhiteBishopBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteQueenBitmap,FWhiteQueenBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FWhiteKingBitmap,FWhiteKingBitmap.Canvas.Pixels[0,0]);

  FPiecesImageList.AddMasked(FBlackPawnBitmap,FBlackPawnBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackRookBitmap,FBlackRookBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackKnightBitmap,FBlackKnightBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackBishopBitmap,FBlackBishopBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackQueenBitmap,FBlackQueenBitmap.Canvas.Pixels[0,0]);
  FPiecesImageList.AddMasked(FBlackKingBitmap,FBlackKingBitmap.Canvas.Pixels[0,0]);

  FPiecesImageList.Masked := True;
  FPiecesImageList.DrawingStyle := dsTransparent;
end;

procedure TChessBoard.Paint;
begin
  inherited;
  if FUpdating<1 then
  begin
    Resize;
    DrawBorder;
    DrawBoard;
    DrawPieces;
    DoHighLightLastMove;
    HighLightPV;
  end;
end;

function TChessBoard.PositionString(Board: TChessBoardState): AnsiString;
var
  x,y,i: Integer;
begin
  for y := 7 downto 0 do
  begin
    i := 0;
    for x := 0 to 7 do
    begin
      if (i<>0) and (Board.Board[x,y]<>0) then
      begin
        Result := Result+AnsiString(IntToStr(i));
        i := 0;
      end;

      if Board.Board[x,y]<>0 then
        Result := Result+FLegalMoves.PieceToAnsiChar(Board.Board[x,y])
      else
        i := i+1;
    end;
    if i<>0 then
      Result := Result+AnsiString(IntToStr(i));
    if y>0 then
      Result := Result +'/';
  end;
end;

procedure TChessBoard.Resize;
begin
  inherited;
  if FPiecesImageList<>nil then
  begin
    if (Width-FBorderSize*2<280) and (FPiecesImageList.Width<>22) then
    begin
      FreeBitmaps;
      LoadTinyBitmaps;
    end
    else
    if (Width-FBorderSize*2<320) and (Width-FBorderSize*2>=280) and (FPiecesImageList.Width<>30) then
    begin
      FreeBitmaps;
      LoadSmallBitmaps;
    end
    else
    if (Width-FBorderSize*2>360) and (FPiecesImageList.Width<>40) then
    begin
      FreeBitmaps;
      LoadMediumBitmaps;
    end;
  end;
end;

procedure TChessBoard.SetBlackBishopBitmap(const Value: TBitmap);
begin
  FBlackBishopBitmap := Value;
end;

procedure TChessBoard.SetBlackKingBitmap(const Value: TBitmap);
begin
  FBlackKingBitmap := Value;
end;

procedure TChessBoard.SetBlackKnightBitmap(const Value: TBitmap);
begin
  FBlackKnightBitmap := Value;
end;

procedure TChessBoard.SetBlackPawnBitmap(const Value: TBitmap);
begin
  FBlackPawnBitmap := Value;
end;

procedure TChessBoard.SetBlackQueenBitmap(const Value: TBitmap);
begin
  FBlackQueenBitmap := Value;
end;

procedure TChessBoard.SetBlackRookBitmap(const Value: TBitmap);
begin
  FBlackRookBitmap := Value;
end;

procedure TChessBoard.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  DrawBorder;
end;

procedure TChessBoard.SetBorderLabels(const Value: TBorderLabels);
begin
  FBorderLabels := Value;
  DrawBorder;
end;

procedure TChessBoard.SetBorderSize(const Value: Integer);
begin
  FBorderSize := Value;
  Width := Width-1; // call CanResize and get the new size according to this BorderSize
  DrawBorder;
end;

procedure TChessBoard.SetFENPosition(const Value: AnsiString);
var
  Board: PChessBoardState;
  StrList: TStringList;
  Str: string;
  FENPos: string;
  SideToMove: AnsiChar;
  CastlingRight: string;
  EnpasantPos: string;
  i,x,y: Integer;
  FenStrList: TStringList;
  FiftyMoveStr: AnsiString;
begin
  SideToMove := 'w';
  Str := string(Value);
  StrList := TStringList.Create;
  StrList.Delimiter := ' ';
  StrList.DelimitedText := Str;
  FENPos := StrList.Strings[0];
  if StrList.Count>1 then
  begin
    if Length(StrList.Strings[1])=1 then
      SideToMove := AnsiChar(StrList.Strings[1][1]);
  end
  else
    SideToMove := 'w';


  if StrList.Count>2 then
    CastlingRight := StrList.Strings[2]
  else
    CastlingRight := '-';

  if StrList.Count>3 then
    EnpasantPos := StrList.Strings[3]
  else
    EnpasantPos := '-';

  if StrList.Count>4 then
    FiftyMoveStr := AnsiString(StrList.Strings[4])
  else
    FiftyMoveStr := '0';

  GetMem(Board,SizeOf(TChessBoardState));
  ZeroMemory(Board,SizeOf(TChessBoardState));
  FenStrList := TStringList.Create;
  FenStrList.Delimiter :='/';
  FenStrList.DelimitedText := FENPos;
  if FenStrList.Count=8 then
  begin
    for y:= 7 downto 0 do
    begin
      x := 0;
      for i := 1 to Length(FenStrList.Strings[7-y]) do
      begin
        if (Byte(FenStrList.Strings[7-y][i])<=Byte('9')) and (Byte(FenStrList.Strings[7-y][i])>Byte('0')) then
        begin
          x := x+(Byte(FenStrList.Strings[7-y][i])-48);
          Continue;
        end
        else
        begin
          case FenStrList.Strings[7-y][i] of
          'p': Board.Board[x,y] := BlackPawn;
          'r': Board.Board[x,y] := BlackRook;
          'n': Board.Board[x,y] := BlackKnight;
          'b': Board.Board[x,y] := BlackBiShop;
          'q': Board.Board[x,y] := BlackQueen;
          'k': Board.Board[x,y] := BlackKing;
          'P': Board.Board[x,y] := WhitePawn;
          'R': Board.Board[x,y] := WhiteRook;
          'N': Board.Board[x,y] := WhiteKnight;
          'B': Board.Board[x,y] := WhiteBiShop;
          'Q': Board.Board[x,y] := WhiteQueen;
          'K': Board.Board[x,y] := WhiteKing;
          end;
          x:= x + 1;
        end;
      end;
    end;
  end;
  if SideToMove='w' then
    Board.IsWhiteToMove := True
  else
    Board.IsWhiteToMove := False;
  if CastlingRight<>'-' then
  begin
    if Pos('k',CastlingRight)>0 then
      Board.BlackCanCastleKingSide := True;
    if Pos('q',CastlingRight)>0 then
      Board.BlackCanCastleQueenSide := True;
    if Pos('K',CastlingRight)>0 then
      Board.WhiteCanCastleKingSide := True;
    if Pos('Q',CastlingRight)>0 then
      Board.WhiteCanCastleQueenSide := True;
  end;
  if EnpasantPos<>'-' then
  begin
    Board.EnpasantPosX := Byte(AsciiLowerChar(AnsiChar(EnpasantPos[1])))-Byte('a');
    if EnpasantPos[2]='3' then
      Board.EnpasantPosY := 2
    else
    if EnpasantPos[2]='6' then
      Board.EnpasantPosY := 4;
  end
  else
  begin
    Board.EnpasantPosX := -1;
    Board.EnpasantPosY := -1;
  end;

  StrList.Free;
  FenStrList.Free;
  // Clear all previous moves if any exist
  while FPositionStrList.Count>0 do
  begin
    FreeMem(Pointer(FPositionStrList.Objects[0]));
    FPositionStrList.Delete(0);
  end;
  FPositionStrList.AddObject(string(PositionString(Board^)),TObject(Board));
  FCurrentPositionIndex := 0;
  CurrentBoard := Board^;
  FLegalMoveList.Clear;
  FLegalMoves.GetMoveList(Board^,FLegalMoveList);
  FFENPosition := Value;
  DrawBorder;
  DrawBoard;
  DrawPieces;
end;

procedure TChessBoard.SetHighLightColor(const Value: TColor);
begin
  FHighLightColor := Value;
  Paint;
end;

procedure TChessBoard.SetIsWhiteToMove(const Value: Boolean);
begin
  FIsWhiteToMove := Value;
  PChessBoardState(FPositionStrList.Objects[FCurrentPositionIndex]).IsWhiteToMove := Value;
end;

procedure TChessBoard.SetOnBlackCastle(const Value: TOnMove);
begin
  FOnBlackCastle := Value;
  FLegalMoves.OnBlackCastle := Value;
end;

procedure TChessBoard.SetOnLegalMove(const Value: TOnMove);
begin
  FOnLegalMove := Value;
  FLegalMoves.OnLegalMove := Value;
end;

procedure TChessBoard.SetOnPromotion(const Value: TOnPromotion);
begin
  FOnPromotion := Value;
  FLegalMoves.OnPromotion := Value;
end;

procedure TChessBoard.SetOnWhiteCastle(const Value: TOnMove);
begin
  FOnWhiteCastle := Value;
  FLegalMoves.OnWhiteCastle := Value;
end;

procedure TChessBoard.SetPV(const Value: AnsiString);
begin
  if FPV<>Value then
  begin
    FPV := Value;
    if FPVHighLight then
      Paint;
  end;
end;

procedure TChessBoard.SetPVHighLightColor(const Value: TColor);
begin
  FPVHighLightColor := Value;
  Paint;
end;

procedure TChessBoard.SetSquareColorDark(const Value: TColor);
begin
  FSquareColorDark := Value;
  if Parent<>nil then
  begin
    DrawBoard;
    DrawPieces;
  end;
end;

procedure TChessBoard.SetSquareColorLight(const Value: TColor);
begin
  FSquareColorLight := Value;
  if Parent<>nil then
  begin
    DrawBoard;
    DrawPieces;
  end;
end;

procedure TChessBoard.SetSquareSize(const Value: Integer);
begin
  FSquareSize := Value;
end;

procedure TChessBoard.SetWhiteBishopBitmap(const Value: TBitmap);
begin
  FWhiteBishopBitmap := Value;
end;

procedure TChessBoard.SetWhiteKingBitmap(const Value: TBitmap);
begin
  FWhiteKingBitmap := Value;
end;

procedure TChessBoard.SetWhiteKnightBitmap(const Value: TBitmap);
begin
  FWhiteKnightBitmap := Value;
end;

procedure TChessBoard.SetWhiteOnTop(const Value: Boolean);
begin
  FWhiteOnTop := Value;
  Paint;
end;

procedure TChessBoard.SetWhitePawnBitmap(const Value: TBitmap);
begin
  FWhitePawnBitmap := Value;
end;

procedure TChessBoard.SetWhiteQueenBitmap(const Value: TBitmap);
begin
  FWhiteQueenBitmap := Value;
end;

procedure TChessBoard.SetWhiteRookBitmap(const Value: TBitmap);
begin
  FWhiteRookBitmap := Value;
end;

function TChessBoard.SquareToStr(x, y: Integer): AnsiString;
begin
  if FWhiteOnTop then
  begin
    x := 7-x;
    Result := AnsiChar(x+65)+AnsiString(IntToStr(y+1));
  end
  else
  begin
    y := 7-y;
    Result := AnsiChar(x+65)+AnsiString(IntToStr(y+1));
  end;
end;

end.
