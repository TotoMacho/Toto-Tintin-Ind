
set /A var=wmic cpu get loadpercentage

echo %var%
IF /I "%var%" GEQ "90" (
	ECHO "CRITICAL- CPU load is %var%"
	
) ELSE IF /I "%var%" GEQ "75" ( 
	ECHO "WARNING- CPU load is %var%" 
	
) ELSE IF /I "%var%" LEQ "75" (
	ECHO "OK- CPU load is %var%" 
	
) ELSE (
	ECHO "UNKNOWN- CPU load is unknown"
	
)
		
	
