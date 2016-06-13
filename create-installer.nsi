Name "Tibia maps"
OutFile "Tibia-maps-installer.exe"
BrandingText " "
Icon "icon.ico"
Caption "Tibia maps installer by TibiaMaps.io"
VIProductVersion "1.0.0.0"
VIAddVersionKey CompanyName "TibiaMaps.io"
VIAddVersionKey FileDescription "Tibia maps installer, powered by the TibiaMaps.io maps."
VIAddVersionKey FileVersion "1.0.0"
VIAddVersionKey LegalCopyright TibiaMaps.io
VIAddVersionKey OriginalFilename "Tibia maps installer.exe"
VIAddVersionKey ProductName "Tibia maps installer"

!include "Sections.nsh" ; Include the plugin for checkboxes.
!include "zipdll.nsh" ; Include the ZIP plugin.

Page components
Page instfiles

; Set up the selection screen.
Section "Tibia maps with markers" P1
FindProcDLL::FindProc "Tibia.exe" ; Show an error if Tibia is running.
IntCmp $R0 1 0 notRunning
	MessageBox MB_OK|MB_ICONEXCLAMATION "Tibia is running. Please close it first." /SD IDOK
	goto end
notRunning: ; If Tibia isn’t running, start downloading the map files.
inetc::get "https://tibiamaps.io/downloads/with-markers" "$pluginsdir\Automap.zip" /END
Pop $R0 ; Get the return value.
StrCmp $R0 "OK" +3
	MessageBox MB_OK "Download failed; try again later."
	Quit
Pop $0
end:
SectionEnd

Section /o "Tibia maps without markers" P2
IntCmp $R0 1 0 notRunning
	MessageBox MB_OK|MB_ICONEXCLAMATION "Tibia is running. Please close it first." /SD IDOK
	goto end
notRunning: ; If Tibia isn’t running, start downloading the map files.
inetc::get "https://tibiamaps.io/downloads/without-markers" "$pluginsdir\Automap.zip" /END
Pop $R0 ; Get the return value.
StrCmp $R0 "OK" +3
	MessageBox MB_OK "Download failed; try again later."
	Quit
Pop $0
end:
SectionEnd

; Handle the installation.
Section
IntCmp $R0 1 0 notRunning
	Quit
notRunning:
IfFileExists "$pluginsdir\Automap.zip" fileExist
Quit
fileExist:
IfFileExists "$APPDATA\Tibia\Automap\*.*" folderExist
goto folderDontExist
folderExist:
DetailPrint "Removing old map files..."
DetailPrint "Deleting $APPDATA\Tibia\Automap..."
RMDir /r "$APPDATA\Tibia\Automap"
folderDontExist:
DetailPrint "Installing new map files..."
!insertmacro ZIPDLL_EXTRACT "$pluginsdir\Automap.zip" "$APPDATA\Tibia" "<ALL>"
DetailPrint "Cleaning up temporary files..."
Delete "$pluginsdir\Automap.zip"
SectionEnd

; Startup checks and variables.
Function .onInit
Initpluginsdir ; Make sure `$pluginsdir` exists.
StrCpy $1 ${P1} ; The default.
; Size (KB) of uncompressed ZIP with marker data.
; unzip -l Automap-with-markers.zip | tail -n 1
SectionSetSize ${P1} 105689
 ; Size (KB) of uncompressed ZIP without marker data.
 ; unzip -l Automap-without-markers.zip | tail -n 1
SectionSetSize ${P2} 105647
FunctionEnd

; Ensure only a single checkbox can be checked at any time.
Function .onSelChange
!insertmacro StartRadioButtons $1
	!insertmacro RadioButton ${P1}
	!insertmacro RadioButton ${P2}
!insertmacro EndRadioButtons
FunctionEnd
