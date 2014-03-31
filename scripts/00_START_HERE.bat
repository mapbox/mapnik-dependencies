@echo off

echo "use this script from 'Developer Command Prompt for VS2013' only"
echo "call from %ROOTDIR%"

CALL scripts\01_set_env_and_versions.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\02_download_packages.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\03_build_icu.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\04_build_boost.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\05_build_jpeg.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\06_build_freetype.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\07_build_zlib.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\08_build_libpng.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\09_build_libpq.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\10_build_tiff.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\11_build_pixman.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\12_build_cairo.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\13_build_libxml2.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\14_build_proj4.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\15_install_expat.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\16_build_gdal.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\17_unzip_sqlite.bat
IF ERRORLEVEL 1 GOTO ERROR

CALL scripts\18_build_protobuf.bat
IF ERRORLEVEL 1 GOTO ERROR

::GEOS not working
::CALL scripts\19_build_geos.bat
::IF ERRORLEVEL 1 GOTO ERROR


GOTO DONE

:ERROR
echo !!!!!ERROR: ABORTED!!!!!!

:DONE
echo -- DONE ---