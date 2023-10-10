//
//  AppDelegate.swift
//  edelivery
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications
import GooglePlaces
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseCrashlytics
import Branch
import Alamofire
import Firebase
import FirebaseMessaging
import CoreData
import FirebaseInstallations

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    private struct PUSH {
        static let OrderAccepted = "2001"
        static let OrderPreparing = "2002"
        static let OrderReady = "2003"
        static let OrderRejected = "2004"
        static let OrderCanceled = "2005"
        static let Approved = "2006"
        static let Declined = "2007"
        static let DeliveryManAcceptOrder = "2081"
        static let DeliveryManArrivedAtPickup = "2083"
        static let OrderDispatched = "2084"
        static let OrderOnTheWay = "2085"
        static let OrderArrived = "2086"
        static let OrderDelivered = "2087"
        static let StoreOrderChange = "2088"
        static let LoginAtAnother = "2091"
    }

    var window: UIWindow?
    var reachability: Reachability?
    var dialogForNetwork:CustomAlertDialog?
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.launchOptions = launchOptions
        clearQRUser()
        if #available(iOS 13.0, *) {
            //window?.overrideUserInterfaceStyle = .light
        }

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Localizer.doTheMagic()
        setupNetworkReachability()

        setupIQKeyboard()
        setupNavigationbar()
        
        let pushNotificationData = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary
        if pushNotificationData != nil {

            if let aps:NSDictionary = (pushNotificationData?[AnyHashable("aps")] as? NSDictionary) {
                if let alert = (aps["alert"] as? NSDictionary) {
                    self.manageAllPush(data: alert)
                }
            }
        }

        Branch.setUseTestBranchKey(false)
        //Branch.io DeepLinking Code.
        let branch: Branch = Branch.getInstance()

        currentBooking.selectedBranchIoStore = ""
        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
            if error == nil {
                if (params!["~stage"] as? String ?? "") != "" {
                    
                    CurrentBooking.shared.selectedBranchIoStore = params!["~stage"] as? String ?? ""
                    currentBooking.selectedBranchIoStore = currentBooking.selectedBranchIoStore.replacingOccurrences(of: "'", with: "")
                    
                    if !currentBooking.selectedBranchIoStore.isEmpty {
                        if let wd = self.window {
                            let rootController = wd.rootViewController
                            if let navigaitonController = (rootController as? UINavigationController) {
                                if let mainVC = (navigaitonController.visibleViewController as? MainVC) {
                                    mainVC.homeVC?.goToProductScreen()
                                } else if (navigaitonController.visibleViewController as? DeliveryLocationVC) != nil {
                                    APPDELEGATE.goToMain()
                                } else {
                                    var mainView: UIStoryboard!
                                    mainView = UIStoryboard(name: "MainStoryboard", bundle: nil)
                                    if let productVc : ProductVC = mainView.instantiateViewController(withIdentifier: "productVC") as? ProductVC {
                                        productVc.selectedStoreId = currentBooking.selectedBranchIoStore
                                        productVc.isFromDeliveryList = true
                                        navigaitonController.pushViewController(productVc, animated: true)
                                        self.window!.rootViewController = navigaitonController
                                        self.window?.makeKeyAndVisible()
                                        Utility.hideLoading()
                                    }
                                }
                            } else {
                                self.goToMain()
                            }
                        }
                    }
                }
            }
        })

        if #available(iOS 11.0, *) {
            UIColor.setColors()
        }

        UISwitch.appearance().tintColor = UIColor.lightGray
        UISwitch.appearance().onTintColor = UIColor.themeSwitchTintColor

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        //TWTRTwitter.sharedInstance().start(withConsumerKey:CONSTANT.TWITTER.CONSUMER_KEY, consumerSecret:CONSTANT.TWITTER.SECRET_KEY)
        setupTabbar()
        return true
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

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
    }

    //MARK: - Facebook & Google Login
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        print("deep link url = \(url)")
        let dict:[String:String] = url.queryDictionary ?? [:]
        if dict[PARAMS.STORE_ID] != nil {
            let storeId = dict[PARAMS.STORE_ID] ?? ""
            //let tableId = dict[PARAMS.TABLE_ID] ?? ""

            if let wd = self.window {
                let rootController = wd.rootViewController
                if let navigaitonController = (rootController as? UINavigationController) {
                    if let mainVC = (navigaitonController.visibleViewController as? MainVC) {
                        currentBooking.isQrCodeScanBooking = true
                        mainVC.homeVC?.goToProductVC(storeID: storeId)
                    } else {
                        var mainView: UIStoryboard!
                        mainView = UIStoryboard(name: "MainStoryboard", bundle: nil)
                        if let productVc : ProductVC = mainView.instantiateViewController(withIdentifier: "productVC") as? ProductVC {
                            productVc.selectedStoreId = storeId
                            productVc.isFromDeliveryList = true
                            currentBooking.isQrCodeScanBooking = true
                            navigaitonController.pushViewController(productVc, animated: true)
                            self.window!.rootViewController = navigaitonController
                            self.window?.makeKeyAndVisible()
                            Utility.hideLoading()
                        }
                    }
                } else {
                    self.goToMain()
                }
            }
        }

        let googleDidHandle:Bool = GIDSignIn.sharedInstance.handle(url)
        let facebookDidHandle:Bool = ApplicationDelegate.shared.application(app, open: url as URL, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: nil)
        return facebookDidHandle || googleDidHandle
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data

        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString \(deviceTokenString)")
        preferenceHelper.setDeviceToken(deviceTokenString)
        self.wsUpdateDeviceToken()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("didReceiveRemoteNotification : \(userInfo)")
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        let aps = userInfo["aps" as NSString] as? [String:Any]
        if let alert = (aps?["alert"] as? NSDictionary) {
            self.manageAllPush(data: alert)
        }
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo:[AnyHashable:Any] =  notification.request.content.userInfo
        let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary)!
        //        let alert:NSDictionary = (aps["alert"] as? NSDictionary)!
        print("Push Data \(aps)")
        if isNotNSNull(object: aps["alert"] as AnyObject){
            if (aps["alert"] as? NSDictionary) != nil {
                let alert:NSDictionary = (aps["alert"] as? NSDictionary)!
                self.manageAllPush(data: alert)
            }
        }
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Messa ge ID: \(messageID)")
        }
        
        print("userInfo \(userInfo)")
        
        
        print(userInfo)
        
        completionHandler([.badge, .sound, .alert])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        print("userNotificationCenter userInfo : \(response.notification.request.content.userInfo)")


        let userInfo:[AnyHashable:Any] =  response.notification.request.content.userInfo
        let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary)!
        //        check
        
        if isNotNSNull(object: aps["alert"] as AnyObject){
            if (aps["alert"] as? NSDictionary) != nil {
                let alert:NSDictionary = (aps["alert"] as? NSDictionary)!
                self.manageAllPush(data: alert)
            }
        }
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        completionHandler()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printE("i am not available in simulator \(error)")
    }

    func setupPushNotification(_ application: UIApplication,launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(grant, error)  in
                DispatchQueue.main.async {
                    if error == nil {
                        if grant {
                            application.registerForRemoteNotifications()
                        }
                        else {
                        }
                    }
                    else {
                    }
                }
            })
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
        let pushNotificationData = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary
        if pushNotificationData != nil {
            let aps = pushNotificationData!["aps" as NSString] as? [String:Any]
            if let alert = (aps?["alert"] as? NSDictionary) {
                self.manageAllPush(data: alert)
            }
        }
    }

    func manageAllPush(data:NSDictionary,isClick:Bool = true) {

        print("manageAllPush \(data)")

        let id = data["id"] as! String
        self.addPushDataToDB(id: id)
        
        switch id {
        case PUSH.LoginAtAnother:
            APPDELEGATE.removeFirebaseTokenAndTopic()
            preferenceHelper.setSessionToken("")
            preferenceHelper.setUserId("")
            preferenceHelper.setRandomCartID(String.random(length: 20))
            
            self.goToHome()
            break
        case PUSH.Approved:
            preferenceHelper.setIsUserApprove(true)
            self.goToMain()
            break
        case PUSH.Declined:
            preferenceHelper.setIsUserApprove(false)
            self.goToMain()
            break

        case PUSH.OrderDelivered,PUSH.StoreOrderChange,
             PUSH.OrderAccepted,
             PUSH.OrderPreparing,
             PUSH.OrderReady,
             PUSH.OrderArrived,
             PUSH.OrderOnTheWay,
             PUSH.OrderDispatched,
             PUSH.DeliveryManAcceptOrder,
             PUSH.DeliveryManArrivedAtPickup:
            
            let orderData:[String:Any] = data["push_data1"] as! [String:Any]
            let orderId:String = orderData["order_id"] as! String
            let arrstoreName:[String] = orderData["store_name"] as? [String] ?? []
            var storeName:String = orderData["store_name"] as? String ?? ""
            if arrstoreName.count > 0 {
                storeName = arrstoreName[0]
            }
            let deliveryType = (orderData["delivery_type"] as? Int) ?? 1
            let uniqueId = (orderData["unique_id"] as? Int) ?? 1
            
            print("Push Data \(data)")
            if let wd = self.window {
                var viewController = wd.rootViewController
                if(viewController is UINavigationController) {
                    viewController = (viewController as! UINavigationController).visibleViewController
                }
                if deliveryType == DeliveryType.courier {
                    if(viewController is CourierStatusVC) {
                        let courierStatusVC:CourierStatusVC = (viewController as! CourierStatusVC)
                        if isClick
                        {
                            courierStatusVC.selectedOrder._id = orderId
                            courierStatusVC.selectedOrder.store_name = storeName
                            courierStatusVC.selectedOrder.unique_id = uniqueId
                            courierStatusVC.selectedOrder.delivery_type = DeliveryType.courier
                            courierStatusVC.wsGetOrderDetail()
                        }
                        else
                        {
                            courierStatusVC.resetTimer()
                        }
                    }
                    else {
                        if isClick
                        {
                            goToOrderStatus(id: orderId, storeName: storeName,deliveryType: deliveryType, uniqueID: uniqueId)
                        }
                    }
                }else {
                    if(viewController is OrderStatusVC) {
                        let orderStatusVC:OrderStatusVC = (viewController as! OrderStatusVC)
                        if isClick
                        {
                            orderStatusVC.selectedOrder._id = orderId
                            orderStatusVC.selectedOrder.unique_id = uniqueId
                            orderStatusVC.selectedOrder.store_name = storeName
                            orderStatusVC.wsGetOrderDetail()
                        }
                        else
                        {
                            orderStatusVC.resetTimer()
                        }
                    }else {
                        if isClick
                        {
                            
                            goToOrderStatus(id: orderId, storeName: storeName,deliveryType: deliveryType, uniqueID: uniqueId)
                        }
                    }
                }
            }
            break
        case PUSH.OrderCanceled: fallthrough
        case PUSH.OrderRejected:
            if let wd = self.window {
                var viewController = wd.rootViewController
                if(viewController is UINavigationController) {
                    viewController = (viewController as! UINavigationController).visibleViewController
                }
                if isClick
                {
                    goToMain()
                }
            }
            break
        default:
            break
        }
    }

    func addPushDataToDB(id: String) {
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
        case PUSH.OrderAccepted:
            self.addNotificationToDb(message: PUSH.OrderAccepted.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.OrderPreparing:
            self.addNotificationToDb(message: PUSH.OrderPreparing.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.OrderReady:
            self.addNotificationToDb(message: PUSH.OrderReady.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.OrderArrived:
            self.addNotificationToDb(message: PUSH.OrderArrived.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.OrderOnTheWay:
            self.addNotificationToDb(message: PUSH.OrderOnTheWay.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.OrderDispatched:
            self.addNotificationToDb(message: PUSH.OrderDispatched.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.OrderDelivered:
            self.addNotificationToDb(message: PUSH.OrderDelivered.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.StoreOrderChange:
            self.addNotificationToDb(message: PUSH.StoreOrderChange.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.OrderCanceled:
            self.addNotificationToDb(message: PUSH.OrderCanceled.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.OrderRejected:
            self.addNotificationToDb(message: PUSH.OrderRejected.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.DeliveryManArrivedAtPickup:
            self.addNotificationToDb(message: PUSH.DeliveryManArrivedAtPickup.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        case PUSH.DeliveryManAcceptOrder:
            self.addNotificationToDb(message: PUSH.DeliveryManAcceptOrder.localized, entityName: CoreDataEntityName.ORDER_NOTIFICATION)
            break
        default:
            self.addNotificationToDb(message: id, entityName: CoreDataEntityName.MASS_NOTIFICATION)
            break
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //location change 2-11
        // LocationCenter.default.requestAuthorization()
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
        print("\(#function) Windows:-\n \(String(describing: APPDELEGATE.window?.subviews))")
        
        if let mywindow = self.window {
            for view in mywindow.subviews {
                if (String(describing: type(of: view.self)) == "UILayoutContainerView") &&
                    view != APPDELEGATE.window!.rootViewController?.view {
                    if view.subviews.count == 0 {
                        print("View is Removed \(view.description)")
                        view.removeFromSuperview()
                    }
                    
                }
            }
        }
        
        print("\(#function) Windows:-\n \(String(describing: APPDELEGATE.window?.subviews))")
    }
    
    func applicationWillTerminate(_ application: UIApplication){
        self.saveContext()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("\(#function) Windows:-\n \(String(describing: APPDELEGATE.window?.subviews))")
    }
    
    func applicationWillResignActive(_ application: UIApplication){
       // AppEvents.activateApp()
        print("\(#function) Windows:-\n \(String(describing: APPDELEGATE.window?.subviews))")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("\(#function) Windows:-\n \(String(describing: APPDELEGATE.window?.subviews))")
        
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let reachability = note.object as! Reachability
            
            if reachability.isReachable {
                if APPDELEGATE.window?.viewWithTag(400) != nil {
                    self.dialogForNetwork?.removeFromSuperview()
                }
                
                if reachability.isReachableViaWiFi {
                    printE("Reachable via WiFi")
                }
                else {
                    printE("Reachable via Cellular")
                }
            }
            else {
                printE("Network not reachable")
                self.openNetworkDialog()
            }
        }
    }
    
    
    func setupNetworkReachability() {
        self.reachability = Reachability.init()
        do {
            try self.reachability?.startNotifier()
        }
        catch {
            printE(error)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
    }
    
    func goToOrderStatus(id:String,storeName:String, deliveryType:Int = 1, uniqueID:Int = 0) {
        if CurrentBooking.shared.PushNotification == false {
            GMSServices.provideAPIKey(Google.MAP_KEY)
            GMSPlacesClient.provideAPIKey(Google.API_KEY)
        Alamofire.Session.default.session.cancelTasks {
            
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            if deliveryType == DeliveryType.courier {
                var mainView: UIStoryboard!
                mainView = UIStoryboard(name: "Courier", bundle: nil)
                if let courierStatusVC : CourierStatusVC = mainView.instantiateViewController(withIdentifier: "courierStatusVC") as? CourierStatusVC {

                    courierStatusVC.selectedOrder._id = id
                    courierStatusVC.selectedOrder.unique_id = uniqueID
                    courierStatusVC.selectedOrder.store_name = "TXT_COURIER".localized
                    courierStatusVC.selectedOrder.delivery_type = DeliveryType.courier
                    courierStatusVC.isOpenFromPush = true
                    let navigationViewController: UINavigationController = UINavigationController(rootViewController: courierStatusVC)
                    
                    self.window!.rootViewController = navigationViewController
                    self.window?.makeKeyAndVisible()
                }
            }else {
                var mainView: UIStoryboard!
                mainView = UIStoryboard(name: "Order", bundle: nil)
                let orderStatusVC : OrderStatusVC = mainView.instantiateViewController(withIdentifier: "orderStatusVC") as! OrderStatusVC
                orderStatusVC.selectedOrder._id = id
                orderStatusVC.selectedOrder.store_name = storeName
                orderStatusVC.selectedOrder.unique_id = uniqueID
                orderStatusVC.isOpenFromPush = true
                let navigationViewController: UINavigationController = UINavigationController(rootViewController: orderStatusVC)
                
                self.window!.rootViewController = navigationViewController
                self.window?.makeKeyAndVisible()
            }
        }
            CurrentBooking.shared.PushNotification = true
        }
    }
    
    func goToMain(strQrURL: String? = nil) {
        Alamofire.Session.default.session.cancelTasks {
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            Utility.hideLoading()
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "MainStoryboard", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateInitialViewController()!
            self.window!.rootViewController = viewcontroller
            self.window?.makeKeyAndVisible()
            if preferenceHelper.getUserId() != "" {
                self.setupPushNotification(UIApplication.shared, launchOptions: self.launchOptions)
            }
        }
    }

    func goToHome(isSplash: Bool = false) {
        Alamofire.Session.default.session.cancelTasks {
            CurrentBooking.shared.PushNotification = false
            APPDELEGATE.removeFirebaseTokenAndTopic()
            preferenceHelper.setUserId("")
            preferenceHelper.setSessionToken("")
            preferenceHelper.setIsPhoneNumberVerified(false)
            preferenceHelper.setIsEmailVerified(false)
            preferenceHelper.setFirstName("")
            preferenceHelper.setLastName("")
            preferenceHelper.setAddress("")
            preferenceHelper.setPhoneNumber("")
            preferenceHelper.setPhoneCountryCode("")
            preferenceHelper.setCountryCode("")
            preferenceHelper.setCountryId("")
            preferenceHelper.setEmail("")
            preferenceHelper.setProfilePicUrl("")
            preferenceHelper.setSocialId("")

            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Prelogin", bundle: nil)
            var viewcontroller : UIViewController = mainView.instantiateInitialViewController()!
            
            if isSplash {
                mainView = UIStoryboard(name: "Splash", bundle: nil)
                viewcontroller = mainView.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
            }
            
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window!.rootViewController = viewcontroller
            self.window?.makeKeyAndVisible()
            Utility.hideLoading()
        }
    }

    //MARK:- DIALOG
    func openNetworkDialog () {
        dialogForNetwork = CustomAlertDialog.showCustomAlertDialog(title: "TXT_INTERNET".localized, message: "MSG_INTERNET_ENABLE".localized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized)
        self.dialogForNetwork!.onClickLeftButton = { [unowned self] in
            self.dialogForNetwork!.removeFromSuperview()
            exit(0)
        }
        self.dialogForNetwork!.onClickRightButton = { [unowned self] in
            self.dialogForNetwork?.removeFromSuperview()
            exit(0)
        }
    }

    //MARK:- SETUP TABBAR AND NAVIGATION BAR+
    func setupTabbar() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:FontHelper.textRegular(), NSAttributedString.Key.foregroundColor: UIColor.themeTextColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:FontHelper.textLarge(), NSAttributedString.Key.foregroundColor: UIColor.themeTextColor], for: .selected)
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
    }
    
    func setupNavigationbar() {
        UINavigationBar.appearance().barTintColor = UIColor.themeViewBackgroundColor
        UINavigationBar.appearance().tintColor = UIColor.themeViewBackgroundColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.themeTitleColor]
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
        UITextField.appearance().tintColor = UIColor.black
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func getCommonDictionary() -> [String:Any] {
        var dictParam: [String:Any] = [PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()]
        
        if preferenceHelper.getSessionToken().isEmpty {
            dictParam[PARAMS.USER_ID] = ""
            dictParam[PARAMS.IPHONE_ID] = preferenceHelper.getRandomCartID()
        } else {
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.IPHONE_ID] = ""
        }
        return dictParam
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                hendleQRCode(url: url)
                print(url.absoluteString)
            }
        }
        // pass the url to the handle deep link call
        printE(userActivity)
        Branch.getInstance().continue(userActivity)
        return true
    }
    
    func hendleQRCode(url: URL) {
        let strUrl = url.absoluteString
        if let wd = self.window {
            let rootController = wd.rootViewController
            if let navigaitonController = (rootController as? UINavigationController) {
                if let mainVC = (navigaitonController.visibleViewController as? MainVC) {
                    currentBooking.isQrCodeScanBooking = true
                    mainVC.found(code: strUrl)
                } else {
                    let mainVC = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MainStoryBoard") as! MainVC
                    mainVC.isQrUrl = strUrl
                    navigaitonController.setViewControllers([mainVC], animated: false)
                }
            } else {
                currentBooking.qrCodeUrl = strUrl
            }
        }
    }

    //MARK: - Core Data stack
    func addLocationToDb() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreDataEntityName.ADDRESS_DATA, in: context)
        let newLocation = NSManagedObject(entity: entity!, insertInto: context)
        newLocation.setValue(UserSingleton.shared.SendplaceData.latitude.toString(decimalPlaced: 6), forKey: "latitude")
        newLocation.setValue(UserSingleton.shared.SendplaceData.longitude.toString(decimalPlaced: 6), forKey: "longitude")
        newLocation.setValue(UserSingleton.shared.SendplaceData.title, forKey: "title")
        newLocation.setValue(UserSingleton.shared.SendplaceData.address, forKey: "address")
        newLocation.setValue(UserSingleton.shared.SendplaceData.city1, forKey: "city")
        newLocation.setValue(UserSingleton.shared.SendplaceData.country, forKey: "country")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }

    func fetchLocationFromDB() -> [[String : Any]] {
        var locationArray:[[String : Any]] = [[:]]
        locationArray.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.ADDRESS_DATA)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let latitude = (data.value(forKey:"latitude") as? String) ?? ""
                let longitude = (data.value(forKey:"longitude") as? String) ?? ""
                let title = (data.value(forKey:"title") as? String) ?? ""
                let city = (data.value(forKey:"city") as? String) ?? ""
                let address = (data.value(forKey:"address") as? String) ?? ""
                let country = (data.value(forKey:"country") as? String) ?? ""
                _ = (data.objectID.uriRepresentation())
                print(data.objectID)
                
                let array = ["latitude":latitude,"longitude":longitude,"title":title,"city":city,"address":address,"country":country,"ID":data.objectID] as [String : Any]
                locationArray.append(array)
            }
            
        }catch {
            print("Failed")
        }
        
        return locationArray
    }
    
    func clearQRUser() {
        if preferenceHelper.getIsQRUser() {
            preferenceHelper.setSessionToken("")
            preferenceHelper.setUserId("")
            preferenceHelper.setIsQRUser(false)
        }
    }

    /*func clearEntity() {
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let managedContext = appDelegate.persistentContainer.viewContext
     
     let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressData")
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
     }*/

    func deleteAddressdataWithPredicate(strAddress:String, strTitle: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.ADDRESS_DATA)
        fetchRequest.predicate = NSPredicate(format: "address = %@ AND title = %@", "\(strAddress)", "\(strTitle)")
        
        fetchRequest.fetchLimit = 1
        let objects = try! managedContext.fetch(fetchRequest)
        for obj in objects {
            managedContext.delete(obj as! NSManagedObject)
        }
        
        do {
            try managedContext.save() // <- remember to put this :)
        } catch {
            // Do something... fatalerror
        }
    }

    func updateLocationToDB(objectId:NSManagedObjectID) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.ADDRESS_DATA)
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "(SELF = %@)", objectId)
        request.predicate = predicate
        
        do {
            let myManagedObject = try managedContext.existingObject(with: objectId)
            print(myManagedObject)
            
            myManagedObject.setValue(UserSingleton.shared.SendplaceData.latitude.toString(decimalPlaced: 6), forKey: "latitude")
            myManagedObject.setValue(UserSingleton.shared.SendplaceData.longitude.toString(decimalPlaced: 6), forKey: "longitude")
            myManagedObject.setValue(UserSingleton.shared.SendplaceData.title, forKey: "title")
            myManagedObject.setValue(UserSingleton.shared.SendplaceData.address, forKey: "address")
            myManagedObject.setValue(UserSingleton.shared.SendplaceData.city1, forKey: "city")
            myManagedObject.setValue(UserSingleton.shared.SendplaceData.country, forKey: "country")
            
            do {
                try managedContext.save()
            }catch let error as NSError {
                print(error.localizedFailureReason ?? "")
            }
        }
        catch let error as NSError {
            print(error.localizedFailureReason ?? "")
        }
    }

 /*   func addAppleSignInDataToDb(email:String,name:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreDataEntityName.APPLE_SIGNIN, in: context)
        let newData = NSManagedObject(entity: entity!, insertInto: context)
        newData.setValue(email, forKey: "email")
        newData.setValue(name, forKey: "name")
       
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchAppleSignInDataFromDB() -> [[String : Any]] {
        var arr:[[String : Any]] = [[:]]
        arr.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.APPLE_SIGNIN)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let email = (data.value(forKey:"email") as? String) ?? ""
                let name = (data.value(forKey:"name") as? String) ?? ""
                
                let array = ["email":email,"name":name] as [String : Any]
                arr.append(array)
            }
            
        }catch {
            print("Failed")
        }
        
        return arr
    }
    
    func clearAppleSignInDataEntity(){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.APPLE_SIGNIN)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            do
            {
                let result = try context.execute(request)
        
            } catch let error as NSError {
                print("Detele all data in \(CoreDataEntityName.APPLE_SIGNIN) error : \(error) \(error.userInfo)")
            }
    }*/
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EDeliveryUser")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data stack for Push Notifications
    
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
    
    func addDeliveryLocationToDb(country:String,city:String,address:String,country_code:String,lat:String,long:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreDataEntityName.DELIVERY_LOCATION, in: context)
        let newLocation = NSManagedObject(entity: entity!, insertInto: context)
        newLocation.setValue(lat, forKey: "latitude")
        newLocation.setValue(long, forKey: "longitude")
        newLocation.setValue(country_code, forKey: "country_code")
        newLocation.setValue(address, forKey: "address")
        newLocation.setValue(city, forKey: "city")
        newLocation.setValue(country, forKey: "country")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchDeliveryLocationFromDB() -> [[String : Any]] {
        var locationArray:[[String : Any]] = [[:]]
        locationArray.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.DELIVERY_LOCATION)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let latitude = (data.value(forKey:"latitude") as? String) ?? ""
                let longitude = (data.value(forKey:"longitude") as? String) ?? ""
                let country_code = (data.value(forKey:"country_code") as? String) ?? ""
                let city = (data.value(forKey:"city") as? String) ?? ""
                let address = (data.value(forKey:"address") as? String) ?? ""
                let country = (data.value(forKey:"country") as? String) ?? ""
                _ = (data.objectID.uriRepresentation())
                print(data.objectID)
                
                let array = ["latitude":latitude,"longitude":longitude,"country_code":country_code,"city":city,"address":address,"country":country,"ID":data.objectID] as [String : Any]
                locationArray.append(array)
            }
        }catch {
            print("Failed")
        }
        return locationArray
    }

    func clearDeliveryLocationEntity() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.DELIVERY_LOCATION)
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

    func clearFavoriteAddressEntity() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.ADDRESS_DATA)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete Favorite Address data in  error : \(error) \(error.userInfo)")
        }
    }

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

    //MARK: - Core Data Saving support
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

