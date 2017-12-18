@echo off

setlocal enabledelayedexpansion

set Times=0

for /f "skip=1" %%p in ('wmic cpu get loadpercentage') do (

set Cpusage!Times!=%%p

set /A Times=!Times! + 1

)

IF /I "%Cpusage0%" GEQ "90" (
	ECHO CRITICAL- CPU load is %Cpusage0%
	
) ELSE IF /I "%Cpusage0%" GEQ "75" ( 
	ECHO WARNING- CPU load is %Cpusage0% 
	
) ELSE IF /I "%Cpusage0%" LEQ "75" (
	ECHO OK- CPU load is %Cpusage0%
	
) ELSE (
	ECHO "UNKNOWN- CPU load is unknown"
	
)
		
	
