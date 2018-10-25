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
    
    @IBAction func tappedCard(_ sender: CardView) {
        print("Taped \(sender)")
        /*
        if let index = cardViews.index(of: sender) {
            print("  index: \(index)")
            game.pickCard(at: index)
        }
         */
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            // Symbol
            cardView.symbol = card.symbol.rawValue
            
            // Count
            cardView.count = card.count.value
            
            // Color
            cardView.color = colors[card.color]!
            
            // Shading
            cardView.shading = card.shading.rawValue
            
        }
        
        deckLabel.text = "Deck: \(game.deck.count)"
        scoreLabel.text = "Score: \(game.score)"
        resetButton.isEnabled = game.canDeal
        
        /*
        for (index, cardView) in cardViews.enumerated() {
            
            let optionalCard = game.hand.indices.contains(index)
                ? game.hand[index]
                : nil
            
            cardView.card = optionalCard
            if let card = optionalCard {
                cardView.card = card
                if game.selected.contains(index) {
                    cardView.layer.shadowOpacity = 1.0
                    cardView.layer.shadowColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                } else if game.lastMistake.contains(index) {
                    cardView.layer.shadowOpacity = 1.0
                    cardView.layer.shadowColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                } else if game.lastMatch.contains(index) {
                    cardView.layer.shadowOpacity = 1.0
                    cardView.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                } else if game.hint.contains(index) {
                    cardView.layer.shadowOpacity = 1.0
                    cardView.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                } else {
                    cardView.layer.shadowOpacity = 0.0
                }
            } else {
                cardView.layer.shadowOpacity = 0.0
            }
        }
        
        deckLabel.text = "Deck: \(game.deck.count)"
        scoreLabel.text = "Score: \(game.score)"
        resetButton.isEnabled = game.canDeal
        */
    }
}
