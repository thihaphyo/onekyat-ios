//
//  LoginVM.swift
//  onekyat
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation
import CommonExtensions
import Utilities
import RxSwift
import RxCocoa
import RxSwiftExt
import Data

class LoginVM {
    
    typealias ValidationError = [FormType: String]
    let required = "Required"
    
    struct Input {
        let formInput: Observable<FormInput>
        let didTapLogin: Observable<Void>
    }
    
    struct Output {
        let formErrors: Driver<Validation<LoginVM.FormInput, LoginVM.ValidationError>>
        let enableButton: Driver<Bool>
        let didLoggedIn: Driver<Bool>
    }
    
    struct FormInput {
        let phone: String
        let password: String
        let isTermAccepted: Bool
    }
    
    enum FormType {
        case phone, password, isTermAccepted
    }
    
    func transform(_ input: Input) -> Output {
        
        let validateRequiredField = input.formInput
            .map(validateRequired)
            .share()
        
        let loginReq = input.formInput
            .map(mapToRequest)
            .compactMap { $0.valid}
            .share()
        
        let enableButton = validateRequiredField
            .map { $0.isSuccess }
        
        let formInvalid = validateRequiredField
            .compactMap { $0 }
        
        let didLogIn = input.didTapLogin
            .withLatestFrom(loginReq)
            .flatMapLatest {[unowned self] in
                checkPhoneAndPassword($0)
            }
            .share()
        
        return .init(formErrors: formInvalid.asDriverOnErrorNever(),
                     enableButton: enableButton.asDriverOnErrorNever(),
                     didLoggedIn: didLogIn.asDriverOnErrorNever())
        
    }
    
    func checkPhoneAndPassword(_ req: LoginReq) -> Observable<Bool> {
        
        if req.phone == "09420000001" && req.password == "password_123$#" {
            Current.keychain.saveLoginState()
            return Observable.just(true)
        }
        return Observable.just(false)
    }
    
    func mapToRequest(_ form: FormInput) -> Validation<LoginReq, ValidationError> {
    
        let phoneVali = validatePhoneNumber(message: required)(form.phone)
            .mapError { [FormType.phone: $0] }
        
        let passwordVali = validateNonEmpty(message: required)(form.password)
            .mapError { [FormType.password : $0 ]}
        
        let loginReq = curry(LoginReq.init)
        
        let login = .pure(loginReq)
            <*> phoneVali
            <*> passwordVali
        
        return login
    }
    
    func validateRequired(_ form: FormInput) -> Validation<FormInput, ValidationError> {
        
        let phoneVali = validatePhoneNumber(message: required)(form.phone)
            .mapError { [FormType.phone: $0] }
        
        let passwordVali = validateNonEmpty(message: required)(form.password)
            .mapError { [FormType.password : $0 ]}

        let termsVali = validateNonEmpty(message: required)(form.isTermAccepted)
            .mapError { [FormType.isTermAccepted : $0 ]}

        let formInit = curry(FormInput.init)
        let formVali = .pure(formInit)
            <*> phoneVali
            <*> passwordVali
            <*> termsVali
    
        return formVali
    }
}
