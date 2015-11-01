#NoEnv
#Warn
#Warn, LocalSameAsGlobal, Off
#Warn, UseUnsetLocal, Off

Include_Functions()
Include_CpTransform()

delHead()

ExitApp
return

delHead()
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
      
      _newContent := ""      
      
      ;~ ��������
      loop, Parse, % content, `n, `r
      {
         _line := A_LoopField
         
         if (A_Index = 6)
         || (A_Index = 7)
         {
            if (_line ~= "i)charset=iso-8859-1")
            {
               _line := RegExReplace(_line,"charset=iso-8859-1","charset=GB2312")
            }
         }
         else if (A_Index = 9)
         || (A_Index = 10)
         {
            if (_line ~= "^<script.*jquery")
            {
               continue
            }
         }
         
         _newContent .= _line "`n"
      }
      ;~ ɾ�����Ļ��з�
      _newContent := SubStr(_newContent, 1 , -1)
      FileAppend, % _newContent, % A_LoopFileFullPath
      ToolTip, %A_Index% %A_LoopFileFullPath% ���
   }
   Trace("�滻ͷ�����", 3)
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
