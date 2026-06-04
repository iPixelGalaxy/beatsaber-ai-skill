# nunit.framework.dll

- Role: Third-party or platform library bundled with this Beat Saber install
- Latest state: present in Latest/1.44.0
- Shared Unity/System runtime DLL: no
- Category in latest/present sample: third-party
- Assembly name: nunit.framework

## Version Presence

| Version | State | Category | Assembly version | Bytes | SHA256-12 |
| --- | --- | --- | ---: | ---: | --- |
| 1.29.1 | present | third-party | 3.5.0.0 | 329728 | e388e140954d |
| 1.40.8 | present | third-party | 3.5.0.0 | 291840 | d3fe5ce66fba |
| 1.44.0 | present | third-party | 3.5.0.0 | 291840 | 25466626abfe |

## Changes

- 1.29.1 to 1.40.8: changed
- 1.40.8 to 1.44.0: changed

## Update Notes

- If `changed`, assume public APIs, private fields, and Harmony transpiler IL patterns may need verification before porting a mod.
- If `added` or `removed`, check whether a type moved from/to another assembly before deleting code or references.
- For exact APIs, search `references/versions/<version>/types-game.jsonl` first, then decompile exact types with `ilspycmd`.
