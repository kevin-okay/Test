#NoEnv
#Warn
#Warn, LocalSameAsGlobal, Off
#Warn, UseUnsetLocal, StdOut

Include_Functions()
Include_CpTransform()

if (gv_us := fc_InputBox("","1 ��һ���Ƿ���֮ǰ��ͬ��`n2 �ڶ����Ǳ���CHM֮ǰ��׼��"))
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
       
      ;~ utf8+bom,��Ҫ��Ϊ utf8 no bom
      if (_fEncoding = 4)
      {
          File_CpTransform(A_LoopFileFullPath, "b", "a")
      }
      ;~ ansi,��Ҫ��Ϊutf8 no bom
      else if (_fEncoding = 1)
      {
         ;~ Debug(A_LineFile "`nline`: " A_LineNumber "`nFunc`:" A_ThisFunc "`n`n"
         ;~ . A_LoopFileFullPath)
         
          ;~ File_CpTransform(A_LoopFileFullPath, "a", "b")
      }
      ;~ utf8 no bom,��ΪANSI
      else if (_fEncoding = 6)
      {
          File_CpTransform(A_LoopFileFullPath, "u", "a")
         
      }
      
      FileRead, content, % A_LoopFileFullPath
      FileDelete, % A_LoopFileFullPath
      FileAppend, % RegExReplace(content,"charset=iso-8859-1","charset=GB2312"), % A_LoopFileFullPath
   }
   Trace("�ڶ������")
   Sleep, 500
   return
}

go_change1()
{
   ;~ �°��js����λ�ñ仯
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
      
      ;~ ɾ�����Ļ��з�
      _newContent := SubStr(_newContent, 1 , -1)
      
      FileAppend, % _newContent, % A_LoopFileFullPath
   }
   Trace("��һ�����")
   Sleep, 500
   return
}
