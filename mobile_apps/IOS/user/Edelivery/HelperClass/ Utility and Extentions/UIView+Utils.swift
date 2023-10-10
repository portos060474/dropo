//
//  UIView+Utils.swift
//  BigRed
//
//  Created by Sapana Ranipa on 17/09/16.
//  Copyright © 2016 Elluminati. All rights reserved.
//

import UIKit
import SwiftUI

extension UIView {
    
    func applyRoundedCornersWithHeight(_ radius: CGFloat? = nil) {
        
        self.layer.cornerRadius = radius ?? self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    /// apply shadow effect
    func applyShadowToButton() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0, height:1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
    }
    
    //// for apply two corner Radius
    
    func applyBottomCornerRadius() {
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.bottomLeft,.bottomRight],
                                cornerRadii: CGSize(width: 10, height:  10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    func applyTopCornerRadius() {
        let path = UIBezierPath(roundedRect:UIScreen.main.bounds,
                                byRoundingCorners:[.topLeft,.topRight],
                                cornerRadii: CGSize(width: 20, height:  20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.frame = UIScreen.main.bounds
        self.layer.mask = maskLayer
    }
    func roundCorner(corners: UIRectCorner, withRadius radius: CGFloat) {
        let mask = UIBezierPath(roundedRect: UIScreen.main.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.frame = UIScreen.main.bounds
        shape.path = mask.cgPath
        self.layer.mask = shape
        
    }
    func applyTopRightBottomRightCornerRadius(width:CGFloat = 3.0, height:CGFloat =  3.0) {
        
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topRight,.bottomRight],
                                cornerRadii: CGSize(width: width, height:  height))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
    }
    
    
    func setRound(withBorderColor:UIColor=UIColor.clear, andCornerRadious:CGFloat = 0.0, borderWidth:CGFloat = 1.0){
        if andCornerRadious==0.0 {
            var frame:CGRect = self.frame
            frame.size.height=min(self.frame.size.width, self.frame.size.height)
            frame.size.width=frame.size.height
            self.frame=frame
            self.layer.cornerRadius=self.layer.frame.size.width/2
        }else {
            self.layer.cornerRadius=andCornerRadious
        }
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
        self.layer.borderColor = withBorderColor.cgColor
    }
    
    func setShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0),
                   shadowOpacity: Float = 1.0,
                   shadowRadius: CGFloat = 0.0){
        
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
    
    func sectionRound(_ lblSection:UILabel) {
        lblSection.sizeToFit()
        lblSection.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: lblSection.frame.size.width, height: 25))
        lblSection.baselineAdjustment = .alignCenters
        var path:UIBezierPath
        
