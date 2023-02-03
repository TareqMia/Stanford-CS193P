//
//  SetGameView.swift
//  Set
//
//  Created by Tareq Mia on 1/10/23.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var game = GameOfSet()
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text("Set!").font(.title).bold()
                Spacer()
                Text("Score: \(game.score)")
                gameBody
                HStack(alignment: .center) {
                    deckBody
                    Spacer()
                    discardPile
                }
                .padding(.all)
                HStack {
                    newGameButton
                    Spacer()
                    shuffleButton
                }
                .padding(.all)
            }
        }
        
    }
    
    var gameBody: some View {
        
        AspectVGrid(items: game.cardsInPlay, aspectRatio: 2/3) { card in
            cardView(for: card)
                .transition(.asymmetric(insertion: .identity, removal: .scale))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        game.choose(card: card)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            withAnimation {
                                game.addCardsToDiscardPile()
                            }
                        }
                    }
                }
        }
        .padding(4)
        
        
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.deck.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity , removal: .scale))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .onTapGesture {
            
            if dealt.count == 0 {
                for card in game.cardsInPlay {
                    withAnimation(dealAnimation(for: card)) {
                        deal(card)
                    }
                    
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if game.cardsInPlay.count < 81 {
                        game.dealThreeCards()
                        updateDealt()
                    }
                    
                }
            }
            
        }
    }
    
    var discardPile: some View {
        ZStack {
            ForEach(game.discardPile) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity , removal: .scale))
            }
            .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        }
    }
    
    private func updateDealt() {
        for card in game.cardsInPlay {
            if !dealt.contains(card.id) {
                deal(card)
            }
        }
    }
    
    var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    var newGameButton: some View {
        Button("New Game", action: {
            withAnimation {
                dealt = []
                game.startNewGame()
            }
            
        })
    }
    
    private func dealAnimation(for card: GameOfSet.Card) -> Animation {
        var delay = 0.0
        if let index = game.cardsInPlay.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cardsInPlay.count))
        }
        return .easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    @ViewBuilder
    private func cardView(for card: GameOfSet.Card) -> some View {
        if isUndealt(card) {
            Color.clear
        } else {
            if (dealt.contains(card.id)) {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(.scale).animation(.linear(duration: 1), value: isUndealt(card))
            }
            
        }
    }
    
    private func deal(_ card: GameOfSet.Card) -> Void {
        game.dealCard(card: card)
        dealt.insert(card.id)
    }
    
    private func isUndealt(_  card: GameOfSet.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
}

struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView()
    }
}
