//
//  Validations.swift
//  Utilities
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation

infix operator <>
public protocol Semigroup {
    static func <>(_ left: Self, right: Self) -> Self
}

public enum Validation<A, E> {
    
    case valid(A)
    case invalid(E)
    
    public func map<B>(_ f: (A) -> B) -> Validation<B, E> {
        switch self {
        case let .valid(a):
            return .valid(f(a))
            
        case let .invalid(e):
            return .invalid(e)
        }
    }
    
    public func mapError<F>(_ f: (E) -> F) -> Validation<A, F> {
        switch self {
        case let .valid(a):
            return .valid(a)
            
        case let .invalid(e):
            return .invalid(f(e))
        }
    }
        
    public func flatMap<B>(_ f: (A) -> Validation<B, E>) -> Validation<B, E> {
        switch self {
        case let .valid(a):
            return f(a)
            
        case let .invalid(e):
            return .invalid(e)
        }
    }
    
    public static func pure<A>(_ x: A) -> Validation<A, E> {
        .valid(x)
    }
        
    public var valid: A? {
        switch self {
        case let .valid(value):
            return value
        case .invalid:
            return nil
        }
    }
    
    public var invalid: E? {
        switch self {
        case .valid: return nil
        case let .invalid(error): return error
        }
    }
    
    public var isSuccess: Bool {
        switch self {
        case .valid: return true
        case .invalid: return false
        }
    }
}

public extension Validation where E: Semigroup {
    
    func apply<B>(_ f: Validation<(A) -> B, E>) -> Validation<B, E> {
        switch (f, self) {
        case let (.valid(f), _):
          return self.map(f)
        
        case let (.invalid(e), .valid):
          return .invalid(e)
        
        case let (.invalid(e1), .invalid(e2)):
          return .invalid(e1 <> e2)
        }
    }
    
    static func <*> <B>(a2b: Validation<(A) -> B, E>, a: Validation) -> Validation<B, E> {
      return a.apply(a2b)
    }
}

public extension Validation {
    
    func getOrElse(_ x: @autoclosure () -> A) -> A {
        switch self {
        case let .valid(a):
            return a
            
        case .invalid:
            return x()
        }
    }
    
    static func condition(
        _ predicate: () -> Bool,
        _ valid:@autoclosure () -> A,
        _ invalid:@autoclosure () -> E) -> Validation {
        guard predicate() else {
            return .invalid(invalid())
        }
        return .valid(valid())
    }
}

public func zip<A, B, E: Semigroup>(_ validate1: Validation<A, E>, _ validate2: Validation<B, E>) -> Validation<(A, B), E> {
    .pure(curry(f2)) <*> validate1 <*> validate2
}

public func zip<A, B, C, E: Semigroup>(with f:@escaping (A, B) -> C) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>) -> Validation<C, E> {
    { .pure(curry(f)) <*> $0 <*> $1 }
}

public func zip<A, B, C, E: Semigroup>(_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>) -> Validation<(A, B, C), E> {
    .pure(curry(f3)) <*> validate1 <*> validate2 <*> validate3
}

public func zip<A, B, C, D, E: Semigroup>(with f:@escaping (A, B, C) -> D) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>) -> Validation<D, E> {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 }
}

public func zip<A, B, C, D, F, E: Semigroup>(with f:@escaping (A, B, C, D) -> F) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>) -> Validation<F, E> {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 }
}

public func zip<A, B, C, D, F, G, E: Semigroup>(with f:@escaping (A, B, C, D, F) -> G) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>) -> Validation<G, E> {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 }
}

public func zip<A, B, C, D, F, G, H, E: Semigroup>(with f:@escaping (A, B, C, D, F, G) -> H) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>, _ validate3: Validation<G, E>) -> Validation<H, E> {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 <*> $5 }
}

public func zip<A, B, C, D, F, G, H, I, E: Semigroup>(with f:@escaping (A, B, C, D, F, G, H) -> I) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>, _ validate3: Validation<G, E>, _ validate3: Validation<H, E>) -> Validation<I, E> {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 <*> $5 <*> $6 }
}

