//
//  Day07.swift
//  
//
//  Created by Ekaterina Grishina on 14/12/23.
//

import Foundation

struct Day07: AdventDay {

    var data: String

    private var entities: [HandBid] {
        return data.split(separator: "\n").map { str in
            let handAndBid = str.split(separator: " ")
            let hand = String(handAndBid.first ?? "")
            let bid = Int(handAndBid.last ?? "") ?? 0
            return HandBid(hand: hand, bid: bid)
        }
    }

    func part1() -> Any {
        let sortedHands = entities.sorted { hand1, hand2 in // true if first < second
            let hand1Type = handType(hand: hand1.hand)
            let hand2Type = handType(hand: hand2.hand)

            if hand1Type == hand2Type {
                let zipped = zip(hand1.hand, hand2.hand)
                var result = false
                for (card1, card2) in zipped {
                    if card1 == card2 { continue }
                    result = convertToInt(card: card1) < convertToInt(card: card2)
                    break
                }
                return result
            }

            return hand1Type.rawValue < hand2Type.rawValue
        }

        return sortedHands.enumerated().reduce(0) { partialResult, iterableHand in
            return partialResult + iterableHand.element.bid * (iterableHand.offset + 1)
        }
    }

    func part2() -> Any {
        let sortedHands = entities.sorted { hand1, hand2 in // true if first < second
            let hand1Type = handType(hand: hand1.hand, isPartTwo: true)
            let hand2Type = handType(hand: hand2.hand, isPartTwo: true)

            if hand1Type == hand2Type {
                let zipped = zip(hand1.hand, hand2.hand)
                var result = false
                for (card1, card2) in zipped {
                    if card1 == card2 { continue }
                    result = convertToInt(card: card1, isPartTwo: true) < convertToInt(card: card2, isPartTwo: true)
                    break
                }
                return result
            }

            return hand1Type.rawValue < hand2Type.rawValue
        }

        return sortedHands.enumerated().reduce(0) { partialResult, iterableHand in
            return partialResult + iterableHand.element.bid * (iterableHand.offset + 1)
        }
    }

    func handType(hand: String, isPartTwo: Bool = false) -> HandType {
        var cardCounts = Array(repeating: 0, count: 15) // 13 types of cards and 0, 1 for covenience
        for card in hand {
            let number = convertToInt(card: card, isPartTwo: isPartTwo)
            cardCounts[number] += 1
        }

        var maxCount = cardCounts.max() ?? 0
        if isPartTwo {
            let jokerCount = cardCounts.remove(at: 1)
            let maxCardIndex = cardCounts.firstIndex(of: maxCount) ?? 0
            cardCounts[maxCardIndex] += jokerCount
            maxCount = cardCounts.max() ?? 0
        }

        switch maxCount {
            case 5: return .fiveOfAKind
            case 4: return .fourOfAKind
            case 3:
                if cardCounts.contains(where: { $0 == 2 }) { return .fullHouse }
                return .threeOfAKind
            case 2:
                if cardCounts.filter({ $0 == 2 }).count == 2 {
                    return .twoPair
                }
                return .onePair
            default:
                return .highCard
        }
    }

    func convertToInt(card: Character, isPartTwo: Bool = false) -> Int {
        let cardMapping: [Character: Int] = ["A": 14, "K": 13, "Q": 12, "J": isPartTwo ? 1 : 11, "T": 10]
        return card.isWholeNumber ? card.wholeNumberValue ?? 0 : cardMapping[card] ?? 0
    }
}

enum HandType: Int {
    case highCard = 1, onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, fiveOfAKind
}

struct HandBid {
    let hand: String
    let bid: Int
}
