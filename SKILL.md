---
name: beatsaber
description: Opt-in Beat Saber modding and game-version reference skill. Use only when the user explicitly invokes `$beatsaber`, asks to update this Beat Saber skill, or asks to use a Beat Saber version/mod reference stored in this skill. Supports Beat Saber 1.29.1, 1.40.8, and Latest/1.44.0 references; do not trigger for generic C# or Unity work unless the user explicitly names Beat Saber or `$beatsaber`.
---

# Beat Saber

## Core Rule

Use this skill only for the current user request. Do not keep it active across turns unless the user invokes `$beatsaber` again or explicitly asks to keep working on Beat Saber skill content.

## Version Selection

- If the user says `Latest`, use Beat Saber `1.44.0` until `references/supported-versions.md` is updated.
- If the user names `1.29.1`, `1.40.8`, or `1.44.0`, use that exact version.
- If the target version is unclear, infer from the active repo only when obvious from project files; otherwise ask one short question.

## Install Path Discovery

Do not assume Beat Saber lives under a fixed drive or folder.

When exact install paths are needed:

1. Check BSManager config at `%APPDATA%\bs-manager\config.json`.
   - Read `installation-folder`.
   - BSManager instances are normally under `<installation-folder>\BSManager\BSInstances\<version>`.
   - `last-version-launched.path` may identify the latest active instance.
2. If BSManager config is missing or unusable, find the Steam Beat Saber install from Steam registry/library folders.
3. If neither discovery path gives a usable Beat Saber install, ask the user once where their Beat Saber installs are.

Use `<instance-root>` in docs and examples when possible. Resolve it at runtime before running `ilspycmd`, reading `Plugins`, or scanning `Beat Saber_Data\Managed`.

## What To Load

Load the smallest reference that answers the request:

- `references/supported-versions.md`: first stop for supported versions, install paths, and update policy.
- `references/versions/<version>/managed-index.md`: assembly inventory, hashes, and relevant DLL list for one game version.
- `references/versions/<version>/types-game.jsonl`: compact machine index of game-facing type names. Search it with `rg`; do not read the whole file unless necessary.
- `references/managed-dlls.md`: load when the user asks which managed DLLs are Beat Saber/game-specific or not shared Unity/System runtime DLLs.
- `references/managed-dll-changes.jsonl`: search with `rg` for pairwise non-Unity/non-System DLL changes across supported versions.
- `docs/managed-dlls.md`: human-readable index for every non-Unity/non-System managed DLL and links to per-DLL docs.
- `docs/version-<version>.md`: human-readable version notes and update checklist.
- `docs/update-workflow.md`: use only when the user asks to update this skill or process a new Beat Saber game version.
- `references/mods/`: reserved for per-mod skill files. Do not read mod-specific files unless the user names that mod, asks for that mod's migration, or the needed answer cannot be derived from version references.

## Mod Work

1. Identify target Beat Saber version.
2. Inspect the mod repo/project files normally.
3. Search the compact type index only for APIs touched by the mod:
   - `rg "AudioTimeSyncController" references/versions/1.44.0/types-game.jsonl`
   - `rg "BeatmapKey|BeatmapLevel" references/versions/1.40.8/types-game.jsonl`
4. Use `ilspycmd -t <TypeName> -r <ManagedDir> <DllPath>` for exact member bodies only when type names are insufficient.
5. Read `references/mods/<mod>.md` only when the user explicitly asks to process that mod-specific skill file or when a named mod has documented migration notes.

## Updating This Skill

Only update skill files when the user explicitly asks to update `$beatsaber`, this skill, supported game versions, managed DLL references, docs, or a mod-specific skill file.

When updating:

1. Edit `references/supported-versions.md` if version support or `Latest` changes.
2. Run `scripts/build-managed-index.ps1` to regenerate version indexes. It auto-discovers BSManager first, Steam second.
3. Run `scripts/build-managed-dll-docs.ps1` after assembly inventories change.
4. Update `docs/version-<version>.md` with human-readable notes.
5. Add or update exactly one file in `references/mods/` per mod when the user asks to process a mod.
6. Keep mod files disconnected from normal loading; reference them from `references/mods/index.md`, not from the main workflow unless necessary.

## Rebuild Command

From the skill folder:

```powershell
.\scripts\build-managed-index.ps1
.\scripts\build-managed-dll-docs.ps1
```

Override paths when needed:

```powershell
.\scripts\build-managed-index.ps1 -InstancesRoot '<instance-root>' -LatestVersion '1.44.0'
```
