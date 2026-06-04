# IPA.Injector.dll

- Role: BSIPA loader/injector assembly bundled in this modded install
- Latest state: present in Latest/1.44.0
- Shared Unity/System runtime DLL: no
- Category in latest/present sample: third-party
- Assembly name: IPA.Injector

## Version Presence

| Version | State | Category | Assembly version | Bytes | SHA256-12 |
| --- | --- | --- | ---: | ---: | --- |
| 1.29.1 | present | third-party | 4.3.6.0 | 32256 | 1c9b4c8e71f6 |
| 1.40.8 | present | third-party | 4.3.6.0 | 27648 | d90f380bcd09 |
| 1.44.0 | present | third-party | 4.3.7.0 | 29184 | 52203a9d5663 |

## Changes

- 1.29.1 to 1.40.8: changed
- 1.40.8 to 1.44.0: changed

## Update Notes

- If `changed`, assume public APIs, private fields, and Harmony transpiler IL patterns may need verification before porting a mod.
- If `added` or `removed`, check whether a type moved from/to another assembly before deleting code or references.
- For exact APIs, search `references/versions/<version>/types-game.jsonl` first, then decompile exact types with `ilspycmd`.
