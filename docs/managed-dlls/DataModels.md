# DataModels.dll

- Role: Core Beat Saber gameplay/data assembly
- Latest state: present in Latest/1.44.0
- Shared Unity/System runtime DLL: no
- Category in latest/present sample: game
- Assembly name: DataModels

## Version Presence

| Version | State | Category | Assembly version | Bytes | SHA256-12 |
| --- | --- | --- | ---: | ---: | --- |
| 1.29.1 | absent |  |  |  |  |
| 1.40.8 | present | game | 0.0.0.0 | 523264 | b95112a1a581 |
| 1.44.0 | present | game | 0.0.0.0 | 506368 | b00ec1d9bf35 |

## Changes

- 1.29.1 to 1.40.8: added
- 1.40.8 to 1.44.0: changed

## Update Notes

- If `changed`, assume public APIs, private fields, and Harmony transpiler IL patterns may need verification before porting a mod.
- If `added` or `removed`, check whether a type moved from/to another assembly before deleting code or references.
- For exact APIs, search `references/versions/<version>/types-game.jsonl` first, then decompile exact types with `ilspycmd`.
