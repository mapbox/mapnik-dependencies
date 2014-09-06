@echo off
SETLOCAL
SET EL=0
echo ------ expat -----
:: guard to make sure settings have been sourced
IF "%ROOTDIR%"=="" ( echo "ROOTDIR variable not set" && GOTO DONE )

cd %PKGDIR%
CALL %ROOTDIR%\scripts\download expat-%EXPAT_VERSION%.tar.gz
IF ERRORLEVEL 1 GOTO ERROR

if EXIST expat (
  echo found extracted sources
)

if NOT EXIST expat (
  echo extracting
  CALL bsdtar xfz expat-%EXPAT_VERSION%.tar.gz
  rename expat-%EXPAT_VERSION% expat
  IF ERRORLEVEL 1 GOTO ERROR
)

cd expat
IF ERRORLEVEL 1 GOTO ERROR

patch -N -p1 < %PATCHES%/expat.diff || true

msbuild expat.sln /m /toolsversion:%TOOLS_VERSION% /p:PlatformToolset=%PLATFORM_TOOLSET% /p:Configuration="Release" /p:Platform=%BUILDPLATFORM%
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

GOTO DONE

:ERROR
SET EL=%ERRORLEVEL%
echo ----------ERROR expat --------------

:DONE

cd %ROOTDIR%
EXIT /b %EL%
