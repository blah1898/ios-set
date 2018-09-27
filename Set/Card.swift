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
        
        static let all: [Shading] = [.light, .medium, .full]
    }
    
    enum Color {
        case black, red, blue
        
        static let all: [Color] = [.black, .red, .blue]
    }
    
    enum Count {
        case one, two, three
        
        static let all: [Count] = [.one, .two, .three]
        
        public var value: Int {
            switch self {
            case .one :
                return 1
            case .two:
                return 2
            case .three:
                return 3
            }
        }
    }
    
    enum Symbol {
        case circle, square, star
        
        static let all: [Symbol] = [.circle, .square, .star]
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
