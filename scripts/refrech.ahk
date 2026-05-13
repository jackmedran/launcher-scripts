global windows := []

WinGet, id, List, ahk_exe chrome.exe

Loop, %id%
{
    windows.Push(id%A_Index%)
}

while (windows.Length() > 0)
{
    this_id := windows.RemoveAt(1) 
    
    WinActivate, ahk_id %this_id%
    Sleep, 500
	Send, {F5}
	if (ErrorLevel = 0)  ; If the dialog exists
    {
        WinActivate  ; Bring it to front
        Sleep, 200
        Send, {Enter}  ; Confirm leaving
    }
	Sleep, 500
}
return