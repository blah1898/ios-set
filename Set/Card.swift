//
//  Card.swift
//  Set
//
//  Created by comp05A on 9/13/18.
//  Copyright © 2018 Universidad Autonoma de Baja California. All rights reserved.
//

import Foundation

struct Card : Equatable {
    
    enum Shading {
        case light, medium, full
    }
    
    enum Color {
        case black, red, blue
    }
    
    enum Count {
        case one, two, three
    }
    
    enum Symbol {
        case circle, square, star
    }

    
    let color:      Color
    let shading:    Shading
    let count:      Count
    let symbol:     Symbol
    
    init(color: Color, shading: Shading, count: Count, symbol: Symbol) {
        self.color = color
        self.shading = shading
        self.count = count
        self.symbol = symbol
    }
}
