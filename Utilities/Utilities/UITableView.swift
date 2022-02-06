//
//  UITableView.swift
//  Utilities
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation
import UIKit

public extension UITableView {
    
    func deque<cell: UITableViewCell>(_ cell: cell.Type) -> cell {
        return dequeueReusableCell(withIdentifier: cell.className) as! cell
    }
    
    func dequeHeaderFooter<T: UITableViewHeaderFooterView>(_ cell: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.className) as! T
    }
    
    func register<cell: UITableViewCell>(_ cell: cell.Type) {
        register(cell, forCellReuseIdentifier: cell.className)
    }
    
    func register(nib nibName: String, bundle: Bundle? = nil) {
        self.register(UINib(nibName: nibName , bundle: bundle), forCellReuseIdentifier: nibName)
    }
    
    func registerHeaderFooter(nib nibName: String, bundle: Bundle? = nil) {
        register(UINib(nibName: nibName , bundle: bundle), forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ headerFooterView: T.Type) {
        register(headerFooterView.self, forHeaderFooterViewReuseIdentifier: headerFooterView.className)
    }
    
    func register(nibs nibNames: [String], bundle: Bundle? = nil) {
        nibNames.forEach {
            self.register(UINib(nibName: $0 , bundle: bundle), forCellReuseIdentifier: $0)
        }
    }
    
    func register(nibs nibNames: [UITableViewCell], bundle: Bundle? = nil) {
        nibNames.forEach {
            self.register(UINib(nibName: $0.className , bundle: bundle), forCellReuseIdentifier: $0.className)
        }
    }
    
    func layoutHeaderView() {
        
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerWidth = headerView.bounds.size.width;
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["headerView": headerView])
        
        headerView.addConstraints(temporaryWidthConstraints)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        
        frame.size.height = height
        headerView.frame = frame
        
        self.tableHeaderView = headerView
        
        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
//    func reloadData(animation: Bool, completion: (() -> Void)? = nil) {
//        if animation {
//            self.reloadData()
//            UIView.animate(views: self.visibleCells, animations: [AnimationType.from(direction: .bottom, offset: UIScreen.main.bounds.width / 2)], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, animationInterval: AniDuration.interval.double(), duration: AniDuration.duration.double(), usingSpringWithDamping: AniDuration.springWithDamping.float(), initialSpringVelocity: AniDuration.springVelocity.float(), options: [.curveEaseInOut], completion: {
//                completion?()
//            })
//        } else {
//            self.reloadData()
//            completion?()
//        }
//    }
    
}
