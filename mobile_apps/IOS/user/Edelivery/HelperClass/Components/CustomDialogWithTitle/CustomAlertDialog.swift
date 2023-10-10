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
            let frame = (APPDELEGATE.window?.frame)!;
            view.frame = frame;
            view.lblTitle.text = title;
            view.lblMessage.text = message;
            view.btnRight.setTitle(titleRightButton, for: UIControl.State.normal)
        
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
        lblMessage.textColor = UIColor.themeTextColor
        lblMessage.font = FontHelper.labelRegular()
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
    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!()
        }
    }
}



