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
    func testConnectThePipesLowLevelEncoding() throws {
        guard let url = Bundle.module.url(forResource: "connectthepipes", withExtension: "hopscotch") else {
            XCTFail("No connect the pipes project json url")
            return
        }
        guard let originalData = try? Data(contentsOf: url) else {
            XCTFail("No connect the pipes project json")
            return
        }
        let decoder = JSONDecoder()
        let originalJson = try decoder.decode(JSONType.self, from: originalData)
        let project = try decoder.decode(LowLevelProject.self, from: originalData)
        XCTAssertNotNil(project)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let reencodedData = try encoder.encode(project)
        let reencodedJson = try decoder.decode(JSONType.self, from: reencodedData)
        XCTAssertEqual(originalJson, reencodedJson)
    }
    func testMooseIslandLowLevelEncoding() throws {
        guard let url = Bundle.module.url(forResource: "mooseisland", withExtension: "hopscotch") else {
            XCTFail("No mooseisland project json url")
            return
        }
        guard let originalData = try? Data(contentsOf: url) else {
            XCTFail("No mooseisland project json")
            return
        }
        let decoder = JSONDecoder()
        let originalJson = try decoder.decode(JSONType.self, from: originalData)
        let project = try decoder.decode(LowLevelProject.self, from: originalData)
        XCTAssertNotNil(project)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let reencodedData = try encoder.encode(project)
        let reencodedJson = try decoder.decode(JSONType.self, from: reencodedData)
        XCTAssertEqual(originalJson, reencodedJson)
    }
    func testConnectThePipesHighLevelDecoding() throws {
        guard let url = Bundle.module.url(forResource: "connectthepipes", withExtension: "hopscotch") else {
            XCTFail("No connectthepipes project json url")
            return
        }
        guard let projectData = try? Data(contentsOf: url) else {
            XCTFail("No connectthepipes project json")
            return
        }
        let _ = try Project(decoding: projectData)
    }
}
