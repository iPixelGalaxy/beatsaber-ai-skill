# BGLib.UnityExtension.dll

- Role: Beat Games shared/support library bundled with Beat Saber
- Latest state: present in Latest/1.44.0
- Shared Unity/System runtime DLL: no
- Category in latest/present sample: game
- Assembly name: BGLib.UnityExtension

## Version Presence

| Version | State | Category | Assembly version | Bytes | SHA256-12 |
| --- | --- | --- | ---: | ---: | --- |
| 1.29.1 | absent |  |  |  |  |
| 1.40.8 | present | game | 0.0.0.0 | 52736 | a4d506858549 |
| 1.44.0 | present | game | 0.0.0.0 | 61440 | 31baaa865632 |

## Changes

- 1.29.1 to 1.40.8: added
- 1.40.8 to 1.44.0: changed

## Update Notes

- If `changed`, assume public APIs, private fields, and Harmony transpiler IL patterns may need verification before porting a mod.
- If `added` or `removed`, check whether a type moved from/to another assembly before deleting code or references.
- For exact APIs, search `references/versions/<version>/types-game.jsonl` first, then decompile exact types with `ilspycmd`.
