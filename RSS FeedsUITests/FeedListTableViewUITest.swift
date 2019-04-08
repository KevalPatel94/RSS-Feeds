//
//  FeedListTableViewUITest.swift
//  RSS FeedsUITests
//
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import XCTest

class FeedListTableViewUITest: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()    }

    override func tearDown() {
        super.tearDown()
    }

    func testFeedListTableView(){
        let app = XCUIApplication()
        let tblSummary = app.tables[accessibilityIdentifier.tblSummary.rawValue]
        let tableCell = tblSummary.cells.element(boundBy: 0)
        tableCell.tap()
        let activity = app.activityIndicators[accessibilityIdentifier.activityIndicator.rawValue]
        let tblFeedList = app.tables[accessibilityIdentifier.tblFeedList.rawValue]
        if activity.exists == true{
            XCTAssertTrue(activity.exists, "Activity Indicator Exists")
        }
        else if tblFeedList.exists == true{
            XCTAssertTrue(tblFeedList.exists, "Feed TableView Exist")
            let feedCells = tblFeedList.cells
            guard feedCells.count >= 1 else {
                XCTAssert(false, "Not able to find summaryTableView")
                return
            }
            guard feedCells.element(boundBy: 0).exists == true else{return}
            feedCells.element(boundBy: 0).tap()
        }
    }

    func testPerformanceExample(){
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
