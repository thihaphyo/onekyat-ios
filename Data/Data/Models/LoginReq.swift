//
//  LoginReq.swift
//  Data
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation


public class LoginReq: Encodable {
    
    public let phone: String
    public let password: String

    
    public init(phone: String, password: String) {
        self.phone = phone
        self.password = password
    }
    
}
