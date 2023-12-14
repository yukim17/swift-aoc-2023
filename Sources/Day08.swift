//
//  Day08.swift
//  
//
//  Created by Ekaterina Grishina on 14/12/23.
//

import Foundation

struct Day08: AdventDay {

    var data: String

    private var entities: (instructions: String, map: [String: (left: String, right: String)]) {
        let strings = data.split(separator: "\n\n")
        let instructions = String(strings.first ?? "")

        var map: [String: (left: String, right: String)] = [:]
        strings.last?.split(separator: "\n").forEach { str in
            var formattedStr = String(str).replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "=(", with: ",")
            formattedStr.removeLast()
            let components = formattedStr.split(separator: ",")
            let start = String(components.first ?? "")
            let left = String(components.item(at: 1) ?? "")
            let right = String(components.last ?? "")
            map[start] = (left, right)
        }
        return (instructions, map)
    }

    func part1() -> Any {
        var stepCount = 0
        let map = entities.map
        let instructions = Array(entities.instructions)
        var currentStep = "AAA"
        var isExitFound = false
        var instructionIndex = 0
        while !isExitFound {
            let instruction = instructions[instructionIndex]
            let nextInstructions = map[currentStep]
            if instruction == "L" {
                currentStep = nextInstructions?.left ?? ""
            } else {
                currentStep = nextInstructions?.right ?? ""
            }
            stepCount += 1
            instructionIndex += 1
            if currentStep == "ZZZ" {
                isExitFound = true
            }
            if instructionIndex >= instructions.count {
                instructionIndex = 0
            }
        }
        return stepCount
    }

    func part2() -> Any {
        let stepCounts = entities.map.keys.filter({ $0.last == "A" }).map { start in
            return stepsCountForInput(start: start)
        }

        return Int.lcm(stepCounts)
    }

    func stepsCountForInput(start: String) -> Int {
        var stepCount = 0
        let map = entities.map
        let instructions = Array(entities.instructions)
        var currentStep = start
        var isExitFound = false
        var instructionIndex = 0
        while !isExitFound {
            let instruction = instructions[instructionIndex]
            let nextInstructions = map[currentStep]
            if instruction == "L" {
                currentStep = nextInstructions?.left ?? ""
            } else {
                currentStep = nextInstructions?.right ?? ""
            }
            stepCount += 1
            instructionIndex += 1
            if currentStep.last == "Z" {
                isExitFound = true
            }
            if instructionIndex >= instructions.count {
                instructionIndex = 0
            }
        }
        return stepCount
    }
}

extension Int {

    static func gcd(_ a: Int, _ b: Int) -> Int {
        var (a, b) = (a, b)
        while b != 0 {
            (a, b) = (b, a % b)
        }
        return abs(a)
    }

    // GCD of a vector of numbers:
    static func gcd(_ vector: [Int]) -> Int {
        return vector.reduce(0, Int.gcd)
    }

    // LCM of two numbers:
    static func lcm(a: Int, b: Int) -> Int {
        return (a / Int.gcd(a, b)) * b
    }

    // LCM of a vector of numbers:
    static func lcm(_ vector : [Int]) -> Int {
        return vector.reduce(1, Int.lcm)
    }
}
