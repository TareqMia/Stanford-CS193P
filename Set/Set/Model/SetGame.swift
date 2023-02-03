//
//  SetGame.swift
//  Set
//
//  Created by Tareq Mia on 1/8/23.
//

import Foundation

struct SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfSymbols> where CardSymbolShape: Hashable, CardSymbolColor: Hashable, CardSymbolPattern: Hashable, NumberOfSymbols: Hashable {
    
    private(set) var deck: [Card]
    private(set) var cardsInPlay: [Card]
    private(set) var discardPile: [Card]
    private var initialNumberOfCards: Int
    private(set) var numberOfCardsPlayed = 0
    private(set) var toatlNumberOfCards: Int
    private(set) var selectedCards: [Card] = []
    private let createCardContent: (Int) -> Card.CardContent
    private(set) var score = 0
    
    
    init(initialNumberOfCards: Int, totalNumberOfCards: Int, createCardContent: @escaping (Int) -> SetGame.Card.CardContent) {
        deck = []
        cardsInPlay = []
        discardPile = []
        self.toatlNumberOfCards = totalNumberOfCards
        self.initialNumberOfCards = initialNumberOfCards
        self.createCardContent = createCardContent
        
        for _ in 0..<totalNumberOfCards {
            let content = createCardContent(numberOfCardsPlayed)
            deck.append(Card(cardContent: content, id: numberOfCardsPlayed))
            numberOfCardsPlayed += 1
        }
        
        for _ in 0..<initialNumberOfCards {
            cardsInPlay.append(deck.removeFirst())
        }
        
    }
    
    mutating func addCardsToDiscardPile() -> Void {
        let indices = cardsInPlay.indices.filter({ cardsInPlay[$0].isMatched })
        
        for index in indices.reversed() {
            var card = cardsInPlay.remove(at: index)
            card.isSelected = false
            card.isMatched = false
            discardPile.append(card)
        }
        
        cardsInPlay.indices.forEach({ cardsInPlay[$0].isSelected = false })
        selectedCards = []
    }
    
    mutating func handleValidSet() -> Void {
        
        if selectedCards.count ==  3  {
            let indices = cardsInPlay.indices.filter({ cardsInPlay[$0].isSelected })
            for index in indices {
                cardsInPlay[index].isMatched = true
            }
            print("Valid set")
            score += 2
        }
        
    }
    
    mutating func handleInvalidSet() -> Void {
        print("Invalid set")
        if selectedCards.count == 3 {
            let indices = cardsInPlay.indices.filter({ cardsInPlay[$0].isSelected })
            for index in indices {
                cardsInPlay[index].isNotMatched = true
            }
            addCardsToDiscardPile()
            if score > 0 {
                score -= 1
            }
        }
       
    }
    
    mutating func replaceCards() -> Void {
        let indices = selectedCards.indices.filter({ cardsInPlay[$0].isMatched })
        for index in indices {
            let content = createCardContent(numberOfCardsPlayed)
            cardsInPlay[index] = Card(cardContent: content, id: numberOfCardsPlayed)
            numberOfCardsPlayed += 1
        }
        
    }
    
    mutating func choose(card: Card) -> Void {
        
        let notMatchedIndices = cardsInPlay.indices.filter({ cardsInPlay[$0].isNotMatched })
        for index in notMatchedIndices {
            cardsInPlay[index].isNotMatched = false
        }
        
        if let index = cardsInPlay.firstIndex(where: { $0.id == card.id } )  {
            if selectedCards.count < 3 {
                if selectedCards.contains(where: { $0.id == card.id }) {
                    cardsInPlay[index].isSelected = false
                    selectedCards.remove(at: selectedCards.firstIndex(where: { $0.id == card.id })!)
                } else {
                    selectedCards.append(cardsInPlay[index])
                    cardsInPlay[index].isSelected = true
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
            dealOneCard(at: cardsInPlay.endIndex)
        }
    }
    
    mutating private func dealOneCard(at index: Int) -> Void {
        cardsInPlay.insert(deck.removeFirst(), at: index)
    }
    
    mutating func startNewGame(cardContents: [Card.CardContent]) {
        deck = []
        numberOfCardsPlayed = 0
        for _ in 0..<initialNumberOfCards {
            let content = createCardContent(numberOfCardsPlayed)
            deck.append(Card(cardContent: content, id: numberOfCardsPlayed))
            numberOfCardsPlayed += 1
        }
    }
    
    mutating func shuffle() -> Void {
        cardsInPlay.shuffle()
    }
    
    mutating func dealCard(card: Card) {
        if let index = cardsInPlay.firstIndex(where: { $0.id == card.id }) {
            cardsInPlay[index].isDealt = true
        }
    }
    
    struct Card: Identifiable, Equatable, Hashable {
        
        let cardContent: CardContent
        let id: Int
        var isSelected = false
        var isMatched = false
        var isNotMatched = false
        var isFaceUp = false
        var isDealt = false
        
        struct CardContent {
            let shape: CardSymbolShape
            let color: CardSymbolColor
            let pattern: CardSymbolPattern
            let numberOfShapes: Int
        }
        
        static func == (lhs: SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfSymbols>.Card, rhs: SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfSymbols>.Card) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var hashValue: Int {
            return id
        }
    }
    
}
