//
//  Strings+Extensions.swift
//  RSS Feeds
//
//  Copyright © 2019 Keval Patel. All rights reserved.

import Foundation
extension String{
    //MARK:- spaceAndLineTrimmer
    /**
     Remove Spaces and New Lines.
     
     - Parameter : string to be operated.
     
     - Returns: trimed String.
     */
    func spaceAndLineTrimmer() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    //MARK:- customString
    /**
    Custom function slice the string by index values and returns the same string for index out of bound scenarios
    - Parameter indexFrom indexTo: indexFrom and indexTo string to be sliced
    - Returns: sliced String or the same string if improper indexes.
    */
    func customString(_ indexFrom: Int, _ indexTo: Int) -> String{
        guard indexFrom <= self.count - 1 && indexTo <= self.count - 1 else{
            return self
        }
        let startPoint = self.index(self.startIndex, offsetBy: indexFrom)
        let endPoint = self.index(self.endIndex, offsetBy: -1 * (self.count - 1 - indexTo))
        let subString = self[ startPoint..<endPoint]
        return String(subString)
    }
}
