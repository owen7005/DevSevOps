' Usage :
' netsh dhcp server show mibinfo | cscript //nologo DhcpReservStats.vbs.
' The invite must be locate at the vbs script location & it must be run on the dhcp server

Set oRe=New RegExp
Set oShell = CreateObject("WScript.Shell")
 
oRe.Global=True
' for other language, change the etwork for the network equivalent in your language
oRe.Pattern= "etwork = (.*)\.\r\n.*?(\d{1,})\.\r\n.*?(\d{1,})\."
' Get result from "netsh dhcp server show mibinfo" piped command 
Set o=oRe.Execute(WScript.StdIn.ReadAll)
 
' For all scopes
For i=0 To o.Count-1
  sMsg = sMsg & vbcrlf & o(i).SubMatches(0) & ": " & vbcrlf
  Set oScriptExec = oShell.Exec("netsh dhcp server scope " & o(i).SubMatches(0) & " show clients")
 
  ' For all DHCP scope clients
  Do Until oScriptExec.StdOut.AtEndOfStream 
    strTemp = oScriptExec.StdOut.ReadLine
    ' If the lease is a reservation
    If InStr(strTemp, "-R") Then
       sMsg = sMsg & strTemp & vbcrlf
    End If 
  Loop
 
Next
 
' Show message. If the list is too long, you can send the output to a file
WScript.Echo sMsg