# Mono.Posix.dll

- Role: Mono framework support assembly bundled with the game
- Latest state: present in Latest/1.44.0
- Shared Unity/System runtime DLL: no
- Category in latest/present sample: third-party
- Assembly name: Mono.Posix

## Version Presence

| Version | State | Category | Assembly version | Bytes | SHA256-12 |
| --- | --- | --- | ---: | ---: | --- |
| 1.29.1 | present | third-party | 4.0.0.0 | 212480 | a33abceffeaa |
| 1.40.8 | present | third-party | 4.0.0.0 | 214528 | 79aeb34d48d7 |
| 1.44.0 | present | third-party | 4.0.0.0 | 214528 | 17a042d9f9e6 |

## Changes

- 1.29.1 to 1.40.8: changed
- 1.40.8 to 1.44.0: changed

## Update Notes

- If `changed`, assume public APIs, private fields, and Harmony transpiler IL patterns may need verification before porting a mod.
- If `added` or `removed`, check whether a type moved from/to another assembly before deleting code or references.
- For exact APIs, search `references/versions/<version>/types-game.jsonl` first, then decompile exact types with `ilspycmd`.
