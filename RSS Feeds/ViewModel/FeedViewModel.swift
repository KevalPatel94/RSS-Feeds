//
//  FeedViewModel.swift
//  RSS Feeds
//
//  Copyright © 2019 Keval Patel. All rights reserved.

import Foundation
struct FeedViewModel {
    let title : String
    let link : String
    let pubDate : String
    init(_ feedModel: FeedModel) {
        self.title = feedModel.title
        self.link = feedModel.link
        self.pubDate = feedModel.pubDate
    }
    
    /**
     Creates a formatted Date.
     
     - Parameter dateInString: The Date String From Api Response entitled as pubaDate.
     
     - Returns: A New String in the formate.
     */
    func getformattedDate(_ dateInString: String) -> String{
       return dateInString.customString(5, 15)
    }
}
