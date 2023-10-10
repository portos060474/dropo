//
//  AppDelegate.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 15/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import UserNotifications
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
//import Fabric
//import Crashlytics
import FirebaseCrashlytics
//import TwitterKit
//import TwitterCore
import Alamofire
import Firebase
import FirebaseMessaging
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {
    var window: UIWindow?
    var reachability: Reachability?;
    var dialogForAcceptRequest:CustomRequestDialog? = nil
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    var isOpenThroughPush:Bool = false
    let gcmMessageIDKey = "gcm.message_id"

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EDeliveryProvider")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK:
    //MARK: Application Delegate Method
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.launchOptions = launchOptions
       /* if #available(iOS 13.0, *) {
         
         if preferenceHelper.getIsDarkModeOn() {
             window?.overrideUserInterfaceStyle = .dark
         }
         else {
             window?.overrideUserInterfaceStyle = .light
         }
         
     }*/
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 11.0, *) {
            UIColor.setColors()
        } 
        GMSServices.provideAPIKey(Google.MAP_KEY)
        setupIQKeyboard()
        setupNavigationbar()
        setupTabbar()
        UIApplication.shared.isIdleTimerDisabled = true
        UISwitch.appearance().tintColor = UIColor.themeSwitchTintColor
        UISwitch.appearance().onTintColor = UIColor.themeColor
        Localizer.doTheMagic()

        //Fabric.with([Crashlytics.self])
        
        self.reachability = Reachability.init();
        do {
            try self.reachability?.startNotifier()
        }
        catch {
            print(error)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
              
        let pushNotificationData = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary
        if pushNotificationData != nil {
            if let aps:NSDictionary = (pushNotificationData?[AnyHashable("aps")] as? NSDictionary) {
                if let alert:NSDictionary = (aps["alert"] as? NSDictionary) {
                    if let id = alert["id"] as? String {
                        self.addPushDataToDB(id: id)
                    }
                }
            }
        }
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationWillResignActive(_ application: UIApplication){
       // AppEvents.activateApp()
    }
    //MARK: Facebook & Google Login
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool    {
        
        let googleDidHandle = GIDSignIn.sharedInstance.handle(url)
        let facebookDidHandle = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return googleDidHandle || facebookDidHandle
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications: [UNNotification]) in
            for request in notifications {
                print("Pending notifications : \(request.request.content.userInfo)")
                if let aps:NSDictionary = (request.request.content.userInfo[AnyHashable("aps")] as? NSDictionary) {
                    if let alert:NSDictionary = (aps["alert"] as? NSDictionary) {
                        if let id = alert["id"] as? String {
                            //self.addPushDataToDB(id: id)
                        }
                    }
                }
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    //MARK:
    //MARK: Go to Main
    //MARK:
    //MARK: Reachability Changed
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            closeNetworkDialog()
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
            openNetworkDialog()
        }
    }

    //MARK:- Dialog for Network
    func openNetworkDialog () {
        let dialogForNetwork  = CustomAlertDialog.showCustomAlertDialog(title: "TXT_INTERNET".localizedUppercase, message: "MSG_INTERNET_ENABLE".localized, titleLeftButton: "TXT_EXIT".localized, titleRightButton: "TXT_EXIT".localized.localized,isAnimation : false, tag: 501)
        dialogForNetwork.onClickLeftButton = { [unowned dialogForNetwork] in
            dialogForNetwork.removeFromSuperview();
            exit(0)
        }
        dialogForNetwork.onClickRightButton = { [unowned dialogForNetwork] in
            dialogForNetwork.removeFromSuperview();
            exit(0)
        }
    }

    func closeNetworkDialog() {
        DispatchQueue.main.async {
         APPDELEGATE.window?.viewWithTag(501)?.removeFromSuperview()
        }
    }

    //MARK: - Dialog for Network
    func openRequestDialog(newOrder:[String:Any]) {
        let newOrderDetail:PushNewOrder = PushNewOrder.init(fromDictionary:newOrder)
        if (UIApplication.shared.windows.last?.viewWithTag(503)) != nil {
            print(newOrder)
            dialogForAcceptRequest!.updateView(count: newOrderDetail.orderDetail.orderCount)
            APPDELEGATE.window?.bringSubviewToFront(dialogForAcceptRequest!);
        } else {
            print(newOrder)
            closeRequestDialog()
            dialogForAcceptRequest = CustomRequestDialog.showCustomRequestDialog(newOrder:newOrder,tag:503)
            dialogForAcceptRequest?.tag = 503

            UIApplication.shared.windows.last?.addSubview(dialogForAcceptRequest!)
            UIApplication.shared.windows.last?.bringSubviewToFront(dialogForAcceptRequest!);
            dialogForAcceptRequest?.setUpSound()
            dialogForAcceptRequest?.startTimer()
        }
    }

    func closeRequestDialog() {
        dialogForAcceptRequest?.stopTimer()
        dialogForAcceptRequest?.removeFromSuperview()
        dialogForAcceptRequest = nil
        if let mainview = APPDELEGATE.window?.rootViewController as? PBRevealViewController {
            if let nav1 = mainview.mainViewController as? UINavigationController {
                if nav1.topViewController is HomeVC {
                    let vc = nav1.topViewController as! HomeVC
                    vc.wsGetRequestCount()
                }
            }
        }
    }

    //MARK: - MessagingDelegate
    private func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("fcmToken :")
        print(fcmToken)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }

    //MARK: - Itial Setup
    func setupTabbar() {
        UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):FontHelper.textRegular(), convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.gray]), for: .normal);
        UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):FontHelper.textLarge(), convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.themeTextColor]), for: .selected);
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
    }

    func setupNavigationbar() {
        UINavigationBar.appearance().barTintColor = UIColor.themeNavigationBackgroundColor
        UINavigationBar.appearance().tintColor = UIColor.themeTitleColor
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.themeTitleColor])
        
        //UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().castShadow = ""
    }
    
    func getImageWithColorPosition(color: UIColor, size: CGSize, lineSize: CGSize) -> UIImage {
        
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let rectLine = CGRect(x: 0, y: size.height-lineSize.height, width: lineSize.width, height: lineSize.height)
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        color.setFill()
        UIRectFill(rectLine)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        image.resizableImage(withCapInsets: UIEdgeInsets.zero)
        return image
    }
    
    func setupIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        UITextField.appearance().tintColor = UIColor.themeTextColor;
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
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


