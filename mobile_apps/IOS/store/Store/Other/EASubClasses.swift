//
//  EASubClasses.swift
//  HandymanServiceUser
//
//  Created by Mac Pro5 on 29/04/19.
//  Copyright © 2019 KetanMR_Elluminati. All rights reserved.
//

import Foundation
import UIKit

class VC: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        //self.clean()
    }
    
    deinit {
        Log.d("\(self) \(#function)")
    }
    
}

class NC: UINavigationController {
    
    override var viewControllers: [UIViewController] {
        didSet {
            for vC in super.viewControllers {
                vC.clean()
            }
            
            for vC in oldValue {
                vC.clean()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        //self.clean()
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vC = super.popViewController(animated: animated)
        vC?.clean()
        return vC
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let vCs = super.popToViewController(viewController, animated: animated)
        
        if vCs != nil {
            for vC in vCs! {
                vC.clean()
            }
        }
        
        return vCs        
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let vCs = super.popToRootViewController(animated: animated)
        
        if vCs != nil {
            for vC in vCs! {
                vC.clean()
            }
        }
        
        return vCs        
    }
    deinit {
        Log.d("\(self) \(#function)")
    }
    
    enum UIUserInterfaceIdiom : Int {
        case unspecified
        case phone // iPhone and iPod touch style UI
        case pad   // iPad style UI (also includes macOS Catalyst)
    }
    
    override open var shouldAutorotate: Bool {
        get {
            //            if visibleViewController != nil {
            //                return false
            //            }
            //            return false
            
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return false
            case .pad:
                return true
            @unknown default:
                return false
                
            }
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return .portrait
            case .pad:
                return super.preferredInterfaceOrientationForPresentation
            @unknown default:
                return .portrait
            }
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            //            if visibleViewController != nil {
            //                return .portrait
            //            }
            //            return .portrait
            
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return .portrait
            case .pad:
                return super.supportedInterfaceOrientations
            @unknown default:
                return .portrait
            }
        }
    }
}
