//
//  StringUtility.swift
//  edelivery
//
//  Created by Elluminati on 21/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation

extension String {

    //MARK: - String Localizing
    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    var localizedCapitalized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "").capitalized
    }

    var localizedUppercase: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "").uppercased()
    }

    var localizedLowercase: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "").lowercased()
    }

    func localizedCompare(string:String) -> Bool {
        let str1 = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        let str2 = NSLocalizedString(string, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        return str1.caseInsensitiveCompare(str2) == .orderedSame
    }

    func localizedCaseCompare(string:String) -> Bool{
        let str1 = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        let str2 = NSLocalizedString(string, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        return str1.compare(str2) == .orderedSame
    }

    //MARK: - String Casting
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }

    static func secondsToMinutesSeconds (seconds : Int) -> String {
        return "\(Int((seconds % 3600) / 60)):\((seconds % 3600) % 60)"
    }

    var doubleValue:Double? {
        if NumberFormat.instance.number(from: self)?.doubleValue != nil {
            return NumberFormat.instance.number(from: self)?.doubleValue
        } else {
            return Double.init(String(format: "%.2f",Double.init(self) ?? 0.0)) ?? 0.0
        }
    }

    var integerValue:Int? {
        if NumberFormat.instance.number(from: self)?.intValue != nil {
            return NumberFormat.instance.number(from: self)?.intValue
        } else {
            return Int.init(self)
        }
    }

    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    struct NumberFormat {
        static let instance = NumberFormatter()
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int = 2) -> Double {
        let divisor = pow(10.00, Double(places))
        return (self * divisor).rounded() / divisor
    }

    func toString(decimalPlaced:Int = 2) -> String {
        return String.init(format: "%.\(decimalPlaced)f", self)
    }

    static func getCurrencySign(currencyCode:String = preferenceHelper.getWalletCurrencyCode()) -> String {
        var currencyNewCode = currencyCode

        if currencyNewCode.isEmpty() {
            currencyNewCode = preferenceHelper.getWalletCurrencyCode()
        }

        var locale = Locale.current
        if CurrencyHelper.shared.myLocale.currencyCode == currencyNewCode {
            locale = CurrencyHelper.shared.myLocale
        } else {
            for iteratedLocale in Locale.availableIdentifiers {
                let newLocal = Locale.init(identifier: iteratedLocale)
                if newLocal.currencyCode == currencyNewCode {
                    locale = newLocal
                    break;
                }
            }
        }

        if locale.identifier.contains("_") {
            let strings = locale.identifier.components(separatedBy: "_")
            if strings.count > 0 {
                let countryCode = strings[strings.count - 1]
                locale = Locale.init(identifier: "\(arrForLanguages[preferenceHelper.getLanguage()].code)_\(countryCode)")
            }
        } else {
            locale = Locale.init(identifier: "\(arrForLanguages[preferenceHelper.getLanguage()].code)_\(locale.identifier)")
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        CurrencyHelper.shared.myLocale = locale
        return formatter.currencySymbol
    }

    func toCurrencyString(currencyCode:String = preferenceHelper.getWalletCurrencyCode()) -> String {
        var currencyNewCode = currencyCode

        if currencyNewCode.isEmpty() {
            currencyNewCode = preferenceHelper.getWalletCurrencyCode()
        }

        var locale = Locale.current
        if CurrencyHelper.shared.myLocale.currencyCode == currencyNewCode {
            locale = CurrencyHelper.shared.myLocale
        } else {
            for iteratedLocale in Locale.availableIdentifiers {
                let newLocal = Locale.init(identifier: iteratedLocale)
                if newLocal.currencyCode == currencyNewCode {
                    locale = newLocal
                    break;
                }
            }
        }

        if locale.identifier.contains("_") {
            let strings = locale.identifier.components(separatedBy: "_")
            if strings.count > 0 {
                let countryCode = strings[strings.count - 1]
                locale = Locale.init(identifier: "\(arrForLanguages[preferenceHelper.getLanguage()].code)_\(countryCode)")
            }
        } else {
            locale = Locale.init(identifier: "\(arrForLanguages[preferenceHelper.getLanguage()].code)_\(locale.identifier)")
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        CurrencyHelper.shared.myLocale = locale
        return formatter.string(from: NSNumber.init(value: self) ) ?? self.toString(decimalPlaced: 2);
    }
}
