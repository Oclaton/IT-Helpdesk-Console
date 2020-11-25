# Using
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Windows.Forms.Application]::EnableVisualStyles()
 
# Create Form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "IT Admin Console"
$Form.Size = New-Object System.Drawing.Size(800,600)
$Form.MaximizeBox = $false
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = 'Fixed3D'

$Form.AutoSizeMode = "GrowAndShrink"    # or GrowOnly
$Form.MinimizeBox = $True
$Form.MaximizeBox = $True
$Form.WindowState = "Maximized"         # Maximized, Minimized, Normal
$Form.SizeGripStyle = "Auto"            # Auto, Hide, Show
$Form.ShowInTaskbar = $True             
$Form.StartPosition = "CenterScreen"

# Icon
$Icon = New-Object system.drawing.icon ("$PSScriptRoot\Data\Pic\Logo.ico")
$Form.Icon = $Icon

# Label
$u = [Environment]::UserName
$usr = (Get-ADUser $u -Properties *).Name

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "$usr"
$Label.AutoSize = $True
$Label.Location = New-Object System.Drawing.Size(20,20) 
$Font = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Bold)
$Form.ForeColor = "DarkBlue"
$Form.Font = $Font
$Form.Controls.Add($Label)

# Button: OK
$Okbutton1 = New-Object System.Windows.Forms.Button 
$Okbutton1.Size = New-Object System.Drawing.Size(100,30)
#$Okbutton1.Location = New-Object System.Drawing.Size(200,150)
#$Okbutton1.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
$Okbutton1.Text = "OK"
$Okbutton1.Add_Click({$Form.Close()
# do this with button
Write-Host "OK"}) 
#$Form.Controls.Add($Okbutton1)
 
# Button: Abbruch
$Abbruch = New-Object System.Windows.Forms.Button 
$Abbruch.Size = New-Object System.Drawing.Size(100,30)
#$Abbruch.Location = New-Object System.Drawing.Size(50,50)
$Abbruch.Text = "Abbruch"
$Abbruch.Add_Click({$Form.Close() 
# do this with button
Write-Host "Abbruch"}) 
#$Form.Controls.Add($Abbruch)

$tableLayoutPanel1 = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel1.RowCount = 2 #how many rows
$tableLayoutPanel1.ColumnCount = 2 #how many columns
$tableLayoutPanel1.Controls.Add($Okbutton1, 0, 0) #choose where to place button
$tableLayoutPanel1.Controls.Add($Abbruch, 1, 1) #choose where to place listbox
$tableLayoutPanel1.Dock = [System.Windows.Forms.DockStyle]::Fill #choose style

#make rows the same size
$tableLayoutPanel1.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 50)))
$tableLayoutPanel1.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 50)))
#make columns the same size
$tableLayoutPanel1.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent,50)))
$tableLayoutPanel1.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent,50)))

$Form.controls.AddRange(@($tableLayoutPanel1)) #don't add button and listbox here because they're already added by tablelayoutpanel


$Form.ShowDialog()