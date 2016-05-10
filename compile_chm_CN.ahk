;���İ����ʹ�ùٷ��ű����룬�����ļ����˵������ļ����봦��
;��ʹ��AHK 32λ�汾���ɰ����ļ�����Ԥ�Ȱ�װMicrosoft HTML Help Workshop
;
;	Project.hhp				CHM�����Ĺ����ļ����Ѹ�������Ϊ����
;	+ \docs\static\source	����CHM���������Ŀ¼�ļ�hhc�������ļ�hhk�Ľű�
;	- CreateFiles4Help.ahk	���������ļ���AHK�ű���ʵ��������JS���
;							��������뷽ʽΪCP936��������UTF-8
;	- data_index.js			�����ļ�hhk������Դ���ɺ���
;	- data_toc.js			Ŀ¼�ļ�hhk������Դ���Ѻ���
;	- main.js				ʵ�����������ļ���JS�ű�
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