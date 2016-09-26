# Tibia maps installer for Windows [![Build status](https://travis-ci.org/tibiamaps/tibia-maps-installer-windows.svg)](https://travis-ci.org/tibiamaps/tibia-maps-installer-windows)

[NSIS](http://nsis.sourceforge.net/) source code for an executable that downloads the latest version of the Tibia map data provided by [the tibia-map-data project](https://github.com/tibiamaps/tibia-map-data) and extracts it to the `%LOCALAPPDATA%\Tibia\packages\Tibia\minimap` folder.

## Creating the `.exe` installer

1. Download and install NSIS v2.x from <http://nsis.sourceforge.net/Download>.

2. Copy the contents of the `dependencies` folder in this repo to the NSIS directory, which is located at `C:\Program Files (x86)\NSIS` by default.

3. Right-click `create-installer.nsi` and select “Compile NSIS Script” to generate `Tibia-maps-installer.exe`.

## Maintainer

| [![twitter/mathias](https://gravatar.com/avatar/24e08a9ea84deb17ae121074d0f17125?s=70)](https://twitter.com/mathias "Follow @mathias on Twitter") |
|---|
| [Mathias Bynens](https://mathiasbynens.be/) |
