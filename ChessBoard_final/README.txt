ChessBoard
==========

ChessBoard is a Delphi/VCL chessboard component. The main visual component class is TChessBoard.

The component is intended for Delphi developers who want to add a playable chess board to a VCL application without building the board UI, piece handling, and move-rule logic from scratch.

Package contents
----------------
component/
  ChessBoard.pas          Main VCL component unit.
  ChessTypes.pas          Chess constants, board-state records, events, and shared types.
  LegalMoves.pas          Move generation and chess-rule logic.
  ChessBoardPackage.dpk   Delphi package for installing the component.
  ChessBoard.dcr          Component palette/resource file.
  ChessPieces*/           Original bitmap piece files kept as editable source assets.

ChessInterfaceUCI3/
  A sample VCL application showing how the component can be used together with a UCI chess engine.

engines/
  Pawnora.exe             Small UCI-compatible engine included for quick testing.

Quick start
-----------
1. Open component/ChessBoardPackage.dpk in Delphi.
2. Build and install the package.
3. The component appears in the ALTEK component palette tab.
4. Drop TChessBoard on a VCL form.
5. Run the application and start moving pieces.

UCI demo
--------
The included demo application is not presented as a finished chess product. It is a practical sample showing how TChessBoard can be connected to a UCI-compatible chess engine.

Pawnora.exe is included only so the demo can run immediately after download. For stronger play, use Stockfish or another UCI-compatible engine.

Compatibility notes
-------------------
- The project is intended to remain compatible with Delphi 7 and modern Delphi/RAD Studio.
- Published component events use string for IDE/DFM compatibility.
- UCI communication uses AnsiString internally because UCI commands are ASCII text.
- The Zobrist random table is stored as signed Int64 constants and accessed through ZobristValue(). This avoids Delphi 7 range-check compile errors for UInt64 constants above High(Int64), while preserving the original 64-bit bit patterns for XOR hashing.

Public-package cleanup
----------------------
- The old personal screen-capture helper code is not included.
- The old separate component test project is not included.
- Build artifacts and IDE history files are not included.
- Development-only commented code was removed while keeping useful explanatory comments.

This source package is meant as an educational Delphi/VCL component project and as a base for experimentation.
