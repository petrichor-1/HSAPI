import XCTest
@testable import HSAPI

final class HSAPITests: XCTestCase {
    func testConnectThePipesLowLevelDecoding() throws {
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
    func testMooseIslandLowLevelDecoding() throws {
        guard let url = Bundle.module.url(forResource: "mooseisland", withExtension: "hopscotch") else {
            XCTFail("No mooseisland project json url")
            return
        }
        guard let ctpData = try? Data(contentsOf: url) else {
            XCTFail("No mooseisland project json")
            return
        }
        let decoder = JSONDecoder()
        let project = try decoder.decode(LowLevelProject.self, from: ctpData)
        XCTAssertNotNil(project)
    }
}
