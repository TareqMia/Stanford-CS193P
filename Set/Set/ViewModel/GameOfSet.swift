//
//  Game.swift
//  Set
//
//  Created by Tareq Mia on 1/8/23.
//

import SwiftUI


class GameOfSet: ObservableObject {
    
    typealias Card = SetGame<SymbolShape, SymbolColor, SymbolPattern, NumberOfSymbols>.Card
    
    enum SymbolShape: CaseIterable {
      
        case roundedRectangle
        case diamond
        case squiggle
    }
    
    enum SymbolColor: String, CaseIterable {
        case green = "green"
        case red = "red"
        case purple = "purple"
        
        func getColor() -> Color {
            switch self {
            case .red:
                return Color.red
            case .green:
                return Color.green
            case .purple:
                return Color.purple
            }
        }
    }
    
    enum SymbolPattern: CaseIterable {
        case shaded
        case filled
        case stroked
    }
    
    enum NumberOfSymbols: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }
    
    private static func getCardContents() -> [Card.CardContent] {
        var contents = [Card.CardContent]()
        
        // create 81 cards
        for shape in SymbolShape.allCases {
            for color in SymbolColor.allCases {
                for pattern in SymbolPattern.allCases {
                    for number in NumberOfSymbols.allCases {
                        contents.append(Card.CardContent(shape: shape, color: color, pattern: pattern, numberOfShapes: number.rawValue))
                    }
                }
            }
        }
        return contents
        
    }
    
    private static func createSetGame() -> SetGame<SymbolShape, SymbolColor, SymbolPattern, NumberOfSymbols> {
        let cardContents = getCardContents().shuffled()
        return SetGame(initialNumberOfCards: 12, totalNumberOfCards: cardContents.count) { cardContents[$0] }
    }
    
    @Published private var model = createSetGame()
    
    var cards: [Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    var numberOfCardsPlayed: Int {
        model.numberOfCardsPlayed
    }
    
    // MARK: Intent(s)
    
    func choose(card: Card) {
        model.choose(card: card)
       
        if model.checkForSet() {
            model.handleValidSet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
                self?.model.replaceCards()
            }
        } else {
            model.handleInvalidSet()
        }
    }
    
    func dealThreeCards() -> Void {
        model.dealThreeCards()
    }
    
    func startNewGame() -> Void {
        model = GameOfSet.createSetGame()
    }
}
