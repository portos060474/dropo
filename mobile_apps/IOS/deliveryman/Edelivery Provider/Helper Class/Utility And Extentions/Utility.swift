//
//  Utility.swift
//
//  Created by Elluminati on 12/01/17.
//  Copyright © 2017 tag. All rights reserved.
//

import UIKit
import Alamofire

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
                
                if APPDELEGATE.window?.viewWithTag(101) != nil {
                    
                }else {
                    overlayView.center = (UIApplication.shared.keyWindow?.center)!
                    mainView.tag = 101
                    UIApplication.shared.keyWindow?.addSubview(mainView)
                    activityIndicator.startAnimating()
                }
            }
        }
    }

    static func hideLoading(){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating();
            UIApplication.shared.keyWindow?.viewWithTag(101)?.removeFromSuperview()
        }
    }

    static func showToast(message:String, backgroundColor:UIColor = UIColor.black, textColor:UIColor = UIColor.white) {
        if !message.isEmpty {
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

    static func conteverDictToJson(dict:Dictionary<String, Any>) -> Void {
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        _ = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
    }

    //MARK:- DATE/TIME UTILITY FUNCTIONS
    static func relativeDateStringForDate(strDate: String) -> String {
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
            return "TXT_TODAY".localizedCapitalized
        } else if(strDate == strYesterdatDate) {
            return "TXT_YESTERDAY".localizedCapitalized
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.ReferenceType.default
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: strDate)
            let myCurrentDate = Utility.convertDateFormate(date: date!)
            return myCurrentDate
        }
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    static func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }

    static func convertDateFormate(date : Date) -> String {
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

    static func stringToString(strDate:String, fromFormat:String, toFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC") ?? TimeZone(identifier: "UTC") ?? TimeZone.ReferenceType.default
        dateFormatter.dateFormat = fromFormat
        let currentDate = dateFormatter.date(from: strDate) ?? Date()
        dateFormatter.dateFormat =  toFormat
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        let currentDates = dateFormatter.string(from: currentDate)
        return currentDates
    }

    static func dateToString(date: Date, withFormat:String) -> String {
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
        return dateFormatter.date(from: strDate) ?? Date()
    }

    static func currentTimeInMilisecondsOfHHMM() -> UInt64 {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        dateFormatter.dateFormat = DATE_CONSTANT.TIME_FORMAT_HH_MM
        let currentDate = dateFormatter.string(from: Date())
        let date = dateFormatter.date(from: currentDate)
        let since1970 = date?.timeIntervalSince1970
         return UInt64(since1970! * 1000)
    }

    static func stringToMilisecond(strDate:String) -> UInt64 {
        let str = Utility.stringToString(strDate: strDate, fromFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM, toFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM);
        let date = Utility.stringToDate(strDate: str, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM);
        let since1970 = date.timeIntervalSince1970
        return UInt64(since1970 * 1000)
    }

    static func secondsToHoursMinutes(seconds : Int64) -> String {
        return "\(seconds / 3600) hr \((seconds % 3600) / 60) min"
    }

    static func minutToHoursMinutes(minut : Double) -> String {
        let seconds =  Int64.init(minut * 60)
        return "\(seconds / 3600) : \((seconds % 3600) / 60)"
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
                }else {
                    let d:DateFormatter = DateFormatter()
                    d.dateFormat = "dd MMM yyyy"
                    let nextSaturday = cal.date(byAdding: .day, value: 6, to: sundayDate)!
                    myDateSelectionArray.append((sundayDate,nextSaturday))
                }
            }
            
        }
        myDateSelectionArray.reverse()
      return myDateSelectionArray
    }
    static func maskWithColor(color: UIColor, image: UIImage) -> UIImage?{
        let maskImage = image.cgImage!
        let width = image.size.width
        let height = image.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    //MARK:
    //MARK: - Button Properties
        static func setupButton(button: UIButton){
            
            button.semanticContentAttribute = .forceLeftToRight
            
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
    //MARK: download image
    /*static func downloadImageFrom(link:String, completion: @escaping (_ result: UIImage) -> Void) {
        if link.isEmpty {
            return  completion(UIImage.init(named: "driver_pin_icon")!)
        }else {
       let urlStr = WebService.BASE_URL +  link
        guard let url = URL(string: urlStr) else {
            return completion(UIImage.init(named: "driver_pin_icon")!)
        }
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return completion(UIImage.init(named: "driver_pin_icon")!)
            }
            guard response != nil else {
                print("no response")
                return completion(UIImage.init(named: "driver_pin_icon")!)
            }
            guard data != nil else {
                print("no data")
                return completion(UIImage.init(named: "driver_pin_icon")!)
            }
            DispatchQueue.main.async {
                
                let image = UIImage.init(data: data!) ?? UIImage.init(named: "driver_pin_icon")!
                // This is the rect that we've calculated out and this is what is actually used below
                let rect = CGRect(x: 0, y: 0, width: 30, height:45)
                
                // Actually do the resizing to the rect using the ImageContext stuff
                UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 30, height: 45), false, 1.0)
                image.draw(in: rect)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                completion(newImage!)
            }
        }; task.resume()
        }
        
   }*/
    
    //Replaced //change //Resizing issue //deliverymanapp
    static func downloadImageFrom(link:String, completion: @escaping (_ result: UIImage) -> Void) {
        if link.isEmpty() {
            return  completion(UIImage.init(named: "driver_pin_icon")!)
        }
       
        else {
            let urlStr = WebService.BASE_URL +  link
            _ = URLRequest(url: URL(string: urlStr)!)
            AF.request(URL(string: urlStr)!, method: .get).responseData { response in
                if let data = response.value {
                    let width = (UIScreen.main.bounds.width * 0.07)
                    let height = width/0.45
                    let size = CGSize.init(width: width, height: height)
                    
                    let image = UIImage(data: data)

                    let newImage = image?.jd_imageAspectScaled(toFit: size)
                    if newImage != nil{
                        completion(newImage!)
                    }else{
                        completion(UIImage.init(named: "driver_pin_icon")!)
                    }
                    
                } else {
                    completion(UIImage.init(named: "driver_pin_icon")!)
                }
            }
        }
    }

    static func getHttpsHeaderForAPI() -> HTTPHeaders{
        var header: HTTPHeaders = [:]
        let OSVersion : String = UIDevice.current.systemVersion
        let currentAppVersion : String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        print(" lang = \(preferenceHelper.getLanguage())")
        if preferenceHelper.getUserId().count > 0{
            header = ["lang":"\(preferenceHelper.getLanguage())", "lang_code" : "\(LocalizeLanguage.currentLanguage())","type" : "0","storeid":preferenceHelper.getUserId(),"token":preferenceHelper.getSessionToken(),"os_version":OSVersion,"app_version":currentAppVersion,"app_code": "IOS","os_orientation": getDeviceOrientation(),"model": UIDevice.modelName,"userid":preferenceHelper.getUserId()]
        }else{
            header = ["lang":"\(preferenceHelper.getLanguage())", "lang_code" : "\(LocalizeLanguage.currentLanguage())","type" : "0","os_version":OSVersion,"app_version":currentAppVersion,"app_code": "IOS","os_orientation": getDeviceOrientation(),"model": UIDevice.modelName]
        }
        print("Https Header \(header)")
        return header
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

public extension UITableView {
    func register(cellType: UITableViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func register(cellTypes: [UITableViewCell.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}

public extension UICollectionView {
    func register(cellType: UICollectionViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }
}

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

public extension NSObjectProtocol {
    var describedProperty: String {
        let mirror = Mirror(reflecting: self)
        return mirror.children.map { element -> String in
            let key = element.label ?? "Unknown"
            let value = element.value
            return "\(key): \(value)"
            }
            .joined(separator: "\n")
    }
}
