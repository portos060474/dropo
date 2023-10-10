//
//  AppDelegate.swift
// Edelivery Store
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import GoogleMaps
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import GooglePlaces
//import Fabric
import FirebaseAnalytics
//import Crashlytics
//import TwitterKit
import Alamofire
import Firebase
import FirebaseMessaging
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EDeliveryStore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private struct PUSH {
        static let  NewScheduleOrder = "2070"
        static let  NewOrder = "2071"
        static let  Approved = "2072"
        static let  Declined = "2073"
        static let  LoginAtAnother = "2093"
        static let  UserCancelledOrder = "2068"
        static let  DeliveryManAccepted = "2061"
        static let  DeliveryManComing = "2062"
        static let  DeliveryManArrived = "2063"
        static let  DeliveryManPickedOrder = "2064"
        static let  DeliveryManStartedDelivery = "2065"
        static let  DeliveryManArrivedAtDestination = "2066"
        static let  DeliveryManCompletedOrder = "2067"
        static let  DeliveryManNotFound = "2069"
        static let  UserAcceptedEditOrder = "2074"
        static let  StoreOrderChange = "2088"
    }
    
    var window: UIWindow?
    var reachability: Reachability?;
    var dialogForNetwork:CustomAlertDialog?;
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool{
        
        self.launchOptions = launchOptions
        FirebaseApp.configure()

        if #available(iOS 13.0, *) {
            //            window?.overrideUserInterfaceStyle = .light
        }
        
        Messaging.messaging().delegate = self

        setupNavigationbar()
        GMSServices.provideAPIKey(Google.MAP_KEY);
        GMSPlacesClient.provideAPIKey(Google.MAP_KEY)
        UITabBar.appearance().backgroundColor = UIColor.themeViewBackgroundColor
        UISwitch.appearance().tintColor = UIColor.themeColor
        UISwitch.appearance().onTintColor = UIColor.themeLightLineColor
        //        UITextField.appearance().keyboardAppearance = .alert
        setupIQKeyboard()
        Localizer.doTheMagic()
        self.reachability = Reachability.init();
        do{
            try self.reachability?.startNotifier()
        }
        catch{
            print(error)
        }
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .themeViewBackgroundColor

        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        //        Crashlytics.sharedInstance().debugMode = true
        //        Fabric.with([Crashlytics.self])

      // GIDSignIn.sharedInstance.clientID = Google.CLIENT_ID
        // TWTRTwitter.sharedInstance().start(withConsumerKey:CONSTANT.TWITTER.CONSUMER_KEY, consumerSecret:CONSTANT.TWITTER.SECRET_KEY)

        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication){
     //   AppEvents.activateApp()
        
        print("App Background Statuss \(application.backgroundRefreshStatus.rawValue)")
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication){
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return .portrait
            case .pad:
                return .all
            @unknown default:
                return .portrait
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication){
        print("applicationDidBecomeActive")
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications: [UNNotification]) in
            for request in notifications {
                print("Pending notifications : \(request.request.content.userInfo)")
                if let aps:NSDictionary = (request.request.content.userInfo[AnyHashable("aps")] as? NSDictionary)
                {
                    if let alert:NSDictionary = (aps["alert"] as? NSDictionary) {
                        if  let id = alert["id"] as? String {
                            self.addPushDataToDB(id: id)
                        }
                    }
                }

            }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    func applicationWillTerminate(_ application: UIApplication){         // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - MessagingDelegate

    private func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("fcmToken :")
        print(fcmToken)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")

        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print("user Info : \(userInfo)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    
    @objc func reachabilityChanged(note: NSNotification){
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable{
            DispatchQueue.main.async {
                if (APPDELEGATE.window?.viewWithTag(400)) != nil{
                    self.dialogForNetwork?.removeFromSuperview()
                }
                
            }
            if reachability.isReachableViaWiFi{
                print("Reachable via WiFi")
            }else {
                print("Reachable via Cellular")
            }
        }else{
            print("Network not reachable")
            openNetworkDialog()
        }
    }
    //MARK: Facebook & Google Login
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let _:Bool = GIDSignIn.sharedInstance.handle(url)
        let _:Bool = self.application(app, open: url, options: options)
        return true
    }
    
    // MARK: - Navigation
    func goToMain(){
        Alamofire.Session.default.session.cancelTasks {
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            Utility.hideLoading()

            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Main", bundle: nil)
            
            let mainVC = mainView.instantiateViewController(withIdentifier: "orderStoryboard")
            let navigation = UINavigationController(rootViewController: mainVC)
            let leftViewController = mainView.instantiateViewController(withIdentifier: "SideMenuVC")
            
            let revealViewController:PBRevealViewController = PBRevealViewController.init(sideViewController: leftViewController, mainViewController: navigation)

            //            let viewcontroller : UIViewController = mainView.instantiateInitialViewController()!;
            //            self.window!.rootViewController = viewcontroller
            self.window!.rootViewController = revealViewController

            self.window?.makeKeyAndVisible();
            self.setupPushNotification(UIApplication.shared, launchOptions: self.launchOptions)
        }
    }
    
    func goToDeliveries() {
        Alamofire.Session.default.session.cancelTasks {
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            Utility.hideLoading()

            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Main", bundle: nil)
            
            let mainVC = mainView.instantiateViewController(withIdentifier: "deliveriesStoryboard")
            let navigation = UINavigationController(rootViewController: mainVC)
            let leftViewController : SideMenuVC = mainView.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
            leftViewController.selectedRow = 1
            let revealViewController:PBRevealViewController = PBRevealViewController.init(sideViewController: leftViewController, mainViewController: navigation)

            //            let viewcontroller : UIViewController = mainView.instantiateInitialViewController()!;
            //            self.window!.rootViewController = viewcontroller
            self.window!.rootViewController = revealViewController

            self.window?.makeKeyAndVisible();
            self.setupPushNotification(UIApplication.shared, launchOptions: self.launchOptions)
        }
    }
    
    func goToHome(){
        Alamofire.Session.default.session.cancelTasks {

            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()

            APPDELEGATE.removeFirebaseTokenAndTopic()
            
            Utility.hideLoading()
            GMSServices.provideAPIKey(Google.MAP_KEY);
            GMSPlacesClient.provideAPIKey(Google.MAP_KEY)
            preferenceHelper.setSessionToken("");
            preferenceHelper.setUserId("");
            preferenceHelper.setIsPhoneNumberVerified(false)
            preferenceHelper.setIsEmailVerified(false)
            
            
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Prelogin", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateInitialViewController()!;
            self.window!.rootViewController = viewcontroller
            self.window?.makeKeyAndVisible();
        }
        
    }
    
    func goToSplash() {
        Alamofire.Session.default.session.cancelTasks { [unowned self] in
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            
            APPDELEGATE.removeFirebaseTokenAndTopic()
            
            Utility.hideLoading()
            GMSServices.provideAPIKey(Google.MAP_KEY);
            GMSPlacesClient.provideAPIKey(Google.MAP_KEY)
            preferenceHelper.setSessionToken("");
            preferenceHelper.setUserId("");
            preferenceHelper.setIsPhoneNumberVerified(false)
            preferenceHelper.setIsEmailVerified(false)
            
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Splash", bundle: nil)
            let viewcontroller : SplashVC = mainView.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
            let nav = UINavigationController.init(rootViewController: viewcontroller)
            self.window!.rootViewController = nav
            self.window?.makeKeyAndVisible();
        }
    }
    
    // MARK: - DIALOG
    func openNetworkDialog () {
        dialogForNetwork  = CustomAlertDialog.showCustomAlertDialog(title: "TXT_INTERNET".localized, message: "MSG_INTERNET_ENABLE".localized, titleLeftButton: "".localizedUppercase, titleRightButton: "TXT_EXIT".localizedUppercase)
        self.dialogForNetwork!.onClickLeftButton = { [unowned self] in
            self.dialogForNetwork!.removeFromSuperview();
            exit(0)
        }
        self.dialogForNetwork!.onClickRightButton = { [unowned self] in
            self.dialogForNetwork?.removeFromSuperview();
            exit(0)
        }
    }

    func closeNetworkDialog(){
        APPDELEGATE.window?.viewWithTag(501)?.removeFromSuperview()
    }
    
    func openRequestDialog (newOrder:[String:Any]){
        
        let newOrderDetail:PushNewOrder = PushNewOrder.init(fromDictionary:newOrder)
        
        if let view:CustomRequestDialog = (APPDELEGATE.window?.viewWithTag(503) as? CustomRequestDialog) {
            view.updateView(count: newOrderDetail.orderDetail.orderCount)
        }else {
            _ =  CustomRequestDialog.showCustomRequestDialog(newOrder:newOrder,tag:503)
        }
    }

    func closeRequestDialog(){
        APPDELEGATE.window?.viewWithTag(503)?.removeFromSuperview()
    }

    func setupTabbar(tabBar:UITabBar){
        for item in tabBar.items!{
            item.setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):FontHelper.textRegular(), convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.themeLightTextColor]), for: .normal);
            item.setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):FontHelper.textLarge(), convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.themeTextColor]), for: .selected);
        }
        tabBar.backgroundColor = UIColor.themeViewBackgroundColor
        tabBar.isTranslucent = true
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.layer.borderWidth = 0.0
        tabBar.clipsToBounds = true
    }
    
    
    func setupIQKeyboard(){
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardAppearance = .alert
        UITextField.appearance().tintColor =  UIColor.black
        
    }
    
    func setupNavigationbar(){
        //        UINavigationBar.appearance().barTintColor = UIColor.themeNavigationBackgroundColor
        UINavigationBar.appearance().barTintColor = UIColor.themeViewBackgroundColor

        UINavigationBar.appearance().tintColor = UIColor.themeTitleColor
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.themeTitleColor])
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
extension AppDelegate : UNUserNotificationCenterDelegate {
    func setupPushNotification(_ application: UIApplication,launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(grant, error)  in
                if error == nil {
                    if grant {
                        DispatchQueue.main.async {
                            application.registerForRemoteNotifications()
                        }
                        
                    } else {
                        //User didn't grant permission
                        
                    }
                } else {
                }
            })
        } else {
            // Fallback on earlier versions
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
        
        
    }
    // MARK:- PUSH NOTIFICATION CODE BLOCK
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data

        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        preferenceHelper.setDeviceToken(deviceTokenString)
        self.wsUpdateDeviceToken()
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]){
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("user Info : \(userInfo)")
        if let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary)
        {
            if let alert:NSDictionary = (aps["alert"] as? NSDictionary) {
                if  let id = alert["id"] as? String {
                    self.addPushDataToDB(id: id)

                    switch id
                    {
                        case PUSH.LoginAtAnother:
                            preferenceHelper.setSessionToken("")
                            self.goToHome()
                            break;
                        case PUSH.Approved:
                            preferenceHelper.setIsUserApprove(true)
                            self.goToMain()
                            break;
                        case PUSH.Declined:
                            preferenceHelper.setIsUserApprove(false)
                            self.goToMain()
                            break
                        case PUSH.UserCancelledOrder:
                            closeRequestDialog()
                            self.goToMain()
                            
                        case PUSH.DeliveryManAccepted,PUSH.DeliveryManComing,PUSH.DeliveryManArrived,PUSH.DeliveryManPickedOrder,PUSH.DeliveryManStartedDelivery,PUSH.DeliveryManArrivedAtDestination,PUSH.DeliveryManCompletedOrder,PUSH.DeliveryManNotFound:
                            goToDeliveries()

                        case PUSH.UserAcceptedEditOrder:
                            goToMain()
                        case PUSH.StoreOrderChange:
                            goToMain()

                        default:
                            break;
                    }
                }
            }
            
        }
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        print("willPresent ----------- : \(notification.request.content.userInfo)")
        
        completionHandler([.alert, .badge, .sound]) // Display notification as
        
        //        completionHandler(UNNotificationPresentationOptions.alert)
        let userInfo:[AnyHashable:Any] =  notification.request.content.userInfo
        print("user Info : \(userInfo)")
        let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary)!
        if aps["alert"] as? NSDictionary != nil{
            if let alert = (aps["alert"] as? NSDictionary) {
                //            let alert:[String:Any] = (aps["alert"] as? [String:Any])!
                if alert["id"] != nil{
                    let id = alert["id"] as! String
                    
                    // self.addPushDataToDB(id: id)
                    switch id {
                        case PUSH.Approved:
                            preferenceHelper.setIsUserApprove(true)
                            self.goToMain()
                            break;
                        case PUSH.Declined:
                            preferenceHelper.setIsUserApprove(false)
                            self.goToMain()
                            break
                        case PUSH.NewOrder:
                            openRequestDialog(newOrder: alert as! [String : Any])
                        case PUSH.UserCancelledOrder:
                            closeRequestDialog()
                            self.goToMain()

                        case PUSH.NewScheduleOrder: fallthrough
                        case PUSH.DeliveryManAccepted,PUSH.DeliveryManComing,PUSH.DeliveryManArrived,PUSH.DeliveryManPickedOrder,PUSH.DeliveryManStartedDelivery,PUSH.DeliveryManArrivedAtDestination,PUSH.DeliveryManCompletedOrder,PUSH.DeliveryManNotFound:
                            goToDeliveries()
                        case PUSH.UserAcceptedEditOrder:
                            goToMain()
                        case PUSH.StoreOrderChange:
                            goToMain()


                        default:
                            break;
                    }
                }
            }
        }
    }
    
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("didReceive ----------- : \(response.notification.request.content.userInfo)")
        
        
        let userInfo:[AnyHashable:Any] =  response.notification.request.content.userInfo
        print("user Info : \(userInfo)")
        let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary)!
        if aps["alert"] as? NSDictionary != nil{
            if let alert = (aps["alert"] as? NSDictionary) {
                let id = alert["id"] as! String
                self.addPushDataToDB(id: id)
                switch id {
                case PUSH.LoginAtAnother:
                    preferenceHelper.setSessionToken("")
                    self.goToHome()
                    break;
                case PUSH.Approved:
                    preferenceHelper.setIsUserApprove(true)
                    self.goToMain()
                    break;
                case PUSH.Declined:
                    preferenceHelper.setIsUserApprove(false)
                    self.goToMain()
                    break
                case PUSH.UserCancelledOrder:
                    closeRequestDialog()
                    self.goToMain()
                    
                case PUSH.DeliveryManAccepted,PUSH.DeliveryManComing,PUSH.DeliveryManArrived,PUSH.DeliveryManPickedOrder,PUSH.DeliveryManStartedDelivery,PUSH.DeliveryManArrivedAtDestination,PUSH.DeliveryManCompletedOrder,PUSH.DeliveryManNotFound:
                    goToDeliveries()

                case PUSH.UserAcceptedEditOrder:
                    goToMain()
                case PUSH.StoreOrderChange:
                    goToMain()

                default:
                    break;
                }
            }
        }
        completionHandler()
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
}


