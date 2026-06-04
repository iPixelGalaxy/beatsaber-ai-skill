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

## Mod-Specific Notes

Mod references live under `references/mods/`. They should only be read when the user asks about that mod or asks to update mod-specific `$beatsaber` knowledge.
