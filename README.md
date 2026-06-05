# 🎨 Color TSR - Syntax Highlighting for MS-DOS

[![License](https://img.shields.io/github/license/Hawkynt/ColorTSR)](https://github.com/Hawkynt/ColorTSR/blob/main/LICENSE)
[![Language](https://img.shields.io/github/languages/top/Hawkynt/ColorTSR?color=8957D5)](https://github.com/Hawkynt/ColorTSR)
[![Build](https://github.com/Hawkynt/ColorTSR/actions/workflows/ci.yml/badge.svg)](https://github.com/Hawkynt/ColorTSR/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/Hawkynt/ColorTSR)](https://github.com/Hawkynt/ColorTSR/releases/latest)

![Last Commit](https://img.shields.io/github/last-commit/Hawkynt/ColorTSR?branch=main)
![Activity](https://img.shields.io/github/commit-activity/m/Hawkynt/ColorTSR)

[![Stars](https://img.shields.io/github/stars/Hawkynt/ColorTSR?color=FFD700)](https://github.com/Hawkynt/ColorTSR/stargazers)
[![Forks](https://img.shields.io/github/forks/Hawkynt/ColorTSR?color=008080)](https://github.com/Hawkynt/ColorTSR/network/members)
[![Issues](https://img.shields.io/github/issues/Hawkynt/ColorTSR)](https://github.com/Hawkynt/ColorTSR/issues)
![Code Size](https://img.shields.io/github/languages/code-size/Hawkynt/ColorTSR?color=4CAF50)
![Repo Size](https://img.shields.io/github/repo-size/Hawkynt/ColorTSR?color=FF9800)

> Ever wished for a splash of color in your MS-DOS text editor? ✨ This little TSR brings syntax highlighting to your favorite classic editors!

## 🤔 What is it?

Color TSR is a [Terminate-and-Stay-Resident (TSR)](https://en.wikipedia.org/wiki/Terminate-and-stay-resident_program) program for MS-DOS. In simple terms, it's a small program that loads into memory and runs in the background, enhancing other programs. In this case, it adds color to text as you type in various text editors.

## 🚀 Features

*   **Real-time Syntax Highlighting:** Adds color to keywords, strings, numbers, and symbols as you type.
*   **Lightweight:** It's a tiny program that won't slow down your system.
*   **Customizable:** (Future goal) The color scheme can be customized.

## 💻 Compatibility

This TSR works with many text-based editors on MS-DOS, including:

*   MS-DOS Editor (`EDIT`)
*   Power BASIC
*   Turbo Pascal
*   Turbo C
*   ...and many others!

## 🛠️ How to Use

1.  **Get the binary:** Download `COLTSR.COM` from the [latest release](https://github.com/Hawkynt/ColorTSR/releases/latest), or build it yourself (see below).
2.  **Run the TSR:**
    ```bash
    COLTSR.COM
    ```
    The TSR is now loaded into memory.
3.  **Start your editor:**
    ```bash
    EDIT MYFILE.TXT
    ```
    You should now see syntax highlighting in the editor.
4.  **To unload the TSR:**
    ```bash
    COLTSR.COM
    ```
    Running the program again will unload it from memory.

## 🏗️ Building from Source

The source is written in MASM/TASM dialect. It assembles with the open-source [JWasm](https://github.com/Baron-von-Riedesel/JWasm) (or [UASM](https://github.com/Terraspace/UASM)) on any modern OS, and with Borland's TASM on real DOS:

```bash
# JWasm (Windows/Linux/macOS)
jwasm -bin -Fo=COLTSR.COM COLTSR.ASM

# or simply
make
```

> **Note:** NASM will *not* assemble this source — it uses a different syntax dialect.

## ✅ Testing

The test suite runs the real binary inside [DOSBox](https://www.dosbox.com/) and verifies its observable behavior: install/uninstall messages, actual colorization of video memory (digits, operators, strings — including boundary cells), the negative control after removal, and the refusal to unload while another TSR owns the interrupt vectors.

```bash
make test            # needs jwasm + dosbox on the PATH
```

Both build and tests run automatically in CI on every push and pull request; tagging `v*` builds, tests, and publishes a release.

## ⚠️ Limitations

The TSR is always active once loaded. It doesn't detect if you are in a supported text editor, so it will try to color text in any application. This is usually harmless, but can have unexpected visual results.

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request. Some ideas for improvement:

*   Add a configuration file for custom colors.
*   Improve editor detection.
*   Add support for more languages/syntaxes.

## 📜 License

This project is licensed under the LGPL 3.0 License. See the [LICENSE](LICENSE) file for details.

## 🙏 Credits

*   **Author:** Hawkynt