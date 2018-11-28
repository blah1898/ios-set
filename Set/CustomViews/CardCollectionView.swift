//
//  CardCollectionView.swift
//  Set
//
//  Created by comp05A on 10/24/18.
//  Copyright © 2018 Universidad Autonoma de Baja California. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CardCollectionView : UIView {
    private var grid = Grid(layout: Grid.Layout.aspectRatio(CGFloat(5.0/7.0)))
    
    private var cardsToSpawn = [CardView]()
    private var cardsToDiscard = [CardView]()
    
    private(set) var cards = [CardView]()
    
    var cardSpawnPoint: CGRect? = nil
    var cardDiscardPoint: CGRect? = nil
    
    
    override func didAddSubview(_ subview: UIView) {
        setNeedsLayout()
    }
    
    func addCard(_ card: CardView) {
        cardsToSpawn.append(card);
        cards.append(card);
    }
    
    func discardCard(_ card: CardView) {
        cardsToDiscard.append(card);
        cards.remove(at: cards.index(of: card)!);
    }
    
    func animateCards() {
        cardsToSpawn.forEach { card in
            addSubview(card)
        }
        
        layoutIfNeeded()
        
        if let spawnPoint = cardSpawnPoint {
            for (index, card) in cardsToSpawn.enumerated() {
                let targetFrame = card.frame
                let startingFrame = spawnPoint
                
                card.frame = startingFrame

                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.1 * Double(index),
                    options: [.beginFromCurrentState, .allowAnimatedContent],
                    animations: {[weak card] in
                        card?.frame = targetFrame
                    },
                    completion: nil
                )
            }
        }
        
        // TODO: Discard animation
        
        cardsToDiscard.removeAll()
        cardsToSpawn.removeAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = bounds
        grid.cellCount = subviews.count
        for viewIndex in 0..<subviews.count {
            let view = subviews[viewIndex]
            
            let frame = grid[viewIndex]
            
            view.frame = frame ?? CGRect.zero
            view.layoutIfNeeded()
        }
    }
    
    func reset() {
        
        UIView.transition(
            with        : self,
            duration    : 0.25,
            options     : [.transitionCrossDissolve, .allowUserInteraction, .beginFromCurrentState],
            animations  : { [weak self] in
                for view in self?.subviews ?? [] {
                    view.removeFromSuperview();
                    self?.cards = []
                    self?.cardsToSpawn = []
                    self?.cardsToDiscard = []
                }
            },
            completion  : nil
        )
    }
    
}
