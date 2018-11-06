//
//  Card.swift
//  Set
//
//  Created by comp05A on 9/13/18.
//  Copyright © 2018 Universidad Autonoma de Baja California. All rights reserved.
//

import Foundation

/**
 Represents a card in the Set game
 
 - Author
 Bruce Hernández Gudiño
 
 # Fields
 
 `color`
 
 `shading`
 
 `count`
 
 `shape`
 
 */
struct Card : Equatable {
    
    /**
     Represents the level of shading of a card in the set game.
     
     # Values
     
     `light`: A light shading, usually represented by having no shading at all.
     
     `medium`: A medium shading, usually represented by a striped shading.
     
     `full`: A full shading, usually represented by a full color fill.
    */
    enum Shading: String {
        case light  = "light"
        case medium = "medium"
        case full   = "full"
        
        static let all: [Shading] = [.light, .medium, .full]
    }
    
    /**
     Represents the color of a card in the set game.
     
     # Values
     
     `black`
     
     `red`
     
     `blue`
     */
    enum Color: String {
        case black  = "black"
        case red    = "red"
        case blue   = "blue"
        
        static let all: [Color] = [.black, .red, .blue]
    }
    
    /**
     Represents the amount of shapes of a card in the set game.
     
     # Values
     
     `one`
     
     `two`
     
     `three`
     */
    enum Count: Int {
        case one    = 1
        case two    = 2
        case three  = 3
        
        static let all: [Count] = [.one, .two, .three]
    }
    
    /**
     Represents the type of shape of a card in the set game.
     
     # values
     
     `circle`
     
     `square`
     
     `star`
     */
    enum Shape: String {
        case circle = "circle"
        case square = "square"
        case star   = "star"
        
        static let all: [Shape] = [.circle, .square, .star]
    }

    let color   : Color
    let shading : Shading
    let count   : Count
    let shape   : Shape
    
    /**
     Create a Card object
     
     - Parameters:
        - color: The color of the card
        - shading: The shading of the card
        - count: The amount of shapes on the card
        - shape: The type of shape on the card
     */
    init(color: Color, shading: Shading, count: Count, shape: Shape) {
        self.color = color
        self.shading = shading
        self.count = count
        self.shape = shape
    }
}
