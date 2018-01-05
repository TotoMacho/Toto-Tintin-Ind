$cheminEncrypter = Get-Content c:tempServerSecurePassword.txt
$c = Read-EncryptedString -InputString $cheminEncrypter -password "TonPassphrase"