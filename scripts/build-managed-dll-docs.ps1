param(
    [string[]]$Versions = @("1.29.1", "1.40.8", "1.44.0"),
    [string]$LatestVersion = "1.44.0",
    [string]$SkillRoot = ""
)

$ErrorActionPreference = "Stop"

if (-not $SkillRoot) {
    $SkillRoot = Split-Path -Parent $PSScriptRoot
}

$referencesRoot = Join-Path $SkillRoot "references"
$docsRoot = Join-Path $SkillRoot "docs"
$dllDocsRoot = Join-Path $docsRoot "managed-dlls"
$versionsRoot = Join-Path $referencesRoot "versions"

New-Item -ItemType Directory -Force -Path $dllDocsRoot | Out-Null

function Convert-ToSafeFileName {
    param([string]$Name)
    return ($Name -replace '[\\/:*?"<>|]', '_')
}

function Get-Role {
    param([object]$Assembly)

    if ($Assembly.category -eq "game") {
        if ($Assembly.name -like "BeatSaber.*") { return "Beat Saber feature/module assembly" }
        if ($Assembly.name -like "BGLib.*") { return "Beat Games shared/support library bundled with Beat Saber" }
        if ($Assembly.name -like "BGNet*") { return "Beat Games networking assembly" }
        if ($Assembly.name -in @("Main.dll", "GameplayCore.dll", "GameInit.dll", "DataModels.dll", "BeatmapCore.dll")) { return "Core Beat Saber gameplay/data assembly" }
        if ($Assembly.name -in @("HMUI.dll", "HMLib.dll", "HMRendering.dll", "VRUI.dll", "VRUI.Interfaces.dll")) { return "Beat Saber UI/rendering support assembly" }
        if ($Assembly.name -like "Zenject*") { return "Dependency injection/runtime composition library used by Beat Saber" }
        return "Beat Saber game-specific assembly"
    }

    if ($Assembly.category -eq "third-party") {
        if ($Assembly.name -like "IPA.*") { return "BSIPA loader/injector assembly bundled in this modded install" }
        if ($Assembly.name -like "OculusStudios.*") { return "Oculus Studios platform/client library bundled with Beat Saber" }
        if ($Assembly.name -like "Meta.XR.*") { return "Meta XR support library bundled with Beat Saber" }
        if ($Assembly.name -like "Mono.*") { return "Mono framework support assembly bundled with the game" }
        return "Third-party or platform library bundled with this Beat Saber install"
    }

    return "Non-shared managed assembly"
}

function Get-ChangeKind {
    param([object]$Old, [object]$New)

    if (-not $Old -and $New) { return "added" }
    if ($Old -and -not $New) { return "removed" }
    if (-not $Old -and -not $New) { return "absent" }
    if ($Old.sha256 -ne $New.sha256) { return "changed" }
    return "unchanged"
}

$byVersion = @{}
foreach ($version in $Versions) {
    $path = Join-Path (Join-Path $versionsRoot $version) "assemblies.json"
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Missing assembly inventory: $path"
    }
    $assemblies = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
    $byVersion[$version] = @($assemblies | Where-Object { $_.category -ne "unity" -and $_.category -ne "system" })
}

$allNames = @($byVersion.Values | ForEach-Object { $_ } | Select-Object -ExpandProperty name -Unique | Sort-Object)
$changeJsonl = Join-Path $referencesRoot "managed-dll-changes.jsonl"
if (Test-Path -LiteralPath $changeJsonl) { Remove-Item -LiteralPath $changeJsonl }
New-Item -ItemType File -Path $changeJsonl | Out-Null

$indexRows = @()
$addedRemovedRows = @()

