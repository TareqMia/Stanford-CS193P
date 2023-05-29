//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Tareq Mia on 1/2/23.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    
    @Published private var model: MemoryGame<String>
     let theme: Theme
    
    static func createMemoryGame(of theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.map { String($0) }.shuffled()
        
        return MemoryGame(numberOfPairsOfCards: theme.numberOfPairsOfCards) { index in
            
            if index < emojis.count {
                return emojis[index]
            } else {
                return ""
            }
        }
    }
    
    init(theme: Theme) {
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(of: theme)
    }
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        model = EmojiMemoryGame.createMemoryGame(of: theme)
    }
    
    func shuffle() {
        model.shuffle()
    }
}
