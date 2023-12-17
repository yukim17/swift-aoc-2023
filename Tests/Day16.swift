import XCTest

@testable import AdventOfCode

final class Day16Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = #"""
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
    """#

    func testPart1() throws {
        let challenge = Day16(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "46")
    }

    func testPart2() throws {
        let challenge = Day16(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "51")
    }
}
