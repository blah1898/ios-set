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
    private(set)    var hand = [Card?](repeating: nil, count: 24)
    private(set)    var selected = [Int]()
    private(set)    var lastMistake = [Int]()
    private(set)    var lastMatch = [Int]()
    private(set)    var hint = [Int]()
    private(set)    var score = 0
    
    var deckCount : Int {
        return deck.count
    }
    
    var canDeal : Bool {
        return deck.count > 0 && (hand.filter{$0 != nil}.count - lastMatch.count) < 24
    }
    
    func removeLastMatch() {
        for index in lastMatch {
            hand[index] = nil
        }
    }
    
    func pickCard(at index: Int) {
        if (hand[index] == nil) {
            return
        }
        removeLastMatch()
        if lastMatch.contains(index) {
            lastMatch = [];
            return;
        }
        lastMistake = []
        lastMatch = []
        
        // If we're selecting an already selected element, remove it from selection
        if let alreadyExistingIndex = selected.index(of: index) {
            selected.remove(at: alreadyExistingIndex)
            return
        }
        
        selected.append(index)
        
        if selected.count == 3 {
            if checkIfMatch(hand[selected[0]]!, hand[selected[1]]!, hand[selected[2]]!) {
                lastMatch = selected
                if !hint.containsSameElements(as: selected) {
                    score += 3
                }
            } else {
                score -= 1
                lastMistake = selected
            }
        }
        
        if selected.count >= 3 {
            selected = []
            hint = []
        }
    }
    
    func getHint() {
        removeLastMatch()
        lastMistake = []
        lastMatch = []
        for card1 in hand.indices {
            if hand[card1] == nil {
                continue
            }
            for card2 in hand.indices {
                if hand[card2] == nil {
                    continue
                }
                if card1 == card2 {
                    continue
                }
                for card3 in hand.indices {
                    if hand[card3] == nil {
                        continue
                    }
                    if card2 == card3 || card1 == card3 {
                        continue
                    }
                    if checkIfMatch(hand[card1]!, hand[card2]!, hand[card3]!) {
                        hint = [card1, card2, card3]
                        return
                    }
                }
            }
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
        hand = [Card?](repeating: nil, count: 24)
        selected = []
        lastMistake = []
        lastMatch = []
        hint = []
        deck = SetGame.generateDeck().shuffle()
        initialDeal()
    }
    
    func deal() {
        if !self.canDeal {
            return;
        }
        
        removeLastMatch()
        lastMistake = []
        lastMatch = []
        hint = []
        
        3.times {
            if let card = deck.popLast() {
                addToHand(card: card);
            }
        }
    }
    
    private func initialDeal() {
        12.times {
            if let card = deck.popLast() {
                addToHand(card: card)
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
    
    func addToHand(card: Card) {
        for (index, element) in hand.enumerated() {
            if (element == nil) {
                hand[index] = card
                return
            }
        }
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

extension Array where Element : Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
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
