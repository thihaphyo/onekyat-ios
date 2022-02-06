//
//  AppEnvironment.swift
//  onekyat
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation
import Data
import CommonExtensions
import RxSwift
import RxCocoa
import Utilities

var Current = AppEnvironment.live

struct AppEnvironment {
    
    var concurrentSchedular: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)
    var keychain: KeyValueClient = KeychainService()
    var mainSchedular: SchedulerType = MainScheduler.instance
}


extension AppEnvironment {
    static let live = AppEnvironment()
    
    static let dev: AppEnvironment = {
        var env = AppEnvironment()
        env.keychain = KeychainMock()
        return env
    }()
}
