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
    private(set)    var lastMistake = [Int]()
    private(set)    var lastMatch = [Int]()
    private(set)    var hint = [Int]()
    private(set)    var score = 0
    
    var deckCount : Int {
        return deck.count
    }
    
    var canDeal : Bool {
        return deck.count > 0
    }
    
    func removeLastMatch() {
        for index in lastMatch.sorted(by: {$1 < $0}) {
            hand.remove(at: index)
        }
    }
    
    func pickCard(at index: Int) {
        if (!hand.indices.contains(index)) {
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
            if checkIfMatch(hand[selected[0]], hand[selected[1]], hand[selected[2]]) {
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
        lastMatch = []
        hint = findPossibleMatch() ?? []
    }
    
    private func findPossibleMatch() -> [Int]? {
        var match = [Int]()
        forEachInHand { index1, card1 in
            if match != [] {
                return
            }
            
            forEachInHand { index2, card2 in
                if index1 == index2 {
                    return
                }
                
                if match != [] {
                    return
                }
                forEachInHand { index3, card3 in
                    if match != [] {
                        return
                    }
                    
                    if index2 == index3 || index1 == index3 {
                        return
                    }
                    
                    if checkIfMatch(card1, card2, card3) {
                        match = [index1, index2, index3]
                        return
                    }
                }
            }
        }
	
        return match
    }
    
    func checkIfMatch(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool{
        var colorMatched    = false
        var shadingMatched  = false
        var symbolMatched   = false
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
    
    func forEachInHand(_ perform: (Int, Card) -> () ) {
        hand.enumerated().forEach(perform)
    }
    
    func reset() {
        hand = [Card]()
        score = 0
        selected = []
        lastMistake = []
        lastMatch = []
        hint = []
        deck = SetGame.generateDeck().shuffled()
        initialDeal()
    }
    
    func deal() {
        if !self.canDeal {
            return;
        }
        
        removeLastMatch()
        
        if findPossibleMatch() != nil {
            score -= 1
        }
        

        lastMistake = []
        lastMatch = []
        hint = []
        
        for _ in 1...3 {
            if let card = deck.popLast() {
                addToHand(card: card);
            }
        }
    }
    
    private func initialDeal() {
        for _ in 1...12 {
            if let card = deck.popLast() {
                addToHand(card: card)
            }
        }
    }
    
    private static func generateDeck() -> [Card] {
        var newDeck = [Card]()
        
        for color in Card.Color.all {
            for shading in Card.Shading.all {
                for count in Card.Count.all {
                    for symbol in Card.Symbol.all {
                        newDeck.append(Card(color: color, shading: shading, count: count, symbol: symbol))
                    }
                }
            }
        }
        
        return newDeck
    }
    
    func addToHand(card: Card) {
        hand.append(card)
    }

    init() {
        deck = SetGame.generateDeck().shuffled()
      
        initialDeal()
    }
}

extension Array {
    func shuffled() -> Array<Element> {
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
}
