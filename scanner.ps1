$ErrorActionPreference = "SilentlyContinue"

$url     = "https://raw.githubusercontent.com/igareck/vpn-configs-for-russia/refs/heads/main/WHITE-CIDR-RU-checked.txt"
$outFile = "WHITE-CIDR-RU-checked.txt"

Write-Host "Скачиваю файл..."
$content = Invoke-WebRequest -Uri $url -UseBasicParsing
$lines   = $content.Content -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

Write-Host "Извлекаю IP..."
$items = foreach ($line in $lines) {
    if ($line -match "@(.+?):") {
        [pscustomobject]@{
            Line = $line
            IP   = $Matches[1]
        }
    }
}

Write-Host "Тестирую задержку..."
$results = @()

foreach ($item in $items) {
    $ping = Test-Connection -TargetName $item.IP -Count 1 -TimeoutSeconds 1 -ErrorAction SilentlyContinue
    if ($ping) {
        $lat = ($ping | Select-Object -ExpandProperty Latency)
        if ($lat -ne $null) {
            $results += [pscustomobject]@{
                IP      = $item.IP
                Latency = [double]$lat
                Line    = $item.Line
            }
        }
    }
}

if (-not $results) {
    Write-Host "Ни один IP не ответил."
    exit
}

Write-Host "Сортирую..."
$sorted = $results | Sort-Object Latency

Write-Host "Топ 10:"
$sorted | Select-Object -First 10 | ForEach-Object {
    Write-Host "$($_.IP)  $($_.Latency)"
}

Write-Host "Сохраняю топ 10 в файл $outFile..."
$sorted | Select-Object -First 10 | ForEach-Object {
    $_.Line.ToString()
} | Out-File $outFile -Encoding utf8

Write-Host "Готово."
