import XCTest

import DistributedAPITests

var tests = [XCTestCaseEntry]()
tests += DistributedAPITests.allTests()
XCTMain(tests)
