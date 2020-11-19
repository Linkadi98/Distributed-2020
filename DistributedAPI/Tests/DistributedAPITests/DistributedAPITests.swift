import XCTest
@testable import DistributedAPI

final class DistributedAPITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(DistributedAPI().text, "Hello, World!")
        
        let expectation = XCTestExpectation(description: "API Calling")
        Repository.shared.getAllTasks(params: .init(id: 111111)) { (r) in
            switch r {
            case.success(let response):
                print(response.tasks?.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 10)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
