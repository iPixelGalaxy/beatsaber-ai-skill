# Supported Beat Saber Versions

- Latest: `1.44.0`
- Instances root: `<instance-root>`
- Update command: `.\scripts\build-managed-index.ps1`

| Version | Label | DLLs | Relevant DLLs | Instance |
| --- | --- | ---: | ---: | --- |
| 1.29.1 |  | 152 | 16 | `<instance-root>\1.29.1` |
| 1.40.8 |  | 218 | 60 | `<instance-root>\1.40.8` |
| 1.44.0 | Latest | 247 | 64 | `<instance-root>\1.44.0` |

## Loading Policy

Load one version at a time. Prefer `managed-index.md` for assembly identity and `types-game.jsonl` searched with `rg` for API names. Decompile exact types only when needed.

