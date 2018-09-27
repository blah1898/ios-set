//
//  UICard.swift
//  Set
//
//  Created by comp05A on 9/26/18.
//  Copyright © 2018 Universidad Autonoma de Baja California. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class CardView : UIView {
    var card: Card? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_: CGRect) {
        if let drawingCard = card {
            let path = UIBezierPath()
            
            if drawingCard.shading == .medium {
                // Draw the "striped" pattern
                
            }
        } else {
            self.isHidden = true
        }
    }
    
    private func shadingPattern() -> UIBezierpath {
        
    }
    
    private func trianglePath() -> UIBezierPath {
        let path = UIBezierPath()
        
        
        return path
    }
    
    private func starPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        return path
    }
    
    private func squarePath() -> UIBezierPath {
        let path = UIBezierPath()
        
        return path
    }
    
    private func circlePath() -> UIBezierPath {
        let path = UIBezierPath()
        
        return path
    }
}
