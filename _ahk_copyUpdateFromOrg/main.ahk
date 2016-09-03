#NoEnv
#Warn
#Warn, LocalSameAsGlobal, Off
#Warn, UseUnsetLocal, Off
#Include %A_ScriptDir%

SetWorkingDir, %A_ScriptDir%

global Gs_IsDebug := true
, Gs_Version := 0.1
, Gs_Author := "Fonny"
, Gs_Public := "2016"
, Gs_Option_ini := SubStr(A_ScriptName, 1, -3) "ini"

global Gv_updateListFile := "_updateFiles.txt"
, Gv_OrgFilesRootPath := "z:\ahk_docs_translate\en"

fsys_include()
main()
return

main()
{
	Trace(sys_getUpdateFilesPath(), 3)
}

sys_getUpdateFilesPath()
{
	_content := fc_FileRead(Gv_updateListFile)
	loop, Parse, % _content, `n, `r
	{
		if (! _line := Trim(A_LoopField))
		{
			continue
		}
		
		if (A_Index == 1)
		&& (_line ~= "__allUpdated")
		{
			return "无需更新"
		}
		
		_sFile := fsys.joinPath(Gv_OrgFilesRootPath, _line)
		_dFile := fsys.joinPath(fsys.getLongPath(A_ScriptDir "\..\"), _line)
		
		if (! FileExist(_sFile))
		{
			Debug(A_LineFile "`nFunc `: " A_ThisFunc "`nLine : " A_LineNumber "`n"
			. "`n" "找不到文件:"
			. "`n" _sFile
			. "")
			return 0
		}
		
		if (! FileExist(_dFile))
		{
			;~ 目录存在也可以
			if (! FileExist(fsys.getLongPath(_dFile "\..\")))
			{	
				Debug(A_LineFile "`nFunc `: " A_ThisFunc "`nLine : " A_LineNumber "`n"
				. "`n" "找不到文件:"
				. "`n" _dFile
				. "")
				return 0
			}
		}
		FileCopy, % _sFile, % _dFile, 1
	}
	return "done"
}