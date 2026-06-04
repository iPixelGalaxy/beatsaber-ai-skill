# MappingExtensions Mod Reference

Use this file only when the user names MappingExtensions, asks about Mapping Extensions migration, or asks for `$beatsaber` mod-specific notes.

## Scope

- Mod repo: `<workspace>\MappingExtensions`
- Installed plugin DLLs inspected:
  - `<instance-root>\1.29.1\Plugins\MappingExtensions.dll`
  - `<instance-root>\1.40.8\Plugins\MappingExtensions.dll`
  - `<instance-root>\1.44.0\Plugins\MappingExtensions.dll`
- Historical source anchors:
  - `5af2bdf` = `Update for 1.29.0`
  - `0f33ec0` = `Update for 1.30.0`
  - `4c31727` = `Fix for game v1.40.0`
  - `1cfda03` = current `origin/master`, before local 1.44 WIP edits
- Current local repo state: dirty, with 1.44-targeted edits in patch files, `MappingExtensions.csproj`, `Plugin.cs`, `manifest.json`, and new `MappingExtensionsData.cs`.

## Build/Install Observation

`dotnet build .\MappingExtensions.sln -c Release` succeeded against `<instance-root>/1.44.0` on 2026-06-03. The build emitted warnings only, then copied `MappingExtensions.dll` and `.pdb` into `<instance-root>\1.44.0\Plugins`.

Do not treat this as a runtime validation. MappingExtensions depends heavily on Harmony transpiler IL patterns; compile success only proves referenced types/members are resolvable in publicized assemblies.

## Activation Model

MappingExtensions is mostly passive until `Plugin.active` is true.

1. On enable, register SongCore capabilities:
   - `Mapping Extensions`
   - `Mapping Extensions-Precision Placement`
   - `Mapping Extensions-Extra Note Angles`
   - `Mapping Extensions-More Lanes`
2. Patch the executing assembly with Harmony id `com.kyle1413.BeatSaber.MappingExtensions`.
3. Listen to `SceneManager.activeSceneChanged`.
4. On menu scene, set `active = false`.
5. On game scene, inspect SongCore difficulty requirements and set `active = true` only when requirements contain `Mapping Extensions`.

1.29.1 used `SongCore.Collections.RetrieveDifficultyData(diff)` from `GameplayCoreSceneSetupData.difficultyBeatmap`.

1.40.8 uses `SongCore.Collections.GetCustomLevelSongDifficultyData(gameplayCoreSceneSetupData.beatmapKey)`. This is the important activation migration: Beat Saber moved gameplay identity toward `BeatmapKey`, so old `IDifficultyBeatmap`-based retrieval is not the right anchor after the 1.30+ data-model shift.

## Encoded MappingExtensions Values

The mod preserves non-vanilla map data by patching conversion, spawn, display, cut-direction, and mirror behavior.

### Line Index / Precision Placement

- Vanilla lanes: `0..3`.
- Extra integer lanes: values `<0` or `>3`.
- Precision values: `>= 1000` or `<= -1000`.
- Negative precision lane values are normalized by adding `2000` before coordinate math.
- Precision x offset formula used in 1.29.1 and 1.40.8:
  - base = `-(noteLinesCount - 1) * 0.5`
  - x = `base + normalizedLineIndex * kNoteLinesDistance / 1000`
  - world note offset = `_rightVec * x + y`

Current 1.44 WIP extracted this into `MappingExtensionsData.NormalizePrecisionLineIndex`.

### Line Layer / Extra Layers

- Vanilla layers: `Base = 0`, `Upper = 1`, `Top = 2`.
- Extra layers: values `<0` or `>2`.
- Precision layers: `>= 1000` or `<= -1000`.
- 1.40.8 line-y logic:
  - `delta = kTopLinesYPos - kUpperLinesYPos` in static helper, or `_topLinesHighestJumpPosY - _upperLinesHighestJumpPosY` for jump height.
  - precision: upper baseline minus two deltas plus `layer * delta / 1000`
  - integer extra layer: upper baseline minus one delta plus `layer * delta`

1.44.0 changed `StaticBeatmapObjectSpawnMovementData.LineYPosForLineLayer` to `0.25f + 0.6f * (float)lineLayer` and no longer exposes `kUpperLinesYPos`, `kTopLinesYPos`, or `layerHeight` in the same way. Any 1.44 update must avoid assuming those constants exist.

### Cut Direction / 360 Note Rotation

- Extra angle range: `1000..1360`
  - rotation angle = `1000 - direction`
