//
//  Fonts+Extensions.swift
//  RSS Feeds
//
//  Created by Keval Patel on 4/4/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import UIKit
enum fonts: String{
    case timesNewRoman = "Times New Roman"
}
/**
 UILabel extension for different font sizes.
 */
extension UILabel{
    func dateSizeFont(){
        self.font = UIFont(name: fonts.timesNewRoman.rawValue, size: 15)
    }
    func titleSizeFont(){
        self.font = UIFont(name: fonts.timesNewRoman.rawValue, size: 20)
    }
    func regularSizeFont(){
        self.font = UIFont(name: fonts.timesNewRoman.rawValue, size: 17)
    }
}
