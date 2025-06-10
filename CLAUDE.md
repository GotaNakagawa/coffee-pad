# CLAUDE.md
必ず日本語で返答してください。
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## ⚠️ CRITICAL NOTICE: ULTRA-STRICT CODE QUALITY ENFORCEMENT ⚠️

**THIS PROJECT ENFORCES ZERO-TOLERANCE CODE QUALITY STANDARDS**

🚫 **ABSOLUTELY FORBIDDEN**:
- ANY compile errors
- ANY SwiftLint errors  
- ANY missing hot reload support
- ANY non-existent properties/methods
- ANY architectural violations

✅ **MANDATORY REQUIREMENTS**:
- 100% error-free code
- Zero SwiftLint violations
- Complete recursive validation
- Perfection before proceeding

**VIOLATION CONSEQUENCES**: Immediate task termination and recursive fix requirement.

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

### After Every Code Change
Claude MUST perform these steps in order after creating or modifying ANY Swift file:

**CRITICAL: This is a MANDATORY RECURSIVE process. Claude MUST continue until ALL violations are resolved. NO EXCEPTIONS.**

#### Phase 1: Initial Comprehensive Validation
1. **Error Detection**: Run `mcp__ide__getDiagnostics` to check for Swift/Xcode errors
2. **SwiftLint Check**: Run `swiftlint --config .swiftlint.yml` to detect ALL code quality violations
3. **Violation Classification**: Categorize ALL findings:
   - **CRITICAL ERRORS** (Compile errors, type errors): MUST be fixed immediately
   - **SWIFTLINT ERRORS** (Code structure violations): MUST be fixed immediately  
   - **SWIFTLINT WARNINGS** (Code quality issues): MUST be fixed unless technically impossible
   - **INFORMATIONAL** (Spelling, etc.): May be ignored if not fixable

#### Phase 2: Mandatory Fix Implementation
4. **ZERO-TOLERANCE ERROR RESOLUTION**: Fix ALL critical errors and SwiftLint errors immediately:
   - **Closure Body Length**: Split into computed properties/separate views (max 50 lines warning, 100 lines error)
   - **Type Body Length**: Extract nested structs to separate files (max 250 lines)
   - **Function Body Length**: Extract complex logic into private functions (max 50 lines)
   - **Line Length**: Break at logical points (max 300 chars warning, 500 chars error)
   - **Multiple Closures with Trailing Closure**: Use explicit parameter labels
   - **Vertical Whitespace**: Remove extra blank lines (max 1 consecutive)
   - **Trailing Newline**: Ensure single trailing newline
   - **File Name**: Match primary type name in file
   - **Cyclomatic Complexity**: Simplify conditional logic
   - **Property Existence**: Verify all model properties exist before use

#### Phase 3: Recursive Validation Loop
5. **IMMEDIATE RE-VALIDATION**: After EACH individual fix, run:
   - `mcp__ide__getDiagnostics` 
   - `swiftlint --config .swiftlint.yml`

6. **MANDATORY RECURSIVE LOOP**: If ANY violations remain:
   - **INSTANT RETURN**: Immediately GOTO Phase 2
   - **NO PROGRESS TOLERANCE**: Continue until ZERO violations
   - **ITERATION TRACKING**: Track fix attempts to prevent infinite loops
   - **SAFETY LIMIT**: Maximum 15 iterations, then report failure

#### Phase 4: Success Criteria (STRICT)
7. **ABSOLUTE COMPLETION REQUIREMENTS**:
   - ✅ `mcp__ide__getDiagnostics` returns ZERO errors
   - ✅ `swiftlint --config .swiftlint.yml` shows ZERO "error" violations  
   - ✅ SwiftLint warnings reduced to minimum possible (target: zero)
   - ✅ All code compiles successfully
   - ✅ All properties/methods exist and are accessible

**ABSOLUTE ENFORCEMENT RULES**:
- 🚫 **NEVER proceed** with other tasks until validation passes 100%
- 🚫 **NEVER ignore** SwiftLint errors under any circumstances  
- 🚫 **NEVER accept** "good enough" - only perfection is acceptable
- 🚫 **NEVER skip** the recursive validation process
- ✅ **ALWAYS** achieve zero critical violations before continuing

