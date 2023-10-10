//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class ChooseOrRepeat: CustomDialog {
 
    //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCustomization: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnChoose: UIButton!
    @IBOutlet weak var alertView: UIView!
 
    //MARK:Variables
    var onClickRightButton : (() -> Void)? = nil
    var onClickChoose : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  dialogNibName = "ChooseOrRepeat"
    
    public static func  showChooseOrRepeatDialog
        (title:String,
         customization:String,
         titleLeftButton:String,
         strRepeat:String,
         strChoose:String,
         tag:Int = 958
         ) -> ChooseOrRepeat
     {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ChooseOrRepeat
        view.tag = tag
        if ((APPDELEGATE.window?.viewWithTag(tag)) != nil) {
            APPDELEGATE.window?.bringSubviewToFront((APPDELEGATE.window?.viewWithTag(tag))!)
        }else {
            view.setLocalization()
            let frame = (APPDELEGATE.window?.frame)!;
            view.frame = frame;
            view.lblTitle.text = title;
            view.lblCustomization.text = customization;
            view.btnRight.setTitle(strRepeat, for: UIControl.State.normal)
            view.btnChoose.setTitle(strChoose, for: UIControl.State.normal)
        
            DispatchQueue.main.async{
                UIApplication.shared.keyWindow?.addSubview(view)
                APPDELEGATE.window?.bringSubviewToFront(view);
                view.alertView.layoutIfNeeded()
                view.animationBottomTOTop(view.alertView)
            }
        }
       
        return view;
    }

    func setLocalization() {
        alertView.backgroundColor = UIColor.themeAlertViewBackgroundColor
        backgroundColor = UIColor.themeOverlayColor
        lblTitle.textColor = UIColor.themeTextColor;
        lblTitle.font = FontHelper.textMedium(size:18)
        lblCustomization.textColor = UIColor.themeLightGrayColor
        lblCustomization.font = FontHelper.labelRegular()
        btnRight.titleLabel?.font = FontHelper.textRegular(size: 14)
        btnLeft.setImage(UIImage.init(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }
    
    override func updateUIAccordingToTheme() {
        self.setLocalization()
    }

    //ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any) {
      
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.alertView.frame = CGRect.init(x: self.alertView.frame.origin.x, y: self.frame.height, width: self.alertView.frame.size.width, height: self.alertView.frame.size.height)
                        
        }, completion: { test in
            if self.onClickLeftButton != nil {
                self.onClickLeftButton!();
                self.removeFromSuperview()
            }
            
        })
    }
    @IBAction func onClickBtnRight(_ sender: UIButton) {
        if sender.tag == 1 {
            if self.onClickRightButton != nil {
                self.onClickRightButton!()
            }
        } else {
            if self.onClickChoose != nil {
                self.onClickChoose!()
            }
        }
    }
}



