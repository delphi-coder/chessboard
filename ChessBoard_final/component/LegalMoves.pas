unit LegalMoves;

interface

uses
  Windows, Classes, Math, ChessTypes, SysUtils, StrUtils;


function AsciiLowerMove(const S: AnsiString): AnsiString;
function AsciiLowerChar(C: AnsiChar): AnsiChar;

type
  TLegalMoves = class
  private
    FOnPromotion: TOnPromotion;
    FOnWhiteCastle: TOnMove;
    FOnBlackCastle: TOnMove;
    FOnCapture: TOnCapture;
    FOnLegalMove: TOnMove;
  public
    constructor Create;
    destructor Destroy; override;
    function IsBlackPiece(Piece: Byte): Boolean;
    function IsWhitePiece(Piece: Byte): Boolean;

    function IsBlackPawn(Piece:Byte): Boolean;
    function IsWhitePawn(Piece:Byte): Boolean;

    function IsBlackRook(Piece:Byte): Boolean;
    function IsWhiteRook(Piece:Byte): Boolean;

    function IsBlackknight(Piece:Byte): Boolean;
    function IsWhiteknight(Piece:Byte): Boolean;

    function IsBlackBishop(Piece:Byte): Boolean;
    function IsWhiteBishop(Piece:Byte): Boolean;

    function IsBlackQueen(Piece:Byte): Boolean;
    function IsWhiteQueen(Piece:Byte): Boolean;

    function IsBlackking(Piece:Byte): Boolean;
    function IsWhiteking(Piece:Byte): Boolean;

    function IsSquareUnderWhiteAttack(x,y: Byte; Board: TChessBoardState): Boolean;
    function IsSquareUnderBlackAttack(x,y: Byte; Board: TChessBoardState): Boolean;

    function IsBlackKingInCheck(Board: TChessBoardState): Boolean;
    function IsWhiteKingInCheck(Board: TChessBoardState): Boolean;

    procedure GetMoveList(Board: TChessBoardState; MoveList: TStringList);
    function GetWhiteMoveList(Board: TChessBoardState; MoveList: TStringList): TStringList;
    function GetBlackMoveList(Board: TChessBoardState; MoveList: TStringList): TStringList;

    procedure AddBlackPawnMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);
    procedure AddBlackBishopMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);
    procedure AddBlackKnightMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);
    procedure AddBlackQueenMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);
    procedure AddBlackRookMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);
    procedure AddBlackKingMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);

    procedure AddWhitePawnMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);
    procedure AddWhiteBishopMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);
    procedure AddWhiteKnightMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);
    procedure AddWhiteQueenMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);
    procedure AddWhiteRookMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);
    procedure AddWhiteKingMoveList(Board: TChessBoardState; x,y: Byte; MoveList: TStringList);

    function SquareStr(x,y: Integer): AnsiString;
    function PieceToAnsiChar(Piece: Byte): AnsiChar;
    function GetMoveStr(x1,y1,x2,y2: Byte): string;
    function DoMove(MoveStr: AnsiString; Board: TChessBoardState): TChessBoardState;
    function DoMove1(MoveStr: AnsiString; Board: TChessBoardState): TChessBoardState;
    property OnPromotion: TOnPromotion read FOnPromotion write FOnPromotion;
    property OnWhiteCastle: TOnMove read FOnWhiteCastle write FOnWhiteCastle;
    property OnBlackCastle: TOnMove read FOnBlackCastle write FOnBlackCastle;
    property OnLegalMove: TOnMove read FOnLegalMove write FOnLegalMove;
    property OnCapture: TOnCapture read FOnCapture write FOnCapture;
  end;

implementation

function AsciiLowerMove(const S: AnsiString): AnsiString;
var
  I: Integer;
begin
  Result := S;
  for I := 1 to Length(Result) do
    if (Result[I] >= 'A') and (Result[I] <= 'Z') then
      Result[I] := AnsiChar(Ord(Result[I]) + 32);
end;

function AsciiLowerChar(C: AnsiChar): AnsiChar;
begin
  Result := C;
  if (Result >= 'A') and (Result <= 'Z') then
    Result := AnsiChar(Ord(Result) + 32);
end;

function MoveText(X1, Y1, X2, Y2: Integer): AnsiString;
begin
  Result := AnsiChar(65 + X1) + AnsiChar(49 + Y1) +
            AnsiChar(65 + X2) + AnsiChar(49 + Y2);
end;

{ TLegalMoves }



procedure TLegalMoves.AddBlackBishopMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  i: Integer;
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  // up right
  if (x<7) and (y<7) then
  begin
    i := 1;
    while ((x+i)<=7) and ((Y+i)<=7) do
    begin
      if Board.Board[x+i,y+i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y+i] := BlackBiShop;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y+i));
        LocalBoard := Board;
      end
      else
      if IsBlackPiece(Board.Board[x+i,y+i]) then
        break;
      if IsWhitePiece(Board.Board[x+i,y+i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y+i] := BlackBiShop;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y+i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // down right
  if (x<7) and (y>0) then
  begin
    i := 1;
    while ((x+i)<=7) and ((y-i)>=0) do
    begin
      if Board.Board[x+i,y-i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y-i] := BlackBiShop;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y-i));
        LocalBoard := Board;
      end;
      if IsBlackPiece(Board.Board[x+i,y-i]) then
        break;
      if IsWhitePiece(Board.Board[x+i,y-i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y-i] := BlackBiShop;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y-i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // up left
  if (x>0) and (y<7) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y+i)<=7) do
    begin
      if Board.Board[x-i,y+i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y+i] := BlackBiShop;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y+i));
        LocalBoard := Board;
      end;
      if IsBlackPiece(Board.Board[x-i,y+i]) then
        break;
      if IsWhitePiece(Board.Board[x-i,y+i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y+i] := BlackBiShop;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y+i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // down left
  if (x>0) and (y>0) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y-i)>=0) do
    begin
      if Board.Board[x-i,y-i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y-i] := BlackBiShop;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y-i));
        LocalBoard := Board;
      end;
      if IsBlackPiece(Board.Board[x-i,y-i]) then
        break;
      if IsWhitePiece(Board.Board[x-i,y-i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y-i] := BlackBiShop;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y-i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
end;

procedure TLegalMoves.AddBlackKingMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  if x<7 then
  begin
    // in this case we normaly have x+1,y
    if not IsBlackPiece(Board.Board[x+1,y]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x+1,y] := BlackKing;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x+1,y));
      LocalBoard := Board;
    end;
    if y<7 then
    begin
      if not IsBlackPiece(Board.Board[x+1,y+1]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+1,y+1] := BlackKing;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+1,y+1));
        LocalBoard := Board;
      end;
    end;
    if y>0 then
    begin
      if not IsBlackPiece(Board.Board[x+1,y-1]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+1,y-1] := BlackKing;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+1,y-1));
        LocalBoard := Board;
      end;
    end;
  end;

  if x>0 then
  begin
    // in this case we normaly have x-1,y
    if not IsBlackPiece(Board.Board[x-1,y]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x-1,y] := BlackKing;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x-1,y));
      LocalBoard := Board;
    end;
    if y<7 then
    begin
      if not IsBlackPiece(Board.Board[x-1,y+1]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-1,y+1] := BlackKing;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-1,y+1));
        LocalBoard := Board;
      end;
    end;
    if y>0 then
    begin
      if not IsBlackPiece(Board.Board[x-1,y-1]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-1,y-1] := BlackKing;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-1,y-1));
        LocalBoard := Board;
      end;
    end;
  end;

  if y<7 then
    if not IsBlackPiece(Board.Board[x,y+1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y+1] := BlackKing;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y+1));
      LocalBoard := Board;
    end;

  if y>0 then
    if not IsBlackPiece(Board.Board[x,y-1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y-1] := BlackKing;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y-1));
      LocalBoard := Board;
    end;
  if (x=4) and (y=7) then // is king placed in initial location??
  begin
    // check for king side castle
    if IsBlackRook(Board.Board[7,7]) and
      (Board.Board[6,7]=0) and
      (Board.Board[5,7]=0) and
      Board.BlackCanCastleKingSide and
      (not IsSquareUnderWhiteAttack(6,7,Board)) and
      (not IsSquareUnderWhiteAttack(5,7,Board)) and
      (not IsBlackKingInCheck(Board)) then
      MoveList.Add('E8G8');
    if IsBlackRook(Board.Board[0,7]) and
      (Board.Board[1,7]=0) and
      (Board.Board[2,7]=0) and
      (Board.Board[3,7]=0) and
      Board.BlackCanCastleQueenSide and
      (not IsSquareUnderWhiteAttack(2,7,Board)) and
      (not IsSquareUnderWhiteAttack(3,7,Board)) and
      (not IsBlackKingInCheck(Board)) then
      MoveList.Add('E8C8');
  end;
end;

