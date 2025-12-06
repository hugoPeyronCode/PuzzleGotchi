////
////  LevelSelectionView.swift
////  PuzzleGotchi
////
////  Created by Hugo Peyron on 05/12/2025.
////
//
//import SwiftUI
//
//struct LevelSelectionView: View {
//  @Environment(\.dismiss) private var dismiss
//  let gameManager: GameManager
//  let gameViewModel: BinarioGameViewModel
//  
//  var body: some View {
//    NavigationStack {
//      ScrollView {
//        VStack(spacing: 20) {
//          ForEach(gameManager.purchasedPacks) { pack in
//            PackLevelsSection(
//              pack: pack,
//              gameManager: gameManager,
//              gameViewModel: gameViewModel,
//              onLevelSelected: {
//                dismiss()
//              }
//            )
//          }
//          
//          if gameManager.purchasedPacks.isEmpty {
//            emptyStateView
//          }
//        }
//        .padding()
//      }
//      .navigationTitle("Select Level")
//      .navigationBarTitleDisplayMode(.inline)
//      .toolbar {
//        ToolbarItem(placement: .topBarTrailing) {
//          Button("Done") {
//            dismiss()
//          }
//          .foregroundStyle(.primary)
//        }
//      }
//    }
//  }
//  
//  private var emptyStateView: some View {
//    VStack(spacing: 20) {
//      Image(systemName: "cart.fill")
//        .font(.system(size: 60))
//        .foregroundStyle(.secondary)
//      
//      Text("No Levels Yet")
//        .font(.title2)
//        .fontWeight(.bold)
//        .foregroundStyle(.primary)
//      
//      Text("Visit the Shop to purchase level packs")
//        .font(.subheadline)
//        .foregroundStyle(.secondary)
//        .multilineTextAlignment(.center)
//    }
//    .padding()
//    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
//  }
//}
//
//struct PackLevelsSection: View {
//  let pack: LevelPack
//  let gameManager: GameManager
//  let gameViewModel: BinarioGameViewModel
//  let onLevelSelected: () -> Void
//  
//  var body: some View {
//    VStack(alignment: .leading, spacing: 15) {
//      // Pack header
//      HStack {
//        Image(systemName: pack.iconName)
//          .font(.title2)
//          .foregroundStyle(iconColor)
//        
//        VStack(alignment: .leading) {
//          Text(pack.name)
//            .font(.headline)
//            .foregroundStyle(.primary)
//          
//          Text("\(pack.difficulty.rawValue) • \(completedCount)/\(pack.levelCount) completed")
//            .font(.caption)
//            .foregroundStyle(.secondary)
//        }
//        
//        Spacer()
//      }
//      
//      // Level grid
//      LazyVGrid(columns: [
//        GridItem(.adaptive(minimum: 60), spacing: 10)
//      ], spacing: 10) {
//        ForEach(Array(gameManager.getLevelsForPack(pack).enumerated()), id: \.element.id) { index, level in
//          LevelButton(
//            levelNumber: index + 1,
//            isCompleted: gameManager.completedLevelIds.contains(level.id),
//            level: level,
//            gameViewModel: gameViewModel,
//            onSelected: onLevelSelected
//          )
//        }
//      }
//    }
//    .padding()
//    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
//  }
//  
//  private var completedCount: Int {
//    let levels = gameManager.getLevelsForPack(pack)
//    return levels.filter { gameManager.completedLevelIds.contains($0.id) }.count
//  }
//  
//  private var iconColor: Color {
//    switch pack.difficulty {
//    case .easy: return .green
//    case .medium: return .blue
//    case .hard: return .orange
//    case .expert: return .red
//    }
//  }
//}
//
//struct LevelButton: View {
//  let levelNumber: Int
//  let isCompleted: Bool
//  let level: BinarioLevel
//  let gameViewModel: BinarioGameViewModel
//  let onSelected: () -> Void
//  
//  var body: some View {
//    Button {
//      gameViewModel.loadLevel(level)
//      onSelected()
//    } label: {
//      ZStack {
//        RoundedRectangle(cornerRadius: 12)
//          .fill(isCompleted ? Color.green.opacity(0.3) : Color.primary.opacity(0.15))
//          .frame(width: 60, height: 60)
//        
//        if isCompleted {
//          Image(systemName: "checkmark")
//            .font(.caption)
//            .foregroundStyle(.green)
//            .offset(x: 18, y: -18)
//        }
//        
//        Text("\(levelNumber)")
//          .font(.headline)
//          .foregroundStyle(.primary)
//      }
//    }
//  }
//}
//
//#Preview {
//  LevelSelectionView(gameManager: GameManager(), gameViewModel: BinarioGameViewModel())
//}
