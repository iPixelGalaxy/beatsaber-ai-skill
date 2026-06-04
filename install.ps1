param(
    [string]$CodexHome = "",
    [string]$SkillName = "beatsaber",
    [string]$RepoUrl = "",
    [string]$Ref = "",
    [switch]$Force,
    [switch]$NoBackup
)

$ErrorActionPreference = "Stop"

function Resolve-FullPath {
    param([string]$Path)
    return [System.IO.Path]::GetFullPath($Path)
}

function Assert-ChildPath {
    param(
        [string]$Parent,
        [string]$Child
    )

    $parentFull = Resolve-FullPath $Parent
    $childFull = Resolve-FullPath $Child
    $parentNorm = $parentFull.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
    if (-not $childFull.StartsWith($parentNorm + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to modify path outside expected parent. Parent: $parentFull Child: $childFull"
    }
}

function Copy-SkillFiles {
    param(
        [string]$Source,
        [string]$Destination
    )

    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    $excludedDirectories = @(".git")
    $items = Get-ChildItem -LiteralPath $Source -Force
    foreach ($item in $items) {
        if ($item.PSIsContainer -and $item.Name -in $excludedDirectories) {
            continue
        }

        $target = Join-Path $Destination $item.Name
        Copy-Item -LiteralPath $item.FullName -Destination $target -Recurse -Force
    }
}

if (-not $CodexHome) {
    if ($env:CODEX_HOME) {
        $CodexHome = $env:CODEX_HOME
    }
    else {
        $CodexHome = Join-Path $HOME ".codex"
    }
}

$tempRoot = ""
$sourceRoot = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$sourceSkill = Join-Path $sourceRoot "SKILL.md"
if ($RepoUrl) {
    $git = (Get-Command git -ErrorAction SilentlyContinue).Source
    if (-not $git) { throw "git is required when installing from -RepoUrl." }

    $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("beatsaber-ai-skill-" + [guid]::NewGuid().ToString("N"))
    & $git clone --depth 1 $RepoUrl $tempRoot | Write-Host
    if ($LASTEXITCODE -ne 0) { throw "git clone failed for $RepoUrl" }
    if ($Ref) {
        & $git -C $tempRoot fetch --depth 1 origin $Ref | Write-Host
        if ($LASTEXITCODE -ne 0) { throw "git fetch failed for ref $Ref" }
        & $git -C $tempRoot checkout FETCH_HEAD | Write-Host
        if ($LASTEXITCODE -ne 0) { throw "git checkout failed for ref $Ref" }
    }

    $sourceRoot = $tempRoot
    $sourceSkill = Join-Path $sourceRoot "SKILL.md"
}

if (-not (Test-Path -LiteralPath $sourceSkill)) {
    throw "No SKILL.md found. Run from the skill repo root, or pass -RepoUrl <git-url>."
}

$skillsRoot = Join-Path $CodexHome "skills"
$destination = Join-Path $skillsRoot $SkillName

New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null
Assert-ChildPath -Parent $skillsRoot -Child $destination

$sourceFull = Resolve-FullPath $sourceRoot
$destinationFull = Resolve-FullPath $destination
$selfInstall = $false
if ($sourceFull.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar) -eq $destinationFull.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)) {
    $selfInstall = $true
    $stagedRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("beatsaber-ai-skill-stage-" + [guid]::NewGuid().ToString("N"))
    Copy-SkillFiles -Source $sourceRoot -Destination $stagedRoot
    $tempRoot = $stagedRoot
    $sourceRoot = $stagedRoot
}

if ((Test-Path -LiteralPath $destination) -and -not $selfInstall) {
    if (-not $NoBackup) {
        $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backup = Join-Path $skillsRoot "$SkillName.backup-$stamp"
        Assert-ChildPath -Parent $skillsRoot -Child $backup
        Move-Item -LiteralPath $destination -Destination $backup
        Write-Host "Backed up existing skill to: $backup"
    }
    else {
        Remove-Item -LiteralPath $destination -Recurse -Force
    }
}

try {
    Copy-SkillFiles -Source $sourceRoot -Destination $destination
}
finally {
    if ($tempRoot -and (Test-Path -LiteralPath $tempRoot)) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}

Write-Host "Installed Beat Saber skill to: $destination"
Write-Host "Invoke it with: `$beatsaber"
