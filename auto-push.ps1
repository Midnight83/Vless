$ErrorActionPreference = "SilentlyContinue"

Set-Location "C:\RomanScanner"

# Читаем токен
$token = Get-Content "$PSScriptRoot\config.txt" -Raw
$token = $token.Trim()

if (-not $token) {
    Write-Host "В config.txt нет токена"
    exit
}

# Адрес репозитория
$repo = "https://$token@github.com/Midnight83/Vless.git"

# Настройка имени и email (если не настроено)
git config --global user.email "roman@example.com"
git config --global user.name "Roman"

# Публикуем файл
git add WHITE-CIDR-RU-checked.txt
git commit -m "Auto update" --allow-empty
git push --force-with-lease $repo main


