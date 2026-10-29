# ModMedic

**Find the fault. Fix your modded game.**

ModMedic is an open-source **Windows-first desktop app** that inspects BepInEx plugin folders, parses game log warnings and errors, exports a private-by-default diagnostic report, and makes an opt-in ZIP backup of plugins and config files. Its v0.1 diagnostic scan does **not** disable or execute mods.

![ModMedic desktop app preview with sample data](docs/interface-preview.png)

*Desktop UI preview captured with sample log data; this is not a screenshot of the Windows installer.*

![ModMedic installer artwork](assets/wizard-side.png)

> **Status:** Early v0.1 prototype. Automated crash isolation and dependency resolution are planned, not available yet. Log warnings are clues, not a definitive diagnosis. This is not affiliated with BepInEx or any game publisher.

## Download a setup EXE from GitHub Actions

The repository includes a complete Windows installer build workflow:

1. Create your own public GitHub repository, push these source files to the `main` branch.
2. Open **Actions** > **Windows installer** > **Run workflow** (or wait for the first push build).
3. When the workflow succeeds, download the **ModMedic-Windows-Setup** artifact from the run's **Artifacts** section.
4. Extract the downloaded artifact ZIP, then double-click `ModMedic-Setup-0.1.0.exe`.

**Important:** The GitHub Actions artifact itself is a ZIP containing the **single setup EXE**. End users only need that EXE; Python is bundled inside the installed application. The installer is **not code-signed**, so Windows SmartScreen may warn. Inspect the source and release binaries only from the repository you trust. Do not disable security protections globally.

## What the installer does

- Modern, dark setup wizard with custom ModMedic branding
- Welcome, pre-flight information, licence, install location, progress, completion
- Per-user install to `%LOCALAPPDATA%\Programs\ModMedic` (no administrator access required)
- Start Menu shortcut and optional desktop shortcut
- Optional launch after installing
- Standard Windows uninstall support through Installed Apps

## Use ModMedic

1. Launch **ModMedic**.
2. Click **Browse** and select your game's directory containing `BepInEx` (or the BepInEx folder itself).
3. Click **SCAN GAME**.
4. Review the DLL inventory and BepInEx log findings.
5. Use **Export report** to create JSON or **Backup mods** to archive plugin/config files to a ZIP. The backup does not include full game saves or BepInEx core files.

### Command-line mode (developer build)

```powershell
py -m pip install -e .
modmedic --scan "C:\Games\ExampleGame" --report "diagnostics.json"
```

## Build the installer on Windows

Requirements: Windows 10/11, Python 3.11 or later, and [Inno Setup 6.7+](https://jrsoftware.org/isinfo.php).

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\build-installer.ps1
```

Output: `dist-installer\ModMedic-Setup-0.1.0.exe`.

The build script creates a virtual environment, installs PyInstaller, runs tests, bundles the Python app, and compiles the branded Inno Setup installer. It never requires a global Python package install. Use the GitHub Actions workflow instead if you don't want to install developer tools locally.

## Run directly from source

```powershell
py -m pip install -e .
modmedic
```

Run tests from an activated environment:

```powershell
$env:PYTHONPATH="src"
py -m unittest discover -s tests -v
```

## Privacy, safety, limitations

- No telemetry, API calls, account sign-in, mod downloads, code injection, or game modification.
- Folders are read only while scanning. ZIP backup is opt-in and saved where you choose.
- JSON report redacts common Windows/macOS/Linux home path usernames, **but could still include private information typed into a log line or embedded in mod names**. Review before posting publicly.
- Only conventional BepInEx folder layouts and a few common log patterns are supported in v0.1.
- Inventory counts `.dll` files; a DLL isn't necessarily an independently configurable mod.
- Nothing in the app bypasses game DRM, anti-cheat, or online moderation systems.
- The Windows build workflow is included but is not verified as having successfully compiled on a Windows runner yet.

## Roadmap

- **v0.1:** Scanner, BepInEx log parsing, backup, report, desktop GUI, installer
- **v0.2:** Safer and smarter error correlations and compatibility checks
- **v0.3:** Guided bisect testing with reversible snapshots
- **v0.4:** Opt-in mod manager profile imports, additional game frameworks

## Contribute

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to reproduce problems and submit improvements. Licence: [MIT](LICENSE).
