# LookAwayClone (macOS)

A lightweight macOS app inspired by [lookaway.com](https://lookaway.com/) that reminds you to take eye breaks using the 20-20-20 style workflow.

## Features

- Focus countdown timer (default 20 minutes)
- Break overlay prompt (default 20 seconds)
- Menu bar controls for quick start/pause/reset
- Adjustable focus and break duration

## Project structure

- `LookAwayClone/Package.swift` – Swift package manifest
- `LookAwayClone/Sources/LookAwayClone/` – SwiftUI app source

## How to run (Xcode)

1. Open **Xcode 15+** on macOS.
2. Choose **File → Open...** and open `LookAwayClone/Package.swift`.
3. Select the `LookAwayClone` scheme.
4. Set destination to **My Mac**.
5. Press **Run** (`⌘R`).

## How to run (Terminal on macOS)

From repository root:

```bash
cd LookAwayClone
swift run
```

> Note: This app uses macOS-only APIs (MenuBarExtra/AppKit), so it should be run on macOS.