### Before Every Commit (ULTRA-STRICT)
Claude MUST perform these steps in order with ZERO tolerance for violations:

#### Pre-Commit Comprehensive Audit
1. **Full Project Error Scan**: Run `mcp__ide__getDiagnostics` on ALL files
2. **Complete SwiftLint Audit**: Run `swiftlint --config .swiftlint.yml` on entire project
3. **Build Verification**: Ensure project builds successfully (if build commands available)
4. **Property Verification**: Confirm all model properties used in code actually exist

#### Pre-Commit Success Criteria (ZERO-TOLERANCE)
5. **MANDATORY REQUIREMENTS** (ALL must be met):
   - ✅ **ZERO compile errors** across entire project
   - ✅ **ZERO SwiftLint errors** across entire project
   - ✅ **SwiftLint warnings minimized** (target: zero, acceptable if technically unfixable)
   - ✅ **All files follow naming conventions**
   - ✅ **All code follows architectural patterns**
   - ✅ **Hot reload support** added to all SwiftUI views

#### Pre-Commit Failure Protocol
6. **If ANY requirement fails**:
   - 🚫 **IMMEDIATELY ABORT** commit process
   - 🔄 **RETURN** to "After Every Code Change" recursive process
   - 🔧 **FIX ALL** violations before attempting commit again
   - 📋 **DOCUMENT** what was fixed in commit message

#### Commit Authorization
7. **Only commit when**:
   - All validation passes 100%
   - Code quality is pristine
   - No technical debt introduced
   - All architectural standards maintained

**PRE-COMMIT ENFORCEMENT**:
- 🚫 **NEVER commit** with any SwiftLint errors
- 🚫 **NEVER commit** with any compile errors  
- 🚫 **NEVER commit** with missing hot reload support
- 🚫 **NEVER commit** with property/method errors
- ✅ **ONLY commit** when code is absolutely perfect

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

### Ultra-Strict Recursive Error Handling Protocol
When ANY Xcode errors or SwiftLint violations are detected, Claude MUST follow this MANDATORY RECURSIVE process:

#### Violation Detection and Analysis (COMPREHENSIVE)
1. **DEEP SCAN**: Parse ALL error messages, violation types, and exact locations
2. **STRICT CATEGORIZATION**: Classify by severity and fix priority:
   - **LEVEL 1 CRITICAL**: Compile/build errors (IMMEDIATE fix required)
   - **LEVEL 2 ERRORS**: SwiftLint errors (IMMEDIATE fix required)
   - **LEVEL 3 WARNINGS**: SwiftLint warnings (MUST fix unless impossible)
   - **LEVEL 4 INFO**: Informational (Fix if possible)

#### Mandatory Fix Implementation (ZERO-COMPROMISE)
3. **SYSTEMATIC FIXING**: Address violations in strict priority order:
   - Fix ALL Level 1 before Level 2
   - Fix ALL Level 2 before Level 3
   - Document any Level 3 that cannot be fixed
4. **PRECISION FIXING**: Apply exact solution patterns:
   - **Property Errors**: Verify model definitions before use
   - **Closure Length**: Split immediately when >50 lines (warning) or >100 lines (error)
   - **Type Length**: Extract when >250 lines
   - **Line Length**: Break when >300 chars (warning) or >500 chars (error)
   - **Trailing Closure**: Convert to explicit parameters
   - **Whitespace**: Remove extra blank lines
   - **File Naming**: Rename to match primary type

#### Recursive Validation (RELENTLESS)
5. **IMMEDIATE VERIFICATION**: After EACH single fix:
   - Run `mcp__ide__getDiagnostics`
   - Run `swiftlint --config .swiftlint.yml`
   - Parse results for ANY remaining violations

