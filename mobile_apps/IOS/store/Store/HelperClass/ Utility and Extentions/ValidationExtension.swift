//
//  ValidationExtension.swift
//  Store
//
//  Created by Dhruvi on 27/01/22.
//  Copyright © 2022 Elluminati. All rights reserved.
//

import Foundation
import UIKit
import libPhoneNumber_iOS

typealias PhoneNumberFormat = (formatted: String,phoneCode:String,normal: String, isValid: Bool, phoneNumber: NBPhoneNumber)

//MARK: - Validation Extension
extension String{
    func isEmpty() -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func isValidEmail() -> Bool {
        if self.count < emailMinimumLength || self.count > emailMaximumLength {
            return false
        } else {
            let emailRegex = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|" +
            "(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]" +
            "{0,61}[A-Za-z0-9])?)*)))(\\.[A-Za-z]{2,})$"
            let emailTest:NSPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            let isValid = emailTest.evaluate(with: self)
            if isValid {
                return true
            } else {
                return false
            }
        }
    }

    func checkEmailValidation() -> (Bool, String) {
        if self.isEmpty() {
            return (false, "MSG_PLEASE_ENTER_EMAIL".localized)
        } else {
            if self.count < emailMinimumLength || self.count > emailMaximumLength {
                return (false, String(format: "msg_enter_valid_email_min_max_length".localized, String(emailMinimumLength), String(emailMaximumLength)))
            } else {
                let emailRegex = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|" +
                                "(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]" +
                                "{0,61}[A-Za-z0-9])?)*)))(\\.[A-Za-z]{2,})$"
                let emailTest:NSPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
                let isValid = emailTest.evaluate(with: self)
                if isValid {
                    return (true, "")
                } else {
                    return (false, "MSG_PLEASE_ENTER_VALID_EMAIL".localized)
                }
            }
        }
    }

    func checkPasswordValidation() -> (Bool, String) {
        if self.isEmpty() {
            return (false, "MSG_PLEASE_ENTER_PASSWORD".localized)
        } else {
            if self.count < passwordMinLength || self.count > passwordMaxLength {
                return (false, String(format: "msg_enter_valid_password_min_max_length".localized, String(passwordMinLength), String(passwordMaxLength)))
            } else {
                return (true, "")
            }
        }
    }

    func isNumber() -> Bool {
        let numberCharacters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty() && self.rangeOfCharacter(from:numberCharacters) == nil
    }

    func isValidMobileNumber(CounrtyCode:String = "") -> (Bool, String) {
        if self.isEmpty() {
            return (false, "MSG_PLEASE_ENTER_MOBILE_NUMBER".localized)
        } else {
            let min = preferenceHelper.getMinMobileLength()
            let max = preferenceHelper.getMaxMobileLength()
            
            if self.count < min || self.count > max {
                return (false, "MSG_PLEASE_ENTER_MOBILE_NUMBER".localized)
            } else {
                return (true, "")
            }
        }
    }

    var isPhoneNumber: Bool {
        get {
            let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result = phoneTest.evaluate(with: self)
            return result
        }
    }

    func getPhoneNumberFormat(regionCode:String) -> PhoneNumberFormat {
        //        let regionCode: String = Locale.current.regionCode ?? "US"
        let phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()
        var myNumber: NBPhoneNumber = NBPhoneNumber()
        var formatted: String = ""
        var normal: String = ""
        var phoneCode: String = ""
        var isValid: Bool = false

        do {
            myNumber = try phoneUtil.parse(self, defaultRegion: regionCode)
            if phoneUtil.isValidNumber(myNumber) {
                isValid = true
                formatted = try phoneUtil.format(myNumber, numberFormat: NBEPhoneNumberFormat.INTERNATIONAL)
            }
        }

        catch let error as NSError {
            debugPrint("\(#function) \(error.localizedDescription)")
        }

        formatted = formatted.replacingOccurrences(of: "(", with: "")
        formatted = formatted.replacingOccurrences(of: ")", with: "")
        formatted = formatted.replacingOccurrences(of: "-", with: " ")
        phoneCode = formatted.components(separatedBy: " ")[0]
        normal = formatted.replacingOccurrences(of: " ", with: "")

        return (formatted, phoneCode, normal, isValid, myNumber)
    }
}