procedure TLegalMoves.AddBlackKnightMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  if (x-1>=0) and (y-2>=0) then
    if not IsBlackPiece(Board.Board[x-1,y-2]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x-1,y-2] := BlackKnight;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x-1,y-2));
      LocalBoard := Board;
    end;

  if (x-1>=0) and (y+2<=7) then
    if not IsBlackPiece(Board.Board[x-1,y+2]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x-1,y+2] := BlackKnight;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x-1,y+2));
      LocalBoard := Board;
    end;

  if (x-2>=0) and (y-1>=0) then
    if not IsBlackPiece(Board.Board[x-2,y-1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x-2,y-1] := BlackKnight;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x-2,y-1));
      LocalBoard := Board;
    end;

  if (x-2>=0) and (y+1<=7) then
    if not IsBlackPiece(Board.Board[x-2,y+1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x-2,y+1] := BlackKnight;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x-2,y+1));
      LocalBoard := Board;
    end;

  if (x+1<=7) and (y-2>=0) then
    if not IsBlackPiece(Board.Board[x+1,y-2]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x+1,y-2] := BlackKnight;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x+1,y-2));
      LocalBoard := Board;
    end;

  if (x+1<=7) and (y+2<=7) then
    if not IsBlackPiece(Board.Board[x+1,y+2]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x+1,y+2] := BlackKnight;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x+1,y+2));
      LocalBoard := Board;
    end;

  if (x+2<=7) and (y-1>=0) then
    if not IsBlackPiece(Board.Board[x+2,y-1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x+2,y-1] := BlackKnight;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x+2,y-1));
      LocalBoard := Board;
    end;

  if (x+2<=7) and (y+1<=7) then
    if not IsBlackPiece(Board.Board[x+2,y+1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x+2,y+1] := BlackKnight;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x+2,y+1));
      LocalBoard := Board;
    end;
end;

procedure TLegalMoves.AddBlackPawnMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  if y>1 then  // NotInPromotion state
  begin
    if y=3 then // enpasant possiblity
    begin
      if (x<7) and (Board.EnpasantPosX = x+1) then // enpasant to right side
      begin
        LocalBoard.Board[x+1,y] := 0;
        LocalBoard.Board[x+1,y-1] := BlackPawn;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+1,y-1));
        LocalBoard := Board;
      end;
      if (x>0) and (Board.EnpasantPosX = x-1) then // enpasant to left side
      begin
        LocalBoard.Board[x-1,y] := 0;
        LocalBoard.Board[x-1,y-1] := BlackPawn;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-1,y-1));
        LocalBoard := Board;
      end;
    end;

    if Board.Board[x,y-1]=0 then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y-1] := BlackPawn;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y-1));
      LocalBoard := Board;
    end;

    if y=6 then  // First Pawn move. we can move 2 square here
      if (Board.Board[x,y-1]=0) and (Board.Board[x,y-2]=0) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x,y-2] := BlackPawn;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x,y-2));
        LocalBoard := Board;
      end;

    if x<7 then
    begin
      if Board.Board[x+1,y-1]<>0 then
      begin
        if IsWhitePiece(Board.Board[x+1,y-1]) then
        begin
          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x+1,y-1] := BlackPawn;
          if not IsBlackKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x+1,y-1));
          LocalBoard := Board;
        end;
      end;
    end;

    if x>0 then
    begin
      if Board.Board[x-1,y-1]<>0 then
      begin
        if IsWhitePiece(Board.Board[x-1,y-1]) then
        begin
          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x-1,y-1] := BlackPawn;
          if not IsBlackKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x-1,y-1));
          LocalBoard := Board;
        end;
      end;
    end;
  end
  else
  begin
    if Board.Board[x,y-1]=0 then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y-1] := BlackRook;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y-1)+'r');
      LocalBoard := Board;

      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y-1] := BlackKnight;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y-1)+'n');
      LocalBoard := Board;

      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y-1] := BlackBiShop;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y-1)+'b');
      LocalBoard := Board;

      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y-1] := BlackQueen;
      if not IsBlackKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y-1)+'q');
      LocalBoard := Board;
    end;

    if x<7 then
    begin
      if Board.Board[x+1,y-1]<>0 then
      begin
        if IsWhitePiece(Board.Board[x+1,y-1]) then
        begin
          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x+1,y-1] := BlackRook;
          if not IsBlackKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x+1,y-1)+'r');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x+1,y-1] := BlackKnight;
          if not IsBlackKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x+1,y-1)+'n');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x+1,y-1] := BlackBiShop;
          if not IsBlackKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x+1,y-1)+'b');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x+1,y-1] := BlackQueen;
          if not IsBlackKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x+1,y-1)+'q');
          LocalBoard := Board;
        end;
      end;
    end;

    if x>0 then
    begin
      if Board.Board[x-1,y-1]<>0 then
      begin
        if IsWhitePiece(Board.Board[x-1,y-1]) then
        begin
          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x-1,y-1] := BlackRook;
          if not IsBlackKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x-1,y-1)+'r');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x-1,y-1] := BlackKnight;
          if not IsBlackKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x-1,y-1)+'n');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x-1,y-1] := BlackBiShop;
          if not IsBlackKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x-1,y-1)+'b');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x-1,y-1] := BlackPawn;
          if not IsBlackKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x-1,y-1)+'q');
          LocalBoard := Board;
        end;
      end;
    end;
  end;
end;

procedure TLegalMoves.AddBlackQueenMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  i: Integer;
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  // right side
  if x<7 then
    for i := x+1 to 7 do
    begin
      if not IsBlackPiece(Board.Board[i,y]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[i,y] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,i,y));
        LocalBoard := Board;
        if IsWhitePiece(Board.Board[i,y]) then
          break;
      end
      else
        break;
    end;

  // left side
  if x>0 then
    for i := x-1 downto 0 do
    begin
      if not IsBlackPiece(Board.Board[i,y]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[i,y] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,i,y));
        LocalBoard := Board;
        if IsWhitePiece(Board.Board[i,y]) then
          break;
      end
      else
        break;
    end;
  // up side
  if y<7 then
    for i := y+1 to 7 do
    begin
      if not IsBlackPiece(Board.Board[x,i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x,i] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x,i));
        LocalBoard := Board;
        if IsWhitePiece(Board.Board[x,i]) then
          break;
      end
      else
        break;
    end;
  // down side
  if y>0 then
    for i := y-1 downto 0 do
    begin
      if not IsBlackPiece(Board.Board[x,i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x,i] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x,i));
        LocalBoard := Board;
        if IsWhitePiece(Board.Board[x,i]) then
          break;
      end
      else
        break;
    end;


  //////////////////////////////////////////////////
  if (x<7) and (y<7) then
  begin
    i := 1;
    while ((x+i)<=7) and ((Y+i)<=7) do
    begin
      if Board.Board[x+i,y+i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y+i] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y+i));
        LocalBoard := Board;
      end
      else
      if IsBlackPiece(Board.Board[x+i,y+i]) then
        break;
      if IsWhitePiece(Board.Board[x+i,y+i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y+i] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y+i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // down right
  if (x<7) and (y>0) then
  begin
    i := 1;
    while ((x+i)<=7) and ((y-i)>=0) do
    begin
      if Board.Board[x+i,y-i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y-i] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y-i));
        LocalBoard := Board;
      end;
      if IsBlackPiece(Board.Board[x+i,y-i]) then
        break;
      if IsWhitePiece(Board.Board[x+i,y-i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y-i] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y-i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // up left
  if (x>0) and (y<7) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y+i)<=7) do
    begin
      if Board.Board[x-i,y+i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y+i] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y+i));
        LocalBoard := Board;
      end;
      if IsBlackPiece(Board.Board[x-i,y+i]) then
        break;
      if IsWhitePiece(Board.Board[x-i,y+i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y+i] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y+i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // down left
  if (x>0) and (y>0) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y-i)>=0) do
    begin
      if Board.Board[x-i,y-i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y-i] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y-i));
        LocalBoard := Board;
      end;
      if IsBlackPiece(Board.Board[x-i,y-i]) then
        break;
      if IsWhitePiece(Board.Board[x-i,y-i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y-i] := BlackQueen;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y-i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
end;

procedure TLegalMoves.AddBlackRookMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  i: Integer;
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  // right side
  if x<7 then
    for i := x+1 to 7 do
    begin
      if not IsBlackPiece(Board.Board[i,y]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[i,y] := BlackRook;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,i,y));
        LocalBoard := Board;
        if IsWhitePiece(Board.Board[i,y]) then
          break;
      end
      else
        break;
    end;

  // left side
  if x>0 then
    for i := x-1 downto 0 do
    begin
      if not IsBlackPiece(Board.Board[i,y]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[i,y] := BlackRook;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,i,y));
        LocalBoard := Board;
        if IsWhitePiece(Board.Board[i,y]) then
          break;
      end
      else
        break;
    end;
  // up side
  if y<7 then
    for i := y+1 to 7 do
    begin
      if not IsBlackPiece(Board.Board[x,i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x,i] := BlackRook;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x,i));
        LocalBoard := Board;
        if IsWhitePiece(Board.Board[x,i]) then
          break;
      end
      else
        break;
    end;
  // down side
  if y>0 then
    for i := y-1 downto 0 do
    begin
      if not IsBlackPiece(Board.Board[x,i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x,i] := BlackRook;
        if not IsBlackKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x,i));
        LocalBoard := Board;
        if IsWhitePiece(Board.Board[x,i]) then
          break;
      end
      else
        break;
    end;
end;

