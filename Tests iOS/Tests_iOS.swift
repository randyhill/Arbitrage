//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Randy Hill on 4/7/21.
//

import XCTest

class Tests_iOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPurchases() {
        let twoYearsAway = Date().add(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 2)
        let oneYearAway = Date().add(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 1)
        
        let zeroReturns = Position(best: 20, worst: 10, latestPrice: 15, bid: 14, ask: 15, soonest: Date(), latest: twoYearsAway, bestPercentage: 0.5)
        XCTAssertEqual(zeroReturns.purchaseReturn, 0.0)
        XCTAssertEqual(zeroReturns.annualizedPurchaseReturn, 0.0)
        
        let doubleReturn = Position(best: 30, worst: 10, latestPrice: 16, bid: 10, ask: 10, soonest: oneYearAway, latest: oneYearAway, bestPercentage: 0.5)
        XCTAssertEqual(doubleReturn.purchaseReturn, 1.0)
        XCTAssertEqual(doubleReturn.annualizedPurchaseReturn, 1.0)
        
        let negativeReturn = Position(best: 20, worst: 10, latestPrice: 30, bid: 30, ask: 30, soonest: oneYearAway, latest: oneYearAway, bestPercentage: 0.5)
        XCTAssertEqual(negativeReturn.purchaseReturn, -0.5)
        XCTAssertEqual(negativeReturn.annualizedPurchaseReturn, -0.5)
    }
    
    func testSales() {
        let twoYearsAway = Date().add(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 2)
        let oneYearAway = Date().add(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 1)
        
        let zeroReturns = Position(best: 20, worst: 10, latestPrice: 15, bid: 15, ask: 16, soonest: Date(), latest: twoYearsAway, bestPercentage: 0.5)
        XCTAssertEqual(zeroReturns.saleReturn, 0.0)
        XCTAssertEqual(zeroReturns.annualizedSaleReturn, 0.0)
        
        let doubleReturn = Position(best: 30, worst: 10, latestPrice: 11, bid: 10, ask: 11, soonest: oneYearAway, latest: oneYearAway, bestPercentage: 0.5)
        XCTAssertEqual(doubleReturn.saleReturn, 1.0)
        XCTAssertEqual(doubleReturn.annualizedSaleReturn, 1.0)
        
        let negativeReturn = Position(best: 20, worst: 10, latestPrice: 32, bid: 30, ask: 32, soonest: oneYearAway, latest: oneYearAway, bestPercentage: 0.5)
        XCTAssertEqual(negativeReturn.saleReturn, -0.5)
        XCTAssertEqual(negativeReturn.annualizedSaleReturn, -0.5)
    }

//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
