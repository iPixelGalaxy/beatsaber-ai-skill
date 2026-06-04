param(
    [string]$InstancesRoot = "",
    [string[]]$Versions = @("1.29.1", "1.40.8", "1.44.0"),
    [string]$LatestVersion = "1.44.0",
    [string]$OutputRoot = ""
)

$ErrorActionPreference = "Stop"

function Get-BSManagerInstancesRoot {
    $configPath = Join-Path $env:APPDATA "bs-manager\config.json"
    if (-not (Test-Path -LiteralPath $configPath)) { return "" }

    try {
        $config = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json
        $installFolder = $config.'installation-folder'
        if (-not $installFolder) { return "" }

        $candidate = Join-Path $installFolder "BSManager\BSInstances"
        if (Test-Path -LiteralPath $candidate) { return $candidate }
    }
    catch {
        return ""
    }

    return ""
}

function Get-SteamBeatSaberInstallRoot {
    $steamRoots = @()
    foreach ($key in @(
        "HKCU:\Software\Valve\Steam",
        "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam",
        "HKLM:\SOFTWARE\Valve\Steam"
    )) {
        try {
            $path = (Get-ItemProperty -Path $key -ErrorAction Stop).SteamPath
            if ($path) { $steamRoots += $path }
            $path = (Get-ItemProperty -Path $key -ErrorAction Stop).InstallPath
            if ($path) { $steamRoots += $path }
        }
        catch {}
    }

    $steamRoots = $steamRoots | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -Unique
    foreach ($steamRoot in $steamRoots) {
        $libraryRoots = @($steamRoot)
        $libraryFile = Join-Path $steamRoot "steamapps\libraryfolders.vdf"
        if (Test-Path -LiteralPath $libraryFile) {
            $content = Get-Content -LiteralPath $libraryFile -Raw
            foreach ($match in [regex]::Matches($content, '"path"\s+"([^"]+)"')) {
                $libraryRoots += ($match.Groups[1].Value -replace '\\\\', '\')
            }
        }

        foreach ($libraryRoot in ($libraryRoots | Select-Object -Unique)) {
            $candidate = Join-Path $libraryRoot "steamapps\common\Beat Saber"
            if (Test-Path -LiteralPath (Join-Path $candidate "Beat Saber_Data\Managed")) {
                return $candidate
            }
        }
    }

    return ""
}

function Resolve-InstancesRoot {
    param([string]$RequestedRoot)

    if ($RequestedRoot) {
        if (Test-Path -LiteralPath $RequestedRoot) { return $RequestedRoot }
        throw "InstancesRoot was provided but does not exist: $RequestedRoot"
    }

    $bsManagerRoot = Get-BSManagerInstancesRoot
    if ($bsManagerRoot) { return $bsManagerRoot }

    $steamRoot = Get-SteamBeatSaberInstallRoot
    if ($steamRoot) { return $steamRoot }

    throw "Could not find Beat Saber installs. Checked BSManager config at '$env:APPDATA\bs-manager\config.json' and Steam library folders. Ask the user for their Beat Saber install or BSManager instances root, then rerun with -InstancesRoot."
}

$InstancesRoot = Resolve-InstancesRoot -RequestedRoot $InstancesRoot
$instancesRootIsSingleInstall = Test-Path -LiteralPath (Join-Path $InstancesRoot "Beat Saber_Data\Managed")
if ($instancesRootIsSingleInstall -and $Versions.Count -gt 1) {
    throw "Resolved a single Steam Beat Saber install at '$InstancesRoot', but multiple versions were requested. Rerun with one -Versions value, or provide a BSManager instances root with -InstancesRoot."
}

if (-not $OutputRoot) {
    $skillRoot = Split-Path -Parent $PSScriptRoot
    $OutputRoot = Join-Path $skillRoot "references"
}

$docsRoot = Join-Path (Split-Path -Parent $PSScriptRoot) "docs"
$versionsRoot = Join-Path $OutputRoot "versions"
New-Item -ItemType Directory -Force -Path $versionsRoot, $docsRoot | Out-Null

$ilspy = (Get-Command ilspycmd -ErrorAction SilentlyContinue).Source
if (-not $ilspy) {
    throw "ilspycmd is required. Install with: dotnet tool install --global ilspycmd"
}

$relevantNames = @(
    "Assembly-CSharp", "Main", "GameplayCore", "GameInit", "DataModels", "BeatmapCore",
    "BeatSaber.", "BGLib.", "BGNet", "HMUI", "HMLib", "HMRendering", "Zenject",
    "VRUI", "Networking", "Core", "Colors", "Helpers", "Rendering", "Tweening",
    "SaberTrail", "Menu", "MockCore", "OverridableData", "PlatformUserModel"
)

function Get-AssemblyInfo {
    param([string]$Path)
    try {
        $name = [System.Reflection.AssemblyName]::GetAssemblyName($Path)
        return @{
            assemblyName = $name.Name
            assemblyVersion = $name.Version.ToString()
            culture = if ($name.CultureName) { $name.CultureName } else { "neutral" }
        }
    }
    catch {
        return @{
            assemblyName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
            assemblyVersion = ""
            culture = ""
        }
    }
}

function Get-Category {
    param([string]$Name)
    if ($Name -like "UnityEngine.*" -or $Name -like "Unity.*") { return "unity" }
    if ($Name -like "System.*" -or $Name -in @("System.dll", "mscorlib.dll", "netstandard.dll")) { return "system" }
    if ($Name -like "BeatSaber.*" -or $Name -like "BGLib.*" -or $Name -in @(
        "Assembly-CSharp.dll", "Main.dll", "GameplayCore.dll", "GameInit.dll", "DataModels.dll",
        "BeatmapCore.dll", "HMUI.dll", "HMLib.dll", "HMRendering.dll", "BGNetCore.dll",
        "BGNetLogging.dll", "Zenject.dll", "ZenjectExtension.dll", "VRUI.dll",
        "VRUI.Interfaces.dll", "Networking.dll", "Core.dll", "Colors.dll", "Helpers.dll",
        "Rendering.dll", "Tweening.dll", "SaberTrail.dll"
    )) { return "game" }
    return "third-party"
}

function Test-Relevant {
    param([string]$Name)
    foreach ($prefix in $relevantNames) {
        if ($Name.StartsWith($prefix)) { return $true }
    }
    return $false
}

function Convert-TypeLine {
    param([string]$Line)
    if (-not $Line.Trim()) { return $null }
    $parts = $Line.Trim() -split "\s+", 2
    if ($parts.Length -lt 2) { return $null }
    return @{ kind = $parts[0]; name = $parts[1] }
}

function Convert-ToReferencePath {
    param([string]$Path)
    if (-not $Path) { return "" }
    if ($Path.StartsWith($InstancesRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        return "<instance-root>" + $Path.Substring($InstancesRoot.Length)
    }
    return $Path
}

$supported = @()
$assemblyByVersion = @{}
$typeCountByVersion = @{}

foreach ($version in $Versions) {
    $instance = if ($instancesRootIsSingleInstall) { $InstancesRoot } else { Join-Path $InstancesRoot $version }
    $managed = Join-Path $instance "Beat Saber_Data\Managed"
    if (-not (Test-Path -LiteralPath $managed)) {
        throw "Missing Managed folder for $version at $managed"
    }

    $versionOut = Join-Path $versionsRoot $version
    New-Item -ItemType Directory -Force -Path $versionOut | Out-Null

    $dlls = Get-ChildItem -LiteralPath $managed -Filter "*.dll" | Sort-Object Name
    $assemblies = foreach ($dll in $dlls) {
        $info = Get-AssemblyInfo -Path $dll.FullName
        $hash = (Get-FileHash -LiteralPath $dll.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        [pscustomobject]@{
            name = $dll.Name
            category = Get-Category -Name $dll.Name
            relevant = Test-Relevant -Name $dll.Name
            bytes = $dll.Length
            sha256 = $hash
            sha256_12 = $hash.Substring(0, 12)
            assemblyName = $info.assemblyName
            assemblyVersion = $info.assemblyVersion
            path = $dll.FullName
        }
    }

    $assemblies | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $versionOut "assemblies.json") -Encoding UTF8
    $assemblyByVersion[$version] = @($assemblies)

    $typePath = Join-Path $versionOut "types-game.jsonl"
    if (Test-Path -LiteralPath $typePath) { Remove-Item -LiteralPath $typePath }
    New-Item -ItemType File -Path $typePath | Out-Null
    foreach ($asm in ($assemblies | Where-Object { $_.relevant })) {
        $dllPath = Join-Path $managed $asm.name
        foreach ($kind in @("c", "i", "s", "d", "e")) {
            $lines = & $ilspy --disable-updatecheck -l $kind $dllPath 2>$null
            foreach ($line in $lines) {
                $type = Convert-TypeLine -Line $line
                if ($type) {
                    [pscustomobject]@{
                        version = $version
                        assembly = $asm.name
                        kind = $type.kind
                        name = $type.name
                    } | ConvertTo-Json -Compress | Add-Content -LiteralPath $typePath -Encoding UTF8
                }
            }
        }
    }
    $typeCountByVersion[$version] = (Get-Content -LiteralPath $typePath | Measure-Object -Line).Lines

    $counts = $assemblies | Group-Object category | ForEach-Object { "$($_.Name): $($_.Count)" }
    $relevantList = $assemblies | Where-Object relevant | Select-Object -ExpandProperty name

    $md = @()
    $md += "# Beat Saber $version Managed DLL Index"
    $md += ""
    $md += '- Instance: `' + (Convert-ToReferencePath $instance) + '`'
    $md += '- Managed dir: `' + (Convert-ToReferencePath $managed) + '`'
    $generatedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
    $md += "- Generated: $generatedAt"
    $md += "- DLL count: $($assemblies.Count)"
    $md += "- Categories: $($counts -join "; ")"
    $md += '- Type index: `types-game.jsonl` contains game-facing type names only.'
    $md += ""
    $md += "## Relevant DLLs"
    $md += ""
    foreach ($name in $relevantList) { $md += '- `' + $name + '`' }
    $md += ""
    $md += "## Assembly Inventory"
    $md += ""
    $md += "| DLL | Category | Version | Bytes | SHA256-12 | Relevant |"
    $md += "| --- | --- | ---: | ---: | --- | --- |"
    foreach ($asm in $assemblies) {
        $md += "| $($asm.name) | $($asm.category) | $($asm.assemblyVersion) | $($asm.bytes) | $($asm.sha256_12) | $($asm.relevant) |"
    }
    $md | Set-Content -LiteralPath (Join-Path $versionOut "managed-index.md") -Encoding UTF8

    $doc = @()
    $doc += "# Beat Saber $version"
    $doc += ""
    $doc += 'Human-readable update notes for the `' + $version + '` reference set.'
    $doc += ""
    $doc += "## Install"
    $doc += ""
    $doc += '- Instance: `' + (Convert-ToReferencePath $instance) + '`'
    $doc += '- Managed assemblies: `' + (Convert-ToReferencePath $managed) + '`'
    $doc += '- Assembly inventory: `../references/versions/' + $version + '/managed-index.md`'
    $doc += '- Compact type index: `../references/versions/' + $version + '/types-game.jsonl`'
    $doc += ""
    $doc += "## What Was Captured"
    $doc += ""
    $doc += '- Every DLL in `Beat Saber_Data\Managed` was hashed and version-indexed.'
    $doc += '- Game-facing assemblies were indexed by type name for fast `rg` lookup.'
    $doc += "- Unity/System/third-party assemblies were inventoried but not type-dumped by default."
    $doc += ""
    $doc += "## Human Update Checklist"
    $doc += ""
    $doc += "- Confirm the game launches from this resolved install."
    $doc += '- Compare `managed-index.md` against the previous supported version for changed DLLs.'
    $doc += '- Search `types-game.jsonl` for renamed or removed APIs used by active mods.'
    $doc += "- Add migration notes here when a mod update reveals a breaking API change."
    $doc += '- Put mod-specific findings in `references/mods/<mod-name>.md`, not in this file.'
    $doc | Set-Content -LiteralPath (Join-Path $docsRoot "version-$version.md") -Encoding UTF8

    $supported += [pscustomobject]@{
        version = $version
        label = if ($version -eq $LatestVersion) { "Latest" } else { "" }
        instance = $instance
        managed = $managed
        dllCount = $assemblies.Count
        relevantDllCount = ($assemblies | Where-Object relevant).Count
    }
}

$supportMd = @()
$supportMd += "# Supported Beat Saber Versions"
$supportMd += ""
$supportMd += '- Latest: `' + $LatestVersion + '`'
$supportMd += '- Instances root: `<instance-root>`'
$supportMd += '- Update command: `.\scripts\build-managed-index.ps1`'
$supportMd += ""
$supportMd += "| Version | Label | DLLs | Relevant DLLs | Instance |"
$supportMd += "| --- | --- | ---: | ---: | --- |"
foreach ($item in $supported) {
    $supportMd += "| $($item.version) | $($item.label) | $($item.dllCount) | $($item.relevantDllCount) | ``$(Convert-ToReferencePath $item.instance)`` |"
}
$supportMd += ""
$supportMd += "## Loading Policy"
$supportMd += ""
$supportMd += 'Load one version at a time. Prefer `managed-index.md` for assembly identity and `types-game.jsonl` searched with `rg` for API names. Decompile exact types only when needed.'
$supportMd | Set-Content -LiteralPath (Join-Path $OutputRoot "supported-versions.md") -Encoding UTF8

$workflow = @()
$workflow += "# Beat Saber Skill Update Workflow"
$workflow += ""
$workflow += 'Use this when the user explicitly asks to update `$beatsaber` or process a new game version.'
$workflow += ""
$workflow += '1. Resolve install paths: first check BSManager config at `%APPDATA%\bs-manager\config.json`, then Steam libraries. If neither gives usable installs, ask the user once for their Beat Saber install or BSManager instances root.'
$workflow += '2. Add or confirm each requested version under the resolved root. For BSManager this is usually `<installation-folder>\BSManager\BSInstances\<version>`; for Steam this is the single Steam Beat Saber install.'
$workflow += '3. Update `SKILL.md` and `references/supported-versions.md` if supported versions or Latest changed.'
$workflow += '4. Run `.\scripts\build-managed-index.ps1 -Versions <versions> -LatestVersion <latest>` from the skill folder. Use `-InstancesRoot <path>` only when auto-discovery is wrong or unavailable.'
$workflow += '5. Run `.\scripts\build-managed-dll-docs.ps1 -Versions <versions> -LatestVersion <latest>` from the skill folder.'
$workflow += '6. Review `references/versions/<version>/managed-index.md` for unexpected missing DLLs.'
$workflow += '7. Review `docs/managed-dlls.md` and per-DLL docs for non-Unity/non-System assembly changes.'
$workflow += '8. Add human notes to `docs/version-<version>.md` after comparing active mod breakages.'
$workflow += '9. For each processed mod, create or update one file in `references/mods/` and list it in `references/mods/index.md`.'
$workflow += ""
$workflow += "Do not mix mod-specific migration notes into the global version index unless the finding applies broadly."
$workflow | Set-Content -LiteralPath (Join-Path $docsRoot "update-workflow.md") -Encoding UTF8

$comparison = @()
$comparison += "# Beat Saber Version Comparison"
$comparison += ""
$comparison += "Generated from managed DLL names, hashes, sizes, and compact type-index counts."
$comparison += ""
$comparison += "## Snapshot"
$comparison += ""
$comparison += "| Version | Label | DLLs | Relevant DLLs | Indexed game-facing types |"
$comparison += "| --- | --- | ---: | ---: | ---: |"
foreach ($item in $supported) {
    $comparison += "| $($item.version) | $($item.label) | $($item.dllCount) | $($item.relevantDllCount) | $($typeCountByVersion[$item.version]) |"
}

for ($i = 1; $i -lt $Versions.Count; $i++) {
    $from = $Versions[$i - 1]
    $to = $Versions[$i]
    $fromAssemblies = @($assemblyByVersion[$from])
    $toAssemblies = @($assemblyByVersion[$to])
    $fromNames = @($fromAssemblies | Select-Object -ExpandProperty name)
    $toNames = @($toAssemblies | Select-Object -ExpandProperty name)
    $added = @($toNames | Where-Object { $_ -notin $fromNames } | Sort-Object)
    $removed = @($fromNames | Where-Object { $_ -notin $toNames } | Sort-Object)
    $fromRelevant = @($fromAssemblies | Where-Object relevant | Select-Object -ExpandProperty name)
    $toRelevant = @($toAssemblies | Where-Object relevant | Select-Object -ExpandProperty name)
    $addedRelevant = @($toRelevant | Where-Object { $_ -notin $fromRelevant } | Sort-Object)
    $removedRelevant = @($fromRelevant | Where-Object { $_ -notin $toRelevant } | Sort-Object)
    $changedRelevant = @()
    foreach ($name in ($toRelevant | Where-Object { $_ -in $fromRelevant } | Sort-Object)) {
        $old = $fromAssemblies | Where-Object name -eq $name | Select-Object -First 1
        $new = $toAssemblies | Where-Object name -eq $name | Select-Object -First 1
        if ($old.sha256 -ne $new.sha256) {
            $changedRelevant += [pscustomobject]@{ name = $name; oldHash = $old.sha256_12; newHash = $new.sha256_12; oldBytes = $old.bytes; newBytes = $new.bytes }
        }
    }

    $comparison += ""
    $comparison += "## $from to $to"
    $comparison += ""
    $comparison += "- DLL count: $($fromAssemblies.Count) to $($toAssemblies.Count)"
    $comparison += "- Relevant DLL count: $($fromRelevant.Count) to $($toRelevant.Count)"
    $comparison += "- Indexed game-facing type count: $($typeCountByVersion[$from]) to $($typeCountByVersion[$to])"
    $comparison += "- Added DLLs: $($added.Count)"
    $comparison += "- Removed DLLs: $($removed.Count)"
    $comparison += "- Changed relevant DLL hashes: $($changedRelevant.Count)"
    $comparison += ""
    $comparison += "### Added Relevant DLLs"
    $comparison += ""
    if ($addedRelevant.Count) { foreach ($name in $addedRelevant) { $comparison += "- " + $name } } else { $comparison += "- None" }
    $comparison += ""
    $comparison += "### Removed Relevant DLLs"
    $comparison += ""
    if ($removedRelevant.Count) { foreach ($name in $removedRelevant) { $comparison += "- " + $name } } else { $comparison += "- None" }
    $comparison += ""
    $comparison += "### Changed Relevant DLLs"
    $comparison += ""
    if ($changedRelevant.Count) {
        $comparison += "| DLL | Old SHA12 | New SHA12 | Old bytes | New bytes |"
        $comparison += "| --- | --- | --- | ---: | ---: |"
        foreach ($item in $changedRelevant) {
            $comparison += "| $($item.name) | $($item.oldHash) | $($item.newHash) | $($item.oldBytes) | $($item.newBytes) |"
        }
    } else {
        $comparison += "- None"
    }
}
$comparison | Set-Content -LiteralPath (Join-Path $docsRoot "version-comparison.md") -Encoding UTF8

$modsRoot = Join-Path $OutputRoot "mods"
New-Item -ItemType Directory -Force -Path $modsRoot | Out-Null
$modsIndex = Join-Path $modsRoot "index.md"
if (-not (Test-Path -LiteralPath $modsIndex)) {
    @(
        "# Beat Saber Mod-Specific Skill Files",
        "",
        "This directory is intentionally opt-in.",
        "",
        'Only read a mod file when the user names that mod, asks to process that mod, or asks to update mod-specific `$beatsaber` knowledge.',
        "",
        "## Files",
        "",
        "- None yet."
    ) | Set-Content -LiteralPath $modsIndex -Encoding UTF8
}

Write-Host "Generated Beat Saber references in $OutputRoot"
