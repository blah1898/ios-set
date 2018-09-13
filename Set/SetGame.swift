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
    private         var hand = [Card]()
    
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
        deck = SetGame.generateDeck()
    }
}

extension Array {
    func shuffle() {

    }
}

extension Int {
    static func random(range: ClosedRange<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(range.upperBound))) - range.lowerBound
    }
}
