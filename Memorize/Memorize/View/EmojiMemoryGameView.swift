//
//  ContentView.swift
//  Memorize
//
//  Created by Tareq Mia on 12/14/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var game = EmojiMemoryGame()
    
    var body: some View {
        VStack {
            Text("Memorize \(game.theme.name)!")
                .font(.largeTitle)
            Text("Score: \(game.points)")
            
            AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                cardView(for: card)
            })
            .foregroundColor(game.color ?? .red)
            .padding(.horizontal)
            
            Button("New Game") {
                game.createNewGame()
            }
            .font(.largeTitle)
        }
        .foregroundColor(game.color)
    }
    
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if card.isMatched && !card.isFaceUp {
            Rectangle().opacity(0)
        } else {
            CardView(card: card, color: game.color ?? .red)
                .padding(4)
                .onTapGesture {
                    game.choose(card)
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}
