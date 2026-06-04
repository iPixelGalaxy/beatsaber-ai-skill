To be completely clear, this could be completely wrong, if some modder comes across this and wants to PR some suggestions, I'll happily take em if I've heard of you haha :)

# Beat Saber AI Skill

Opt-in Codex skill for Beat Saber modding references.

This skill is designed to trigger only when explicitly requested with `$beatsaber` or when the user asks to update/use this Beat Saber skill. It contains compact machine-oriented references for Codex plus human-readable documentation for Beat Saber version updates.

## Supported Versions

- Beat Saber `1.29.1`
- Beat Saber `1.40.8`
- Beat Saber `1.44.0` as `Latest`

## Contents

- `SKILL.md`: main opt-in skill instructions and load policy.
- `scripts/`: rebuild scripts for managed DLL indexes and docs.
- `references/`: compact references, version indexes, type lists, and mod-specific notes.
- `docs/`: human-readable managed DLL and version documentation.
- `agents/`: optional skill metadata.

## Install Path Behavior

The skill does not assume a fixed Beat Saber install path.

When install paths are needed, it resolves them in this order:

1. BSManager config at `%APPDATA%\bs-manager\config.json`
2. Steam registry and library folders
3. Ask the user for their Beat Saber install or BSManager instances root

Docs use placeholders such as `<instance-root>`, `<workspace>`, and `<skill-root>` where paths are environment-specific.

## Updating References

From the skill root:

```powershell
.\scripts\build-managed-index.ps1
.\scripts\build-managed-dll-docs.ps1
```

Use `-InstancesRoot <path>` only when auto-discovery is wrong or unavailable.

## Installing Locally

From a local checkout:

```powershell
.\install.ps1
```

By default this installs to `%USERPROFILE%\.codex\skills\beatsaber`, or `$env:CODEX_HOME\skills\beatsaber` when `CODEX_HOME` is set. On Linux/macOS, the default is `~/.codex/skills/beatsaber`, or `$CODEX_HOME/skills/beatsaber` when `CODEX_HOME` is set.

Rerun the installer to update an existing install. Existing installs are moved to a timestamped backup by default.

To replace without a backup:

```powershell
.\install.ps1 -NoBackup
```

## Install From GitHub

Repository URL:

```text
https://github.com/iPixelGalaxy/beatsaber-ai-skill.git
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/iPixelGalaxy/beatsaber-ai-skill/master/install.ps1'))) -RepoUrl 'https://github.com/iPixelGalaxy/beatsaber-ai-skill.git'
```

PowerShell on Linux/macOS:

```powershell
& ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/iPixelGalaxy/beatsaber-ai-skill/master/install.ps1'))) -RepoUrl 'https://github.com/iPixelGalaxy/beatsaber-ai-skill.git'
```

Linux/macOS Bash:

```bash
curl -fsSL https://raw.githubusercontent.com/iPixelGalaxy/beatsaber-ai-skill/master/install.sh | bash -s -- --repo-url 'https://github.com/iPixelGalaxy/beatsaber-ai-skill.git'
```

All three commands are rerunnable. Rerunning installs the latest repository contents and backs up the previous install. Add `-NoBackup` for PowerShell or `--no-backup` for Bash to replace without keeping a backup.

Install a specific branch, tag, or commit:

```powershell
.\install.ps1 -RepoUrl 'https://github.com/iPixelGalaxy/beatsaber-ai-skill.git' -Ref '<branch-or-tag-or-commit>'
```

```bash
./install.sh --repo-url 'https://github.com/iPixelGalaxy/beatsaber-ai-skill.git' --ref '<branch-or-tag-or-commit>'
```

## Mod-Specific Notes

Mod references live under `references/mods/`. They should only be read when the user asks about that mod or asks to update mod-specific `$beatsaber` knowledge.
