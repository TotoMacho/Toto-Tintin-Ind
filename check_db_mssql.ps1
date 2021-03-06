$SQLServer = "192.168.139.140"
$uid ="SA"
$pwd = "passwd"
$SQLDBName = "nomDB"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; User ID = $uid; Password = $pwd;"
$SqlConnection.Open()
$SqlConnection.State
If($SqlConnection.State -eq "Open"){
    Write-Host "OK- Connection to database established"
    $SqlConnection.Close()
    $SqlConnection.State
    Remove-Variable * -ErrorAction SilentlyContinue; Remove-Module *;
    exit 0
}
ElseIf($SqlConnection.State -eq "Closed"){
    Write-Host "CRITICAL- Connection to database impossible"
    exit 2
}
Else{
    Write-Host "UNKNOWN- State of the connection to database unknown"
    exit 3
}