func zip<A, B, C, D, F, G, H, I, J, E: Semigroup>(with f:@escaping (A, B, C, D, F, G, H, I) -> J) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>, _ validate3: Validation<G, E>, _ validate3: Validation<H, E>, _ validate3: Validation<I, E>) -> Validation<J, E> {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 <*> $5 <*> $6 <*> $7 }
}

func zip<A, B, C, D, F, G, H, I, J, K, E: Semigroup>(with f:@escaping (A, B, C, D, F, G, H, I, J) -> K) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>, _ validate3: Validation<G, E>, _ validate3: Validation<H, E>, _ validate3: Validation<I, E>, _ validate3: Validation<J, E>) -> Validation<K, E> {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 <*> $5 <*> $6 <*> $7 <*> $8 }
}

func zip<A, B, C, D, F, G, H, I, J, K, L, E: Semigroup>(with f:@escaping (A, B, C, D, F, G, H, I, J, K) -> L) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>, _ validate3: Validation<G, E>, _ validate3: Validation<H, E>, _ validate3: Validation<I, E>, _ validate3: Validation<J, E>, _ validate3: Validation<K, E>) -> Validation<L, E> {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 <*> $5 <*> $6 <*> $7 <*> $8 <*> $9 }
}

func zip<A, B, C, D, F, G, H, I, J, K, L, M, E: Semigroup>(with f:@escaping (A, B, C, D, F, G, H, I, J, K, L) -> M) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>, _ validate3: Validation<G, E>, _ validate3: Validation<H, E>, _ validate3: Validation<I, E>, _ validate3: Validation<J, E>, _ validate3: Validation<K, E>, _ validate3: Validation<L, E> ) -> Validation<M, E>  {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 <*> $5 <*> $6 <*> $7 <*> $8 <*> $9 <*> $10 }
}

func zip<A, B, C, D, F, G, H, I, J, K, L, M, N, E: Semigroup>(with f:@escaping (A, B, C, D, F, G, H, I, J, K, L, M) -> N) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>, _ validate3: Validation<G, E>, _ validate3: Validation<H, E>, _ validate3: Validation<I, E>, _ validate3: Validation<J, E>, _ validate3: Validation<K, E>, _ validate3: Validation<L, E>, _ validate3: Validation<M, E> ) -> Validation<N, E>  {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 <*> $5 <*> $6 <*> $7 <*> $8 <*> $9 <*> $10 <*> $11 }
}

//14
func zip<A, B, C, D, F, G, H, I, J, K, L, M, N, O,  E: Semigroup>(with f:@escaping (A, B, C, D, F, G, H, I, J, K, L, M,N ) -> O) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>, _ validate3: Validation<G, E>, _ validate3: Validation<H, E>, _ validate3: Validation<I, E>, _ validate3: Validation<J, E>, _ validate3: Validation<K, E>, _ validate3: Validation<L, E>, _ validate3: Validation<M, E>,  _ validate3: Validation<N, E> ) -> Validation<O, E>  {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 <*> $5 <*> $6 <*> $7 <*> $8 <*> $9 <*> $10 <*> $11 <*> $12}
}

//15
func zip<A, B, C, D, F, G, H, I, J, K, L, M, N, O,P,  E: Semigroup>(with f:@escaping (A, B, C, D, F, G, H, I, J, K, L, M,N,O ) -> P) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>, _ validate3: Validation<G, E>, _ validate3: Validation<H, E>, _ validate3: Validation<I, E>, _ validate3: Validation<J, E>, _ validate3: Validation<K, E>, _ validate3: Validation<L, E>, _ validate3: Validation<M, E>,  _ validate3: Validation<N, E>, _ validate3: Validation<O, E> ) -> Validation<P, E>  {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 <*> $5 <*> $6 <*> $7 <*> $8 <*> $9 <*> $10 <*> $11 <*> $12 <*> $13}
}

//16
func zip<A, B, C, D, F, G, H, I, J, K, L, M, N, O,P,Q,  E: Semigroup>(with f:@escaping (A, B, C, D, F, G, H, I, J, K, L, M,N,O,P ) -> Q) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>, _ validate3: Validation<G, E>, _ validate3: Validation<H, E>, _ validate3: Validation<I, E>, _ validate3: Validation<J, E>, _ validate3: Validation<K, E>, _ validate3: Validation<L, E>, _ validate3: Validation<M, E>,  _ validate3: Validation<N, E>, _ validate3: Validation<O, E>, _ validate3: Validation<P, E> ) -> Validation<Q, E>  {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 <*> $5 <*> $6 <*> $7 <*> $8 <*> $9 <*> $10 <*> $11 <*> $12 <*> $13 <*> $14}
}


