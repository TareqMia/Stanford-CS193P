//
//  Diamond.swift
//  Set
//
//  Created by Tareq Mia on 1/9/23.
//

import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let width = rect.width
        let height = rect.width / 2
        
        let top = CGPoint(x: center.x, y: center.y + height / 2)
        let bottom = CGPoint(x: center.x, y: center.y - height / 2)
        let left = CGPoint(x: center.x - width / 2, y: center.y)
        let right = CGPoint(x: center.x + width / 2, y: center.y)
        
        path.move(to: top)
        path.addLine(to: left)
        path.addLine(to: bottom)
        path.addLine(to: right)
        path.addLine(to: top)
        
        return path
        
    }
}

