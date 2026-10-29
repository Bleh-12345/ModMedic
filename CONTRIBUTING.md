
Contributions are welcome: compatibility reports, tests, documentation, accessibility improvements, and new log patterns are especially useful.

1. Open an issue describing your platform, BepInEx version, and expected behaviour.
2. **Do not post unredacted logs**: logs may contain usernames, installation paths, or tokens.
3. Fork and create a feature branch; add tests for new parsers or scans.
4. Run `PYTHONPATH=src python -m unittest discover -s tests -v` on macOS/Linux or set `$env:PYTHONPATH='src'` on Windows.
5. Open a PR explaining the change and how you verified it.

Avoid submitting features that bypass anti-cheat, inject into multiplayer games, or alter users' games without explicit opt-in and recoverable backups.
