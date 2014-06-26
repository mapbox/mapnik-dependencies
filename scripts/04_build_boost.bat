@echo off
echo ----------- boost ---------


::set to -vc110 if using MSVC 2012
SET BOOST_PREFIX=boost-%BOOST_VERSION%-vc120


powershell scripts\deletedir -dir2del "%ROOTDIR%\%BOOST_PREFIX%"
IF ERRORLEVEL 1 GOTO ERROR
PAUSE


echo extracting
CALL bsdtar xzf %PKGDIR%/boost_1_%BOOST_VERSION%_0.tar.gz
IF ERRORLEVEL 1 GOTO ERROR

cd boost_1_%BOOST_VERSION%_0

echo !!!!!!!!!
echo USE x86 COMMANDPROMPT!!!!!!!!
::http://www.boost.org/boost-build2/doc/html/bbv2/reference/tools.html#v2.reference.tools.compiler.msvc.64
:: If you provide a path to the compiler explicitly, provide the path to the 32-bit compiler. If you try to specify the path to any of 64-bit compilers, configuration will not work.
echo !!!!!!!!
echo.
echo adjust tools/build/v2/user-config.jam to use python:
echo using python : 2.7 : C:/Python27/python.exe ;
echo or 64bit Python
echo.
pause


echo calling bootstrap bat
CALL bootstrap.bat
IF ERRORLEVEL 1 GOTO ERROR


::http://dominoc925.blogspot.co.at/2013/04/how-i-build-boost-for-64-bit-windows.html

::patching has_icu_test.cpp
::http://stackoverflow.com/a/16304738

::I was building boost with the bjam -q option.
::When I build using the bjam -q option the build stops on the above error and
::does not build the libraries.
::I removed the -q and it ignored the above error, as you explained, and
::everything built fine. 

::http://www.boost.org/boost-build2/doc/html/bbv2/overview/invocation.html
::http://www.boost.org/doc/libs/1_55_0/more/getting_started/windows.html#or-build-binaries-from-source
::http://www.boost.org/doc/libs/1_55_0/libs/regex/doc/html/boost_regex/install.html
::http://devwiki.neosys.com/index.php/Building_Boost_32/64_on_Windows


::VS2010/MSBuild 10: toolset=msvc-10.0 
::VS2012/MSBuild 11: toolset=msvc-11.0
::VS2013/MSBuild 12: toolset=msvc-12.0
::64bit: http://stackoverflow.com/a/2326485
echo bjamming ....
IF ERRORLEVEL 1 GOTO ERROR

CALL b2 toolset=msvc-12.0 --clean
::CALL bjam toolset=msvc-12.0 address-model=%BOOSTADDRESSMODEL% --prefix=..\\%BOOST_PREFIX% --with-python --with-thread --with-filesystem --with-date_time --with-system --with-program_options --with-regex --with-chrono --disable-filesystem2 -sHAVE_ICU=1 -sICU_PATH=%ROOTDIR%\\icu -sICU_LINK=%ROOTDIR%\\icu\\lib\\icuuc.lib release link=static install --build-type=complete
::icu: lib64\
:: -a rebuild everything
:: -q stop at first error
:: --reconfigure rerun all configuration checks




::b2 -a variant=release --toolset=msvc-12.0 architecture=x86 address-model=64 --with-python stage --stagedir=stage64 link=shared,static --build-type=complete -j2 -a

::just regex
::b2 -a --build-type=minimal --with-regex  address-model=32 stage --stagedir=stage32-minimal
::b2 toolset=msvc-12.0 address-model=%BOOSTADDRESSMODEL% -a --build-type=complete --with-regex  address-model=32 stage --stagedir=stage32-regex-complete -sHAVE_ICU=1 -sICU_PATH=%ROOTDIR%\icu -sICU_LINK=%ROOTDIR%\icu\lib\icuuc.lib release link=static,shared
::!!!!! THIS SEEMS TO BE THE(!) ONE THAT RULES THEM ALL!!!
::b2 toolset=msvc-12.0 address-model=%BOOSTADDRESSMODEL% -a --build-type=complete --with-regex  address-model=32 stage --stagedir=stage32-regex-complete -sHAVE_ICU=1 -sICU_PATH=%ROOTDIR%\icu release link=static,shared

