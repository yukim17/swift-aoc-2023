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

    func part2() -> Any {
        return 0
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
}

extension Array {

    func item(at index: Array.Index) -> Array.Element? {
        guard index >= 0 && index < self.count else { return nil }

        return self[index]
    }
}
