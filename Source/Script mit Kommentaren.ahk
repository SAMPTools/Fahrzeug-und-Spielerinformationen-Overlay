/*

Overlay by Konstantin Schütte (https://github.com/KonstantinSchuette)
Wenn du dieses Overlay veröffentlichst oder modifizierst, sei doch bitte so nett und erwähne meinen Namen in den Credits.

*/

/*
Wenn du hier die Kommentare weg machst, wirst du aufgefordert, das Overlay als Administrator auszuführen.
Dies kann zur stabilisierung und zu weniger Bugs seitens des Overlays führen.

if(!A_IsAdmin)
{
	MsgBox, 0, Info, Du musst den Keybinder als Administrator ausführen!`nDas Programm wird sich jetzt schließen.
	ExitApp
}
*/

SetWorkingDir, %A_ScriptDir%		;Gibt als "current working directory", den Dateipfad des Overlays an.

#NoEnv								;"It significantly improves performance whenever empty variables are used in an expression or command."
#SingleInstance, Force				;Sorgt dafür, dass die Anwendung nur einmal gestartet werden kann.
#include SAMP.ahk					;Fügt die SAMP-UDF hinzu.
#Include Overlay-API.ahk			;Fügt die Overlay-API hinzu.

DestroyAllVisual()					;Bereits bestehende Overlay-Elemente werden hier gelöscht.

global Overlay 			:= 0		;Das Overlay wird auf "noch nicht erstellt" eingestellt.
global VehicleText 		:= 0		;Die Fahrzeuginformationen werden auf "noch nicht erstellt" eingestellt.
global FontSizeText		:= 8		;Hier wird die FontSize/Text Größe, der Informationen, definiert.
global FontSizeTitel	:= 12		;Hier wird die FontSize/Text Größe, der Titel, definiert.

SetParam("use_window", "1")
SetParam("window", "GTA:SA:MP")		;Der SAMP Client wird als Ziel zur Erstellung des Overlays ausgewählt

