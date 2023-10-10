//
//  StringUtility.swift
//  edelivery
//
//  Created by Elluminati on 21/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


class FontHelper:UIFont {
    static let largest:CGFloat = 26;
    static let large:CGFloat = 21
    static let medium:CGFloat = 15;
    static let regular:CGFloat = 14;
    static let small:CGFloat = 11;
    static let labelRegular:CGFloat = 13;
    static let labelSmall:CGFloat = 10;
    static let tiny:CGFloat = 9;
    static let cartText:CGFloat = 10;
    static let buttonText:CGFloat = 14;
    class func textLargest(size: CGFloat = 26) -> UIFont {
        return UIFont(name: "ClanPro-News", size: size)!
    }
    class func textMedium(size: CGFloat = 15) -> UIFont {
        return UIFont(name: "ClanPro-Medium", size: size)!
    }
    class func textRegular(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "ClanPro-News", size: size)!
    }
    class func textSmall(size:CGFloat = 11) -> UIFont {
        return UIFont(name: "ClanPro-News", size: size)!
    }
    class func textLarge(size: CGFloat = 21) -> UIFont {
        return UIFont(name: "ClanPro-News", size: size)!
    }
    class func tiny(size: CGFloat = 9) -> UIFont {
        return UIFont(name: "ClanPro-News", size: size)!
    }
    class func labelRegular(size: CGFloat = 13) -> UIFont {
        return UIFont(name: "ClanPro-News", size: size)!
    }
    class func labelSmall(size: CGFloat = 10) -> UIFont {
        return UIFont(name: "ClanPro-News", size: size)!
    }
    class func cartText(size: CGFloat = 10) -> UIFont {
        return UIFont(name: "ClanPro-News", size: size)!
    }
    class func buttonText(size: CGFloat = 14) -> UIFont {
        return UIFont(name: "ClanPro-News", size: size)!
    }
}
