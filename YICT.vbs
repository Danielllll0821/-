#$language = "VBScript"
#$interface = "1.0"

Sub Main
    '�򿪱����豸�����ַ�Լ�������ļ�
    Const ForReading = 1, ForWriting = 2, ForAppending = 8
    Dim fso,file1,line,logfile,params,ipaddr,username,password
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set file1 = fso.OpenTextFile("D:\YICT�������\�Զ�Ѳ��ű�\hostlist.txt",Forreading, False)    
    crt.Screen.Synchronous = True
    DO While file1.AtEndOfStream <> True
       '����ÿ��
       line = file1.ReadLine
       '����ÿ�еĲ��� IP��ַ ���� En����
       params = Split (line)
	   ipaddr = params(0)
	   username = params(1)
	   password = params(2)
	   
	   
		
			'����Telnet_Login����
		Telnet_Login ipaddr,username,password
		crt.Screen.Send "show privilege" & vbCr
		crt.Screen.Send vbCr
		crt.Screen.Send "show ver | in uptime"
		outPut = crt.Screen.ReadString ("show ver | in uptime")
	
		if InStr(output,">")  Then
			PrivilegeLevel ">",ipaddr
			crt.Session.Disconnect
		Elseif InStr(outPut,"#") Then
			PrivilegeLevel "#",ipaddr
			crt.Session.Disconnect
		End if
	
	 	 
    loop
    crt.Screen.Synchronous = False
	'crt.Quit 	
End Sub

Function Telnet_Login(ipaddress,username,password)

	   'Telnet������豸��
        crt.Session.Connect "/TELNET " & ipaddress

	   '����telnet����
	    crt.Screen.WaitForString "Username:"
        crt.Screen.Send username & vbcr
        crt.Screen.WaitForString "Password:"
        crt.Screen.Send password & vbcr
       '����Ȩģʽ
       'crt.Screen.Send "enable" & vbcr
       'crt.Screen.WaitForString "Password:"
       'crt.Screen.Send params(3) & vbcr	
End Function





Function PrivilegeLevel(str1,ipaddress)
		 
       'crt.Screen.waitForString "#"
	   
	   '��"show run | in host" �Ľ������ȡ�û������������ļ���
	   crt.Screen.Send "show ver | in uptime" & vbCr 
	   Result = crt.Screen.ReadString(str1)

       'msgbox Result
	   
	   '��һ���û������ָ�������ȡhostname R1,���Ƿ��ص��������Ԫ�أ��޷����뵽�ļ����У���ҪMid�����ٴ���ȡ
	   strHN = Split(Result,vbCr)(1) 
       'msgbox strHN
	   '''msgbox Mid(Result, 21)
	   '''strHN = Split(Mid(Result, 21),vbCr)(1)	'��2�ַ�������Mid������ȡ������Split��ȡR1   
	   '''msgbox strHN
	   hn = Split(strHN)(0)
	   'msgbox hn	   
	   HN = Mid(hn,2)  '''hn�а������У���һ��Ϊ�գ����ǵڶ���ΪHOSTNAME�����ǵ�һ��Ҫռ��һ���ַ����ڶ��д�2��ʼ��
  	   'msgbox HN
	   
       '�����ļ����Ŀ¼���ļ������ļ����а�������
       logfile = "D:\YICT�������\�Զ�Ѳ��-Log\" & ipaddress & " " & HN & " .log"
	  
	   '������¼��־
	   crt.Session.LogFileName = logfile
	   crt.Session.Log(true) 	   
	   
	   SendCommand(str1)	 
End Function

Function SendCommand(str1)
	
	commands = Array("terminal length 0","show ver"," show env ala","show env stat","show process cpu ","show process memory","show module","show logging","show clock" ,"show ntp status")
	
	for each c in commands
		crt.Screen.Send c & vbCr 
		'crt.Sleep 1000
		crt.Screen.waitForString str1
	Next
	
End Function