$var = Invoke-WebRequest -URI http://192.168.139.140:9200 -Method Get -TimeoutSec 5
$test = $Error[0]
If($var.StatusCode -eq "200"){
    Write-Host "OK- Connection to Elastic database established"
    exit 0
}
ElseIf($var.StatusCode -ne "200"){
    Write-Host "CRITICAL- Impossible to connect to database`n"$var.StatusCode" - "$var.StatusDescription"`n$test"
    $Error.Clear()
    exit 2
}
Else{
    Write-Host "UNKNOWN- Connection state to database is unknown`n"$var.StatusCode" - "$var.StatusDescription"`n$test"
    $Error.Clear()
    exit 3
}