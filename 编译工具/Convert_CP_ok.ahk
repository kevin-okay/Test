#NoEnv
#Warn
#Warn, LocalSameAsGlobal, Off
#Warn, UseUnsetLocal, StdOut

Include_Functions()
Include_CpTransform()

if (gv_us := fc_InputBox("","1 第一步是翻译之前的同步`n2 第二步是编译CHM之前的准备"))
{
   if (gv_us = 1)
   {
      go_change1()
   }
   else
   {
      go_change2()
   }
}

ExitApp
return

go_change2()
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
