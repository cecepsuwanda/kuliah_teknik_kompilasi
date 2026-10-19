# check-code-paths.ps1
# Memeriksa bahwa setiap path pada \includecode{...} benar-benar ada.

$root = Split-Path -Parent $PSScriptRoot
$errors = 0
$checked = 0

Get-ChildItem -Path (Join-Path $root "chapters") -Recurse -Filter *.tex |
    ForEach-Object {
        $file = $_
        $text = Get-Content $file.FullName -Raw
        $matches = [regex]::Matches(
            $text,
            '\\includecode(?:\[[^\]]*\])?\{([^}]+)\}'
        )
        foreach ($m in $matches) {
            $rel = $m.Groups[1].Value
            $path = Join-Path $file.DirectoryName $rel
            $path = [System.IO.Path]::GetFullPath($path)
            $checked++
            if (-not (Test-Path $path)) {
                Write-Host "HILANG: $($file.FullName) -> $rel"
                $script:errors++
            }
        }
    }

Write-Host "Diperiksa: $checked path"
if ($errors -eq 0) {
    Write-Host "OK: semua path kode ditemukan."
    exit 0
} else {
    Write-Host "GAGAL: $errors path tidak ditemukan."
    exit 1
}
