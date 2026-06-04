# BSML / BeatSaberMarkupLanguage Reference

Use this file only when the user asks about BSML, BeatSaberMarkupLanguage, BSML views, settings/gameplay tabs, BSML parser behavior, or a BSML version migration. Do not load this file for unrelated Beat Saber or unrelated mod work.

## Installed Versions

| Beat Saber | BSML assembly | Plugin path | SHA256 | Notes |
|---|---:|---|---|---|
| 1.29.1 | 1.6.10.0 | `<instance-root>\1.29.1\Plugins\BSML.dll` | `950DCEB85D2045D0347FA0DE461C1162EA3427090CA3C2DF42B6FAF5643EF6A1` | 374 exported/local types found. Install has no adjacent `BSML.xml`. Embedded resources include `Views.main-menu-screen.bsml` and manifest. |
| 1.40.8 | 1.12.5.0 | `<instance-root>\1.40.8\Plugins\BSML.dll` | `77E8E4466ED33C9DCAACBA628415A9A96A3534780FCDC2632C018C7A0385ADA0` | 434 types, 228 XML documented members. Embedded localization CSV and expanded views/settings/gameplay resources. |
| 1.44.0 / Latest | 1.14.1.0 | `<instance-root>\1.44.0\Plugins\BSML.dll` | `444F7F0EF5B1A166E08E2814DA5C6FC10C2BDE8E6782DCCAC9C93976023E58F6` | 431 types, 237 XML documented members. Installed DLL is newer than the local source snapshot; use decompile/XML for exact 1.44 behavior. |

Local source repo observed at `<workspace>\BeatSaberMarkupLanguage`. It was clean on `master`, with `origin/master` at `1837c3216cd8fdcab9671637f319e0746699cc66` and `origin/beat-saber-1-40-9` at `b5ef4be...`. The local source project currently targets game `1.40.9`, BSML version `1.12.6`, so it is useful for architecture and 1.40-era behavior, but it is not authoritative for installed BSML 1.14.1 on Beat Saber 1.44.0.

## What BSML Is

BSML is a UI construction layer for Beat Saber mods. It parses embedded `.bsml` XML-like markup into Unity/HMUI objects, binds markup attributes to a host object, and provides integration points for mod settings pages, gameplay setup tabs, menu buttons, floating screens, and custom view controllers.

The core runtime is `BeatSaberMarkupLanguage.BSMLParser`. It is a Zenject singleton and is only safe after its bindings are installed and `IInitializable.Initialize()` has run. If parsing happens too early, parser calls can fail because tags, macros, type handlers, and `BeatSaberUI.DiContainer` are not ready.

## Parser Contract

Important parser prefixes:

- `macro.`: invokes a macro tag. Example: `macro.if`, `macro.for-each`.
- `~`: binds an attribute value to a host `[UIValue]`/field/property. Example: `text="~title"`.
- `#`: subscribes an event/action name. Example: `on-click="#clicked"`.

Important parser attributes and pseudo-properties:

- `id`: binds the created object/component into host members marked `[UIComponent]` or `[UIObject]`.
- `tags`: adds object tags into `BSMLParserParams`; later macros or host code can retrieve tagged objects.
- `_children`: internal pseudo-property for raw child markup.
- `post-parse`: emitted after child creation and type after-parse handling.

Host member discovery:

- `[UIAction("id")]` exposes a method as an action.
- `[UIValue("id")]` exposes a field/property as a value.
- `[UIComponent("id")]` receives a component created from markup by `id`.
- `[UIObject("id")]` receives the created object by `id`.
- `[UIParams]` receives the active `BSMLParserParams`.
- `[ViewDefinition("resource.path.bsml")]` overrides automatic view resource lookup.
- `HostOptionsAttribute` can change field/property/method access modes. With permissive modes, raw member names can also be used, not just explicit attributes.

Binding details:

- Attribute values beginning with `~` become `BSMLPropertyValue` references into the host.
- If the host implements `INotifyPropertyChanged`, type handlers can subscribe and update UI when host properties change.
- `[UIValue]` fields and properties can collide; code notes field values can take precedence over property values.
- Missing tags/macros/actions/values are version-sensitive: 1.40+ has a more specific exception hierarchy than 1.29.1.

## Tags And Macros

Common tag aliases in the 1.40-era source:

