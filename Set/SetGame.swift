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
    private(set)    var discardPile = [Card]()
    private(set)    var selected = [Int]()
    private(set)    var lastMistake = [Int]()
    private(set)    var lastMatch = [Int]()
    
    var deckCount : Int {
        return deck.count
    }
    
    var canDeal : Bool {
        return deck.count > 0 && hand.count < 24
    }
    
    func pickCard(at index: Int) {
        lastMistake = []
        lastMatch = []
        
        // If we're selecting an already selected element, remove it from selection
        if let alreadyExistingIndex = selected.index(of: index) {
            selected.remove(at: alreadyExistingIndex)
            return
        }
        
        selected.append(index)
        
        if selected.count == 3 {
            if checkIfMatch(hand[selected[0]], hand[selected[1]], hand[selected[2]]) {
                lastMatch = selected
            } else {
                lastMistake = selected
            }
        }
        
        if selected.count >= 3 {
            selected = [];
        }
    }
    
    func checkIfMatch(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        var colorMatched    = false
        var shadingMatched  = false
        var symbolMatched    = false
        var countMatched    = false
        // Color
        if card1.color == card2.color && card2.color == card3.color {
            colorMatched = true
        } else if card1.color != card2.color && card2.color != card3.color && card1.color != card3.color {
            colorMatched = true
        }
        
        if !colorMatched {
            return false
        }
        
        // Shading
        if card1.shading == card2.shading && card2.shading == card3.shading {
            shadingMatched = true
        } else if card1.shading != card2.shading && card2.shading != card3.shading && card1.shading != card3.shading {
            shadingMatched = true
        }
        
        if !shadingMatched {
            return false
        }
        
        // symbol
        if card1.symbol == card2.symbol && card2.symbol == card3.symbol {
            symbolMatched = true
        } else if card1.symbol != card2.symbol && card2.symbol != card3.symbol && card1.symbol != card3.symbol {
            symbolMatched = true
        }
        
        if !symbolMatched {
            return false
        }
        
        // Count
        if card1.count == card2.count && card2.count == card3.count {
            countMatched = true
        } else if card1.count != card2.count && card2.count != card3.count && card1.count != card3.count {
            countMatched = true
        }
        
        if !countMatched {
            return false
        }
        
        return true
    }
    
    func reset() {
        hand = []
        selected = []
        lastMistake = []
        lastMatch = []
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
