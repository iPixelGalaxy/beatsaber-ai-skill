# BS_Utils

Knowledge note for Beat Saber 1.44.0 installs with `BS_Utils.dll` in `Plugins`.

## Assembly

- Plugin DLL: `<instance-root>\Plugins\BS_Utils.dll`
- Main namespaces:
  - `BS_Utils.Utilities`
  - `BS_Utils.Gameplay`

## Startup

`BS_Utils.Utilities.BSEvents.OnLoad()` creates the persistent `BSEvents` GameObject if needed. BS_Utils itself normally calls this from its plugin lifecycle.

For mods that depend on BS_Utils, add manifest dependency using local installed version range. For a 1.44.0 instance observed with `1.14.3`, use:

```json
"BS Utils": "^1.14.0"
```

## Menu Scene Events

`BS_Utils.Utilities.BSEvents` exposes:

- `menuSceneActive`
- `menuSceneLoaded`
- `earlyMenuSceneLoadedFresh`
- `menuSceneLoadedFresh` obsolete
- `lateMenuSceneLoadedFresh`
- `gameSceneActive`
- `gameSceneLoaded`

Useful pattern for BSML GameplaySetup tabs:

```csharp
using BeatSaberMarkupLanguage.GameplaySetup;
using BS_Utils.Utilities;

BSEvents.lateMenuSceneLoadedFresh += OnMenuSceneLoadedFresh;

private void OnMenuSceneLoadedFresh(ScenesTransitionSetupDataSO data)
{
    GameplaySetup.Instance.RemoveTab("MyMod");
    GameplaySetup.Instance.AddTab("MyMod", "MyMod.Views.my-tab.bsml", host, MenuType.All);
}
```

Do not access `GameplaySetup.Instance` in plugin `OnEnable`; BSML DI can be too early.

## Menu Selection Events

`BSEvents` wires these from Beat Saber menu controllers during fresh menu load:

- `difficultySelected`
  - Installed 1.44.0 signature: `Action<StandardLevelDetailViewController>`
- `characteristicSelected`
  - `Action<BeatmapCharacteristicSegmentedControlController, BeatmapCharacteristicSO>`
- `levelPackSelected`
  - `Action<LevelSelectionNavigationController, BeatmapLevelPack>`
- `levelSelected`
  - Installed 1.44.0 signature: `Action<LevelCollectionViewController, BeatmapLevel>`

Use `levelSelected` for selected level in menu UI:

```csharp
BSEvents.levelSelected += OnLevelSelected;

private void OnLevelSelected(LevelCollectionViewController controller, BeatmapLevel level)
{
    // level.levelID, level.songName, level.songAuthorName
}
```

Unsubscribe in `OnDisable`:

```csharp
BSEvents.levelSelected -= OnLevelSelected;
```

## Game Events

Common gameplay events:

- `songPaused`
- `songUnpaused`
- `LevelFinished`
- `levelCleared`
- `levelQuit`
- `levelFailed`
- `levelRestarted`
- `noteWasCut`
- `noteWasMissed`
- `multiplierDidChange`
- `comboDidChange`
- `comboDidBreak`
- `scoreDidChange`
- `energyDidChange`
- `energyReachedZero`
- `beatmapEvent`

## LevelData

`BS_Utils.Plugin.LevelData` stores active gameplay setup data after BS_Utils Harmony patches capture scene setup:

- `IsSet`
- `Mode`
- `GameplayCoreSceneSetupData`

Use this for active gameplay context, not for menu selection UI. For menu selection, prefer `BSEvents.levelSelected`.

## Version Caveat

Some older source snapshots show `levelSelected` as `Action<BeatmapLevelSO, PreviewDifficultyBeatmap>`. The installed 1.44.0 DLL inspected locally exposes:

```csharp
public static event Action<LevelCollectionViewController, BeatmapLevel> levelSelected;
```

Always inspect local `BS_Utils.dll` with `ilspycmd` when signature matters.
