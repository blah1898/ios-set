//
//  ViewController.swift
//  Set
//
//  Created by comp05A on 9/6/18.
//  Copyright © 2018 Universidad Autonoma de Baja California. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let colors = [
        Color.red: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
        Color.black: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        Color.blue: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),
    ]
    
    let symbols = [
        Symbol.circle: "●",
        Symbol.square: "■",
        Symbol.star: "★",
    ]
    
    let shadings = [
        Shading.light: 0.2,
        Shading.medium: 0.7,
        Shading.full: 1.0,
    ]

    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    let game = SetGame();
    
    @IBAction func tappedCheat(_ sender: Any) {
        game.getHint()
        updateViewFromModel()
    }
    
    @IBAction func tappedCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
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
        super.viewDidLoad()
        cardButtons = cardButtons.sorted(by: {$0.tag < $1.tag})
        updateViewFromModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViewFromModel() {
        for (index, button) in cardButtons.enumerated() {
            
            let optionalCard = game.hand.indices.contains(index)
                ? game.hand[index]
                : nil
            
            if let card = optionalCard {
                
                let color = colors[card.color]!
                let shading = shadings[card.shading]!
                let symbol = symbols[card.symbol]!
                let count : Int
                
                switch card.count {
                case .one:
                    count = 1
                case .two:
                    count = 2
                case .three:
                    count = 3
                }
                
                let shadedColor = color.withAlphaComponent(CGFloat(shading))
                let countedString = String(repeating: symbol, count: count)
                
                let attributes = [
                    NSAttributedStringKey.foregroundColor: shadedColor
                ]
                
                let attributedString = NSAttributedString(string: countedString, attributes: attributes)
                
                button.setAttributedTitle(attributedString, for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
                
                if game.selected.contains(index) {
                    button.layer.shadowRadius = 5.0
                    button.layer.shadowOpacity = 1.0
                    button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                    button.layer.shadowColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    button.layer.masksToBounds = false
                } else if game.lastMistake.contains(index) {
                    button.layer.shadowRadius = 5.0
                    button.layer.shadowOpacity = 1.0
                    button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                    button.layer.shadowColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    button.layer.masksToBounds = false
                } else if game.lastMatch.contains(index) {
                    button.layer.shadowRadius = 5.0
                    button.layer.shadowOpacity = 1.0
                    button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                    button.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    button.layer.masksToBounds = false
                } else if game.hint.contains(index) {
                    button.layer.shadowRadius = 5.0
                    button.layer.shadowOpacity = 1.0
                    button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                    button.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    button.layer.masksToBounds = false
                } else {
                    button.layer.shadowOpacity = 0.0
                }
            } else {
                button.setAttributedTitle(NSAttributedString(string: ""), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                continue
            }
        }
        
        deckLabel.text = "Deck: \(game.deck.count)"
        resetButton.isEnabled = game.canDeal
    }
}
