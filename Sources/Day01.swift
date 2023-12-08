import Algorithms
import Foundation

struct Day01: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [String] {
        data.split(separator: "\n").map(String.init)
    }

    private static let digitsRegExp = "one|two|three|four|five|six|seven|eight|zero"
    private let regex = try? NSRegularExpression(pattern: "\\d|\(Day01.digitsRegExp)")
    private let regexReversed = try? NSRegularExpression(pattern: "\\d|\(Day01.digitsRegExp.reversed())")

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let digits = entities.map { str in
            let digits = str.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            let resultString = (digits.first?.lowercased() ?? "") + (digits.last?.lowercased() ?? "")
            return Int(resultString) ?? 0
        }
        return digits.reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let digits = entities.map { str in
            let range = NSRange(location: 0, length: str.count)
            //            let matchesFirst = regex?.firstMatch(in: str, range: range)
            //            let matchesLast = regexReversed?.firstMatch(in: String(str.reversed()), range: range)
            guard let firstMatch = regex?.firstMatch(in: str, range: range),
                  let lastMatch = regexReversed?.firstMatch(in: str.reversedString(), range: range) else { return 0 }

            let firstDigit = str.substring(with: firstMatch.range).replacedWithDigit()
            let secondDigit = str.reversedString()
                .substring(with: lastMatch.range)
                .reversedString()
                .replacedWithDigit()

            return Int(firstDigit + secondDigit) ?? 0
        }
        return digits.reduce(0, +)
    }
}

fileprivate extension String {

    private static let spellingDigits = [
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "nine": 9,
        "zero": 0
    ]

    func substring(with range: NSRange) -> String {
        guard let newRange = Range(range, in: self) else { return "" }
        return String(self[newRange])
    }

    func replacedWithDigit() -> String {
        guard let digitToReplace = String.spellingDigits[self] else { return self }
        return String(digitToReplace)
    }

    func reversedString() -> String {
        String(self.reversed())
    }
}
