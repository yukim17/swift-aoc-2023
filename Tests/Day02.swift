import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day02Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """

    func testPart1() throws {
        let challenge = Day02(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "8")
    }

    func testValidGameSet() {
        let challenge = Day02(data: testData)
        let gameSet = challenge.entities[0]
        XCTAssertTrue(challenge.isGameSetValid(for: gameSet, with: .red, reference: 12))
    }

    func testMinColorComponent() {
        let challenge = Day02(data: testData)
        let gameSet = challenge.entities[0]
        let result  = challenge.minColorComponent(for: gameSet, of: .red)
        XCTAssertEqual(result, 4)
    }

    func testPart2() throws {
        let challenge = Day02(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "2286")
    }
}
