//
//  Day04.swift
//  
//
//  Created by Ekaterina Grishina on 10/12/23.
//

import Foundation

struct Card {
    let winnigNumbers: Set<Int>
    let cardNumbers: Set<Int>
}

struct Day04: AdventDay {

    var data: String

    private var entities: [Card] {
        data.split(separator: "\n").map { str in
            var string = str
            string.replace(/(Card \d+: )/) { match in
                ""
            }

            let stringParts = string.split(separator: " | ")
            var winningNumbers: [Int] = []
            var cardNumbers: [Int] = []
            if let winningNumsString = stringParts.first {
                winningNumbers = winningNumsString.split(separator: " ").map { numStr in
                    Int(numStr) ?? 0
                }
            }

            if let cardNumsString = stringParts.last {
                cardNumbers = cardNumsString.split(separator: " ").map { numStr in
                    Int(numStr) ?? 0
                }
            }
            return Card(winnigNumbers: Set(winningNumbers), cardNumbers: Set(cardNumbers))
        }
    }

    func part1() -> Any {
        return entities.reduce(0) { partialResult, card in
            let cardWinnigNumbers = card.winnigNumbers.intersection(card.cardNumbers)
            guard cardWinnigNumbers.count > 0 else { return partialResult }
            return partialResult + (cardWinnigNumbers.count > 1 ? NSDecimalNumber(decimal: pow(2, cardWinnigNumbers.count - 1)).intValue : 1)
        }
    }

    func part2() -> Any {
        var cardPile = Dictionary(uniqueKeysWithValues: zip(0..<entities.count, Array(repeating: 1, count: entities.count)))
        for (index, card) in entities.enumerated() {
            let cardWinnigNumbers = card.winnigNumbers.intersection(card.cardNumbers)
            guard cardWinnigNumbers.count > 0 else { continue }

            let startIndex = index + 1
            let endIndex = index + cardWinnigNumbers.count
            (startIndex...endIndex).forEach { pileIndex in
                if let cardCount = cardPile[pileIndex] {
                    let multiplier = cardPile[index] ?? 1
                    cardPile[pileIndex] = cardCount + 1 * multiplier
                }
            }
        }
        return cardPile.values.reduce(0, +)
    }
}
