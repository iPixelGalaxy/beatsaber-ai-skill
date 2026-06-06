# BeatSaberCinema

Reference notes from local repo `D:\Development\Beat Saber\BeatSaberCinema` for Beat Saber 1.44.0 style menu selection UI.

## Selected Level Detection

Cinema does not depend on `BS_Utils.BSEvents.levelSelected` for its video tab. It patches Beat Saber menu controllers directly and broadcasts its own event:

```csharp
[HarmonyPatch(typeof(LevelCollectionViewController), "HandleLevelCollectionTableViewDidSelectLevel")]
public class LevelSelectionPatch
{
    public static void Prefix(BeatmapLevel level)
    {
        Events.SetSelectedLevel(level);
    }
}
```

It also clears selected level when pack/main/multiplayer menu changes:

```csharp
[HarmonyPatch(typeof(LevelCollectionViewController), "HandleLevelCollectionTableViewDidSelectPack")]
[HarmonyPatch(typeof(MainMenuViewController), "DidActivate")]
[HarmonyPatch(typeof(LobbySetupViewController), "DidActivate")]
```

For 1.44.0, `LevelCollectionViewController` contains:

- `public event Action<LevelCollectionViewController, BeatmapLevel> didSelectLevelEvent`
- `public void SelectLevel(BeatmapLevel beatmapLevel)`
- `private void HandleLevelCollectionTableViewDidSelectLevel(LevelCollectionTableView tableView, BeatmapLevel level)`
- `private void HandleLevelCollectionTableViewDidSelectPack(LevelCollectionTableView tableView)`

Use string Harmony method names for private/protected methods because `nameof(...)` cannot compile against inaccessible members.

## UI Refresh Pattern

Cinema injects concrete UI components and sets text directly:

```csharp
[UIComponent("no-video-text")]
private readonly TextMeshProUGUI _noVideoText = null!;
```

Then update:

```csharp
_noVideoText.text = "No level selected";
```

It also attaches a small `MonoBehaviour` to the BSML root object and refreshes when the tab becomes active:

```csharp
[UIObject("root-object")]
private readonly GameObject _root = null!;

_menuStatus = _root.AddComponent<VideoMenuStatus>();
_menuStatus.DidEnable += StatusViewerDidEnable;
```

This is safer than relying only on BSML `text='~value'` plus parser refresh events for status labels in GameplaySetup tabs.
