import XCTest

@testable import AdventOfCode

final class Day03Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    func testPart1() throws {
        let challenge = Day03(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "4361")
    }

//    func testPart2() throws {
//    }
}