extension AppDelegate {
    func wsUpdateDeviceToken() {
        if !preferenceHelper.getUserId().isEmpty {
            let afh:AlamofireHelper = AlamofireHelper.init()
            let dictParam : [String : Any] =
                [ PARAMS.USER_ID:preferenceHelper.getUserId(),
                  PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                  PARAMS.DEVICE_TOKEN : preferenceHelper.getDeviceToken()]

            afh.getResponseFromURL(url: WebService.UPDATE_DEVICE_TOKEN, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {  (response, error) -> (Void) in
                print(response)
            }
        }
    }
    
    func wsClearCart(block:@escaping () -> ()) {
        Utility.showLoading()
        var dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.CART_ID] = currentBooking.cartId

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_CLEAR_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            Utility.hideLoading()
            currentBooking.clearCart()
            currentBooking.clearTableBooking()
            block()
        }
    }
}

extension AppDelegate{
    func removeFirebaseTokenAndTopic(){
        Messaging.messaging().unsubscribe(fromTopic: "\(preferenceHelper.getUserId())") { error in
            print("UnSubscribed to \(preferenceHelper.getUserId()) topic")
        }
        /*
        let instance = InstanceID.instanceID()
        instance.deleteID { (err:Error?) in
            if err != nil{
                print(err.debugDescription);
            } else {
                print("Token Deleted");
            }
        }*/
        
        //InstanceID is deprecated so used Installations
        let installation = Installations.installations()
        installation.delete { (err:Error?) in
            if err != nil{
                print(err.debugDescription);
            } else {
                print("Token Deleted");
            }
        }
    }
}

/*Universal Link Domain
 applinks:webappedelivery.appemporio.net
*/
