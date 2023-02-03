//
//  CardView.swift
//  Set
//
//  Created by Tareq Mia on 1/10/23.
//

import SwiftUI

struct CardView: View {
    
    let card: GameOfSet.Card
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 15.0
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        
        static let symbolAspectRatio: CGFloat = 2/1
        static let symbolOpacity: Double = 0.7
        static let symbolCornerRadius: CGFloat = 50
        
        static let defaultLineWidth: CGFloat = 2
        static let effectLineWidth: CGFloat = 3
        static let cardCornerRadius: CGFloat = 10
        static let effectOpacity: Double = 0.1
    }
    
    private func font(in size: CGSize) -> Font {
        .system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    ForEach(0..<card.cardContent.numberOfShapes, id: \.self) { _ in
                        createSymbol(for: card)
                    }
                }
                .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                .cardify(isMatched: card.isMatched, isSelected: card.isSelected, isNotMatched: card.isNotMatched, isDealt: card.isDealt)
            }
        }
    }
    
    @ViewBuilder
    private func createSymbol(for card: GameOfSet.Card) -> some View {
        switch card.cardContent.shape {
        case .roundedRectangle:
            createSymbolView(of: card.cardContent, shape: RoundedRectangle(cornerRadius: DrawingConstants.symbolCornerRadius))
        case .diamond:
            createSymbolView(of: card.cardContent, shape: Diamond())
        case .squiggle:
            createSymbolView(of: card.cardContent, shape: Squiggle())
        }
    }
    
    @ViewBuilder
    private func createSymbolView<SymbolShape>(of symbol: GameOfSet.Card.CardContent, shape: SymbolShape) -> some View where SymbolShape: Shape {
        
        switch symbol.pattern {
            
        case .filled:
            shape.fill().foregroundColor(symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
            
        case .shaded:
            StripesView(shape: shape, color: symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
        case .stroked:
            shape.stroke(lineWidth: DrawingConstants.defaultLineWidth)
                .foregroundColor(symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio,
                             contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
        }
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = GameOfSet()
        CardView(card: vm.deck[3])
    }
}
