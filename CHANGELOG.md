# Changelog

## v20260605 (2026-06-05)

### Added
- house-standard pipeline scripts (version.pl, update-changelog.mjs, prune-nightlies.mjs), VERSION file as the non-.NET version source, CHANGELOG seed and baseline .editorconfig # entry-point guards of the .mjs scripts misfired in working copies whose path contains blanks (file-URL percent-encoding); compare via pathToFileURL instead (8feeed5)
- CI pipeline assembling COLTSR.COM and running the DOSBox test suite on every push/PR + release pipeline packaging and publishing tagged builds (v*) (7a06f2e)
- behavioral test suite running the real binary inside DOSBox: install/remove round-trip, video memory colorization probes (equivalence classes + boundary cell), negative control after removal and refused removal while INT 1Ch is foreign-owned (6000186)
- Makefile building COLTSR.COM and the test fixtures via JWasm + .gitignore for assembler outputs and the test scratch area (4329862)
- LICENSE (b8e047f)
- initial commit (6ea0001)

### Changed
- README reshaped to the house skeleton (title, generated badge block, one-liner blockquote, Install/Usage/Features/Building/License) with emoji-free headers and the full canonical badge rows including Ship (c61aec7)
- CI/CD reshaped to the hawkynt-standard quartet * ci.yml runs the ubuntu+windows matrix; DOSBox suite required on ubuntu, advisory on windows * release.yml is manual dispatch only, reuses ci.yml, refreshes CHANGELOG.md and tags the dated marker vyyyyMMdd instead of triggering on version tags + nightly.yml publishing GFS-pruned nightly-yyyyMMdd prereleases from the exact SHA CI validated + _build.yml as the single shared packaging block versioning artifacts from the VERSION file + commit count (cf08875)
- document building with JWasm/UASM/TASM and the DOSBox-based test suite - misleading NASM build instructions (the source is MASM/TASM dialect) + build status and release badges (bb3e891)
- assemble with any MASM-compatible assembler (JWasm/UASM/TASM) by replacing the TASM-only codeseg directive with .code (c6121e9)
- rename to README.md and standardize the badge block to the house style (d2cf63e)
- readme (5cd84e4)

All notable changes are recorded here. This file is maintained automatically by
`.github/workflows/scripts/update-changelog.mjs`, which bucketises commits by
their prefix (`+` added, `*` changed, `-` removed, `#` fixed).

## [Unreleased]

- Initial repository setup.