//MARK: - PUSH handling
extension AppDelegate: UNUserNotificationCenterDelegate {
    private struct PUSH {
        static let  Approved = "2032"
        static let  Declined = "2033"
        static let  LoginAtAnother = "2092"
        static let  NewOrder = "2031"
        static let  CancelledRequest = "2036"
    }

    func setupPushNotification(_ application: UIApplication,launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            DispatchQueue.main.async {
                center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(grant, error)  in
                    if error == nil {
                        if grant {
                            DispatchQueue.main.async {
                                application.registerForRemoteNotifications()
                            }
                        } else {
                            //User didn't grant permission
                        }
                    } else {}
                })
            }
        } else {
            // Fallback on earlier versions
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
    }
    
    func wsUpdateDeviceToken() {
        if !preferenceHelper.getUserId().isEmpty {
            let afh:AlamofireHelper = AlamofireHelper.init()
            let dictParam : [String : Any] =
                [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
                  PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                  PARAMS.DEVICE_TOKEN : preferenceHelper.getDeviceToken()];
            
            
            afh.getResponseFromURL(url: WebService.UPDATE_DEVICE_TOKEN, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {  (response, error) -> (Void) in
                
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data

        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString \(deviceTokenString)")
        preferenceHelper.setDeviceToken(deviceTokenString)
        self.wsUpdateDeviceToken()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
     
        if let messageID = userInfo[gcmMessageIDKey] {
                        print("Message ID: \(messageID)")
        }
      // Print full message.
      print(userInfo)
        if let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary) {
            print("Push Data: - \(aps)")
            if let alert:NSDictionary = (aps["alert"] as? NSDictionary) {
                if let id = alert["id"] as? String {
                    self.addPushDataToDB(id: id)
                    switch id {
                    case PUSH.Approved:
                        preferenceHelper.setIsProviderApprove(true)
                        self.goToMain()
                        break;
                    case PUSH.Declined:
                        preferenceHelper.setIsProviderApprove(false)
                        self.goToMain()
                        break
                    default:
                        break;
                    }
                }
            }
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary) {
            print("Push Data Background: - \(aps)")
            if let alert:NSDictionary = (aps["alert"] as? NSDictionary) {
                if  let id = alert["id"] as? String {
                    //self.addPushDataToDB(id: id)
                    switch id {
                    case PUSH.Approved:
                        preferenceHelper.setIsProviderApprove(true)
                        self.goToMain()
                        break;
                    case PUSH.Declined:
                        preferenceHelper.setIsProviderApprove(false)
                        self.goToMain()
                        break
                    case PUSH.NewOrder:
                        self.newOrderPush()
                        break
                    default:
                        break;
                    }
                }
            }
        }
    }

    func newOrderPush() {
        if let mainview = APPDELEGATE.window?.rootViewController as? PBRevealViewController {
            self.window!.rootViewController = mainview
            if let nav1 = mainview.mainViewController as? UINavigationController {
                if nav1.topViewController is AvailableDeliveriesVC {
                    let vc = nav1.topViewController as! AvailableDeliveriesVC
                    vc.tabBar(vc.tabBar, didSelect: vc.tabBar.items![0])
                } else {
                    if let mainVC = nav1.viewControllers.first as? HomeVC {
                        mainVC.performSegue(withIdentifier: SEGUE.HOME_TO_AVAIL_DELIVERIES, sender: mainVC)
                    }
                }
            }
        }
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
        let userInfo:[AnyHashable:Any] =  notification.request.content.userInfo
        if let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary) {
            print("Push Data: - \(aps)")
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Messa ge ID: \(messageID)")
            }
            // Print full message.
            print("userInfo \(userInfo)")
            if aps["alert"] as? NSDictionary != nil {
                if let alert:NSDictionary = (aps["alert"] as? NSDictionary) {
                    if  let id = alert["id"] as? String {
                        self.addPushDataToDB(id: id)
                        switch id {
                        case PUSH.Approved:
                            preferenceHelper.setIsProviderApprove(true)
                            APPDELEGATE.window?.viewWithTag(502)?.removeFromSuperview()
                            self.goToMain()
                            break;
                        case PUSH.Declined:
                            preferenceHelper.setIsProviderApprove(false)
                            self.goToMain()
                            break
                        case PUSH.NewOrder:
                            openRequestDialog(newOrder:alert as! [String:Any])
                            break
                        case PUSH.CancelledRequest:
                            closeRequestDialog()
                        print("testing")
                        default:
                            break;
                        }
                    }
                }
            }
        }
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo:[AnyHashable:Any] =  response.notification.request.content.userInfo
        if let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary) {
            if let alert:NSDictionary = (aps["alert"] as? NSDictionary) {
                if let id = alert["id"] as? String {
                    if UIApplication.shared.applicationState == .inactive {
                        self.addPushDataToDB(id: id)
                    }
                    switch id {
                    case PUSH.LoginAtAnother:
                        preferenceHelper.setSessionToken("")
                        preferenceHelper.setUserId("")
                        self.goToHome()
                        break;
                    case PUSH.NewOrder:
                        self.newOrderPush()
                        break;
                    default:
                        break;
                    }
                }
            }
        }
        completionHandler()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
}

