//
//  Optional.swift
//  CommonExtensions
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//
import Foundation

public extension Optional {
    
    // apply a void function if the value present
    
    func then(_ f: (Wrapped) -> Void) {
        switch self {
        case .some(let value):
            f(value)
        case .none:
            return
        }
    }
    
    static func pure(_ x: Wrapped) -> Optional {
        .some(x)
    }
    
    func apply<B>(_ f: Optional<(Wrapped) -> B>) -> Optional<B> {
        switch (f, self) {
        case let (.some(fx), _):
            return self.map(fx)
        default:
            return .none
        }
    }
    
    func orElse(_ x: Wrapped) -> Wrapped {
        switch self {
        case .none: return x
        case .some(let v): return v
        }
    }
    
    static func zip<A, B>(_ x: A?, _ y: B?) -> (A, B)? {
        switch (x, y) {
        case (.some(let x), .some(let y)):
            return .some((x, y))
        default:
            return nil
            
        }
    }
}

public extension Optional where Wrapped == String {
    
    var orEmpty: String {
        switch self {
        case .none: return ""
        case .some(let v): return v
        }
    }
    
    var nilIfEmpty: String? {
        self.flatMap { $0.isEmpty ? nil : $0 }
    }

}

public extension Optional where Wrapped == Double {
    
    var orEmpty: Double {
        switch self {
        case .none: return 0
        case .some(let v): return v
        }
    }
}

public extension Optional {
    var isNil: Bool {
        return self == nil
    }
    
    var isNotNil: Bool {
        return self != nil
    }
}
