﻿$user = 'toto'
$pass = 'pwd'
$database = 'mysql'
$mysql_host = '192.168.139.139'
$SqlConnection = New-Object System.Data.ODBC.ODBCConnection
$SqlConnection.connectionstring = `
   "DRIVER={MySQL ODBC 5.3 ANSI Driver};" +
   "Server = $mysql_host;" +
   "Database = $database;" +
   "UID = $user;" +
   "PWD= $pass;" +
   "Option = 3"
$SqlConnection.Open()
If($SqlConnection.State -eq "Open"){
    Write-Host "OK- Connection to database established"
    $SqlConnection.Close()
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
