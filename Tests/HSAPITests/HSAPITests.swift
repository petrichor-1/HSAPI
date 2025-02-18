import XCTest
@testable import HSAPI

final class HSAPITests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        let bundle = Bundle(for: type(of: self))
        guard let url = Bundle.module.url(forResource: "connectthepipes", withExtension: "hopscotch") else {
            XCTFail("No connect the pipes project json url")
            return
        }
        guard let ctpData = try? Data(contentsOf: url) else {
            XCTFail("No connect the pipes project json")
            return
        }
        let decoder = JSONDecoder()
        let project = try decoder.decode(LowLevelProject.self, from: ctpData)
        XCTAssertNotNil(project)
    }
}
