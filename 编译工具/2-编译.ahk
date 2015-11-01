#NoEnv
#Warn
#Warn, LocalSameAsGlobal, Off
#Warn, UseUnsetLocal, Off

Include_Functions()
Include_CpTransform()

;~ 删除已经存在的输出文件 AutoHotkey.chm
if (FileExist("AutoHotkey.chm"))
{    
    FileDelete, AutoHotkey.chm
}

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
return

go_change1()
{
   ;~ 新版的js引用位置变化
   _replaceStr1 =
   (`"
   static/jquery.js" type="text/javascript"></script>
   )

   _replaceStr2=
   (`"
   static/tree.jquery.js" type="text/javascript"></script>
   )

   Loop, %A_ScriptDir%\*.htm, , 1
   {
       FileRead, content, % A_LoopFileFullPath
       FileDelete, % A_LoopFileFullPath

      _newContent := ""
      Loop, parse, content, `n, `r
      {
         _line := Trim(A_LoopField)
         if (A_Index < 20)
         && ((_line ~= _replaceStr1) || (_line ~= _replaceStr2))
         {
            continue
         }
         _newContent .= A_LoopField "`n"
      }
      
      ;~ 删除最后的换行符
      _newContent := SubStr(_newContent, 1 , -1)
      
      FileAppend, % _newContent, % A_LoopFileFullPath
   }
   Trace("第一步完成")
   Sleep, 500
   return
}

Convert_cp_4chinese()
{
   Loop, %A_ScriptDir%\*.htm, , 1
   {
       _fEncoding := Unicode_GetFileEncoding(A_LoopFileFullPath)
       
      ;~ utf8+bom,需要改为 utf8 no bom
      if (_fEncoding = 4)
      {
          File_CpTransform(A_LoopFileFullPath, "b", "a")
      }
      ;~ ansi,需要改为utf8 no bom
      else if (_fEncoding = 1)
      {
         ;~ Debug(A_LineFile "`nline`: " A_LineNumber "`nFunc`:" A_ThisFunc "`n`n"
         ;~ . A_LoopFileFullPath)
         
          ;~ File_CpTransform(A_LoopFileFullPath, "a", "b")
      }
      ;~ utf8 no bom,改为ANSI
      else if (_fEncoding = 6)
      {
          File_CpTransform(A_LoopFileFullPath, "u", "a")
         
      }
      
      FileRead, content, % A_LoopFileFullPath
      FileDelete, % A_LoopFileFullPath
      FileAppend, % RegExReplace(content,"charset=iso-8859-1","charset=GB2312"), % A_LoopFileFullPath
   }
   Trace("第二步完成")
   Sleep, 500
   return
}