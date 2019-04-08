//
//  RSS_FeedsTests.swift
//  RSS_FeedsTests
//
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import XCTest
import Foundation
@testable import RSS_Feeds
class RSS_FeedsTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    /**
        Test the function *getformattedDate* of **FeedViewModel**
    */
    func testDateFormate(){
        let feedModel = FeedModel(title: "Why Hondurans Flee for the U.S.", link: "https://www.wsj.com/articles/why-hondurans-flee-for-the-u-s-11554661716", pubDate: "Sun, 07 Apr 2019 14:28:00 -0400")
        let feedViewModel = FeedViewModel(feedModel)
        XCTAssertEqual(feedViewModel.getformattedDate(feedViewModel.pubDate), "07 Apr 2019")
    }

    func testPerformanceExample() {
        self.measure {
        }
    }

}
