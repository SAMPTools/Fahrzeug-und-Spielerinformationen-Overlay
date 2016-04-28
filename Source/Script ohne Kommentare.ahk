/*

Overlay by Konstantin Schütte (https://github.com/KonstantinSchuette)
Wenn du dieses Overlay veröffentlichst oder modifizierst, sei doch bitte so nett und erwähne meinen Namen in den Credits.

*/

/*
if(!A_IsAdmin)
{
	MsgBox, 0, Info, Du musst den Keybinder als Administrator ausführen!`nDas Programm wird sich jetzt schließen.
	ExitApp
}
*/

SetWorkingDir, %A_ScriptDir%

#NoEnv
#SingleInstance, Force
#include SAMP.ahk
#Include Overlay-API.ahk

DestroyAllVisual()

global Overlay 			:= 0
global VehicleText 		:= 0
global FontSizeText		:= 8
global FontSizeTitel	:= 12

SetParam("use_window", "1")
SetParam("window", "GTA:SA:MP")

while(1)
{
	if(WinActive("GTA:SA:MP") && IsSAMPAvailable())
	{
		if(Overlay == 0)
		{
			PlayerBox := BoxCreate(648, 215, 153, 188, 0xAA000000, 1)
			CarBox := BoxCreate(648, 408, 153, 153, 0xAA000000, 0)
			
			PlayerTitel := "Spieler"
			PlayerTitelText := TextCreate("Geneva", FontSizeTitel, 1, 0, 704, 219, 0xFFFFFFFF, "", 1, 1)
			TextSetString(PlayerTitelText, PlayerTitel)
			PlayerInfo := TextCreate("Geneva", FontSizeText, 1, 0, 662, 243, 0xFFFFFFFF, "", 1, 1)
			
			VehicleTitel := "Fahrzeug"
			VehicleTitelText := TextCreate("Geneva", FontSizeTitel, 1, 0, 698, 412, 0xFFFFFFFF, "", 1, 1)
			TextSetString(VehicleTitelText, VehicleTitel)
			CarInfo := TextCreate("Geneva", FontSizeText, 1, 0, 662, 436, 0xFFFFFFFF, "", 1, 1)
			TextSetShown(VehicleTitelText, 0)
			
			Overlay := 1
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
		
		if(isPlayerInAnyVehicle())
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
			
			CarInfoStr .= "{FFFFFF}Color 1: {B0B0B0}" GetVehicleColor1()"`n"
			CarInfoStr .= "{FFFFFF}Color 2: {B0B0B0}" GetVehicleColor2()"`n"				
			
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
			
			if(VehicleText)
			{
				TextSetString(CarInfo, CarInfoStr)
			}
			else
			{
				BoxSetShown(CarBox, 1)
				TextSetString(CarInfo, CarInfoStr)
				TextSetShown(CarInfo, 1)
				TextSetShown(VehicleTitelText, 1)
				VehicleText := 1
			}
		}
		else if(isPlayerInAnyVehicle() == 0 && VehicleText == 1)
		{
			BoxSetShown(CarBox, 0)
			TextSetShown(CarInfo, 0)
			TextSetShown(VehicleTitelText, 0)
			VehicleText := 0
		}
	}
	else
	{
		if(Overlay)
		{
			DestroyAllVisual()
			Overlay := 0
			VehicleText := 0
		}
	}
	Sleep, 1
}

GuiClose:
DestroyAllVisual()
ExitApp
return

ExitApp:
DestroyAllVisual()
ExitApp
return

Numpad0::
FontSizeText := 8
TextUpdate(PlayerInfo, "Geneva", FontSizeText, 1, 0)
TextUpdate(CarInfo, "Geneva", FontSizeText, 1, 0)
return

Numpad1::
FontSizeText := 7
TextUpdate(PlayerInfo, "Geneva", FontSizeText, 1, 0)
TextUpdate(CarInfo, "Geneva", FontSizeText, 1, 0)
return