//MARK: - Navigation handling

extension AppDelegate {
    func goToMain() {
        Alamofire.Session.default.session.cancelTasks { [unowned self] in
            GMSServices.provideAPIKey(Google.MAP_KEY)
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Main", bundle: nil)
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            let mainVC = mainView.instantiateViewController(withIdentifier: "home")
            let navigation = UINavigationController(rootViewController: mainVC)
            let leftViewController = mainView.instantiateViewController(withIdentifier: "MenuVC")
            let revealViewController:PBRevealViewController = PBRevealViewController.init(sideViewController: leftViewController, mainViewController: navigation)
            self.window!.rootViewController = revealViewController
            self.window?.makeKeyAndVisible();
            self.setupPushNotification(UIApplication.shared, launchOptions: self.launchOptions)
        }
    }
    
    //MARK:
    //MARK: Go to Home
    func goToHome() {
        Alamofire.Session.default.session.cancelTasks { [unowned self] in
            self.removeFirebaseTokenAndTopic()
            preferenceHelper.setIsPhoneNumberVerified(false)
            preferenceHelper.setIsEmailVerified(false)
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Home", bundle: nil)
            let viewcontroller : LoginVC = mainView.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController.init(rootViewController: viewcontroller)
            self.window!.rootViewController = nav
            self.window?.makeKeyAndVisible();
        }
    }
    
