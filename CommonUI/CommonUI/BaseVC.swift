//
//  BaseVC.swift
//  CommonUI
//
//  Created by Codigo Phyo Thiha on 2/5/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt
import RxRelay

open class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    
    lazy var bag = DisposeBag()
    
    open var isPopEnabled: Bool = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = isPopEnabled
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return isPopEnabled
    }
    
}

//extension Reactive where Base: BaseVC {
//
//   public var showLoading: Binder<Bool> {
//        return Binder(base) { vc, isLoading in
//            if isLoading {
//                LoadingView.shared.show()
//            } else {
//                LoadingView.shared.hide()
//            }
//        }
//    }
//}
