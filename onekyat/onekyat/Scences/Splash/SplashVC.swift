//
//  SplashVC.swift
//  onekyat
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import UIKit
import CommonUI
import RxSwift
import RxSwiftExt
import RxCocoa
import Utilities
import CommonExtensions

class SplashVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = "Main"
    
    let vm = SplashVM.init()
    @IBOutlet weak var ivLogo: UIImageView!
    
    lazy var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()

    }
    
    func setupViews() {
        ivLogo.image = .load(named: "splash.logo")
    }
    
    func setupBindings() {
        
        let input = SplashVM.Input.init(viewDidAppear: rx.viewDidAppear.take(1).mapToVoid())
        
        let output = vm.transform(input)
        
        output.logInState
            .drive(rx.loggedInState)
            .disposed(by: bag)

    }

    func goToHome() {
        
       
    }
    
    func goToLogin() {
        let vc = LoginVC.instantiate()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }

}

extension Reactive where Base: SplashVC {
    
    var loggedInState: Binder<Bool> {
        return Binder(base) { vc, isLoggedIn in
            if isLoggedIn {
                vc.goToHome()
            } else {
                vc.goToLogin()
            }
        }
    }
    

}
