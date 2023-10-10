//
//  Utility.swift
//  tableViewDemo
//
//  Created by Jaydeep Vyas on 12/01/17.
//  Copyright © 2017 tag. All rights reserved.
//

import UIKit
//import AlamofireImage
import Alamofire
import Printer


class Utility: NSObject
 {
    static var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    static var overlayView = UIView();
    static var mainView = UIView();
    override init(){

    }
    
    class func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    static  func checkImageSize(image:UIImage,maxWidth :Int, maxHeight:Int, minWidth:Int,
    minHeight:Int) -> Bool
     {
            let imageHeight:Int = Int((image.size.height * image.scale).rounded())
        let imageWidth:Int = Int((image.size.width * image.scale).rounded())
        
    
    let imageRatio = imageWidth / imageHeight;
    let requiredRatio = maxWidth / maxHeight;
        
    return imageHeight <= maxHeight && imageHeight >=
    minHeight && imageWidth <= maxWidth && imageWidth >= minWidth
    && imageRatio == requiredRatio
    
    }

    static func getListFromYear(year:Int) -> [(Date,Date)] {
        let cal = Calendar.current
        
        var myDateSelectionArray = Array<(Date,Date)>()
        
        let startDateComponents = DateComponents.init(calendar: nil, timeZone: nil, era: nil, year: nil, month: nil, day: 1, hour: 12, minute: 00, second: 00, nanosecond: 00, weekday: 1, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: year)
        
        let stopDateComponents = DateComponents.init(calendar: nil, timeZone: nil, era: nil, year: nil, month: 12, day: 31, hour: 12, minute: 00, second: 00, nanosecond: 00, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: year)

        let startDate = cal.date(from: startDateComponents)!
        var stopDate = cal.date(from: stopDateComponents)!
        if stopDate > Date() {
            stopDate = Date()
        }
        var comps = DateComponents()
        comps.weekday = 1
        // Sunday
        
        cal.enumerateDates(startingAfter: startDate, matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents, repeatedTimePolicy: .first, direction: .forward) { (date, match, stop) in
            if let sundayDate = date {
                if sundayDate > stopDate {
                    stop = true
                }
                else {
                    let d:DateFormatter = DateFormatter()
                    d.dateFormat = "dd-MMM yyyy"
                    let nextSaturday = cal.date(byAdding: .day, value: 6, to: sundayDate)!
                    myDateSelectionArray.append((sundayDate,nextSaturday))
                }
            }
            
        }
        myDateSelectionArray.reverse()
        return myDateSelectionArray
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
                    
                }
                else {
                    overlayView.center = (UIApplication.shared.keyWindow?.center)!
                    mainView.tag = 701
                    UIApplication.shared.keyWindow?.addSubview(mainView)
                    activityIndicator.startAnimating()
                }
            }
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating();
            UIApplication.shared.keyWindow?.viewWithTag(701)?.removeFromSuperview()
        }
    }

    static func showToast(message:String, backgroundColor:UIColor = UIColor.black, textColor:UIColor = UIColor.white) {
        if !message.isEmpty() {
            DispatchQueue.main.async {
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate;
                let label = UILabel(frame: CGRect.zero);
                label.textAlignment = NSTextAlignment.center;
                label.text = message;
                label.adjustsFontSizeToFitWidth = true;
                label.backgroundColor =  backgroundColor; //UIColor.whiteColor()
                label.textColor = textColor; //TEXT COLOR
                label.sizeToFit()
                label.numberOfLines = 4
                label.layer.shadowColor = UIColor.gray.cgColor;
                label.layer.shadowOffset = CGSize.init(width: 4, height: 3)
                label.layer.shadowOpacity = 0.3;
                label.frame = CGRect.init(x: 0, y: (appDelegate.window?.frame.maxY)!, width:  appDelegate.window!.frame.size.width, height: 44);
                label.alpha = 1

                UIApplication.shared.keyWindow?.endEditing(true)
                UIApplication.shared.windows.last?.endEditing(true)

                var window: UIWindow?
                if let keyWindow = UIApplication.shared.keyWindow {
                    window = keyWindow
                } else {
                    window = UIApplication.shared.windows.last
                }
                window?.addSubview(label)

                var basketTopFrame: CGRect = label.frame;
                basketTopFrame.origin.x = 0;
                basketTopFrame.origin.y = (appDelegate.window?.frame.maxY)! - label.frame.height;

                UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                    label.frame = basketTopFrame
                },  completion: {
                    (value: Bool) in
                    UIView.animate(withDuration: 2.0, delay: 2.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                        label.alpha = 0
                    },  completion: {
                        (value: Bool) in
                        label.removeFromSuperview()
                    })
                })
            }
        }
    }

    static func conteverDictToJson(dict:Dictionary<String, Any>) -> Void{
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
    }

    //MARK:- DATE UTILITY FUNCTIONS
    static func relativeDateStringForDate(strDate: String) -> NSString{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = dateFormatter.string(from:NSDate() as Date)
        
        let calender : NSCalendar = NSCalendar.init(identifier:.gregorian)!
        
        let dayComponent = NSDateComponents()
        
        dayComponent.day = -1
        
        let date:Date = calender.date(byAdding:dayComponent as DateComponents, to: NSDate() as Date, options: NSCalendar.Options(rawValue: 0))!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strYesterdatDate = dateFormatter.string(from:date as Date)
        
        if(strDate == currentDate) {
            return "TXT_TODAY".localized as NSString
        }else if(strDate == strYesterdatDate) {
            return "TXT_YESTERDAY".localized as NSString
        }else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.ReferenceType.default
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: strDate)
            let myCurrentDate = Utility.convertDateFormate(date: date!)
            print(myCurrentDate)
            return myCurrentDate as NSString
        }
    }
    static func convertDateFormate(date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.timeZone = TimeZone.ReferenceType.default
        
        dateFormate.dateFormat = "MMMM, yyyy"
        let newDate = dateFormate.string(from: date)
        
        var day  = "\(anchorComponents.day!)"
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
    static func stringToString(strDate:String, fromFormat:String, toFormat:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC") ?? TimeZone(identifier: "UTC") ??  TimeZone.ReferenceType.default
        
        dateFormatter.dateFormat = fromFormat
        let currentDate = dateFormatter.date(from: strDate) ?? Date()
        dateFormatter.dateFormat =  toFormat
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        let currentDates = dateFormatter.string(from: currentDate)
        return currentDates

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
    static func convertDateToYourTimezone(strDate:String, fromFormat:String, toFormat:String, withTimeZone:String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC") ?? TimeZone(identifier: "UTC") ?? TimeZone.init(identifier: withTimeZone) ?? TimeZone.init(abbreviation: withTimeZone) ?? TimeZone.ReferenceType.default
        dateFormatter.dateFormat = fromFormat
        let currentDate = dateFormatter.date(from: strDate) ?? Date()
        dateFormatter.dateFormat =  toFormat
        dateFormatter.timeZone = TimeZone.init(identifier: withTimeZone) ?? TimeZone.init(abbreviation: withTimeZone) ?? TimeZone.ReferenceType.default
        let currentDates = dateFormatter.string(from: currentDate)
        return currentDates
        
    }
    static func dateToString(date: Date, withFormat:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        dateFormatter.dateFormat = withFormat
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    static func stringToDate(strDate: String, withFormat:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        dateFormatter.dateFormat = withFormat
        return dateFormatter.date(from: strDate) ?? Date.init()
        
    }
   
    static func stringToMilisecond(strDate:String) -> Int64{
        let str = Utility.stringToString(strDate: strDate, fromFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM, toFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM);
        let date = Utility.stringToDate(strDate: str, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM);
        let since1970 = date.timeIntervalSince1970
    
        return Int64(since1970 * 1000)
     }
    static func stringToMinute(strDate:String) -> Int{
           let dt = Utility.stringToDate(strDate: strDate, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
           let calendar = Calendar.current
           let comp = calendar.dateComponents([.minute, .hour], from: dt)
           return (comp.hour! * 60)+comp.minute!
        }
    
    static func minuteToString(min:Int) -> String{
        let mins = (min % 60)
        let hours = (min - mins)/60

        var dateComponents = DateComponents()
        dateComponents.hour = hours
        dateComponents.minute = mins

        let calendar = Calendar.current
        let dt = calendar.date(from: dateComponents)

        print(Utility.dateToString(date: dt ?? Date(), withFormat: DATE_CONSTANT.TIME_FORMAT))
        return Utility.dateToString(date: dt ?? Date(), withFormat: DATE_CONSTANT.TIME_FORMAT)
    }
    static func secondsToHoursMinutes(seconds : Int64) -> String {
        return "\(seconds / 3600) hr \((seconds % 3600) / 60) min"
    }
    static func minutToHoursMinutes(minut : Double) -> String {
        
        let seconds =  Int64.init(minut * 60)
        return "\(seconds / 3600) : \((seconds % 3600) / 60) min"
    }
    
    static func dateCompontentToMilisecond(dateComponent:DateComponents,futureDateComponent:DateComponents)->Int {
        let intervel = Calendar.current.dateComponents([.second], from: (dateComponent.date)!, to: (futureDateComponent.date)!).second ?? 0
        return abs(intervel * 1000)
    }
    static func convertServerDateToMilliSecond(serverDate:String,strTimeZone:String)-> Int64 {
        let dateFor = DateFormatter()
        dateFor.timeZone = TimeZone.init(abbreviation: "UTC") ?? TimeZone(identifier: "UTC") ?? TimeZone.ReferenceType.default
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFor.date(from: serverDate) ?? Date()
        let timezone = TimeZone.init(identifier: strTimeZone) ?? TimeZone.ReferenceType.default
        let offSetMiliSecond = Int64(timezone.secondsFromGMT() * 1000)
        let finalServerMilli =   Int64(  Int64((date.timeIntervalSince1970) * 1000) +  offSetMiliSecond)
        return finalServerMilli
    }
    
    static func convertSelectedDateToMilliSecond(serverDate:Date,strTimeZone:String)-> Int64 {
        let timezone = TimeZone.init(identifier: strTimeZone) ?? TimeZone.ReferenceType.default
        let offSetMiliSecond = Int64(timezone.secondsFromGMT() * 1000)
        let finalSelectedDateMilli =   Int64(  Int64(serverDate.timeIntervalSince1970) * 1000 +  offSetMiliSecond)
        return finalSelectedDateMilli
    }

    static func millisecondToDateComponents(milliSeconds:Int64) -> DateComponents {
        let selectedDate:Date =  Date(timeIntervalSince1970: Double(milliSeconds/1000))
        let timeZone = TimeZone.init(abbreviation: "UTC") ?? TimeZone(identifier: "UTC") ?? TimeZone.ReferenceType.default
        let component:DateComponents = Calendar.current.dateComponents(in:timeZone, from: selectedDate)
        return component
    }
    
    static func dateToMiliseconds(date:Date)-> Int64 {
        let since1970 = date.timeIntervalSince1970
        return Int64(since1970 * 1000)
        
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
    
    static func isStoreOpen(storeTime:[StoreTime],milliSeconds:Int64) -> (Bool,String) {

        let components = Utility.millisecondToDateComponents(milliSeconds: milliSeconds)
        let weekday = (components.weekday! - 1)
        
        let currentcomponents = Utility.millisecondToDateComponents(milliSeconds: StoreSingleton.shared.currentDateMilliSecond)
        let currentweekday = (currentcomponents.weekday! - 1)
        
        
        
        let currentDate:Date = Calendar.current.date(bySettingHour: components.hour ?? 0, minute: components.minute ?? 0, second: 0, of: Date()) ?? Date()
        
        
        let currentTime:Int64 = Utility.dateToMiliseconds(date: currentDate)
        var nextOpenTime = "";
        if let selectedStoreDay:StoreTime = storeTime.first(where: {$0.day == weekday}) {
            if selectedStoreDay.isStoreOpenFullTime {
                return (true,"")
            }else {
                if selectedStoreDay.isStoreOpen {
                    let dayTime : [DayTime] = selectedStoreDay.dayTime
                    if dayTime.isEmpty
                    {
                        return (false,"TXT_STORE_IS_CLOSED_ON".localized + (Day(rawValue:weekday)?.text())!)
                    }
                    else
                    {
                        var isStoreClosed = true;
                        for store_time:DayTime in dayTime
                        {
                            let open_time = store_time.storeOpenTime.components(separatedBy: ":");
                            
                            let x:Date = Calendar.current.date(bySettingHour: open_time[0].integerValue!, minute: open_time[1].integerValue!, second: 0, of: currentDate)!
                            let x2 = Utility.dateToMiliseconds(date: x)
                            
                            let close_time = store_time.storeCloseTime.components(separatedBy: ":");
                            
                            let y:Date = Calendar.current.date(bySettingHour: close_time[0].integerValue!, minute: close_time[1].integerValue!, second: 0, of: currentDate)!
                            
                            let y2 = Utility.dateToMiliseconds(date: y)
                            
                            if(currentTime > x2 && currentTime < y2)
                            {
                                isStoreClosed = false
                                break;
                            }
                            
                            if(currentTime < x2 && nextOpenTime.isEmpty()) {
                                nextOpenTime = store_time.storeOpenTime
                                break;
                            }
                        }
                        
                        if nextOpenTime.isEmpty() && isStoreClosed
                        {
                            if (weekday - currentweekday) == 0
                            {
                                
                                nextOpenTime  = "TXT_STORE_IS_CLOSED_ON".localized + "TODAY".localizedCapitalized
                                
                            }
                            else {
                                nextOpenTime  = "TXT_STORE_IS_CLOSED_ON".localized + (Day(rawValue:weekday)?.text())!
                            }
                        }
                        else {
                            nextOpenTime = "TXT_REOPEN_AT".localized + " " + nextOpenTime
                        }
                        return (!isStoreClosed,nextOpenTime)
                    }
                }
                else {
                    if (weekday - currentweekday) == 0 {
                        nextOpenTime  = "TXT_STORE_IS_CLOSED_ON".localized + "TODAY".localizedCapitalized
                    }
                    else {
                        nextOpenTime  = "TXT_STORE_IS_CLOSED_ON".localized + (Day(rawValue:weekday)?.text())!
                    }
                    return (false,nextOpenTime)
                }
            }
        }
        return (true,"")
    }
    
    //MARK: - Other Utility Functions
    static func setTabbarProperties(tabbar:UITabBar) -> Void{
        
        let size = CGSize.init(width:(tabbar.frame.size.width/2), height:tabbar.frame.size.height);
        let lineSize =  CGSize.init(width:(tabbar.frame.size.width/2), height:2);
        let rect = CGRect.init(x:0, y:10, width:size.width,height: size.height);
        let rectLine = CGRect.init(x:0, y:size.height-lineSize.height,width:lineSize.width,height:lineSize.height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.clear.setFill();
        UIRectFill(rect);
        UIColor.black.setFill();
        UIRectFill(rectLine);
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        tabbar.shadowImage = UIImage();
        tabbar.backgroundImage = UIImage();
        tabbar.barTintColor = UIColor.themeViewBackgroundColor;
        tabbar.selectionIndicatorImage = image;
        tabbar.layer.shadowColor = UIColor.themeLightTextColor.cgColor;
        tabbar.layer.shadowOffset = CGSize.init(width: 0, height: 0.7);
        tabbar.layer.shadowOpacity = 0.6;
        tabbar.layer.shadowRadius = 0.5;
        tabbar.layer.borderWidth = 0.0;
        tabbar.layer.borderColor = UIColor.clear.cgColor;
        tabbar.isTranslucent = false;
        
    }
    static func setupButton(button: UIButton){
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        let spacing: CGFloat = 5.0
        let imageSize: CGSize = (button.imageView?.image?.size) ?? CGSize.init(width: 25.0, height: 25.0)
        
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: button.titleLabel?.text ?? "abcd")
        let titleSize = labelString.size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): button.titleLabel?.font ?? FontHelper.textSmall()]))
        button.imageEdgeInsets = UIEdgeInsets.init(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        button.contentEdgeInsets = UIEdgeInsets.init(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
 }
   //MARK:
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
        return image!;
    }
   
    //Replaced
    static func downloadImageFrom(link:String, completion: @escaping (_ result: UIImage) -> Void) {
        if link.isEmpty() {
            return  completion(UIImage.init(named: "provider_pin")!)
        }
       
        else {
            let urlStr = WebService.BASE_URL +  link
            let urlRequest = URLRequest(url: URL(string: urlStr)!)
            AF.request(URL(string: urlStr)!, method: .get).responseData { response in
                if let data = response.value {
                    let width = (UIScreen.main.bounds.width * 0.07)
                    let height = width/0.45
                    let size = CGSize.init(width: width, height: height)
                    
                    let image = UIImage(data: data)

                    let newImage = image?.sd_resizedImage(with: size, scaleMode: .aspectFit)
                    if newImage != nil{
                        completion(newImage!)
                    }else{
                        completion(UIImage.init(named: "provider_pin")!)
                    }
                    
                } else {
                    completion(UIImage.init(named: "provider_pin")!)
                }
            }
        }
    }
//            /*let urlStr = WebService.BASE_URL +  link
//            let urlRequest = URLRequest(url: URL(string: urlStr)!)
//            
//            Alamofire.download(URL(string: urlStr)!).responseData { response in
//                       if let data = response.result.value {
//                               let width = (UIScreen.main.bounds.width * 0.07)
//                               let height = width/0.45
//                               let size = CGSize.init(width: width, height: height)
//                               
//                               let image = UIImage(data: data)
//
//                        let newImage = image?.sd_resizedImage(with: size, scaleMode: .aspectFit)
//                        completion(newImage!)
//                           
//                       } else {
//                           completion(UIImage())
//                       }
//                   }*/
//
//            //storeapp //updated Alamofire version
//           /* downloader.download(urlRequest) { response in
//                
//                if let image = response.result.value {
//                    let width = (UIScreen.main.bounds.width * 0.07)
//                    let height = width/0.45
//                    let size = CGSize.init(width: width, height: height)
//                    
//                    
//                    let newImage = image.af_imageAspectScaled(toFit: size)
//                    completion(newImage)
//                }
//            }
//            */
//        }
//    }
    
   
    static func getDynamicImageURL(width:CGFloat, height:CGFloat, imgUrl:String) -> String{
//        let str = "resize_image?image=/\(imgUrl)&width=\(width)&height=\(height)&format=webp"
//        return str
        
        if imgUrl.count > 0{
           var imgFormat = ""
           if #available(iOS 14, *) {
               imgFormat = "webp"
           } else {
               imgFormat = "jpeg"
           }

           let str = "resize_image?image=/\(imgUrl)&width=\(width)&height=\(height)&format=\(imgFormat)"

            return str
        }else{
            return ""
        }
    }
    
   static func resize(image:UIImage) -> UIImage {
        let width = (UIScreen.main.bounds.width * 0.07)
        let height = width/0.45
        
        let newSize = CGSize.init(width: width, height: height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect.init(x: 0.0, y: 0.0, width: width, height: height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }

    static func getHttpsHeaderForAPI() -> HTTPHeaders{
        var header: HTTPHeaders = [:]
        let OSVersion : String = UIDevice.current.systemVersion
        let currentAppVersion : String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        print(" lang = \(arrForLanguages[preferenceHelper.getLanguage()].code)")
        print(" AdminLanguageCodeSelected = \(ConstantsLang.AdminLanguageCodeSelected)")

        if preferenceHelper.getIsSubStoreLogin() {
           if preferenceHelper.getUserId().count > 0{
               header = ["lang":"\(preferenceHelper.getLanguageAdminInd())", "lang_code": "\(preferenceHelper.getLanguageAdminLang())", "type" : "1","id":preferenceHelper.getSubStoreId(),"storeid":preferenceHelper.getUserId(),"token":preferenceHelper.getSessionToken(),"os_version":OSVersion,"app_version":currentAppVersion,"app_code": "IOS","os_orientation": getDeviceOrientation(),"model": UIDevice.modelName,"userid":preferenceHelper.getUserId()]
           }else{
               header = ["lang":"\(preferenceHelper.getLanguageAdminInd())", "lang_code": "\(preferenceHelper.getLanguageAdminLang())","type" : "1","os_version":OSVersion,"app_version":currentAppVersion,"app_code": "IOS","os_orientation": getDeviceOrientation(),"model": UIDevice.modelName]
           }
           print("Https Header \(header)")
           return header
        }else{
            if preferenceHelper.getUserId().count > 0{
                header = ["lang":"\(preferenceHelper.getLanguageAdminInd())", "lang_code": "\(preferenceHelper.getLanguageAdminLang())","type" : "0","storeid":preferenceHelper.getUserId(),"token":preferenceHelper.getSessionToken(),"os_version":OSVersion,"app_version":currentAppVersion,"app_code": "IOS","os_orientation": getDeviceOrientation(),"model": UIDevice.modelName,"userid":preferenceHelper.getUserId()]
            }else{
                header = ["lang":"\(preferenceHelper.getLanguageAdminInd())", "lang_code": "\(preferenceHelper.getLanguageAdminLang())","type" : "0","os_version":OSVersion,"app_version":currentAppVersion,"app_code": "IOS","os_orientation": getDeviceOrientation(),"model": UIDevice.modelName]
            }
            print("Https Header \(header)")
            return header
        }
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
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
