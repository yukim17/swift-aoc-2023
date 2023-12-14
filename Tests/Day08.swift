import XCTest

@testable import AdventOfCode

final class Day08Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """

    let testData2 = """
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """

    func testPart1() throws {
        let challenge = Day08(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "6")
    }

    func testPart2() throws {
        let challenge = Day08(data: testData2)
        XCTAssertEqual(String(describing: challenge.part2()), "6")
    }
}
