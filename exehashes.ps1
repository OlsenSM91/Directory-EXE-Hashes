<# 
Directory EXEs to SHA256 Hash
Company: Computer Networking Solutions Inc.
Author: Steven Olsen
GitHub: https://github.com/OlsenSM91
Version: 0.1

Run:
  irm https://pathto.script/exehashes.ps1 | iex
#>

$ErrorActionPreference = 'Stop'

function Write-CnsBanner {
    Clear-Host
    $c = [ConsoleColor]

    Write-Host ""
    Write-Host "_________   _______    _________   _____  ____ ___ " -ForegroundColor $c::Cyan
    Write-Host "\_   ___ \  \      \  /   _____/  /  |  ||    |   \" -ForegroundColor $c::Cyan
    Write-Host "/    \  \/  /   |   \ \_____  \  /   |  ||    |   /" -ForegroundColor $c::Cyan
    Write-Host "\     \____/    |    \/        \/    ^   /    |  / " -ForegroundColor $c::Cyan
    Write-Host " \______  /\____|__  /_______  /\____   ||______/  " -ForegroundColor $c::Cyan
    Write-Host "        \/         \/        \/      |__|          " -ForegroundColor $c::Cyan
    Write-Host ""

    Write-Host "Directory EXEs to SHA256 Hash" -ForegroundColor $c::White
    Write-Host "Company: Computer Networking Solutions Inc." -ForegroundColor $c::DarkGray
    Write-Host "Author : Steven Olsen" -ForegroundColor $c::DarkGray
    Write-Host "GitHub : https://github.com/OlsenSM91" -ForegroundColor $c::DarkGray
    Write-Host "Version: 0.1" -ForegroundColor $c::DarkGray
    Write-Host ("-" * 72) -ForegroundColor $c::DarkGray
    Write-Host ""
}

function Prompt-ForDirectory {
    $c = [ConsoleColor]

    while ($true) {
        Write-Host "Enter a directory to hash (or press Enter for current directory):" -ForegroundColor $c::Yellow
        $inputPath = Read-Host "Path"

        if ([string]::IsNullOrWhiteSpace($inputPath)) {
            $inputPath = (Get-Location).Path
        }

        try {
            if (-not (Test-Path -LiteralPath $inputPath)) {
                Write-Host "Path not found: $inputPath" -ForegroundColor $c::Red
                Write-Host ""
                continue
            }

            return (Resolve-Path -LiteralPath $inputPath).Path
        }
        catch {
            Write-Host "Invalid path: $inputPath" -ForegroundColor $c::Red
            Write-Host "Details: $($_.Exception.Message)" -ForegroundColor $c::DarkRed
            Write-Host ""
        }
    }
}

function Prompt-YesNo {
    param(
        [Parameter(Mandatory)]
        [string]$Question,
        [bool]$DefaultNo = $true
    )

    $c = [ConsoleColor]
    $suffix = if ($DefaultNo) { "[y/N]" } else { "[Y/n]" }

    while ($true) {
        $ans = Read-Host "$Question $suffix"
        if ([string]::IsNullOrWhiteSpace($ans)) {
            return (-not $DefaultNo)
        }

        switch ($ans.Trim().ToLower()) {
            'y'   { return $true }
            'yes' { return $true }
            'n'   { return $false }
            'no'  { return $false }
            default { Write-Host "Please answer y or n." -ForegroundColor $c::DarkYellow }
        }
    }
}

function Get-ExeSha256Hashes {
    param(
        [Parameter(Mandatory)]
        [string]$Directory,
        [bool]$Recurse = $false
    )

    $items = if ($Recurse) {
        Get-ChildItem -LiteralPath $Directory -Filter '*.exe' -File -Recurse -ErrorAction Stop
    } else {
        Get-ChildItem -LiteralPath $Directory -Filter '*.exe' -File -ErrorAction Stop
    }

    if (-not $items) { return @() }

    $items |
        Sort-Object FullName |
        ForEach-Object { (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash }
}

function Main {
    $c = [ConsoleColor]

    Write-CnsBanner

    Write-Host "This tool outputs SHA256 hashes for all .exe files in the selected directory." -ForegroundColor $c::Gray
    Write-Host ""

    $dir = Prompt-ForDirectory
    Write-Host ""
    Write-Host "Target:" -ForegroundColor $c::DarkGray
    Write-Host "  $dir" -ForegroundColor $c::Green
    Write-Host ""

    $recurse = Prompt-YesNo -Question "Include subfolders?" -DefaultNo $true
    $copy    = Prompt-YesNo -Question "Copy hash list to clipboard?" -DefaultNo $true

    Write-Host ""
    Write-Host "Hashing EXEs..." -ForegroundColor $c::Cyan

    $hashes = Get-ExeSha256Hashes -Directory $dir -Recurse $recurse

    Write-Host ""
    if (-not $hashes -or $hashes.Count -eq 0) {
        Write-Host "No .exe files found." -ForegroundColor $c::Yellow
        return
    }

    # Output only hashes, one per line
    $hashes

    if ($copy) {
        ($hashes -join "`r`n") | Set-Clipboard
        Write-Host ""
        Write-Host "Copied $($hashes.Count) hashes to clipboard." -ForegroundColor $c::Green
    }

    Write-Host ""
    Write-Host "Done." -ForegroundColor $c::DarkGray
}

Main
