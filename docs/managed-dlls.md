# Managed DLLs Not Shared Across All Unity Games

This documentation excludes `Unity*`, `UnityEngine*`, `System*`, `mscorlib.dll`, and `netstandard.dll`. It includes Beat Saber game assemblies plus bundled third-party/platform assemblies from `Beat Saber_Data\Managed`.

- Latest: `1.44.0`
- Supported versions compared: 1.29.1, 1.40.8, 1.44.0
- Per-DLL docs: `docs/managed-dlls/`
- Compact machine change log: `references/managed-dll-changes.jsonl`

## Index

| DLL | Category | Latest state | Present versions |
| --- | --- | --- | --- |
| [Accessibility.dll](managed-dlls/Accessibility.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [AdditionalContentModel.Interfaces.dll](managed-dlls/AdditionalContentModel.Interfaces.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Analytics.Model.dll](managed-dlls/Analytics.Model.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [AYellowpaper.SerializedCollections.dll](managed-dlls/AYellowpaper.SerializedCollections.md) | third-party | present in Latest/1.44.0 | 1.44.0 |
| [BeatGames.Analytics.dll](managed-dlls/BeatGames.Analytics.md) | third-party | present in Latest/1.44.0 | 1.44.0 |
| [BeatmapCore.dll](managed-dlls/BeatmapCore.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [BeatmapEditor3D.dll](managed-dlls/BeatmapEditor3D.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [BeatSaber.Analytics.Gameplay.dll](managed-dlls/BeatSaber.Analytics.Gameplay.md) | game | present in Latest/1.44.0 | 1.44.0 |
| [BeatSaber.AvatarCore.dll](managed-dlls/BeatSaber.AvatarCore.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.BeatAvatarAdapter.dll](managed-dlls/BeatSaber.BeatAvatarAdapter.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.BeatAvatarSDK.dll](managed-dlls/BeatSaber.BeatAvatarSDK.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.BeatmapEditor.dll](managed-dlls/BeatSaber.BeatmapEditor.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.Credits.dll](managed-dlls/BeatSaber.Credits.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.Destinations.dll](managed-dlls/BeatSaber.Destinations.md) | game | present in Latest/1.44.0 | 1.44.0 |
| [BeatSaber.Environments.BTS.dll](managed-dlls/BeatSaber.Environments.BTS.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.Environments.Interscope.dll](managed-dlls/BeatSaber.Environments.Interscope.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.Environments.LadyGaga.dll](managed-dlls/BeatSaber.Environments.LadyGaga.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.Environments.LinkinPark2.dll](managed-dlls/BeatSaber.Environments.LinkinPark2.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.FeatureFlags.dll](managed-dlls/BeatSaber.FeatureFlags.md) | game | present in Latest/1.44.0 | 1.44.0 |
| [BeatSaber.GameSettings.dll](managed-dlls/BeatSaber.GameSettings.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.GraphQL.dll](managed-dlls/BeatSaber.GraphQL.md) | game | present in Latest/1.44.0 | 1.44.0 |
| [BeatSaber.Init.dll](managed-dlls/BeatSaber.Init.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.Multiplayer.Core.dll](managed-dlls/BeatSaber.Multiplayer.Core.md) | game | present in Latest/1.44.0 | 1.44.0 |
| [BeatSaber.Multiplayer.TimelineMock.dll](managed-dlls/BeatSaber.Multiplayer.TimelineMock.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.RecPlay.dll](managed-dlls/BeatSaber.RecPlay.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.Settings.dll](managed-dlls/BeatSaber.Settings.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.Styles.dll](managed-dlls/BeatSaber.Styles.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.TrackDefinitions.dll](managed-dlls/BeatSaber.TrackDefinitions.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BeatSaber.ViewSystem.dll](managed-dlls/BeatSaber.ViewSystem.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.AppFlow.dll](managed-dlls/BGLib.AppFlow.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.Attributes.dll](managed-dlls/BGLib.Attributes.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.ClassicStaticBatcher.dll](managed-dlls/BGLib.ClassicStaticBatcher.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.DotnetExtension.dll](managed-dlls/BGLib.DotnetExtension.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.FileStorage.dll](managed-dlls/BGLib.FileStorage.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.FileStorage.Sony.dll](managed-dlls/BGLib.FileStorage.Sony.md) | game | not present in Latest/1.44.0 | 1.40.8 |
| [BGLib.JsonExtension.dll](managed-dlls/BGLib.JsonExtension.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.MetaRemoteAssets.dll](managed-dlls/BGLib.MetaRemoteAssets.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.Notepad.dll](managed-dlls/BGLib.Notepad.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.Polyglot.dll](managed-dlls/BGLib.Polyglot.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.SaveDataCore.dll](managed-dlls/BGLib.SaveDataCore.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.UiToolkitUtilities.dll](managed-dlls/BGLib.UiToolkitUtilities.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGLib.UnityExtension.dll](managed-dlls/BGLib.UnityExtension.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGNet.dll](managed-dlls/BGNet.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [BGNetCore.dll](managed-dlls/BGNetCore.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [BGNetLogging.dll](managed-dlls/BGNetLogging.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [BouncyCastle.Crypto.dll](managed-dlls/BouncyCastle.Crypto.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Cinemachine.dll](managed-dlls/Cinemachine.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Colors.dll](managed-dlls/Colors.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [com.rlabrecque.steamworks.net.dll](managed-dlls/com.rlabrecque.steamworks.net.md) | third-party | present in Latest/1.44.0 | 1.44.0 |
| [Core.dll](managed-dlls/Core.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [DataModels.dll](managed-dlls/DataModels.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [DynamicBone.dll](managed-dlls/DynamicBone.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [FinalIK.dll](managed-dlls/FinalIK.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [Gaga.dll](managed-dlls/Gaga.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [GameInit.dll](managed-dlls/GameInit.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [GameplayCore.dll](managed-dlls/GameplayCore.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Helpers.dll](managed-dlls/Helpers.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [HMLib.dll](managed-dlls/HMLib.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [HMLibAttributes.dll](managed-dlls/HMLibAttributes.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [HMRendering.dll](managed-dlls/HMRendering.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [HMUI.dll](managed-dlls/HMUI.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [HoudiniEngineUnity.dll](managed-dlls/HoudiniEngineUnity.md) | third-party | not present in Latest/1.44.0 | 1.29.1, 1.40.8 |
| [Ignorance.dll](managed-dlls/Ignorance.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Interactable.dll](managed-dlls/Interactable.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [IntervalTree.dll](managed-dlls/IntervalTree.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [IPA.Injector.dll](managed-dlls/IPA.Injector.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [IPA.Loader.dll](managed-dlls/IPA.Loader.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Library.UnityOpus.dll](managed-dlls/Library.UnityOpus.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [LiteNetLib.dll](managed-dlls/LiteNetLib.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [LIV.dll](managed-dlls/LIV.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Main.dll](managed-dlls/Main.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [MediaLoader.dll](managed-dlls/MediaLoader.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Menu.ColorSettings.dll](managed-dlls/Menu.ColorSettings.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Menu.CommonLib.dll](managed-dlls/Menu.CommonLib.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [MenuLightPreset.dll](managed-dlls/MenuLightPreset.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [MenuSystem.dll](managed-dlls/MenuSystem.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Meta.XR.ImmersiveDebugger.Interface.dll](managed-dlls/Meta.XR.ImmersiveDebugger.Interface.md) | third-party | present in Latest/1.44.0 | 1.44.0 |
| [MidiParser.dll](managed-dlls/MidiParser.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [MockCore.dll](managed-dlls/MockCore.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Mono.Data.Sqlite.dll](managed-dlls/Mono.Data.Sqlite.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Mono.Posix.dll](managed-dlls/Mono.Posix.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Mono.Security.dll](managed-dlls/Mono.Security.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Mono.WebBrowser.dll](managed-dlls/Mono.WebBrowser.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Networking.dll](managed-dlls/Networking.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Networking.NetworkPlayerEntitlementsChecker.dll](managed-dlls/Networking.NetworkPlayerEntitlementsChecker.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Newtonsoft.Json.dll](managed-dlls/Newtonsoft.Json.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Notepad.dll](managed-dlls/Notepad.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [Novell.Directory.Ldap.dll](managed-dlls/Novell.Directory.Ldap.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [nunit.framework.dll](managed-dlls/nunit.framework.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Oculus.Platform.dll](managed-dlls/Oculus.Platform.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [Oculus.VR.dll](managed-dlls/Oculus.VR.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [OculusStudios.GraphQL.Client.dll](managed-dlls/OculusStudios.GraphQL.Client.md) | third-party | present in Latest/1.44.0 | 1.44.0 |
| [OculusStudios.GraphQL.ClientInterface.dll](managed-dlls/OculusStudios.GraphQL.ClientInterface.md) | third-party | present in Latest/1.44.0 | 1.44.0 |
| [OculusStudios.HierarchyIcons.dll](managed-dlls/OculusStudios.HierarchyIcons.md) | third-party | present in Latest/1.44.0 | 1.44.0 |
| [OculusStudios.Platform.Core.dll](managed-dlls/OculusStudios.Platform.Core.md) | third-party | present in Latest/1.44.0 | 1.44.0 |
| [OculusStudios.Platform.Steam.dll](managed-dlls/OculusStudios.Platform.Steam.md) | third-party | present in Latest/1.44.0 | 1.44.0 |
| [Ookii.Dialogs.dll](managed-dlls/Ookii.Dialogs.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [osce.analytics.dll](managed-dlls/osce.analytics.md) | third-party | present in Latest/1.44.0 | 1.44.0 |
| [Overdraw.dll](managed-dlls/Overdraw.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [OverridableData.dll](managed-dlls/OverridableData.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Platforms.PC.Steam.dll](managed-dlls/Platforms.PC.Steam.md) | third-party | not present in Latest/1.44.0 | 1.40.8 |
| [PlatformUserModel.dll](managed-dlls/PlatformUserModel.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Polyglot.dll](managed-dlls/Polyglot.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [Rendering.dll](managed-dlls/Rendering.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [SaberTrail.dll](managed-dlls/SaberTrail.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [SegmentedControl.dll](managed-dlls/SegmentedControl.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Static Batcher.dll](managed-dlls/Static Batcher.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [SteamVR.dll](managed-dlls/SteamVR.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [Steamworks.NET.dll](managed-dlls/Steamworks.NET.md) | third-party | not present in Latest/1.44.0 | 1.29.1, 1.40.8 |
| [Tayx.Graphy.dll](managed-dlls/Tayx.Graphy.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [TestUtil.dll](managed-dlls/TestUtil.md) | third-party | not present in Latest/1.44.0 | 1.29.1 |
| [Transitions.dll](managed-dlls/Transitions.md) | third-party | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Tweening.dll](managed-dlls/Tweening.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [VRUI.dll](managed-dlls/VRUI.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [VRUI.Interfaces.dll](managed-dlls/VRUI.Interfaces.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |
| [Zenject-usage.dll](managed-dlls/Zenject-usage.md) | third-party | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [Zenject.dll](managed-dlls/Zenject.md) | game | present in Latest/1.44.0 | 1.29.1, 1.40.8, 1.44.0 |
| [ZenjectExtension.dll](managed-dlls/ZenjectExtension.md) | game | present in Latest/1.44.0 | 1.40.8, 1.44.0 |

## Added/Removed Between Supported Versions

| DLL | Pair | Change | Old category | New category |
| --- | --- | --- | --- | --- |
| AdditionalContentModel.Interfaces.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Analytics.Model.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| AYellowpaper.SerializedCollections.dll | 1.40.8 to 1.44.0 | added |  | third-party |
| BeatGames.Analytics.dll | 1.40.8 to 1.44.0 | added |  | third-party |
| BeatmapEditor3D.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| BeatSaber.Analytics.Gameplay.dll | 1.40.8 to 1.44.0 | added |  | game |
| BeatSaber.AvatarCore.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.BeatAvatarAdapter.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.BeatAvatarSDK.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.BeatmapEditor.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.Credits.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.Destinations.dll | 1.40.8 to 1.44.0 | added |  | game |
| BeatSaber.Environments.BTS.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.Environments.Interscope.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.Environments.LadyGaga.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.Environments.LinkinPark2.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.FeatureFlags.dll | 1.40.8 to 1.44.0 | added |  | game |
| BeatSaber.GameSettings.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.GraphQL.dll | 1.40.8 to 1.44.0 | added |  | game |
| BeatSaber.Init.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.Multiplayer.Core.dll | 1.40.8 to 1.44.0 | added |  | game |
| BeatSaber.Multiplayer.TimelineMock.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.RecPlay.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.Settings.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.Styles.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.TrackDefinitions.dll | 1.29.1 to 1.40.8 | added |  | game |
| BeatSaber.ViewSystem.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.AppFlow.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.Attributes.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.ClassicStaticBatcher.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.DotnetExtension.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.FileStorage.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.FileStorage.Sony.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.FileStorage.Sony.dll | 1.40.8 to 1.44.0 | removed | game |  |
| BGLib.JsonExtension.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.MetaRemoteAssets.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.Notepad.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.Polyglot.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.SaveDataCore.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.UiToolkitUtilities.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGLib.UnityExtension.dll | 1.29.1 to 1.40.8 | added |  | game |
| BGNet.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| BGNetCore.dll | 1.29.1 to 1.40.8 | added |  | game |
| com.rlabrecque.steamworks.net.dll | 1.40.8 to 1.44.0 | added |  | third-party |
| DataModels.dll | 1.29.1 to 1.40.8 | added |  | game |
| DynamicBone.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| FinalIK.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| Gaga.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| GameInit.dll | 1.29.1 to 1.40.8 | added |  | game |
| Helpers.dll | 1.29.1 to 1.40.8 | added |  | game |
| HMLibAttributes.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| HoudiniEngineUnity.dll | 1.40.8 to 1.44.0 | removed | third-party |  |
| Ignorance.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Interactable.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Library.UnityOpus.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| MediaLoader.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Menu.ColorSettings.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Menu.CommonLib.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| MenuLightPreset.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| MenuSystem.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Meta.XR.ImmersiveDebugger.Interface.dll | 1.40.8 to 1.44.0 | added |  | third-party |
| Networking.dll | 1.29.1 to 1.40.8 | added |  | game |
| Networking.NetworkPlayerEntitlementsChecker.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Notepad.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| Oculus.Platform.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| Oculus.VR.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| OculusStudios.GraphQL.Client.dll | 1.40.8 to 1.44.0 | added |  | third-party |
| OculusStudios.GraphQL.ClientInterface.dll | 1.40.8 to 1.44.0 | added |  | third-party |
| OculusStudios.HierarchyIcons.dll | 1.40.8 to 1.44.0 | added |  | third-party |
| OculusStudios.Platform.Core.dll | 1.40.8 to 1.44.0 | added |  | third-party |
| OculusStudios.Platform.Steam.dll | 1.40.8 to 1.44.0 | added |  | third-party |
| osce.analytics.dll | 1.40.8 to 1.44.0 | added |  | third-party |
| Overdraw.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| OverridableData.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Platforms.PC.Steam.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Platforms.PC.Steam.dll | 1.40.8 to 1.44.0 | removed | third-party |  |
| PlatformUserModel.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Polyglot.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| SaberTrail.dll | 1.29.1 to 1.40.8 | added |  | game |
| SegmentedControl.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Static Batcher.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| SteamVR.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| Steamworks.NET.dll | 1.40.8 to 1.44.0 | removed | third-party |  |
| TestUtil.dll | 1.29.1 to 1.40.8 | removed | third-party |  |
| Transitions.dll | 1.29.1 to 1.40.8 | added |  | third-party |
| Tweening.dll | 1.29.1 to 1.40.8 | added |  | game |
| VRUI.Interfaces.dll | 1.29.1 to 1.40.8 | added |  | game |
| ZenjectExtension.dll | 1.29.1 to 1.40.8 | added |  | game |
