$Error.Clear()
Connect-RedisServer -Host 192.168.139.140 -Port 6379
$test = $Error[-1]
Send-RedisCommand -Command "auth Passwd"
$var = Send-RedisCommand -Command "PING"
If($var -eq "PONG"){
    Write-Host "OK- Connection to Redis database established"
    Disconnect-RedisServer
    Clear-Variable -Name var
    exit 0
}
ElseIf($var -ne "PONG"){
    Write-Host "CRITICAL- Impossible to connect to database`n$test"
    Clear-Variable -Name var
    exit 2
}
Else{
    Write-Host "UNKNOWN- Connection state to database is unknown`n$test"
    Clear-Variable -Name var
    exit 3
}