import XCTest
@testable import RazeCore

final class RazeCoreTests: XCTestCase {
    
    func testColorRedEqual() {
        let color = RazeCore.colorFromHexString("FF0000")
    }
    
    static var allTests = [
        ("testColorRedEqual", testColorRedEqual),
    ]
}