procedure TLegalMoves.AddWhiteBishopMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  i: Integer;
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  // up right
  if (x<7) and (y<7) then
  begin
    i := 1;
    while ((x+i)<=7) and ((Y+i)<=7) do
    begin
      if Board.Board[x+i,y+i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y+i] := WhiteBiShop;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y+i));
        LocalBoard := Board;
      end
      else
      if IsWhitePiece(Board.Board[x+i,y+i]) then
        break;
      if IsBlackPiece(Board.Board[x+i,y+i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y+i] := WhiteBiShop;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y+i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // down right
  if (x<7) and (y>0) then
  begin
    i := 1;
    while ((x+i)<=7) and ((y-i)>=0) do
    begin
      if Board.Board[x+i,y-i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y-i] := WhiteBiShop;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y-i));
        LocalBoard := Board;
      end;
      if IsWhitePiece(Board.Board[x+i,y-i]) then
        break;
      if IsBlackPiece(Board.Board[x+i,y-i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y-i] := WhiteBiShop;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y-i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // up left
  if (x>0) and (y<7) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y+i)<=7) do
    begin
      if Board.Board[x-i,y+i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y+i] := WhiteBiShop;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y+i));
        LocalBoard := Board;
      end;
      if IsWhitePiece(Board.Board[x-i,y+i]) then
        break;
      if IsBlackPiece(Board.Board[x-i,y+i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y+i] := WhiteBiShop;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y+i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // down left
  if (x>0) and (y>0) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y-i)>=0) do
    begin
      if Board.Board[x-i,y-i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y-i] := WhiteBiShop;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y-i));
        LocalBoard := Board;
      end;
      if IsWhitePiece(Board.Board[x-i,y-i]) then
        break;
      if IsBlackPiece(Board.Board[x-i,y-i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y-i] := WhiteBiShop;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y-i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
end;

procedure TLegalMoves.AddWhiteKingMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  if x<7 then
  begin
    // in this case we normaly have x+1,y
    if not IsWhitePiece(Board.Board[x+1,y]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x+1,y] := WhiteKing;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x+1,y));
      LocalBoard := Board;
    end;
    if y<7 then
    begin
      if not IsWhitePiece(Board.Board[x+1,y+1]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+1,y+1] := WhiteKing;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+1,y+1));
        LocalBoard := Board;
      end;
    end;
    if y>0 then
    begin
      if not IsWhitePiece(Board.Board[x+1,y-1]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+1,y-1] := WhiteKing;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+1,y-1));
        LocalBoard := Board;
      end;
    end;
  end;

  if x>0 then
  begin
    // in this case we normaly have x-1,y
    if not IsWhitePiece(Board.Board[x-1,y]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x-1,y] := WhiteKing;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x-1,y));
      LocalBoard := Board;
    end;
    if y<7 then
    begin
      if not IsWhitePiece(Board.Board[x-1,y+1]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-1,y+1] := WhiteKing;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-1,y+1));
        LocalBoard := Board;
      end;
    end;
    if y>0 then
    begin
      if not IsWhitePiece(Board.Board[x-1,y-1]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-1,y-1] := WhiteKing;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-1,y-1));
        LocalBoard := Board;
      end;
    end;
  end;

  if y<7 then
    if not IsWhitePiece(Board.Board[x,y+1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y+1] := WhiteKing;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y+1));
      LocalBoard := Board;
    end;

  if y>0 then
    if not IsWhitePiece(Board.Board[x,y-1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y-1] := WhiteKing;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y-1));
      LocalBoard := Board;
    end;

  if (x=4) and (y=0) then // is king placed in initial location??
  begin
    // check for king side castle
    if IsWhiteRook(Board.Board[7,0]) and
      (Board.Board[6,0]=0) and
      (Board.Board[5,0]=0) and
      Board.WhiteCanCastleKingSide and
      (not IsSquareUnderBlackAttack(6,0,Board)) and
      (not IsSquareUnderBlackAttack(5,0,Board)) and
      (not IsWhiteKingInCheck(Board)) then
      MoveList.Add('E1G1');
    if IsWhiteRook(Board.Board[0,0]) and
      (Board.Board[1,0]=0) and
      (Board.Board[2,0]=0) and
      (Board.Board[3,0]=0) and
      Board.WhiteCanCastleQueenSide and
      (not IsSquareUnderBlackAttack(2,0,Board)) and
      (not IsSquareUnderBlackAttack(3,0,Board)) and
      (not IsWhiteKingInCheck(Board)) then
      MoveList.Add('E1C1');
  end;


end;

procedure TLegalMoves.AddWhiteKnightMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  if (x-1>=0) and (y-2>=0) then
    if not IsWhitePiece(Board.Board[x-1,y-2]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x-1,y-2] := WhiteKnight;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x-1,y-2));
      LocalBoard := Board;
    end;

  if (x-1>=0) and (y+2<=7) then
    if not IsWhitePiece(Board.Board[x-1,y+2]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x-1,y+2] := WhiteKnight;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x-1,y+2));
      LocalBoard := Board;
    end;

  if (x-2>=0) and (y-1>=0) then
    if not IsWhitePiece(Board.Board[x-2,y-1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x-2,y-1] := WhiteKnight;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x-2,y-1));
      LocalBoard := Board;
    end;

  if (x-2>=0) and (y+1<=7) then
    if not IsWhitePiece(Board.Board[x-2,y+1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x-2,y+1] := WhiteKnight;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x-2,y+1));
      LocalBoard := Board;
    end;

  if (x+1<=7) and (y-2>=0) then
    if not IsWhitePiece(Board.Board[x+1,y-2]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x+1,y-2] := WhiteKnight;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x+1,y-2));
      LocalBoard := Board;
    end;

  if (x+1<=7) and (y+2<=7) then
    if not IsWhitePiece(Board.Board[x+1,y+2]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x+1,y+2] := WhiteKnight;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x+1,y+2));
      LocalBoard := Board;
    end;

  if (x+2<=7) and (y-1>=0) then
    if not IsWhitePiece(Board.Board[x+2,y-1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x+2,y-1] := WhiteKnight;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x+2,y-1));
      LocalBoard := Board;
    end;

  if (x+2<=7) and (y+1<=7) then
    if not IsWhitePiece(Board.Board[x+2,y+1]) then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x+2,y+1] := WhiteKnight;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x+2,y+1));
      LocalBoard := Board;
    end;
end;

procedure TLegalMoves.AddWhitePawnMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  if y<6 then  // NotInPromotion state
  begin
    if y=4 then // enpasant possiblity
    begin
      if (x<7) and (Board.EnpasantPosX = x+1) then // enpasant to right side
      begin
        LocalBoard.Board[x+1,y] := 0;
        LocalBoard.Board[x+1,y+1] := WhitePawn;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+1,y+1));
        LocalBoard := Board;
      end;
      if (x>0) and (Board.EnpasantPosX = x-1) then // enpasant to left side
      begin
        LocalBoard.Board[x-1,y] := 0;
        LocalBoard.Board[x-1,y+1] := WhitePawn;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-1,y+1));
        LocalBoard := Board;
      end;
    end;

    if Board.Board[x,y+1]=0 then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y+1] := WhitePawn;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y+1));
      LocalBoard := Board;
    end;

    if y=1 then // First Pawn move. we can move 2 square here
      if (Board.Board[x,y+1]=0) and (Board.Board[x,y+2]=0) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x,y+2] := WhitePawn;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x,y+2));
        LocalBoard := Board;
      end;

    if x<7 then
    begin
      if Board.Board[x+1,y+1]<>0 then
      begin
        if IsBlackPiece(Board.Board[x+1,y+1]) then
        begin
          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x+1,y+1] := WhitePawn;
          if not IsWhiteKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x+1,y+1));
          LocalBoard := Board;
        end;
      end;
    end;

    if x>0 then
    begin
      if Board.Board[x-1,y+1]<>0 then
      begin
        if IsBlackPiece(Board.Board[x-1,y+1]) then
        begin
          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x-1,y+1] := WhitePawn;
          if not IsWhiteKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x-1,y+1));
          LocalBoard := Board;
        end;
      end;
    end;
  end
  else
  begin
    if Board.Board[x,y+1]=0 then
    begin
      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y+1] := WhiteRook;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y+1)+'r');
      LocalBoard := Board;

      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y+1] := WhiteKnight;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y+1)+'n');
      LocalBoard := Board;

      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y+1] := WhiteBiShop;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y+1)+'b');
      LocalBoard := Board;

      LocalBoard.Board[x,y] := 0;
      LocalBoard.Board[x,y+1] := WhiteQueen;
      if not IsWhiteKingInCheck(LocalBoard) then
        MoveList.Add(GetMoveStr(x,y,x,y+1)+'q');
      LocalBoard := Board;
    end;

    if x<7 then
    begin
      if Board.Board[x+1,y+1]<>0 then
      begin
        if IsBlackPiece(Board.Board[x+1,y+1]) then
        begin
          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x+1,y+1] := WhiteRook;
          if not IsWhiteKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x+1,y+1)+'r');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x+1,y+1] := WhiteKnight;
          if not IsWhiteKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x+1,y+1)+'n');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x+1,y+1] := WhiteBiShop;
          if not IsWhiteKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x+1,y+1)+'b');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x+1,y+1] := WhiteQueen;
          if not IsWhiteKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x+1,y+1)+'q');
          LocalBoard := Board;
        end;
      end;
    end;

    if x>0 then
    begin
      if Board.Board[x-1,y+1]<>0 then
      begin
        if IsBlackPiece(Board.Board[x-1,y+1]) then
        begin
          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x-1,y+1] := WhiteRook;
          if not IsWhiteKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x-1,y+1)+'r');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x-1,y+1] := WhiteKnight;
          if not IsWhiteKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x-1,y+1)+'n');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x-1,y+1] := WhiteBiShop;
          if not IsWhiteKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x-1,y+1)+'b');
          LocalBoard := Board;

          LocalBoard.Board[x,y] := 0;
          LocalBoard.Board[x-1,y+1] := WhitePawn;
          if not IsWhiteKingInCheck(LocalBoard) then
            MoveList.Add(GetMoveStr(x,y,x-1,y+1)+'q');
          LocalBoard := Board;
        end;
      end;
    end;
  end;
