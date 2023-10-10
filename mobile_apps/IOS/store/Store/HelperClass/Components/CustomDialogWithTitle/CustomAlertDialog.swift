//
//  CustomPhotoDialog.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 22/02/17.
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

    //MARK:- Variables
    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let verificationDialog = "dialogForAlert"
    var isFromAdminConfimationDialog:Bool = false

    public static func showCustomAlertDialog (title:String, message:String, titleLeftButton:String, titleRightButton:String, isFromAdminConfimationDialog:Bool = false, isHideCloseButton:Bool = false) -> CustomAlertDialog {

        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomAlertDialog
        view.tag = 400
        view.alertView.setShadow()
        view.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.lblMessage.text = message;
        view.isFromAdminConfimationDialog = isFromAdminConfimationDialog

        view.setLocalization()
//        view.btnLeft.setTitle(titleLeftButton.uppercased(), for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)
        view.btnRight.titleLabel?.font = FontHelper.textMedium()

        if isHideCloseButton {
            view.btnLeft.isHidden = true
        } else {
            view.btnLeft.isHidden = false
        }

        if let view1 = (APPDELEGATE.window?.viewWithTag(400)) {
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.bringSubviewToFront(view1);
            }
        } else {
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.addSubview(view)
                UIApplication.shared.keyWindow?.bringSubviewToFront(view);
                view.animationBottomTOTop(view.alertView)
            }
        }
        return view;
    }

    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }

    override func updateUIAccordingToTheme() {
        if isFromAdminConfimationDialog {
            btnLeft.setImage(UIImage(named: "logoutIcon")?.imageWithColor(color: .themeColor), for: .normal)
        } else {
            btnLeft.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
        }
    }

    func setLocalization() {
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeLightTextColor

        lblTitle.font = FontHelper.textLargeMedium()
        lblMessage.font = FontHelper.textRegular()

        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeOverlayColor
        alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        updateUIAccordingToTheme()
    }

    //MARK:- Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!();
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!()
        }
    }
}
