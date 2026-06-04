# Beat Saber Skill Update Workflow

Use this when the user explicitly asks to update `$beatsaber` or process a new game version.

1. Resolve install paths: first check BSManager config at `%APPDATA%\bs-manager\config.json`, then Steam libraries. If neither gives usable installs, ask the user once for their Beat Saber install or BSManager instances root.
2. Add or confirm each requested version under the resolved root. For BSManager this is usually `<installation-folder>\BSManager\BSInstances\<version>`; for Steam this is the single Steam Beat Saber install.
3. Update `SKILL.md` and `references/supported-versions.md` if supported versions or Latest changed.
4. Run `.\scripts\build-managed-index.ps1 -Versions <versions> -LatestVersion <latest>` from the skill folder. Use `-InstancesRoot <path>` only when auto-discovery is wrong or unavailable.
5. Run `.\scripts\build-managed-dll-docs.ps1 -Versions <versions> -LatestVersion <latest>` from the skill folder.
6. Review `references/versions/<version>/managed-index.md` for unexpected missing DLLs.
7. Review `docs/managed-dlls.md` and per-DLL docs for non-Unity/non-System assembly changes.
8. Add human notes to `docs/version-<version>.md` after comparing active mod breakages.
9. For each processed mod, create or update one file in `references/mods/` and list it in `references/mods/index.md`.

Do not mix mod-specific migration notes into the global version index unless the finding applies broadly.

