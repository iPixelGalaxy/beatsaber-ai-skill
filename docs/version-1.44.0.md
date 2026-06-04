# Beat Saber 1.44.0

Human-readable update notes for the `1.44.0` reference set.

## Install

- Instance: `<instance-root>\1.44.0`
- Managed assemblies: `<instance-root>\1.44.0\Beat Saber_Data\Managed`
- Assembly inventory: `../references/versions/1.44.0/managed-index.md`
- Compact type index: `../references/versions/1.44.0/types-game.jsonl`

## What Was Captured

- Every DLL in `Beat Saber_Data\Managed` was hashed and version-indexed.
- Game-facing assemblies were indexed by type name for fast `rg` lookup.
- Unity/System/third-party assemblies were inventoried but not type-dumped by default.

## Human Update Checklist

- Confirm the game launches from this resolved install.
- Compare `managed-index.md` against the previous supported version for changed DLLs.
- Search `types-game.jsonl` for renamed or removed APIs used by active mods.
- Add migration notes here when a mod update reveals a breaking API change.
- Put mod-specific findings in `references/mods/<mod-name>.md`, not in this file.

