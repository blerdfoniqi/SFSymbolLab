# Contributing to SF Symbol Lab

Thanks for your interest in improving SF Symbol Lab! This is a small, dependency-free SwiftUI showcase, so contributing is straightforward.

## Prerequisites

- **Xcode 16+** (the project uses synchronized file groups)
- **iOS 17.0+** SDK / simulator
- No package manager or third-party dependencies

## Getting started

1. Fork and clone the repo.
2. Open `SFSymbolLab.xcodeproj` in Xcode.
3. Select an iOS 17+ simulator and Build & Run (⌘R).

> The project also builds for iPadOS, macOS 14+, and visionOS. Platform-specific modifiers are guarded with `#if`, so keep that in mind when adding UIKit-only APIs.

## Running tests

Tests use **Swift Testing** and live in `SFSymbolLabTests/`.

- In Xcode: **⌘U**
- From the CLI:

  ```bash
  xcodebuild test \
    -project SFSymbolLab.xcodeproj \
    -scheme SFSymbolLab \
    -destination 'platform=iOS Simulator,name=iPhone 16'
  ```

Please add or update tests when you change the model enums or add testable logic.

## Linting

We use [SwiftLint](https://github.com/realm/SwiftLint). Install it with `brew install swiftlint`, then run:

```bash
swiftlint
```

CI runs SwiftLint on every PR. Fix any **error**-level violations before submitting; warnings are advisory.

## Code style

- 4-space indentation, no tabs, no trailing whitespace.
- Keep views small and composable; reuse the shared components in `Components/`.
- Prefer `@State` for view-local UI state — this app is intentionally **not** MVVM (no networking, persistence, or shared state to justify it).
- Add an accessibility label for any symbol that conveys meaning; mark decorative symbols `.accessibilityHidden(true)`.
- Every demo `View` should provide a `#Preview`.

## Adding a new demo section

1. Add a case to `DemoSection` with its `title`, `icon`, `description`, `accentColor`, and `destination`.
2. Create the view in `Views/`, wrapping content in `DemoScrollView` and `DemoCard`.
3. Update the feature table in `README.md`.
4. Add tests if you introduce new model metadata.

## Regenerating screenshots

README screenshots live in `.github/screenshots/`. Regenerate them all with:

```bash
Scripts/capture_screenshots.sh "iPhone 17"
```

The script builds the app and uses a `#if DEBUG` launch hook (`SCREENSHOT_SECTION`) in `ContentView` to open each demo directly, then captures a clean status-bar screenshot via `simctl`. The app icon can likewise be regenerated with `swift Scripts/GenerateAppIcon.swift`.

## Pull requests

- Branch from `main`; keep PRs focused and small.
- Ensure the project builds and tests pass.
- Fill out the PR template checklist.
- Use clear commit messages (Conventional Commits encouraged: `feat:`, `fix:`, `docs:` …).

## Reporting issues

Use the issue templates for bug reports and feature requests. For bugs, include your Xcode/iOS versions and reproduction steps.

## License

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).
