//
//  SetGame.swift
//  Set
//
//  Created by Tareq Mia on 1/8/23.
//

import Foundation

struct SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfSymbols> where CardSymbolShape: Hashable, CardSymbolColor: Hashable, CardSymbolPattern: Hashable, NumberOfSymbols: Hashable {
    
    private(set) var cards: [Card]
    private var initialNumberOfCards: Int
    private(set) var numberOfCardsPlayed = 0
    private(set) var toatlNumberOfCards: Int
    private var selectedCards: [Card] = []
    private let createCardContent: (Int) -> Card.CardContent
    private(set) var score = 0
    
    
    init(initialNumberOfCards: Int, totalNumberOfCards: Int, createCardContent: @escaping (Int) -> SetGame.Card.CardContent) {
        cards = []
        self.toatlNumberOfCards = totalNumberOfCards
        self.initialNumberOfCards = initialNumberOfCards
        self.createCardContent = createCardContent
        
        for _ in 0..<initialNumberOfCards {
            let content = createCardContent(numberOfCardsPlayed)
            cards.append(Card(cardContent: content, id: numberOfCardsPlayed))
            numberOfCardsPlayed += 1
        }
        
    }
    
    private mutating func resetSelectedCards() -> Void {
        cards.indices.forEach({ cards[$0].isSelected = false })
        selectedCards = []
    }
    
    mutating func handleValidSet() -> Void {
        if selectedCards.count ==  3  {
            let indices = cards.indices.filter({ cards[$0].isSelected })
            for index in indices {
                cards[index].isMatched = true
            }
            resetSelectedCards()
            score += 2
        }
        
    }
    
    mutating func handleInvalidSet() -> Void {
        if selectedCards.count == 3 {
            let indices = cards.indices.filter({ cards[$0].isSelected })
            for index in indices {
                cards[index].isNotMatched = true
            }
            resetSelectedCards()
            if score > 0 {
                score -= 1
            }
        }
       
    }
    
    mutating func replaceCards() -> Void {
        let indices = cards.indices.filter({ cards[$0].isMatched })
        for index in indices {
            let content = createCardContent(numberOfCardsPlayed)
            cards[index] = Card(cardContent: content, id: numberOfCardsPlayed)
            numberOfCardsPlayed += 1
        }
        
    }
    
    mutating func choose(card: Card) -> Void {
        
        let notMatchedIndices = cards.indices.filter({ cards[$0].isNotMatched })
        for index in notMatchedIndices {
            cards[index].isNotMatched = false
        }
        
        if let index = cards.firstIndex(where: { $0.id == card.id } )  {
            if selectedCards.count < 3 {
                if selectedCards.contains(where: { $0.id == card.id }) {
                    cards[index].isSelected = false
                    selectedCards.remove(at: selectedCards.firstIndex(where: { $0.id == card.id })!)
                } else {
                    selectedCards.append(cards[index])
                    cards[index].isSelected = true
                }
            }
        }
    }
    
    func checkForSet()  -> Bool {
        var shapes = Set<CardSymbolShape>()
        var patterns = Set<CardSymbolPattern>()
        var colors = Set<CardSymbolColor>()
        var numbers = Set<Int>()
        
        
        selectedCards.forEach { card in
            shapes.insert(card.cardContent.shape)
            patterns.insert(card.cardContent.pattern)
            colors.insert(card.cardContent.color)
            numbers.insert(card.cardContent.numberOfShapes)
        }
        
        if shapes.count == 2 || patterns.count == 2 || colors.count == 2 || numbers.count == 2 {
            return false
        }
        
        return true
    }
    
    mutating func dealThreeCards() -> Void {
        for _ in 0..<3 {
            dealOneCard(at: cards.endIndex)
        }
    }
    
    mutating private func dealOneCard(at index: Int) -> Void {
        if numberOfCardsPlayed < toatlNumberOfCards {
            let content = createCardContent(numberOfCardsPlayed)
            cards.insert(Card(cardContent: content, id: numberOfCardsPlayed), at: index)
            numberOfCardsPlayed += 1
        }
    }
    
    mutating func startNewGame(cardContents: [Card.CardContent]) {
        cards = []
        numberOfCardsPlayed = 0
        for _ in 0..<initialNumberOfCards {
            let content = createCardContent(numberOfCardsPlayed)
            cards.append(Card(cardContent: content, id: numberOfCardsPlayed))
            numberOfCardsPlayed += 1
        }
    }
    
    struct Card: Identifiable {
        
        let cardContent: CardContent
        let id: Int
        var isSelected = false
        var isMatched = false
        var isNotMatched = false
        
        struct CardContent {
            let shape: CardSymbolShape
            let color: CardSymbolColor
            let pattern: CardSymbolPattern
            let numberOfShapes: Int
        }
    }
    
}
