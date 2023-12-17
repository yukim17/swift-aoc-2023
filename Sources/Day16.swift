//
//  Day16.swift
//  
//
//  Created by Ekaterina Grishina on 16/12/23.
//

import Foundation

struct Day16: AdventDay {
    var data: String

    private var entities: [Point: Character] {
        let lines = data.split(whereSeparator: \.isNewline).map(String.init)
        let points = lines.enumerated().flatMap { (y, line) in
            line.enumerated().map { (x, char) in
                (Point(x: x, y: y), char)
            }
        }
        return Dictionary(uniqueKeysWithValues: points)
    }

    func part1() -> Any {
        let start = Beam(position: Point(x: -1, y: 0), direction: Direction.right)
        return calculateEnergized(startingAt: start)
    }

    func part2() -> Any {
        var energizedTiles: [Int] = []
        let entities = self.entities
        let maxPoint = entities.keys.max(by: { $1.x > $0.x && $1.y > $0.y })
        let maxX = maxPoint?.x ?? 0
        let maxY = maxPoint?.y ?? 0

        for x in 0..<maxX {
            let beamTop = Beam(position: Point(x: x, y: -1), direction: .bottom)
            let beamBottom = Beam(position: Point(x: x, y: maxY), direction: .top)

            energizedTiles.append(contentsOf: [calculateEnergized(startingAt: beamTop), calculateEnergized(startingAt: beamBottom)])
        }

        for y in 0..<maxY {
            let beamLeft = Beam(position: Point(x: -1, y: y), direction: .right)
            let beamRight = Beam(position: Point(x: maxX, y: y), direction: .left)

            energizedTiles.append(contentsOf: [calculateEnergized(startingAt: beamLeft), calculateEnergized(startingAt: beamRight)])
        }

        return energizedTiles.max() ?? 0
    }

    func calculateEnergized(startingAt beam: Beam) -> Int {
        let entities = self.entities
        var visited = Set<Beam>()
        var queue = [beam]
        while !queue.isEmpty {
            var beam = queue.remove(at: 0)

            while true {
                let movedPos = beam.position.moved(to: beam.direction)
                if entities[movedPos] == nil {
                    break
                }

                beam.position = movedPos
                switch entities[movedPos] {
                case ".": break

                case "\\":
                    switch beam.direction {
                    case .right: beam.direction = .bottom
                    case .left: beam.direction = .top
                    case .top: beam.direction = .left
                    case .bottom: beam.direction = .right
                    }

                case "/":
                    switch beam.direction {
                    case .right: beam.direction = .top
                    case .left: beam.direction = .bottom
                    case .top: beam.direction = .right
                    case .bottom: beam.direction = .left
                    }

                case "|":
                    switch beam.direction {
                    case .left, .right: beam.direction = .top; queue.append(beam.splitted(to: .bottom))
                    case .top, .bottom: break
                    }


                case "-":
                    switch beam.direction {
                    case .top, .bottom: beam.direction = .left; queue.append(beam.splitted(to: .right))
                    case .left, .right: break
                    }
                default: break
                }

                let (inserted, _) = visited.insert(beam)
                if !inserted {
                    break
                }
            }
        }
        return Set(visited.map({ $0.position })).count
    }
}

enum Direction: Hashable {
    case right, left, top, bottom
}

struct Point: Hashable {
    let x: Int
    let y: Int

    func moved(to dir: Direction) -> Point {
        switch dir {
        case .right:
            return Point(x: x + 1, y: y)
        case .left:
            return Point(x: x - 1, y: y)
        case .top:
            return Point(x: x, y: y - 1)
        case .bottom:
            return Point(x: x, y: y + 1)
        }
    }
}

struct Beam: Hashable {
    var position: Point
    var direction: Direction

    func splitted(to newDirection: Direction) -> Beam {
        Beam(position: position, direction: newDirection)
    }
}
