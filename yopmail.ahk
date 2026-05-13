#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

greetings := ["yopmail.com"]

F2::    
        Send, ^t
		Sleep 200
        Random, r, 1, greetings.Length()
        SendInput, % greetings[r]
		Sleep 200
		Send, %greetings%{Enter}
return