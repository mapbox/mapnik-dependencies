# DEPRECATED

**This repository is not maintained anymore as Windows support for `mapnik` and `node-mapnik` has been dropped.**

Background information: https://github.com/mapnik/node-mapnik/issues/848

**If you are interested in bringing Windows support back to life contact @springmeyer**

windows-builds
===================

[![Build status](https://ci.appveyor.com/api/projects/status/5bgyk71sbsg58n77?svg=true)](https://ci.appveyor.com/project/Mapbox/windows-builds)
[![Build Status](https://travis-ci.org/mapbox/windows-builds.svg?branch=master)](https://travis-ci.org/mapbox/windows-builds)

**Things are moving fast and sometimes break.
If something doesn't work for you, please [open an issue](https://github.com/mapbox/windows-builds/issues/new).**

Windows build scripts mainly targeting:
* mapnik and its dependencies
* C++11 build of node
* node-mapnik

Other supported software:
* node-gdal
* osmium: libosmium, node-osmium, osmium-tool
* osrm

## Requirements

 - __64bit__ operating system (W7, 8, 8.1, Server 2012)
 - [Visual Studio 2015](https://www.visualstudio.com/en-us/downloads/download-visual-studio-vs.aspx), **No earlier versions suppported, C++11 support needed!**
 - [Python 2.7 32 bit](https://www.python.org/downloads/windows/) installed into `C:\Python27`
 - [git](https://msysgit.github.io/) installed into `C:\Program Files (x86)\Git`

### Recommendations:

 - If you are using AWS, then [this `ami-6f2cf804` in `us-east-1`](https://aws.amazon.com/marketplace/ordering?productId=6880e80b-b23d-4689-877e-02e40bdfe170&ref_=dtl_psb_continue&region=us-east-1) is a good starting point
 - Then install `Visual Studio Express 2015 for Windows Desktop` from https://www.visualstudio.com/en-us/downloads/download-visual-studio-vs.aspx ([direct download](http://download.microsoft.com/download/D/E/5/DE5263E9-A58D-469A-BA16-14786E2E2B1C/wdexpress_full.exe))

## System Setup

Install:

 - Python 2.7 32 bit
 - Git
 - Visual Studio VS2015

**When using your builds on machines that don't have Visual Studio installed you have to install the C++ runtime corresponding to the VS version that was used for building:**
* VS2015 runtime:
  * [x64](<https://mapbox.s3.amazonaws.com/windows-builds/visual-studio-runtimes/vcredist-VS2015/vc_redist.x64.exe>)
  * [x86](<https://mapbox.s3.amazonaws.com/windows-builds/visual-studio-runtimes/vcredist-VS2015/vc_redist.x86.exe>)

## Build Setup

There is no need to manually download any dependencies, they all get downloaded automatically when needed.


```
git clone https://github.com/mapbox/windows-builds.git
cd windows-builds
settings.bat
```

This defines default options to get a quick 64bit build of mapnik: e.g dependencies are not compiled, but **already compiled binary dependencies** get downloaded.

### Options for settings.bat ([see source for overridable parameters](/settings.bat)):

    settings.bat ["OVERRIDABLE-PARAM=VALUE"] ["OVERRIDABLE-PARAM-TWO=VALUE"]

You can combine as many overridable parameters as you like, **but each one has to be quoted with double quotes!**

Examples:
* Turning on compilation of dependencies: `settings "FASTBUILD=0"`
* Building 32bit and using mapnik branch `win-perf`: `settings "TARGET_ARCH=32" "MAPNIKBRANCH=win-perf"`


## Building mapnik

    scripts\build.bat

With `"FASTBUILD=1"` (the default):
* downloads pre-compiled dependencies
* pulls latest mapnik (honoring `MAPNIKBRANCH`)
* builds mapnik only
* to build node-mapnik, issue `scripts\build_node_mapnik.bat` afterwards

With `"FASTBUILD=0"`:
* downloads/pulls source and builds each dependencies
* pulls latest mapnik (honoring `MAPNIKBRANCH`)
* builds mapnik
* pulls and builds nodejs
* pulls latest node-mapnik (honoring `NODEMAPNIKBRANCH`)
* builds node-mapnik

With `"PACKAGEMAPNIK=1"` (the default) a mapnik SDK package is created, including all necessary header files, libs and DLLs.

The package will be created in the directory `bin\` with this name:

    mapnik-win-sdk-<MSBUILD VERSION>-<ARCHITECTURE>-<MAPNIK GIT TAG>.7z

 e.g.

    mapnik-win-sdk-14.0-x64-v3.0.0-rc1-242-g2a33ead.7z

## Creating binary mapnik dependencies packages (Mapbox specific)

Binary deps packages help speed up the mapnik build by providing already compiled dependencies. They are utilized by `"FASTBUILD=0"` (the default) and provided by Mapbox via S3 - the build scripts pull them down automatically.

* x64: `settings "FASTBUILD=0" "PACKAGEDEPS=1"`
* x86: `settings "TARGET_ARCH=32" "FASTBUILD=0" "PACKAGEDEPS=1"`

The resulting 7z files are created in the respective `bin\` directories:
* x64: `mapnik-win-sdk-binary-deps-14.0-x64.7z`
* x86: `mapnik-win-sdk-binary-deps-14.0-x86.7z`

### Automated builds

The binary deps packages have to be updated everytime one or more depencdencies change
(e.g. `boost@1.60` -> `boost@1.61`).
Otherwise `"FASTBUILD=1"` will use older depencdencies.

The use of binary deps packages can be overriden via `"FASTBUILD=0"`.

The new binary deps packages have to be put into (overwrite old ones)
```
s3://mapbox/windows-builds/windows-build-deps
```
