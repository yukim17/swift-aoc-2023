import Algorithms
import Foundation

struct Day01: AdventDay {
    var data: String

    private var entities: [String] {
        data.split(separator: "\n").map(String.init)
    }

    private static let spellingDigits = [
        "one": "one1one",
        "two": "two2two",
        "three": "three3three",
        "four": "four4four",
        "five": "five5five",
        "six": "six6six",
        "seven": "seven7seven",
        "eight": "eight8eight",
        "nine": "nine9nine"
    ]

    func part1() -> Any {
        let digits = calibrationValues(from: entities)
        return digits.reduce(0, +)
    }

    func part2() -> Any {
        let preparedStrings = entities.map { str in
            replaceSpellingDigits(in: str)
        }
        let digits = calibrationValues(from: preparedStrings)
        return digits.reduce(0, +)
    }

    private func calibrationValues(from array: [String]) -> [Int] {
        return array.map { str in
            let digits = str.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            let resultString = (digits.first?.lowercased() ?? "") + (digits.last?.lowercased() ?? "")
            return Int(resultString) ?? 0
        }
    }

    private func replaceSpellingDigits(in string: String) -> String {
        var resultString = string
        Day01.spellingDigits.keys.forEach { digit in
            resultString = resultString.replacingOccurrences(of: digit, with: Day01.spellingDigits[digit] ?? "")
        }
        return resultString
    }
}
