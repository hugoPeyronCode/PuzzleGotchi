# Binario Game - Documentation

## Overview
This is a complete Binario (also known as Takuzu or Binary Puzzle) game implementation for PuzzleGotchi. The game features a shop system where players purchase level packs, which are then generated and available to play.

## Game Rules
Binario is a logic puzzle with the following rules:
1. Fill the grid with 0s and 1s
2. No more than two consecutive identical values in any row or column
3. Each row and column must have an equal number of 0s and 1s
4. All rows must be unique, and all columns must be unique

## Project Structure

```
BinarioGame/
├── Models/
│   ├── BinarioCell.swift      # Individual cell representation
│   ├── BinarioLevel.swift     # Level data structure
│   └── LevelPack.swift        # Pack of levels for purchase
├── ViewModels/
│   ├── BinarioGameViewModel.swift  # Game logic and state
│   └── GameManager.swift      # Global game state, purchases, progress
├── Views/
│   ├── BinarioGameView.swift  # Main game interface
│   └── LevelSelectionView.swift # Level browser
└── Generator/
    └── BinarioGenerator.swift # Algorithm to generate levels
```

## Key Components

### Models

#### BinarioCell
- Represents a single cell in the grid
- Contains: value (empty/0/1), locked status, position
- Locked cells are pre-filled clues that can't be changed

#### BinarioLevel
- Complete level data including solution and initial state
- Tracks completion status and player progress
- Difficulty determines grid size (6×6 to 12×12)

#### LevelPack
- Bundles of levels for purchase
- Four difficulty tiers: Easy, Medium, Hard, Expert
- Pre-configured packs with pricing and metadata

### ViewModels

#### BinarioGameViewModel
- Manages active game state
- Handles cell toggling (empty → 0 → 1 → empty)
- Validates moves against Binario rules
- Checks for level completion
- Provides reset functionality

#### GameManager
- Global app state management
- Currency system (earn coins by completing levels)
- Pack purchase system
- Level generation on purchase
- Progress persistence (UserDefaults)

### Generator

#### BinarioGenerator
- Creates valid Binario puzzles using backtracking algorithm
- Ensures solutions follow all game rules
- Removes cells based on difficulty to create puzzles
- Generates complete packs of levels on purchase

### Views

#### BinarioGameView
- Interactive grid interface
- Cell tap to toggle values
- Visual distinction between locked and editable cells
- Color coding: Blue for 0s, Orange for 1s
- Reset and validation controls

#### LevelSelectionView
- Browse purchased packs
- Visual progress indicators
- Level completion status
- Quick level access

## Flow

### 1. Shop View
- Display available level packs
- Show current currency balance
- Purchase packs (generates levels immediately)
- Coins are deducted on purchase

### 2. Puzzle View
- Select a level to play
- Interactive Binario grid
- Real-time validation
- Completion detection

### 3. Library View
- View owned packs
- Track completion statistics
- Monitor overall progress

## Currency System
- Starting balance: 500 coins
- Pack prices: 100-500 coins based on difficulty
- Earn rewards for completing levels:
  - Easy: 10 coins
  - Medium: 20 coins
  - Hard: 35 coins
  - Expert: 50 coins

## Level Generation
When a pack is purchased:
1. `GameManager.purchasePack()` is called
2. `BinarioGenerator.generateLevelPack()` creates all levels
3. Each level uses backtracking to ensure valid solution
4. Cells are removed based on difficulty percentage
5. Levels are stored in the pack and added to available levels
6. Game data is persisted to UserDefaults

## Data Persistence
All game data is saved to UserDefaults:
- Purchased packs (including generated levels)
- Current currency balance
- Completed level IDs
- Player progress

## Difficulty Settings

| Difficulty | Grid Size | Clues | Levels | Price |
|------------|-----------|-------|--------|-------|
| Easy       | 6×6       | 45%   | 10     | 100   |
| Medium     | 8×8       | 35%   | 15     | 200   |
| Hard       | 10×10     | 25%   | 20     | 300   |
| Expert     | 12×12     | 20%   | 25     | 500   |

## Usage

### Starting the Game
1. Launch app (starts on Puzzle tab)
2. If no levels owned, user is prompted to visit Shop
3. Purchase a level pack
4. Levels are immediately available to play

### Playing a Level
1. Tap a level from selection screen
2. Tap cells to cycle through: empty → 0 → 1 → empty
3. Pre-filled cells (locked) cannot be changed
4. Complete the grid following Binario rules
5. Level auto-validates on completion
6. Earn coins for successful completion

### Game Manager Integration
All views use the shared `GameManager` via SwiftUI's environment:
```swift
@Environment(GameManager.self) private var gameManager
```

## Future Enhancements
- Hint system
- Undo/redo functionality
- Timer and scoring
- Daily challenges
- Achievements system
- Cloud save/sync
- Additional puzzle types