extension AppDelegate {
    func wsUpdateDeviceToken() {
        if !preferenceHelper.getUserId().isEmpty {
            let afh:AlamofireHelper = AlamofireHelper.init()
            let dictParam : [String : Any] =
                [ PARAMS.STORE_ID:preferenceHelper.getUserId(),
                  PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                  PARAMS.DEVICE_TOKEN : preferenceHelper.getDeviceToken()];
            
            
            afh.getResponseFromURL(url: WebService.UPDATE_DEVICE_TOKEN, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {  (response, error) -> (Void) in
                print(response)
            }
        }
    }
}

extension AppDelegate{
    func removeFirebaseTokenAndTopic(){
        Messaging.messaging().unsubscribe(fromTopic: "\(preferenceHelper.getUserId())") { error in
            print("UnSubscribed to \(preferenceHelper.getUserId()) topic")
        }
       
      //  let instance = InstanceID.instanceID()
      //  instance.deleteID { (err:Error?) in
//            if err != nil{
//                print(err.debugDescription);
//            } else {
//                print("Token Deleted");
//            }
      //  }
    }
}

//MARK: - Core Data stack for Push Notifications

extension AppDelegate {
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

    func addNotificationToDb(message:String,entityName:String) {
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

        }catch {
            print("Failed")
        }