- Dot-note angle range: `2000..2360`
  - rotation angle = `2000 - direction`
  - gameplay cut info treats these as `NoteCutDirection.Any`
  - visuals convert them to arrowless/dot behavior
- Mirror:
  - `1000..1360` maps to `2360 - direction`
  - `2000..2360` maps to `4360 - direction`

1.40.8 added `BeatmapTypeConverters.ConvertNoteCutDirection` handling so save-data values survive conversion before gameplay objects are initialized.

### Wall Width / Height

- Precision width encoded as `>=1000` or `<=-1000`.
- Width decode:
  - if `<= -1000`, add `2000`
  - width = `(encoded - 1000) / 1000`
- Precision height:
  - `>=1000`: `(height - 1000) / 1000`
  - `<=-1000`: `(height + 2000) / 1000`
- Legacy wall type encodings from v2 save data:
  - `1000..4005000` means custom wall height/start-height data.
  - `4001..4005000` is treated as `PreciseHeightStart`.

1.40.8 decodes width in `BeatmapObjectSpawnMovementData.GetObstacleSpawnData` by transpiling the obstacle width read. It decodes height in `ObstacleController.Init` by replacing `ObstacleSpawnData` with a recalculated height.

Current 1.44 WIP adds negative-length `StretchableObstacle` patches; that is new and was not part of 1.40.8.

## 1.29.1 Behavior

Installed 1.29.1 class list had these core patch classes:

- `BeatmapDataLoaderConvertNoteLineLayer`
- `BeatmapDataLoaderObstacleConvertorGetNoteLineLayer`
- `BeatmapObjectsInTimeRowProcessorHandleCurrentTimeSliceAllNotesAndSlidersDidFinishTimeSlice`
- `BeatmapObjectSpawnMovementDataGetNoteOffset`
- `BeatmapObjectSpawnMovementDataGet2DNoteOffset`
- `BeatmapObjectSpawnControllerGetObstacleOffset`
- `BeatmapObjectSpawnMovementDataHighestJumpPosYForLineLayer`
- `BeatmapSaveDataSpawnRotationForEventValue`
- `BeatmapSaveDataGetHeightForObstacleType`
- `BeatmapSaveDataGetLayerForObstacleType`
- `ColorNoteVisualsHandleNoteControllerDidInit`
- `NoteBasicCutInfoHelperGetBasicCutInfo`
- `NoteCutDirectionExtensionsRotation`
- `NoteCutDirectionExtensionsDirection`
- `NoteCutDirectionExtensionsRotationAngle`
- `NoteCutDirectionExtensionsMirrored`
- `NoteDataMirror`
- `NoteJumpInit`
- `ObstacleControllerInit`
- `ObstacleDataMirror`
- `SliderDataMirror`
- `SliderMeshControllerCutDirectionToControlPointPosition`
- `BeatmapObjectSpawnMovementDataLineYPosForLineLayer`

Important 1.29.1 traits:

- Runtime activation used `IDifficultyBeatmap` and `RetrieveDifficultyData`.
- `BeatmapDataLoader.ConvertNoteLineLayer(int)` was patched directly.
- `BeatmapDataLoader.ObstacleConvertor.GetNoteLineLayer(int)` was patched directly.
- `BeatmapSaveData` was still a viable patch surface for 360 spawn rotation and wall type decoding.
- `BeatmapObjectSpawnMovementData.Get2DNoteOffset` existed as an instance method and was patched there.
- Private fields were accessed with Harmony field-injection names, such as `____noteLinesCount` and `____rightVec`.
- Mirror patches used `IPA.Utilities.SetProperty` to assign private or non-public values after vanilla mirror logic.
- `BeatmapObjectsInTimeRowProcessor.TimeSliceContainer` needed an `IPA.Utilities.FieldAccessor` for `_items` because the public `items` accessor was not relied on.

## 1.40.8 Behavior

Installed 1.40.8 class list had renamed/modernized patch classes:

