//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Tareq Mia on 12/14/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
