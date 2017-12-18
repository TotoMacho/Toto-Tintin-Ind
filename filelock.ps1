function Test-FileLock {
    param ([string]$filePath)
        
    $ErrorActionPreference = "SilentlyContinue"
    $error[0]=""                   # réinitialisation du dernier message d'erreur
    
    if (test-path $filePath)       # test d'existence du fichier
    {   
        $fileInfo = New-Object System.IO.FileInfo $filePath
        $fileStream = $fileInfo.OpenRead()   # tentative d'ouverture du fichier en lecture
        if ($error[0] -eq "")                # Si pas d'erreur
        {
            return $false                    # fichier pas verrouille
        }
        else
        {
            return $true                     # fichier verrouille
        }
    }
    else                            # Le fichier n'existe pas, donc on lève une exception
    {
        $ErrorActionPreference = "Continue"
        throw "ATTENTION : Le fichier spécifié est introuvable !"
    }
}

Test-FileLock "C:\Program Files\NSClient++\nsclient.ini"