end;

procedure TLegalMoves.AddWhiteQueenMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  i: Integer;
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  // right side
  if x<7 then
    for i := x+1 to 7 do
    begin
      if not IsWhitePiece(Board.Board[i,y]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[i,y] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,i,y));
        LocalBoard := Board;
        if IsBlackPiece(Board.Board[i,y]) then
          break;
      end
      else
        break;
    end;

  // left side
  if x>0 then
    for i := x-1 downto 0 do
    begin
      if not IsWhitePiece(Board.Board[i,y]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[i,y] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,i,y));
        LocalBoard := Board;
        if IsBlackPiece(Board.Board[i,y]) then
          break;
      end
      else
        break;
    end;
  // up side
  if y<7 then
    for i := y+1 to 7 do
    begin
      if not IsWhitePiece(Board.Board[x,i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x,i] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x,i));
        LocalBoard := Board;
        if IsBlackPiece(Board.Board[x,i]) then
          break;
      end
      else
        break;
    end;
  // down side
  if y>0 then
    for i := y-1 downto 0 do
    begin
      if not IsWhitePiece(Board.Board[x,i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x,i] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x,i));
        LocalBoard := Board;
        if IsBlackPiece(Board.Board[x,i]) then
          break;
      end
      else
        break;
    end;
  // up right
  if (x<7) and (y<7) then
  begin
    i := 1;
    while ((x+i)<=7) and ((Y+i)<=7) do
    begin
      if Board.Board[x+i,y+i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y+i] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y+i));
        LocalBoard := Board;
      end
      else
      if IsWhitePiece(Board.Board[x+i,y+i]) then
        break;
      if IsBlackPiece(Board.Board[x+i,y+i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y+i] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y+i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // down right
  if (x<7) and (y>0) then
  begin
    i := 1;
    while ((x+i)<=7) and ((y-i)>=0) do
    begin
      if Board.Board[x+i,y-i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y-i] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y-i));
        LocalBoard := Board;
      end;
      if IsWhitePiece(Board.Board[x+i,y-i]) then
        break;
      if IsBlackPiece(Board.Board[x+i,y-i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x+i,y-i] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x+i,y-i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // up left
  if (x>0) and (y<7) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y+i)<=7) do
    begin
      if Board.Board[x-i,y+i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y+i] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y+i));
        LocalBoard := Board;
      end;
      if IsWhitePiece(Board.Board[x-i,y+i]) then
        break;
      if IsBlackPiece(Board.Board[x-i,y+i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y+i] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y+i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
  // down left
  if (x>0) and (y>0) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y-i)>=0) do
    begin
      if Board.Board[x-i,y-i]=0 then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y-i] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y-i));
        LocalBoard := Board;
      end;
      if IsWhitePiece(Board.Board[x-i,y-i]) then
        break;
      if IsBlackPiece(Board.Board[x-i,y-i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x-i,y-i] := WhiteQueen;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x-i,y-i));
        LocalBoard := Board;
        break;
      end;
      Inc(i);
    end;
  end;
end;

procedure TLegalMoves.AddWhiteRookMoveList(Board: TChessBoardState; x, y: Byte;
  MoveList: TStringList);
var
  i: Integer;
  LocalBoard: TChessBoardState;
begin
  LocalBoard := Board;
  // right side
  if x<7 then
    for i := x+1 to 7 do
    begin
      if not IsWhitePiece(Board.Board[i,y]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[i,y] := WhiteRook;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,i,y));
        LocalBoard := Board;
        if IsBlackPiece(Board.Board[i,y]) then
          break;
      end
      else
        break;
    end;

  // left side
  if x>0 then
    for i := x-1 downto 0 do
    begin
      if not IsWhitePiece(Board.Board[i,y]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[i,y] := WhiteRook;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,i,y));
        LocalBoard := Board;
        if IsBlackPiece(Board.Board[i,y]) then
          break;
      end
      else
        break;
    end;
  // up side
  if y<7 then
    for i := y+1 to 7 do
    begin
      if not IsWhitePiece(Board.Board[x,i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x,i] := WhiteRook;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x,i));
        LocalBoard := Board;
        if IsBlackPiece(Board.Board[x,i]) then
          break;
      end
      else
        break;
    end;
  // down side
  if y>0 then
    for i := y-1 downto 0 do
    begin
      if not IsWhitePiece(Board.Board[x,i]) then
      begin
        LocalBoard.Board[x,y] := 0;
        LocalBoard.Board[x,i] := WhiteRook;
        if not IsWhiteKingInCheck(LocalBoard) then
          MoveList.Add(GetMoveStr(x,y,x,i));
        LocalBoard := Board;
        if IsBlackPiece(Board.Board[x,i]) then
          break;
      end
      else
        break;
    end;
end;

constructor TLegalMoves.Create;
begin

end;

destructor TLegalMoves.Destroy;
begin
  inherited;
end;

function TLegalMoves.DoMove(MoveStr: AnsiString;
  Board: TChessBoardState): TChessBoardState;
var
  i,x1,x2,y1,y2: Integer;
  LegalMovesList: TStringList;
  PromotionPiece: AnsiChar;
  IsLegal: Boolean;
