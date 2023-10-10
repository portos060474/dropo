//
//  Utility.swift
//  tableViewDemo
//
//  Created by Elluminati on 12/01/17.
//  Copyright © 2017 tag. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation
import Alamofire

class Utility: NSObject {
    
    static func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }
    static func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    static var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    static var overlayView = UIView()
    static var mainView = UIView()
    override init(){

    }
    
    static func showLoading(color: UIColor = UIColor.white){
        DispatchQueue.main.async {
            if(!activityIndicator.isAnimating) {
                self.mainView = UIView()
                self.mainView.frame = UIScreen.main.bounds
                self.mainView.backgroundColor = UIColor.clear
                self.overlayView = UIView()
                self.activityIndicator = UIActivityIndicatorView()
                
                overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
                overlayView.clipsToBounds = true
                overlayView.layer.cornerRadius = 10
                overlayView.layer.zPosition = 1
                
                activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
                activityIndicator.style = .whiteLarge
                overlayView.addSubview(activityIndicator)
                self.mainView.addSubview(overlayView)
                
                if APPDELEGATE.window?.viewWithTag(701) != nil {
                    
                }else {
                    overlayView.center = (UIApplication.shared.keyWindow?.center)!
                    mainView.tag = 701
                    UIApplication.shared.keyWindow?.addSubview(mainView)
                    activityIndicator.startAnimating()
                }
            }
            
        }
    }

    static func hideLoading(){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            mainView.removeFromSuperview()
            UIApplication.shared.keyWindow?.viewWithTag(701)?.removeFromSuperview()
        }
    }

    static func showToast( message:String, backgroundColor:UIColor = UIColor.themeButtonBackgroundColor, textColor:UIColor = UIColor.white, endEditing: Bool = true){

        if !message.isEmpty {
            DispatchQueue.main.async {

                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                let label = EdgeInsetLabel()
                label.textInsets = UIEdgeInsets(top: 10, left: 20, bottom: UIApplication.bottomSafeAreaHeight == 0 ? 10 : UIApplication.bottomSafeAreaHeight, right: 20)
                label.textAlignment = NSTextAlignment.center
                label.text = message
                label.adjustsFontSizeToFitWidth = true

                label.backgroundColor =  backgroundColor //UIColor.whiteColor()
                label.textColor = textColor //TEXT COLOR
                label.sizeToFit()
                label.numberOfLines = 4
                label.layer.shadowColor = UIColor.gray.cgColor
                label.layer.shadowOffset = CGSize.init(width: 4, height: 3)
                label.layer.shadowOpacity = 0.3
                label.frame = CGRect.init(x: 0, y: (appDelegate.window?.frame.maxY)!, width:  appDelegate.window!.frame.size.width, height: label.frame.size
                    .height)

                label.alpha = 1
                
                if endEditing {
                    UIApplication.shared.keyWindow?.endEditing(true)
                    UIApplication.shared.windows.last?.endEditing(true)
                }
                
                var window: UIWindow?

                if let keyWindow = UIApplication.shared.keyWindow {
                    window = keyWindow
                } else {
                    window = UIApplication.shared.windows.last

                }
                window?.addSubview(label)


                var basketTopFrame: CGRect = label.frame
                basketTopFrame.origin.x = 0
                basketTopFrame.origin.y = (appDelegate.window?.frame.maxY)! - label.frame.height

                UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                    label.frame = basketTopFrame
                },  completion: {
                    (value: Bool) in
                    UIView.animate(withDuration: 3.0, delay: 3.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                        label.alpha = 0
                    },  completion: {
                        (value: Bool) in
                        label.removeFromSuperview()
                    })
                })
            }
        }
    }

    static func convertDictToJson(dict:Dictionary<String, Any>) -> Void{
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
    }

    //MARK: - DATE UTILITY FUNCTIONS
    static func relativeDateStringForDate(strDate: String, dateFormate: String = "yyyy-MM-dd") -> NSString{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        let enUSPOSIXLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPOSIXLocale as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = dateFormatter.string(from:NSDate() as Date)

        let calender : NSCalendar = NSCalendar.init(identifier:.gregorian)!
        let dayComponent = NSDateComponents()
        dayComponent.day = -1
        
        let date:Date = calender.date(byAdding:dayComponent as DateComponents, to: NSDate() as Date, options: NSCalendar.Options(rawValue: 0))!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strYesterdatDate = dateFormatter.string(from:date as Date)
        
        if(strDate == currentDate) {
            return "TXT_TODAY".localizedCapitalized as NSString
        }
        else if(strDate == strYesterdatDate) {
            return "TXT_YESTERDAY".localizedCapitalized as NSString
        }else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.ReferenceType.default
            let enUSPOSIXLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.locale = enUSPOSIXLocale as Locale

            dateFormatter.dateFormat = dateFormate
            let date = dateFormatter.date(from: strDate)
            let myCurrentDate = Utility.convertDateFormate(date: date!)
            return myCurrentDate as NSString
        }
    }
    static func convertDateFormate(date : Date) -> String {
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.timeZone = TimeZone.ReferenceType.default
        
        dateFormate.dateFormat = "MMM yyyy, hh:mm a"
        let newDate = dateFormate.string(from: date)
        
        var day = "\(anchorComponents.day!)"
        switch (day) {
            case "1" , "21" , "31":
                day.append("st")
            case "2" , "22":
                day.append("nd")
            case "3" ,"23":
                day.append("rd")
            default:
                day.append("th")
        }
        return day + " " + newDate
    }
    static func stringToString(strDate:String, fromFormat:String, toFormat:String, locale: String = "en_GB")->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC") ?? TimeZone(identifier: "UTC") ?? TimeZone.ReferenceType.default
        var localeId = ""
        if locale != "" {
            localeId = arrForLanguages[0].code + "_GB"
        }
        else {
            localeId = arrForLanguages[preferenceHelper.getLanguage()].code + "_GB"
        }
        
        dateFormatter.locale = NSLocale(localeIdentifier: localeId) as Locale
        let date = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = toFormat
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        return dateFormatter.string(from: date!)
    }

    static func stringToString(strDate:String, fromFormat:String, toFormat:String,timezone:String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC") ?? TimeZone(identifier: "UTC") ??  TimeZone.ReferenceType.default
        
        dateFormatter.dateFormat = fromFormat
        let currentDate = dateFormatter.date(from: strDate) ?? Date()
        dateFormatter.dateFormat =  toFormat
        dateFormatter.timeZone = TimeZone.init(identifier: timezone) ?? TimeZone.current
        
        let currentDates = dateFormatter.string(from: currentDate)
        return currentDates
    }
    
    static func dateToString(date: Date, withFormat:String, withTimezone:TimeZone = TimeZone.ReferenceType.default) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = withTimezone
        dateFormatter.dateFormat = withFormat
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    static func stringToDate(strDate: String, withFormat:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        dateFormatter.dateFormat = withFormat
        return dateFormatter.date(from: strDate) ?? Date()
    }

    static func currentTimeInMilisecondsOfHHMM() -> Int64{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        dateFormatter.dateFormat = DATE_CONSTANT.TIME_FORMAT_HH_MM
        let currentDate = dateFormatter.string(from: Date())
        let date = dateFormatter.date(from: currentDate) ?? Date()
        let since1970 = date.timeIntervalSince1970
        return Int64(since1970 * 1000)
    }
    static func dateToMiliseconds(date:Date)-> Int64 {
        let since1970 = date.timeIntervalSince1970
        return Int64(since1970 * 1000)
    }
    static func stringToMilisecond(strDate:String) -> Int64 {
        let str = Utility.stringToString(strDate: strDate, fromFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM, toFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
        let date = Utility.stringToDate(strDate: str, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
        let since1970 = date.timeIntervalSince1970

        return Int64(since1970 * 1000)
    }


    static func bindPriceTag(arrForFamousTags:[Famous_Products_Tags],currency:String,numberOfTags:Int) -> String {

        let dot = " \u{2022} "
        var priceTag:String = ""
        if numberOfTags <= 0 {
            return priceTag
        }
        for _ in 1...numberOfTags {
            priceTag.append(currency)
        }
        if !arrForFamousTags.isEmpty {
            priceTag.append(" \(dot)")
            //Userapp
            //            priceTag.append(arrForFamousTags.joined(separator: dot))
            
            /*if arrForFamousTags.count > 0{
             if arrForFamousTags[0].count > 0{
             if arrForFamousTags[0].count-1 >= preferenceHelper.getSelectedLanguage(){
             priceTag.append(arrForFamousTags[0][preferenceHelper.getSelectedLanguage()])
             }else{
             priceTag.append(arrForFamousTags[0][0])
             }
             }
             }*/
            
            for obj in arrForFamousTags {
                priceTag.append("\(obj.tag) \(dot)")
            }
            
            /*
            for i in 0...arrForFamousTags.count-1{
                if arrForFamousTags[i].count > 0{
                    if arrForFamousTags[i].count-1 >= preferenceHelper.getSelectedLanguage(){
                        priceTag.append(arrForFamousTags[i][preferenceHelper.getSelectedLanguage()]+"\(dot)")
                    }else{
                        priceTag.append(arrForFamousTags[i][0] + "\(dot)")
                    }
                }
            }*/
            
        }
        return priceTag
    }
    static func bindTagWithComma(arrForFamousTags:[Famous_Products_Tags],numberOfTags:Int) -> String {

        let dot = ", "
        var priceTag:String = ""
        if numberOfTags <= 0 {
            return priceTag
        }
        
        var arrStr: [String] = []
        for obj in arrForFamousTags {
            arrStr.append(obj.tag)
        }
        priceTag = arrStr.joined(separator: ", ")
        /*
        if !arrForFamousTags.isEmpty {
            //Userapp
            for i in 0...arrForFamousTags.count-1{
                if arrForFamousTags[i].count > 0{
                    if arrForFamousTags[i].count-1 >= preferenceHelper.getSelectedLanguage(){
                        if arrForFamousTags.count == 1 ||  (arrForFamousTags.count-1) == i {
                            priceTag.append(arrForFamousTags[i][preferenceHelper.getSelectedLanguage()])
                        }
                        else {
                            priceTag.append(arrForFamousTags[i][preferenceHelper.getSelectedLanguage()]+"\(dot)")
                        }



                    }else{
                        if arrForFamousTags.count == 1 {
                            priceTag.append(arrForFamousTags[i][0])
                        }
                        else {
                            priceTag.append(arrForFamousTags[i][0] + "\(dot)")
                        }

                    }
                }
            }
        }*/
        return priceTag
    }


    static func numberOfTag(numberOfTags:Int, currency: String) -> String {
        var priceTag:String = ""
        if numberOfTags <= 0 {
            return priceTag
        }
        else {
            for _ in 1...numberOfTags {
                priceTag.append(currency)
            }
        }
        return priceTag
    }

    static func isStoreOpen(storeTime:[StoreTime],milliSeconds:Int64) -> (Bool,String)
    {
        let components = Utility.millisecondToDateComponents(milliSeconds: milliSeconds)
        let weekday = (components.weekday! - 1)

        let currentcomponents = Utility.millisecondToDateComponents(milliSeconds: currentBooking.currentDateMilliSecond)
        let currentweekday = (currentcomponents.weekday! - 1)

        let currentDate:Date = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: Date()) ?? Date()

        let currentTime:Int64 = Utility.dateToMiliseconds(date: currentDate)
        var nextOpenTime = ""
        if let selectedStoreDay:StoreTime = storeTime.first(where: {$0.day == weekday}) {
            if selectedStoreDay.isStoreOpenFullTime {
                return (true,"")
            }else {
                if selectedStoreDay.isStoreOpen {
                    let dayTime : [DayTime] = selectedStoreDay.dayTime
                    if dayTime.isEmpty {
                        return (false,"TXT_STORE_IS_CLOSED_ON".localized + (Day(rawValue:weekday)?.text())!)
                    }else {
                        var isStoreClosed = true
                        for store_time:DayTime in dayTime
                        {
                            if store_time.storeOpenTime != nil && store_time.storeCloseTime != nil {
                                let open_time = store_time.storeOpenTime.components(separatedBy: ":")
                                let x:Date = Calendar.current.date(bySettingHour: open_time[0].integerValue!, minute: open_time[1].integerValue!, second: 0, of: currentDate)!
                                let x2 = Utility.dateToMiliseconds(date: x)

                                let close_time = store_time.storeCloseTime.components(separatedBy: ":")
                                let y:Date = Calendar.current.date(bySettingHour: close_time[0].integerValue!, minute: close_time[1].integerValue!, second: 0, of: currentDate)!
                                let y2 = Utility.dateToMiliseconds(date: y)

                                if(currentTime >= x2 && currentTime < y2) {
                                    isStoreClosed = false
                                    break
                                }

                                if(currentTime < x2 && nextOpenTime.isEmpty())
                                {
                                    nextOpenTime = store_time.storeOpenTime
                                    break
                                }
                            }
                        }
                        if nextOpenTime.isEmpty() && isStoreClosed {
                            if (weekday - currentweekday) == 0 {
                                nextOpenTime = "TXT_STORE_IS_CLOSED_ON".localized + "TXT_TODAY".localizedCapitalized
                            } else {
                                nextOpenTime = "TXT_STORE_IS_CLOSED_ON".localized + (Day(rawValue:weekday)?.text())!
                            }
                        } else {
                            nextOpenTime = "TXT_REOPEN_AT".localized + " " + nextOpenTime
                        }
                        return (!isStoreClosed,nextOpenTime)
                    }
                } else {
                    if (weekday - currentweekday) == 0 {
                        nextOpenTime = "TXT_STORE_IS_CLOSED_ON".localized + "TXT_TODAY".localizedCapitalized
                    } else {
                        nextOpenTime = "TXT_STORE_IS_CLOSED_ON".localized + (Day(rawValue:weekday)?.text())!
                    }
                    return (false,nextOpenTime)
                }
            }
        }
        return (true,"")
    }

    static func isStoreOpenForSchedule(storeTime:[StoreTime],milliSeconds:Int64,is_store_set_schedule_delivery_time:Bool) -> (Bool,String)
    {
        let components = Utility.millisecondToDateComponents(milliSeconds: milliSeconds)
        let weekday = (components.weekday! - 1)

        let currentcomponents = Utility.millisecondToDateComponents(milliSeconds: currentBooking.currentDateMilliSecond)
        let currentweekday = (currentcomponents.weekday! - 1)

        let currentDate:Date = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: Date()) ?? Date()

        let currentTime:Int64 = Utility.dateToMiliseconds(date: currentDate)

        var nextOpenTime = ""
        if let selectedStoreDay:StoreTime = storeTime.first(where: {$0.day == weekday}) {
            //         if selectedStoreDay.isStoreOpenFullTime {
            //             return (true,"")
            //         }else {
            if is_store_set_schedule_delivery_time {
                let dayTime : [DayTime] = selectedStoreDay.dayTime
                if dayTime.isEmpty {
                    return (false,"TXT_STORE_IS_CLOSED_ON".localized + (Day(rawValue:weekday)?.text())!)
                }else {
                    var isStoreClosed = true
                    for store_time:DayTime in dayTime
                    {
                        let open_time = store_time.storeOpenTime.components(separatedBy: ":")

                        let x:Date = Calendar.current.date(bySettingHour: open_time[0].integerValue!, minute: open_time[1].integerValue!, second: 0, of: currentDate)!
                        let x2 = Utility.dateToMiliseconds(date: x)

                        let close_time = store_time.storeCloseTime.components(separatedBy: ":")
                        let y:Date = Calendar.current.date(bySettingHour: close_time[0].integerValue!, minute: close_time[1].integerValue!, second: 0, of: currentDate)!
                        let y2 = Utility.dateToMiliseconds(date: y)

                        if(currentTime >= x2 && currentTime < y2)
                        {
                            isStoreClosed = false
                            break
                        }

                        if(currentTime < x2 && nextOpenTime.isEmpty())
                        {
                            nextOpenTime = store_time.storeOpenTime
                            break
                        }

                    }

                    if nextOpenTime.isEmpty() && isStoreClosed {
                        if (weekday - currentweekday) == 0 {
                            nextOpenTime = "TXT_STORE_IS_CLOSED_ON".localized + "TXT_TODAY".localizedCapitalized
                        } else {
                            nextOpenTime = "TXT_STORE_IS_CLOSED_ON".localized + (Day(rawValue:weekday)?.text())!
                        }
                    } else {
                        nextOpenTime = "TXT_REOPEN_AT".localized + " " + nextOpenTime
                    }
                    return (!isStoreClosed,nextOpenTime)
                }
            } else {
                if (weekday - currentweekday) == 0 {
                    nextOpenTime = "TXT_STORE_IS_CLOSED_ON".localized + "TXT_TODAY".localizedCapitalized
                } else {
                    nextOpenTime = "TXT_STORE_IS_CLOSED_ON".localized + (Day(rawValue:weekday)?.text())!
                }
                return (false,nextOpenTime)
            }
        }
        return (true,"")
    }

    //MARK: - Table Booking Conditions
    static func isTableBooking() -> Bool {
        if currentBooking.deliveryType != 0 && currentBooking.bookingType != 0 && currentBooking.number_of_pepole != 0 && currentBooking.table_no != 0 {
            return true
        } else {
            return false
        }
    }

    //MARK: - Other Utility Functions
    static func setTabbarProperties(tabbar:UITabBar) -> Void {
        let size = CGSize.init(width:(tabbar.frame.size.width/2), height:tabbar.frame.size.height)
        let lineSize =  CGSize.init(width:(tabbar.frame.size.width/2), height:2)
        let rect = CGRect.init(x:0, y:10, width:size.width,height: size.height)
        let rectLine = CGRect.init(x:0, y:size.height-lineSize.height,width:lineSize.width,height:lineSize.height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        UIColor.black.setFill()
        UIRectFill(rectLine)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        tabbar.shadowImage = UIImage()
        tabbar.backgroundImage = UIImage()
        tabbar.barTintColor = UIColor.white
        tabbar.selectionIndicatorImage = image
        tabbar.layer.shadowColor = UIColor.themeLightTextColor.cgColor
        tabbar.layer.shadowOffset = CGSize.init(width: 0, height: 0.7)
        tabbar.layer.shadowOpacity = 0.6
        tabbar.layer.shadowRadius = 0.5
        tabbar.layer.borderWidth = 0.0
        tabbar.layer.borderColor = UIColor.clear.cgColor
        tabbar.isTranslucent = false
    }

    static func setupButton(button: UIButton) {
        button.semanticContentAttribute = .forceLeftToRight
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        let spacing: CGFloat = 5.0
        let imageSize: CGSize = (button.imageView?.image?.size) ?? CGSize.init(width: 25.0, height: 25.0)

        button.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: button.titleLabel?.text ?? "abcd")
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: button.titleLabel?.font ?? FontHelper.textSmall()])
        button.imageEdgeInsets = UIEdgeInsets.init(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
        button.contentEdgeInsets = UIEdgeInsets.init(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }

    //MARK: - Gesture Handler
    static func addGestureForRemoveViewOnTouch(view:UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
        view.addGestureRecognizer(tap)
    }

    @objc static func hideView(sender:UITapGestureRecognizer) {
        let view:UIView = sender.view!
        view.removeFromSuperview()
        view.endEditing(true)
    }
    static func snapshotImage(view:UIView, frame:CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, true, 0)
        view.drawHierarchy(in: frame, afterScreenUpdates: true)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func downloadImageFrom(link:String, placeholder:String = "driver_pin_icon", completion: @escaping (_ result: UIImage) -> Void) {
        if link.isEmpty() {
            return  completion(UIImage.init(named: placeholder)!)
        }else {
            let urlStr = WebService.BASE_URL_ASSETS +  link
            SDWebImageManager.shared.imageLoader.requestImage(with: URL.init(string: urlStr), options: .continueInBackground, context: nil, progress: nil) { (image, data, error, result) in
                
                if let downloadedImage = image {
                    let width = (UIScreen.main.bounds.width * 0.1)
                    let height = width
                    let size = CGSize.init(width: width, height: height)
                    let newImage = downloadedImage.jd_imageAspectScaled(toFit: size)
                    completion(newImage)
                }else{
                    completion(UIImage.init(named: placeholder)!)
                }
            }
        }
    }

    //MARK : Date and Time Calculator
    static func secondsToHoursMinutes(seconds : Int64) -> String {
        return "\(seconds / 3600) hr \((seconds % 3600) / 60) min"
    }

    static func minutToHoursMinutes(minut : Double) -> String {
        
        let seconds =  Int64.init(minut * 60)
        return "\(seconds / 3600) : \((seconds % 3600) / 60)"
    }

    static func dateCompontentToMilisecond(dateComponent:DateComponents,futureDateComponent:DateComponents)->Int {
        let intervel = Calendar.current.dateComponents([.second], from: (dateComponent.date)!, to: (futureDateComponent.date)!).second ?? 0
        return abs(intervel * 1000)
    }

    static func convertServerDateToMilliSecond(serverDate:String,strTimeZone:String)-> Int64 {
        let dateFor = DateFormatter()
        dateFor.timeZone = TimeZone.init(abbreviation: "UTC") ?? TimeZone(identifier: "UTC") ?? TimeZone.ReferenceType.default
        dateFor.dateFormat = DATE_CONSTANT.DATE_TIME_FORMAT_WEB
        let date = dateFor.date(from: serverDate) ?? Date()
        
        if let timezone = TimeZone.init(identifier: strTimeZone) ?? TimeZone.init(abbreviation:strTimeZone ) ?? dateFor.timeZone {
            let offSetMiliSecond:Int64
                =  Int64(timezone.secondsFromGMT() * 1000)
            let timeFrom1970:Int64 = Int64(date.timeIntervalSince1970)
            let finalServerMilli =   Int64(  Int64(timeFrom1970 * 1000) +  offSetMiliSecond)
            return finalServerMilli
        }else {
            return 0
        }
    }
    
    static func convertSelectedDateToMilliSecond(serverDate:Date,strTimeZone:String)-> Int64 {
        
        let timezone = TimeZone.init(identifier: strTimeZone) ?? TimeZone.ReferenceType.default
        let offSetMiliSecond = Int64(timezone.secondsFromGMT() * 1000)
        let timeSince1970 = Int64(serverDate.timeIntervalSince1970)
        let finalSelectedDateMilli =   Int64(  Int64(timeSince1970 * 1000) +  offSetMiliSecond)
        return finalSelectedDateMilli
    }
    
    
    static func millisecondToDateComponents(milliSeconds:Int64) -> DateComponents {
        let selectedDate:Date =  Date(timeIntervalSince1970: Double(milliSeconds/1000))
        let component:DateComponents = Calendar.current.dateComponents(in:TimeZone.init(identifier: "UTC")!, from: selectedDate)
        return component
    }

    static func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, isUnitKiloMeter:Bool) -> Int {
        let sourceCoordinate = CLLocation(latitude: lat1, longitude: lon1)
        let destCoordinate = CLLocation(latitude: lat2, longitude: lon2)
        var distanceInMeters = sourceCoordinate.distance(from: destCoordinate)
        if (isUnitKiloMeter) {
            distanceInMeters = distanceInMeters *  0.001
        } else {
            distanceInMeters = distanceInMeters * 0.000621371
        }
        return abs(Int(distanceInMeters))
    }

    //MARK:- Day Function
    static func getWeekDayInd(day:String) -> Int {
        switch day.lowercased() {
            case "sun":
                return Day.SUN.rawValue
            case "mon":
                return Day.MON.rawValue
            case "tue":
                return Day.TUE.rawValue
            case "wed":
                return Day.WED.rawValue
            case "thu":
                return Day.THU.rawValue
            case "fri":
                return Day.FRI.rawValue
            case "sat":
                return Day.SAT.rawValue
            default:
                return 0
        }
    }

    static func getDayFromDate(date:String) -> String {
        let dateString = date
        let formatter = DateFormatter()
        formatter.dateFormat = DATE_CONSTANT.DATE_FORMATE_WITHOUT_TIME
        guard let date = formatter.date(from: dateString) else {
            return ""
        }
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        return day
    }

    static func makeParticularStringColored(to givenFullString:String, colorString:String, textColor:UIColor, fontSize:CGFloat) -> NSMutableAttributedString {
        let mainString = givenFullString
        let range = (mainString as NSString).range(of: colorString)
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value:UIFont(name:"ClanPro-News", size:fontSize)!, range: NSMakeRange(0, mutableAttributedString.length))
        return mutableAttributedString
    }
    
    static func minuteToString(min:Int) -> String{
        let mins = (min % 60)
        let hours = (min - mins)/60

        var dateComponents = DateComponents()
        dateComponents.hour = hours
        dateComponents.minute = mins

        let calendar = Calendar.current
        let dt = calendar.date(from: dateComponents)

        return Utility.dateToString(date: dt ?? Date(), withFormat: DATE_CONSTANT.TIME_FORMAT)
    }

    static func stringToMinute(strDate:String) -> Int{
        let dt = Utility.stringToDate(strDate: strDate, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.minute, .hour], from: dt)
        return (comp.hour! * 60)+comp.minute!
    }

    static func getDynamicResizeImageURL(width:CGFloat, height:CGFloat, imgUrl:String) -> String{
        
        if imgUrl.count > 0{
            var imgFormat = ""
            if #available(iOS 14, *) {
                imgFormat = "webp"
            } else {
                imgFormat = "jpeg"
            }

            var str = ""
            if WebService.IS_USING_S3BUCKET{
                str = "resize_image?image=\(WebService.BASE_URL_ASSETS + imgUrl)&width=\(width)&height=\(height)&format=\(imgFormat)"
            }else{
                str = "resize_image?image=/\(imgUrl)&width=\(width)&height=\(height)&format=\(imgFormat)"
            }
            return str
        }else{
            return ""
        }
    }

    static func getHttpsHeaderForAPI() -> HTTPHeaders{
        var header: HTTPHeaders = [:]
        let OSVersion : String = UIDevice.current.systemVersion
        let currentAppVersion : String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        print(" lang = \(preferenceHelper.getSelectedLanguage())")
        if preferenceHelper.getUserId().count > 0{
            header = ["lang":"\(preferenceHelper.getSelectedLanguage())", "lang_code": "\(preferenceHelper.getSelectedLanguageCode())","type" : "7","userid":preferenceHelper.getUserId(),"os_version":OSVersion,"app_version":currentAppVersion,"app_code": "IOS","os_orientation": getDeviceOrientation(),"model": UIDevice.modelName]
        }else{
            header = ["lang":"\(preferenceHelper.getSelectedLanguage())", "lang_code": "\(preferenceHelper.getSelectedLanguageCode())","type" : "7","userid":"","os_version":OSVersion,"app_version":currentAppVersion,"app_code": "IOS","os_orientation": getDeviceOrientation(),"model": UIDevice.modelName]
        }
        print("Https Header \(header)")
        return header
    }
    
    static func getTax(itemAmount:Double, taxValue:Double) -> Double {
        if !currentBooking.isTaxIncluded{
            return itemAmount * taxValue * 0.01
        }else{
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
    }
    
    static func isProductExistInLocalCart(cartProductItems:CartProductItems, strProductId: String) -> (Bool,CartProduct?) {
        for cartProduct in currentBooking.cart {
            if (cartProduct.product_id?.compare(strProductId)) == .orderedSame {
                return (true,cartProduct)
            }
        }
        return (false,nil)
    }
    
    static func currentAppVersion() -> String {
        if let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return currentAppVersion
        }
        return ""
    }
    
    static func getLatestVersion() -> String {
        guard
            let info = Bundle.main.infoDictionary,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let versionString = results[0]["version"] as? String
            else { return "" }
        print("Latest Version:- \(versionString)")
        return versionString
    }

    static func getDeviceOrientation() -> String{
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
            return "landscapeLeft"
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
            return "landscapeRight"
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
            return "portraitUpsideDown"
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portrait{
            return "portrait"
        }else{
            return ""
        }
    }
    
    class func addToCart(objSection: ProductItem, objItem: ProductItemsItem, quantity: Int = 1, note: String = "", cartIndexPath: IndexPath? = nil, complition: @escaping () -> Void) {
        
        var arrCurrentAdded = [CartProductItems]()
        if currentBooking.cart.count > 0 {
            for obj in CurrentBooking.shared.cart {
                for item in (obj.items ?? []) {
                    arrCurrentAdded.append(item)
                }
            }
        }
        print(arrCurrentAdded)
        
        currentBooking.deliveryAddress = currentBooking.currentAddress
        currentBooking.deliveryLatLng = currentBooking.currentLatLng
        var specificationPriceTotal = 0.0
        var specificationPrice = 0.0
        var specificationList:[Specifications] = [Specifications].init()
        
        Utility.showLoading()
        for specificationListItem in (objItem.specifications ?? []) {
            
            var specificationItemCartList:[SpecificationListItem] = [SpecificationListItem].init()
            
            for listItem in specificationListItem.list! {
                print(listItem.name)
                print(listItem.is_default_selected)
                
                if (listItem.is_default_selected) {
                    specificationPrice = specificationPrice + (listItem.price! * Double(listItem.quantity))
                    specificationPriceTotal = specificationPriceTotal + (listItem.price! * Double(listItem.quantity))
                    specificationItemCartList.append(listItem)
                }
            }
            
            if !specificationItemCartList.isEmpty {
                let specificationsItem:Specifications = Specifications()
                specificationsItem.list = specificationItemCartList
                specificationsItem.unique_id = specificationListItem.unique_id
                specificationsItem.name = specificationListItem.name
                specificationsItem.price = specificationPrice
                specificationsItem.type = specificationListItem.type
                specificationsItem.range = specificationListItem.range
                specificationsItem.rangeMax = specificationListItem.rangeMax
                specificationsItem.is_required = specificationListItem.is_required
                

                specificationList.append(specificationsItem)
            }
            specificationPrice = 0
        }
        
        let cartProductItems:CartProductItems = CartProductItems.init()
        let currentSelectedProductItem = objItem
        
        cartProductItems.item_id = currentSelectedProductItem._id
        cartProductItems.unique_id = currentSelectedProductItem.unique_id
        cartProductItems.item_name = currentSelectedProductItem.name
        cartProductItems.quantity = quantity
        cartProductItems.image_url = currentSelectedProductItem.image_url
        cartProductItems.details = currentSelectedProductItem.details
        cartProductItems.specifications = specificationList
        cartProductItems.item_price = currentSelectedProductItem.price
        cartProductItems.total_specification_price = specificationPriceTotal
        cartProductItems.totalItemPrice = Double(objItem.quantity) * (objItem.price ?? 0)
        cartProductItems.taxDetails = currentSelectedProductItem.taxDetails
        cartProductItems.noteForItem = note
        cartProductItems.totalPrice = currentSelectedProductItem.price + specificationPriceTotal
        
        var tax = 0.0
        
        if cartIndexPath != nil {
            if !currentBooking.isUseItemTax {
                for obj in currentBooking.StoreTaxDetails {
                    tax = tax + Double(obj.tax)
                }
            }else{
                for obj in currentSelectedProductItem.taxDetails{
                    tax = tax + Double(obj.tax)
                }
            }
        }else{
            if !currentBooking.selectedStore!.isUseItemTax{
                for obj in currentBooking.selectedStore!.storeTaxDetails{
                    tax = tax + Double(obj.tax)
                }
            }else{
                for obj in currentSelectedProductItem.taxDetails{
                    tax = tax + Double(obj.tax)
                }
            }
        }
        
        print(tax)
        let itemTax = getTax(itemAmount: currentSelectedProductItem.price, taxValue: tax)
        let specificationTax = getTax(itemAmount: specificationPriceTotal, taxValue: tax)
        let totalTax = itemTax + specificationTax
        cartProductItems.tax = tax
        cartProductItems.itemTax = itemTax
        cartProductItems.totalSpecificationTax = specificationTax
        cartProductItems.totalTax = totalTax
        cartProductItems.totalItemTax = totalTax * Double(quantity)
        
        if cartIndexPath != nil {
            currentBooking.cart[cartIndexPath!.section].items![cartIndexPath!.row] = cartProductItems
            currentBooking.cart[cartIndexPath!.section].totalItemTax = cartProductItems.totalItemTax
        } else {
            if !(currentBooking.cartWithAllSpecification.contains(where: { (item) -> Bool in
                item._id == currentSelectedProductItem._id!
            })) {
                currentBooking.cartWithAllSpecification.append(currentSelectedProductItem)
            }
            
            let isAdded = arrCurrentAdded.filter { obj in
                if obj.getProductJson().isEqual(to: cartProductItems.getProductJson() as! [AnyHashable : Any]) {
                    return true
                }
                return false
            }

            if isAdded.count > 0 {
                var section = 0
                var row = 0
                
                for obj in currentBooking.cart {
                    for item in (obj.items ?? []) {
                        if isAdded[0].getProductJson().isEqual(to: item.getProductJson() as! [AnyHashable : Any]) {
                            section = currentBooking.cart.firstIndex(where: {$0.getProductJson() == obj.getProductJson()}) ?? 0
                            row = (obj.items ?? []).firstIndex(where: {$0.getProductJson() == item.getProductJson()}) ?? 0
                            print("break")
                            break
                        }
                    }
                }
                
                print("section \(section) row \(row)")
                
                currentBooking.cart[section].items![row] = cartProductItems
                currentBooking.cart[section].items![row].quantity = isAdded[0].quantity + quantity
                currentBooking.cart[section].items![row].totalItemTax = totalTax * Double((isAdded[0].quantity + quantity))
                
            }else {
                var cartProductItemsList:[CartProductItems] = [CartProductItems].init()
                cartProductItemsList.append(cartProductItems)
                let cartProducts:CartProduct = CartProduct.init()
                cartProducts.items = cartProductItemsList
                cartProducts.product_id = currentSelectedProductItem.product_id
                cartProducts.product_name = objSection.productDetail?.name
                cartProducts.unique_id = objSection.productDetail?.unique_id
                cartProducts.total_item_price = (objItem.price ?? 0.0) * Double(objItem.quantity)
                cartProducts.totalItemTax =  cartProductItems.totalItemTax
                currentBooking.cart.append(cartProducts)
                currentBooking.selectedStoreId = currentSelectedProductItem.store_id
            }
        }
    }
    
    ///Destination address array set first in currentBooking before calling
    class func wsAddItemInServerCart(complition: @escaping (NSDictionary, Any) -> Void) {
        
        let cartOrder:CartOrder = CartOrder.init()
        cartOrder.server_token = preferenceHelper.getSessionToken()
        cartOrder.user_id = preferenceHelper.getUserId()
        cartOrder.store_id = currentBooking.selectedStoreId ?? ""
        cartOrder.order_details = currentBooking.cart
        
        var totalPrice:Double = 0.0
        var totalTax:Double = 0.0
        for cartProduct in currentBooking.cart {
            totalTax = totalTax + cartProduct.totalItemTax
            totalPrice = totalPrice + (cartProduct.total_item_price ?? 0.0)
            
        }
        cartOrder.totalCartPrice =  totalPrice
        cartOrder.totalItemTax = totalTax
        
        if currentBooking.pickupAddress.isEmpty && (currentBooking.selectedStore != nil) {
            let mySelectedStore:StoreItem = currentBooking.selectedStore!
            let pickupAddress:Address = Address.init()
            pickupAddress.address = mySelectedStore.address
            pickupAddress.addressType = AddressType.PICKUP
            pickupAddress.userType = CONSTANT.TYPE_USER
            pickupAddress.note = ""
            pickupAddress.city = ""
            pickupAddress.location = mySelectedStore.location ?? [0.0,0.0]

            let cartStoreDetail:CartUserDetail = CartUserDetail()
            cartStoreDetail.email = mySelectedStore.email ?? ""
            cartStoreDetail.countryPhoneCode = mySelectedStore.country_phone_code ?? ""
            cartStoreDetail.name = mySelectedStore.name ?? ""
            cartStoreDetail.phone = mySelectedStore.phone ?? ""
            cartStoreDetail.imageUrl = mySelectedStore.image_url ?? ""
            pickupAddress.userDetails = cartStoreDetail
            
            currentBooking.pickupAddress = [pickupAddress]
        }

        cartOrder.pickupAddress = currentBooking.pickupAddress
        cartOrder.destinationAddress = currentBooking.destinationAddress
        if Utility.isTableBooking() || currentBooking.isQrCodeScanBooking {
            cartOrder.table_no = currentBooking.table_no
            cartOrder.table_id = currentBooking.tableID
            cartOrder.booking_type = currentBooking.bookingType
            cartOrder.delivery_type = DeliveryType.tableBooking
            currentBooking.deliveryType = DeliveryType.tableBooking
            cartOrder.no_of_persons = currentBooking.number_of_pepole
            cartOrder.order_start_at = currentBooking.futureDateMilliSecondTable
            cartOrder.order_start_at2 = currentBooking.futureDateMilliSecondTable2
        }

        let dictData:NSDictionary = (cartOrder.dictionaryRepresentation())
        dictData.setValue(currentBooking.isUseItemTax, forKey: PARAMS.IS_USE_ITEM_TAX)
        dictData.setValue(currentBooking.isTaxIncluded, forKey: PARAMS.IS_TAX_INCLUDED)
        dictData.setValue(currentBooking.totalCartAmountWithoutTax, forKey: PARAMS.TOTAL_CART_AMOUNT_WITHOUT_TAX)

        print(Utility.convertDictToJson(dict: dictData as! Dictionary<String, Any>))

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ADD_ITEM_IN_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictData as? Dictionary<String, Any>) { (response,error) -> (Void) in
            complition(response,error)
        }
    }
}

