$ErrorActionPreference = 'Stop'

function Show-Value {
    param(
        [string]$Label,
        [object]$Value
    )

    if ($null -eq $Value -or [string]::IsNullOrWhiteSpace([string]$Value)) {
        $Value = 'Bulunamadi'
    }
    Write-Host ("{0}: {1}" -f $Label, $Value) -ForegroundColor Green
}

function Format-GiB {
    param([object]$Bytes)

    if ($null -eq $Bytes) {
        return 'Bulunamadi'
    }
    return ('{0:N2} GiB' -f ($Bytes / 1GB))
}

function Show-CPU {
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    Write-Host "`n--- Islemci ---" -ForegroundColor Green
    Show-Value 'Model' $cpu.Name
    Show-Value 'Uretici' $cpu.Manufacturer
    Show-Value 'Cekirdek sayisi' $cpu.NumberOfCores
    Show-Value 'Mantiksal islemci sayisi' $cpu.NumberOfLogicalProcessors
    $speed = if ($cpu.MaxClockSpeed) { "$($cpu.MaxClockSpeed) MHz" } else { $null }
    Show-Value 'Azami saat hizi' $speed
}

function Show-Memory {
    $computer = Get-CimInstance Win32_ComputerSystem
    $modules = @(Get-CimInstance Win32_PhysicalMemory)
    Write-Host "`n--- Bellek (RAM) ---" -ForegroundColor Green
    Show-Value 'Toplam RAM' (Format-GiB $computer.TotalPhysicalMemory)
    if ($modules.Count -eq 0) {
        Write-Host 'Bellek modulu bilgisi bulunamadi.' -ForegroundColor Green
        return
    }

    for ($index = 0; $index -lt $modules.Count; $index++) {
        $module = $modules[$index]
        $speed = if ($module.Speed) { "$($module.Speed) MHz" } else { 'Hiz bilgisi yok' }
        $manufacturer = if ($module.Manufacturer) { $module.Manufacturer } else { 'Uretici bilgisi yok' }
        $partNumber = if ($module.PartNumber) { $module.PartNumber.Trim() } else { 'Parca numarasi yok' }
        Write-Host ("Modul {0}: {1} | {2} | {3} | {4}" -f
            ($index + 1), (Format-GiB $module.Capacity), $speed, $manufacturer, $partNumber) -ForegroundColor Green
    }
}

function Show-GPU {
    $cards = @(Get-CimInstance Win32_VideoController)
    Write-Host "`n--- Ekran karti ---" -ForegroundColor Green
    if ($cards.Count -eq 0) {
        Write-Host 'Ekran karti bilgisi bulunamadi.' -ForegroundColor Green
        return
    }

    for ($index = 0; $index -lt $cards.Count; $index++) {
        $card = $cards[$index]
        if ($cards.Count -gt 1) {
            Write-Host ("Kart {0}:" -f ($index + 1)) -ForegroundColor Green
        }
        Show-Value 'Model' $card.Name
        Show-Value 'Grafik islemcisi' $card.VideoProcessor
        Show-Value 'Paylasilan/ayrilmis bellek' (Format-GiB $card.AdapterRAM)
        Show-Value 'Surucu surumu' $card.DriverVersion
    }
}

function Show-Motherboard {
    $board = Get-CimInstance Win32_BaseBoard | Select-Object -First 1
    Write-Host "`n--- Anakart ---" -ForegroundColor Green
    Show-Value 'Uretici' $board.Manufacturer
    Show-Value 'Model' $board.Product
    Show-Value 'Surum' $board.Version
}

function Show-All {
    Show-CPU
    Show-Memory
    Show-GPU
    Show-Motherboard
}

while ($true) {
    Write-Host "`n=== Donanim Bilgisi ===" -ForegroundColor Magenta
    Write-Host '1. Islemci (CPU)' -ForegroundColor Magenta
    Write-Host '2. Bellek (RAM)' -ForegroundColor Magenta
    Write-Host '3. Ekran karti (GPU)' -ForegroundColor Magenta
    Write-Host '4. Anakart' -ForegroundColor Magenta
    Write-Host '5. Tum bilgileri goster' -ForegroundColor Magenta
    Write-Host '0. Cikis' -ForegroundColor Magenta
    $choice = Read-Host 'Seciminiz'

    try {
        switch ($choice) {
            '1' { Show-CPU }
            '2' { Show-Memory }
            '3' { Show-GPU }
            '4' { Show-Motherboard }
            '5' { Show-All }
            '0' {
                Write-Host 'Program kapatildi.'
                return
            }
            default { Write-Host 'Gecersiz secim. Lutfen 0-5 arasinda bir secim yapin.' -ForegroundColor Red }
        }
    }
    catch {
        Write-Host ("Hata: {0}" -f $_.Exception.Message) -ForegroundColor Red
    }

    if ($choice -in @('1', '2', '3', '4', '5')) {
        $null = Read-Host "`nMenuye donmek icin Enter'a basin"
    }
}
