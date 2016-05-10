;中文版帮助使用官方脚本编译，部分文件做了调整（文件编码处理）
;须使用AHK 32位版本生成帮助文件，需预先安装Microsoft HTML Help Workshop
;
;	Project.hhp				CHM帮助的工程文件，已更改语言为中文
;	+ \docs\static\source	生成CHM帮助所需的目录文件hhc、索引文件hhk的脚本
;	- CreateFiles4Help.ahk	生成上述文件的AHK脚本，实际生成由JS完成
;							更改其编码方式为CP936，而不是UTF-8
;	- data_index.js			索引文件hhk的数据源，可汉化
;	- data_toc.js			目录文件hhk的数据源，已汉化
;	- main.js				实际生成上述文件的JS脚本
;
if (A_PtrSize = 8) {
    try
        RunWait "%A_AhkPath%\..\AutoHotkeyU32.exe" "%A_ScriptFullPath%"
    catch
        MsgBox 16,, This script must be run with AutoHotkey 32-bit, due to use of the ScriptControl COM component.
    ExitApp
}

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