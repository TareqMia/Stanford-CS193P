//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Tareq Mia on 1/2/23.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    
    private static var vehicleEmojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐",
                                        "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁",
                                        "🚢", "🛶", "🛥", "🚞", "🚟", "🚃"]
    
    private static var animalEmojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼",
                                       "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐵"]
    
    private static var foodEmojis = ["🍔", "🥐", "🍕", "🥗", "🥟", "🍣", "🍪",
                                     "🍚", "🍝", "🥙", "🍭", "🍤", "🥞", "🍦",
                                     "🍛", "🍗"]
    
    private static var heartEmojis = ["❤️", "🧡", "💛",
                                      "💚", "💙", "💜"]
    
    private static var sportsEmojis = ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏉", "🥏", "🏊",
                                       "🏐", "🎱", "🏓", "🏸", "🏒", "🥊", "🚴‍♂️",
                                       "🧗‍♀️", "🤺", "🏇", "🏋️‍♀️", "⛸", "⛷", "🤼","🏄"]
    
    private static var weatherEmojis = ["☀️", "🌪", "☁️", "☔️", "❄️"]
    
    
    private static func createMemoryGame(of theme: Theme) -> MemoryGame<String> {
        var numberOfPairsOfCards = theme.numberOfPairsOfCards
        if theme.name == "Vehicles" || theme.name == "Animals" {
            numberOfPairsOfCards = Int.random(in: 2...theme.emojis.count)
        }
        return MemoryGame(numberOfPairsOfCards: numberOfPairsOfCards) { theme.emojis[$0] }
    }
    
    private static let colors = ["gray", "red", "green", "blue", "orange",
                                 "yellow", "pink", "purple", "fushia", "beige", "gold"]
    
    
    private static func createTheme(_ name: String, _ emojis: [String], _ numberOfPairsOfCards: Int)  -> Theme {
        let color = colors.randomElement()
        var pairsOfCards = numberOfPairsOfCards
        if emojis.count < numberOfPairsOfCards {
            pairsOfCards = emojis.count
        }
        return Theme(name: name, emojis: emojis, color: color!, numberOfPairsOfCards: pairsOfCards)
    }
    
    private static var themes: [Theme] = {
        var themes = [Theme]()
        let numberOfPairsOfCards = 8
        
        themes.append(createTheme("Vehicles", vehicleEmojis, numberOfPairsOfCards))
        themes.append(createTheme("Animals", animalEmojis, numberOfPairsOfCards))
        themes.append(createTheme("Food", foodEmojis, numberOfPairsOfCards))
        themes.append(createTheme("Hearts", heartEmojis, numberOfPairsOfCards))
        themes.append(createTheme("Sports", sportsEmojis, numberOfPairsOfCards))
        themes.append(createTheme("Weather", weatherEmojis, numberOfPairsOfCards))
        return themes
    }()
    
    private static func getTheme() -> Theme {
        return EmojiMemoryGame.themes.randomElement()!
    }
    
    private static func getColor(_ chosenColor: String) -> Color {
        switch chosenColor {
        case "black":
            return .black
        case "gray":
            return .gray
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        case "orange":
            return .orange
        case "yellow":
            return .yellow
        case "pink":
            return .pink
        case "purple":
            return .purple
        default:
            return .red
        }
    }
    
    private(set) var theme: Theme
    private(set) var color: Color?
    @Published private var model: MemoryGame<String>
    
    init() {
        theme = EmojiMemoryGame.getTheme()
        model = EmojiMemoryGame.createMemoryGame(of: theme)
        color = EmojiMemoryGame.getColor(theme.color)
    }
    
    var cards: [Card]  {
        model.cards
    }
    
    var points: Int {
        model.points
    }
    
    // MARK: Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func createNewGame() -> Void {
        theme = EmojiMemoryGame.getTheme()
        model = EmojiMemoryGame.createMemoryGame(of: theme)
        color = EmojiMemoryGame.getColor(theme.color)
    }
}
