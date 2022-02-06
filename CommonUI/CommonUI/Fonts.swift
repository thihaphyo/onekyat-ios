//
//  Fonts.swift
//  CommonUI
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation
import UIKit
import Utilities

public enum Font: String, CaseIterable {
    
    case nunitoBlack = "Nunito-Black"
    case nutinoBlackItalic = "Nunito-BlackItalic"
    case nutinoBold = "Nunito-Bold"
    case nutinoBoldItalic = "Nunito-BoldItalic"
    case nutinoExtraBold = "Nunito-ExtraBold"
    case nutinoExtraBoldItalic = "Nunito-ExtraBoldItalic"
    case nutinoExtraLight = "Nunito-ExtraLight"
    case nutinoExtraLightItalic = "Nunito-ExtraLightItalic"
    case nutinoItalic = "Nunito-Italic"
    case nutinoLight = "Nunito-Light"
    case nutinoLightItalic = "Nunito-LightItalic"
    case nutinoRegular = "Nunito-Regular"
    case nutinoSemiBold = "Nunito-SemiBold"
    case nutinoSemiBoldItalic = "Nunito-SemiBoldItalic"

    //static var installed = false
}

public extension Font {
    func size(_ size : CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size:  size)!
    }
    
    static func load() {
        let fonts = Bundle(for: CommonUIBundle.self)
            .urls(forResourcesWithExtension: "ttf", subdirectory: nil) ?? []
        let ptSan = Bundle(for: CommonUIBundle.self)
            .urls(forResourcesWithExtension: "ttc", subdirectory: nil) ?? []
        [fonts, ptSan].flatMap(id).forEach({ url in
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        })
    }
}
/*
public extension Font {
    static func install(from bundles: [Bundle] = Bundle.allBundles) {
        Font.installed = true
        for each in Font.allCases {
            for bundle in bundles {
                if let cfURL = bundle.url(forResource:each.rawValue, withExtension: "ttf") {
                    CTFontManagerRegisterFontsForURL(cfURL as CFURL, .process, nil)
                } else {
                    assertionFailure("Could not find font:\(each.rawValue) in bundle:\(bundle)")
                }
            }
        }
    }
}
 */

