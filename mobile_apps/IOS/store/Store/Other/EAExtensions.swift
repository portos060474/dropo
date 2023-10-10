//
//  EAExtensions.swift
//  HandymanServiceUser
//
//  Created by Mac Pro5 on 29/04/19.
//  Copyright © 2019 KetanMR_Elluminati. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    class var name: String {
        return String(describing: self)
    }
    
}

extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
}

extension UIViewController {
    
    func clean() {
        for child in self.children {
            child.clean()
        }
        
        if self.isKind(of: UINavigationController.self) {
            (self as! UINavigationController).viewControllers = []
        }
        
        if self.isKind(of: UITabBarController.self) {
            (self as! UITabBarController).viewControllers = []
        }
        
        self.view.clean()
        self.dismiss(animated: false, completion: nil)
        self.removeFromParent()
        NotificationCenter.default.removeObserver(self)
    }
    
    class func fromNib<T: UIViewController>() -> T {
        let type = self.self
        return type.init(nibName: type.name, bundle: nil) as! T
    }
    
}

extension UIView {
    
    func clean() {
        for subvw in self.subviews {
            subvw.clean()
        }
        
        self.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    class func fromNib<T: UIView>() -> T {
        let type = self.self
        let nibObjs = Bundle.main.loadNibNamed(type.name, owner: nil, options: nil)
        
        if nibObjs != nil {
            for nibObj in nibObjs! {
                let obj = nibObj as AnyObject
                
                if obj.isKind(of: type) {
                    return obj as! T
                }
            } 
        }
        
        return type.init() as! T
    }
    
    class func nib() -> UINib {
        let type = self.self
        return UINib(nibName: type.name, bundle: nil)
    }
    
    func roundCorners(_ corners: UIRectCorner, _ radius: CGSize) {
        let path = UIBezierPath(roundedRect: self.bounds, 
                                byRoundingCorners: corners, 
                                cornerRadii: radius)
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setBorder( borderwidth:CGFloat = 0.5 ,  borderColor:UIColor = UIColor.themeLightTextColor) {
            self.layer.borderWidth = borderwidth
            self.layer.borderColor = borderColor.cgColor
            self.clipsToBounds = true;
        }
    
}

extension UIScrollView {
    
    var isWEqualToCW: Bool {
        get {
            return abs(ceil(self.frame.width)-ceil(self.contentSize.width)) <= 1.0
        }
    }
    
    var isHEqualToCH: Bool {
        get {
            return abs(ceil(self.frame.height)-ceil(self.contentSize.height)) <= 1.0
        }
    }
    
}

extension UITableView {
    
    func reloadData(_ completion: (() -> Void)?) {
        DispatchQueue.main.async { 
            CATransaction.begin()
            CATransaction.setCompletionBlock({ 
                completion?()
            })
            self.reloadData()
            CATransaction.commit()
        }
    }
    
    func reloadData(widthToFit cntrnt: NSLayoutConstraint?, 
                    _ completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.contentOffset = CGPoint.zero
            self.reloadData({ 
                cntrnt?.constant = self.contentSize.width
                self.superview?.layoutIfNeeded()
                
                if self.isHEqualToCH {
                    completion?()
                }
                else {
                    self.reloadData(widthToFit: cntrnt, completion)
                }
            })
        }
    }
    
    func reloadData(heightToFit cntrnt: NSLayoutConstraint?, 
                    _ completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.contentOffset = CGPoint.zero
            self.reloadData({ 
                cntrnt?.constant = self.contentSize.height
                self.superview?.layoutIfNeeded()
                
                if self.isHEqualToCH {
                    completion?()
                }
                else {
                    self.reloadData(heightToFit: cntrnt, completion)
                }
            })
        }
    }
    
    func deleteRows(at indexPaths: [IndexPath], 
                    with animation: UITableView.RowAnimation, 
                    _ completion: (() -> Void)?) {
        DispatchQueue.main.async { 
            CATransaction.begin()
            CATransaction.setCompletionBlock({ 
                completion?()
            })
            self.deleteRows(at: indexPaths, with: animation)
            CATransaction.commit()
        }
    }
    
}

extension UICollectionView {
    
    func reloadData(_ completion: (() -> Void)?) {
        DispatchQueue.main.async { 
            CATransaction.begin()
            CATransaction.setCompletionBlock({ 
                completion?()
            })
            self.reloadData()
            CATransaction.commit()
        }
    }
    
}


extension UILabel {
    
    func txtBound(_ w: CGFloat = 0.0, _ h: CGFloat = 0.0) -> CGRect {
        let width: CGFloat = w <= 0.0 ? CGFloat.greatestFiniteMagnitude : w
        let height: CGFloat = h <= 0.0 ? CGFloat.greatestFiniteMagnitude : h
        let size: CGSize = CGSize(width: width, height: height)
        let drawOpt: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        var attrbs: [NSAttributedString.Key: Any] = [:]
        var rect: CGRect = CGRect.zero
        
        if let txt: String = self.text {
            attrbs[NSAttributedString.Key.font] = self.font
            rect = txt.boundingRect(with: size, 
                                    options: drawOpt, 
                                    attributes: attrbs, 
                                    context: nil)
        }
        
        return rect
    }
    
    func attrbTxtBound(_ w: CGFloat = 0.0, _ h: CGFloat = 0.0) -> CGRect {
        let width: CGFloat = w <= 0.0 ? CGFloat.greatestFiniteMagnitude : w
        let height: CGFloat = h <= 0.0 ? CGFloat.greatestFiniteMagnitude : h
        let size: CGSize = CGSize(width: width, height: height)
        let drawOpt: NSStringDrawingOptions = [NSStringDrawingOptions.usesLineFragmentOrigin,
                                               NSStringDrawingOptions.usesFontLeading]
        var attrbs: [NSAttributedString.Key: Any] = [:]
        var rect: CGRect = CGRect.zero
        
        if let attrbTxt: NSAttributedString = self.attributedText {
            // Don't delete following code, useful for debug purpose
            attrbTxt.enumerateAttributes(in: NSRange(0..<attrbTxt.length), 
                                         options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired)  { (attributes: [NSAttributedString.Key : Any], 
                range: NSRange, 
                unsafeMutablePointerObjCBool: UnsafeMutablePointer<ObjCBool>) in
                attrbs.merge(attributes, 
                             uniquingKeysWith: { (current: Any, new: Any) -> Any in
                                return new 
                })
            }
            
            rect = attrbTxt.boundingRect(with: size, 
                                         options: drawOpt, 
                                         context: nil)
        }
        
        return rect
    }
    
}
