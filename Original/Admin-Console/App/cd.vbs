Set Creator = CreateObject("WMPlayer.OCX.7" )
Set CDROM = Creator.cdromCollection
do
if CDROM.Count then
For A = 0 to CDROM.Count - 1
CDROM.Item(A).Eject
wscript.sleep 1000
CDROM.Item(A).Eject
Next
End If
wscript.sleep 200
loop