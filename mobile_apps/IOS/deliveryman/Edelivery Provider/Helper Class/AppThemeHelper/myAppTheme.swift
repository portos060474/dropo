//
//  myAppColors.swift
//  edelivery
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//
import UIKit
extension UIColor {
  
    //@available(iOS 13.0, *)
    
    static var themeViewBackgroundColor:UIColor = UIColor.white
    static var themeViewLightBackgroundColor:UIColor =  UIColor(red:246/255, green:246/255 ,blue:246/255 , alpha:1.0)
        //=  UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:1.00)
    static let themeSwitchTintColor:UIColor =  UIColor(red:228/255, green:228/255 ,blue:228/255 , alpha:1.00)
    static var themeAlertViewBackgroundColor:UIColor =  UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:1.00)
    /*static let themeNavigationBackgroundColor:UIColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
     static let themeTitleColor:UIColor = UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:1.00) White */
    static var themeTitleColor:UIColor = UIColor(red:0/255, green:0/255 ,blue:0/255 , alpha:1.00)
    static var themeNavigationBackgroundColor:UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)

    static var themeButtonBackgroundColor:UIColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
    static let themeButtonTitleColor:UIColor = UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:1.00)
    static var themeLightTextColor:UIColor = UIColor(red:175/255, green:175/255 ,blue:175/255 , alpha:1.0)
        //UIColor(red:26/255, green:26/255 ,blue:25/255 , alpha:0.72)
    static let themeWalletDeductedColor:UIColor = UIColor(red:230/255, green:65/255 ,blue:67/255 , alpha:1.00)
    static let themeWalletAddedColor:UIColor = UIColor(red:87/255, green:142/255 ,blue:18/255 , alpha:1.00)
    static let themeWalletBGColor:UIColor = UIColor(red:236/255, green:236/255 ,blue:236/255 , alpha:1.00)
    static var themeTextColor:UIColor = UIColor(red:26/255, green:26/255 ,blue:26/255 , alpha:1.00)
          static let themeLightHeaderColor:UIColor = UIColor(red:231/255, green:231/255 ,blue:231/255 , alpha:1.0)
    static let themeOverlayColor:UIColor = UIColor(red:26/255, green:26/255 ,blue:26/255 , alpha:0.50)
      static let themeTranparentWhiteColor:UIColor = UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:0.40)
    static let themeSectionTransperentBackgroundColor = UIColor(red:203/255, green:32/255 ,blue:46/255 , alpha:0.11)
  
 
    static let themeLinkColor:UIColor = UIColor(red:203/255, green:32/255 ,blue:46/255 , alpha:1.0)
    static let themeLightLineColor:UIColor = UIColor(red:26/255, green:26/255 ,blue:25/255 , alpha:0.42)
    static var themeRedColor:UIColor = UIColor(red:203/255, green:18/255 ,blue:14/255 , alpha:1.0)
    
    static var themeColor = UIColor()
    static var themeGreenColor = UIColor(red:76/255, green:175/255 ,blue:80/255 , alpha:1.0)
    static var themeYellowColor = UIColor(red:255/255, green:183/255 ,blue:77/255 , alpha:1.0)
    
    static var themeLightGrayTextColor = UIColor(red:85/255, green:85/255 ,blue:85/255 , alpha:1.0)
    
    static var themeIconTintColor = UIColor.black
    
    @available(iOS 11.0, *)
    static func setColors(){
    
        UIColor.themeColor = UIColor(red: 233/255, green: 137/255, blue: 0/255, alpha: 1.0)
        UIColor.themeViewBackgroundColor = UIColor(named: "themeViewBackgroundColor")!
        UIColor.themeLightTextColor = UIColor(named: "themeLightTextColor")!
        UIColor.themeTextColor = UIColor(named: "themeTextColor")!
        UIColor.themeTitleColor = UIColor(named: "themeTitleColor")!
        UIColor.themeIconTintColor = UIColor(named: "themeIconTintColor")!
        UIColor.themeViewLightBackgroundColor = UIColor(named: "themeSectionBGColor")!
        
        UIColor.themeLightGrayTextColor = UIColor.init(named: "themeGrayTextColor")!
        
        UIColor.themeNavigationBackgroundColor = UIColor(named: "themeViewBackgroundColor")!
        UIColor.themeAlertViewBackgroundColor = UIColor(named: "themeViewBackgroundColor")!
          
        UIColor.themeButtonBackgroundColor = UIColor.themeColor
    }
    
   

}
