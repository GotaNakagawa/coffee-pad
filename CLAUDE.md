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
- **CRITICAL**: All new SwiftUI View components MUST include hot reload support

### Error Detection and Correction
- **MANDATORY**: Always check for Xcode errors before committing using `mcp__ide__getDiagnostics`
- **SwiftLint REQUIRED**: Run `swiftlint --config .swiftlint.yml` to detect linting violations
- **AUTO-FIX**: When errors are detected, Claude MUST automatically fix them before proceeding
- **VALIDATION**: After fixes, re-run diagnostics to ensure errors are resolved

### Branch Management
- **AUTO-DELETE**: Configure GitHub to automatically delete head branches after PR merge
- **LOCAL CLEANUP**: Run `git branch -d <branch-name>` after successful PR merge
- **REMOTE CLEANUP**: Use `git remote prune origin` to remove stale remote references

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
- **MANDATORY: All SwiftUI View components MUST include hot reload support**

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

## Component Creation Rules

### Required Hot Reload Pattern for ALL SwiftUI Views

When creating any new SwiftUI View component, Claude MUST always include the following pattern:

```swift
import Inject
import SwiftUI

struct YourComponent: View {
    @ObserveInjection var inject
    // ... other properties
    
    var body: some View {
        // ... your view content
        .enableInjection()
    }
}
```

**This is MANDATORY for ALL SwiftUI View structs. No exceptions.**

## Development Workflow Rules

### Before Every Commit
Claude MUST perform these steps in order:

1. **Error Detection**: Run `mcp__ide__getDiagnostics` to check for Swift/Xcode errors
2. **Error Resolution**: If errors are found, fix them immediately:
   - Syntax errors: Correct Swift syntax issues
   - Type errors: Fix type mismatches and missing imports
   - SwiftUI errors: Resolve view structure and modifier issues
   - Build errors: Address compilation problems
3. **Validation**: Re-run `mcp__ide__getDiagnostics` to confirm all errors are resolved
4. **Commit**: Only proceed with commit after zero errors confirmed

### Common Swift Error Patterns and Solutions

#### SwiftUI View Modifier Issues
```swift
// WRONG: Cannot apply modifiers to switch statements
switch condition {
    case .a: ViewA()
    case .b: ViewB()
}
.someModifier()

// CORRECT: Wrap in Group
Group {
    switch condition {
        case .a: ViewA()
        case .b: ViewB()
    }
}
.someModifier()
```

#### Hot Reload Integration Issues
```swift
// WRONG: Missing inject imports/properties
struct MyView: View {
    var body: some View { Text("Hello") }
}

// CORRECT: Complete hot reload setup
import Inject
import SwiftUI

struct MyView: View {
    @ObserveInjection var inject
    var body: some View {
        Text("Hello")
            .enableInjection()
    }
}
```

### Error Handling Protocol
When Xcode errors are detected:
1. **Identify**: Parse error message and location
2. **Categorize**: Determine error type (syntax, type, SwiftUI, build)
3. **Fix**: Apply appropriate solution pattern
4. **Verify**: Confirm fix resolves the specific error
5. **Test**: Ensure fix doesn't introduce new errors

## Branch Cleanup Workflow

### GitHub Repository Settings
To enable automatic branch deletion after PR merge:
1. Go to repository Settings → General → Pull Requests
2. Check "Automatically delete head branches"
3. This removes the feature branch from GitHub after merge

### Local Branch Cleanup Commands
After a PR is merged, clean up local branches:

```bash
# Switch to main and pull latest changes
git checkout main
git pull origin main

# Delete merged local branch
git branch -d <feature-branch-name>

# Remove stale remote branch references
git remote prune origin

# Alternative: Delete both local and remote tracking
git branch -D <feature-branch-name>
git push origin --delete <feature-branch-name>
```

### Automated Cleanup Script
Add to your shell profile for convenience:

```bash
# Function to clean up after PR merge
cleanup_branch() {
    if [ -z "$1" ]; then
        echo "Usage: cleanup_branch <branch-name>"
        return 1
    fi
    
    git checkout main
    git pull origin main
    git branch -d "$1"
    git remote prune origin
    echo "✅ Cleaned up branch: $1"
}
```

### Claude Workflow
When Claude learns a PR has been merged:
1. **Switch to main**: `git checkout main`
2. **Pull latest**: `git pull origin main`
3. **Delete local branch**: `git branch -d <branch-name>`
4. **Clean remote refs**: `git remote prune origin`