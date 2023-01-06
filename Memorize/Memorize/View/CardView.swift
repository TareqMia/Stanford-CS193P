//
//  CardView.swift
//  Memorize
//
//  Created by Tareq Mia on 1/5/23.
//

import SwiftUI

struct CardView: View {
    var card: EmojiMemoryGame.Card
    var color: Color
    
    private struct DrawingConstraints {
        static let cornerRadius: CGFloat = 10.0
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
    }
    
    private func font(in size: CGSize) -> Font {
        .system(size: min(size.width, size.height) * DrawingConstraints.fontScale)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstraints.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstraints.lineWidth)
                    Text(card.content).font(font(in: geometry.size))
                }
                else if  card.isMatched {
                    shape.opacity(0)
                }
                else {
                    shape.fill(color)
                }
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        CardView(card: game.cards[0], color: .red)
    }
}
