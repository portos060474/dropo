//
//  myAppColors.swift
// Edelivery Store
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//
import UIKit
struct AppFontName {
    static let regular = "Avenir-Heavy"
    static let bold = "Avenir-Heavy"
    static let italic = "Avenir"
}
extension UIColor{
    
    static let themeViewLightBackgroundColor:UIColor = UIColor(named: "themeSectionBGColor")!

    //UIColor(red:242/255, green:242/255 ,blue:244/255 , alpha:1.00)
    static let themeSearchBackgroundColor:UIColor =  UIColor(red:231/255, green:231/255 ,blue:231/255 , alpha:1.00)
    static let themeAlertViewBackgroundColor:UIColor =  UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:1.00)
    static let themeLightGrayBackgroundColor:UIColor =  UIColor(red:36/255, green:36/255 ,blue:35/255 , alpha:0.62)
    /*static let themeNavigationBackgroundColor:UIColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
     static let themeTitleColor:UIColor = UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:1.00) White */
//        = UIColor(red:0/255, green:0/255 ,blue:0/255 , alpha:1.00)
    static let themeNavigationBackgroundColor:UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let themeDisableButtonBackgroundColor:UIColor = UIColor(red:26/255, green:26/255 ,blue:25/255 , alpha:0.42)
    static let themeButtonTitleColor:UIColor = UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:1.00)
    static let themeWalletBGColor:UIColor = UIColor(red:236/255, green:236/255 ,blue:236/255 , alpha:1.00)
    static let themeWalletDeductedColor:UIColor = UIColor(red:230/255, green:65/255 ,blue:67/255 , alpha:1.00)
    static let themeWalletAddedColor:UIColor = UIColor(red:87/255, green:142/255 ,blue:18/255 , alpha:1.00)
    static let themeOverlayColor:UIColor = UIColor(red:26/255, green:26/255 ,blue:26/255 , alpha:0.60)
    static let themeSectionTransperentBackgroundColor = UIColor(red:203/255, green:32/255 ,blue:46/255 , alpha:0.11)
    static let themeTransparentNavigationBackgroundColor:UIColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.1)
    static let themeStartGradientColor:UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let themeEndGradientColor:UIColor = UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:0.0)
    static let themeGradientColor:UIColor = UIColor(red:26/255, green:26/255 ,blue:25/255 , alpha:0.54)
    static let themeLinkColor:UIColor = UIColor(red:203/255, green:32/255 ,blue:46/255 , alpha:1.0)
    static let themeWhiteTransparentColor:UIColor = UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:0.8)
    static let themeLightLineColor:UIColor = UIColor(red:26/255, green:26/255 ,blue:25/255 , alpha:0.42)
    static let themeSwitchTintColor:UIColor =  UIColor(red:228/255, green:228/255 ,blue:228/255 , alpha:1.00)
    static let themeLightHeaderColor:UIColor = UIColor(red:231/255, green:231/255 ,blue:231/255 , alpha:1.0)
    static let themePlaceholderColor:UIColor = UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:0.50)
    static let themeGreenColor:UIColor = UIColor(red: 52.0/255.0, green: 190.0/255.0, blue: 82.0/255.0, alpha: 1.0)
    static let themeRedCellBGColor:UIColor = UIColor(red:248/255, green:227/255 ,blue:225/255 , alpha:0.8)
    
    static var themeLightGrayTextColor = UIColor(red:85/255, green:85/255 ,blue:85/255 , alpha:1.0)
    
    static var themeViewBackgroundColor = UIColor()
    static var themeTitleColor = UIColor()
    static var themeRedColor = UIColor()
    static var themeColor = UIColor()
    static var themeLightTextColor = UIColor()
    static var themeTextColor = UIColor()
    static var themeIconTintColor = UIColor()
    static var themeSectionLightGrayColor = UIColor()


    
    static func setColors(){
        //theme color
        UIColor.themeColor  = UIColor(red: 93/255, green: 170/255, blue: 30/255, alpha: 1.0)
        UIColor.themeRedColor = UIColor(red:203/255, green:33/255 ,blue:46/255 , alpha:1.0)
    
        UIColor.themeViewBackgroundColor = UIColor(named: "themeViewBackgroundColor") ?? .white
        UIColor.themeLightTextColor = UIColor(named: "themeLightTextColor") ?? UIColor(red: 0/255, green: 175/255, blue: 194/255, alpha: 1.0)
        UIColor.themeTextColor = UIColor(named: "themeTextColor") ?? UIColor(red: 0/255, green: 175/255, blue: 194/255, alpha: 1.0)
        UIColor.themeTitleColor = UIColor(named: "themeTitleColor") ?? UIColor(red: 0/255, green: 175/255, blue: 194/255, alpha: 1.0)
        UIColor.themeIconTintColor = UIColor(named: "themeIconTintColor") ?? UIColor(red: 0/255, green: 175/255, blue: 194/255, alpha: 1.0)
//        UIColor.themeIconTintColor = UIColor(named: "themeIconTintColor", in: Bundle(for: AppDelegate.self), compatibleWith: nil)!
//        UIColor.themeIconTintColor = UIColor(red:56/255, green:56/255 ,blue:56/255 , alpha:1.0)
//        UIColor.themeIconTintColor = UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:1.0)
        
        UIColor.themeLightGrayTextColor = UIColor.init(named: "themeGrayTextColor")!
    }
}

