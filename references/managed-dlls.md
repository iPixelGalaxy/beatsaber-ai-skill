# Managed DLL Change Reference

Compact guide for non-Unity/non-System managed DLL docs.

- Human index: `docs/managed-dlls.md`
- Per-DLL docs: `docs/managed-dlls/<dll-name>.md`
- Machine change log: `references/managed-dll-changes.jsonl`

Use `rg '"dll":"Main.dll"' references/managed-dll-changes.jsonl` for quick pairwise changes.

Non-shared means category is not `unity` and not `system` in generated assembly inventories.
