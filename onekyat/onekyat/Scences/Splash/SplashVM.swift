//
//  SplashVM.swift
//  onekyat
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import Utilities

class SplashVM {
    
    let timer = 2
    
    struct Input {
        let viewDidAppear: Observable<Void>
    }
    
    struct Output {
        let logInState: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        let timerStartEvent = input.viewDidAppear
            .flatMapLatest { [unowned self] in
                Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
                        .take(timer+1)
            }.share()
            .debug()
        
       let timerEndEvent = timerStartEvent.ignoreWhen { [unowned self] in
            ( timer - $0 ) != 0
       }
        .mapToVoid()
        .share()
        
       let loginState = timerEndEvent.withLatestFrom(Observable.just(
            Current.keychain.getLoginState() ?? false
       ))
       .share()
        
        return .init(logInState: loginState.asDriverOnErrorNever())
    }
}
