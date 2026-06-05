# Agent guide — ColorTSR

Working agreement for **all** coding agents and human contributors working in
this repository. These rules are not optional. The full house spec lives in
the `Hawkynt/project-template` repo (`STANDARD.md`); this file is the
per-repo distillation.

## What this is

A tiny **x86 real-mode TSR** for MS-DOS (`COLTSR.ASM`) that live-recolours
the text screen for syntax highlighting in text-mode editors. Built via
`Makefile` (assembler on CI); hook/colour test programs live in `tests/`.

## Commits

- **Group changes semantically/logically** — one hook/feature/concern per
  commit.
- **Every subject line starts with a prefix**: `+` added · `-` removed ·
  `*` changed · `#` bug fixed · `!` critical todo.
- Never start a subject with "fix"/"bugfix"/"changed"/"modified".
- **No AI traces anywhere**: no `Co-Authored-By` AI lines, no "Generated
  with" footers, no agent mentions in messages, comments, or authorship.

## The loop (always, in this order)

1. **Before committing**: assemble exactly as `ci.yml` does (`make`); for
   behavioral changes, exercise the TSR under DOSBox with a real text-mode
   editor. Update the README when switches/behavior change; `CHANGELOG.md`
   is generated — never edit it by hand.
2. **Commit** (rules above) and **push**.
3. **Wait for CI**; on `main` a green CI triggers the nightly (prerelease +
   GFS prune). Fix and loop until everything is green.

Stable releases are **manual** (`gh workflow run release.yml`) — never cut
one unless explicitly asked.

## Code conventions

- Real-mode constraints rule: the resident part stays as small as possible —
  every byte of resident footprint and every cycle in the timer/keyboard
  hook path counts and must be justified.
- Interrupt-hook changes (1Ch et al.) document the chain behavior; never
  break unhooking/uninstall.
- Comment register usage per routine; no assumptions about DOS version
  beyond what the README states.

## README & repo conventions

- Standard frame: title → badges → one-line `>` blockquote; fixed emoji
  mapping for the standard sections (`## 📦 Install`, `## 🚀 Usage`,
  `## ✨ Features`, `## 🛠️ Building`, `## ❤️ Support`, `## 📜 License`).
- License is LGPL-3.0-or-later; the `## ❤️ Support` section and
  `.github/FUNDING.yml` stay intact.