foreach ($name in $allNames) {
    $rows = @()
    $presentVersions = @()
    $records = @{}

    foreach ($version in $Versions) {
        $record = @($byVersion[$version] | Where-Object { $_.name -eq $name } | Select-Object -First 1)
        if ($record.Count -gt 0) {
            $records[$version] = $record[0]
            $presentVersions += $version
        } else {
            $records[$version] = $null
        }
    }

    $sample = $records[$LatestVersion]
    if (-not $sample) {
        $sample = $records[$presentVersions[-1]]
    }

    $versionStates = foreach ($version in $Versions) {
        $r = $records[$version]
        if ($r) {
            "| $version | present | $($r.category) | $($r.assemblyVersion) | $($r.bytes) | $($r.sha256_12) |"
        } else {
            "| $version | absent |  |  |  |  |"
        }
    }

    $pairSummaries = @()
    for ($i = 1; $i -lt $Versions.Count; $i++) {
        $from = $Versions[$i - 1]
        $to = $Versions[$i]
        $old = $records[$from]
        $new = $records[$to]
        $kind = Get-ChangeKind -Old $old -New $new
        $pair = [pscustomobject]@{
            dll = $name
            from = $from
            to = $to
            change = $kind
            oldCategory = if ($old) { $old.category } else { "" }
            newCategory = if ($new) { $new.category } else { "" }
            oldSha256_12 = if ($old) { $old.sha256_12 } else { "" }
            newSha256_12 = if ($new) { $new.sha256_12 } else { "" }
            oldBytes = if ($old) { $old.bytes } else { $null }
            newBytes = if ($new) { $new.bytes } else { $null }
        }
        $pair | ConvertTo-Json -Compress | Add-Content -LiteralPath $changeJsonl -Encoding UTF8
        $pairSummaries += "- " + $from + " to " + $to + ": " + $kind

        if ($kind -in @("added", "removed")) {
            $addedRemovedRows += "| $name | $from to $to | $kind | $($pair.oldCategory) | $($pair.newCategory) |"
        }
    }

    $latestState = if ($records[$LatestVersion]) { "present in Latest/$LatestVersion" } else { "not present in Latest/$LatestVersion" }
    $doc = @()
    $doc += "# $name"
    $doc += ""
    $doc += "- Role: $(Get-Role -Assembly $sample)"
    $doc += "- Latest state: $latestState"
    $doc += "- Shared Unity/System runtime DLL: no"
    $doc += "- Category in latest/present sample: $($sample.category)"
    $doc += "- Assembly name: $($sample.assemblyName)"
    $doc += ""
    $doc += "## Version Presence"
    $doc += ""
    $doc += "| Version | State | Category | Assembly version | Bytes | SHA256-12 |"
    $doc += "| --- | --- | --- | ---: | ---: | --- |"
    $doc += $versionStates
    $doc += ""
    $doc += "## Changes"
    $doc += ""
    $doc += $pairSummaries
    $doc += ""
    $doc += "## Update Notes"
    $doc += ""
    $doc += '- If `changed`, assume public APIs, private fields, and Harmony transpiler IL patterns may need verification before porting a mod.'
    $doc += '- If `added` or `removed`, check whether a type moved from/to another assembly before deleting code or references.'
    $doc += '- For exact APIs, search `references/versions/<version>/types-game.jsonl` first, then decompile exact types with `ilspycmd`.'

    $safeName = Convert-ToSafeFileName -Name ($name -replace '\.dll$', '')
    $docPath = Join-Path $dllDocsRoot "$safeName.md"
    $doc | Set-Content -LiteralPath $docPath -Encoding UTF8

    $indexRows += "| [$name](managed-dlls/$safeName.md) | $($sample.category) | $latestState | $($presentVersions -join ', ') |"
}

$human = @()
$human += "# Managed DLLs Not Shared Across All Unity Games"
$human += ""
$human += 'This documentation excludes `Unity*`, `UnityEngine*`, `System*`, `mscorlib.dll`, and `netstandard.dll`. It includes Beat Saber game assemblies plus bundled third-party/platform assemblies from `Beat Saber_Data\Managed`.'
$human += ""
$human += '- Latest: `' + $LatestVersion + '`'
$human += "- Supported versions compared: $($Versions -join ', ')"
$human += '- Per-DLL docs: `docs/managed-dlls/`'
$human += '- Compact machine change log: `references/managed-dll-changes.jsonl`'
$human += ""
$human += "## Index"
$human += ""
$human += "| DLL | Category | Latest state | Present versions |"
$human += "| --- | --- | --- | --- |"
$human += $indexRows
$human += ""
$human += "## Added/Removed Between Supported Versions"
$human += ""
$human += "| DLL | Pair | Change | Old category | New category |"
$human += "| --- | --- | --- | --- | --- |"
if ($addedRemovedRows.Count) { $human += $addedRemovedRows } else { $human += "| None |  |  |  |  |" }
$human | Set-Content -LiteralPath (Join-Path $docsRoot "managed-dlls.md") -Encoding UTF8

$reference = @()
$reference += "# Managed DLL Change Reference"
$reference += ""
$reference += "Compact guide for non-Unity/non-System managed DLL docs."
$reference += ""
$reference += '- Human index: `docs/managed-dlls.md`'
$reference += '- Per-DLL docs: `docs/managed-dlls/<dll-name>.md`'
$reference += '- Machine change log: `references/managed-dll-changes.jsonl`'
$reference += ""
$reference += 'Use `rg ''"dll":"Main.dll"'' references/managed-dll-changes.jsonl` for quick pairwise changes.'
$reference += ""
$reference += 'Non-shared means category is not `unity` and not `system` in generated assembly inventories.'
$reference | Set-Content -LiteralPath (Join-Path $referencesRoot "managed-dlls.md") -Encoding UTF8

Write-Host "Generated non-shared managed DLL docs for $($allNames.Count) DLLs."
