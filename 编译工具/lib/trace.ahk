;~ ������ʾ�İ�װ����
Trace(aText = "", isDie = "", aTitle = "")
{
	;~ ��������,�����˳�
	if (isDie = 1)
	{
		if ( aTitle = "" )
		{
			aTitle := "�������� `! 30����˳�����"
		}
		Suspend , On
		MsgBox, 16, %aTitle%, %aText%, 30
		ExitApp
	}
	;~ ���ʶԻ���,���ݵ����ť��������1��0
	else if (isDie = 2)
	{
		if ( aTitle = "" )
		{
			aTitle := "����"
		}
		Suspend , On
		MsgBox, 36, %aTitle%, %aText%
		Suspend, off
		IfMsgBox  yes
		{
			return true
		}
		else
		{
			return false
		}
	}
	;~ ��ʾ�Ի���,ֻ��һ��ȷ����ť
	else if (isDie = 3)
	{
		if ( aTitle = "" )
		{
			aTitle := "ע��"
		}
		Suspend , On
		MsgBox, 0, %aTitle%, %aText%
		Suspend, off
		return true
	}
	else
	{
		if ( aTitle = "" )
		{
			aTitle := "��ע��"
		}
		TrayTip, %aTitle%, %aText%, 10, 1
		return true
	}
}