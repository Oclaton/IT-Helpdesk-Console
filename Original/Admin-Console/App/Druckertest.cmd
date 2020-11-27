@echo off
echo Testsite Helpdesk>%temp%\test.txt
cls
set /p printer=printername:
set suffix=
set errorlevel=
set ok_log=0
set fehler_log=0
set pingausgabe=
set dnsausgabe=
set lprAusgabe=
echo.
echo.


for %%e in (DOMAIN DOMAIN.intra) do nslookup %printer%.%%e 2>nul|find /i "Name:" 1>nul 2>&1 && set suffix=%%e
set printer_lang=%printer%.%suffix%
if /i ("%suffix%") == ("") set printer_lang=%printer%


echo.

echo ***************************************************************
echo.                                                         
echo Step 1
echo printer wird auf Ping geprueft :            
ping %printer_lang% >nul&& call :ok "ping %printer_lang% ist ok"||call :fehler "%printer_lang% per ping nicht erreichbar"
echo.  


echo Step 2
echo Namensaufloesung wird geprueft :
set errorlevel=
nslookup %printer_lang%|find /i /c "Name:" >nul
if %errorlevel% EQU 1 (
			call :fehler "nslookup %printer_lang% per nslookup nicht aufloesbar"
		) ELSE (
			call :ok "nslookup %printer_lang% ist ok"
		)
echo.
echo Step 3
echo printer wird auf direkte Funktion geprueft :
set errorlevel=
lpr -S %printer_lang% -P %printer_lang% %temp%\test.txt|find /i /c "Fehler" >nul
if %errorlevel% EQU 0 (
			call :fehler "Direktdruck %printer_lang% nicht moeglich"
		) ELSE (
			call :ok "Direktdruck %printer_lang% ist ok"
		)
echo.  


if %ok_log% == 3 color A0 
if %fehler_log% NEQ 0 color C0 

echo bitte Taste drucken um Fenster zu schliessen.
echo.
echo %pingausgabe%
pause

goto :EOF


:ok
set /A ok_log=%ok_log% + 1
echo %~1
goto :EOF


:fehler
set /A fehler_log=%fehler_log% + 1
echo %~1
goto :EOF





