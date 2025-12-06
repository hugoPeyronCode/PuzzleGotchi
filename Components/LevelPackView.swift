//
//  LevelPackView.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 06/12/2025.
//

import SwiftUI

// MARK: - Models

enum PuzzleType: String, CaseIterable, Identifiable {
  case mambo = "Mambo"
  case shikaku = "Shikaku"
  case kings = "Kings"
  case pipes = "Pipes"
  case tango = "Tango"
  case zip = "Zip"
  case queens = "Queens"
  case minesweeper = "Minesweeper"
  case sudoku = "Sudoku"
  case kakuro = "Kakuro"
  
  var id: String { rawValue }
  
  var icon: String {
    switch self {
    case .mambo: "circle.hexagongrid"
    case .shikaku: "rectangle.split.3x3"
    case .kings: "crown"
    case .pipes: "pipe.and.drop"
    case .tango: "circle.grid.cross"
    case .zip: "point.topleft.down.to.point.bottomright.curvepath"
    case .queens: "chess.queen"
    case .minesweeper: "bomb"
    case .sudoku: "number.square"
    case .kakuro: "sum"
    }
  }
  
  var color: Color {
    switch self {
    case .mambo: .orange
    case .shikaku: .blue
    case .kings: .yellow
    case .pipes: .cyan
    case .tango: .pink
    case .zip: .purple
    case .queens: .red
    case .minesweeper: .gray
    case .sudoku: .green
    case .kakuro: .indigo
    }
  }
}

struct PuzzlePack: Identifiable {
  let id = UUID()
  let type: PuzzleType
  let cardCount: Int
  let price: Int
  let difficulty: Difficulty
  var isPurchased: Bool = false
  
  enum Difficulty: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case expert = "Expert"
  }
  
  var title: String {
    "\(type.rawValue) \(difficulty.rawValue)"
  }
}


// MARK: - Views

struct LevelPackView: View {
  
  var cardNumber: Int = 5
  var angleMultiple: Double = 7.0
  var puzzleType: PuzzleType = .mambo
  
  @State private var isSpread = false
  @State private var isFloating = false
  @State private var selectedCard: Int? = nil
  
  var body: some View {
    ZStack {
      ForEach(1...cardNumber, id: \.self) { index in
        RoundedRectangle(cornerRadius: 15)
          .foregroundStyle(.thinMaterial)
          .overlay {
            RoundedRectangle(cornerRadius: 15)
              .stroke(lineWidth: 2)
              .foregroundStyle(puzzleType.color)
            
            VStack {
              Image(systemName: puzzleType.icon)
                .resizable()
                .scaledToFit()
                .padding()
              
              Text("\(index)")
                .font(.title2)
                .fontWeight(.bold)
                .fontDesign(.rounded)
            }
            .padding(.vertical)
            .foregroundStyle(puzzleType.color)
          }
          .frame(width: 100, height: 150)
          .rotationEffect(
            Angle(degrees: isSpread ? Double(cardNumber - index) * angleMultiple : 0)
          )
          .offset(y: selectedCard == index ? -20 : (isFloating ? -3 : 3))
          .scaleEffect(selectedCard == index ? 1.05 : 1)
          .animation(
            .spring(response: 0.4, dampingFraction: 0.7)
              .delay(Double(index) * 0.05),
            value: isSpread
          )
          .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedCard)
          .animation(
            .easeInOut(duration: 2)
              .repeatForever(autoreverses: true)
              .delay(Double(index) * 0.1),
            value: isFloating
          )
      }
    }
    .sensoryFeedback(.impact(weight: .medium), trigger: isSpread)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        isSpread = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        isFloating = true
      }
    }
  }
}

struct PackShopItemView: View {
  
  let pack: PuzzlePack
  let onPurchase: () -> Void
  var isPurchasing: Bool = false
  
  @State private var isPressed = false
  @State private var isFolding = false
  @State private var flyingCards: [Int] = []
  @State private var completedPurchase = false
  @State private var hasStartedAnimation = false
  
  var body: some View {
    VStack(spacing: 16) {
      ZStack {
        // Main pack view
        AnimatedPackView(
          cardNumber: pack.cardCount,
          puzzleType: pack.type,
          isFolding: isFolding,
          flyingCards: flyingCards
        )
        
        // Flying cards overlay
        ForEach(flyingCards, id: \.self) { cardIndex in
          FlyingCardView(
            puzzleType: pack.type,
            cardNumber: cardIndex
          )
          .transition(.asymmetric(
            insertion: .identity,
            removal: .scale(scale: 0.1).combined(with: .opacity)
          ))
        }
      }
      .opacity(completedPurchase ? 0 : 1)
      
      VStack(spacing: 4) {
        Text(pack.title)
          .font(.headline)
          .fontDesign(.rounded)
        
        Text("\(pack.cardCount) levels")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      .opacity(completedPurchase ? 0 : 1)
      
      Button {
        if !isPurchasing && !hasStartedAnimation {
          startPurchaseAnimation()
        }
      } label: {
        HStack {
          if pack.isPurchased {
            Image(systemName: "checkmark")
            Text("Owned")
          } else {
            Image(systemName: "star.fill")
            Text("\(pack.price)")
          }
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .fontDesign(.rounded)
        .foregroundStyle(pack.isPurchased ? .secondary : Color.primary)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background {
          Capsule()
            .fill(pack.isPurchased ? .gray.opacity(0.3) : pack.type.color)
        }
      }
      .disabled(pack.isPurchased || isPurchasing || hasStartedAnimation)
      .scaleEffect(isPressed ? 0.95 : 1)
      .opacity(completedPurchase ? 0 : 1)
    }
    .padding()
    .onChange(of: isPurchasing) { oldValue, newValue in
      if newValue && !oldValue && !hasStartedAnimation {
        startPurchaseAnimation()
      }
    }
  }
  
  private func startPurchaseAnimation() {
    guard !hasStartedAnimation else { return }
    hasStartedAnimation = true
    
    // Step 1: Fold the pack
    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
      isFolding = true
    }
    
    // Step 2: Start flying cards one by one
    for i in 1...pack.cardCount {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 + Double(i) * 0.15) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
          flyingCards.append(i)
        }
        
        // Remove card after it flies away
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          withAnimation {
            if let index = flyingCards.firstIndex(of: i) {
              flyingCards.remove(at: index)
            }
          }
        }
      }
    }
    
    // Step 3: Complete purchase and trigger callback
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 + Double(pack.cardCount) * 0.15 + 0.5) {
      withAnimation {
        completedPurchase = true
      }
      onPurchase()
      
      // Reset state after animation (but keep hasStartedAnimation true)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        isFolding = false
        flyingCards = []
        completedPurchase = false
        // Note: hasStartedAnimation stays true to prevent re-animation
      }
    }
  }
}