        return locationArray
    }
    
    func addPushDataToDB(id: String){
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
            case PUSH.UserCancelledOrder:
                self.addNotificationToDb(message: PUSH.UserCancelledOrder.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
                break
            case PUSH.DeliveryManAccepted:
                self.addNotificationToDb(message: PUSH.DeliveryManAccepted.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
                break
            case PUSH.DeliveryManArrived:
                self.addNotificationToDb(message: PUSH.DeliveryManArrived.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
                break
            case PUSH.DeliveryManPickedOrder:
                self.addNotificationToDb(message: PUSH.DeliveryManPickedOrder.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
                break
            case PUSH.DeliveryManStartedDelivery:
                self.addNotificationToDb(message: PUSH.DeliveryManStartedDelivery.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
                break
            case PUSH.DeliveryManArrivedAtDestination:
                self.addNotificationToDb(message: PUSH.DeliveryManArrivedAtDestination.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
                break
            case PUSH.DeliveryManCompletedOrder:
                self.addNotificationToDb(message: PUSH.DeliveryManCompletedOrder.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
                break
            case PUSH.DeliveryManNotFound:
                self.addNotificationToDb(message: PUSH.DeliveryManNotFound.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
                break
            case PUSH.UserAcceptedEditOrder:
                self.addNotificationToDb(message: PUSH.UserAcceptedEditOrder.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
                break
            case PUSH.NewScheduleOrder:
                self.addNotificationToDb(message: PUSH.NewScheduleOrder.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
                break
            case PUSH.StoreOrderChange:
                self.addNotificationToDb(message: PUSH.StoreOrderChange.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
                break
            default:
                self.addNotificationToDb(message: id, entityName: CoreDataEntityName.MASS_NOTIFICATION)
                break
        }
    }

    // MARK: - Core Data Saving support

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
