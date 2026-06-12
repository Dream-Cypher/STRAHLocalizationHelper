# Summertime Render: Another Horizon — Localization Patch Generator

Used for the [main localization project](https://github.com/Dream-Cypher/STRAHLocalization) (English fork).

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
