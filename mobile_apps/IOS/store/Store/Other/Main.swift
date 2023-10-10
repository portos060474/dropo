//
//  Main.swift
//  HandymanServiceUser
//
//  Created by Mac Pro5 on 29/04/19.
//  Copyright © 2019 KetanMR_Elluminati. All rights reserved.
//

import Foundation
import UIKit

class MainVC: BaseVC {
    
    @IBOutlet weak var navigationBar: Vw?
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var btnLeft: UIButton?
    @IBOutlet weak var btnRight: UIButton?
   
    // MARK: - LifeCycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
    }
    func setupNavigationBar() {
       
        self.navigationBar?.backgroundColor = UIColor.themeNavigationBackgroundColor
        self.navigationBar?.shadow = Shadow(withVw: self.navigationBar)
        self.navigationBar?.shadow?.offset = CGSize(width: 0.0, height: 3.0)
        self.navigationBar?.shadow?.radius = 2.0
        self.navigationBar?.shadow?.opacity = 0.2
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationBar?.shadow?.path = self.navigationBar?.bounds ?? CGRect.zero
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUIAccordingToTheme()
    }
    
//    func updateUIAccordingToTheme(){
//    }
    // MARK: - StatusBar
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    // MARK: - Notification
//    func setNavigationTitle(title:String) -> Void {
//
//        lblTitle?.textAlignment = .center
//        lblTitle?.font = FontHelper.textRegular()
//        lblTitle?.textColor = UIColor.themeTextColor
//        lblTitle?.text = title
//    }
   
    
    // MARK: - IBAction
    @IBAction func btnLeftTapped(_ btn: UIButton = UIButton()) {
        
    }
    
    @IBAction func btnRightTapped(_ btn: UIButton = UIButton()) {
        
    }
    
}

class Vw: UIView {
    
    var shadow: Shadow?
    
    // MARK: - LifeCycle
    
    deinit {
        Log.d("\(self) \(#function)")
    }
    
    func setCustomShadow(shadowColor: UIColor = UIColor.themeNavigationBackgroundColor,
                   shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0),
                   shadowOpacity: Float = 2.0,
                   shadowRadius: CGFloat = 2.0) {
        self.backgroundColor = shadowColor
        self.shadow = Shadow(withVw: self)
        self.shadow?.offset = shadowOffset
        self.shadow?.radius = shadowRadius
        self.shadow?.opacity = shadowOpacity
    }
    override func layoutSubviews() {
        if self.shadow != nil {
            self.shadow?.path = self.bounds
        }
    }

}

class TblCell: UITableViewCell {
    
    var shadow: Shadow?
    var idxPath: IndexPath = IndexPath(row: -1, section: -1)
    
    // MARK: - LifeCycle
    
    deinit {
        Log.d("\(self) \(#function)")
    }
    
    // MARK: - Notification
    
   
    
}

class TblHdrFtr: UITableViewHeaderFooterView {
    
    var shadow: Shadow?
    var section: Int = -1
    
    // MARK: - LifeCycle
    
    deinit {
        Log.d("\(self) \(#function)")
    }
    
    // MARK: - Notification
    
    
    
}

class CltCell: UICollectionViewCell {
    
    @IBOutlet weak var vwContent: UIView?
    var shadow: Shadow?
    var idxPath: IndexPath = IndexPath(item: -1, section: -1)
    
    // MARK: - LifeCycle
    
    deinit {
        Log.d("\(self) \(#function)")
    }
    
    // MARK: - Notification
    
   
    
}

class BtmVw: Vw {
    
    @IBOutlet weak var btnClose: UIButton!
    weak var hC: NSLayoutConstraint!
    weak var btmC: NSLayoutConstraint!
    var isHitTest: Bool = true
    
    var height: CGFloat { 
        get {
            return Common.safeAreaInsets.bottom
        } 
    }
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.shadow = Shadow(withVw: self)
        self.shadow?.radius = 7.5
        self.shadow?.opacity = 0.2
        self.layer.cornerRadius = 15.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shadow?.path = self.bounds
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let vw: UIView? = super.hitTest(point, with: event)
        
        if self.isHitTest {
            if let btmC = self.btmC {
                if (vw == nil) && (btmC.constant >= 0.0) {
                    //self.hide()
                    self.btmC?.constant = -(self.hC?.constant ?? 0.0)
                    self.isHidden = true
                }
            }
        }
        
        return vw
    }
    
    // MARK: - IBAction
    
    @IBAction func btnCloseTapped(_ btn: UIButton = UIButton()) {
        self.hide()
    }
    
    // MARK: Other
    
    func add(intoSupervw supervw: UIView, _ isHitTest: Bool = true) {
        self.isHitTest = isHitTest
        self.translatesAutoresizingMaskIntoConstraints = false
        supervw.addSubview(self)
        
        let h: CGFloat = self.height
        let btm: CGFloat = 0.0
        let vws: [String: Any] = ["self": self]
        var constraints: [String] = []
        
        constraints.append("H:|-0-[self]-0-|")
        constraints.append(String(format: "V:[self(%lf)]-%lf-|", h, btm))
        constraints.forEach { (constraint: String) in 
            var constraints: [NSLayoutConstraint] = []
            constraints += NSLayoutConstraint.constraints(withVisualFormat: constraint, 
                                                          options: NSLayoutConstraint.FormatOptions(rawValue: 159), 
                                                          metrics: nil, 
                                                          views: vws)
            NSLayoutConstraint.activate(constraints)
            
            for c in constraints {
                let attrbH = NSLayoutConstraint.Attribute.height
                let attrbBtm = NSLayoutConstraint.Attribute.bottom
                
                if c.firstAttribute == attrbH {
                    self.hC = c
                }
                
                if (c.firstAttribute == attrbBtm) && 
                    (c.secondAttribute == attrbBtm) {
                    self.btmC = c
                }
            }
            
            self.btmC?.constant = -(self.hC?.constant ?? 0.0)
        }
    }
    
    func show() {
        self.isHidden = false
        
        UIView.animate(withDuration: Common.duration,
                       animations: {
                        self.btmC?.constant = 0.0
                        self.superview?.layoutIfNeeded()
        }) { (bl: Bool) in
        }
    }
    
    func hide() {
        UIView.animate(withDuration: Common.duration,
                       animations: {
                        self.btmC?.constant = -(self.hC?.constant ?? 0.0)
                        self.superview?.layoutIfNeeded()                        
        }) { (bl: Bool) in
            self.isHidden = true
        }
    }
    
}