// Animated pack that can fold
struct AnimatedPackView: View {
  let cardNumber: Int
  let puzzleType: PuzzleType
  let isFolding: Bool
  let flyingCards: [Int]
  
  @State private var isSpread = false
  @State private var isFloating = false
  
  var body: some View {
    ZStack {
      ForEach(1...cardNumber, id: \.self) { index in
        if !flyingCards.contains(index) {
          RoundedRectangle(cornerRadius: 15)
            .foregroundStyle(.thinMaterial)
            .overlay {
              RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 2)
                .foregroundStyle(puzzleType.color)
              
              VStack {
                Image(systemName: puzzleType.icon)
                  .resizable()
                  .scaledToFit()
                  .padding()
                
                Text("\(index)")
                  .font(.title2)
                  .fontWeight(.bold)
                  .fontDesign(.rounded)
              }
              .padding(.vertical)
              .foregroundStyle(puzzleType.color)
            }
            .frame(width: 100, height: 150)
            .rotationEffect(
              Angle(degrees: isFolding ? 0 : (isSpread ? Double(cardNumber - index) * 7.0 : 0))
            )
            .offset(y: isFloating ? -3 : 3)
            .animation(
              .spring(response: 0.4, dampingFraction: 0.7)
                .delay(Double(index) * 0.05),
              value: isSpread
            )
            .animation(
              .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.1),
              value: isFloating
            )
        }
      }
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        isSpread = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        isFloating = true
      }
    }
  }
}

// Flying card that moves to top bar
struct FlyingCardView: View {
  let puzzleType: PuzzleType
  let cardNumber: Int
  
  @State private var offset: CGSize = .zero
  @State private var rotation: Double = 0
  @State private var scale: CGFloat = 1
  
  var body: some View {
    RoundedRectangle(cornerRadius: 15)
      .foregroundStyle(.thinMaterial)
      .overlay {
        RoundedRectangle(cornerRadius: 15)
          .stroke(lineWidth: 2)
          .foregroundStyle(puzzleType.color)
        
        VStack {
          Image(systemName: puzzleType.icon)
            .resizable()
            .scaledToFit()
            .padding()
          
          Text("\(cardNumber)")
            .font(.title2)
            .fontWeight(.bold)
            .fontDesign(.rounded)
        }
        .padding(.vertical)
        .foregroundStyle(puzzleType.color)
      }
      .frame(width: 100, height: 150)
      .scaleEffect(scale)
      .rotationEffect(.degrees(rotation))
      .offset(offset)
      .onAppear {
        // Fly to top-left (where inventory would be)
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
          offset = CGSize(width: -UIScreen.main.bounds.width / 2 + 50, 
                         height: -UIScreen.main.bounds.height / 2 + 100)
          rotation = Double.random(in: -20...20)
          scale = 0.3
        }
      }
  }
}

struct PuzzleShopView: View {
  
  @State private var viewModel = ShopViewModel()
  
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 24) {
          ForEach(viewModel.packs) { pack in
            PackShopItemView(
              pack: pack,
              onPurchase: { viewModel.purchase(pack) },
              isPurchasing: viewModel.purchasingPack?.id == pack.id
            )
            .sensoryFeedback(.success, trigger: pack.isPurchased)
          }
        }
        .padding()
      }
      .navigationTitle("Level Packs")
      .overlay {
        if viewModel.showPurchaseSuccess {
          PurchaseSuccessOverlay()
        }
      }
    }
  }
}

struct PurchaseSuccessOverlay: View {
  
  @State private var scale: CGFloat = 0.5
  @State private var opacity: CGFloat = 0
  
  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "checkmark.circle.fill")
        .font(.system(size: 60))
        .foregroundStyle(.green)
      
      Text("Purchased!")
        .font(.title2)
        .fontWeight(.bold)
        .fontDesign(.rounded)
    }
    .padding(40)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    .scaleEffect(scale)
    .opacity(opacity)
    .onAppear {
      withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
        scale = 1
        opacity = 1
      }
    }
  }
}

#Preview {
  PuzzleShopView()
}