- `SliderMeshControllerCutDirectionToControlPointPositionPatch`
- `NoteCutDirectionExtensionsDirectionPatch`
- `NoteCutDirectionExtensionsRotationAnglePatch`
- `ColorNoteVisualsHandleNoteControllerDidInitPatch`
- `BeatmapTypeConvertersConvertNoteCutDirectionPatch`
- `NoteBasicCutInfoHelperGetBasicCutInfoPatch`
- `RotationTimeProcessorSpawnRotationForEventValuePatch`
- `BeatmapDataLoaderObstacleConverterGetHeightForObstacleTypePatch`
- `BeatmapDataLoaderObstacleConverterGetLayerForObstacleTypePatch`
- `BeatmapObjectSpawnMovementDataGetObstacleSpawnDataPatch`
- `ObstacleControllerInitPatch`
- `BeatmapDataLoaderObstacleConverterGetNoteLineLayerPatch`
- `BeatmapTypeConvertersConvertNoteLineLayerPatch`
- `BeatmapTypeConvertersConvertNoteLineLayerPatch2`
- `BeatmapObjectsInTimeRowProcessorHandleCurrentTimeSliceAllNotesAndSlidersDidFinishTimeSlicePatch`
- `NoteJumpInitPatch`
- `NoteDataMirrorPatch`
- `ObstacleDataMirrorPatch`
- `SliderDataMirrorPatch`
- `NoteCutDirectionExtensionsMirroredPatch`
- `BeatmapObjectSpawnMovementDataGetNoteOffsetPatch`
- `BeatmapObjectSpawnMovementDataGetObstacleOffsetPatch`
- `BeatmapObjectSpawnMovementDataHighestJumpPosYForLineLayerPatch`
- `StaticBeatmapObjectSpawnMovementDataLineYPosForLineLayerPatch`
- `StaticBeatmapObjectSpawnMovementDataGet2DNoteOffsetPatch`

Important 1.40.8 traits:

- The plugin constructor takes `Logger` and `PluginMetadata`, stores `_metadata.Assembly`, and calls `_harmony.PatchAll(_metadata.Assembly)`.
- `DeregisterizeCapability` was replaced by `DeregisterCapability`.
- `BeatmapTypeConverters` became the main save-data conversion surface for line layers and cut directions.
- `RotationTimeProcessor.SpawnRotationForEventValue` replaced old `BeatmapSaveData` spawn-rotation patching.
- V2/v2.6 wall decoding moved to `BeatmapDataLoaderVersion2_6_0AndEarlier.BeatmapDataLoader.ObstacleConverter`.
- V3 obstacle note-line-layer conversion moved to `BeatmapDataLoaderVersion3.BeatmapDataLoader.ObstacleConverter`.
- `StaticBeatmapObjectSpawnMovementData.Get2DNoteOffset` replaced the older instance `BeatmapObjectSpawnMovementData.Get2DNoteOffset` patch target.
- Publicized assemblies allow direct field/property access, so mirror patches directly assign `lineIndex`, `flipLineIndex`, `headLineIndex`, `tailLineIndex`, etc., instead of using `SetProperty`.
- `TimeSliceContainer.items` is used directly instead of a field accessor.

## Migration Map: 1.29.1 to 1.40.8

### Plugin Activation

Old:

- `GameplayCoreSceneSetupData.difficultyBeatmap`
- `SongCore.Collections.RetrieveDifficultyData(diff)`

New:

- `GameplayCoreSceneSetupData.beatmapKey`
- `SongCore.Collections.GetCustomLevelSongDifficultyData(beatmapKey)`

Reason: game data identity changed; `BeatmapKey` is the stable post-1.30 lookup key.

### Note Line Layer Conversion

Old:

- `BeatmapDataLoader.ConvertNoteLineLayer(int)`
- `BeatmapDataLoader.ObstacleConvertor.GetNoteLineLayer(int)`

New:

- `BeatmapTypeConverters.ConvertNoteLineLayer(int)`
- `BeatmapTypeConverters.ConvertNoteLineLayer(BeatmapSaveDataCommon.NoteLineLayer)`
- `BeatmapDataLoaderVersion3.BeatmapDataLoader.ObstacleConverter.GetNoteLineLayer(int)`

Purpose: preserve non-vanilla line layers through save-data conversion and obstacle conversion.

### Cut Direction Conversion

Old:

- runtime helpers like `NoteCutDirectionExtensions.Rotation/Direction/RotationAngle/Mirrored`
- gameplay helper `NoteBasicCutInfoHelper.GetBasicCutInfo`
- visual helper `ColorNoteVisuals.HandleNoteControllerDidInit`

New:

- same runtime/display helpers
- plus `BeatmapTypeConverters.ConvertNoteCutDirection(BeatmapSaveDataCommon.NoteCutDirection)`

Purpose: preserve custom cut directions during data conversion, not just during runtime interpretation.

### 360 Spawn Rotation

Old:

- `BeatmapSaveData.SpawnRotationForEventValue`

New:

- `RotationTimeProcessor.SpawnRotationForEventValue`

