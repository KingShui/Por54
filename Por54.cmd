@echo off &title Por54 Firefox Loader By KingShui & mode con cols=55 lines=9
echo,	CompanyName: KSSC
echo,	FileDescription: Firefox Loader
echo,	FileVersion: 0.0.0.32
echo,	LegalCopyright: KingShui
echo,	ProductName: Firefox Loader
echo,	ProductVersion: 0.0.0.32
echo,	Created by KingShui
echo,	For reference, please indicate the source.
:begin
set "key=%~dp0"
set "key=%key:!=|%"
setlocal enableextensions
setlocal enabledelayedexpansion
	
:init
set fpath=%~dp0
set ini=%~n0
Set fullname=%~1
Set dirpath=%~dp1
Set srcname=%~n1
if not exist !ini!.ini call :createini
for /f "delims=" %%i in (!ini!.ini) do set "%%i" >nul 2>nul

:package
if "%~1" NEQ "" (
	ver |find "5." &&echo NT5.x nonsupport package. &&pause>nul&&goto preinit
	if exist cabstr del cabstr >nul
	goto packagemod
	)
if not exist "%PFDir%" (
	ver |find "5." &&echo NT5.x nonsupport unpack. &&pause>nul&&goto preinit
	if exist Por54_Profiles.cab call :unpackmod
	)

:preinit
set prefs=%PFDir%\prefs.js
set pstar=user_pref("
set pend=);
find 2>nul 9009>nul & if "%errorlevel%" equ "9009" goto run
if "%FFPath%" == "" (
	(dir /s/b | find "firefox.exe")>ffpath
	set /p FFPath=<ffpath
	del /f/q ffpath >nul
	)
if not exist "%FFPath%" exit
if "%FFPath:~1,1%" NEQ ":" (
	set "FFPath=%fpath%%FFPath%"
	)
if not exist "%PFDir%" goto plugin
if "%PFDir:~1,1%" NEQ ":" (
	set "PFDir=%fpath%%PFDir%"
	)
if not exist %prefs% goto run

:plugin
if "%Plugin%" == "" goto cache
if "%Plugin:~1,1%" NEQ ":" (
	set "Plugin=%fpath%%Plugin%"
	)
if not exist "%Plugin%" md "%Plugin%"
set "MOZ_PLUGIN_PATH=%Plugin%"

:cache
if "%CacheDir%" == "" goto cachesize
if "%cachedir:~1,1%" NEQ ":" (
	set "cachedir=%fpath%%cachedir%"
	)
if not exist "%CacheDir%" md "%CacheDir%"

set cacpref=browser.cache.disk.parent_directory
set offpref=browser.cache.offline.parent_directory
set cappref=browser.cache.disk.capacity
set cacpath=%CacheDir%
set cacpath=%cacpath:\=\\%
set cacpref=%pstar%%cacpref%", "%cacpath%");
set offpref=%pstar%%offpref%", "%cacpath%");
set cappref=%pstar%%cappref%", %CacheSize%);

find /v "browser.cache.disk.parent_directory browser.cache.offline.parent_directory" "%prefs%" >cac && move /y cac "%prefs%" >nul
echo,>> "%prefs%"
echo %cacpref% >> "%prefs%"
echo,>> "%prefs%"
echo %offpref% >> "%prefs%"

:cachesize
if "%CacheSize%" == "" goto downdir
find /v "browser.cache.disk.capacity" "%prefs%" >cacs && move /y cacs "%prefs%" >nul
echo,>> "%prefs%"
echo %cappref% >> "%prefs%"	

:downdir
if "%DownDir%" == "" goto run
if "%DownDir:~1,1%" NEQ ":" (
	set "DownDir=%fpath%%DownDir%"
	)
if not exist "%DownDir%" md "%DownDir%"

set downloaddir=%DownDir%
set dirname=%downloaddir:\=\\%
set dirname=%dirname%
set ddir=%pstar%browser.download.folderList", 2);
set downloaddir=%pstar%browser.download.dir","%dirname%");
set dtapref=extensions.dta.directory
set dtadir=%DownDir%
set dtadowndir=%dtadir:\=\\\\%
set dtadowndir=%pstar%extensions.dta.directory", "[\"%dtadowndir%^\\\\\"]");

