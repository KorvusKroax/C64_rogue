param(
    [string]$BasicName = "main",
    [string]$AsmName = "routines",
    [string]$DiskName = "disk",
    [string]$AcmePath = "C:/acme0.97win/acme/acme.exe",
    [string]$ViceBinDir = "C:/GTK3VICE-3.10-win64/bin",
    [string]$Ip = "127.0.0.1",
    [int]$Port = 6510
)

$BuildDir = "build"
$SrcDir = "src"

function Convert-BasicLabelsToNumbered {
    param(
        [Parameter(Mandatory = $true)]
        [string]$InputPath,
        [Parameter(Mandatory = $true)]
        [string]$OutputPath,
        [int]$StartLine = 10,
        [int]$LineStep = 10
    )

    $rawLines = Get-Content -Path $InputPath
    $hasLabels = $rawLines | Where-Object { $_ -match '^\s*[A-Za-z_][A-Za-z0-9_]*\s*:' }
    if (-not $hasLabels) {
        return $InputPath
    }

    $entries = @()
    $labelToLine = @{}
    $lineNumber = $StartLine

    foreach ($rawLine in $rawLines) {
        $trimmed = $rawLine.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed)) {
            continue
        }

        if ($trimmed -match '^\s*(\d+)\b') {
            throw "A labels source cannot contain explicit line numbers: '$trimmed'"
        }

        $workingText = $trimmed
        if ($workingText -match '^([A-Za-z_][A-Za-z0-9_]*)\s*:\s*(.*)$') {
            $label = $Matches[1]
            $rest = $Matches[2]

            if ($labelToLine.ContainsKey($label)) {
                throw "Duplicate BASIC label '${label}:' in '$InputPath'"
            }

            $labelToLine[$label] = $lineNumber
            $workingText = $rest.Trim()

            if ([string]::IsNullOrWhiteSpace($workingText)) {
                continue
            }
        }

        $entries += [PSCustomObject]@{
            Number = $lineNumber
            Code = $workingText
        }
        $lineNumber += $LineStep
    }

    $resolvedLines = @()
    foreach ($entry in $entries) {
        $resolvedCode = [regex]::Replace(
            $entry.Code,
            '(?i)^\s*on\s+(.+?)\s+(goto|gosub)\s+([A-Za-z0-9_\s,]+)\s*$',
            {
                param($m)
                $expressionPart = $m.Groups[1].Value
                $keyword = $m.Groups[2].Value
                $targetsPart = $m.Groups[3].Value
                $resolvedTargets = @()

                foreach ($target in ($targetsPart -split ',')) {
                    $trimmedTarget = $target.Trim()
                    if ([string]::IsNullOrWhiteSpace($trimmedTarget)) {
                        continue
                    }

                    if ($trimmedTarget -match '^\d+$') {
                        $resolvedTargets += $trimmedTarget
                        continue
                    }

                    if ($labelToLine.ContainsKey($trimmedTarget)) {
                        $resolvedTargets += [string]$labelToLine[$trimmedTarget]
                        continue
                    }

                    throw "Unknown BASIC label reference '$trimmedTarget' in '$InputPath'"
                }

                return "on $expressionPart $keyword $($resolvedTargets -join ',')"
            }
        )

        $resolvedCode = [regex]::Replace(
            $resolvedCode,
            ('(?i)\bthen\s+(goto|gosub)\s+([A-Za-z_][A-Za-z0-9_]*)\b' +
             '|\b(goto|gosub|then)\s+([A-Za-z_][A-Za-z0-9_]*)\b'),
            {
                param($m)
                if ($m.Groups[1].Success) {
                    $keyword = $m.Groups[1].Value
                    $targetLabel = $m.Groups[2].Value
                    if ($labelToLine.ContainsKey($targetLabel)) { return "then $keyword $($labelToLine[$targetLabel])" }
                } else {
                    $keyword = $m.Groups[3].Value
                    $targetLabel = $m.Groups[4].Value
                    if ($labelToLine.ContainsKey($targetLabel)) { return "$keyword $($labelToLine[$targetLabel])" }
                }
                return $m.Value
            }
        )
        $resolvedLines += "$($entry.Number) $resolvedCode"
    }

    Set-Content -Path $OutputPath -Value $resolvedLines
    return $OutputPath
}

# create build folder if it isn't exists
if (-not (Test-Path $BuildDir)) {
    New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
}

