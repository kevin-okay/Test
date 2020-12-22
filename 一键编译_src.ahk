#NoEnv
#Warn, UseUnsetGlobal, StdOut
#Warn, LocalSameAsGlobal, StdOut
#Warn, UseUnsetLocal, Off
#Include %A_ScriptDir%
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
ListLines Off

global Gs_Author := "Fonny"
, Gs_ConfigFile := path_replaceExtName(A_ScriptName, "ini")
, Gv_logFile := "_dbglog.txt"
, Gs_DebugLevel := 3

main()
return

_main()
{
	
   SYS_FixHeadAndTransCp()
   SYS_Convert()
   return
}

SYS_FixHeadAndTransCp()
{
   Loop, %A_ScriptDir%\*.htm, , 1
   {
      _newContent := ""

      ;~ 解析内容
      loop, Parse, % content, `n, `r
      {
         _line := A_LoopField

         if (A_Index < 10)
         {
            if (_line ~= "i)\<meta.+?iso-8859-1")
            {
               _line := RegExReplace(_line, "i)iso-8859-1", "gb2312")
            }
            if (_line ~= "i)\<meta.+?UTF-8")
            {
               _line := RegExReplace(_line, "i)UTF-8", "gb2312")
            }
         }
         _newContent .= _line "`n"
      }
      
      ;~ 删除最后的换行符
      _newContent := SubStr(_newContent, 1 , -1)
      
      FileAppend, % _newContent, % A_LoopFileFullPath
      FileCodepage_TransTo(A_LoopFileFullPath, 936)
      
      ToolTip, %A_Index% %A_LoopFileFullPath% 完成
   }
   
   Trace("替换头部完成")
   return
}

SYS_Convert()
{
   ;~ 删除已经存在的输出文件 AutoHotkey.chm
   if (FileExist("AutoHotkey.chm"))
   {
      FileDelete, AutoHotkey.chm
   }

   FileCopy, _forReplace\main.js, docs\static\source\, 1
   FileCopy, _forReplace\data_index.js, docs\static\source\, 1
   FileCopy, _forReplace\data_toc.js, docs\static\source\, 1
   FileCopy, _forReplace\data_translate.js, docs\static\source\, 1
   FileCopy, _forReplace\CreateFiles4Help.ahk, docs\static\source\, 1
   FileCopy, _forReplace\Index.hhk, %A_ScriptDir%, 1
   FileCopy, _forReplace\Project.hhp, %A_ScriptDir%, 1
   FileCopy, _forReplace\Table of Contents.hhc, %A_ScriptDir%, 1

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
   ;~ RunWait "%A_AhkPath%" source\CreateFiles4Help.ahk
   _cmd := fsys_JoinPath(A_ScriptDir, "docs\static\source\CreateFiles4Help.ahk")
   RunWait, % _cmd
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

   FileDelete, %A_ScriptDir%\docs\static\source\CreateFiles4Help.ahk
   FileDelete, %A_ScriptDir%\docs\static\source\data_index.js
   FileDelete, %A_ScriptDir%\docs\static\source\data_toc.js
   FileDelete, %A_ScriptDir%\docs\static\source\data_translate.js
   FileDelete, %A_ScriptDir%\docs\static\source\main.js
   
   ;~ 2020-12-23 修复内容拼接时数组自动排序导致目录顺序被改变的问题
   FileCopy, content.js, %A_ScriptDir%\_forReplace\, 1
   FileCopy, content.chm.js, %A_ScriptDir%\_forReplace\, 1
   return
}

main()
{
   try
      _main()
   catch , _err
      Debug(A_ThisFunc ? A_ThisFunc : A_ThisLabel, A_LineFile, A_LineNumber, _err)
}
