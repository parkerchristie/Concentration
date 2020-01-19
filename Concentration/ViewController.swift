//
//  ViewController.swift
//  Concentration
//
//  Created by Parker Christie on 2018-06-22.
//  Copyright © 2018 Parker Christie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
            return (cardButtons.count+1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themeIndex =  themeData.count.arc4random
        startNewGame()
        updateViewFromModel()
    }

    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 3.0,
            .strokeColor: buttonColor
        ]
        let attributedString = NSAttributedString(string: "Flips : \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private(set) var bestScore = 0 {
        didSet {
            updateBestScoreLabel()
        }
    }
    
    private func updateWinLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 3.0,
            .strokeColor: buttonColor
        ]
        let attributedString = NSAttributedString(string: "You Win!", attributes: attributes)
        winLabel.attributedText = attributedString
    }
    
    private func updateScoreLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 3.0,
            .strokeColor: buttonColor
        ]
        let attributedString = NSAttributedString(string: "Score : \(game.score)", attributes: attributes)
        scoreLabel.attributedText = attributedString
    }
    
    private func updateBestScoreLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 3.0,
            .strokeColor: buttonColor
        ]
        let attributedString = NSAttributedString(string: "Best : \(bestScore)", attributes: attributes)
        bestScoreLabel.attributedText = attributedString
    }
    
    @IBOutlet private weak var bestScoreLabel: UILabel! {
        didSet {
            let attributes: [NSAttributedStringKey:Any] = [
                .strokeWidth : 3.0,
                .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            ]
            let attributedString = NSAttributedString(string: "Best : \(bestScore)", attributes: attributes)
            bestScoreLabel.attributedText = attributedString
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            let attributes: [NSAttributedStringKey:Any] = [
                .strokeWidth : 3.0,
                .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            ]
            let attributedString = NSAttributedString(string: "Flips : \(flipCount)", attributes: attributes)
            flipCountLabel.attributedText = attributedString
        }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            let attributes: [NSAttributedStringKey:Any] = [
                .strokeWidth: 3.0,
                .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            ]
            let attributedString = NSAttributedString(string: "Score: \(game.score)", attributes: attributes)
            scoreLabel.attributedText = attributedString
        }
    }
    
    
    @IBOutlet weak var winLabel: UILabel! {
        didSet {
            let attributes: [NSAttributedStringKey:Any] = [
                .strokeWidth: 3.0,
                .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            ]
            let attributedString = NSAttributedString(string: "You Win!", attributes: attributes)
            scoreLabel.attributedText = attributedString
        }
    }
    private func toggleWinLabel(hidden: Bool) {
        winLabel.isHidden = hidden
    }
    
    @IBOutlet weak var newGameButton: UIButton!
    
    private func updateNewGameButton() {
        newGameButton.backgroundColor = buttonColor
        newGameButton.setTitleColor(themeColor, for: .normal)
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if !game.cards[cardButtons.index(of: sender)!].isMatched {
            flipCount += 1
        }
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        themeColor = themeData[themeIndex].viewColor
        buttonColor = themeData[themeIndex].cardColor
        view.backgroundColor = themeColor
        updateScoreLabel()
        updateBestScoreLabel()
        updateFlipCountLabel()
        updateNewGameButton()
        updateWinLabel()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : buttonColor
            }
        }
        if allMatchesCompleted() {
            toggleWinLabel(hidden: false)
        }
    }
    
    private func allMatchesCompleted() -> Bool {
        var correctChoices = 0
        for flipDownindex in 0..<game.cards.count {
            if game.cards[flipDownindex].isMatched {
                correctChoices += 1
            }
        }
        if correctChoices == game.cards.count {
            return true
        }
        else {
            return false
        }
    }
    
    private func startNewGame() {
        themeIndex = themeData.count.arc4random
        themeChoices = themeData[themeIndex].emojis
        buttonColor = themeData[themeIndex].cardColor
        toggleWinLabel(hidden: true)
        if allMatchesCompleted() {
            if bestScore < game.score {
                bestScore = game.score
            }
        }
        flipCount = 0
        for flipDownindex in 0..<game.cards.count {
            game.cards[flipDownindex].isFaceUp = false
            game.cards[flipDownindex].isMatched = false
            updateViewFromModel()
        }
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateScoreLabel()
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        startNewGame()
    }
//    private var emojiChoices = "🎃👻🦇🙀😱🍭😈🍬🍎"
    
    private struct Theme {
        var name: String
        var emojis: String
        var viewColor: UIColor
        var cardColor: UIColor
    }
    
    private var themeData: [Theme] = [
        Theme(name: "Halloween", emojis : "🎃👻🦇🙀😱🍭😈🍬🍎", viewColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cardColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
        Theme(name: "Animals", emojis: "🐶🐱🐭🦊🐻🐼🐹🐰🐯", viewColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), cardColor: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)),
        Theme(name: "Fish", emojis: "🐟🐠🐡🍣🍤🍥🎣", viewColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), cardColor: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)),
        Theme(name: "Sports", emojis: "⚽️🏀🏈⚾️🏉🏐🎾", viewColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), cardColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)),
        Theme(name: "Cars", emojis: "🚗🚕🚙🚌🚑🚓🚎🚒", viewColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), cardColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        Theme(name: "Flags", emojis: "🇨🇦🇨🇱🇨🇮🇯🇵🇺🇸🇺🇦🇰🇷🇳🇴", viewColor: #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), cardColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
    ]
    
    private var themeChoices = String()
    private var themeColor = UIColor()
    private var buttonColor = UIColor()
    private var themeIndex = Int()
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, (themeChoices.count) > 0 {
            let randomStringIndex = themeChoices.index((themeChoices.startIndex), offsetBy: (themeChoices.count.arc4random))
            emoji[card] = String(themeChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