    func goToSplash() {
        Alamofire.Session.default.session.cancelTasks { [unowned self] in
            self.removeFirebaseTokenAndTopic()
            preferenceHelper.setIsPhoneNumberVerified(false)
            preferenceHelper.setIsEmailVerified(false)
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Splash", bundle: nil)
            let viewcontroller : SplashVC = mainView.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
            let nav = UINavigationController.init(rootViewController: viewcontroller)
            self.window!.rootViewController = nav
            self.window?.makeKeyAndVisible();
        }
    }
}

extension AppDelegate{
    func removeFirebaseTokenAndTopic(){
        Messaging.messaging().unsubscribe(fromTopic: "\(preferenceHelper.getUserId())") { error in
               print("UnSubscribed to \(preferenceHelper.getUserId()) topic")
        }
        
        let instance = Installations.installations()
        instance.delete { (err:Error?) in
           if err != nil{
               print(err.debugDescription);
           } else {
               print("Token Deleted");
           }
        }
        
    }
}


// MARK: - Core Data stack for Push Notifications

extension AppDelegate {
    func addNotificationToDb(message:String, entityName:String) {
        print("addMassNotificationToDb ---> \(message)")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)

        let newLocation = NSManagedObject(entity: entity!, insertInto: context)
        let time = (Date().timeIntervalSince1970 * 1000)
        newLocation.setValue(time, forKey: "time")
        newLocation.setValue(message, forKey: "message")

        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchNotificationFromDB(entityName:String) -> [[String : Any]] {
        var locationArray:[[String : Any]] = [[:]]
        locationArray.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let time = (data.value(forKey:"time") as? Double) ?? 0.0
                let message = (data.value(forKey:"message") as? String) ?? ""
                _ = (data.objectID.uriRepresentation())
                print(data.objectID)

                let array = ["time":time,"message":message] as [String : Any]
                print("fetchNotificationFromDB ---> \(time) - \(message)")

                locationArray.append(array)
            }
            
        } catch {
            print("Failed")
        }
        return locationArray
    }
    
    func addPushDataToDB(id: String){
        print("addPushDataToDB ----")
        
        switch id {
        case PUSH.LoginAtAnother:
            self.addNotificationToDb(message: PUSH.LoginAtAnother.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.Approved:
            self.addNotificationToDb(message: PUSH.Approved.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.Declined:
            self.addNotificationToDb(message: PUSH.Declined.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.NewOrder:
            self.addNotificationToDb(message: PUSH.NewOrder.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.CancelledRequest:
            self.addNotificationToDb(message: PUSH.CancelledRequest.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        default:
            self.addNotificationToDb(message: id, entityName: CoreDataEntityName.MASS_NOTIFICATION)
            break
        }
    }

    //MARK:- Core Data Saving support
    func clearMassNotificationEntity() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.MASS_NOTIFICATION)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in  error : \(error) \(error.userInfo)")
        }
    }

    func clearOrderNotificationEntity() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.ORDER_NOTIFICATION)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in  error : \(error) \(error.userInfo)")
        }
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
