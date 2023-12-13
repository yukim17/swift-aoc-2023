//
//  Day06.swift
//  
//
//  Created by Ekaterina Grishina on 13/12/23.
//

import Foundation

struct Day06: AdventDay {

    var data: String

    private var entities: [Game] {
        let strings = data.split(separator: "\n")
        guard let timeStrings = strings.first?.suffix(while: { $0.isWhitespace || $0.isNumber }).split(separator: " "),
              let distanceStrings = strings.last?.suffix(while: { $0.isWhitespace || $0.isNumber }).split(separator: " ") else {
            return []
        }

        return zip(timeStrings, distanceStrings).map { timeStr, distanceStr in
            let time = Int(timeStr) ?? 0
            let distance = Int(distanceStr) ?? 0
            return Game(time: time, distance: distance)
        }
    }

    func part1() -> Any {
        let winCountsForGames = entities.map { game in
            countWins(with: game.time, distance: game.distance)
        }

        return winCountsForGames.reduce(1, *)
    }

    func part2() -> Any {
        let strings = data.split(separator: "\n")
        guard let timeString = strings.first?.suffix(while: { $0.isWhitespace || $0.isNumber }).replacingOccurrences(of: " ", with: ""),
              let distanceString = strings.last?.suffix(while: { $0.isWhitespace || $0.isNumber }).replacingOccurrences(of: " ", with: "") else {
            return 0
        }

        let time = Int(timeString) ?? 0
        let distance = Int(distanceString) ?? 0

        return countWins(with: time, distance: distance)
    }

    func countWins(with time: Int, distance: Int) -> Int {
        var winCounts = 0
        for buttonHoldTime in 0...time {
            let winDistance = (time - buttonHoldTime) * buttonHoldTime
            if winDistance > distance {
                winCounts += 1
            }
        }
        return winCounts
    }
}

struct Game {
    let time: Int
    let distance: Int
}
