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
    private(set)    var selected = [Int]()
    
    var deckCount : Int {
        return deck.count
    }
    
    var canDeal : Bool {
        return deck.count > 0 && hand.count < 24
    }
    
    func pickCard(at index: Int) {
        // If we're selecting an already selected element, remove it from selection
        if let alreadyExistingIndex = selected.index(of: index) {
            selected.remove(at: alreadyExistingIndex)
            return
        }
        
        if selected.count >= 3 {
            selected = []
        }
        
        selected.append(index)
        
        //TODO: check for match
        
        if selected.count >= 3 {
            selected = [];
        }
    }
    
    func reset() {
        hand = []
        selected = []
        deck = SetGame.generateDeck().shuffle()
        initialDeal()
    }
    
    func deal() {
        if !self.canDeal {
            return;
        }
        
        3.times {
            if let card = deck.popLast() {
                hand.append(card);
            }
        }
    }
    
    private func initialDeal() {
        12.times {
            if let card = deck.popLast() {
                hand.append(card);
            }
        }
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
        
        initialDeal()
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
    
    func times(do run: (Int) -> Void) {
        for i in 0..<self {
            run(i)
        }
    }
    
    func times(do run: () -> Void) {
        self.times {_ in run()}
    }
}
