//
//  FeedSummaryTableViewUITest.swift
//  RSS FeedsUITests
//
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import XCTest

class FeedSummaryTableViewUITest: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    /**
     Test all the categories of tableview *tblSummary* from **FeedSummaryVC**
     */
    func testTableInteraction() {
        let app = XCUIApplication()
        let tblSummary = app.tables[accessibilityIdentifier.tblSummary.rawValue]
        XCTAssertTrue(tblSummary.exists, "Summary TableView Exists")
        let tableCells = tblSummary.cells
        guard tableCells.count >= 1 else {
            XCTAssert(false, "Not able to find summaryTableView")
            return
        }
        
        let count : Int = tableCells.count - 1
        let promise = expectation(description: "Wait for table cells")
        for i in stride(from: 0, to: count, by: 1){
            let tableCell = tableCells.element(boundBy: i)
            XCTAssertTrue(tableCell.exists, "The \(i) cell is in place on the table")
            tableCell.tap()
            if i == (count - 1){
                promise.fulfill()
            }
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        waitForExpectations(timeout: 20, handler: nil)
        
        XCTAssertTrue(true, "Finished validating the table cells")
    }
    
    //Turn Of the Internet connectivity and run this test case to check the alertview behaviour
    /**
     Test usecase for Internet Connectivity not available
     */
    func testInternetConnectionUnavailable(){
        let app = XCUIApplication()
        let tblSummary = app.tables[accessibilityIdentifier.tblSummary.rawValue]
        XCTAssertTrue(tblSummary.exists, "Summary tableView exists")
        let tableCell = tblSummary.cells.element(boundBy: 0)
        tableCell.tap()
        let alertNointernetconnectionavailableAlert = XCUIApplication().alerts[accessibilityIdentifier.noInternetConnectionaAlertView.rawValue]
        alertNointernetconnectionavailableAlert.staticTexts[globalConstants.turnOnInternetconnectivity.rawValue].tap()
        alertNointernetconnectionavailableAlert.buttons[globalConstants.turnOnTitle.rawValue].tap()
    }

}