::works:
::b2 -j2 -a --build-type=complete --with-regex address-model=32 stage --stagedir=stage32-complete
::b2 -j2 -a --build-type=complete install release --toolset=msvc-12.0 --prefix=..\\%BOOST_PREFIX% address-model=%BOOSTADDRESSMODEL% --with-thread --with-regex -sHAVE_ICU=1 -sICU_PATH=%ROOTDIR%\\icu -sICU_LINK=L%ROOTDIR%\\icu\\lib\\icuuc.lib
::b2 -j2 -a --build-type=complete install release --toolset=msvc-12.0 --prefix=..\\%BOOST_PREFIX% --with-python python=2.7 --with-thread --with-regex --with-filesystem --with-date_time --with-system --with-program_options --with-chrono --disable-filesystem2 -sHAVE_ICU=1 -sICU_PATH=%ROOTDIR%\\icu
::ORIGINAL:
::bjam toolset=msvc --prefix=..\\%BOOST_PREFIX% --with-thread --with-filesystem --with-date_time --with-system --with-program_options --with-regex --with-chrono --disable-filesystem2 -sHAVE_ICU=1 -sICU_PATH=%ROOTDIR%\\icu -sICU_LINK=%ROOTDIR%\\icu\\lib\\icuuc.lib release link=static install --build-type=complete
::bjam toolset=msvc --prefix=..\\%BOOST_PREFIX% --with-python python=2.7 release link=static --build-type=complete install
::does not work
::b2 -a --build-type=complete release link=static --with-regex -sHAVE_ICU=1 -sICU_PATH=%ROOTDIR%\icu address-model=32

::this seems to be necessary to get all types regex libs
::even when -sICU_PATH is specified
SET INCLUDE=%ROOTDIR%\icu\include;%INCLUDE%

:: SEEMS THAT ONLY SINGLE BACKSLASH IS VALID FOR -sICU_PATH
:: NO DOUBLE BACKSLASH. STILL HAVE TO VERIY
32 BIT
CALL b2 toolset=msvc-12.0 address-model=%BOOSTADDRESSMODEL% -a --prefix=..\\%BOOST_PREFIX% --with-python python=2.7 --with-thread --with-filesystem --with-date_time --with-system --with-program_options --with-regex --with-chrono --disable-filesystem2 -sHAVE_ICU=1 -sICU_PATH=%ROOTDIR%\icu -sICU_LINK=%ROOTDIR%\icu\lib\icuuc.lib release link=static,shared install --build-type=complete >%ROOTDIR%\build_boost-%BOOST_VERSION%.log 2>&1

64BIT
CALL b2 toolset=msvc-12.0 address-model=%BOOSTADDRESSMODEL% -a --prefix=..\\%BOOST_PREFIX% --with-python python=2.7 --with-thread --with-filesystem --with-date_time --with-system --with-program_options --with-regex --with-chrono --disable-filesystem2 -sHAVE_ICU=1 -sICU_PATH=%ROOTDIR%\icu -sICU_LINK=%ROOTDIR%\icu\lib64\icuuc.lib release link=static,shared install --build-type=complete >%ROOTDIR%\build_boost-%BOOST_VERSION%.log 2>&1
IF ERRORLEVEL 1 GOTO ERROR

::if you need python
::note for VS2012, use toolset=msvc-11.0 and VS2010 use toolset=msvc-10.0 
::echo bjamming (python) ....
::CALL bjam toolset=msvc-12.0 --prefix=..\\%BOOST_PREFIX% --with-python python=2.7 release link=static --build-type=complete install
::IF ERRORLEVEL 1 GOTO ERROR

GOTO DONE

:ERROR
echo =========== ERROR boost =========

:DONE

cd %ROOTDIR%
EXIT /b %ERRORLEVEL%
