//
//  L102Language.swift
//  Localization102
//
//  Created by Moath_Othman on 2/24/16.
//  Copyright © 2016 Moath_Othman. All rights reserved.
//

import UIKit

// constants

/// L102Language
class LocalizeLanguage {
    /// get current Apple language
    class func currentLanguage() -> String {
        let languageIndex = preferenceHelper.getLanguage()
        return arrForLanguages[languageIndex].code
        
    }
    class func currentAppleLanguageFull() -> String {
        
        let languageIndex = preferenceHelper.getLanguage()
        return arrForLanguages[languageIndex].language
    }
    /// set @lang to be the first in Applelanguages list
    class func setAppleLanguageTo(lang: Int) {
        preferenceHelper.setLanguage(lang)
    }

    class var isRTL: Bool {
        return LocalizeLanguage.currentLanguage() == "ar"
    }
}
