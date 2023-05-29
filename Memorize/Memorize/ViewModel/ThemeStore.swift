//
//  ThemeStore.swift
//  Memorize
//
//  Created by Tareq Mia on 5/28/23.
//

import SwiftUI

struct Theme: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var emojis: String
    var color: RGBAColor
    var numberOfPairsOfCards: Int
    
    fileprivate init(name: String, emojis: String, numberOfPairsOfCards: Int, color: RGBAColor, id: Int) {
        self.name = name
        self.emojis = emojis
        self.numberOfPairsOfCards = numberOfPairsOfCards
        self.color = color
        self.id = id
    }
}

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    private var userDefaultsKey: String {
        "ThemeStore: " + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode(Array<Theme>.self, from: jsonData) {
            themes = decodedThemes
        }
    }
    
    
    init(named name: String) {
            self.name = name
            restoreFromUserDefaults()
            if themes.isEmpty {
                insertTheme(named: "AnimalFaces", emojis: "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐷🐵", numberOfPairsOfCards: 8, color: Color(rgbaColor: RGBAColor(red: 255/255, green: 143/255, blue: 20/255, alpha: 1)))
                insertTheme(named: "Food", emojis: "🍔🥐🍕🥗🥟🍣🍪🍚🍝🥙🍭🍤🥞🍦🍛🍗", numberOfPairsOfCards: 10, color:Color(rgbaColor: RGBAColor(red: 86/255, green: 178/255, blue: 62/255, alpha: 1)))
                insertTheme(named: "Vehicles", emojis: "🚗🛴✈️🛵⛵️🚎🚐🚛🚂🚊🚀🚁🚢🛶🛥🚞🚟🚃", numberOfPairsOfCards: 5, color: Color(rgbaColor: RGBAColor(red: 248/255, green: 218/255, blue: 9/255, alpha: 1)))
                insertTheme(named: "Hearts", emojis: "❤️🧡💛💚💙💜", numberOfPairsOfCards: 4, color: Color(rgbaColor: RGBAColor(red: 229/255, green: 108/255, blue: 204/255, alpha: 1)))
                insertTheme(named: "Sports", emojis: "⚽️🏀🏈⚾️🎾🏉🥏🏐🎱🏓🏸🏒🥊🚴‍♂️🏊🧗‍♀️🤺🏇🏋️‍♀️⛸⛷🏄🤼", numberOfPairsOfCards: 12,
                            color: Color(rgbaColor: RGBAColor(red: 129/255, green: 18/255, blue: 210/255, alpha: 1)))
                            
                insertTheme(named: "Weather", emojis: "☀️🌪☁️☔️❄️", numberOfPairsOfCards: 3, color: Color(rgbaColor: RGBAColor(red: 37/255, green: 75/255, blue: 240/255, alpha: 1)))
            }
        }

    
    // MARK: - Intent
    
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    
    func insertTheme(named name: String, emojis: String? = nil, numberOfPairsOfCards: Int = 2, color: Color = Color(rgbaColor: RGBAColor(red: 243/255, green: 63/255, blue: 63/255, alpha: 1)) , at index: Int = 0) {
            let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
            let theme = Theme(name: name, emojis: emojis ?? "", numberOfPairsOfCards: numberOfPairsOfCards, color: RGBAColor(color: color), id: unique)
            let safeIndex = min(max(index, 0), themes.count)
            themes.insert(theme, at: safeIndex)
        }
        
        func removeTheme(at index: Int) {
            if themes.count > 1, themes.indices.contains(index) {
                themes.remove(at: index)
            }
        }
    
    
}