find /v "browser.download" "%prefs%" >down && move /y down "%prefs%" >nul
echo,>> "%prefs%"
echo %downloaddir% >> "%prefs%"
echo,>> "%prefs%"
echo %ddir% >> "%prefs%"

find "%dtapref%" "%prefs%" >nul
set msg=%errorlevel%
if %msg% equ 0 (
	find /v "%dtapref%" "%prefs%">dta
	move /y dta "%prefs%" >nul
	echo,>> "%prefs%"
	echo %dtadowndir% >> "%prefs%"
	)	
:run
start "" "%FFPath%" %params% -profile "%PFDir%"
ping 127.1 -n 3 >nul
exit

:unpackmod
expand Por54_Profiles.cab -F:* .\
goto preinit

:createini
echo.^[Configure^]>>!ini!.ini
echo.>>!ini!.ini
echo.^[Firefox Path^]>>!ini!.ini
echo.FFPath=Firefox\firefox.exe>>!ini!.ini
echo.>>!ini!.ini
echo.^[Profile Path^]>>!ini!.ini
echo.PFDir=!ini!>>!ini!.ini
echo.>>!ini!.ini
echo.^[Ext Params^]>>!ini!.ini
echo.Params= /Prefetch:1 -turbo --no-remote>>!ini!.ini
echo.>>!ini!.ini
echo.^[Down Path^]>>!ini!.ini
echo.DownDir=Downloads>>!ini!.ini
echo.>>!ini!.ini
echo.^[Cache Path^]>>!ini!.ini
echo.CacheDir=Cache>>!ini!.ini
echo.>>!ini!.ini
echo.^[Cache Size^]>>!ini!.ini
echo.CacheSize=358400>>!ini!.ini
echo.>>!ini!.ini
echo.^[Plugin Path^]>>!ini!.ini
echo.Plugin=Plugin>>!ini!.ini
echo.>>!ini!.ini
echo ;Please do not change filename>>!ini!.ini
start "" /wait notepad !ini!.ini
goto init

:packagemod
tasklist|find "firefox.exe" && taskkill /im firefox.exe
for %%b in (cache healthreport minidumps offlinecache safebrowsing startupcache webapps weave thumbnails healthreport.sqlite healthreport.sqlite-wal webappsstore.sqlite _cache_clean_ jumpListCache searchplugins) do (
	if exist "%pfdir%\%%b\" (
		rd /s /q "%pfdir%\%%b" >nul
		) else (
			if exist "%pfdir%\%%b" (
				del /f /q "%pfdir%\%%b" >nul
				)
			)
		)
set cmdstr=MAKECAB /v3 /D CompressionType=LZX /D CompressionMemory=21 /D MaxDiskSize=CDROM /D Cabinet=On /D Compress=On /D FolderSizeThreshold=5000000 /D DiskDirectoryTemplate="%~dp1." /D CabinetNameTemplate="Por54_Profiles.CAB"
set "fullname=%~1"
if exist "!fullname!\" (
	for /f "delims=" %%a in ('dir "!fullname!" /a-d /s /b') do (
		setlocal disabledelayedexpansion
		set "name=%%a"
		call set "name=%%name:!=|%%"
		setlocal enabledelayedexpansion
		echo !name!>>cabstr
		endlocal
		endlocal
		)) else (
		echo %~1>>cabstr
		)
if "%~2" neq "" shift&goto packagemod	
SETLOCAL DISABLEDELAYEDEXPANSION
(for /f "delims=" %%a in (cabstr) do (
	set "str=%%a"
	call :fun
	))>cab
ENDLOCAL
%cmdstr% /F cab
del /f/q patch cab cabstr SETUP.INF SETUP.RPT >nul
exit
:fun
set "str=%str:!=|%"
setlocal enabledelayedexpansion
set str="!str!" "!str:*%key%=!"
endlocal&echo %str:|=!%