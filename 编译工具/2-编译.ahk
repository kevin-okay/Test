#NoEnv
#Warn
#Warn, LocalSameAsGlobal, Off
#Warn, UseUnsetLocal, Off

Include_CpTransform()
SetWorkingDir, %A_ScriptDir%

;~ ɾ���Ѿ����ڵ�����ļ� AutoHotkey.chm
if (FileExist("AutoHotkey.chm"))
{    
   FileDelete, AutoHotkey.chm
}

FileCopy, _forReplace\Index.hhk, %A_ScriptDir%, 1
FileCopy, _forReplace\Project.hhp, %A_ScriptDir%, 1
FileCopy, _forReplace\Table of Contents.hhc, %A_ScriptDir%, 1
;~ go_change1()
;~ Convert_cp_4chinese()

; Change this path if the loop below doesn't find your hhc.exe,
; or leave it as-is if hhc.exe is somewhere in %PATH%.
hhc := "hhc.exe"

; Try to find hhc.exe, since it's not in %PATH% by default.
for i, env_var in ["ProgramFiles", "ProgramFiles(x86)", "ProgramW6432"]
{
    EnvGet Programs, %env_var%
    if (Programs && FileExist(checking := Programs "\HTML Help Workshop\hhc.exe"))
    {
        hhc := checking
        break
    }
}

SetWorkingDir %A_ScriptDir%\docs\static

; Rebuild Index.hhk and Table of Contents.hhc.
RunWait "%A_AhkPath%" source\CreateFiles4Help.ahk
FileMove content.js, content.temp.js, 1
FileMove content.chm.js, content.js

; Compile AutoHotkey.chm.
RunWait %hhc% "%A_ScriptDir%\Project.hhp"

; Put it back so that local viewing works.
FileMove content.js, content.chm.js
FileMove content.temp.js, content.js

FileDelete, %A_ScriptDir%\Index.hhk
FileDelete, %A_ScriptDir%\Project.hhp
FileDelete, %A_ScriptDir%\Table of Contents.hhc
return