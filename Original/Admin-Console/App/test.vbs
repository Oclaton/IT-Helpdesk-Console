Set objShell = CreateObject("WScript.Shell")
Set objExec = objShell.Exec("rechner.cmd " & oUser.Value)
strResults = UCase(objExec.StdOut.ReadAll)
If InStr(strResults, "KEINEM") Then
  status =  "Benutzer kann keinem Rechner zugeordnet werden"
Else
'oComputer.Value = Left(strResult, 25)
oPC = Split(strResults, " ")
oComputer.Value = oPC(5)
End If
WScript.Echo status