        if UIApplication.isRTL() {
            path = UIBezierPath.init(roundedRect: lblSection.bounds, byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.topLeft],
                                     cornerRadii: CGSize(width: 5.0, height: 5.0))
            
        }else {
            path = UIBezierPath.init(roundedRect: lblSection.bounds, byRoundingCorners: [UIRectCorner.bottomRight,UIRectCorner.topRight],
                                     cornerRadii: CGSize(width: 5.0, height: 5.0))
        }
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        lblSection.layer.mask = mask
        lblSection.layer.contentsGravity = CALayerContentsGravity.center
    }
    
    func setGradient(startColor:UIColor,endColor:UIColor) {
        
        for layer:CALayer in self.layer.sublayers ?? [CALayer.init()] {
            if layer.name?.compare("gradient") == ComparisonResult.orderedSame {
                layer.removeFromSuperlayer()
            }
        }
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.name = "gradient"
        gradient.colors = [startColor.cgColor,endColor.cgColor,endColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    func addShadow(shadowColor: UIColor, cornerRadius: CGFloat = 0.0, shadowRadius: CGFloat = 6) {
        layer.cornerRadius = cornerRadius
        
        layer.shadowPath = UIBezierPath(rect:bounds).cgPath
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.shadowColor = shadowColor.cgColor
    }
    
    func applyShadowToView(_ cornerRadius : CGFloat = 5.0 ) {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0, height:0.7)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.5
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    func animationBottomTOTop(_ viewToAnimate : UIView, ignoreNavigation: Bool = true, withAnimation: Bool = true) {
        
        let viewframe = viewToAnimate.frame
        
        viewToAnimate.frame = CGRect.init(x: viewframe.origin.x, y: UIScreen.main.bounds.size.height, width: viewframe.size.width , height: viewframe.size.height)
        viewToAnimate.isHidden = false
        
        let navigationHeight = ignoreNavigation ? 0 : UIViewController().topBarHeight
        
        if withAnimation {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut],
                           animations: {
                viewToAnimate.frame = CGRect.init(x: viewframe.origin.x, y: (UIScreen.main.bounds.size.height - viewframe.size.height - navigationHeight), width: (viewframe.size.width), height: viewframe.size.height)
            }, completion: { test in
                
            })
        } else {
            viewToAnimate.frame = CGRect.init(x: viewframe.origin.x, y: (UIScreen.main.bounds.size.height - viewframe.size.height - navigationHeight), width: (viewframe.size.width), height: viewframe.size.height)
        }
    }
    func animationForHideView(_ viewToAnimate : UIView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut],
                       animations: {
            viewToAnimate.frame = CGRect.init(x: viewToAnimate.frame.origin.x, y: self.frame.height, width: viewToAnimate.frame.size.width, height: viewToAnimate.frame.size.height)
            
        }, completion: { test in
            
            completion()
        })
    }
    class CustomTextView : UITextField {
        func setup() {
            self.backgroundColor = .themeViewBackgroundColor
            
            
            
            self.borderStyle = .none
            self.tintColor = .themeTitleColor
            self.font = FontHelper.textRegular()
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.size.height))
            paddingView.backgroundColor = .clear
            self.leftView = paddingView
            self.leftViewMode = .always
            let rightview = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.size.height))
            rightview.backgroundColor = .clear
            self.rightView = rightview
            self.rightViewMode = .always
        }
        override var placeholder: String? {
            didSet {
                let placeholderString = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.themeLightTextColor])
                self.attributedPlaceholder = placeholderString
            }
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
    class CustomLightGrayView : UIView {
        func setup() {
            self.backgroundColor = .themeViewLightBackgroundColor
        }
        override func awakeFromNib() {
            setup()
        }
    }
}
class CustomCardView : UIView
{
    func setup() {
        self.backgroundColor = .themeViewBackgroundColor
        self.applyShadowToView()
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
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor
        
        self.addSublayer(border)
    }
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    func disable() {
        self.isUserInteractionEnabled = false
        self.alpha = 0.5
    }
    
    func enable() {
        self.isUserInteractionEnabled = true
        self.alpha = 1
    }
}

extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}

extension UITabBar {
    func addTabBarItem(title: String, imageName: String, selectedImageName: String, tagIndex: Int) -> UITabBarItem {
        let item = UITabBarItem(title: title,
                                image: UIImage(named: imageName),
                                selectedImage: UIImage(named: selectedImageName))
        item.titlePositionAdjustment = UIOffset(horizontal:0, vertical:-10)
        item.tag = tagIndex
        return item
    }
    
    override open var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UITraitCollection(horizontalSizeClass: .compact)
        }
        
        return super.traitCollection
    }
}




extension UINavigationBar {
    
    var castShadow : String {
        get { return "anything fake" }
        set {
            self.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
            self.layer.shadowRadius = 2.0
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOpacity = 0.17
        }
    }
    
}


extension UIScrollView {
    var currentPage: Int {
        let currentOffset = self.contentOffset.x
        let width = self.frame.size.width
        let currentPosition = Int((currentOffset + (0.5 * width)) / width)
        return currentPosition
    }
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
}

extension NSObject {
    
    class var nameOfClass: String {
        return String(describing: self)
    }
    
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        var indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        indexOfCharacter = indexOfCharacter + 2
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension UIView {
    func addDashedBorder(color: UIColor = UIColor.themeLightGrayColor) {

    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = 2
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [6,3]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath

    self.layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    func enable(_ isEnable: Bool, isAnimation: Bool = true) {
        self.isUserInteractionEnabled = isEnable
        if isAnimation {
            UIView.animate(withDuration: 0.3) {
                self.alpha = isEnable ? 1 : 0.5
            }
        } else {
            self.alpha = isEnable ? 1 : 0.5
        }
    }
}

extension UIApplication {
    static var topSafeAreaHeight: CGFloat {
        var topSafeAreaHeight: CGFloat = 0
         if #available(iOS 11.0, *) {
               let window = UIApplication.shared.windows[0]
               let safeFrame = window.safeAreaLayoutGuide.layoutFrame
               topSafeAreaHeight = safeFrame.minY
             }
        return topSafeAreaHeight
    }
    
    static var bottomSafeAreaHeight: CGFloat {
        var bottomSafeAreaHeight: CGFloat = 0

         if #available(iOS 11.0, *) {
             let window = UIApplication.shared.windows[0]
             let safeFrame = window.safeAreaLayoutGuide.layoutFrame
             bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        }
        
        return bottomSafeAreaHeight
    }
}
