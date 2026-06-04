# Zenject.dll

- Role: Dependency injection/runtime composition library used by Beat Saber
- Latest state: present in Latest/1.44.0
- Shared Unity/System runtime DLL: no
- Category in latest/present sample: game
- Assembly name: Zenject

## Version Presence

| Version | State | Category | Assembly version | Bytes | SHA256-12 |
| --- | --- | --- | ---: | ---: | --- |
| 1.29.1 | present | game | 0.0.0.0 | 511488 | 1c79a46871d8 |
| 1.40.8 | present | game | 0.0.0.0 | 550912 | 2031ff13d801 |
| 1.44.0 | present | game | 0.0.0.0 | 551424 | 8b80662c9029 |

## Changes

- 1.29.1 to 1.40.8: changed
- 1.40.8 to 1.44.0: changed

## Update Notes

- If `changed`, assume public APIs, private fields, and Harmony transpiler IL patterns may need verification before porting a mod.
- If `added` or `removed`, check whether a type moved from/to another assembly before deleting code or references.
- For exact APIs, search `references/versions/<version>/types-game.jsonl` first, then decompile exact types with `ilspycmd`.