- Layout: `bg`, `background`, `div`, `vertical`, `horizontal`, `stack`, `grid`, `scroll-view`, `scrollable-container`, `vertical-scroll-indicator`, `scroll-indicator`, `settings-scroll-view`, `scrollable-settings-container`, `settings-container`.
- Text/buttons/images: `text`, `label`, `button`, `primary-button`, `action-button`, `button-with-icon`, `icon-button`, `clickable-text`, `image`, `img`, `raw-image`, `clickable-image`, `loading`, `loading-indicator`, `page-button`, `pg-button`.
- Lists/tabs/modals: `list`, `custom-list`, `leaderboard`, `tab-select`, `tab-selector`, `tab`, `modal`, `modal-keyboard`, `modal-color-picker`, `text-page`.
- Segmented controls: `text-segments`, `icon-segments`, `vertical-icon-segments`.
- Settings: `toggle-setting`, `bool-setting`, `checkbox-setting`, `checkbox`, `slider-setting`, `list-slider-setting`, `list-setting`, `dropdown-list-setting`, `increment-setting`, `string-setting`, `color-setting`, `settings-submenu`.
- Gameplay modifiers: `modifier-container`, `modifier`.

Macros:

- `macro.define`: defines a name/value alias. Parameters: `name`/`id`, `value`.
- `macro.if`: conditionally parses children. Parameters: `bool`/`value`.
- `macro.for-each`: repeats children for hosts/items. Parameters: `hosts`/`items`, optional `pass-back-tags`.
- `macro.as-host`: parses children against another host. Parameter: `host`.
- `macro.reparent`: reparents one or more transforms. Parameters: `transform`, `transforms`.

## Core APIs

`BSMLParser`:

- `Parse(string bsml, GameObject parent, object host)` and XContainer overloads create UI under a parent.
- Adds actions, values, components, object tags, and events to `BSMLParserParams`.
- Calls `HandleType` during attribute application, then after-children/after-parse hooks.

`BeatSaberUI`:

- Creates Zenject-aware `ViewController` and `FlowCoordinator` instances.
- Exposes main UI services such as `DiContainer`, `MainFlowCoordinator`, raycaster/cache, hover hint controller, UI audio manager, and font/material helpers.
- Supports text helpers, font cloning, TMP font creation, and image loading from URL/path/resource/base-game sprite syntax.
- 1.44 XML exposes `MainTextFont`, `MonochromeTextFont`, `MainUIFontMaterial`, and `MainFlatUIFontMaterial`; local 1.40-era source does not fully match that installed API.

View controller helpers:

- `BSMLViewController`: parses inline `Content` on first activation and shows parse errors as fallback content.
- `BSMLResourceViewController`: loads a BSML resource from an assembly/resource name.
- `BSMLAutomaticViewController`: derives the `.bsml` resource name from namespace/class name unless `[ViewDefinition]` is present; debug builds can hot reload.

Menu/settings/gameplay helpers:

- `BSMLSettings.AddSettingsMenu(string name, string resource, object host)` adds mod settings from an embedded resource. It uses `Assembly.GetCallingAssembly()` for resource ownership.
- `BSMLSettings.RemoveSettingsMenu(object host)` removes a settings menu by host.
- `GameplaySetup.AddTab(string name, string resource, object host)` and overload with `MenuType` add gameplay setup tabs. Tabs are sorted and filtered for Campaign/Solo/Online/Custom.
- `GameplaySetup.RemoveTab(string name)` removes a tab.
- `MenuButtons.RegisterButton(MenuButton)` adds main menu buttons; duplicate button text is rejected and displayed buttons are sorted by stripped text.
- `FloatingScreen.CreateFloatingScreen(...)` creates an HMUI floating screen with optional grab handle, curved canvas settings, raycaster, and world transform.

## Version Notes

### Beat Saber 1.29.1 / BSML 1.6.10

This is the older compatibility baseline. The installed DLL has fewer types and no adjacent XML docs. It has older naming and error behavior:

- `BSMLResourceException` exists before the newer specific resource/action/tag/value exception split.
- `HotReloadableViewController`, `LocalizableText`, `FloatingScreenMoverPointer`, and top-level test/helper classes exist in this era but not in 1.40.8.
- Embedded resources are much smaller; observed view resource is `BeatSaberMarkupLanguage.Views.main-menu-screen.bsml`.
- Expect older Beat Saber/HMUI/TextMeshPro integration points and fewer dedicated patches.

When supporting 1.29.1, avoid assuming the 1.40+ exception classes, `MainMenuAwaiter`, newer utility namespaces, or the newer font/localization patch behavior exists.

### Beat Saber 1.40.8 / BSML 1.12.5

This is the best documented installed version. It has XML docs and the local source is close to it.

Major changes relative to 1.29.1:

- Specific parser/runtime exceptions appear: `ActionNotFoundException`, `BSMLParserException`, `MacroNotFoundException`, `MissingAttributeException`, `ParseException`, `ResourceNotFoundException`, `TagNotFoundException`, `TypeHandlerException`, `UnityWebRequestException`, and `ValueNotFoundException`.
- Utility infrastructure expands: `LocalizationModelExtensions`, `MainMenuAwaiter`, `NotifiableSingleton`, `PersistentSingleton`, `SortedList`, `ZenjectSingleton`, and object extension helpers.
- `GraphicHandler` and several new TMP/TableView/ScrollView/Localization patches appear.
- Settings and gameplay setup tests/helpers move under `Settings` and `GameplaySetup` namespaces.
- The plugin uses BSIPA single-start init, Harmony id `com.monkeymanboy.BeatSaberMarkupLanguage`, async font fallback setup, `MainSystemInitAwaiter`, and `MainMenuAwaiter`.
- Main menu bindings in the 1.40-era source patch `PCAppInit.InstallBindings` and `MainSettingsMenuViewControllersInstaller.InstallBindings`.

High-risk 1.40 behavior:

- UI injection depends on private Beat Saber/HMUI fields in main menu/settings/gameplay controllers.
- TextMeshPro and TableView patches are tightly coupled to method names and signatures.
- Word wrapping in the 1.40-era code can still use the old `enableWordWrapping` path, while later TMP APIs prefer `textWrappingMode`.

### Beat Saber 1.44.0 / BSML 1.14.1

This is the current Latest baseline for this skill. Installed DLL/XML must be treated as authoritative because the local source snapshot is older.

Observed changes relative to 1.40.8:

- Added patch/types include `EmojiSupport`, `TextMeshPro_LoadFontAsset`, `BeatSaberInit_InstallBindings`, `VerticalScrollIndicator_RefreshHandle`, and `FontManager.TMPFontCreationArgs`.
- Removed/renamed patch/types include `TMP_Settings_GetFontAsset`, `PCAppInit_InstallBindings`, and `ScrollViewHandlePointerDidEnterPatch`.
- XML docs expose additional font/material accessors such as `MonochromeTextFont` and `MainFlatUIFontMaterial`.
- Several compiler-generated async/display classes changed, meaning method bodies changed even where public names stayed stable.

For 1.44 work:

- Decompile the installed 1.44 `BSML.dll` before trusting 1.40-era source.
- Verify the app-init binding patch path. `PCAppInit_InstallBindings` is gone and `BeatSaberInit_InstallBindings` exists.
- Verify TMP/font behavior through installed XML/decompile. Font fallback and emoji support changed.
- Verify scroll indicator and scroll view behavior. `VerticalScrollIndicator_RefreshHandle` exists and old pointer-enter patch type is gone.

## Migration Risk Map

Most fragile areas across 1.29.1 -> 1.40.8 -> 1.44.0:

- Zenject binding install points: app init and settings/main menu installers changed across versions.
- Main menu screen injection: `MainFlowCoordinator` and left-screen/menu-button injection depend on HMUI flow coordinator behavior.
- TextMeshPro/font handling: fallback fonts, emoji support, shader/material defaults, wrapping APIs, submesh/material patches.
- TableView/ScrollView: private method patches and visible-index calculations are version-sensitive.
- Gameplay setup UI: tabs depend on Beat Saber menu type enums, view controller internals, and reusable BSML templates.
- Resource loading: 1.29.1 has older resource exception behavior; 1.40+ has specific missing-resource exceptions and async resource helpers.
- Host binding: `~` values, `#` actions, `id` component/object binding, and access-mode behavior must be checked if mod hosts rely on implicit member names.

## Fast Lookup Commands

Use these when more detail is needed without loading every BSML detail into context:

```powershell
# Installed assembly version and hash
[System.Reflection.AssemblyName]::GetAssemblyName('<instance-root>\1.44.0\Plugins\BSML.dll').Version
Get-FileHash '<instance-root>\1.44.0\Plugins\BSML.dll' -Algorithm SHA256

# Decompile a specific type
ilspycmd -t BeatSaberMarkupLanguage.BSMLParser '<instance-root>\1.44.0\Plugins\BSML.dll'
ilspycmd -t BeatSaberMarkupLanguage.BeatSaberUI '<instance-root>\1.44.0\Plugins\BSML.dll'

# Query installed XML docs
rg "BeatSaberMarkupLanguage.BeatSaberUI|GameplaySetup|BSMLSettings" '<instance-root>\1.44.0\Plugins\BSML.xml'

# Compare type surfaces captured during analysis if regenerated
ilspycmd -l c '<instance-root>\1.44.0\Plugins\BSML.dll'
```

## Skill Update Rule

If the user asks to update `$beatsaber` for a new Beat Saber or BSML release, update this file as the BSML-specific reference. Keep mod-specific data here; do not add BSML internals to the base `SKILL.md` except for an index pointer. If a future request needs exact per-type diffs, generate a separate compact BSML type diff file and reference it from this document instead of expanding the base skill load.