begin
  // first of all we have to check that its a legal move
  LegalMovesList := TStringList.Create;
  if Board.IsWhiteToMove then
    GetWhiteMoveList(Board,LegalMovesList)
  else
    GetBlackMoveList(Board,LegalMovesList);
  // checking to see if we have to set enpasant variable
  IsLegal := False;
  if Length(MoveStr)<4 then
  begin
    LegalMovesList.Free;
    Exit;
  end;
  for i := 0 to LegalMovesList.Count - 1 do
    if AsciiLowerMove(Copy(MoveStr, 1, 4)) = AsciiLowerMove(Copy(AnsiString(LegalMovesList.Strings[i]), 1, 4)) then
    begin
      IsLegal := True;
      break;
    end;
  if not IsLegal then
  begin
    LegalMovesList.Free;
    Exit;
  end;
  LegalMovesList.Free;

  // ok here we have some considerations, of course its more than simply moving the piece
  // promotions,
  // setting castling rights after moving rook or king,
  // setting enpasant pos,
  // enpasant move captures
  // setting the fiftymove variable
  Result := Board;
  x1 := Byte(UpCase(MoveStr[1])) - 65;
  x2 := Byte(UpCase(MoveStr[3])) - 65;
  y1 := Byte(MoveStr[2]) - 49;
  y2 := Byte(MoveStr[4]) - 49;

  // Cheking enpasant moves, This is headache because we need to capture oponent piece
  // from the board square which we are not moving into that.
  if IsBlackPawn(Result.Board[x1,y1]) and (y1=3) and ((x2=x1+1) or (x2=x1-1)) then
  begin
    //check to see if its enpasant move or simple capture move
    if Result.Board[x2,y2]=0 then
    begin
      // This is enpasant
      // for now just do the enpasant capture
      // The move itself will be done later
      if Assigned(OnCapture) then
        OnCapture(Self,SquareStr(x1,y1),SquareStr(x2,y2),PieceToAnsiChar(Result.Board[x2,y2]));
      Result.Board[Result.EnpasantPosX,Result.EnpasantPosY] := 0;

    end;
  end;
  //Same checking for white
  if IsWhitePawn(Result.Board[x1,y1]) and (y1=4) and ((x2=x1+1) or (x2=x1-1)) then
  begin
    if Result.Board[x2,y2]=0 then
    begin
      if Assigned(OnCapture) then
        OnCapture(Self,SquareStr(x1,y1),SquareStr(x2,y2),PieceToAnsiChar(Result.Board[x2,y2]));
      Result.Board[Result.EnpasantPosX,Result.EnpasantPosY] := 0;
    end;
  end;
  Result.EnpasantPosX := -1;
  Result.EnpasantPosY := -1;

  //check that if we have to remove catstling right from queen side for black
  if Result.BlackCanCastleQueenSide and IsBlackRook(Result.Board[x1,y1]) and (x1=0) and (y1=7) then
  begin
    Result.BlackCanCastleQueenSide := False;
  end;
  //check that if we have to remove catstling right from king side for black
  if Result.BlackCanCastleKingSide and IsBlackRook(Result.Board[x1,y1]) and (x1=7) and (y1=7) then
  begin
    Result.BlackCanCastleKingSide := False;
  end;
  //check that if we have to remove catstling right from Queen side for white
  if Result.WhiteCanCastleQueenSide and IsWhiteRook(Result.Board[x1,y1]) and (x1=0) and (y1=0) then
  begin
    Result.WhiteCanCastleQueenSide := False;
  end;
  //check that if we have to remove catstling right from king side for white
  if Result.WhiteCanCastleQueenSide and IsWhiteRook(Result.Board[x1,y1]) and (x1=0) and (y1=0) then
  begin
    Result.WhiteCanCastleQueenSide := False;
  end;

  //////////// White Castle king side //////////////////
  if (AsciiLowerMove(MoveStr)='e1g1') and
     (Result.Board[4,0]=WhiteKing) and
     Result.WhiteCanCastleKingSide and
     (Result.Board[7,0]=WhiteRook) and
     (Result.Board[5,0]=0) and
     (Result.Board[6,0]=0) then
  begin
    Result.Board[6,0] := WhiteKing;
    Result.Board[5,0] := WhiteRook;
    Result.Board[4,0] := 0;
    Result.Board[7,0] := 0;
    Inc(Result.FiftyMoveVariable);
    Result.WhiteCanCastleKingSide := False;
    Result.WhiteCanCastleQueenSide := False;
    Result.IsWhiteToMove := False;
    if Assigned(OnWhiteCastle) then
      OnWhiteCastle(Self,string(MoveText(x1,y1,x2,y2)));
    if Assigned(OnLegalMove) then
      OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
    Exit;
  end;

  //////////// White Castle Queen side //////////////////
  if (AsciiLowerMove(MoveStr)='e1c1') and
     (Result.Board[4,0]=WhiteKing) and
     Result.WhiteCanCastleQueenSide and
     (Result.Board[0,0]=WhiteRook) and
     (Result.Board[1,0]=0) and
     (Result.Board[2,0]=0) and
     (Result.Board[3,0]=0) then
  begin
    Result.Board[2,0] := WhiteKing;
    Result.Board[3,0] := WhiteRook;
    Result.Board[0,0] := 0;
    Result.Board[1,0] := 0;
    Result.Board[4,0] := 0;
    Inc(Result.FiftyMoveVariable);
    Result.WhiteCanCastleQueenSide := False;
    Result.WhiteCanCastleKingSide := False;
    Result.IsWhiteToMove := False;
    if Assigned(OnWhiteCastle) then
      OnWhiteCastle(Self,string(MoveText(x1,y1,x2,y2)));
    if Assigned(OnLegalMove) then
      OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
    Exit;
  end;

  if (AsciiLowerMove(MoveStr)='e8g8') and
     (Result.Board[4,7]=BlackKing) and
     Result.BlackCanCastleKingSide and
     (Result.Board[7,7]=BlackRook) and
     (Result.Board[5,7]=0) and
     (Result.Board[6,7]=0) then
  begin
    Result.Board[6,7] := BlackKing;
    Result.Board[5,7] := BlackRook;
    Result.Board[4,7] := 0;
    Result.Board[7,7] := 0;
    Result.BlackCanCastleKingSide := False;
    Result.BlackCanCastleQueenSide := False;
    Result.IsWhiteToMove := True;
    Inc(Result.FiftyMoveVariable);
    if Assigned(OnBlackCastle) then
      OnBlackCastle(Self,string(MoveText(x1,y1,x2,y2)));
    if Assigned(OnLegalMove) then
      OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
    Exit;
  end;

  if (AsciiLowerMove(MoveStr)='e8c8') and
     (Result.Board[4,7]=BlackKing) and
     Result.BlackCanCastleQueenSide and
     (Result.Board[0,7]=BlackRook) and
     (Result.Board[1,7]=0) and
     (Result.Board[2,7]=0) and
     (Result.Board[3,7]=0) then
  begin
    Result.Board[2,7] := BlackKing;
    Result.Board[3,7] := BlackRook;
    Result.Board[0,7] := 0;
    Result.Board[1,7] := 0;
    Result.Board[4,7] := 0;
    Inc(Result.FiftyMoveVariable);
    Result.BlackCanCastleQueenSide := False;
    Result.BlackCanCastleKingSide := False;
    Result.IsWhiteToMove := True;
    if Assigned(OnBlackCastle) then
      OnBlackCastle(Self,string(MoveText(x1,y1,x2,y2)));
    if Assigned(OnLegalMove) then
      OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
    Exit;
  end;
  begin
    if IsBlackPiece(Result.Board[x1,y1]) then
    begin
      if IsBlackPawn(Result.Board[x1,y1]) and (y1=6) and (y2=4) then
      begin
        Result.Board[x1,y1] := 0;
        Result.Board[x2,y2] := BlackPawn;
        Result.EnpasantPosX := x2;
        Result.EnpasantPosY := y2;
        // ok its pawn move so we have to reset fifty move variable
        Result.FiftyMoveVariable := 0;
        Result.IsWhiteToMove := True;
        if Assigned(OnLegalMove) then
          OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
        Exit;
      end;
    end
    else
    begin
      if IsWhitePawn(Result.Board[x1,y1]) and (y1=1) and (y2=3) then
      begin
        Result.Board[x1,y1] := 0;
        Result.Board[x2,y2] := WhitePawn;
        Result.EnpasantPosX := x2;
        Result.EnpasantPosY := y2;
        // ok its pawn move so we have to reset fifty move variable
        Result.FiftyMoveVariable := 0;
        Result.IsWhiteToMove := False;
        if Assigned(OnLegalMove) then
          OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
        Exit;
      end;
    end;
  end;

  // Ok we are done with setting enpasant pos and castling stuffs
  // remaining things are "side to move" and "fiftymove variable"
  // and promotions
  if IsBlackPiece(Result.Board[x1,y1]) then
  begin
    if IsBlackPawn(Result.Board[x1,y1]) then
      Result.FiftyMoveVariable := 0;
    Result.IsWhiteToMove := True;
  end;

  if IsWhitePiece(Result.Board[x1,y1]) then
  begin
    if IsWhitePawn(Result.Board[x1,y1]) then
      Result.FiftyMoveVariable := 0;
    Result.IsWhiteToMove := False;
  end;

  if (Result.Board[x2,y2]<>0) and (Assigned(FOnCapture)) then
    OnCapture(Self,SquareStr(x1,y1),SquareStr(x2,y2),PieceToAnsiChar(Result.Board[x2,y2]));

  Result.Board[x2,y2] := Result.Board[x1,y1];
  Result.Board[x1,y1] := 0;

  // promotions
  if (Length(MoveStr)=5) or
     (IsBlackPawn(Board.Board[x1,y1]) and (y1=1)) or
     (IsWhitePawn(Board.Board[x1,y1]) and (y1=6)) then
  begin
    PromotionPiece := 'q';
    if Length(MoveStr)=5 then
      PromotionPiece := AsciiLowerChar(MoveStr[5]);
    if Assigned(OnPromotion) then
      OnPromotion(Self,SquareStr(x1,y1),SquareStr(x2,y2),PromotionPiece);
    PromotionPiece := AnsiChar(Byte(PromotionPiece) or 32);
    case PromotionPiece of
    'q' : if IsWhitePiece(Result.Board[x2,y2]) then Result.Board[x2,y2] := WhiteQueen else Result.Board[x2,y2] := BlackQueen;
    'n' : if IsWhitePiece(Result.Board[x2,y2]) then Result.Board[x2,y2] := WhiteKnight else Result.Board[x2,y2] := BlackKnight;
    'b' : if IsWhitePiece(Result.Board[x2,y2]) then Result.Board[x2,y2] := WhiteBiShop else Result.Board[x2,y2] := BlackBiShop;
    'r' : if IsWhitePiece(Result.Board[x2,y2]) then Result.Board[x2,y2] := WhiteRook else Result.Board[x2,y2] := BlackRook;
    end;
    if Assigned(OnLegalMove) then
      OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)+PromotionPiece));
  end
  else
  if Assigned(OnLegalMove) then
    OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));

end;

function TLegalMoves.DoMove1(MoveStr: AnsiString;
  Board: TChessBoardState): TChessBoardState;
var
  x1,x2,y1,y2: Integer;
  PromotionPiece: AnsiChar;
