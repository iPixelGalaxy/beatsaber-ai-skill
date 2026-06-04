# Mono.Security.dll

- Role: Mono framework support assembly bundled with the game
- Latest state: present in Latest/1.44.0
- Shared Unity/System runtime DLL: no
- Category in latest/present sample: third-party
- Assembly name: Mono.Security

## Version Presence

| Version | State | Category | Assembly version | Bytes | SHA256-12 |
| --- | --- | --- | ---: | ---: | --- |
| 1.29.1 | present | third-party | 4.0.0.0 | 309248 | 2b7651b398dc |
| 1.40.8 | present | third-party | 4.0.0.0 | 241152 | d29150bcd02b |
| 1.44.0 | present | third-party | 4.0.0.0 | 241152 | 82cd95a77ba1 |

## Changes

- 1.29.1 to 1.40.8: changed
- 1.40.8 to 1.44.0: changed

## Update Notes

- If `changed`, assume public APIs, private fields, and Harmony transpiler IL patterns may need verification before porting a mod.
- If `added` or `removed`, check whether a type moved from/to another assembly before deleting code or references.
- For exact APIs, search `references/versions/<version>/types-game.jsonl` first, then decompile exact types with `ilspycmd`.
