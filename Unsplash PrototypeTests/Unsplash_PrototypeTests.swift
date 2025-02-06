

import XCTest
@testable import Unsplash_Prototype

// Test-case body
class UnsplashPrototypeUnitTests: XCTestCase {
    var systemUnderTest: MainViewController!
    var viewModel: MainViewModel!
    
    // Object initialization
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class
        try super.setUpWithError()
        systemUnderTest = MainViewController(viewModel: viewModel)
    }
    
    // Object realize
    override func tearDownWithError() throws { // Можно сделать override func tearDown() async throws {}
        // Put teardown code here. This method is called after the invocation of each test method in the class
        systemUnderTest = nil
        try super.tearDownWithError()
    }
    
    func testExample() throws {
        // An example of a functional test case
    }
    
    func testPerformanceExample() throws {
        // An example of a performance test case
        self.measure {
            let performanceArray = Array(0...10000)
            var counter = 0
            
            performanceArray.forEach {
                counter += $0
            }
        }
    }
}
