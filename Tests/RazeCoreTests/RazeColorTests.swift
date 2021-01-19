import XCTest
@testable import RazeCore

final class RazeColorTests: XCTestCase {

    func testColorRedEqual(){
        let color = RazeCore.Color.fromHexString("FF0000")
        XCTAssertEqual(color, .red)
    }
    func testRazeColorAreEqual(){
        let color = RazeCore.Color.fromHexString("006736")
        XCTAssertEqual(color, RazeCore.Color.razeColor)
    }
    func testRazeSecondaryXolorsAreEqual() {
        let color = RazeCore.Color.fromHexString("FCFFD")
        XCTAssertEqual(color, RazeCore.Color.secondaryRazeColor)
    }
    static var allTests = [
        ("testColorRedEqual", testColorRedEqual),
        ("testRazeColorAreEqual", testRazeColorAreEqual),
        ("testRazeSecondaryXolorsAreEqual", testRazeSecondaryXolorsAreEqual)
    ]
}
