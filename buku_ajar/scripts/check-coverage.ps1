# check-coverage.ps1
# Memeriksa apakah seluruh 19 Sub-CPMK muncul sebagai \subcpmk{...}
# di berkas chapter.tex.

$root = Split-Path -Parent $PSScriptRoot

$expected = @()
1..7 | ForEach-Object { $expected += "1.$_" }
1..4 | ForEach-Object { $expected += "2.$_" }
1..4 | ForEach-Object { $expected += "3.$_" }
1..4 | ForEach-Object { $expected += "4.$_" }

$found = @{}
Get-ChildItem -Path (Join-Path $root "chapters") -Directory | ForEach-Object {
    $chapter = Join-Path $_.FullName "chapter.tex"
    if (Test-Path $chapter) {
        $text = Get-Content $chapter -Raw
        [regex]::Matches($text, '\\subcpmk\{([0-9]+\.[0-9]+)\}') |
            ForEach-Object { $found[$_.Groups[1].Value] = $true }
    }
}

$missing = @()
foreach ($code in $expected) {
    if (-not $found.ContainsKey($code)) {
        $missing += $code
    }
}

if ($missing.Count -eq 0) {
    Write-Host "OK: seluruh 19 Sub-CPMK ditemukan."
    exit 0
} else {
    Write-Host "Sub-CPMK belum ditemukan:"
    $missing | ForEach-Object { Write-Host "  - $_" }
    exit 1
}
