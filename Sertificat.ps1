$domain = "myhfs.local"
$days = 365

# Папка, где лежит сам скрипт
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "Генерирую приватный ключ..."
openssl genrsa -out "$scriptDir/server.key" 2048

Write-Host "Генерирую самоподписанный сертификат..."
openssl req -x509 -new -nodes -key "$scriptDir/server.key" -sha256 -days $days `
    -out "$scriptDir/server.crt" `
    -subj "/CN=$domain"

Write-Host "Готово!"
Write-Host "Файлы созданы здесь:"
Write-Host "  $scriptDir\server.key"
Write-Host "  $scriptDir\server.crt"
