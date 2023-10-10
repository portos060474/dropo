//
//  CustomFeedbackDialog.swift
//  Store
//
//  Created by elluminati macmini on 7/27/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
public class CustomFeedbackDialog:CustomDialog,UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate{
    
    @IBOutlet weak var alertView:UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var cosmosVw: CosmosView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var viewForTextField: UIView!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var btnApply: CustomBottomButton!
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    public var isRateToUser:Bool = false
    static let  dialogNibName = "dialogForFeedback"
    public var selectedOrderID:String = ""
    var isFromHistory:Bool = false
    var rate:Double =  0.0
    var onClickApplyButton : ((_ rating: String) -> Void)? = nil
    var activeField: UITextField?
    public static func  showCustomFeedbackDialog(_ isRateForUser: Bool , _ FromHistory: Bool ,_ order_id : String, name : String ,tag:Int = 414, storeRate: Double = 0.0) -> CustomFeedbackDialog{
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomFeedbackDialog
        view.tag = tag
        view.isRateToUser = isRateForUser
        view.isFromHistory = FromHistory
        view.selectedOrderID = order_id
        view.setupLocalization()
        view.lblTitle.text = name
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.txtComment.delegate = view
        DispatchQueue.main.async{
            UIApplication.shared.keyWindow?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
            view.animationBottomTOTop(view.alertView)
        }
        if storeRate != 0.0 {
            view.cosmosVw.rating = storeRate
        }
        
        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        view.cosmosVw.rating = 0.0
        view.cosmosVw.settings.minTouchRating = 0.5
        view.cosmosVw.didTouchCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didTouchCosmos: \(rating)")
        }
        view.cosmosVw.didFinishTouchingCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didFinishTouchingCosmos: \(rating)")
            view.rate = rating
        }
//        view.alertView.layoutIfNeeded()
        
        return view;
    }

