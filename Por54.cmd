@echo off
echo,CompanyName: KSSC
echo,FileDescription: Firefox Loader
echo,FileVersion: 0.0.0.31
echo,LegalCopyright: KingShui
echo,ProductName: Firefox Loader
echo,ProductVersion: 0.0.0.31
echo,Created by KingShui
echo,For reference, please indicate the source.
:begin
set "key=%~dp0"
set "key=%key:!=|%"
setlocal enableextensions
setlocal enabledelayedexpansion
title Por54 Firefox Loader By KingShui
	
:init
set fpath=%~dp0
set ini=%~n0
Set fullname=%~1
Set dirpath=%~dp1
Set srcname=%~n1
if not exist !ini!.ini call :createini
for /f "delims=" %%i in ('findstr "=" "!ini!.ini"') do set "%%i"
set prefs=%PFDir%\prefs.js
set pstar=user_pref("
set pend=);
ver |findstr "5." &&start /wait mshta vbscript:msgbox("一些功能不支持NT5.X系统，将直接加载profile和启动参数运行",,"Por54")(windows.close)&goto run

:package
if "%~1" NEQ "" (
	echo %~1 >patch
	if "%~2" NEQ "" echo %~2 >>patch
	if "%~3" NEQ "" echo %~3 >>patch
	if "%~4" NEQ "" echo %~4 >>patch
	if "%~5" NEQ "" echo %~5 >>patch
	if "%~6" NEQ "" echo %~6 >>patch
	if "%~7" NEQ "" echo %~7 >>patch
	if "%~8" NEQ "" echo %~8 >>patch
	if "%~9" NEQ "" echo %~9 >>patch
	call :packagemod
	)
if exist Por54_Profiles.cab (
	if not exist "%PFDir%" call :unpackmod
	)

:preinit
if "%FFPath%" == "" (
	(dir /s/b | findstr "firefox.exe")>ffpath
	set /p FFPath=<ffpath
	del /f/q ffpath >nul
	)

if not exist "%FFPath%" exit
if not exist %prefs% goto run

if "%FFPath:~1,1%" NEQ ":" (
	set "FFPath=%fpath%%FFPath%"
	)

if "%DownDir:~1,1%" NEQ ":" (
	set "DownDir=%fpath%%DownDir%"
	)
	
if "%PFDir:~1,1%" NEQ ":" (
	set "PFDir=%fpath%%PFDir%"
	)

if "%cachedir:~1,1%" NEQ ":" (
	set "cachedir=%fpath%%cachedir%"
	)	

if "%Plugin:~1,1%" NEQ ":" (
	set "Plugin=%fpath%%Plugin%"
	)	

		
:plugin
if "%Plugin%" == "" goto cache
if not exist "%Plugin%" md "%Plugin%"
set "MOZ_PLUGIN_PATH=%Plugin%"

:cache
if "%CacheDir%" == "" goto cachesize
if not exist "%CacheDir%" md "%CacheDir%"

set cacpref=browser.cache.disk.parent_directory
set offpref=browser.cache.offline.parent_directory
set cappref=browser.cache.disk.capacity
set cacpath=%CacheDir%
set cacpath=%cacpath:\=\\%
set cacpref=%pstar%%cacpref%", "%cacpath%");
set offpref=%pstar%%offpref%", "%cacpath%");
set cappref=%pstar%%cappref%", %CacheSize%);

findstr /v "browser.cache.disk.parent_directory browser.cache.offline.parent_directory" "%prefs%" >cac && move /y cac "%prefs%" >nul
echo,>> "%prefs%"
echo %cacpref% >> "%prefs%"
echo,>> "%prefs%"
echo %offpref% >> "%prefs%"

:cachesize
if "%CacheSize%" == "" goto downdir
findstr /v "browser.cache.disk.capacity" "%prefs%" >cacs && move /y cacs "%prefs%" >nul
echo,>> "%prefs%"
echo %cappref% >> "%prefs%"	

:downdir
if "%DownDir%" == "" goto run
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

findstr /v "browser.download" "%prefs%" >down && move /y down "%prefs%" >nul
echo,>> "%prefs%"
echo %downloaddir% >> "%prefs%"
echo,>> "%prefs%"
echo %ddir% >> "%prefs%"

findstr "%dtapref%" "%prefs%" >nul
set msg=%errorlevel%
if %msg% equ 0 (
	findstr /v "%dtapref%" "%prefs%">dta
	move /y dta "%prefs%" >nul
	echo,>> "%prefs%"
	echo %dtadowndir% >> "%prefs%"
	)	
:run
start "" "%FFPath%" %params% -profile "%PFDir%"
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
tasklist|findstr "firefox.exe" && taskkill /im firefox.exe
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
if exist cabstr del cabstr >nul
for /f "delims=" %%i in (patch) do (
	set "fullname=%%i"
	set "fullname=!fullname:~0,-1!"
	if exist "!fullname!\" (
		for /f "delims=" %%a in ('dir "!fullname!" /s /b /a-d') do (
		SETLOCAL DISABLEDELAYEDEXPANSION
		set name=%%a
		call set "name=%%name:!=|%%"
		SETLOCAL ENABLEDELAYEDEXPANSION
		echo !name!>>cabstr
		ENDLOCAL
		ENDLOCAL
		)) else (
		echo %%i>>cabstr
		)
	)
if exist patch del patch >nul	
SETLOCAL DISABLEDELAYEDEXPANSION
(for /f "delims=" %%a in (cabstr) do (
	set "str=%%a"
	call :fun
	))>cab
ENDLOCAL
%cmdstr% /F cab
del /f/q cab cabstr SETUP.INF SETUP.RPT >nul
exit
:fun
set "str=%str:!=|%"
setlocal enabledelayedexpansion
set str="!str!" "!str:*%key%=!"
endlocal&echo %str:|=!%