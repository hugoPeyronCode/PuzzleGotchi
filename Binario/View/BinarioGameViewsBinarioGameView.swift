//
//  BinarioGameView.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import SwiftUI

struct BinarioGameView: View {
  @Bindable var viewModel: BinarioGameViewModel
  @State private var showingCompletionAlert = false
  @State private var showingValidationErrors = false
  
  var body: some View {
    VStack(spacing: 20) {
      // Header
      headerView
      
      // Game Grid
      gameGridView
      
      // Controls
      controlsView
    }
    .alert("Level Complete! 🎉", isPresented: $showingCompletionAlert) {
      Button("Continue") {
        // Handle continuation
      }
    } message: {
      Text("You completed the level in \(viewModel.moveCount) moves!")
    }
    .onChange(of: viewModel.isLevelComplete) { oldValue, newValue in
      if newValue {
        showingCompletionAlert = true
      }
    }
  }
  
  private var headerView: some View {
    VStack(spacing: 10) {
      Text(viewModel.currentLevel?.difficulty.rawValue ?? "Binario")
        .font(.title2)
        .fontWeight(.bold)
        .foregroundStyle(.primary)
      
      HStack(spacing: 20) {
        Label("\(viewModel.moveCount)", systemImage: "arrow.clockwise")
          .font(.caption)
          .foregroundStyle(.secondary)
        
        if let level = viewModel.currentLevel {
          Text("\(level.gridSize)×\(level.gridSize)")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 15))
  }
  
  private var gameGridView: some View {
    GeometryReader { geometry in
      let gridSize = viewModel.grid.count
      let spacing: CGFloat = 4
      let availableWidth = min(geometry.size.width, geometry.size.height) - (spacing * CGFloat(gridSize + 1))
      let cellSize = availableWidth / CGFloat(gridSize)
      
      VStack(spacing: spacing) {
        ForEach(0..<gridSize, id: \.self) { row in
          HStack(spacing: spacing) {
            ForEach(0..<gridSize, id: \.self) { col in
              BinarioCellView(
                cell: viewModel.grid[row][col],
                cellSize: cellSize
              ) {
                viewModel.toggleCell(row: row, col: col)
              }
            }
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .aspectRatio(1, contentMode: .fit)
    .padding()
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 15))
  }
  
  private var controlsView: some View {
    HStack(spacing: 15) {
      Button {
        viewModel.resetLevel()
      } label: {
        Label("Reset", systemImage: "arrow.counterclockwise")
          .font(.subheadline)
          .foregroundStyle(.primary)
          .padding(.horizontal, 20)
          .padding(.vertical, 12)
      }
      .buttonStyle(.glass)
      
      Button {
        let errors = viewModel.getAllValidationErrors()
        if errors.isEmpty {
          // No errors found
        } else {
          showingValidationErrors = true
        }
      } label: {
        Label("Validate", systemImage: "checkmark.circle")
          .font(.subheadline)
          .foregroundStyle(.primary)
          .padding(.horizontal, 20)
          .padding(.vertical, 12)
      }
      .buttonStyle(.glass)
    }
  }
}

struct BinarioCellView: View {
  let cell: BinarioCell
  let cellSize: CGFloat
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      ZStack {
        RoundedRectangle(cornerRadius: 8)
          .fill(cellBackgroundColor)
          .frame(width: cellSize, height: cellSize)
        
        Text(cell.value.displayValue)
          .font(.system(size: cellSize * 0.5, weight: .bold))
          .foregroundStyle(cellTextColor)
      }
    }
    .disabled(cell.isLocked)
    .opacity(cell.isLocked ? 0.6 : 1.0)
  }
  
  private var cellBackgroundColor: Color {
    if cell.isLocked {
      return Color.primary.opacity(0.2)
    } else {
      return Color.primary.opacity(0.08)
    }
  }
  
  private var cellTextColor: Color {
    switch cell.value {
    case .zero:
      return .blue
    case .one:
      return .orange
    case .empty:
      return .clear
    }
  }
}
