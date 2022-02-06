//
//  AppDelegate.swift
//  onekyat
//
//  Created by Codigo Phyo Thiha on 2/4/22.
//

import UIKit
import CommonUI
import IQKeyboardManagerSwift

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Font.load()
        configureKeyboard()
        return true
    }


    func configureKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}

