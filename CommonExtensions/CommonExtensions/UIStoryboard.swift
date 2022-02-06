//
//  UIStoryboard.swift
//  CommonExtensions
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation
import UIKit

public protocol Storyboarded {
    static var storyboardName: String { get set }
    static func instantiate(from bundle: Bundle) -> Self
}

extension Storyboarded where Self: UIViewController {
    public static func instantiate(from bundle: Bundle = Bundle.main) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: Self.className) as! Self
    }
}
