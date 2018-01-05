$var = Test-Connection 192.168.139.139 -Count 3 -Delay 1 -Quiet

if ($var -eq $True) {
    Write-Host "OK- Host is up"
    exit 0
} elseif ($var -eq $False) {
    Write-Host "CRITICAL- Host is down"
    exit 2
} else {
    Write-Host "UNKNOWN"
    exit 3
}