Logic retained:

- if not a 360/90-degree characteristic while gameplay data is set, do not override vanilla value.
- if event index is `1000..1720`, result is `index - 1360`.

### Note/Obstacle Position

Old:

- `BeatmapObjectSpawnMovementData.GetNoteOffset`
- `BeatmapObjectSpawnMovementData.Get2DNoteOffset`
- `BeatmapObjectSpawnMovementData.GetObstacleOffset`
- `BeatmapObjectSpawnMovementData.HighestJumpPosYForLineLayer`
- `BeatmapObjectSpawnMovementData.LineYPosForLineLayer`-named patch class targeting static helper

New:

- `BeatmapObjectSpawnMovementData.GetNoteOffset`
- `BeatmapObjectSpawnMovementData.GetObstacleOffset`
- `BeatmapObjectSpawnMovementData.HighestJumpPosYForLineLayer`
- `StaticBeatmapObjectSpawnMovementData.Get2DNoteOffset`
- `StaticBeatmapObjectSpawnMovementData.LineYPosForLineLayer`

Purpose: redirect precise lane and layer calculations after static helper extraction.

### Wall Width/Height

Old:

- `BeatmapSaveData.GetHeightForObstacleType`
- `BeatmapSaveData.GetLayerForObstacleType`
- `ObstacleController.Init` transpiler for width and prefix for height.

New:

- `BeatmapDataLoaderVersion2_6_0AndEarlier.BeatmapDataLoader.ObstacleConverter.GetHeightForObstacleType`
- `BeatmapDataLoaderVersion2_6_0AndEarlier.BeatmapDataLoader.ObstacleConverter.GetLayerForObstacleType`
- `BeatmapObjectSpawnMovementData.GetObstacleSpawnData` transpiler for width.
- `ObstacleController.Init` prefix replacing `ObstacleSpawnData` height.

Purpose: decode legacy encoded wall metadata before gameplay objects consume it, then correct spawn data at runtime.

### BeatmapObjectsInTimeRowProcessor

Old:

- Transpiler clamps line-index array access through a custom `Clamp`.
- Postfix reads private `_items` via `FieldAccessor`.
- Reimplements note/slider/burst overlap helpers locally.
- Updates head/tail notes and burst slider angle offsets.

New:

- Transpiler still clamps array access, now via `Math.Clamp`.
- Postfix reads `allObjectsTimeSlice.items`.
- Uses game-provided helpers:
  - `BeatmapObjectsInTimeRowProcessor.SliderHeadPositionOverlapsWithNote`
  - `SliderHeadPositionOverlapsWithBurstTail`
  - `SliderTailPositionOverlapsWithNote`
- No longer locally changes note gameplay type in the same explicit way in this patch; game internals handle more of that work.

Purpose: avoid `IndexOutOfRangeException` from extra/precision line indexes and maintain before-jump line layer assignment for dense note/slider rows.

### Mirror Logic

Old and new preserve the same math, but assignment mechanism changed.

For note/slider precision line indexes:

1. Save original line index before vanilla mirror.
2. If `<= -1000`, add `2000`.
3. Track if normalized value is `>= 4000`.
4. Flip around `5000`: `lineIndex = 5000 - lineIndex`.
5. If originally on left side, subtract `2000`.
6. Assign result back to note/slider field.

For integer extra lanes:

- Right side `>3`: compute expanded lane count from `(lineIndex - 3) * 2`.
- Left side `<0`: compute expanded lane count from `(0 - lineIndex) * 2`.
- Reassign to mirrored equivalent.

For obstacle precision width:

1. Normalize line index into precision units.
2. Flip around `2000`.
3. Normalize width into precision units.
4. Subtract width.
5. Re-encode negative/positive side by adding or subtracting `1000`.

## 1.44.0-Specific Observations

Known from inspected 1.44.0 game types:

- `BeatmapObjectSpawnMovementData` still has:
  - `_noteLinesCount`
  - `_rightVec`
  - `_upperLinesHighestJumpPosY`
  - `_topLinesHighestJumpPosY`
  - `GetNoteOffset(int, NoteLineLayer)`
  - `GetObstacleOffset(int, NoteLineLayer)`
  - `GetObstacleSpawnData(ObstacleData)`
  - private `HighestJumpPosYForLineLayer(NoteLineLayer)`
- `StaticBeatmapObjectSpawnMovementData` still has:
  - `kNoteLinesDistance = 0.6f`
  - `kBaseLinesYPos = 0.25f`
  - `Get2DNoteOffset(int, int, NoteLineLayer)`
  - `LineYPosForLineLayer(NoteLineLayer)`
