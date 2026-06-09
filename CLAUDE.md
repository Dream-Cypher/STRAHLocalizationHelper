# STRAHLocalizationHelper — fork notes

Fork of github.com/Xzonn/STRAHChsLocalizationHelper, the patcher that bakes the
translation (text + replacement sprites/textures/fonts) into the Switch game's
assets. Used by the sibling `STRAHLocalization` repo's English build.

## Our change vs upstream
**Language fix in `STRAHLocalizationHelper/AssetHelper.cs` + `Program.cs`:** the
`ReplaceMonoBehaviour` `default:` case was hard-coded to read `texts/zh_Hans/{class}.json`.
On a non-Chinese build (`XZ_LANGUAGE=en`) it extracted the ORIGINAL Japanese to
`texts/zh_Hans/` and re-applied it, silently shipping Japanese for AppGameDataTipsData
(tips), FlowChartData (flowchart), and TextFlyMoveData. Fixed by threading `language`
into `ReplaceMonoBehaviour` and using `texts/{language}/`. This is a general bug fix
(makes the tool language-agnostic) — worth a PR upstream.

## Build / run
- Recompile after changes: `dotnet publish STRAHLocalizationHelper/STRAHLocalizationHelper.csproj -c Release -r win-x64` (needs .NET 8 SDK). Single-file, framework-dependent; native `x64/Texture2DDecoderNative.dll` must stay in the publish folder (the C++ native projects don't rebuild without a C++ toolchain, but the prebuilt DLL persists).
- It is RUN from the localization repo's working directory (all its paths are relative): set `XZ_LANGUAGE=en XZ_GAME=STRAH`, then execute the publish exe. See `../STRAHLocalization/BUILD_ENGLISH_PATCH.txt`.
- Asset replacement reads: `files/fonts/<font>.ttf`, `files/images/<tex>.png` (Texture2D), `files/sprites/<sprite>.png` (Sprite), and `texts/{language}/*.json` — all relative to the localization repo, not this one.
