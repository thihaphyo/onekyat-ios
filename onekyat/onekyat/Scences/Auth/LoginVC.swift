//
//  LoginVC.swift
//  onekyat
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import UIKit
import CommonUI
import CommonExtensions
import Utilities
import RxSwift
import RxSwiftExt
import RxCocoa

class LoginVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = "Auth"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivPhoneIcon: UIImageView!
    @IBOutlet weak var ivPhoneBorder: UIView!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var ivPasswordIcon: UIImageView!
    @IBOutlet weak var ivPasswordBorder: UIView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: Button!
    @IBOutlet weak var lblTerms: LabelHyperLink!
    @IBOutlet weak var ivChk: UIImageView!
    @IBOutlet weak var btnTerms: UIButton!
    
    let vm = LoginVM.init()
    lazy var bag = DisposeBag()
    let isTermsChecked = BehaviorRelay<Bool>.init(value: false)
    var termsChecked = false {
        didSet {
            ivChk.image = termsChecked ? .load(named: "checkbox.on") : .load(named: "checkbox.off")
            isTermsChecked.accept(termsChecked)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }
    
    func setupViews() {
        
        lblTitle.font = Styles.nBE26()
        [tfPhone, tfPassword].forEach {
            $0?.font = Styles.n14()
        }
        
        ivPhoneIcon.image = .load(named: "login.phone")
        ivPasswordIcon.image = .load(named: "login.password")
        
        ivChk.image = .load(named: "checkbox.off")
        
        lblTerms.font = Styles.n12()
        
        tfPhone.becomeFirstResponder()
        
        btnLogin.isEnabled = false
        
        lblTerms.isUserInteractionEnabled = true
        lblTerms.setHyperLink(fullText: "Agree to our Terms & Conditions",
                              hyperLinkText: ["Terms & Conditions"],
                              urlString: ["https://www.onekyat.com"],
                              textColor: .black,
                              hyperLinkColor: .blue,
                              textFont:  Styles.n12(),
                              linkFont:  Styles.n12(),
                              underLineForLink: false,
                              textAlign: .left,
                              delegate: self)
        
        
    }
    
    func setupBindings() {
        
        btnTerms.rx.tap
            .mapToVoid()
            .bind {[unowned self] in
                termsChecked.toggle()
            }
            .disposed(by: bag)
        
        let phone = tfPhone.rx.text.orEmpty
            .map(digitsOnly)
            .do(onNext: setPreservingCursor(on: tfPhone))
        
        let form = Observable
            .combineLatest(phone, tfPassword.rx.text.orEmpty, isTermsChecked.asObservable())
                .skip(2)
                .map(LoginVM.FormInput.init)
                
                
        let input = LoginVM.Input.init(formInput: form, didTapLogin: btnLogin.rx.tap.mapToVoid())
                
        let output = vm.transform(input)
                
            output.enableButton
                .drive(btnLogin.rx.isEnabled)
                .disposed(by: bag)
                
            output.formErrors
                .drive(onNext: {
                    self.resetError()
                    $0.invalid?.forEach { (k,v) in
                        self.showErrorTextField(k)
                    }
                })
                .disposed(by: bag)
                
            output.didLoggedIn
                .drive(rx.loggedInState)
                .disposed(by: bag)
                
    }
    
    func showErrorTextField(_ type: LoginVM.FormType) {
        
        switch type {
            case .phone:
                ivPhoneBorder.backgroundColor = .red
                break
            case .password:
                ivPasswordBorder.backgroundColor = .red
                break
            default:
                break
        }
        
    }
    
    func resetError() {
        ivPhoneBorder.backgroundColor = .lightGray
        ivPasswordBorder.backgroundColor = .lightGray
    }
    
    func resetText(_ view: UIView) {
        view.backgroundColor = .lightGray
    }
    
    func goToHome() {
        
    }
    
    func digitsOnly(_ text: String) -> String {
        return text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    func setPreservingCursor(on textField: UITextField) -> (_ newText: String) -> Void {
        return { newText in
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: textField.selectedTextRange!.start) + newText.count - (textField.text?.count ?? 0)
            textField.text = newText
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
}

extension LoginVC: LabelHyperLinkProtocol {
    
    func  labelHyperLink(onTappedUrlInLabel: String) {
        self.openURL(onTappedUrlInLabel)
    }
}

extension Reactive where Base: LoginVC {
    
    var loggedInState: Binder<Bool> {
        return Binder(base) { vc, isSuccess in
            if isSuccess {
                vc.goToHome()
            } else {
                vc.showAlert(message: "Phone number or Password Invalid!")
            }
        }
    }
}
