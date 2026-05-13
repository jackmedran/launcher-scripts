#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; =================== LOAD PATHS FROM FILE ===================
if !FileExist("path.txt") {
    MsgBox, ❌ ملف path.txt ما كاينش
    ExitApp
}

FileRead, pathContent, *P65001 path.txt
pathContent := StrReplace(pathContent, "`r")
lines := StrSplit(pathContent, "`n")

chromePath := Trim(lines[1])
chromeUser := Trim(lines[2])

if !FileExist(chromePath) {
    MsgBox, ❌ Chrome.exe ما لقيتوش:`n%chromePath%
    ExitApp
}

if !FileExist(chromeUser) {
    MsgBox, ❌ Chrome User Data path ما لقيتوش:`n%chromeUser%
    ExitApp
}

; =================== HOTKEY ===================
;F5::
prefixes := []
prefixStart := []
prefixEnd := []
proxyStartNumbers := []
InputBox, prefixCount, Prefixes, How many prefixes?
if ErrorLevel
    return
prefixCount := prefixCount + 0

Loop, %prefixCount%
{
    InputBox, pfx, Prefix Name, Enter name of Prefix #%A_Index%
    if ErrorLevel
        return
    prefixes.Push(Trim(pfx))

    InputBox, startP, Start Profile, Enter start profile number for "%pfx%"
    if ErrorLevel
        return
    prefixStart.Push(startP+0)

    InputBox, endP, End Profile, Enter end profile number for "%pfx%"
    if ErrorLevel
        return
    prefixEnd.Push(endP+0)

    InputBox, proxyInput, Proxy Start Profile, Enter profile number to start AutoAnyProxy for "%pfx%"`nLeave blank to disable
    if !ErrorLevel && proxyInput != ""
        proxyStartNumbers.Push(proxyInput+0)
    else
        proxyStartNumbers.Push("")
}

; =================== PROFILE LOOP ===================
for index, prefix in prefixes
{
        startProfile := prefixStart[index]
        endProfile := prefixEnd[index]
        proxyStartNumber := proxyStartNumbers[index]
  Loop, % (endProfile - startProfile + 1)
 {
    profNumber := startProfile + A_Index - 1
            userInput := prefix . profNumber
            profName := ""

            Loop, Files, % chromeUser "\*", D
            {
                folder := Trim(A_LoopFileName)
                folderComp := StrReplace(folder, " ")
                userComp := StrReplace(userInput, " ")
                StringLower, folderComp, folderComp
                StringLower, userComp, userComp

                if (folderComp = userComp)
                {
                    profName := folder
                    break
                }
            }

            if (profName = "")
                continue

            fullPath := chromeUser "\" profName
            if !FileExist(fullPath)
                continue

            count := 0

    Run, "%chromePath%" --profile-directory="%profName%" "https://mail.google.com"
    Sleep 1500
    WinWaitActive, ahk_exe chrome.exe
  ; ====== APPLY PROXY ONLY IF USER ENTERED A NUMBER ======
    if (proxyStartNumber != "" && profNumber >= proxyStartNumber)
    {
        ; Proxy logic only runs here
        ControlSend,, {Enter}, ahk_exe chrome.exe
        Sleep 1000
    }
	    Sleep 1500
}
}
    ExitApp
return

