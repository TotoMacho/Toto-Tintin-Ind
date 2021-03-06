﻿$t = netstat -e 

foreach($line in $t[5]){
$line = $line -replace '^\s+',''
$line = $line -split '\s+'
 $properties = @{
        Name = $line[0..1]
        ReceivedPacket = $line[2]
        SendPacket = $line[3]
    }

    $Packet = New-Object -TypeName PSObject -Property $properties 
    

}
foreach($line in $t[7]){
$line = $line -replace '^\s+',''
$line = $line -split '\s+'
 $properties = @{
        Name = $line[0]
        ReceivedReject = $line[1]
        SendReject = $line[2]
    }

    $Reject = New-Object -TypeName PSObject -Property $properties 
    

}
foreach($line in $t[8]){
$line = $line -replace '^\s+',''
$line = $line -split '\s+'
 $properties = @{
        Name = $line[0]
        ReceivedErrors = $line[1]
        SendErrors = $line[2]
    }

    $Errors = New-Object -TypeName PSObject -Property $properties 
    

}
$PctRSuccess = ($Packet.ReceivedPacket - $Reject.ReceivedReject - $Errors.ReceivedErrors ) / $Packet.ReceivedPacket * 100
$PctRFailed = 100 - $PctRSuccess

if($PctRSuccess -gt 75){

    Write-Host "OK- % of successfully received packet is $PctRSuccess%"
    exit 0

}elseif($PctRSuccess -lt 50){

    Write-Host "CRITICAL- $PctRFailed% of received packets are lost"
    exit 1

}elseif($PctRSucces -lt 75){

    Write-Host "WARNING- $PctRFailed% of received packets are lost"
    exit 2

}else{

    Write-Host "UNKNOWN- No information about received packet lost"
    exit 3
}