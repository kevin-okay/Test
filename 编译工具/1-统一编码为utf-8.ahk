#NoEnv
#Warn
#Warn, LocalSameAsGlobal, Off
#Warn, UseUnsetLocal, Off

Include_CpTransform()
delHead()

SetWorkingDir, %A_ScriptDir%
FileCopy, _forReplace\content.js, docs\static\, 1
FileCopy, _forReplace\content.chm.js, docs\static\, 1
FileCopy, _forReplace\CreateFiles4Help.ahk, docs\static\source\, 1
FileCopy, _forReplace\Index.hhk, %A_ScriptDir%, 1
FileCopy, _forReplace\Project.hhp, %A_ScriptDir%, 1
FileCopy, _forReplace\Table of Contents.hhc, %A_ScriptDir%, 1
ExitApp
return

delHead()
{
   Loop, %A_ScriptDir%\*.htm, , 1
   {
      _fEncoding := File_GetEncoding(A_LoopFileFullPath)

      ;~ a to u
      if (_fEncoding = 1)
      {
         File_CpTransform(A_LoopFileFullPath, "a", "b")
      }
      ;~ u to b
      else if (_fEncoding = 6)
      {
         File_CpTransform(A_LoopFileFullPath, "u", "b")
      }

      FileRead, content, % A_LoopFileFullPath
      FileDelete, % A_LoopFileFullPath

      _newContent := ""

      ;~ ��������
      loop, Parse, % content, `n, `r
      {
         _line := A_LoopField

         if (A_Index < 10)
         {
            if (_line ~= "i)\<meta.+?iso-8859-1")
            {
               _line := RegExReplace(_line, "i)iso-8859-1", "UTF-8")
            }
            if (_line ~= "i)\<meta.+?gb2312")
            {
               _line := RegExReplace(_line, "i)gb2312", "UTF-8")
            }
         }
         _newContent .= _line "`n"
      }
      ;~ ɾ�����Ļ��з�
      _newContent := SubStr(_newContent, 1 , -1)
      FileAppend, % _newContent, % A_LoopFileFullPath, cp65001
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
