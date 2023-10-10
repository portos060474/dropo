//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomAlertDialog: CustomDialog {
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    //MARK:Variables
    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  dialogNibName = "dialogForAlert"
    public static func  showCustomAlertDialog
        (title:String,
         message:String,
         titleLeftButton:String,
         titleRightButton:String,
         isAnimation : Bool = true ,
         tag:Int = 400
         ) ->
        CustomAlertDialog
     {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomAlertDialog
        view.tag = tag
        if ((APPDELEGATE.window?.viewWithTag(tag)) != nil) {
            APPDELEGATE.window?.bringSubviewToFront((APPDELEGATE.window?.viewWithTag(tag))!)
        }else {
            view.setLocalization()
            view.alertView.setShadow()
            let frame = (APPDELEGATE.window?.frame)!;
            view.frame = frame;
            view.lblTitle.text = title;
            view.lblMessage.text = message;
            view.btnLeft.setTitle("", for: UIControl.State.normal)
            view.btnLeft.isUserInteractionEnabled = true

            view.btnRight.setTitle(titleRightButton, for: UIControl.State.normal)
            DispatchQueue.main.async{
                UIApplication.shared.keyWindow?.addSubview(view)
                APPDELEGATE.window?.bringSubviewToFront(view);
            }
        }
        //view.alertView.layoutIfNeeded()
       /* DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if view.alertView != nil {
                view.animationBottomTOTop(view.alertView)
            }
        }*/
        if isAnimation {
            DispatchQueue.main.async {
                if view.alertView != nil {
                    view.animationBottomTOTop(view.alertView)
                }
            }
        }
        return view;
    }
    
    func setLocalization() {
        alertView.backgroundColor = UIColor.themeAlertViewBackgroundColor
        backgroundColor = UIColor.themeOverlayColor
        lblTitle.textColor = UIColor.themeTextColor;
        lblTitle.font = FontHelper.textLarge()
        lblMessage.textColor = UIColor.themeTextColor;
        btnLeft.titleLabel?.font = FontHelper.textRegular(size: 14)
        //btnRight.titleLabel?.font = FontHelper.textRegular(size: 14)
        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnLeft.tintColor = .themeColor
        //btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
       // alertView.setRound(withBorderColor: UIColor.clear, andCornerRadious: 3.0, borderWidth: 1.0)
        btnRight.setTitleColor(.themeButtonTitleColor, for: .normal)
        btnLeft.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        btnLeft.backgroundColor = .clear
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }
    //ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.animationForHideAView(alertView) {
                self.onClickLeftButton!();
            }
        }
    }
    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.animationForHideAView(alertView) {
                self.onClickRightButton!()
            }
        }
    }
}


