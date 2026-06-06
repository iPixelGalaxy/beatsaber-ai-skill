# Reactive.BeatSaber.Components

Knowledge note for Beat Saber 1.44.0 installs with `Reactive.BeatSaber.Components.dll` in `Plugins`.

## Assembly

- Plugin DLL: `<instance-root>\Plugins\Reactive.BeatSaber.Components.dll`
- Namespace: `Reactive.BeatSaber.Components`
- Helpers/assets: `Reactive.BeatSaber.BeatSaberStyle`, `BeatSaberResources`, `GameResources`, `MaterialCollection`, `SpriteCollection`

## Model

Reactive.BeatSaber.Components is code-first UI, not BSML tags.

Typical imports:

```csharp
using Reactive.BeatSaber.Components;
using Reactive.Components;
using Reactive.Yoga;
```

BeatLeader has many usage examples:

```powershell
rg "Reactive.BeatSaber.Components|new BsButton|new Slider|new ImageButton" "<repo>\Source"
```

## Common Components

- `BsButton`, `BsPrimaryButton`: text buttons. Common props: `Text`, `FontSize`, `Interactable`, `OnClick`.
- `ImageButton`, `ImageBsButton`, `BackgroundButton`: icon/background button variants.
- `Label`: text display. Common props: `Text`, `FontSize`, `Color`, `RichText`, `Alignment`, `Overflow`.
- `Slider`: slider with optional buttons. Common props: `Value`, `ValueRange`, `ValueStep`, `ShowButtons`, `ShowValueText`, `Interactable`, `ValueFormatter`.
- `InputField`: text input using `Keyboard`/`KeyboardModal`. Common props: `Text`, `Placeholder`, `MaxInputLength`, `TextApplicationContract`, `Keyboard`. `Text` setter is private; mutate via keyboard/controller flow or `ClearText()`.
- `Keyboard`, `KeyboardModal`: keyboard controller/modal for input fields.
- Other primitives: `Background`, `Image`, `WebImage`, `ColorPicker`, `Dropdown`, `TextDropdown`, `TextSegmentedControl`, `IconSegmentedControl`, `ScrollArea`, `Table`, `Toggle`, `Dialog`.

## Useful Extensions

`Reactive.BeatSaber.Components.ComponentExtensions`:

- `WithLabel(...)`: add label to a button/layout driver.
- `WithImage(...)`: add image to a button/layout driver.
- `InBackground(...)`, `InBlurBackground(...)`: wrap with Beat Saber style background.
- `InNamedRail(string text)`: wrap with named rail label.
- `WithModal(...)`: connect button click to modal.
- `Present(...)`: present modal relative to a Beat Saber view transform.

## Gameplay Setup

`BeatSaberMarkupLanguage.GameplaySetup.GameplaySetup.AddTab(name, resource, host, menuType)` expects a BSML resource. Reactive components are not a drop-in BSML tab replacement unless a project builds/patches a host view manually or has a bridge.

Safe BSML registration:

```csharp
GameplaySetup.Instance.AddTab("MyMod", "MyMod.Views.my-tab.bsml", host, MenuType.All);
```

Register after BSML DI is ready, e.g. `BS_Utils.Utilities.BSEvents.lateMenuSceneLoadedFresh`, not plugin `OnEnable`.

## Local Inspection

Use:

```powershell
ilspycmd -l c "<instance-root>\Plugins\Reactive.BeatSaber.Components.dll"
ilspycmd -t Reactive.BeatSaber.Components.Slider "<instance-root>\Plugins\Reactive.BeatSaber.Components.dll"
```
