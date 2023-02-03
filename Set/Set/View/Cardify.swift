//
//  Cardify.swift
//  Set
//
//  Created by Tareq Mia on 1/21/23.
//

import SwiftUI

struct Cardify: ViewModifier {
    
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
    
    var isMatched: Bool
    var isSelected: Bool
    var isNotMatched: Bool
    var isDealt: Bool
    
    
    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        if !isDealt {
            shape.fill().foregroundColor(.blue)
        }
        else {
            shape.fill().foregroundColor(.white)
            
            if isMatched {
                shape.strokeBorder(.green, lineWidth: DrawingConstants.lineWidth - 1)
                
            }
            else {
                if isSelected {
                    shape.strokeBorder(.orange, lineWidth: DrawingConstants.lineWidth - 1)
                } else if isNotMatched {
                    shape.strokeBorder(.gray, lineWidth: DrawingConstants.lineWidth - 1)
                    shape.fill().foregroundColor(.gray).opacity(DrawingConstants.effectOpacity)
                }
                else {
                    shape.strokeBorder(.cyan, lineWidth: DrawingConstants.lineWidth - 1)
                }
            }
            content.padding()
        }
    }
    
    
}

extension View {
    func cardify(isMatched: Bool, isSelected: Bool, isNotMatched: Bool, isDealt: Bool) -> some View {
        self.modifier(Cardify(isMatched: isMatched, isSelected: isSelected, isNotMatched: isNotMatched, isDealt: isDealt))
    }
}
