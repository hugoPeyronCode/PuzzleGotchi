# PuzzleGotchi - File Structure

A Tamagotchi-style puzzle game built with SwiftUI and SwiftData.

## 📁 Project Structure

```
PuzzleGotchi/
├── PuzzleGotchiApp.swift          # Main app entry point
├── ContentView.swift              # Root content view
│
├── Models/                        # Data models
│   ├── Pet.swift                  # Pet model with SwiftData
│   ├── PetState.swift             # Pet state representation
│   └── Actions/
│       └── TamagotchiAction.swift # Protocol for game actions
│
├── ViewModels/                    # View models
│   └── GameViewModel.swift        # Main game state management
│
├── Views/                         # All SwiftUI views
│   ├── Home/
│   │   └── HomeView.swift         # Main home screen
│   │
│   ├── Components/                # Shared components
│   │   ├── PetView.swift          # Pet display
│   │   ├── LifeGaugeView.swift    # Life indicator
│   │   ├── PuzzleListView.swift   # Puzzle selection list
│   │   └── GameComponents.swift   # Shared game UI components
│   │
│   └── Games/                     # Game modules
│       ├── Binario/
│       │   ├── BinarioGameView.swift
│       │   ├── BinarioViewModel.swift
│       │   └── Components/
│       │       └── BinarioComponents.swift
│       │
│       ├── Kings/
│       │   ├── KingsGameView.swift
│       │   ├── KingsViewModel.swift
│       │   └── Components/
│       │       └── KingsComponents.swift
│       │
│       └── Minesweeper/
│           ├── MinesweeperGameView.swift
│           ├── MinesweeperViewModel.swift
│           └── Components/
│               └── MinesweeperComponents.swift
│
├── Services/                      # App services
│   └── HapticsService.swift       # Haptic feedback service
│
└── Utilities/                     # Utilities and helpers
    ├── Constants.swift            # App-wide constants
    └── Extensions/
        └── Collection+SafeAccess.swift
```

## 🎮 Game Modules

Each game follows a consistent structure:
- **GameView**: Main view with UI and layout
- **ViewModel**: Game logic and state management
- **Components**: Game-specific UI components

### Adding a New Game

1. Create a new folder in `Views/Games/`
2. Add `[GameName]GameView.swift`
3. Add `[GameName]ViewModel.swift`
4. Add game-specific components in `Components/` subfolder
5. Register the game in `TamagotchiAction.swift`
6. Add case in `HomeView.puzzleView(for:viewModel:)`

## 🎨 Constants

All colors, timing, and game settings are centralized in `Utilities/Constants.swift`:

- **Colors**: UI color scheme
- **Timing**: Decay intervals and durations
- **GameSettings**: Life values, revival thresholds
- **GridSize**: Default grid sizes for each game

## 🔧 Services

### HapticsService
Provides standardized haptic feedback:
- Button taps
- Success/warning/error notifications
- Game-specific feedback (puzzle complete, pet died, etc.)

## 📊 Data Flow

```
Pet (SwiftData Model)
    ↓
GameViewModel (Observation)
    ↓
HomeView
    ↓
PuzzleGameViews
```

## 🚀 Getting Started

1. Open the project in Xcode 15+
2. Build and run on iOS 17+ device or simulator
3. The app will automatically create a pet on first launch

## 🎯 Features

- **Pet Life System**: Decays over time, restore by completing puzzles
- **Multiple Puzzles**: Binario, Minesweeper, and Kings puzzles
- **Revival System**: Complete 3 puzzles to revive a dead pet
- **Haptic Feedback**: Rich tactile feedback throughout the app
- **Persistence**: SwiftData automatically saves pet state

## 📝 Notes

- Uses Swift 5.9+ features (Observation, @Observable)
- Requires iOS 17+ for SwiftData and modern SwiftUI features
- All colors use native SwiftUI colors for consistency
- Timer-based life decay with background handling
