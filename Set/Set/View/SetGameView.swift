//
//  SetGameView.swift
//  Set
//
//  Created by Tareq Mia on 1/10/23.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var game = GameOfSet()
    
    
    var body: some View {
        VStack {
            Text("Set!").font(.title).bold()
            Spacer()
            Text("Score: \(game.score)")
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card: card)
                    }
            }
            .padding(4)
            HStack {
                Button("Deal 3 Cards", action: {
                    game.dealThreeCards()
                })
                Spacer()
                Button("New Game", action: {
                    game.startNewGame()
                })
            }
            .padding()
        }
            
    }
}

struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView()
    }
}