extension UITextView {
    func hyperLink(originalText: String, hyperLink: String, urlString: String) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "ClanPro-News", size: FontHelper.labelRegular), range: fullRange)
        
        attributedOriginalText.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.themeTextColor], range: fullRange)

        self.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.themeColor
        ]
        self.attributedText = attributedOriginalText
    }

    func hyperLinkWithBGColor(originalText: String, hyperLink: String, hyperLink2: String, urlString: String, urlString2: String) {
        let mutable = NSMutableAttributedString(string: originalText)
        //        let linkRange = originalText.mutableString.range(of: hyperLink)
        var startIndex = originalText.startIndex
        while let range = originalText.range(of: "\\S+", options: .regularExpression, range: startIndex..<originalText.endIndex) {
            mutable.addAttribute(.backgroundColor, value: UIColor.cyan, range: NSRange(range, in: originalText))
            startIndex = range.upperBound
        }
        self.attributedText = mutable
    }
}

class CustomBottomButton : UIButton
{
    func setup() {
        self.titleLabel?.font = FontHelper.buttonText()
        self.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        self.backgroundColor = UIColor.themeColor
        self.setRound(withBorderColor: UIColor.clear, andCornerRadious: self.frame.size.height/2.0, borderWidth: 1.0)
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
class CustomSeperator : UILabel
{
    func setup() {
        self.text = ""
        self.backgroundColor = UIColor.themeSeperatorColor
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
class CustomVerticalSeperator : UILabel
{
    func setup() {
        self.text = ""
        self.backgroundColor = UIColor.themeLightGrayColor
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

class CustomTextfield : SkyFloatingLabelTextField
{
    func setup() {
        
        self.placeholderColor = .themeLightTextColor
        self.lineColor = .themeLightTextColor
        self.titleColor = .themeLightTextColor
        self.textColor = .themeTextColor
        self.selectedTitleColor = .themeLightTextColor
        self.selectedLineColor = .themeLightTextColor
        self.errorColor = .themeRedColor
        self.tintColor = .themeTextColor
    }
    
    
    override func awakeFromNib() {
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

class CustomMobileNumberTextfield : UITextField
{
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            if action == #selector(UIResponderStandardEditActions.paste(_:))
            {
                return false
            }
            return super.canPerformAction(action, withSender: sender)
       }
}

class CustomButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -10, dy: -10).contains(point)
    }

}

extension UIViewController {
    var topBarHeight: CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        if #available(iOS 13.0, *) {
            top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        return top + (UINavigationController().navigationBar.frame.height)
    }
}


@IBDesignable
class ShadowWithCornerView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 25.0 {
        didSet {
            setShadow()
        }
    }
    
    @IBInspectable
    var fillColor: UIColor = UIColor.themeViewBackgroundColor {
        didSet {
            setShadow()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor = UIColor.gray {
        didSet {
            setShadow()
        }
    }
    
    @IBInspectable
    var shadowOffSetX: CGFloat = 0 {
        didSet {
            setShadow()
        }
    }
    
    @IBInspectable
    var shadowOffSetY: CGFloat = -2 {
        didSet {
            setShadow()
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = 0.3 {
        didSet {
            setShadow()
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = 6 {
        didSet {
            setShadow()
        }
    }
    
    var shadowLayer: CAShapeLayer!
     
    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer != nil {
            shadowLayer.removeFromSuperlayer()
        }
        shadowLayer = CAShapeLayer()
        setShadowInMainThred()
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func setShadowInMainThred(byCorner: UIRectCorner = [.topLeft, .topRight]) {
        
        if shadowLayer != nil {
            shadowLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: byCorner, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            shadowLayer.fillColor = fillColor.cgColor

            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: shadowOffSetX, height: shadowOffSetY)
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowRadius = shadowRadius
            self.backgroundColor = .clear
        }
            
        //layoutSubviews()
    }
}

class EdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
