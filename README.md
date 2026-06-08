# ColorTSR

[![License](https://img.shields.io/github/license/Hawkynt/ColorTSR)](https://github.com/Hawkynt/ColorTSR/blob/main/LICENSE)
[![Language](https://img.shields.io/github/languages/top/Hawkynt/ColorTSR?color=8957D5)](https://github.com/Hawkynt/ColorTSR)

[![CI](https://github.com/Hawkynt/ColorTSR/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/Hawkynt/ColorTSR/actions/workflows/ci.yml)
![Last Commit](https://img.shields.io/github/last-commit/Hawkynt/ColorTSR?branch=main)
![Activity](https://img.shields.io/github/commit-activity/m/Hawkynt/ColorTSR)

[![Stars](https://img.shields.io/github/stars/Hawkynt/ColorTSR?color=FFD700)](https://github.com/Hawkynt/ColorTSR/stargazers)
[![Forks](https://img.shields.io/github/forks/Hawkynt/ColorTSR?color=008080)](https://github.com/Hawkynt/ColorTSR/network/members)
[![Issues](https://img.shields.io/github/issues/Hawkynt/ColorTSR)](https://github.com/Hawkynt/ColorTSR/issues)
![Code Size](https://img.shields.io/github/languages/code-size/Hawkynt/ColorTSR?color=4CAF50)
![Repo Size](https://img.shields.io/github/repo-size/Hawkynt/ColorTSR?color=FF9800)

[![Release](https://img.shields.io/github/v/release/Hawkynt/ColorTSR)](https://github.com/Hawkynt/ColorTSR/releases/latest)
[![Nightly](https://img.shields.io/github/v/release/Hawkynt/ColorTSR?include_prereleases&sort=date&label=nightly&color=FF9800)](https://github.com/Hawkynt/ColorTSR/releases)
[![Downloads](https://img.shields.io/github/downloads/Hawkynt/ColorTSR/total)](https://github.com/Hawkynt/ColorTSR/releases)

> A tiny terminate-and-stay-resident program for MS-DOS that recolours the text screen in the background, giving plain text-mode editors like EDIT, Turbo Pascal or Power BASIC live syntax highlighting — digits, operators, brackets and string literals each get their own colour while you type, on machines that never had it built in.

## 📦 Install

Download `COLTSR.COM` from the [latest release](https://github.com/Hawkynt/ColorTSR/releases/latest) (or a `nightly-*` prerelease), put it somewhere on your DOS `PATH`, and load it — optionally from `AUTOEXEC.BAT`.

## 🚀 Usage

```text
C:\> COLTSR.COM
Handler installed !

C:\> EDIT MYFILE.BAS      (any text-mode editor)

C:\> COLTSR.COM
Freed Memory
```

Running it a second time unloads it from memory again.

## ✨ Features

- Real-time colouring of digits, operators, brackets and quoted strings, written straight into text video memory on the timer interrupt
- Editor-agnostic: works with MS-DOS `EDIT`, Power BASIC, Turbo Pascal, Turbo C and most other text-mode editors
- Tiny single-segment `.COM` TSR, well under 1 KiB resident
- Detects double-loading, and refuses to unload (instead of crashing) when another TSR has chained into the interrupt vectors after it
- Caveat: it is always active once loaded — it does not detect which program is in the foreground, so any text-mode application gets coloured

## 🛠️ Building

The source is MASM/TASM dialect — it assembles with the open-source [JWasm](https://github.com/Baron-von-Riedesel/JWasm) (or [UASM](https://github.com/Terraspace/UASM)) on any modern OS, and with Borland's TASM on real DOS. NASM will *not* assemble it (different syntax dialect).

```bash
make        # assemble COLTSR.COM (needs jwasm on the PATH)
make test   # run the behavioral suite inside DOSBox (needs dosbox on the PATH)
```

The test suite runs the real binary in DOSBox and verifies observable behavior: install/remove round-trip, actual colourization of video memory (equivalence classes and boundary cells), a negative control after removal, and the refused removal while the interrupt vectors are foreign-owned.

CI builds and tests every push and pull request on ubuntu and windows. Every green CI run on `main` publishes a `nightly-yyyyMMdd` prerelease; stable releases are cut by manually dispatching the Release workflow, which tags the dated marker `vyyyyMMdd` — the artifact version itself comes from the `VERSION` file plus the commit count (`version.pl`), never from git tags.

## ❤️ Support

If this project saves you time or money, consider supporting its development:

[![GitHub Sponsors](https://img.shields.io/badge/GitHub-Sponsor-EA4AAA?logo=githubsponsors)](https://github.com/sponsors/Hawkynt)
[![PayPal](https://img.shields.io/badge/PayPal-Donate-00457C?logo=paypal)](https://www.paypal.me/hawkynt)

## 📜 License

Licensed under LGPL-3.0-or-later — see [LICENSE](LICENSE).
