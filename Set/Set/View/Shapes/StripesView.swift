//
//  StripesView.swift
//  Set
//
//  Created by Tareq Mia on 1/10/23.
//

import SwiftUI

struct StripesView<SymbolShape>: View where SymbolShape: Shape {
    let shape: SymbolShape
    let color: Color
    let numberOfStrips: Int = 10
    let lineWidth: CGFloat = 2
    let borderLineWidth: CGFloat = 1

    var body: some View {

        HStack(spacing: 0.5) {
            ForEach(0..<numberOfStrips, id: \.self) { number in
                Color.white
                color.frame(width: lineWidth)
                if number == numberOfStrips - 1 {
                    Color.white
                }
            }

        }.mask(shape)
        .overlay(shape.stroke(color, lineWidth: borderLineWidth))

    }
}

struct StripesView_Previews: PreviewProvider {
    static var previews: some View {
        StripesView(shape: Diamond(), color: .blue)
    }
}
