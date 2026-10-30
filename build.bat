@echo off
setlocal
set "CONFIG=Release"
if /I "%~1"=="debug" set "CONFIG=Debug"
if /I "%~1"=="release" set "CONFIG=Release"
if not "%~1"=="" if /I not "%~1"=="debug" if /I not "%~1"=="release" (
  echo Usage: build.bat [release^|debug]
  exit /b 2
)
if defined BDS if exist "%BDS%\bin\rsvars.bat" call "%BDS%\bin\rsvars.bat"
if not defined BDS if exist "%ProgramFiles(x86)%\Embarcadero\Studio\37.0\bin\rsvars.bat" call "%ProgramFiles(x86)%\Embarcadero\Studio\37.0\bin\rsvars.bat"
where msbuild >nul 2>nul || (echo ERROR: RAD Studio build environment was not found.& exit /b 1)
msbuild "%~dp0ChessBoard_final\ChessInterfaceUCI3\Chess.dproj" /t:Build /p:Config=%CONFIG% /p:Platform=Win32 /p:DCC_UnitSearchPath=..\component /nologo /verbosity:minimal
if errorlevel 1 exit /b 1
echo SUCCESS: ChessBoard demo %CONFIG% Win32 build completed.
