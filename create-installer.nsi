Name "Tibia maps"
OutFile "Tibia-11-maps-installer.exe"
BrandingText " "
Icon "icon.ico"
Caption "Tibia 11 maps installer by TibiaMaps.io"
VIProductVersion "1.1.0.0"
VIAddVersionKey CompanyName "TibiaMaps.io"
VIAddVersionKey FileDescription "Tibia maps installer for Tibia 11, powered by the TibiaMaps.io maps."
VIAddVersionKey FileVersion "1.1.0"
VIAddVersionKey LegalCopyright TibiaMaps.io
VIAddVersionKey OriginalFilename "Tibia 11 maps installer.exe"
VIAddVersionKey ProductName "Tibia 11 maps installer"

!include "Sections.nsh" ; Include the plugin for checkboxes.
!include "zipdll.nsh" ; Include the ZIP plugin.

Page components
Page instfiles

; Set up the selection screen.
Section "Tibia maps with markers" P1
FindProcDLL::FindProc "client.exe" ; Show an error if Tibia is running.
IntCmp $R0 1 0 notRunning
	MessageBox MB_OK|MB_ICONEXCLAMATION "Tibia is running. Please close it first." /SD IDOK
	goto end
notRunning: ; If Tibia isn’t running, start downloading the map files.
inetc::get "https://tibiamaps.io/downloads/minimap-with-markers" "$pluginsdir\minimap.zip" /END
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
inetc::get "https://tibiamaps.io/downloads/minimap-without-markers" "$pluginsdir\minimap.zip" /END
Pop $R0 ; Get the return value.
StrCmp $R0 "OK" +3
	MessageBox MB_OK "Download failed; try again later."
	Quit
Pop $0
end:
SectionEnd

Section /o "Tibia maps with grid overlay and markers" P3
IntCmp $R0 1 0 notRunning
	MessageBox MB_OK|MB_ICONEXCLAMATION "Tibia is running. Please close it first." /SD IDOK
	goto end
notRunning: ; If Tibia isn’t running, start downloading the map files.
inetc::get "https://tibiamaps.io/downloads/minimap-with-grid-overlay-and-markers" "$pluginsdir\minimap.zip" /END
Pop $R0 ; Get the return value.
StrCmp $R0 "OK" +3
	MessageBox MB_OK "Download failed; try again later."
	Quit
Pop $0
end:
SectionEnd

Section /o "Tibia maps with grid overlay without markers" P4
IntCmp $R0 1 0 notRunning
	MessageBox MB_OK|MB_ICONEXCLAMATION "Tibia is running. Please close it first." /SD IDOK
	goto end
notRunning: ; If Tibia isn’t running, start downloading the map files.
inetc::get "https://tibiamaps.io/downloads/minimap-with-grid-overlay-without-markers" "$pluginsdir\minimap.zip" /END
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
IfFileExists "$pluginsdir\minimap.zip" fileExist
Quit
fileExist:
IfFileExists "$LOCALAPPDATA\Tibia\packages\Tibia\minimap\*.*" folderExist
goto folderDontExist
folderExist:
DetailPrint "Removing old map files..."
DetailPrint "Deleting $LOCALAPPDATA\Tibia\packages\Tibia\minimap..."
RMDir /r "$LOCALAPPDATA\Tibia\packages\Tibia\minimap"
folderDontExist:
DetailPrint "Installing new map files..."
!insertmacro ZIPDLL_EXTRACT "$pluginsdir\minimap.zip" "$LOCALAPPDATA\Tibia\packages\Tibia" "<ALL>"
DetailPrint "Cleaning up temporary files..."
Delete "$pluginsdir\minimap.zip"
SectionEnd

; Startup checks and variables.
Function .onInit
Initpluginsdir ; Make sure `$pluginsdir` exists.
StrCpy $1 ${P1} ; The default.
; Size (KB) of uncompressed ZIP with marker data.
; unzip -l minimap-with-markers.zip | tail -n 1 | bytes_to_kilobytes
SectionSetSize ${P1} 5648
; Size (KB) of uncompressed ZIP without marker data.
; unzip -l minimap-without-markers.zip | tail -n 1 | bytes_to_kilobytes
SectionSetSize ${P2} 5588
; Size (KB) of uncompressed ZIP with grid overlay and marker data.
; unzip -l minimap-with-grid-overlay-and-markers.zip | tail -n 1 | bytes_to_kilobytes
SectionSetSize ${P3} 5701
; Size (KB) of uncompressed ZIP with grid overlay without marker data.
; unzip -l minimap-with-grid-overlay-without-markers.zip | tail -n 1 | bytes_to_kilobytes
SectionSetSize ${P4} 5641
FunctionEnd

; Ensure only a single checkbox can be checked at any time.
Function .onSelChange
!insertmacro StartRadioButtons $1
	!insertmacro RadioButton ${P1}
	!insertmacro RadioButton ${P2}
	!insertmacro RadioButton ${P3}
	!insertmacro RadioButton ${P4}
!insertmacro EndRadioButtons
FunctionEnd
