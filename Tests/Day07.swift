import XCTest

@testable import AdventOfCode

final class Day07Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    5JA6J 1
    """

    let testData2 = """
    2345A 1
    Q2KJJ 13
    Q2Q2Q 19
    T3T3J 17
    T3Q33 11
    2345J 3
    J345A 2
    32T3K 5
    T55J5 29
    KK677 7
    KTJJT 34
    QQQJA 31
    JJJJJ 37
    JAAAA 43
    AAAAJ 59
    AAAAA 61
    2AAAA 23
    2JJJJ 53
    JJJJ2 41
    """

    func testPart1() throws {
        let challenge = Day07(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "6440")
    }

    func testPart2() throws {
        let challenge = Day07(data: testData2)
        XCTAssertEqual(String(describing: challenge.part2()), "6839")
    }
}
