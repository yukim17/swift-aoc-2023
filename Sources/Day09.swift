//
//  Day09.swift
//  
//
//  Created by Ekaterina Grishina on 15/12/23.
//

import Foundation

struct Day09: AdventDay {

    var data: String

    private var entities: [[Int]] {
        return data.split(separator: "\n").map { str in
            return str.split(separator: " ").map { Int(String($0)) ?? 0 }
        }
    }

    func part1() -> Any {
        var differencies: [Int: [[Int]]] = [:]
        entities.enumerated().forEach { (index, historyNumbers) in
            var difference = calcDifference(for: historyNumbers)
            differencies[index] = [difference]
            while !difference.allSatisfy({ $0 == 0 }) {
                difference = calcDifference(for: difference)
                differencies[index]?.append(difference)
            }
        }

        var result = 0
        for (index, diffs) in differencies {
            var ind = diffs.count - 1
            var extrapolatedValue = diffs[ind].last ?? 0
            while ind != 0 {
                let nextVal = diffs[ind - 1].last ?? 0
                extrapolatedValue = extrapolatedValue + nextVal
                ind -= 1
            }
            result += (entities[index].last ?? 0) + extrapolatedValue
        }
        
        return result
    }

    func calcDifference(for history: [Int]) -> [Int] {
        return (1..<history.count).map { index in
            let prev = history[index - 1]
            let current = history[index]
            return current - prev
        }
    }

    func part2() -> Any {
        var differencies: [Int: [[Int]]] = [:]
        entities.enumerated().forEach { (index, historyNumbers) in
            var difference = calcDifference(for: historyNumbers)
            differencies[index] = [difference]
            while !difference.allSatisfy({ $0 == 0 }) {
                difference = calcDifference(for: difference)
                differencies[index]?.append(difference)
            }
        }

        var result = 0
        for (index, diffs) in differencies {
            var ind = diffs.count - 1
            var extrapolatedValue = diffs[ind].first ?? 0
            while ind != 0 {
                let nextVal = diffs[ind - 1].first ?? 0
                extrapolatedValue = nextVal - extrapolatedValue
                ind -= 1
            }
            result += (entities[index].first ?? 0) - extrapolatedValue
        }

        return result
    }
}
