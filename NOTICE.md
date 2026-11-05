# NOTICE — artwork and third-party material

## Clawd animations

The PNG frames under `frames/` are derived from
[MyClawd](https://github.com/CodeChrisB/MyClawd) by **CodeChrisB**
(live site: <https://codechrisb.github.io/MyClawd/>).

MyClawd is a fan project and does **not** ship an open-source license: the
default is "all rights reserved". For that reason the frames are included here
for **personal, non-commercial use** only, with credit to the original author.

If you redistribute this package or its artwork, ask CodeChrisB for permission
first, or regenerate the frames yourself from the MyClawd sources under whatever
terms you agree with the author.

To use the package without the bundled artwork, delete `frames/` and run
`blue-crab setup` after placing your own PNG frames in
`%USERPROFILE%\.dsh-tui\crab\<set>\frame-XX.png` (192×64, transparent).

## Clawd mascot

**Clawd** is the mascot of Anthropic's Claude Code, and "Claude" / "Claude Code"
are Anthropic trademarks. This project is an unofficial fan work, not affiliated
with, endorsed or sponsored by Anthropic.

## dsh-TUI and DeepSeek Harness

The patches modify files of
[dsh-TUI](https://github.com/ccch1mneyyy/dsh-tui) (MIT) running on top of
**DeepSeek Harness** (`@deepseek-ai/dsh`). Their licenses stay in force for their
code; this package only applies text patches at install time and keeps backups
(`*.clawd-backup`) so `blue-crab restore` can undo them.

## Music detection

The watcher uses the **Windows.Media.Control** (GSMTC) API exposed by Windows 10
and 11 — the same one behind the Fn+F2 media popup. No audio is recorded, no
network calls are made; only the app id, playback state and track title are
written to `%USERPROFILE%\.dsh-tui\clawd-music.json`.
