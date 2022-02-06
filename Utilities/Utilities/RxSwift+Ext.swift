//
//  RxSwift+Ext.swift
//  Utilities
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation
import RxSwift
import RxCocoa

public extension ObservableType where Element == Bool {
    func not() -> Observable<Bool> {
        return self.map(!)
    }
}

public extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

public extension ObservableType {
    
    static func void() -> Observable<Void> {
        .just(())
    }
    
    func catchErrorJustComplete() -> Observable<Element> {
        self.catch { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { error in
            return Driver.empty()
        }
    }
    
    func asDriverOnErrorNever() -> Driver<Element> {
        asDriver { error in
            return .never()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        map { _ in }
    }
}

public extension Observable {
    func withLatestFrom<T, U, R>(_ other1: Observable<T>, _ other2: Observable<U>, selector: @escaping (Element, T, U) -> R) -> Observable<R> {
        return self.withLatestFrom(Observable<Any>.combineLatest(
            other1,
            other2
        )) { x, y in selector(x, y.0, y.1) }
    }
}