while(1)
{
	if(WinActive("GTA:SA:MP") && IsSAMPAvailable()) ;Wenn SAMP gestartet, gerade gespielt wird und der Chat geladen ist, dann wird fortgefahren.
	{
		if(Overlay == 0) 			;Wenn die TextLabel noch nicht erstellt wurden, werden diese hier erstellt
		{
			PlayerBox := BoxCreate(648, 215, 153, 188, 0xAA000000, 1)
			CarBox := BoxCreate(648, 408, 153, 130, 0xAA000000, 0)
			
			PlayerTitel := "Spieler"
			PlayerTitelText := TextCreate("Geneva", FontSizeTitel, 1, 0, 704, 219, 0xFFFFFFFF, "", 1, 1)
			TextSetString(PlayerTitelText, PlayerTitel)
			PlayerInfo := TextCreate("Geneva", FontSizeText, 1, 0, 662, 243, 0xFFFFFFFF, "", 1, 1)
			
			VehicleTitel := "Fahrzeug"
			VehicleTitelText := TextCreate("Geneva", FontSizeTitel, 1, 0, 698, 412, 0xFFFFFFFF, "", 1, 1)
			TextSetString(VehicleTitelText, VehicleTitel)
			CarInfo := TextCreate("Geneva", FontSizeText, 1, 0, 662, 436, 0xFFFFFFFF, "", 1, 1)
			TextSetShown(VehicleTitelText, 0)
			
			Overlay := 1			;Setzt den Status, des Overlays, auf "wurde erstellt".
		}
		
		PlyInfoStr := "{FFFFFF}Name: {B0B0B0}" GetUsername() " (" "ID: " GetID() ")`n"
		PlyInfoStr .= "{FFFFFF}Level: {B0B0B0}" GetPlayerScoreByID(GetID()) "`n"
		PlyInfoStr .= "{FFFFFF}Ping: {B0B0B0}" GetPlayerPingById(GetID()) "`n"
		PlyInfoStr .= "{FFFFFF}Leben: {B0B0B0}" GetPlayerHealth() "`n"
		PlyInfoStr .= "{FFFFFF}Ruestung: {B0B0B0}" GetPlayerArmor() "`n"
		PlyInfoStr .= "{FFFFFF}Waffe: {B0B0B0}" GetPlayerWeaponName() " (" "ID: " GetPlayerWeaponId() ")`n"
		PlyInfoStr .= "{FFFFFF}Geld: {B0B0B0}" GetPlayerMoney() "$`n"
		PlyInfoStr .= "{FFFFFF}Skin-Id: {B0B0B0}" GetPlayerSkinId() "`n"
		PlyInfoStr .= "{FFFFFF}Interior-Id: {B0B0B0}" GetPlayerInteriorId() "`n"
		PlyInfoStr .= "{FFFFFF}Stadt: {B0B0B0}" GetPlayerCity() "`n"
		PlyInfoStr .= "{FFFFFF}Stadtteil: {B0B0B0}" GetPlayerZone() "`n"
		PlyInfoStr .= "{FFFFFF}FPS: {B0B0B0}" GetFrameRate() "`n"
		TextSetString(PlayerInfo, PlyInfoStr)
		
		if(isPlayerInAnyVehicle()) ;Wenn sich der Spieler in einem Auto befindet, werden die Informationen des Autos ausgelesen und in einen String gepackt.
		{
			CarInfoStr := "{FFFFFF}Auto: {B0B0B0}" GetVehicleModelName() " (ID: " GetVehicleModelId() ")`n"
			
			if(getVehicleType() == 1)
				CarInfoStr .= "{FFFFFF}Typ: {B0B0B0} Auto`n"
			if(getVehicleType() == 2)
				CarInfoStr .= "{FFFFFF}Typ: {B0B0B0} Boot`n"
			if(getVehicleType() == 3)
				CarInfoStr .= "{FFFFFF}Typ: {B0B0B0} Zug`n"
			if(getVehicleType() == 4)
				CarInfoStr .= "{FFFFFF}Typ: {B0B0B0} Motorrad`n"
			if(getVehicleType() == 5)
				CarInfoStr .= "{FFFFFF}Typ: {B0B0B0} Flugzeug`n"
			if(getVehicleType() == 6)
				CarInfoStr .= "{FFFFFF}Typ: {B0B0B0} Fahrrad`n"
			
			;CarInfoStr .= "{FFFFFF}Color 1: {B0B0B0}" GetVehicleColor1()"`n"
			;CarInfoStr .= "{FFFFFF}Color 2: {B0B0B0}" GetVehicleColor2()"`n" Die beiden Funktionen funktionieren einfach nicht richtig. Wenn man mit dem Auto fährt, ändert sich der Wert der Farbe auf -223342341, oder so.				
			
			if(GetVehicleEngineState() == 0)
				CarInfoStr .= "{FFFFFF}Motor:{8C8C8C} {D50000}Ausgeschaltet{D50000}`n"
			if(GetVehicleEngineState() == 1)
				CarInfoStr .= "{FFFFFF}Motor:{8C8C8C} {36F840}Eingeschaltet{36F840}`n"
			if(GetVehicleLightState() == 0)
				CarInfoStr .= "{FFFFFF}Licht:{8C8C8C} {D50000}Ausgeschaltet{D50000}`n"
			if(GetVehicleLightState() == 1)
				CarInfoStr .= "{FFFFFF}Licht:{8C8C8C} {36F840}Eingeschaltet{36F840}`n"
			if(GetVehicleLockState() == 1)
				CarInfoStr .= "{FFFFFF}Schloss:{8C8C8C} {36F840}Abgeschlossen{36F840}`n"
			if(GetVehicleLockState() == 0)
				CarInfoStr .= "{FFFFFF}Schloss:{8C8C8C} {D50000}Aufgeschlossen{D50000}`n"
			CarInfoStr .= "{FFFFFF}Zustand:{B0B0B0} " GetVehicleHealth() "`n"
			CarInfoStr .= "{FFFFFF}Geschwindigkeit:{B0B0B0} " Round(GetVehicleSpeed()) " KM/H`n"
			
			if(VehicleText) ;Wenn das TextLabel für das Fahrzeug bereits erstellt worden ist, dann wird nur der Text aktualisiert.
			{
				TextSetString(CarInfo, CarInfoStr)
			}
			else 			;Wenn das TextLabel für das Fahrzeug noch nicht erstellt worden ist, dann wird die schwarze Box sichtbar gemacht, die Texte aktualisiert und ebenfalls sichtbar gemacht.
			{
				BoxSetShown(CarBox, 1)
				TextSetString(CarInfo, CarInfoStr)
				TextSetShown(CarInfo, 1)
				TextSetShown(VehicleTitelText, 1)
				VehicleText := 1
			}
		}
		else if(isPlayerInAnyVehicle() == 0 && VehicleText == 1) ;Wenn sich der Spieler in keinem Fahrzeug befindet, wird der Text und die Box unsichtbar gemacht. Vorausgesetzt der Text wurde bereits erstellt.
		{
			BoxSetShown(CarBox, 0)
			TextSetShown(CarInfo, 0)
			TextSetShown(VehicleTitelText, 0)
			VehicleText := 0
		}
	}
	else 			;Wenn GTA nicht offen ist, oder gerade gespielt wird, oder der Chat noch nicht geladen ist, wird gecheckt, ob das Overlay bereits erstellt worden ist.
	{
		if(Overlay) ;Wenn das Overlay bereits erstellt worden ist, wird es hier gelöscht und der Status auf "noch nicht erstellt" eingestellt.
		{
			DestroyAllVisual()
			Overlay := 0
			VehicleText := 0
		}
	}
	Sleep, 1 		;Verringert die Ressourcennutzung des Prozessors deutlich (Ohne Sleep, ~5%, mit 0-0.1% Auslastung des Prozessors).
}

;Wenn ein GUI hinzugefügt wird und man auf das "X" drückt, wird das bestehende Overlay gelöscht und die Anwendung beendet sich.
GuiClose:
DestroyAllVisual()
ExitApp
return

;Wird die Anwendung geschlossen, dann wird das Overlay gelöscht(funktioniert aber nur teilweise).
ExitApp:
DestroyAllVisual()
ExitApp
return

;Mit der Taste "Numpad0" lassen sich die Texte von "Spieler" und "Fahrzeug" auf die Größe "8" stellen.
Numpad0::
FontSizeText := 8	;Größe "8" ist bereits die standart Größe
TextUpdate(PlayerInfo, "Geneva", FontSizeText, 1, 0)
TextUpdate(CarInfo, "Geneva", FontSizeText, 1, 0)
return

;Mit der Taste "Numpad1" lassen sich die Texte von "Spieler" und "Fahrzeug" auf die Größe "7" stellen.
Numpad1::
FontSizeText := 7	;Größe "7" macht die Font um eine Größe kleiner.
TextUpdate(PlayerInfo, "Geneva", FontSizeText, 1, 0)
TextUpdate(CarInfo, "Geneva", FontSizeText, 1, 0)
return
