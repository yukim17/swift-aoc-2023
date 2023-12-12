//
//  Day05.swift
//  
//
//  Created by Ekaterina Grishina on 11/12/23.
//

import Foundation
import RegexBuilder

struct Day05: AdventDay {

    var data: String

    private var entities: SeedsInfo {
        let regexForSeeds =  Regex {
            "seeds: "
            Capture(
                OneOrMore(.anyNonNewline)
            )
        }

        var seedsInfo = SeedsInfo()

        if let seedsString = data.firstMatch(of: regexForSeeds)?.1 {
            seedsInfo.seeds = seedsString.split(separator: " ").map({ Int($0) ?? 0 })
        }

        var currentSource = TypeOfResource.unknown
        for str in data.split(separator: "\n") {
            if TypeOfResource.allCases.contains(where: { str.contains($0.rawValue) }) {
                currentSource = TypeOfResource(rawValue: String(str.prefix(upTo: str.index(before: str.endIndex)))) ?? .unknown
                continue
            }

            guard let (sourceRange, destinationRange) = rangesFrom(string: String(str)) else { continue }
            switch currentSource {
            case .seedToSoil:
                seedsInfo.seedToSoil[sourceRange] = destinationRange
            case .soilToFertilizer:
                seedsInfo.soilToFertilizer[sourceRange] = destinationRange
            case .fertilizerToWater:
                seedsInfo.fertilizierToWater[sourceRange] = destinationRange
            case .waterToLigth:
                seedsInfo.waterToLight[sourceRange] = destinationRange
            case .lightToTemperature:
                seedsInfo.lightToTemperature[sourceRange] = destinationRange
            case .temperatureToHumidity:
                seedsInfo.temperatureToHumidity[sourceRange] = destinationRange
            case .humididtyToLocation:
                seedsInfo.humidityToLocation[sourceRange] = destinationRange
            case .unknown:
                break
            }
        }

        return seedsInfo
    }

    func part1() -> Any {
        let locations = entities.seeds.map { seed in
            let soil = matchingComponent(component: seed, mapping: entities.seedToSoil)
            let fertilizer = matchingComponent(component: soil, mapping: entities.soilToFertilizer)
            let water = matchingComponent(component: fertilizer, mapping: entities.fertilizierToWater)
            let light = matchingComponent(component: water, mapping: entities.waterToLight)
            let temperature = matchingComponent(component: light, mapping: entities.lightToTemperature)
            let humidity = matchingComponent(component: temperature, mapping: entities.temperatureToHumidity)
            return matchingComponent(component: humidity, mapping: entities.humidityToLocation)
        }
        return locations.min() ?? 0
    }

    func part2() -> Any {
        let seedsRanges = entities.seeds.chunked(into: entities.seeds.count / 2).map { chunk in
            return chunk[0]..<chunk[0] + chunk[1]
        }

        let soil = checkMatchingRanges(sourceRanges: seedsRanges, mapping: entities.seedToSoil)
        let fertilizer = checkMatchingRanges(sourceRanges: soil, mapping: entities.soilToFertilizer)
        let water = checkMatchingRanges(sourceRanges: fertilizer, mapping: entities.fertilizierToWater)
        let light = checkMatchingRanges(sourceRanges: water, mapping: entities.waterToLight)
        let temperature = checkMatchingRanges(sourceRanges: light, mapping: entities.lightToTemperature)
        let humidity = checkMatchingRanges(sourceRanges: temperature, mapping: entities.temperatureToHumidity)
        let location = checkMatchingRanges(sourceRanges: humidity, mapping: entities.humidityToLocation)

        return location.map({ $0.lowerBound }).min() ?? 0
    }

    private func rangesFrom(string: String) -> (source: Range<Int>, destination: Range<Int>)? {
        let mappingRegex = Regex {
            TryCapture {
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
            One(.whitespace)

            TryCapture {
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
            One(.whitespace)

            TryCapture {
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
        }

        guard let match = string.firstMatch(of: mappingRegex) else { return nil }
        let (_, destination, source, length) = match.output
        let destinationRange = destination..<(destination + length)
        let sourceRange = source..<(source + length)
        return (sourceRange, destinationRange)
    }

    func matchingComponent(component: Int, mapping: [Range<Int>: Range<Int>]) -> Int {
        guard let source = mapping.keys.first(where: { $0.contains(component) }),
                let destination = mapping[source] else { return component }

        let offset = component - source.startIndex
        let destComponent = destination.startIndex + offset

        return destComponent
    }

    func checkMatchingRanges(sourceRanges: [Range<Int>], mapping: [Range<Int>: Range<Int>]) -> [Range<Int>] {
        var rangesToCheck = sourceRanges
        var result: [Range<Int>] = []
        var prevResultCount = 0

        repeat {
            prevResultCount = result.count
            for rangeToCheck in rangesToCheck {
                var isOverlappingFound = false
                for (sourceRange, destRange) in mapping {
                    guard !isOverlappingFound else { break }
                    guard sourceRange.overlaps(rangeToCheck) else { continue }
                    isOverlappingFound.toggle()

                    let overlappingLowerBound = max(sourceRange.lowerBound, rangeToCheck.lowerBound)
                    let overlappingUpperBound = min(sourceRange.upperBound, rangeToCheck.upperBound)
                    let overlappingRange = overlappingLowerBound...overlappingUpperBound
                    let offset = destRange.lowerBound - sourceRange.lowerBound
                    result.append((overlappingRange.lowerBound + offset)..<(overlappingRange.upperBound + offset))

                    if overlappingRange.lowerBound > rangeToCheck.lowerBound {
                        rangesToCheck.append(rangeToCheck.lowerBound..<overlappingRange.lowerBound)
                    }

                    if overlappingRange.upperBound < rangeToCheck.upperBound {
                        rangesToCheck.append((overlappingRange.upperBound)..<(rangeToCheck.upperBound))
                    }
                }

                if isOverlappingFound {
                    rangesToCheck.removeAll(where: { $0 == rangeToCheck })
                }
            }
        } while result.count > prevResultCount

        if !rangesToCheck.isEmpty {
            result.append(contentsOf: rangesToCheck)
        }

        return result
    }
}

struct SeedsInfo {
    var seeds: [Int] = []
    var seedToSoil: [Range<Int>: Range<Int>] = [:]
    var soilToFertilizer: [Range<Int>: Range<Int>] = [:]
    var fertilizierToWater: [Range<Int>: Range<Int>] = [:]
    var waterToLight: [Range<Int>: Range<Int>] = [:]
    var lightToTemperature: [Range<Int>: Range<Int>] = [:]
    var temperatureToHumidity: [Range<Int>: Range<Int>] = [:]
    var humidityToLocation: [Range<Int>: Range<Int>] = [:]
}

enum TypeOfResource: String, CaseIterable {
    case seedToSoil = "seed-to-soil map"
    case soilToFertilizer = "soil-to-fertilizer map"
    case fertilizerToWater = "fertilizer-to-water map"
    case waterToLigth = "water-to-light map"
    case lightToTemperature = "light-to-temperature map"
    case temperatureToHumidity = "temperature-to-humidity map"
    case humididtyToLocation = "humidity-to-location map"
    case unknown
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
