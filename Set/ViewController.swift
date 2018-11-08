//
//  ViewController.swift
//  Set
//
//  Created by comp05A on 9/6/18.
//  Copyright © 2018 Universidad Autonoma de Baja California. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var cardCollectionView: CardCollectionView!
    
    let game = SetGame();
        
    @IBAction func tappedCheat(_ sender: Any) {
        game.getHint()
        updateViewFromModel()
    }
    
    @IBAction func tappedRestart() {
        game.reset()
        updateViewFromModel()
    }
    
    @IBAction func tappedDeal() {
        game.deal()
        updateViewFromModel()
    }

    override func viewDidLoad() {
        updateViewFromModel()
        
        view.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(self.rotatedHand)))
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown))
        
        swipeGesture.direction = .down
        
        view.addGestureRecognizer(swipeGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func rotatedHand(_ sender: UIRotationGestureRecognizer) {
        guard sender.view != nil else { return }
        
        print("Rotation: \(sender.rotation)")
        print("Velocity: \(sender.velocity)")
        
        if ( CGFloat.abs(sender.rotation) > CGFloat.pi * CGFloat(0.25) || CGFloat(sender.velocity) > CGFloat(5)) {
            game.shuffleHand()
            sender.rotation = CGFloat(0)
            // This trick cancels the current event
            sender.isEnabled = false
            sender.isEnabled = true
            updateViewFromModel()
        }
    }
    
    @objc func swipeDown(_ sender: UISwipeGestureRecognizer) {
        guard sender.view != nil else { return }
        
        
        if (game.canDeal) {
            game.deal()
            updateViewFromModel()
        }
    }
    
    @objc func cardTapped(_ sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        
        if let tappedIndex = cardCollectionView.subviews.firstIndex(of: sender.view!) {
            game.pickCard(at: tappedIndex)
            updateViewFromModel()
        }
    }
    
    let colors: [Card.Color: UIColor] = [
        Card.Color.black: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        Card.Color.blue: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),
        Card.Color.red: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    ]
    
    func updateViewFromModel() {
        // Make card counts equal
        let difference = cardCollectionView.subviews.count - game.hand.count
        
        if (difference < 0) {
            // There's more cards in our hand than in view
            for _ in 0..<(-difference) {
                let newCard = CardView(frame: CGRect.zero)
                newCard.isOpaque = false
                newCard.layoutMargins = UIEdgeInsets(top: CGFloat(8.0), left: CGFloat(8.0), bottom: CGFloat(8.0), right: CGFloat(8.0))
                newCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cardTapped)))
                cardCollectionView.addSubview(newCard)
            }
        } else {
            // There's less cards in our hand than in view
            for _ in 0..<difference {
                cardCollectionView.subviews[0].removeFromSuperview()
            }
        }
        
        for (index, view) in cardCollectionView.subviews.enumerated() {
            let cardView = view as! CardView
            
            let card = game.hand[index]
            
            // shape
            cardView.shape = card.shape.rawValue
            
            // Count
            cardView.count = card.count.rawValue
            
            // Color
            cardView.color = colors[card.color]!
            
            // Shading
            cardView.shading = card.shading.rawValue
            
            // Is it selected
            if game.selected.contains(index) {
                ViewController.animate(card: cardView, withColor: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
                //cardView.cardBackgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            // Is it a mismatch
            } else if game.lastMistake.contains(index) {
                ViewController.animate(card: cardView, withColor: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1))
            // Is it a match
            } else if game.lastMatch.contains(index) {
                ViewController.animate(card: cardView, withColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
            // Are we hinting at it
            } else if game.hint.contains(index) {
                ViewController.animate(card: cardView, withColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
            } else {
                ViewController.animate(card: cardView, withColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            }
            
        }
        
        deckLabel.text = "Deck: \(game.deck.count)"
        scoreLabel.text = "Score: \(game.score)"
        resetButton.isEnabled = game.canDeal
    }
    
    private static func animate(card: CardView, withColor color: UIColor) {
        // Don't animate if there haven't been any changes
        if (card.cardBackgroundColor != color) {
            UIView.transition(
                with        : card,
                duration    : 0.25,
                options     : [.transitionCrossDissolve, .allowUserInteraction, .beginFromCurrentState],
                animations  : { [weak card] in card?.cardBackgroundColor = color },
                completion  : nil
            )
        }
    }
}

extension CGFloat {
    public static func abs(_ val: CGFloat) -> CGFloat {
        return val >= CGFloat(0) ? val : -val
    }
}
