//
//  Concentration.swift
//  Concentration
//
//  Created by Parker Christie on 2018-06-22.
//  Copyright © 2018 Parker Christie. All rights reserved.
//

import Foundation

struct Concentration {
    
    var cards = [Card]()
    private(set) var tempCards = [Card]()
    private var seenCards: Set<Int> = []
    private(set) var score = 0
    
    private struct Points {
        static let matchBonus = 2
        static let mismatchPenalty = 1
    }
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not within bounds")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += Points.matchBonus
                } else {
                    if seenCards.contains(index) {
                        score -= Points.mismatchPenalty
                    }
                    if seenCards.contains(matchIndex) {
                        score -= Points.mismatchPenalty
                    }
                }
                seenCards.insert(index)
                seenCards.insert(matchIndex)
                cards[index].isFaceUp = true
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            tempCards += [card, card]
        }
        // TODO: Shuffle the cards
        for _ in 0..<tempCards.count {
            if tempCards.count > 0 {
                let randomIndex = Int(arc4random_uniform(UInt32(tempCards.count)))
                cards.append(tempCards[randomIndex])
                tempCards.remove(at: randomIndex)
            }
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}