begin
  // first of all we have to check that its a legal move
  // checking to see if we have to set enpasant variable
  if Length(MoveStr)<4  then
    Exit;

  // ok here we have some considerations, of course its more than simply moving the piece
  // promotions,
  // setting castling rights after moving rook or king,
  // setting enpasant pos,
  // enpasant move captures
  // setting the fiftymove variable
  Result := Board;
  x1 := Byte(UpCase(MoveStr[1])) - 65;
  x2 := Byte(UpCase(MoveStr[3])) - 65;
  y1 := Byte(MoveStr[2]) - 49;
  y2 := Byte(MoveStr[4]) - 49;

  // Cheking enpasant moves, This is headache because we need to capture oponent piece
  // from the board square which we are not moving into that.
  if IsBlackPawn(Result.Board[x1,y1]) and (y1=3) and ((x2=x1+1) or (x2=x1-1)) then
  begin
    //check to see if its enpasant move or simple capture move
    if Result.Board[x2,y2]=0 then
    begin
      // This is enpasant
      // for now just do the enpasant capture
      // The move itself will be done later
      if Assigned(OnCapture) then
        OnCapture(Self,SquareStr(x1,y1),SquareStr(x2,y2),PieceToAnsiChar(Result.Board[x2,y2]));
      Result.Board[Result.EnpasantPosX,Result.EnpasantPosY] := 0;

    end;
  end;
  //Same checking for white
  if IsWhitePawn(Result.Board[x1,y1]) and (y1=4) and ((x2=x1+1) or (x2=x1-1)) then
  begin
    if Result.Board[x2,y2]=0 then
    begin
      if Assigned(OnCapture) then
        OnCapture(Self,SquareStr(x1,y1),SquareStr(x2,y2),PieceToAnsiChar(Result.Board[x2,y2]));
      Result.Board[Result.EnpasantPosX,Result.EnpasantPosY] := 0;
    end;
  end;
  Result.EnpasantPosX := -1;
  Result.EnpasantPosY := -1;

  //check that if we have to remove catstling right from queen side for black
  if Result.BlackCanCastleQueenSide and IsBlackRook(Result.Board[x1,y1]) and (x1=0) and (y1=7) then
  begin
    Result.BlackCanCastleQueenSide := False;
  end;
  //check that if we have to remove catstling right from king side for black
  if Result.BlackCanCastleKingSide and IsBlackRook(Result.Board[x1,y1]) and (x1=7) and (y1=7) then
  begin
    Result.BlackCanCastleKingSide := False;
  end;
  //check that if we have to remove catstling right from Queen side for white
  if Result.WhiteCanCastleQueenSide and IsWhiteRook(Result.Board[x1,y1]) and (x1=0) and (y1=0) then
  begin
    Result.WhiteCanCastleQueenSide := False;
  end;
  //check that if we have to remove catstling right from king side for white
  if Result.WhiteCanCastleQueenSide and IsWhiteRook(Result.Board[x1,y1]) and (x1=0) and (y1=0) then
  begin
    Result.WhiteCanCastleQueenSide := False;
  end;

  //////////// White Castle king side //////////////////
  if (AsciiLowerMove(MoveStr)='e1g1') and
     (Result.Board[4,0]=WhiteKing) and
     Result.WhiteCanCastleKingSide and
     (Result.Board[7,0]=WhiteRook) and
     (Result.Board[5,0]=0) and
     (Result.Board[6,0]=0) then
  begin
    Result.Board[6,0] := WhiteKing;
    Result.Board[5,0] := WhiteRook;
    Result.Board[4,0] := 0;
    Result.Board[7,0] := 0;
    Inc(Result.FiftyMoveVariable);
    Result.WhiteCanCastleKingSide := False;
    Result.WhiteCanCastleQueenSide := False;
    Result.IsWhiteToMove := False;
    if Assigned(OnWhiteCastle) then
      OnWhiteCastle(Self,string(MoveText(x1,y1,x2,y2)));
    if Assigned(OnLegalMove) then
      OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
    Exit;
  end;

  //////////// White Castle Queen side //////////////////
  if (AsciiLowerMove(MoveStr)='e1c1') and
     (Result.Board[4,0]=WhiteKing) and
     Result.WhiteCanCastleQueenSide and
     (Result.Board[0,0]=WhiteRook) and
     (Result.Board[1,0]=0) and
     (Result.Board[2,0]=0) and
     (Result.Board[3,0]=0) then
  begin
    Result.Board[2,0] := WhiteKing;
    Result.Board[3,0] := WhiteRook;
    Result.Board[0,0] := 0;
    Result.Board[1,0] := 0;
    Result.Board[4,0] := 0;
    Inc(Result.FiftyMoveVariable);
    Result.WhiteCanCastleQueenSide := False;
    Result.WhiteCanCastleKingSide := False;
    Result.IsWhiteToMove := False;
    if Assigned(OnWhiteCastle) then
      OnWhiteCastle(Self,string(MoveText(x1,y1,x2,y2)));
    if Assigned(OnLegalMove) then
      OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
    Exit;
  end;

  if (AsciiLowerMove(MoveStr)='e8g8') and
     (Result.Board[4,7]=BlackKing) and
     Result.BlackCanCastleKingSide and
     (Result.Board[7,7]=BlackRook) and
     (Result.Board[5,7]=0) and
     (Result.Board[6,7]=0) then
  begin
    Result.Board[6,7] := BlackKing;
    Result.Board[5,7] := BlackRook;
    Result.Board[4,7] := 0;
    Result.Board[7,7] := 0;
    Result.BlackCanCastleKingSide := False;
    Result.BlackCanCastleQueenSide := False;
    Result.IsWhiteToMove := True;
    Inc(Result.FiftyMoveVariable);
    if Assigned(OnBlackCastle) then
      OnBlackCastle(Self,string(MoveText(x1,y1,x2,y2)));
    if Assigned(OnLegalMove) then
      OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
    Exit;
  end;

  if (AsciiLowerMove(MoveStr)='e8c8') and
     (Result.Board[4,7]=BlackKing) and
     Result.BlackCanCastleQueenSide and
     (Result.Board[0,7]=BlackRook) and
     (Result.Board[1,7]=0) and
     (Result.Board[2,7]=0) and
     (Result.Board[3,7]=0) then
  begin
    Result.Board[2,7] := BlackKing;
    Result.Board[3,7] := BlackRook;
    Result.Board[0,7] := 0;
    Result.Board[1,7] := 0;
    Result.Board[4,7] := 0;
    Inc(Result.FiftyMoveVariable);
    Result.BlackCanCastleQueenSide := False;
    Result.BlackCanCastleKingSide := False;
    Result.IsWhiteToMove := True;
    if Assigned(OnBlackCastle) then
      OnBlackCastle(Self,string(MoveText(x1,y1,x2,y2)));
    if Assigned(OnLegalMove) then
      OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
    Exit;
  end;
  begin
    if IsBlackPiece(Result.Board[x1,y1]) then
    begin
      if IsBlackPawn(Result.Board[x1,y1]) and (y1=6) and (y2=4) then
      begin
        Result.Board[x1,y1] := 0;
        Result.Board[x2,y2] := BlackPawn;
        Result.EnpasantPosX := x2;
        Result.EnpasantPosY := y2;
        // ok its pawn move so we have to reset fifty move variable
        Result.FiftyMoveVariable := 0;
        Result.IsWhiteToMove := True;
        if Assigned(OnLegalMove) then
          OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
        Exit;
      end;
    end
    else
    begin
      if IsWhitePawn(Result.Board[x1,y1]) and (y1=1) and (y2=3) then
      begin
        Result.Board[x1,y1] := 0;
        Result.Board[x2,y2] := WhitePawn;
        Result.EnpasantPosX := x2;
        Result.EnpasantPosY := y2;
        // ok its pawn move so we have to reset fifty move variable
        Result.FiftyMoveVariable := 0;
        Result.IsWhiteToMove := False;
        if Assigned(OnLegalMove) then
          OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));
        Exit;
      end;
    end;
  end;

  // Ok we are done with setting enpasant pos and castling stuffs
  // remaining things are "side to move" and "fiftymove variable"
  // and promotions
  if IsBlackPiece(Result.Board[x1,y1]) then
  begin
    if IsBlackPawn(Result.Board[x1,y1]) then
      Result.FiftyMoveVariable := 0;
    Result.IsWhiteToMove := True;
  end;

  if IsWhitePiece(Result.Board[x1,y1]) then
  begin
    if IsWhitePawn(Result.Board[x1,y1]) then
      Result.FiftyMoveVariable := 0;
    Result.IsWhiteToMove := False;
  end;

  if (Result.Board[x2,y2]<>0) and (Assigned(FOnCapture)) then
    OnCapture(Self,SquareStr(x1,y1),SquareStr(x2,y2),PieceToAnsiChar(Result.Board[x2,y2]));

  Result.Board[x2,y2] := Result.Board[x1,y1];
  Result.Board[x1,y1] := 0;

  // promotions
  if (Length(MoveStr)=5) or
     (IsBlackPawn(Board.Board[x1,y1]) and (y1=1)) or
     (IsWhitePawn(Board.Board[x1,y1]) and (y1=6)) then
  begin
    PromotionPiece := 'q';
    if Length(MoveStr)=5 then
      PromotionPiece := AsciiLowerChar(MoveStr[5]);
    if Assigned(OnPromotion) then
      OnPromotion(Self,SquareStr(x1,y1),SquareStr(x2,y2),PromotionPiece);
    case PromotionPiece of
    'q' : if IsWhitePiece(Result.Board[x2,y2]) then Result.Board[x2,y2] := WhiteQueen else Result.Board[x2,y2] := BlackQueen;
    'n' : if IsWhitePiece(Result.Board[x2,y2]) then Result.Board[x2,y2] := WhiteKnight else Result.Board[x2,y2] := BlackKnight;
    'b' : if IsWhitePiece(Result.Board[x2,y2]) then Result.Board[x2,y2] := WhiteBiShop else Result.Board[x2,y2] := BlackBiShop;
    'r' : if IsWhitePiece(Result.Board[x2,y2]) then Result.Board[x2,y2] := WhiteRook else Result.Board[x2,y2] := BlackRook;
    end;
    if Assigned(OnLegalMove) then
      OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)+PromotionPiece));
  end
  else
  if Assigned(OnLegalMove) then
    OnLegalMove(Self,string(SquareStr(x1,y1)+SquareStr(x2,y2)));

end;

