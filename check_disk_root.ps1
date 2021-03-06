$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"

$size = [Math]::Round($disk.Size / 1GB)
$space = [Math]::Round($disk.FreeSpace / 1GB)
$space_free = [Math]::Round($space / $size * 100)
If($space_free -lt 10){
    echo "CRITICAL- Space available on C: is $space_free"
    exit 2
}
ElseIf($space_free -lt 25 -or $space_free -eq 25){
    echo "WARNING- Space available on C: is $space_free"
    exit 1
}
ElseIf($space_free -gt 25){
    echo "OK- Space available on C: is $space_free"
    exit 0
}
Else {
    echo "UNKNOWN- Space available on C: is unknown"
    exit 3
}