//18
func zip<A, B, C, D, F, G, H, I, J, K, L, M, N, O,P,Q,R,S,  E: Semigroup>(with f:@escaping (A, B, C, D, F, G, H, I, J, K, L, M,N,O,P,Q,R ) -> S) -> (_ validate1: Validation<A, E>, _ validate2: Validation<B, E>, _ validate3: Validation<C, E>, _ validate3: Validation<D, E>, _ validate3: Validation<F, E>, _ validate3: Validation<G, E>, _ validate3: Validation<H, E>, _ validate3: Validation<I, E>, _ validate3: Validation<J, E>, _ validate3: Validation<K, E>, _ validate3: Validation<L, E>, _ validate3: Validation<M, E>,  _ validate3: Validation<N, E>, _ validate3: Validation<O, E>, _ validate3: Validation<P, E>, _ validate3: Validation<Q, E>, _ validate3: Validation<R, E> ) -> Validation<S, E>  {
    { .pure(curry(f)) <*> $0 <*> $1 <*> $2 <*> $3 <*> $4 <*> $5 <*> $6 <*> $7 <*> $8 <*> $9 <*> $10 <*> $11 <*> $12 <*> $13 <*> $14 <*> $15 <*> $16}
}

public struct ValidationError {
    public let error: [Int: String]
    
    public init(error: [Int : String]) {
        self.error = error
    }
    
    func messages() -> String {
        return error.values.map(id).joined(separator: "\n")
    }
}

extension ValidationError: Semigroup, Equatable {
    public static func <> (left: ValidationError, right: ValidationError) -> ValidationError {
        .init(error: left.error.merging(right.error) { cur, _ in cur })
    }
    
    public static func == (lhs: ValidationError, rhs: ValidationError) -> Bool {
        return lhs.error == rhs.error
    }
}

extension String: Semigroup {
    public static func <> (left: String, right: String) -> String {
        left + right
    }
}

extension Dictionary: Semigroup {
    public static func <> (left: Dictionary<Key, Value>, right: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
        left.merging(right) { cur, _ in cur }
    }
}

/*
    EXAMPLE USAGES
 

func validateNumber(_ input: String?) -> Validation<Int, String> {
    guard let ip = input, let num = Int(ip) else {
        return .invalid("Input is not number.")
    }
    return .valid(num)
}

func validateNonEmpty(_ input: String?) -> Validation<String, String> {
    guard input?.isEmpty == false else {
        return .invalid("Input is empty")
    }
    return .valid(input!)
}

func validateEmail(_ input: String?) -> Validation<String, String> {
    guard input?.contains("@") == true else {
        return .invalid("Input is not email")
    }
    return .valid(input!)
}

let emailValidation = validateNonEmpty("")
    .flatMap(validateEmail)
    .mapError { ValidationError(error: [0: $0]) }

let numberValidation = validateNumber("1")
    .mapError { ValidationError(error: [1: $0]) }

struct TestUser {
    let id: Int
    let email: String
}

let createUser = curry(TestUser.init) //{ id in { email in User.init(id: id, email: email) } }

let temp = numberValidation
    .apply(.pure(createUser))

let result = emailValidation
    .apply(temp)

let user = .pure(createUser)
    <*> numberValidation
    <*> emailValidation


// one extra exmple with optional

let o1: String? = "Kaung"
let o2: String? = "Soe"

// try to combine these two string using +
// let o3 = o1 + o2 - can't combine, u must unwrap two optional

// with applicative, u can combine two optional string

let o3 = .pure(curry(+)) <*> o1 <*> o2

 */

func transform(_ input: Int, depe: Int, next: Int) -> Int {
    fatalError()
}

// uncurry

func transform(_ input: Int) -> (_ dep: Int) -> (Int) -> Int {
    fatalError()
}


struct Test {
    let a, b: Int
}

let a = Test.init
let ca = curry(Test.init)
