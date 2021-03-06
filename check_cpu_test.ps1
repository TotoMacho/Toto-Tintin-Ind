$cpu_average=[Math]::Round((Get-Counter -Counter ("\Processeur(*)\% temps processeur") -SampleInterval 1 -MaxSamples 30 | select -ExpandProperty countersamples | select -ExpandProperty cookedvalue | Measure-Object -Average).average)
If($cpu_average -lt 80){
    Write-Host "CRITICAL- Cpu usage is $space_free for the last 30s"
    exit 2
}
ElseIf($cpu_average -lt 75 -or $cpu_average -eq 75){
    Write-Host "WARNING- Cpu usage is $space_free for the last 30s"
    exit 1
}
ElseIf($cpu_average -gt 75){
    Write-Host "OK- Cpu usage is $space_free for the last 30s"
    exit 0
}
Else {
    Write-Host "UNKNOWN- CPU usage is unknown"
    exit 3
}