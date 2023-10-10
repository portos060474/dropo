//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomConfirmationDialog: CustomDialog, UITextFieldDelegate {
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var editTextOne: UITextField!
    @IBOutlet weak var editTextTwo: UITextField!
    
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblCountryPhoneCode: UILabel!
    @IBOutlet weak var stkPhoneView: UIStackView!

    //MARK: - Variables
    var onClickRightButton : ((_ text1:String , _ text2:String ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let dialogNibName = "dialogForConfirmation"

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public static func showCustomConfirmationDialog
        (title:String,
         message:String,
       /*  titleLeftButton:String,*/
         strImage:String,
         titleRightButton:String,
         editTextOneText:String,
         editTextTwoText:String,
         isEdiTextTwoIsHidden:Bool,
         isEdiTextOneIsHidden:Bool
         ) -> CustomConfirmationDialog {

        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomConfirmationDialog
        view.alertView.setShadow()
        view.setLocalization()
        view.btnRight.setTitleColor(.themeButtonTitleColor, for: .normal)
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.lblMessage.text = message;
//        view.btnLeft.setTitle(titleLeftButton.uppercased(), for: UIControl.State.normal)
        view.btnLeft.tintColor = .themeColor
        view.btnLeft.setImage(UIImage.init(named: strImage)?.imageWithColor(), for: .normal)
        view.btnRight.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)
        
        if isEdiTextOneIsHidden {
            view.editTextOne.isHidden = true;
        }else {
            view.editTextOne.isHidden = false;
            view.editTextOne.text = editTextOneText;
            
        }
        if isEdiTextTwoIsHidden {
            view.editTextTwo.text = "";
            view.stkPhoneView.isHidden = true;
            view.lblCountryPhoneCode.text = "";
            
        }else {
            view.editTextTwo.text = editTextTwoText;
            view.stkPhoneView.isHidden = false;
            view.lblCountryPhoneCode.text = preferenceHelper.getPhoneCountryCode()
        }
         
        DispatchQueue.main.async {
            view.alertView.layoutIfNeeded()
            view.animationBottomTOTop(view.alertView)
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
        }
        return view;
    }
    
    func setLocalization() {

        /* Set Color */
        btnRight.setTitleColor(.themeButtonTitleColor, for: .normal)
       // btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
       // btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeTextColor
        editTextOne.textColor = UIColor.themeTextColor
        editTextTwo.textColor = UIColor.themeTextColor
        self.backgroundColor = UIColor.themeOverlayColor
        alertView.backgroundColor = UIColor.themeAlertViewBackgroundColor
       // alertView.setRound(withBorderColor: UIColor.clear, andCornerRadious: 3.0, borderWidth: 1.0)
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        /* Set Font */
        btnRight.setTitleColor(.themeButtonTitleColor, for: .normal)
        btnLeft.titleLabel?.font =  FontHelper.textRegular(size:14)
        
        lblTitle.font = FontHelper.textLarge()
        lblMessage.font =  FontHelper.textRegular()
        editTextOne.font =  FontHelper.textRegular()
        editTextTwo.font =  FontHelper.textRegular()
        
        
        
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == self.editTextOne {
            if editTextTwo.isHidden {
                textField.resignFirstResponder()
            }else {
                editTextTwo.becomeFirstResponder()
            }
        
        }else {
            textField.resignFirstResponder();
        }
        
        
        return true
    }
    //ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!();
        }
    }
    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!(editTextOne.text ?? "",editTextTwo.text ?? "")
        }
    }
   }