#### Recursive Loop Control (FAIL-SAFE)
6. **LOOP MANAGEMENT**: 
   - **Max Iterations**: 15 attempts
   - **Progress Tracking**: Must show improvement each iteration
   - **Stagnation Detection**: If same violation appears 3 times, escalate
   - **Success Condition**: ONLY when zero violations achieved

#### Failure Escalation Protocol
7. **ESCALATION TRIGGERS**:
   - 15 iterations reached without zero violations
   - Same violation persists after 3 fix attempts
   - New violations consistently introduced by fixes
   - Model/property errors that require structural changes

**RECURSIVE ENFORCEMENT (NON-NEGOTIABLE)**:
- 🔄 **ALWAYS continue** until zero violations or failure escalation
- 📊 **ALWAYS track** progress and iteration count  
- 🚫 **NEVER proceed** with incomplete fixes
- 🚫 **NEVER ignore** any category of violation
- 🚫 **NEVER accept** partial solutions
- ✅ **ONLY stop** when validation is 100% clean

### SwiftLint Violation Patterns and Auto-Fix Strategies

#### Closure Body Length Violations
```swift
// PROBLEM: Long closure body (>50 lines for warnings, >100 lines for errors)
var body: some View {
    ScrollView {
        VStack {
            // ... 60+ lines of content
        }
    }
}

// SOLUTION: Extract to computed properties or separate views
var body: some View {
    ScrollView {
        mainContent
    }
}

private var mainContent: some View {
    VStack {
        headerSection
        bodySection
        footerSection
    }
}
```

#### Type Body Length Violations
```swift
// PROBLEM: Type body too long (>250 lines)
struct LargeView: View {
    // ... 300+ lines of code including nested structs
}

// SOLUTION: Extract nested structs to separate private structs
struct LargeView: View {
    var body: some View {
        MainContentView()
    }
}

private struct MainContentView: View {
    // ... extracted content
}
```

#### Multiple Closures with Trailing Closure
```swift
// PROBLEM: Trailing closure with multiple closures
Button({
    // action
}) {
    // label
}

// SOLUTION: Use explicit parameter labels
Button(
    action: {
        // action
    },
    label: {
        // label
    }
)
```

### Ultra-Strict Recursive Validation Example
```
ITERATION 1 (COMPREHENSIVE SCAN):
- Run: mcp__ide__getDiagnostics + swiftlint --config .swiftlint.yml
- Found: 2 compile errors, 3 closure body length errors, 1 type body length error, 4 warnings
- Classification: 2 Level 1, 4 Level 2, 4 Level 3
- Fix Priority: Address 2 compile errors first
- Fix: Correct property name errors (grindMemo → comment)
- Re-run: mcp__ide__getDiagnostics + swiftlint
- Result: 0 compile errors, 4 SwiftLint errors, 4 warnings remain

ITERATION 2 (SWIFTLINT ERRORS):
- Found: 3 closure body length errors (59, 78, 142 lines), 1 type body length error (320 lines)
- Fix: Extract all long closures to computed properties 
- Re-run: mcp__ide__getDiagnostics + swiftlint
- Result: 1 type body length error, 2 new warnings (introduced by extraction)

ITERATION 3 (TYPE LENGTH):
- Found: 1 type body length error (320 lines > 250 limit)
- Fix: Extract 3 private structs to separate file (DetailRowView.swift)
- Re-run: mcp__ide__getDiagnostics + swiftlint
- Result: 3 new violations (file naming, trailing newline, vertical whitespace)

ITERATION 4 (CLEANUP):
- Found: File name violation, trailing newline, vertical whitespace
- Fix: Rename file to match primary type, add newline, remove extra spaces
- Re-run: mcp__ide__getDiagnostics + swiftlint
- Result: ZERO errors, ZERO violations, ZERO warnings

SUCCESS: 100% clean validation - proceed with next task
```

**ULTRA-STRICT PRINCIPLES**:
- 🎯 **Target: ZERO violations** of any kind
- 🔄 **Continue recursively** until perfection achieved  
- 📊 **Track every violation** and fix systematically
- 🚫 **Accept nothing less** than 100% clean validation

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