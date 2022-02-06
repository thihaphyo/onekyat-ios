//
//  TabbarVC.swift
//  onekyat
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import UIKit
import CommonUI
import Device
import Data

class TabbarVC: UITabBarController {
    
//    public var homeVC = HomeVC.instantiate()
//    public var accountVC = AccountVC.instantiate()
//    public var findVC = FindVC.instantiate()
//    public var appointmentVC = AppointmentVC.instantiate()
//    public var shopVC = ShopHomeVC.instantiate()
    
    static var hasNotch: Bool {
        switch Device.size() {
        case .screen5_5Inch, .screen4_7Inch: return false
        default: return true
            
        }
    }
    
    class CustomHeightTB: UITabBar {
                
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            if hasNotch {
                sizeThatFits.height = 90
            } else {
                sizeThatFits.height = 60
            }
            return sizeThatFits
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, CustomHeightTB.self)
        UITabBar.appearance().tintColor = nil
        setCustomFont()

        tabBar.shadowImage = .init()
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.14
        setStyle()
        
    }
    
    func setStyle() {
        tabBar.backgroundColor = .white
        UITabBar.appearance().barTintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self, name: Notification.Name("showfeedback"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setCustomFont()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appWillEnterForeground() {
        //DeeplinkManager.shared.checkAndRoute()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //DeeplinkManager.shared.checkAndRoute()
    }
    
    func setupViews() {
        //delegate = self
        hidesBottomBarWhenPushed = true
        viewControllers = [
//            homeVC.wrapInsideNav(),
//            findVC.wrapInsideNav(),
//            appointmentVC.wrapInsideNav(),
//            shopVC.wrapInsideNav(),
//            accountVC.wrapInsideNav()
        ]
    }
    
    func setCustomFont() {
//        let normalAttribute = [NSAttributedString.Key.font: Styles.asAPSB10(),
//         NSAttributedString.Key.foregroundColor: UIColor.white]
//
//        let selectedAttribute = [NSAttributedString.Key.font: Styles.asAPSB10(),
//         NSAttributedString.Key.foregroundColor: UIColor.white]
//        tabBar.items?.forEach {
//            $0.setTitleTextAttributes(normalAttribute, for: .normal)
//            $0.setTitleTextAttributes(selectedAttribute
//                                      , for: .selected)
//
//            if TabbarVC.hasNotch {
//                $0.titlePositionAdjustment = .init()
//                $0.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
//                $0.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
//            } else {
//                $0.titlePositionAdjustment = .init(horizontal: 0, vertical: -5)
//            }
//
//        }
    }
    

}

func showFeeback() {
    NotificationCenter.default.post(name: Notification.Name("showfeedback"), object: nil)
}

extension UIViewController {
    @discardableResult
    func wrapInsideNav() -> UINavigationController {
        let nav = UINavigationController(rootViewController: self)
        nav.isNavigationBarHidden = false
        return nav
    }
}
