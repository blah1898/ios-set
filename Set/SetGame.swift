//
//  SetGame.swift
//  Set
//
//  Created by comp05A on 9/13/18.
//  Copyright © 2018 Universidad Autonoma de Baja California. All rights reserved.
//

import Foundation

class SetGame {
    
    private(set)    var deck = [Card]()
    private(set)    var hand = [Card]()
    
    var deckCount : Int {
        return deck.count
    }
    
    var canDeal : Bool {
        return deck.count > 0 && hand.count < 24
    }
    
    func pickCard(at index: Int) {
        
    }
    
    func reset() {
        // TODO
    }
    
    func deal() {
        // TODO
    }
    
    private static func generateDeck() -> [Card] {
        var newDeck = [Card]()
        
        let colorCases: [Color] = [.black, .red, .blue]
        let shadingCases: [Shading] = [.light, .medium, .full]
        let countCases: [Count] = [.one, .two, .three]
        let symbolCases: [Symbol] = [.circle, .square, .star]
        
        for color in colorCases {
            for shading in shadingCases {
                for count in countCases {
                    for symbol in symbolCases {
                        newDeck.append(Card(color: color, shading: shading, count: count, symbol: symbol))
                    }
                }
            }
        }
        
        return newDeck
    }

    init() {
        deck = SetGame.generateDeck().shuffle()
    }
}

extension Array {
    func shuffle() -> Array<Element> {
        var shuffled = self;
        
        for index in 0..<(shuffled.count-1) {
            let indexToSwap = Int.random(from: index + 1, to: self.count)
            shuffled.swapAt(index, indexToSwap)
        }
        
        return shuffled
    }
}

extension Int {
    static func random(from lowerBound: Int, to upperBound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperBound - lowerBound))) + lowerBound
    }
}
