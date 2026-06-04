# Oculus.Platform.dll

- Role: Third-party or platform library bundled with this Beat Saber install
- Latest state: not present in Latest/1.44.0
- Shared Unity/System runtime DLL: no
- Category in latest/present sample: third-party
- Assembly name: Oculus.Platform

## Version Presence

| Version | State | Category | Assembly version | Bytes | SHA256-12 |
| --- | --- | --- | ---: | ---: | --- |
| 1.29.1 | present | third-party | 0.0.0.0 | 176128 | 653116984254 |
| 1.40.8 | absent |  |  |  |  |
| 1.44.0 | absent |  |  |  |  |

## Changes

- 1.29.1 to 1.40.8: removed
- 1.40.8 to 1.44.0: absent

## Update Notes

- If `changed`, assume public APIs, private fields, and Harmony transpiler IL patterns may need verification before porting a mod.
- If `added` or `removed`, check whether a type moved from/to another assembly before deleting code or references.
- For exact APIs, search `references/versions/<version>/types-game.jsonl` first, then decompile exact types with `ilspycmd`.
