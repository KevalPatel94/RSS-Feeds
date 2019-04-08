//
//  Global.swift
//  RSS Feeds
//
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import UIKit

enum globalConstants: String{
    case noInternetConnection = "No Internet Connection"
    case turnOnInternetconnectivity = "Please connect your device to internet"
    case cancelTitle = "Cancel"
    case turnOnTitle = "Turn On"
    case somethingWentWrong = "Something went wrong"
}
//MARK:- create Alert
/**
 Create alert to handle not connected to Internet Usecase.
 - Returns: A bool value which indicated internet connectivity.
 */
func createAlert(_ title: String, _ message: String) -> UIAlertController{
    let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: globalConstants.cancelTitle.rawValue, style: .cancel, handler: { (action) in
        // Action here
    }))
    alert.addAction(UIAlertAction(title: globalConstants.turnOnTitle.rawValue, style: .default, handler: { (action) in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            })
        }
    }))
    alert.view.accessibilityIdentifier = accessibilityIdentifier.noInternetConnectionaAlertView.rawValue
    return alert
}
//MARK:- create Alert
/**
 Create alert to handle different error types.
 Can be updated as per requirement and possible error handling mechanism.
 - Returns: A bool value which indicated internet connectivity.
 */
func createErrorAlert(_ title: String, _ message: String) -> UIAlertController{
    let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: globalConstants.cancelTitle.rawValue, style: .cancel, handler: { (action) in
        // Action here
    }))
    return alert
}
