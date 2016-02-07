;~ https://msdn.microsoft.com/en-us/library/windows/desktop/dd374085(v=vs.85).aspx
Include_CpTransform()
{
   return true
}

;~ ANSI ������
;~ ���ֱ����ʽ���ļ�����ת��
;~ ����: aToFile - ���ձ�ʾ�滻 aInFile.
;~ 		aInCp, aToCp - ������������������:
			;~ a - ��ʾ: ANSI
			;~ u - ��ʾ: UTF-8
			;~ b - ��ʾ: UTF-8 + BOM
;~ �쳣:
	;~ > ��������
	;~ > �ļ���дɾ����
	
File_CpTransform(aInFile, aInCp, aToCp, aToFile = "")
{
	if !(FileExist(aInFile))
	|| (aInCp = aToCp)
	|| (aInCp ~= "i)[^aub]")
	|| (aToCp ~= "i)[^aub]")
	{

		throw, {Message:	"��������"
				,What  :	(A_ThisLabel ? A_ThisLabel : A_ThisFunc)
				,File  :	A_LineFile
				,Line  :	A_LineNumber}
		return
	}

	if (!aToFile)
	{
		aToFile := aInFile
	}

	_content := fc_FileRead(aInFile)
	if (ErrorLevel)
	{

		throw, {Message:	"��ȡ�ļ�����"
				,What  :	(A_ThisLabel ? A_ThisLabel : A_ThisFunc)
				,File  :	A_LineFile
				,Line  :	A_LineNumber}
		return
	}

	try
	{
		;~ ANSI
		if (aInCp = "a")
		{
			;~ ansi to utf-8
			if (aToCp = "u")
			{
				_content := Ansi2UTF8(_content)
				if (FileExist(aToFile))
				{
					FileDelete, % aToFile					
				}
				
				FileAppend, %_content%, % aToFile
			}
			;~ ansi to utf-8 + BOM
			else if (aToCp = "b")
			{
				if (FileExist(aToFile))
				{
					FileDelete, % aToFile					
				}
				
				FileAppend, %_content%, % aToFile, UTF-8
			}
		}
		;~ utf-8
		else if (aInCp = "u")
		{
			;~ utf-8 to ansi
			if (aToCp = "a")
			{
				_content := UTF82Ansi(_content)
				
				if (FileExist(aToFile))
				{
					FileDelete, % aToFile					
				}
				
				FileAppend, %_content%, % aToFile
			}
			;~ utf-8 to utf-8 + BOM
			else if (aToCp = "b")
			{
				_content := Unicode2UTF8(_content)
				
				if (FileExist(aToFile))
				{
					FileDelete, % aToFile					
				}
				
				FileAppend, %_content%, % aToFile, UTF-8
			}
		}
		;~ utf-8 + BOM
		else if (aInCp = "b")
		{
			;~ utf-8 + BOM to ansi
			if (aToCp = "a")
			{				
				if (FileExist(aToFile))
				{
					FileDelete, % aToFile					
				}
				
				FileAppend, %_content%, % aToFile, CP936
			}
			;~ utf-8 + BOM to utf-8
			else if (aToCp = "u")
			{
				_content := Ansi2UTF8(_content)
				
				if (FileExist(aToFile))
				{
					FileDelete, % aToFile					
				}
				
				FileAppend, %_content%, % aToFile
			}
		}
		else
			return
	}
	catch, _err
	{
		Debug("Error`:"
		. "`nMessage `:`n"	_err.Message
		. "`nWhat    `:`n"	_err.What
		. "`nFile    `:`n"	_err.File
		. "`nLine    `:`n"	_err.Line)
		return
	}
	return true
}

;~ �� ANSI ���ַ���ת��Ϊ utf8 no BOM ���ַ���
;~ ע��,���Ҫ�����������ص��ַ���д���ı�,
;~ *** ������д��ʱ���� Encoding ����. ***
Ansi2UTF8(sString)
{
   Ansi2Unicode(sString, wString, 0)
   Unicode2Ansi(wString, zString, 65001)
   Return zString
}

;~ �� ANSI ���ַ���ת��Ϊ utf8 + BOM ���ַ���,
;~ ע��,���Ҫ�����������ص��ַ���д���ı�,
;~ *** ������д��ʱָ�� Encoding Ϊ UTF-8 (�� CP65001). ***
Ansi2UTF8_plus(aStr)
{
   _uStr := Ansi2UTF8(aStr)
   Unicode2UTF8(_uStr)
   return _uStr
}

;~ �� UTF8 no BOM ���ַ���ת��Ϊ ANSI ���ַ���
UTF82Ansi(zString)
{
   Ansi2Unicode(zString, wString, 65001)
   Unicode2Ansi(wString, sString, 0)
   Return sString
}

;~ �� UTF8 no BOM ���ַ���ת��Ϊ UTF8 + BOM ���ַ���
Unicode2UTF8(aUStr)
{
   ;~ ���ݼ�����
   _clipBak := ClipboardAll
   Clipboard := ""
   if (aUStr)
   {
	  try
	  {
		 ;~ �� Unicode �ַ��ڼ�������ת��һ��
		 Transform, Clipboard, Unicode, %aUStr%
	  }
	  catch, _err
	  {
		 Debug("Error`:"
			. "`nMessage `:`n"	_err.Message
			. "`nWhat    `:`n"	_err.What
			. "`nFile    `:`n"	_err.File
			. "`nLine    `:`n"	_err.Line)
		 return
	  }
   }
   _UStr := Clipboard
   ;~ ��ԭ������
   Clipboard := _clipBak
   return _UStr
}

;~ �� ANSI ���ַ���ת��Ϊ Unicode ���ַ���
;~ https://msdn.microsoft.com/en-us/library/windows/desktop/dd319072(v=vs.85).aspx
Ansi2Unicode(ByRef sString, ByRef wString, CP = 0)
{
   nSize := DllCall("MultiByteToWideChar"
	  , "Uint", CP
	  , "Uint", 0
	  , "Uint", &sString
	  , "int", -1
	  , "Uint", 0
	  , "int", 0)
   VarSetCapacity(wString, nSize * 2)
   DllCall("MultiByteToWideChar"
	  , "Uint", CP
	  , "Uint", 0
	  , "Uint", &sString
	  , "int", -1
	  , "Uint", &wString
	  , "int", nSize)
}

;~ �� Unicode ���ַ���ת��Ϊ ANSI ���ַ���
;~ https://msdn.microsoft.com/en-us/library/windows/desktop/dd374130(v=vs.85).aspx
Unicode2Ansi(ByRef wString, ByRef sString, CP = 0)
{
   nSize := DllCall("WideCharToMultiByte"
	  , "Uint", CP
	  , "Uint", 0
	  , "Uint", &wString
	  , "int", -1
	  , "Uint", 0
	  , "int", 0
	  , "Uint", 0
	  , "Uint", 0)
   VarSetCapacity(sString, nSize)
   DllCall("WideCharToMultiByte"
	  , "Uint", CP
	  , "Uint", 0
	  , "Uint", &wString
	  , "int", -1
	  , "str", sString
	  , "int", nSize
	  , "Uint", 0
	  , "Uint", 0)
}