//
//  Common.swift
//  HandymanServiceUser
//
//  Created by Mac Pro5 on 01/05/19.
//  Copyright © 2019 KetanMR_Elluminati. All rights reserved.
//

import UIKit
import QuartzCore


class Common: NSObject {
    
    class func alert(_ title: String = "", _ message: String = "",_ actions:[UIAlertAction] = []) {
        OperationQueue.main.addOperation {
            let aC = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: UIAlertController.Style.alert)

            if actions.isEmpty {
                let act = UIAlertAction(title: "Dismiss".localized,
                                        style: UIAlertAction.Style.default) {
                                            [weak aC] (act: UIAlertAction) in
                                            print("\(aC?.actions.first?.title ?? "") tapped")
                }

                aC.addAction(act)
            }
            else {
                for act in actions {
                    aC.addAction(act)
                }
            }

            
            let vC = Common.appDelegate.window?.rootViewController
            vC?.present(aC, animated: true, completion: { [weak aC] in
                print("\(aC?.message ?? "") presented")
            })
        }
    }
    static let screenRect: CGRect = UIScreen.main.bounds
    static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    static let screenScale: CGFloat = UIScreen.main.scale
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let nCd: NotificationCenter = NotificationCenter.default
    static let duration: TimeInterval = 0.250
    
    static var safeAreaInsets: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return Common.appDelegate.window?.safeAreaInsets ?? UIEdgeInsets.zero
            } else {
                return UIEdgeInsets.zero
            }
        }
    }
    
    
    class func errWithDscpt(_ d: String) -> NSError? {
        if d.isEmpty {
            return nil
        }
        
        return NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: d])
    }
    
}



class Shadow: NSObject {
    
    var enabled: Bool = true {
        didSet {
            self.draw()
        }
    }
    
    var path: CGRect = CGRect.zero {
        didSet {
            self.draw()
        }
    }
    
    var offset: CGSize = CGSize.zero {
        didSet {
            self.draw()
        }
    }
    
    var radius: CGFloat = 0.0 {
        didSet {
            self.draw()
        }
    }
    
    var opacity: Float = 1.0 {
        didSet {
            self.draw()
        }
    }
    
    var color: UIColor? = UIColor.black {
        didSet {
            self.draw()
        }
    }
    
    weak var vw: UIView?
    
    override init() {
        super.init()
    }
    
    init(withVw vw: UIView?) {
        super.init()
        self.vw = vw
    }
    
    deinit {
        Log.d("\(self) \(#function)")
        
    }
    
    func draw() {
        if self.enabled {
            self.show()
        } else {
            self.hide()
        }
    }
    
    func show() {
        if self.vw != nil {
            /*if self.path.equalTo(CGRect.zero) {
             self.path = self.vw?.bounds ?? CGRect.zero
             }*/
            
            self.vw?.layer.shadowPath = UIBezierPath(rect: self.path).cgPath
            self.vw?.layer.shadowOffset = self.offset 
            self.vw?.layer.shadowOpacity = self.opacity
            self.vw?.layer.shadowRadius = self.radius
            self.vw?.layer.shadowColor = self.color?.cgColor
            self.vw?.layer.rasterizationScale = Common.screenScale
            self.vw?.clipsToBounds = false
        }
    }
    
    func hide() {
        self.vw?.layer.shadowOpacity = 0.0
        self.vw?.layer.shadowRadius = 0.0
    }
    
    func vwWillRotate() {
        self.vw?.layer.shadowPath = nil
        self.vw?.layer.shouldRasterize = true
    }
    
    func vwDidRotate() {
        self.draw()
        self.vw?.layer.shouldRasterize = false
    }
    
}
