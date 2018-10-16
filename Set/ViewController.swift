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
    

    let game = SetGame();
    
    @IBAction func tappedCheat(_ sender: Any) {
        game.getHint()
        updateViewFromModel()
    }
    
    @IBOutlet var cardViews: [CardView]!
    
    @IBAction func tappedCard(_ sender: CardView) {
        print("Taped \(sender)")
        if let index = cardViews.index(of: sender) {
            print("  index: \(index)")
            game.pickCard(at: index)
        }
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
    
    func updateViewFromModel() {
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
    }
}
