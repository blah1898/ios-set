//
//  Card.swift
//  Set
//
//  Created by comp05A on 9/13/18.
//  Copyright © 2018 Universidad Autonoma de Baja California. All rights reserved.
//

import Foundation

struct Card {
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