procedure TLegalMoves.GetMoveList(Board: TChessBoardState; MoveList: TStringList);
begin
  if Board.IsWhiteToMove then
    GetWhiteMoveList(Board,MoveList)
  else
    GetBlackMoveList(Board,MoveList);
end;

function TLegalMoves.GetMoveStr(x1, y1, x2, y2: Byte): string;
begin
  Result := Char(65+x1)+Char(49+y1)+Char(65+x2)+Char(49+y2);
end;

function TLegalMoves.GetBlackMoveList(Board: TChessBoardState; MoveList: TStringList): TStringList;
var
  i,j: Integer;
begin
  for j := 0 to 7 do
    for i := 0 to 7 do
    begin
      if Board.Board[i,j]<>0 then
      begin
        if IsBlackPiece(Board.Board[i,j]) then
        begin
          if IsBlackPawn(Board.Board[i,j]) then
            AddBlackPawnMoveList(Board,i,j,MoveList)
          else
          if IsBlackRook(Board.Board[i,j]) then
            AddBlackRookMoveList(Board,i,j,MoveList)
          else
          if IsBlackknight(Board.Board[i,j]) then
            AddBlackKnightMoveList(Board,i,j,MoveList)
          else
          if IsBlackBishop(Board.Board[i,j]) then
            AddBlackBishopMoveList(Board,i,j,MoveList)
          else
          if IsBlackQueen(Board.Board[i,j]) then
            AddBlackQueenMoveList(Board,i,j,MoveList)
          else
          if IsBlackking(Board.Board[i,j]) then
            AddBlackKingMoveList(Board,i,j,MoveList);
        end;
      end;
    end;
  Result := MoveList;
end;

function TLegalMoves.GetWhiteMoveList(Board: TChessBoardState; MoveList: TStringList): TStringList;
var
  i,j: Integer;
begin
  for j := 0 to 7 do
    for i := 0 to 7 do
    begin
      if Board.Board[i,j]<>0 then
      begin
        if IsWhitePiece(Board.Board[i,j]) then
        begin
          if IsWhitePawn(Board.Board[i,j]) then
            AddWhitePawnMoveList(Board,i,j,MoveList)
          else
          if IsWhiteRook(Board.Board[i,j]) then
            AddWhiteRookMoveList(Board,i,j,MoveList)
          else
          if IsWhiteknight(Board.Board[i,j]) then
            AddWhiteKnightMoveList(Board,i,j,MoveList)
          else
          if IsWhiteBishop(Board.Board[i,j]) then
            AddWhiteBishopMoveList(Board,i,j,MoveList)
          else
          if IsWhiteQueen(Board.Board[i,j]) then
            AddWhiteQueenMoveList(Board,i,j,MoveList)
          else
          if IsWhiteking(Board.Board[i,j]) then
            AddWhiteKingMoveList(Board,i,j,MoveList);
        end;
      end;
    end;
  Result := MoveList;
end;

function TLegalMoves.IsBlackBishop(Piece: Byte): Boolean;
begin
  Result := (Piece = BlackBiShop);
end;

function TLegalMoves.IsBlackking(Piece: Byte): Boolean;
begin
  Result := (Piece = BlackKing);
end;

function TLegalMoves.IsBlackKingInCheck(Board: TChessBoardState): Boolean;
var
  i,j: Integer;
begin
  Result := False;
  for i := 0 to 7 do
    for j := 0 to 7 do
      if IsBlackking(Board.Board[i,j]) then
        Result := IsSquareUnderWhiteAttack(i,j,Board);
end;

function TLegalMoves.IsWhiteKingInCheck(Board: TChessBoardState): Boolean;
var
  i,j: Integer;
begin
  Result := False;
  for i := 0 to 7 do
    for j := 0 to 7 do
      if IsWhiteking(Board.Board[i,j]) then
        Result := IsSquareUnderBlackAttack(i,j,Board);
end;

function TLegalMoves.IsBlackknight(Piece: Byte): Boolean;
begin
  Result := (Piece = BlackKnight);
end;

function TLegalMoves.IsBlackPawn(Piece: Byte): Boolean;
begin
  Result := (Piece = BlackPawn);
end;

function TLegalMoves.IsBlackPiece(Piece: Byte): Boolean;
begin
  if (Piece>0) and ((Piece and BlackPiece) = BlackPiece) then
    Result := True
  else
    Result := False;
end;

function TLegalMoves.IsBlackQueen(Piece: Byte): Boolean;
begin
  Result := (Piece = BlackQueen);
end;

function TLegalMoves.IsBlackRook(Piece: Byte): Boolean;
begin
  Result := (Piece = BlackRook);
end;

function TLegalMoves.IsWhiteBishop(Piece: Byte): Boolean;
begin
  Result := (Piece = WhiteBiShop);
end;

function TLegalMoves.IsWhiteking(Piece: Byte): Boolean;
begin
  Result := (Piece = WhiteKing);
end;

function TLegalMoves.IsWhiteknight(Piece: Byte): Boolean;
begin
  Result := (Piece = WhiteKnight);
end;

function TLegalMoves.IsWhitePawn(Piece: Byte): Boolean;
begin
  Result := (Piece = WhitePawn);
end;

function TLegalMoves.IsWhitePiece(Piece: Byte): Boolean;
begin
  if (Piece>0) and ((Piece and BlackPiece) = 0) then
    Result := True
  else
    Result := False;
end;

function TLegalMoves.IsWhiteQueen(Piece: Byte): Boolean;
begin
  Result := (Piece = WhiteQueen);
end;

function TLegalMoves.IsWhiteRook(Piece: Byte): Boolean;
begin
  Result := (Piece = WhiteRook);
end;

function TLegalMoves.PieceToAnsiChar(Piece: Byte): AnsiChar;
begin
  Result := #0;
  case Piece of
  BlackPawn: Result := 'p';
  BlackRook: Result := 'r';
  BlackKnight: Result := 'n';
  BlackBiShop: Result := 'b';
  BlackKing: Result := 'k';
  BlackQueen: Result := 'q';
  WhitePawn: Result := 'P';
  WhiteRook: Result := 'R';
  WhiteKnight: Result := 'N';
  WhiteBiShop: Result := 'B';
  WhiteKing: Result := 'K';
  WhiteQueen: Result := 'Q';
  end;
end;

function TLegalMoves.SquareStr(x, y: Integer): AnsiString;
begin
  Result := AnsiChar(65+x)+AnsiChar(49+y);
end;

function TLegalMoves.IsSquareUnderBlackAttack(x,y: Byte; Board: TChessBoardState): Boolean;
var
  i: Integer;
