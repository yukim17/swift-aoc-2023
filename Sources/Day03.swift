//
//  Day03.swift
//  
//
//  Created by Ekaterina Grishina on 09/12/23.
//

import Foundation
import RegexBuilder

struct Day03: AdventDay {

    var data: String

    private var entities: [String] {
        data.split(separator: "\n").map(String.init)
    }

    func part1() -> Any {
        var result = 0
        entities.enumerated().forEach { index, str in
            let regex = Regex {
                TryCapture {
                    OneOrMore(.digit)
                } transform: {
                    Int($0)
                }
            }

            let digitMatches = str.matches(of: regex)
            digitMatches.forEach { match in
                var isValidnumber = false
                isValidnumber = isValidnumber || testSameString(str: str, range: match.range)

                // check the next string
                if let nextString = entities.item(at: index + 1) {
                    isValidnumber = isValidnumber || testAnotherString(str: nextString, range: match.range)
                }

                // check previous string
                if let previousString = entities.item(at: index - 1) {
                    isValidnumber = isValidnumber || testAnotherString(str: previousString, range: match.range)
                }

                result += isValidnumber ? match.1 : 0
            }
        }
        
        return result
    }

    private func testSameString(str: String, range: Range<String.Index>) -> Bool {
        if let previousSymbolIndex = str.index(range.lowerBound, offsetBy: -1, limitedBy: str.startIndex),
           str[previousSymbolIndex] != "." {
            return true
        }

        if range.upperBound < str.endIndex && str[range.upperBound] != "." {
            return true
        }

        return false
    }

    private func testAnotherString(str: String, range: Range<String.Index>) -> Bool {
        let lowerBound = str.index(range.lowerBound, offsetBy: -1, limitedBy: str.startIndex) ?? str.startIndex
        let upperBound = range.upperBound < str.endIndex ? range.upperBound : str.index(before: str.endIndex)
        let stringToTest = str[lowerBound...upperBound]
        return stringToTest.contains(where: { $0 != "." })
    }

    func part2() -> Any {
//        var result = 0
//        entities.enumerated().forEach { index, str in
//            let regex = Regex {
//                TryCapture {
//                    OneOrMore(.digit)
//                } transform: {
//                    Int($0)
//                }
//            }
//
//            let digitMatches = str.matches(of: regex)
//            digitMatches.enumerated().forEach { matchIndex, match in
//
//                // Check right side for any gear
//                if let nextMatch = digitMatches.item(at: matchIndex + 1), match.range.upperBound < str.endIndex && str[match.range.upperBound] == "*" {
//                    let startIndexOfAnotherDigit = str.index(after: match.range.upperBound)
//                    if nextMatch.range.contains(startIndexOfAnotherDigit) {
//                        result += match.1 * nextMatch.1
//                    }
//                }
//
//                // Check bottom for any gear
//                if let nextStr = entities.item(at: index + 1),
//                   let indexOfGear = hasNextStringAGear(str: nextStr, range: match.range) {
//
//                    // check left from the gear
//                    let leftRange = nextStr.startIndex..<indexOfGear
//                    let leftSubstring = nextStr[leftRange]
//                    if leftSubstring.last?.isNumber ?? false {
//                        let number = Int(leftSubstring.suffix(while: { $0.isNumber })) ?? 0
//                        result += match.1 * number
//                    }
//
//                    // check right from the gear
//                    if indexOfGear < nextStr.endIndex {
//                        let rightRange = nextStr.index(after: indexOfGear)..<str.endIndex
//                        let rightSubstring = nextStr[rightRange]
//                        if rightSubstring.first?.isNumber ?? false {
//                            let number = Int(rightSubstring.prefix(while: { $0.isNumber })) ?? 0
//                            result += match.1 * number
//                        }
//                    }
//
//                    // check bottom
//                    if let nextNumberStr = entities.item(at: index + 2) {
//                        let lowerBound = nextNumberStr.index(indexOfGear, offsetBy: -1, limitedBy: nextNumberStr.startIndex) ?? nextNumberStr.startIndex
//                        let upperBound = nextNumberStr.index(indexOfGear, offsetBy: 1, limitedBy: nextNumberStr.lastCharIndex) ?? nextNumberStr.lastCharIndex
//                        let rangeToTest = lowerBound...upperBound
//                        nextNumberStr.matches(of: regex).filter({ $0.range.overlaps(rangeToTest) }).forEach { secondNumMatch in
//                            result += match.1 * secondNumMatch.1
//                        }
//                    }
//                }
//            }
//        }

        return solve(for: data)
    }

    private func hasNextStringAGear(str: String, range: Range<String.Index>) -> String.Index? {
        let lowerBound = str.index(range.lowerBound, offsetBy: -1, limitedBy: str.startIndex) ?? str.startIndex
        let upperBound = range.upperBound < str.endIndex ? range.upperBound : str.index(before: str.endIndex)
        let stringToTest = str[lowerBound...upperBound]
        return stringToTest.firstIndex(of: "*")
    }
}

extension Array {

    func item(at index: Array.Index) -> Array.Element? {
        guard index >= 0 && index < self.count else { return nil }

        return self[index]
    }
}
