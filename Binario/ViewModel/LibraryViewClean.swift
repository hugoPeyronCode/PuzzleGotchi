//
//  LibraryView.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import SwiftUI

// MARK: - Filter Options

enum LibrarySort {
  case lastPurchased
  case difficulty
  case completion
  case name
}

enum CompletionFilter {
  case all
  case completed
  case inProgress
}

// MARK: - Library View Model

@Observable
class LibraryViewModel {
  var purchasedPacks: [PuzzlePack] = []
  var selectedSort: LibrarySort = .lastPurchased
  var completionFilter: CompletionFilter = .all
  
  init() {
    loadPurchasedPacks()
  }
  
  func loadPurchasedPacks() {
    // Mock data - replace with actual persistence
    purchasedPacks = [
      PuzzlePack(type: .mambo, cardCount: 5, price: 100, difficulty: .easy, isPurchased: true),
      PuzzlePack(type: .sudoku, cardCount: 4, price: 150, difficulty: .medium, isPurchased: true),
      PuzzlePack(type: .kings, cardCount: 6, price: 200, difficulty: .hard, isPurchased: true),
      PuzzlePack(type: .shikaku, cardCount: 5, price: 120, difficulty: .easy, isPurchased: true),
      PuzzlePack(type: .pipes, cardCount: 4, price: 180, difficulty: .expert, isPurchased: true),
    ]
  }
  
  var filteredPacks: [PuzzlePack] {
    var packs = purchasedPacks
    
    // Apply completion filter
    // This would check actual completion status in real implementation
    
    // Apply sorting
    switch selectedSort {
    case .lastPurchased:
      break // Already in order
    case .difficulty:
      packs.sort { $0.difficulty.sortOrder < $1.difficulty.sortOrder }
    case .completion:
      break // Would sort by completion percentage
    case .name:
      packs.sort { $0.type.rawValue < $1.type.rawValue }
    }
    
    return packs
  }
}

extension PuzzlePack.Difficulty {
  var sortOrder: Int {
    switch self {
    case .easy: return 0
    case .medium: return 1
    case .hard: return 2
    case .expert: return 3
    }
  }
}

// MARK: - Main Library View

struct LibraryView: View {
  @State private var viewModel = LibraryViewModel()
  @State private var selectedPack: PuzzlePack?
  
  var body: some View {
    VStack(spacing: 0) {
      // Header
      libraryHeader
      
      // Content
      ScrollView {
        VStack(spacing: 20) {
          // Statistics
          statisticsSection
          
          // Filters
          filtersSection
          
          if viewModel.filteredPacks.isEmpty {
            emptyStateView
          } else {
            // Horizontal scrolling cards
            cardsSection
          }
        }
        .padding(.vertical)
      }
    }
  }
  
  private var libraryHeader: some View {
    Text("Library")
      .font(.largeTitle)
      .fontWeight(.bold)
      .fontDesign(.rounded)
      .padding()
  }
  
  private var statisticsSection: some View {
    VStack(spacing: 15) {
      HStack(spacing: 15) {
        StatCard(
          title: "Packs",
          value: "\(viewModel.purchasedPacks.count)",
          icon: "square.stack.3d.up.fill",
          color: .blue
        )
        
        StatCard(
          title: "Games",
          value: "\(totalGames)",
          icon: "gamecontroller.fill",
          color: .green
        )
      }
      
      HStack(spacing: 15) {
        StatCard(
          title: "Completed",
          value: "\(completedGames)",
          icon: "checkmark.circle.fill",
          color: .orange
        )
        
        StatCard(
          title: "To Complete",
          value: "\(totalGames - completedGames)",
          icon: "hourglass",
          color: .purple
        )
      }
    }
    .padding(.horizontal)
  }
  
  private var filtersSection: some View {
    VStack(spacing: 15) {
      // Sort options
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 10) {
          FilterChip(
            title: "Last Purchased",
            isSelected: viewModel.selectedSort == .lastPurchased
          ) {
            viewModel.selectedSort = .lastPurchased
          }
          
          FilterChip(
            title: "Difficulty",
            isSelected: viewModel.selectedSort == .difficulty
          ) {
            viewModel.selectedSort = .difficulty
          }
          
          FilterChip(
            title: "Name",
            isSelected: viewModel.selectedSort == .name
          ) {
            viewModel.selectedSort = .name
          }
        }
        .padding(.horizontal)
      }
      
