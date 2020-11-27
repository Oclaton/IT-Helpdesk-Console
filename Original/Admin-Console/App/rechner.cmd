:: Diese Batch soll herausfinden, an welchem Rechner ein Benutzer angemeldet ist.

:: Es wird bei Anmeldungen auf mehreren Rechnern nur die gefunden, die erfolgte, als der
:: Benutzername auf keinem anderen Rechner eingetragen war.
::
@setlocal
@set gefunden=
@if %1.==. GOTO :benutzung
@set ANMELDENAME=%~1
@set WO=C:\Apps\Admin-Console\App\Wo.exe
@for /f "tokens=2 delims=:" %%a in ('%WO% %ANMELDENAME%^|find /i "%ANMELDENAME%"') do @(
	call :ident %%a %ANMELDENAME%
)
@if not %gefunden%.==ja. (
	@echo.
	@echo. Kann %ANMELDENAME% keinem Rechner zuordnen.
)
@goto :EOF

::##############################################################################
:ident
::IP-Adresse zum Namen auflösen
@set IP=%1
@set Benutzer=%2
@set gefunden=ja

::Wenn der Rechner unerreichbar ist, heißt die Zeile:
::	Reply from 10.72.8.2: Destination host unreachable.
::oder:	Antwort von 10.72.38.2: Zielhost nicht erreichbar.
@ping -n 1 -w 100 %IP%|find /i "TTL" >NUL
@if %errorlevel%==0 (call :UntersucheRechner %Benutzer%
) else (
	@echo.
	@chcp|find "1252" >NUL && (
		@echo. Benutzer %Benutzer% war bei %IP% angemeldet. (Rechner läuft nicht oder ist unerreichbar.^)
	) || (
		@echo. Benutzer %Benutzer% war bei %IP% angemeldet. (Rechner l„uft nicht oder ist unerreichbar.^)
	)
)
@goto :EOF

::##############################################################################
:UntersucheRechner
::Mit herausbekommen, wie der Rechner heißt und
::sichergehen, daß der Benutzer am Rechner angemeldet ist.
@SET BENUTZER=%1

::Den Rechnernamen vom Rechner selbst erfragen
::Alter Kommentar Das Zeichen "" ist 0x0C (Formfeed) und erscheint (manchmal?) in der Ausgabe von FIND (oder NBTSTAT?)
::Alter Befehl @for /f "delims=< " %%r in ('NBTSTAT -A %IP%^|find "<20>"') do @set RECHNER=%%r

::Wie heißt der Recher?
@for /f "tokens=3"  %%a in ('reg query \\%IP%\HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName^|find /i "ComputerName    REG_SZ"') do @set RECHNER=%%a
::SID des Benutzers aus dem AD holen
@for /f %%a in ('dsquery * -l -filter "(&(objectCategory=Person)(objectClass=User)(SAMAccountName=%BENUTZER%))" -attr objectSid') do @set SID=%%a
::SID des Benutzers
@reg query \\%IP%\HKEY_USERS |find /i "%SID%">nul
@if %errorlevel%==0 (
	@echo.
	@echo. Benutzer %BENUTZER% ist an %RECHNER% angemeldet.
	@echo. IP-Adresse: %IP%
) else (
	@echo.
	@chcp|find "1252" >NUL && (
		@echo. Benutzer %BENUTZER% war an %RECHNER% angemeldet. (Rechner läuft aber^)
	) || (
		@echo. Benutzer %BENUTZER% war an %RECHNER% angemeldet. (Rechner l„uft aber^)
	)
)
@goto :EOF

::##############################################################################
:benutzung
@echo.
@echo. Benutzung:
@echo. rechner.cmd ^<Benutzeranmeldename^>