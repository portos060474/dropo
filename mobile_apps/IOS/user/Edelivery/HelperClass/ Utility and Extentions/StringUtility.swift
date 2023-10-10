//
//  StringUtility.swift
//  edelivery
//
//  Created by Elluminati on 21/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

extension String {

    var localized: String {
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

    func localizedCaseCompare(string:String) -> Bool {
        let str1 = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        let str2 = NSLocalizedString(string, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        return str1.compare(str2) == .orderedSame
    }

    var localizedWithFormat: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "").capitalized
    }

    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }

    struct NumberFormat {
        static let instance = NumberFormatter()
    }

    var doubleValue:Double? {
        return NumberFormat.instance.number(from: self)?.doubleValue
    }

    var integerValue:Int? {
        return NumberFormat.instance.number(from: self)?.intValue
    }

    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    func searchIPString(string: String) -> [String]? {
        let regex = "\\d{1,3}[.]\\d{1,3}[.]\\d{1,3}[.]\\d{1,3}"
        do {
            let regularExpresion = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            let matches = regularExpresion.matches(in: string, options: .reportCompletion, range: NSMakeRange(0, string.count))

            var matchingIPs = [String]()
            let convertedString = string as NSString
            matches.forEach { textCheckingResult in
                let range = textCheckingResult.range
                let foundIP = convertedString.substring(with: range) as String
                matchingIPs.append(foundIP)
            }
            return matchingIPs
        } catch let error as NSError{
            print("Regular Expression Format is Wrong: \(error.localizedDescription)")
        }
        return []
    }

    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }

    static func secondsToMinutesSeconds (seconds : Int) -> String {
        let min = String(format: "%02d",Int((seconds % 3600) / 60))
        let sec = String(format: "%02d", Int((seconds % 3600) % 60))
        return "\(min):\(sec)"
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

    func toStringDouble(places:Int = 2) -> String {
        return String(format:"%."+places.description+"f", self)
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
                    break
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
        return formatter.string(from: NSNumber.init(value: self) ) ?? self.toString(decimalPlaced: 2)
    }
}

public extension CGFloat {
     static let HTagAutoWidth: CGFloat = 0.0
     static let HTagAutoMaximumWidth: CGFloat = 0.0
}
