$CheminACrypter = “Chemin1“
$PassphraseToEncrypt = “TonPassphrase“
$CheminEncrypter = Write-EncryptedString -inputstring $CheminACrypter -Password $PassphraseToEncrypt
“$($CheminEncrypter)" | Out-File c:tempServersSecurePassword.txt -Append