func setupLocalization(){
    
    lblTitle.text = "TXT_FEEDBACK".localizedCapitalized
    lblTitle.font = FontHelper.textLarge()
    lblTitle.textColor = UIColor.themeTitleColor
    lblComment.text = "TXT_COMMENT".localized
    lblMessage.text = "TXT_FD_MSG".localized
    lblComment.font = FontHelper.textRegular()
    lblMessage.font = FontHelper.textRegular()
    lblComment.textColor = .themeLightTextColor
    lblMessage.textColor = .themeTextColor
    btnApply.setTitle("TXT_APPLY".localized, for: .normal)
    
    txtComment.textColor = .themeTextColor
    txtComment.delegate = self
    txtComment.font = FontHelper.textRegular()
    
    
/*    self.ratingView.emptyImage = UIImage(named: "nf")?.imageWithColor(color: UIColor.themeTitleColor)
    self.ratingView.fullImage = UIImage(named: "ff")?.imageWithColor(color: UIColor.themeColor)
    self.ratingView.delegate = self
    self.ratingView.contentMode = UIView.ContentMode.scaleAspectFit
    self.ratingView.maxRating = 5
    self.ratingView.minRating = 1
    self.ratingView.rating = 0.0
    self.ratingView.editable = true
    self.ratingView.halfRatings = true
    self.ratingView.floatRatings = false
    */
    self.cosmosVw.rating = 0.0
    self.cosmosVw.didTouchCosmos = { /*[unowned self]*/ (rating: Double) -> () in
        //debugPrint("self.cosmosVw.didTouchCosmos: \(rating)")
    }
    self.cosmosVw.didFinishTouchingCosmos = { /*[unowned self]*/ (rating: Double) -> () in
        //debugPrint("self.cosmosVw.didFinishTouchingCosmos: \(rating)")
        self.rate = rating
    }
    self.cosmosVw.settings.filledImage = UIImage(named: "ff")?.imageWithColor(color: UIColor.themeColor)
    self.cosmosVw.settings.emptyImage = UIImage(named: "nf")?.imageWithColor(color: UIColor.themeIconTintColor)
    self.cosmosVw.settings.fillMode = .half
    self.cosmosVw.settings.starSize = Double(self.cosmosVw.frame.size.height)
    self.cosmosVw.settings.minTouchRating = 0.5
    if UIApplication.isRTL(){
//            self.ratingView.semanticContentAttribute = .forceRightToLeft
        self.txtComment.semanticContentAttribute = .forceRightToLeft
        self.txtComment.textAlignment = .right
    }else{
//            self.ratingView.semanticContentAttribute = .forceLeftToRight
        self.txtComment.semanticContentAttribute = .forceLeftToRight
        self.txtComment.textAlignment = .left
    }

    viewForTextField.backgroundColor = .themeViewBackgroundColor
    alertView.backgroundColor = .themeViewBackgroundColor
   
    self.alertView.updateConstraintsIfNeeded()
    self.alertView.applyTopCornerRadius()
    self.backgroundColor = UIColor.themeOverlayColor
    
   
    btnCancel.setImage(UIImage(named: "cancel_icon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
}

    @IBAction func onClickCancel(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    @IBAction func onClickApply(_ sender: UIButton) {
        
        self.endEditing(true)
      
        
        if rate != 0.0 {
            
            if isRateToUser {
                wsRateToUser()
            }else {
                wsRateToProvider()
            }
           
        }else {
            if isRateToUser {
                Utility.showToast(message: "MSG_ENTER_RATE".localized)
            }else{
                Utility.showToast(message: "MSG_ENTER_RATE_PROVIDER".localized)
            }
        }
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        self.bottomConstraint.constant = keyboardSize!.height
        if let activeFieldPresent = activeField
        {
            _ = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero

            if (aRect.contains(activeField!.frame.origin))
            {
                bottomConstraint.constant = 0.0
                UIView.animate(withDuration: 1.0) {
                    self.bottomConstraint.constant = keyboardSize!.height
                }
            }
        }
    }
    
    override func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var _ : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        
        UIView.animate(withDuration: 1.0) {
            self.bottomConstraint.constant = 0.0
        }
        self.endEditing(true)
    }


  
func wsRateToUser() {
    Utility.showLoading()
    var review:String = txtComment.text ?? ""
    if review.compare("TXT_COMMENT_PLACEHOLDER".localized) == .orderedSame {
        review = ""
    }
    
    let dictParam: Dictionary<String,Any> =
        [PARAMS.STORE_ID:preferenceHelper.getUserId(),
         PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
         PARAMS.ORDER_ID:selectedOrderID,
         PARAMS.STORE_REVIEW_TO_USER:review,
         PARAMS.STORE_RATING_TO_USER:rate
    ];
    let afn:AlamofireHelper = AlamofireHelper.init();
    afn.getResponseFromURL(url: WebService.WS_STORE_RATE_TO_USER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
        Utility.hideLoading()
        if (Parser.isSuccess(response: response,withSuccessToast: true,andErrorToast: true)) {
            APPDELEGATE.goToMain()
            return
        }
    }
}
    
func wsRateToProvider() {
    
    
    Utility.showLoading()
    var review:String = txtComment.text ?? ""
    if review.compare("TXT_COMMENT_PLACEHOLDER".localized) == .orderedSame {
        review = ""
    }
    
    let dictParam: Dictionary<String,Any> =
        [PARAMS.STORE_ID:preferenceHelper.getUserId(),
        PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
         PARAMS.ORDER_ID:selectedOrderID,
         PARAMS.STORE_REVIEW_TO_PROVIDER:review,
         PARAMS.STORE_RATING_TO_PROVIDER:rate
    ];
    let afn:AlamofireHelper = AlamofireHelper.init();
    afn.getResponseFromURL(url: WebService.WS_STORE_RATE_TO_PROVIDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
        Utility.hideLoading()
        if (Parser.isSuccess(response: response,withSuccessToast: true,andErrorToast: true)) {
            APPDELEGATE.goToMain()
            return
        }
    }
}
}