begin
  Result := False;
  // Is under attack by black pawns
  if y<6 then  // Black pawns starts from y=6
  begin
    if x<7 then
      if IsBlackPawn(Board.Board[x+1,y+1]) then
      begin
        Result := True;
        Exit;
      end;
    if x>0 then
      if IsBlackPawn(Board.Board[x-1,y+1]) then
      begin
        Result := True;
        Exit;
      end;
  end;

  // Is under attack by black Rooks also (Queens as Rooks)
  // checking for right side rook or Queen as Rook
  if x<7 then
    for i := x+1 to 7 do
    begin
      if Board.Board[i,y]<>0 then
      begin
        if IsWhitePiece(Board.Board[i,y]) then
          break;
        if IsBlackRook(Board.Board[i,y]) or IsBlackQueen(Board.Board[i,y]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
    end;

  // checking for left side rook or Queen as Rook
  if x>0 then
    for i := x-1 downto 0 do
    begin
      if Board.Board[i,y]<>0 then
      begin
        if IsWhitePiece(Board.Board[i,y]) then
          break;
        if IsBlackRook(Board.Board[i,y]) or IsBlackQueen(Board.Board[i,y]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
    end;
  // checking for up side rook or Queen as Rook
  if y<7 then
    for i := y+1 to 7 do
    begin
      if Board.Board[x,i]<>0 then
      begin
        if IsWhitePiece(Board.Board[x,i]) then
          break;
        if IsBlackRook(Board.Board[x,i]) or IsBlackQueen(Board.Board[x,i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
    end;
  // checking for down side rook or Queen as Rook
  if y>0 then
    for i := y-1 downto 0 do
    begin
      if Board.Board[x,i]<>0 then
      begin
        if IsWhitePiece(Board.Board[x,i]) then
          break;
        if IsBlackRook(Board.Board[x,i]) or IsBlackQueen(Board.Board[x,i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
    end;
  // End checking attack by black Rooks also (Queens as Rooks)

  // Is under attack by black Bishops also (Queens as Bishops)
  // up right
  if (x<7) and (y<7) then
  begin
    i := 1;
    while ((x+i)<=7) and ((Y+i)<=7) do
    begin
      if Board.Board[x+i,y+i]<>0 then
      begin
        if IsWhitePiece(Board.Board[x+i,y+i]) then
          break;
        if IsBlackBishop(Board.Board[x+i,y+i]) or IsBlackQueen(Board.Board[x+i,y+i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
      Inc(i);
    end;
  end;
  // down right
  if (x<7) and (y>0) then
  begin
    i := 1;
    while ((x+i)<=7) and ((y-i)>=0) do
    begin
      if Board.Board[x+i,y-i]<>0 then
      begin
        if IsWhitePiece(Board.Board[x+i,y-i]) then
          break;
        if IsBlackBishop(Board.Board[x+i,y-i]) or IsBlackQueen(Board.Board[x+i,y-i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
      Inc(i);
    end;
  end;
  // up left
  if (x>0) and (y<7) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y+i)<=7) do
    begin
      if Board.Board[x-i,y+i]<>0 then
      begin
        if IsWhitePiece(Board.Board[x-i,y+i]) then
          break;
        if IsBlackBishop(Board.Board[x-i,y+i]) or IsBlackQueen(Board.Board[x-i,y+i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
      Inc(i);
    end;
  end;
  // down left
  if (x>0) and (y>0) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y-i)>=0) do
    begin
      if Board.Board[x-i,y-i]<>0 then
      begin
        if IsWhitePiece(Board.Board[x-i,y-i]) then
          break;
        if IsBlackBishop(Board.Board[x-i,y-i]) or IsBlackQueen(Board.Board[x-i,y-i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
      Inc(i);
    end;
  end;
  // End checking attacks by black Bishops also (Queens as Bishops)

  // Is under attack by black knights
  if (x-1>=0) and (y-2>=0) then
    if Board.Board[x-1,y-2]= BlackKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x-1>=0) and (y+2<=7) then
    if Board.Board[x-1,y+2]= BlackKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x-2>=0) and (y-1>=0) then
    if Board.Board[x-2,y-1]= BlackKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x-2>=0) and (y+1<=7) then
    if Board.Board[x-2,y+1]= BlackKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x+1<=7) and (y-2>=0) then
    if Board.Board[x+1,y-2]= BlackKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x+1<=7) and (y+2<=7) then
    if Board.Board[x+1,y+2]= BlackKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x+2<=7) and (y-1>=0) then
    if Board.Board[x+2,y-1]= BlackKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x+2<=7) and (y+1<=7) then
    if Board.Board[x+2,y+1]= BlackKnight then
    begin
      Result := True;
      Exit;
    end;
  // End checking attacks by black knights

  // Is under attack by black king
  if x<7 then
    if Board.Board[x+1,y]=BlackKing then
    begin
      Result := True;
      Exit;
    end;
  if y<7 then
    if Board.Board[x,y+1]=BlackKing then
    begin
      Result := True;
      Exit;
    end;
  if x>0 then
    if Board.Board[x-1,y]=BlackKing then
    begin
      Result := True;
      Exit;
    end;
  if y>0 then
    if Board.Board[x,y-1]=BlackKing then
    begin
      Result := True;
      Exit;
    end;

  if (x<7) and (y<7) then
    if Board.Board[x+1,y+1]=BlackKing then
    begin
      Result := True;
      Exit;
    end;
  if (x<7) and (y>0) then
    if Board.Board[x+1,y-1]=BlackKing then
    begin
      Result := True;
      Exit;
    end;
  if (x>0) and (y<7) then
    if Board.Board[x-1,y+1]=BlackKing then
    begin
      Result := True;
      Exit;
    end;
  if (x>0) and (y>0) then
    if Board.Board[x-1,y-1]=BlackKing then
    begin
      Result := True;
      Exit;
    end;
end;

function TLegalMoves.IsSquareUnderWhiteAttack(x,y: Byte; Board: TChessBoardState): Boolean;
var
  i: Integer;
begin
  Result := False;
  // Is under attack by white pawns
  if y>1 then  // white pawns starts from y=1
  begin
    if x<7 then
      if IsWhitePawn(Board.Board[x+1,y-1]) then
      begin
        Result := True;
        Exit;
      end;
    if x>0 then
      if IsWhitePawn(Board.Board[x-1,y-1]) then
      begin
        Result := True;
        Exit;
      end;
  end;

  // Is under attack by white Rooks also (Queens as Rooks)
  // checking for right side rook or Queen as Rook
  if x<7 then
    for i := x+1 to 7 do
    begin
      if Board.Board[i,y]<>0 then
      begin
        if IsBlackPiece(Board.Board[i,y]) then
          break;
        if IsWhiteRook(Board.Board[i,y]) or IsWhiteQueen(Board.Board[i,y]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
    end;
  // checking for left side rook or Queen as Rook
  if x>0 then
    for i := x-1 downto 0 do
    begin
      if Board.Board[i,y]<>0 then
      begin
        if IsBlackPiece(Board.Board[i,y]) then
          break;
        if IsWhiteRook(Board.Board[i,y]) or IsWhiteQueen(Board.Board[i,y]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
    end;
  // checking for up side rook or Queen as Rook
  if y<7 then
    for i := y+1 to 7 do
    begin
      if Board.Board[x,i]<>0 then
      begin
        if IsBlackPiece(Board.Board[x,i]) then
          break;
        if IsWhiteRook(Board.Board[x,i]) or IsWhiteQueen(Board.Board[x,i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
    end;
  // checking for down side rook or Queen as Rook
  if y>0 then
    for i := y-1 downto 0 do
    begin
      if Board.Board[x,i]<>0 then
      begin
        if IsBlackPiece(Board.Board[x,i]) then
          break;
        if IsWhiteRook(Board.Board[x,i]) or IsWhiteQueen(Board.Board[x,i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
    end;
  // End checking attack by white Rooks (also Queens as Rooks)

  // Is under attack by white Bishops (also Queens as Bishops)
  // up right
  if (x<7) and (y<7) then
  begin
    i := 1;
    while ((x+i)<=7) and ((Y+i)<=7) do
    begin
      if Board.Board[x+i,y+i]<>0 then
      begin
        if IsBlackPiece(Board.Board[x+i,y+i]) then
          break;
        if IsWhiteBishop(Board.Board[x+i,y+i]) or IsWhiteQueen(Board.Board[x+i,y+i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
      Inc(i);
    end;
  end;
  // down right
  if (x<7) and (y>0) then
  begin
    i := 1;
    while ((x+i)<=7) and ((y-i)>=0) do
    begin
      if Board.Board[x+i,y-i]<>0 then
      begin
        if IsBlackPiece(Board.Board[x+i,y-i]) then
          break;
        if IsWhiteBishop(Board.Board[x+i,y-i]) or IsWhiteQueen(Board.Board[x+i,y-i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
      Inc(i);
    end;
  end;
  // up left
  if (x>0) and (y<7) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y+i)<=7) do
    begin
      if Board.Board[x-i,y+i]<>0 then
      begin
        if IsBlackPiece(Board.Board[x-i,y+i]) then
          break;
        if IsWhiteBishop(Board.Board[x-i,y+i]) or IsWhiteQueen(Board.Board[x-i,y+i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
      Inc(i);
    end;
  end;
  // down left
  if (x>0) and (y>0) then
  begin
    i := 1;
    while ((x-i)>=0) and ((Y-i)>=0) do
    begin
      if Board.Board[x-i,y-i]<>0 then
      begin
        if IsBlackPiece(Board.Board[x-i,y-i]) then
          break;
        if IsWhiteBishop(Board.Board[x-i,y-i]) or IsWhiteQueen(Board.Board[x-i,y-i]) then
        begin
          Result := True;
          Exit;
        end
        else
          break;
      end;
      Inc(i);
    end;
  end;
  // End checking attacks by white Bishops (also Queens as Bishops)

  // Is under attack by white knights
  if (x-1>=0) and (y-2>=0) then
    if Board.Board[x-1,y-2]= WhiteKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x-1>=0) and (y+2<=7) then
    if Board.Board[x-1,y+2]= WhiteKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x-2>=0) and (y-1>=0) then
    if Board.Board[x-2,y-1]= WhiteKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x-2>=0) and (y+1<=7) then
    if Board.Board[x-2,y+1]= WhiteKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x+1<=7) and (y-2>=0) then
    if Board.Board[x+1,y-2]= WhiteKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x+1<=7) and (y+2<=7) then
    if Board.Board[x+1,y+2]= WhiteKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x+2<=7) and (y-1>=0) then
    if Board.Board[x+2,y-1]= WhiteKnight then
    begin
      Result := True;
      Exit;
    end;

  if (x+2<=7) and (y+1<=7) then
    if Board.Board[x+2,y+1]= WhiteKnight then
    begin
      Result := True;
      Exit;
    end;
  // End checking attacks by white knights

  // Is under attack by white king
  if x<7 then
    if Board.Board[x+1,y]=WhiteKing then
    begin
      Result := True;
      Exit;
    end;
  if y<7 then
    if Board.Board[x,y+1]=WhiteKing then
    begin
      Result := True;
      Exit;
    end;
  if x>0 then
    if Board.Board[x-1,y]=WhiteKing then
    begin
      Result := True;
      Exit;
    end;
  if y>0 then
    if Board.Board[x,y-1]=WhiteKing then
    begin
      Result := True;
      Exit;
    end;

  if (x<7) and (y<7) then
    if Board.Board[x+1,y+1]=WhiteKing then
    begin
      Result := True;
      Exit;
    end;
  if (x<7) and (y>0) then
    if Board.Board[x+1,y-1]=WhiteKing then
    begin
      Result := True;
      Exit;
    end;
  if (x>0) and (y<7) then
    if Board.Board[x-1,y+1]=WhiteKing then
    begin
      Result := True;
      Exit;
    end;
  if (x>0) and (y>0) then
    if Board.Board[x-1,y-1]=WhiteKing then
    begin
      Result := True;
      Exit;
    end;
end;

end.
