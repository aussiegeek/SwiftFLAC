import SwiftFLAC
import XCTest

class SwiftFLACTests: XCTestCase {
    func findSample(type: String, name: String) throws -> String {
        let testPath = #file
        var parts = testPath.split(separator: "/")
        print(parts)
//        parts[parts.count - 1] = name + "." + type
//        let path = parts[0 ..< parts.count - 1]
        // print(path)
        print("updated path")
        parts = Array(parts[0 ..< parts.count - 2])
        parts.append("Samples")
        parts.append(name + "." + type)
        // parts = parts + ["Samples", name + "." + type]
        print(parts)
        let fullFileName = "/" + parts.joined(separator: "/")
        print(fullFileName)
        return fullFileName
    }

    func testLoadFLACMetadata() throws {
        let samplePath = try findSample(type: "flac", name: "bitter_words")

        let parser = try SwiftFLAC(filename: samplePath)

        let metadata = parser.metadata
        XCTAssertEqual(metadata["ARTIST"], "Area-7")
    }

    func testFileNotFoundError() {
        XCTAssertThrowsError(try SwiftFLAC(filename: "/ireallydontexist"), "nope") { error in
            XCTAssertEqual(error as? SwiftFLAC.Errors, SwiftFLAC.Errors.errorOpeningFile)
        }
    }

    func testNotAFlacFile() throws {
        let textFilePath = try findSample(type: "txt", name: "bitter_words")
        XCTAssertThrowsError(try SwiftFLAC(filename: textFilePath)) { error in
            XCTAssertEqual(error as? SwiftFLAC.Errors, SwiftFLAC.Errors.notAFlacFile)
        }
    }
}
