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
            let soil = matchingComponent(component: seed, seedToSoil: entities.seedToSoil)
            let fertilizer = matchingComponent(component: soil, seedToSoil: entities.soilToFertilizer)
            let water = matchingComponent(component: fertilizer, seedToSoil: entities.fertilizierToWater)
            let light = matchingComponent(component: water, seedToSoil: entities.waterToLight)
            let temperature = matchingComponent(component: light, seedToSoil: entities.lightToTemperature)
            let humidity = matchingComponent(component: temperature, seedToSoil: entities.temperatureToHumidity)
            return matchingComponent(component: humidity, seedToSoil: entities.humidityToLocation)
        }
        return locations.min() ?? 0
    }

    func part2() -> Any {
        let seedsRanges = entities.seeds.chunked(into: entities.seeds.count / 2).map { chunk in
            return chunk[0]..<chunk[0] + chunk[1]
        }.reduce(into: []) { partialResult, nextRange in
            partialResult.append(contentsOf: nextRange)
        }
        print("Seeds are ready")

        let locations = seedsRanges.map { seed in
            let soil = matchingComponent(component: seed, seedToSoil: entities.seedToSoil)
            let fertilizer = matchingComponent(component: soil, seedToSoil: entities.soilToFertilizer)
            let water = matchingComponent(component: fertilizer, seedToSoil: entities.fertilizierToWater)
            let light = matchingComponent(component: water, seedToSoil: entities.waterToLight)
            let temperature = matchingComponent(component: light, seedToSoil: entities.lightToTemperature)
            let humidity = matchingComponent(component: temperature, seedToSoil: entities.temperatureToHumidity)
            return matchingComponent(component: humidity, seedToSoil: entities.humidityToLocation)
        }

        return locations.min() ?? 0
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

    func matchingComponent(component: Int, seedToSoil: [Range<Int>: Range<Int>]) -> Int {
        guard let source = seedToSoil.keys.first(where: { $0.contains(component) }),
                let destination = seedToSoil[source] else { return component }

        let offset = component - source.startIndex
        let destComponent = destination.startIndex + offset

        return destComponent
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
