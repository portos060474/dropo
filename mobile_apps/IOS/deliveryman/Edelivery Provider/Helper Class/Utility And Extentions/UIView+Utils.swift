//
//  UIView+Utils.swift
//  BigRed
//
//  Created by Sapana Ranipa on 17/09/16.
//  Copyright © 2016 Elluminati. All rights reserved.
//

import UIKit

extension UIView {
    func applyRoundedCornersWithOutBorder(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2;
        self.layer.masksToBounds = true;
    }
    
    func applyRoundedCornersWithHeight(_ radius: CGFloat? = nil) {
        
        self.layer.cornerRadius = radius ?? self.frame.height / 2;
        self.layer.masksToBounds = true;
    }
    
    func applyRoundedCornersFullWithColorAndWidth(_ color : UIColor?=nil , width : CGFloat?=nil) {
        
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.borderColor = color?.cgColor ?? UIColor.clear.cgColor;
        self.layer.borderWidth = width ?? 3.0;
        self.layer.masksToBounds = true;
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
    func sectionRound(_ lblSection:UILabel) {
        lblSection.sizeToFit();
        lblSection.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: lblSection.frame.size.width, height: 25))
        lblSection.baselineAdjustment = .alignCenters
        var path:UIBezierPath;
        
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
    
    func applyBottomCornerRadius() {
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.bottomLeft,.bottomRight],
                                cornerRadii: CGSize(width: 10, height:  10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
   
    func applyTopRightBottomRightCornerRadius() {
        
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topRight,.bottomRight],
                                cornerRadii: CGSize(width: 3, height:  3))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
    }
    
    func  setRound(withBorderColor:UIColor=UIColor.clear, andCornerRadious:CGFloat = 0.0, borderWidth:CGFloat = 1.0) {
        if andCornerRadious==0.0 {
            var frame:CGRect = self.frame;
            frame.size.height=min(self.frame.size.width, self.frame.size.height) ;
            frame.size.width=frame.size.height;
            self.frame=frame;
            self.layer.cornerRadius=self.layer.frame.size.width/2;
            
        }else {
            self.layer.cornerRadius=andCornerRadious;
        }
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = withBorderColor.cgColor
        self.clipsToBounds = true;
        
        
    }
    
    func setShadow(shadowColor: CGColor = UIColor.black.cgColor,
                          shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0),
                          shadowOpacity: Float = 1.0,
                          shadowRadius: CGFloat = 0.0){
        
        self.layer.shadowColor = shadowColor;
        self.layer.shadowOffset = shadowOffset;
        self.layer.shadowOpacity = shadowOpacity;
        self.layer.shadowRadius = shadowRadius;
        self.layer.masksToBounds = false;
        
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
    func roundCorner(corners: UIRectCorner, withRadius radius: CGFloat) {
       let mask = UIBezierPath(roundedRect: UIScreen.main.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
       let shape = CAShapeLayer()
       shape.frame = UIScreen.main.bounds
       shape.path = mask.cgPath
       self.layer.mask = shape
     }
    func animationBottomTOTop(_ viewToAnimate : UIView ) {
        
        let viewframe = viewToAnimate.frame
        viewToAnimate.isHidden = true
       
            viewToAnimate.frame = CGRect.init(x: viewframe.origin.x, y: viewToAnimate.frame.height, width: viewframe.size.width , height: viewframe.size.height)
        
        
        viewToAnimate.isHidden = false
       
        
            
        
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut],
                animations: {
                    viewToAnimate.frame = CGRect.init(x: viewframe.origin.x, y: (viewToAnimate.frame.size.height - viewframe.size.height), width: (viewframe.size.width), height: viewframe.size.height)
                    }, completion: { test in
                        viewToAnimate.layer.removeAllAnimations()
            })
        
        
    }
    func animationForHideAView(_ viewToAnimate : UIView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut],
                       animations: {
                        viewToAnimate.frame = CGRect.init(x: viewToAnimate.frame.origin.x, y: self.frame.height, width: viewToAnimate.frame.size.width, height: viewToAnimate.frame.size.height)
                        
        }, completion: { test in
            
            completion()
        })
    }
 
}
extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
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
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}
final class PaddedLabel: UILabel {
    var padding: UIEdgeInsets?
    override func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            if let insets = padding {
                contentSize.height += insets.top + insets.bottom
                contentSize.width += insets.left + insets.right
            }
            return contentSize
        }
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
}


class CustomCardView : UIView
{
    func setup() {
        self.backgroundColor = .themeViewBackgroundColor
//        self.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 5.0, borderWidth: 0.3)
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

class CustomLightGrayView : UIView {
    func setup() {
        self.backgroundColor = .themeViewLightBackgroundColor
    }
    override func awakeFromNib() {
        setup()
    }
}
class TextLabel : UILabel {
    func setup() {
        self.font = FontHelper.textRegular()
        self.textColor = .themeLightTextColor
        self.backgroundColor = .themeViewBackgroundColor
    }
    override func awakeFromNib() {
        setup()
    }
}

class CustomBottomButton : UIButton
{
    func setup() {
        self.titleLabel?.font = FontHelper.buttonText()
        self.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        self.backgroundColor = UIColor.themeButtonBackgroundColor
        self.setRound(withBorderColor: UIColor.themeButtonBackgroundColor, andCornerRadious: self.frame.height/2.0, borderWidth: 0.0)
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
extension UIImage {

    func imageWithColor(color: UIColor = .themeColor) -> UIImage? {
            var image = withRenderingMode(.alwaysTemplate)
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            color.set()
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }
}
class CustomPaddingLabel: UILabel {
    var textEdgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textEdgeInsets))
        self.paddingTop = 3
        self.paddingBottom = 3
        self.paddingLeft = 10
        self.paddingRight = 10
        self.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 4.0, borderWidth: 0.0)
        self.backgroundColor = .themeViewLightBackgroundColor
        self.textColor = .themeLightGrayTextColor
        self.font = FontHelper.textRegular()
    }
    
    @IBInspectable
    var paddingLeft: CGFloat {
        set { textEdgeInsets.left = newValue }
        get { return textEdgeInsets.left }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        set { textEdgeInsets.right = newValue }
        get { return textEdgeInsets.right }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        set { textEdgeInsets.top = newValue }
        get { return textEdgeInsets.top }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        set { textEdgeInsets.bottom = newValue }
        get { return textEdgeInsets.bottom }
    }
}

class CustomTextView : UITextField {
    func setup() {
        self.backgroundColor = .themeViewBackgroundColor
        
        
        
        self.borderStyle = .none
        self.tintColor = .themeTextColor
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

class CustomOTPField : UITextField {
    func setup() {
        self.backgroundColor = .themeViewBackgroundColor
        
        
        
        self.borderStyle = .none
        self.tintColor = .themeTextColor
        self.font = FontHelper.textRegular()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.size.height))
        paddingView.backgroundColor = .clear
        self.leftView = paddingView
        self.leftViewMode = .always
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

extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}

extension Notification.Name {
    static let didChangeCustomLocation = Notification.Name(rawValue: "didChangeCustomLocation")
}
