//
//  ContentView.swift
//  Memorize
//
//  Created by Tareq Mia on 12/14/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var game = EmojiMemoryGame()
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                
                Text("Memorize \(game.theme.name)!")
                    .font(.largeTitle)
                Text("Score: \(game.points)")
                
                gameBody
                
                gameButtons
                
            }
            
            deckBody
        }
        .foregroundColor(game.color)
    }
    
    var gameBody: some View {
        
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            cardView(for: card)
                .transition(.asymmetric(insertion: .identity, removal: .scale))
        })
        .foregroundColor(game.color ?? CardConstants.color)
        .padding(.horizontal)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card, color: game.color ?? .red)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity , removal: .scale))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(game.color ?? CardConstants.color)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var gameButtons: some View {
        HStack {
            Button("New Game") {
                withAnimation {
                    dealt = []
                    game.createNewGame()
                }
            }
            Spacer()
            Button("Shuffle") {
                withAnimation{
                    game.shuffle()
                }
            }
        }.padding(.horizontal)
    }
    
    private func deal(_ card: EmojiMemoryGame.Card) -> Void {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return .easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
            Color.clear
        } else {
            CardView(card: card, color: game.color ?? .red)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .padding(4)
                .transition(.scale).animation(.easeInOut(duration: 1), value: isUndealt(card))
                .zIndex(zIndex(of: card))
                .onTapGesture {
                    withAnimation {
                        game.choose(card)
                    }
                    
                }
        }
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}
