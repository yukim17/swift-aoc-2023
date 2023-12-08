//
//  Day02.swift
//  
//
//  Created by Ekaterina Grishina on 08/12/23.
//

import Foundation
import RegexBuilder

struct Day02: AdventDay {

    var data: String

    var entities: [String] {
        data.split(separator: "\n").map { str in
            var string = str
            string.replace(/(Game \d+: )/) { match in
                ""
            }
            return String(string)
        }
    }

    func part1() -> Any {
        let possibleValues = (red: 12, green: 13, blue: 14)
        var result = 0

        entities.enumerated().forEach { index, game in
            let isRedValid = isGameSetValid(for: game, with: .red, reference: possibleValues.red)
            let isGreenValid = isGameSetValid(for: game, with: .green, reference: possibleValues.green)
            let isBlueValid = isGameSetValid(for: game, with: .blue, reference: possibleValues.blue)

            if isRedValid && isGreenValid && isBlueValid {
                result += index + 1
            }
        }

        return result
    }

    func part2() -> Any {
        return entities.reduce(0) { partialResult, gameSet in
            let redComponent = minColorComponent(for: gameSet, of: .red)
            let greenComponent = minColorComponent(for: gameSet, of: .green)
            let blueComponent = minColorComponent(for: gameSet, of: .blue)
            return partialResult + redComponent * greenComponent * blueComponent
        }
    }

    func isGameSetValid(for game: String, with color: ColorComponent, reference: Int) -> Bool {
        let regex = Regex {
            TryCapture {
                OneOrMore(.digit)
              } transform: {
                Int($0)
              }
            One(.whitespace)
            One("\(color.rawValue)")
        }

        let gameMatches = game.matches(of: regex)
        return !gameMatches.isEmpty ? gameMatches.allSatisfy({ $0.1 <= reference }) : true
    }

    func minColorComponent(for game: String, of color: ColorComponent) -> Int {
        let regex = Regex {
            TryCapture {
                OneOrMore(.digit)
              } transform: {
                Int($0)
              }
            One(.whitespace)
            One("\(color.rawValue)")
        }

        let gameMatches = game.matches(of: regex)
        return gameMatches.max(by: { $0.1 < $1.1 })?.1 ?? 0
    }

    enum ColorComponent: String {
        case red
        case green
        case blue
    }
}
