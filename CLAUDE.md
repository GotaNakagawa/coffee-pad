# CLAUDE.md
必ず日本語で返答してください。
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Building and Running
- Build: Use Xcode's build system (⌘+B) or run from simulator
- Tests: Run via Xcode Test Navigator or ⌘+U

### Code Quality
- **SwiftLint**: Runs automatically on build. Manual check with `swiftlint --config .swiftlint.yml`
- **SwiftFormat**: Runs automatically on build. Manual formatting via right-click CoffeePad folder > SwiftFormatPlugin

### Hot Reloading
- **InjectionIII**: Configured for rapid development iteration. Use `#if DEBUG` wrapped `Inject.ViewControllerHost()` calls for hot reloading

## Architecture Overview

**CoffeePad** is a SwiftUI-based iOS app for managing coffee brewing methods and recipes.

### Core Architecture
- **SwiftUI + SwiftData**: Modern iOS app architecture with declarative UI
- **MVVM Pattern**: State management through `@State`, `@Binding`, `@ObservedObject`
- **Navigation**: `NavigationStack` with programmatic navigation
- **Data Layer**: Currently UserDefaults for persistence, SwiftData configured for future use

### Key Models
- **BrewMethod**: Core brewing recipe with steps, parameters (temp, weight, time)
- **StepDefinition**: Template system for brewing steps with predefined types
- **BrewStep**: Individual brewing actions with user customization

### View Architecture
```
HomeView (root)
├── BrewMethodListView (brew methods management)
├── CreateBrewMethodView (multi-step brew creation)
│   ├── CreateBrewMethodStepFlow (step ordering/drag-drop)
│   └── BrewMethodConfirmView (final review)
└── Components/ (reusable UI elements)
```

### Data Flow
- **UserDefaults**: JSON serialization for BrewMethod persistence
- **Codable**: All models implement Codable for easy serialization
- **Drag & Drop**: Custom drop delegates for step reordering

## Key Development Patterns

### SwiftUI Conventions
- Small, focused view components
- `@Environment(\.dismiss)` for modal dismissal
- Progressive disclosure in multi-step forms
- Custom modifiers for consistent styling

### Code Organization
- Feature-based folder structure (`Views/BrewMethod/`, `Views/Home/`)
- Separate Models/ directory for data structures
- Components/ for reusable UI elements

### Japanese Localization
- UI text and step names in Japanese
- Consider localization when adding new user-facing strings

## Configuration Notes

### Build Settings
- `ENABLE_USER_SCRIPT_SANDBOXING = NO` (required for SwiftLint/SwiftFormat scripts)
- `EMIT_FRONTEND_COMMAND_LINES = YES` (required for InjectionIII)

### Dependencies
- **SwiftFormat**: Added via SPM for code formatting
- **InjectionIII**: External tool for hot reloading during development

### SwiftLint Configuration
- Relaxed line length limits (300 warning, 500 error)
- Disabled some restrictive rules for SwiftUI development
- Enabled many opt-in rules for code quality
- Excludes build artifacts and dependencies