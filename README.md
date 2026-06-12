# Summertime Render: Another Horizon — Localization Patch Generator

Used for the [main localization project](https://github.com/Dream-Cypher/STRAHLocalization) (English fork).

This is a fork of [Xzonn/STRAHChsLocalizationHelper](https://github.com/Xzonn/STRAHChsLocalizationHelper),
the patcher originally built for the Simplified Chinese translation. All credit for
the original asset-patching pipeline (AssetStudio integration, MonoBehaviour/Texture2D/
Sprite/Font replacement, CRI pack repacking) goes to its author and contributors.

## Changes from upstream
- **Multi-language support**: upstream's `ReplaceMonoBehaviour` `default:` case was
  hard-coded to read `texts/zh_Hans/{class}.json` regardless of the configured
  language. On a non-Chinese build this extracted the *original Japanese* text into
  `texts/zh_Hans/` and re-applied it, silently shipping untranslated Japanese for
  `AppGameDataTipsData` (tips), `FlowChartData` (flowchart), and `TextFlyMoveData`.
  Fixed by threading the configured `language` through to `texts/{language}/`,
  making the tool work for any target language, not just Simplified Chinese.
- **`config.json` + English default**: settings (`platform`/`game`/`language`) are
  now read from a `config.json` next to the exe (defaulting to `Switch`/`STRAH`/`en`)
  instead of requiring `XZ_PLATFORM`/`XZ_GAME`/`XZ_LANGUAGE` environment variables on
  every run. The env vars are still honored as overrides.
- **Self-contained, portable build**: `./build.ps1` publishes a self-contained
  `dist/` folder (bundled .NET runtime + native DLL + `config.json`) and mirrors it
  into the sibling `STRAHLocalization` repo's `tools/` folder, fixing a
  `DllNotFoundException: Texture2DDecoderNative` crash and removing the need to
  install a .NET runtime on the build target machine.
- **Repo layout cleanup**: un-doubled the nested project folder
  (`STRAHLocalizationHelper/src/`), removed the unused upstream CI workflow and
  unused C++ projects from the solution, and documented which submodule
  sub-projects are actually compiled.

## Repository layout
- **`STRAHLocalizationHelper/src/`** — our code: `Program.cs` (entry point),
  `AssetHelper.cs` (asset patching logic), `Config.cs` (config loader), `config.json`
  (runtime settings, defaults to English), and `native/Texture2DDecoderNative.dll`
  (a prebuilt native dependency checked into the repo).
- **`AssetStudio/`, `BundleHelper/`, `CriPakTools/`** — git submodules pinned to the
  repos listed under Dependencies below (not vendored copies). After cloning, run:
  ```
  git submodule update --init --recursive
  ```
  Of each submodule's sub-projects, only a subset is actually compiled into this tool
  (see `STRAHLocalizationHelper.sln`): `AssetStudio`, `AssetStudioUtility`,
  `AssetStudio.PInvoke`, `AssetStudioFBXWrapper`, `Texture2DDecoderWrapper` (from
  AssetStudio), `BundleHelper`, and `LibCPK` (from CriPakTools). `AssetStudioGUI`, the
  C++ native projects (`AssetStudioFBXNative`, `Texture2DDecoderNative`), and
  `LibCRIComp` are unused — we ship the prebuilt `native/Texture2DDecoderNative.dll`
  instead of building its C++ source.

## Build / run
- `./build.ps1` — builds a self-contained `dist/` folder (exe + native DLL +
  `config.json`) and mirrors it into `../STRAHLocalization/tools/`.
- Settings (`platform`/`game`/`language`) come from `config.json` next to the exe,
  defaulting to `Switch`/`STRAH`/`en`. The `XZ_PLATFORM`/`XZ_GAME`/`XZ_LANGUAGE`
  environment variables override `config.json` if set.

## Dependencies
- [AssetStudio](https://github.com/Xzonn/AssetStudio)
- [CriPakTools](https://github.com/Xzonn/CriPakTools)
- [BundleHelper](https://github.com/Xzonn/BundleHelper)

## Inspired by
- [YC_English](https://github.com/Thesola10/YC_English)
