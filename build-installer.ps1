# Run from Windows PowerShell 5.1 or PowerShell 7 on Windows 10/11.
# Produces dist-installer\ModMedic-Setup-0.1.0.exe
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Repo = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $Repo

if (-not (Test-Path '.venv\Scripts\python.exe')) {
    py -3 -m venv .venv
    if ($LASTEXITCODE -ne 0) { throw 'Unable to create Python virtual environment. Install Python 3.11+.' }
}
$Python = Join-Path $Repo '.venv\Scripts\python.exe'
& $Python -m pip install --disable-pip-version-check 'pyinstaller>=6.18,<7'
if ($LASTEXITCODE -ne 0) { throw 'Installing PyInstaller failed.' }

$env:PYTHONPATH = Join-Path $Repo 'src'
& $Python -m unittest discover -s tests -v
if ($LASTEXITCODE -ne 0) { throw 'Unit tests failed. No installer will be built.' }

& $Python -m PyInstaller --noconfirm --clean --onedir --windowed `
    --name ModMedic `
    --paths (Join-Path $Repo 'src') `
    --icon (Join-Path $Repo 'assets\modmedic.ico') `
    --add-data "$(Join-Path $Repo 'assets\modmedic.png'):modmedic/assets" `
    (Join-Path $Repo 'src\modmedic\__main__.py')
if ($LASTEXITCODE -ne 0) { throw 'Building the ModMedic application failed.' }

$Compiler = Get-Command 'ISCC.exe' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source -First 1
if (-not $Compiler) {
    foreach ($Root in @(${env:ProgramFiles(x86)}, $env:ProgramFiles)) {
        if (-not $Root -or -not (Test-Path -LiteralPath $Root)) { continue }
        $Candidates = Get-ChildItem -LiteralPath $Root -Directory -Filter 'Inno Setup*' -ErrorAction SilentlyContinue
        foreach ($Folder in $Candidates) {
            $Candidate = Join-Path $Folder.FullName 'ISCC.exe'
            if (Test-Path -LiteralPath $Candidate) { $Compiler = $Candidate; break }
        }
        if ($Compiler) { break }
    }
}
if (-not $Compiler) {
    throw 'Inno Setup not found. Install the current Inno Setup 6.7+ version from jrsoftware.org.'
}

& $Compiler (Join-Path $Repo 'installer\ModMedic.iss')
if ($LASTEXITCODE -ne 0) { throw 'Inno Setup compilation failed.' }

$Result = Join-Path $Repo 'dist-installer\ModMedic-Setup-0.1.0.exe'
if (-not (Test-Path -LiteralPath $Result)) { throw "Expected installer missing: $Result" }
Write-Host "`nSUCCESS: $Result" -ForegroundColor Cyan
