//
//  ValidationRules.swift
//  Utilities
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation
import UIKit


extension String {
    var removedSpaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}


public func validatePhoneNumber(message: String = "invalid phone number")
    -> (_ input: String) -> Validation<String, String> {
        {
            
            let isValid = PhoneValidator.isValidMMPhoneNumber(phoneNumber: $0.removedSpaces)
            
            if isValid {
                return .valid($0)
            } else {
                return .invalid(message)
            }
            
        }
}

public func validateNonEmpty(message: String = "Input is empty")
    -> (_ input: String?) -> Validation<String, String> {
        {
            guard $0?.isEmpty == false else {
                return .invalid(message)
            }
            return .valid($0!)
        }
}

public func validateNonEmpty(message: String = "Input is empty")
    -> (_ input: Bool?) -> Validation<Bool, String> {
        {
            guard $0.isNotNil, $0 == true else {
                return .invalid(message)
            }
        
            return .valid($0!)
        }
}
