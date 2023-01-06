//
//  MemoryGame.swift
//  Memorize
//
//  Created by Tareq Mia on 1/2/23.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    private(set) var points = 0
    
    private var faceUpCardIndex: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        
        // add numberOfPairsOfCards x 2 cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }),
           !cards[index].isFaceUp,
           !cards[index].isMatched  {
            if let potentialMatchIndex = faceUpCardIndex {
                if cards[index].content == cards[potentialMatchIndex].content {
                    cards[index].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                faceUpCardIndex = index
            }
            
            if !cards[index].hasBeenSeen {
                cards[index].hasBeenSeen = true
            }
            
            if cards[index].isInvolvedInMismatch {
                points -= 1
            }
            
            var faceUpCards = cards.filter { $0.isFaceUp }
            if faceUpCards.count == 2 {
                if faceUpCards[0].content != faceUpCards[1].content {
                    faceUpCards.indices.forEach { faceUpCards[$0].isInvolvedInMismatch = true }
                    points -= 1
                } else {
                    faceUpCards.indices.forEach { faceUpCards[$0].isMatched = true }
                    points += 2
                }
            }
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var hasBeenSeen = false
        var isInvolvedInMismatch = false
        let content: CardContent
        let id: Int
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