      // Completion filter
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 10) {
          FilterChip(
            title: "All",
            isSelected: viewModel.completionFilter == .all
          ) {
            viewModel.completionFilter = .all
          }
          
          FilterChip(
            title: "Completed",
            isSelected: viewModel.completionFilter == .completed,
            color: .green
          ) {
            viewModel.completionFilter = .completed
          }
          
          FilterChip(
            title: "In Progress",
            isSelected: viewModel.completionFilter == .inProgress,
            color: .orange
          ) {
            viewModel.completionFilter = .inProgress
          }
        }
        .padding(.horizontal)
      }
    }
  }
  
  private var cardsSection: some View {
    VStack(alignment: .leading, spacing: 15) {
      Text("Your Collection")
        .font(.title2)
        .fontWeight(.bold)
        .fontDesign(.rounded)
        .padding(.horizontal)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
          ForEach(viewModel.filteredPacks) { pack in
            LibraryCardView(pack: pack)
              .onTapGesture {
                selectedPack = pack
              }
          }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
      }
    }
  }
  
  private var emptyStateView: some View {
    VStack(spacing: 20) {
      Image(systemName: "tray")
        .font(.system(size: 80))
        .foregroundStyle(.secondary)
      
      Text("No Packs Found")
        .font(.title2)
        .fontWeight(.bold)
      
      Text("Try adjusting your filters")
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
    .padding()
  }
  
  private var totalGames: Int {
    viewModel.purchasedPacks.reduce(0) { $0 + $1.cardCount }
  }
  
  private var completedGames: Int {
    // Mock - would track actual completion
    Int(Double(totalGames) * 0.6)
  }
}

// MARK: - Stat Card

struct StatCard: View {
  let title: String
  let value: String
  let icon: String
  let color: Color
  
  var body: some View {
    VStack(spacing: 10) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundStyle(color)
      
      Text(value)
        .font(.title)
        .fontWeight(.bold)
        .foregroundStyle(.primary)
      
      Text(title)
        .font(.caption)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 15))
  }
}

// MARK: - Filter Chip

struct FilterChip: View {
  let title: String
  let isSelected: Bool
  var color: Color = .blue
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.subheadline)
        .fontWeight(.semibold)
        .fontDesign(.rounded)
        .foregroundStyle(isSelected ? .white : .primary)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background {
          Capsule()
            .fill(isSelected ? color : Color.primary.opacity(0.1))
        }
    }
  }
}

// MARK: - Library Card View

struct LibraryCardView: View {
  let pack: PuzzlePack
  @State private var completionPercentage: Double = 0.6 // Mock data
  
  var body: some View {
    VStack(spacing: 0) {
      // Card pack visualization
      ZStack {
        // Background
        RoundedRectangle(cornerRadius: 20)
          .fill(.ultraThinMaterial)
          .overlay {
            RoundedRectangle(cornerRadius: 20)
              .stroke(pack.type.color, lineWidth: 3)
          }
        
        VStack(spacing: 15) {
          // Pack preview
          LevelPackView(
            cardNumber: pack.cardCount,
            puzzleType: pack.type
          )
          .scaleEffect(0.6)
          .frame(height: 120)
          
          // Pack info
          VStack(spacing: 8) {
            Text(pack.title)
              .font(.headline)
              .fontDesign(.rounded)
              .multilineTextAlignment(.center)
            
            HStack(spacing: 15) {
              Label("\(pack.cardCount)", systemImage: "square.stack.3d.up.fill")
                .font(.caption)
                .foregroundStyle(.secondary)
              
              Label(pack.difficulty.rawValue, systemImage: "flame.fill")
                .font(.caption)
                .foregroundStyle(difficultyColor)
            }
          }
          .padding(.horizontal)
          
          // Progress section
          VStack(spacing: 8) {
            HStack {
              Text("Progress")
                .font(.caption2)
                .foregroundStyle(.secondary)
              
              Spacer()
              
              Text("\(Int(completionPercentage * Double(pack.cardCount)))/\(pack.cardCount)")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            }
            
            ProgressView(value: completionPercentage)
              .tint(pack.type.color)
              .scaleEffect(y: 0.6)
          }
          .padding(.horizontal)
          .padding(.bottom, 5)
          
          // Completion badge
          if completionPercentage >= 1.0 {
            HStack {
              Image(systemName: "crown.fill")
                .foregroundStyle(.yellow)
              Text("Completed!")
                .font(.caption)
                .fontWeight(.bold)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background {
              Capsule()
                .fill(.green.opacity(0.2))
            }
            .padding(.bottom, 10)
          }
        }
      }
      .frame(width: 250, height: 380)
      .shadow(color: pack.type.color.opacity(0.3), radius: 10)
    }
  }
  
  private var difficultyColor: Color {
    switch pack.difficulty {
    case .easy: return .green
    case .medium: return .blue
    case .hard: return .orange
    case .expert: return .red
    }
  }
}

#Preview {
  LibraryView()
}