- But 1.44.0 static layer y now returns `0.25f + 0.6f * (float)lineLayer`.
- 1.44.0 static helper no longer matches the 1.40.8 constant surface:
  - no `kUpperLinesYPos`
  - no `kTopLinesYPos`
  - no `layerHeight`
- `ObstacleController.Init` signature is `public virtual void Init(ObstacleData obstacleData, in ObstacleSpawnData obstacleSpawnData)`.
  - Harmony prefix using `ref ObstacleSpawnData obstacleSpawnData` may compile, but verify runtime patch binding carefully because the game method parameter is `in`.
- 1.44.0 `GetObstacleSpawnData` uses literal `0.6f` for obstacle height instead of `StaticBeatmapObjectSpawnMovementData.layerHeight`.

Current local 1.44 WIP appears to address some of this:

- `ObstacleControllerInitPatch` multiplies decoded height by `StaticBeatmapObjectSpawnMovementData.layerHeight` in one version of local edits, but inspected 1.44.0 does not expose that property in decompiled `StaticBeatmapObjectSpawnMovementData`. The later local file currently uses `layerHeight`; verify against publicized output before relying on it.
- `MappingExtensionsData.TryDecodePrecisionHeight` returns unscaled height and leaves scale to caller.
- New `StretchableObstacle` patches try to support negative length by post-processing calculated transform properties and renderer size/offset.

High-risk 1.44 runtime areas:

- Transpiler matching in `ColorNoteVisuals.HandleNoteControllerDidInit`.
- Transpiler matching in `BeatmapObjectsInTimeRowProcessor.HandleCurrentTimeSliceAllNotesAndSlidersDidFinishTimeSlice`.
- Transpiler matching in `NoteJump.Init`.
- Transpiler matching in `BeatmapObjectSpawnMovementData.GetObstacleSpawnData`.
- Harmony binding for `ObstacleController.Init(ObstacleData, in ObstacleSpawnData)`.
- Any code that assumes old static constants/properties from `StaticBeatmapObjectSpawnMovementData`.

## Recommended 1.44 Update Strategy

1. Keep the 1.40.8 feature model; do not re-invent MappingExtensions semantics.
2. Reconfirm each patch target against 1.44.0 decompiled types before changing logic.
3. Replace static layer constants with formula-based values:
   - base y = `StaticBeatmapObjectSpawnMovementData.LineYPosForLineLayer(NoteLineLayer.Base)`
   - delta = `StaticBeatmapObjectSpawnMovementData.kNoteLinesDistance`
   - y = base + delta * layer, except where legacy ME precision offset requires the old below-upper formula.
4. Treat `ObstacleSpawnData` as the authoritative 1.44 obstacle size carrier.
5. For `in ObstacleSpawnData`, prefer a Harmony prefix signature verified by runtime patch logs. If `ref` does not actually patch, use a transpiler or postfix on `GetObstacleSpawnData` instead.
6. Keep helper functions in `MappingExtensionsData` for precision detection/decoding; this reduces repeated off-by-1000 mistakes.
7. After compile, test in-game with one map per feature:
   - More Lanes, integer lanes left and right.
   - Precision Placement, positive and negative encoded lanes.
   - Extra Note Angles, both arrow and dot ranges.
   - Extra Layers, integer and precision layers.
   - Wall width/height, positive and negative precision encodings.
   - Mirroring enabled.
   - 360/90-degree map spawn rotation.

## Quick Lookup Commands

Use these when updating MappingExtensions:

```powershell
rg "BeatmapObjectSpawnMovementData|StaticBeatmapObjectSpawnMovementData|BeatmapTypeConverters|RotationTimeProcessor" <skill-root>\references\versions\1.44.0\types-game.jsonl
```

```powershell
ilspycmd --disable-updatecheck -t BeatmapObjectSpawnMovementData -r "<instance-root>\1.44.0\Beat Saber_Data\Managed" "<instance-root>\1.44.0\Beat Saber_Data\Managed\Main.dll"
```

```powershell
ilspycmd --disable-updatecheck -t StaticBeatmapObjectSpawnMovementData -r "<instance-root>\1.44.0\Beat Saber_Data\Managed" "<instance-root>\1.44.0\Beat Saber_Data\Managed\BeatmapCore.dll"
```

```powershell
git diff --unified=80 5af2bdf..4c31727 -- MappingExtensions
```

