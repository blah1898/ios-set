//
//  UICard.swift
//  Set
//
//  Created by comp05A on 9/26/18.
//  Copyright © 2018 Universidad Autonoma de Baja California. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CardView : UIView {
    
    let colors: [Card.Color: UIColor] = [
        Card.Color.black: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        Card.Color.blue: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),
        Card.Color.red: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    ]
    
    let star = [
        CGPoint(x: 0.5, y: 0),
        CGPoint(x: 0.65, y: 0.35),
        CGPoint(x: 1, y: 0.35),
        CGPoint(x: 0.75, y: 0.55),
        CGPoint(x: 0.95, y: 1),
        CGPoint(x: 0.5, y: 0.7),
        CGPoint(x: 0.05, y: 1),
        CGPoint(x: 0.25, y: 0.55),
        CGPoint(x: 0, y: 0.35),
        CGPoint(x: 0.35, y: 0.35)
    ]
    
    let margin = 12.0
    let spacing = 6.0
    let shadingInterval = 5.0
    
    var card: Card? = nil {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func draw(_ rect: CGRect) {        
        if let drawingCard = card {
            
            let drawAreas = calculateDrawAreas(count: drawingCard.count.value)
            
            colors[drawingCard.color]!.setStroke()
            colors[drawingCard.color]!.setFill()
            
            for area in drawAreas {
                let symbolPath: UIBezierPath;
                switch(drawingCard.symbol) {
                case .circle:
                    symbolPath = circlePath(bounds: area)
                case .square:
                    symbolPath = squarePath(bounds: area)
                case .star:
                    symbolPath = starPath(bounds: area)
                }
                

                switch(drawingCard.shading) {
                case .full:
                    symbolPath.fill()
                case .medium:
                    symbolPath.stroke()
                    let shading = shadingPattern(bounds: area, interval: shadingInterval)
                    symbolPath.addClip()
                    shading.stroke()
                    UIGraphicsGetCurrentContext()!.resetClip()
                case .light:
                    symbolPath.stroke()
                }
            }
        }

    }
    
    private func calculateDrawAreas(count: Int) -> [CGRect] {
        // TODO: Burn this method
        let horizontal = bounds.width > bounds.height
        
        let marginatedArea = CGRect(
            origin: CGPoint(x: bounds.minX + margin, y: bounds.minY + margin),
            size: CGSize(width: bounds.width - (margin * 2), height: bounds.height - (margin * 2))
        )
        
        let longerSideLength = max(marginatedArea.width, marginatedArea.height)
        let shorterSideLength = min(marginatedArea.width, marginatedArea.height)
        
        let longerSideLimitedSideLength = (longerSideLength - (CGFloat(count) - 1) * spacing) / CGFloat(count)
        let shorterSideLimitedSideLength = shorterSideLength
        
        let limitedSideLength = min(longerSideLimitedSideLength, shorterSideLimitedSideLength)
        let exceedingSideLength = max(longerSideLimitedSideLength, shorterSideLimitedSideLength)
        
        let isShorterLimiting = shorterSideLimitedSideLength < longerSideLimitedSideLength
        
        var areas = [CGRect]()
        let centeringMargin: CGFloat
        let centeredArea: CGRect
        
        if (horizontal) {
            if (isShorterLimiting) {
                let usedUpSpace = (CGFloat(count) - 1.0) * spacing + limitedSideLength * Double(count)
                let remainingSpace = longerSideLength - usedUpSpace
                centeringMargin = remainingSpace / 2

                centeredArea = CGRect(
                    origin: CGPoint(x: marginatedArea.minX + centeringMargin, y: marginatedArea.minY),
                    size: CGSize(width: marginatedArea.width - centeringMargin * 2, height: marginatedArea.height)
                )
                
                for index in 0..<count {
                    areas.append(CGRect(
                        origin: CGPoint(x: centeredArea.origin.x + (limitedSideLength + spacing) * index, y: centeredArea.origin.y),
                        size: CGSize(width: limitedSideLength, height: limitedSideLength)
                    ))
                }
            } else {
                centeringMargin = (exceedingSideLength - limitedSideLength) / 2
                centeredArea = CGRect(
                    origin: CGPoint(x: marginatedArea.minX , y: marginatedArea.minY + centeringMargin),
                    size: CGSize(width: marginatedArea.width, height: marginatedArea.height - centeringMargin * 2)
                )

                for index in 0..<count {
                    areas.append(CGRect(
                        origin: CGPoint(x: centeredArea.origin.x + (limitedSideLength + spacing) * index, y: centeredArea.origin.y),
                        size: CGSize(width: limitedSideLength, height: limitedSideLength)
                    ))
                }
            }
        } else {
            if (isShorterLimiting) {
                let usedUpSpace = (CGFloat(count) - 1.0) * spacing + limitedSideLength * Double(count)
                let remainingSpace = longerSideLength - usedUpSpace
                centeringMargin = remainingSpace / 2
                
                centeredArea = CGRect(
                    origin: CGPoint(x: marginatedArea.minX, y: marginatedArea.minY + centeringMargin),
                    size: CGSize(width: marginatedArea.width, height: marginatedArea.height - centeringMargin * 2)
                )
                
                for index in 0..<count {
                    areas.append(CGRect(
                        origin: CGPoint(x: centeredArea.origin.x, y: centeredArea.origin.y + (limitedSideLength + spacing) * index),
                        size: CGSize(width: limitedSideLength, height: limitedSideLength)
                    ))
                }
            } else {
                centeringMargin = (exceedingSideLength - limitedSideLength) / 2
                centeredArea = CGRect(
                    origin: CGPoint(x: marginatedArea.minX + centeringMargin , y: marginatedArea.minY),
                    size: CGSize(width: marginatedArea.width - centeringMargin * 2, height: marginatedArea.height)
                )

                for index in 0..<count {
                    areas.append(CGRect(
                        origin: CGPoint(x: centeredArea.origin.x, y: centeredArea.origin.y + (limitedSideLength + spacing) * index),
                        size: CGSize(width: limitedSideLength, height: limitedSideLength)
                    ))
                }
            }
        }
        
        return areas;
    }
    
    private func shadingPattern(bounds: CGRect, interval: Double) -> UIBezierPath {
        let path = UIBezierPath()
        
        let startPosition = CGPoint(x: bounds.minX - bounds.height, y: bounds.minY)
        
        path.move(to: startPosition)
        
        for x in stride(from: Double(startPosition.x), to: Double(bounds.maxX), by: interval) {
            path.move(to: CGPoint(x: CGFloat(x), y: bounds.minY))
            path.addLine(to: CGPoint(x: CGFloat(x) + bounds.height, y: bounds.maxY))
        }
        
        return path
    }
    
    private func trianglePath(bounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let side = bounds.height // should be the same, since the draw area should be a square
        
        let topBottomMargin = (side - sqrt(3) * side / 2)/2
        
        path.move(to: CGPoint(x: bounds.minX + 0.5 * bounds.width, y: bounds.minY + topBottomMargin))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - topBottomMargin))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY - topBottomMargin))
        path.close()
        
        return path
    }
    
    private func polygon(bounds: CGRect, points: [CGPoint], closed: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        let side = bounds.width
        let start = points.first!
        let rest = points.dropFirst()
        
        path.move(to: CGPoint(x: bounds.minX + side * start.x, y: bounds.minY + side * start.y))
        
        for point in rest {
            path.addLine(to: CGPoint(x: bounds.minX + side * point.x, y: bounds.minY + side * point.y))
        }
        
        if closed {
            path.close()
        }
        
        return path
    }
    
    private func starPath(bounds: CGRect) -> UIBezierPath {
        return polygon(bounds: bounds, points: star, closed: true)
    }
    
    private func squarePath(bounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath(rect: bounds)
        
        return path
    }
    
    private func circlePath(bounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath(ovalIn: bounds)
        
        return path
    }
}


extension CGFloat {
    
    public static func -(lhs: CGFloat, rhs: Double) -> CGFloat {
        return lhs - CGFloat(rhs)
    }
    
    public static func -(lhs: CGFloat, rhs: Int) -> CGFloat {
        return lhs - CGFloat(rhs)
    }
    
    public static func +(lhs: CGFloat, rhs: Int) -> CGFloat {
        return lhs + CGFloat(rhs)
    }
    
    public static func +(lhs: CGFloat, rhs: Double) -> CGFloat {
        return lhs + CGFloat(rhs)
    }
    
    public static func *(lhs: CGFloat, rhs: Double) -> CGFloat {
        return lhs * CGFloat(rhs)
    }
    
    public static func *(lhs: CGFloat, rhs: Int) -> CGFloat {
        return lhs * CGFloat(rhs)
    }
}