# compiling asembly (ACME)
& $AcmePath -f cbm --symbollist "$BuildDir/$AsmName.symbols.txt" -o "$BuildDir/$AsmName.prg" "$SrcDir/$AsmName.asm"

# parse asm symbols: `label: !byte $hex` data constants (value) + `label = $hex` equates (address)
# + remaining code labels ($c000+) from symbollist (address) for anything not already a data constant
$asmSymbols = @{}
Get-Content "$SrcDir/$AsmName.asm" | ForEach-Object {
    if ($_ -match '^\s*(\w+):\s*!byte\s*\$([0-9a-fA-F]{1,2})\b') {
        $asmSymbols[$Matches[1]] = [Convert]::ToInt32($Matches[2], 16)
    }
}
Get-Content "$SrcDir/$AsmName.asm" | ForEach-Object {
    if ($_ -match '^\s*(\w+)\s*=\s*\$([0-9a-fA-F]+)') {
        $asmSymbols[$Matches[1]] = [Convert]::ToInt32($Matches[2], 16)
    }
}
Get-Content "$BuildDir/$AsmName.symbols.txt" | ForEach-Object {
    if ($_ -match '^\s*(\w+)\s*=\s*\$([0-9a-fA-F]+)') {
        $label = $Matches[1]
        $value = [Convert]::ToInt32($Matches[2], 16)
        if ($value -ge 0xc000 -and -not $asmSymbols.ContainsKey($label)) { $asmSymbols[$label] = $value }  # code region only
    }
}

# compiling BASIC (Petcat)
$basicInputPath = "$SrcDir/$BasicName.bas"
$basicForPetcatPath = Convert-BasicLabelsToNumbered -InputPath $basicInputPath -OutputPath "$BuildDir/$BasicName.numbered.bas"

# resolve asm symbols/constants anywhere in the BASIC source (poke/peek/sys args, expressions, etc.)
$basicContent = Get-Content $basicForPetcatPath
if ($asmSymbols.Count -gt 0) {
    $symbolPattern = '\b(' + (($asmSymbols.Keys | Sort-Object Length -Descending | ForEach-Object { [regex]::Escape($_) }) -join '|') + ')\b'
    $basicContent = $basicContent | ForEach-Object {
        [regex]::Replace($_, $symbolPattern, {
            param($m)
            return [string]$asmSymbols[$m.Value]
        })
    }
}
Set-Content $basicForPetcatPath $basicContent

& "$ViceBinDir/petcat.exe" -w2 -o "$BuildDir/$BasicName.prg" $basicForPetcatPath

# creating D64 image (c1541)
& "$ViceBinDir/c1541.exe" -format mygame,01 d64 "$BuildDir/$DiskName.d64" `
    -write "$BuildDir/$BasicName.prg" $BasicName `
    -write "$BuildDir/$AsmName.prg" $AsmName | Out-Null

# live reload in VICE emulátor
$fullDiskPath = (Get-Item "$BuildDir/$DiskName.d64").FullName
$target = "${fullDiskPath}:$BasicName"

if (-not (Get-Process x64sc -ErrorAction SilentlyContinue)) {
    # VICE is not rinning -> start VICE and load program
    Write-Host "Starting VICE instance with $target..."
    Start-Process "$ViceBinDir/x64sc.exe" -ArgumentList "-remotemonitor", "+binarymonitor", "-autostart", "`"$target`""
} else {
    # VICE is already running -> reset VICE and reload program
    $client = $null
    $reader = $null
    $writer = $null

    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $client.SendTimeout = 1000
        $client.ReceiveTimeout = 1000
        $client.Connect($Ip, $Port)

        $stream = $client.GetStream()
        $writer = New-Object System.IO.StreamWriter($stream)
        $reader = New-Object System.IO.StreamReader($stream)
        $writer.NewLine = "`n"

        Start-Sleep -Milliseconds 100
        while ($stream.DataAvailable) {
            $null = $reader.ReadLine()
        }

        foreach ($command in @("detach 8", "autostart `"$target`"", "x")) {
            $writer.WriteLine($command)
            $writer.Flush()
            Start-Sleep -Milliseconds 50
        }

        Start-Sleep -Milliseconds 100
        while ($stream.DataAvailable) {
            $null = $reader.ReadLine()
        }

        Write-Host "Successfully reloaded $target in running VICE instance."
    }
    finally {
        if ($writer) { $writer.Close() }
        if ($reader) { $reader.Close() }
        if ($client) { $client.Close() }
    }
}
