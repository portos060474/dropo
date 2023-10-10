//
//  DailogForFeedback.swift
//  Edelivery Provider
//
//  Created by Elluminati on 01/03/21.
//  Copyright © 2021 Elluminati iMac. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Cosmos

class DailogForFeedback: CustomDialog,UITextFieldDelegate{

    @IBOutlet weak var constraintForBottom: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewForTextField: UIView!
    @IBOutlet weak var btnFilter: CustomBottomButton!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var cosmosVw: CosmosView!
    
    static let  dialogNibName = "dailogForFeedback"
    var rate:Double =  0.0
    var keyboardHeight : CGFloat = 50.0
    public var selectedOrderID:String = ""
    var isFromHistory:Bool = false
    var onClickApplyButton : ((_ rating: String) -> Void)? = nil
    public var isRateToProvider:Bool = false
    public static func  showCustomFeedbackDialog(_ isRateForUser: Bool , _ FromHistory: Bool ,_ order_id : String, name : String ,tag:Int = 414, storeRate: Double = 0.0) -> DailogForFeedback
    {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DailogForFeedback
        view.tag = tag
        view.isRateToProvider = isRateForUser
        view.isFromHistory = FromHistory
        view.selectedOrderID = order_id
        view.setupLocalization()
        view.lblTitle.text = name
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
           
        DispatchQueue.main.async{
            UIApplication.shared.keyWindow?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
            view.animationBottomTOTop(view.alertView)
        }
        if storeRate != 0.0 {
            view.cosmosVw.rating = storeRate
        }
        view.cosmosVw.rating = 0.0
        view.cosmosVw.settings.minTouchRating = 0.5
        view.cosmosVw.didTouchCosmos = { (rating: Double) -> () in
        }
        view.cosmosVw.didFinishTouchingCosmos = {(rating: Double) -> () in
            view.rate = rating
        }
        return view;
    }
    func setupLocalization() {
        
        lblTitle.text = "TXT_FEEDBACK".localizedCapitalized
        lblTitle.font = FontHelper.textLarge()
        lblTitle.textColor = UIColor.themeTitleColor
        lblComment.text = "TXT_COMMENT".localized
        lblMessage.text = "TXT_FD_MSG".localized
        lblComment.font = FontHelper.textRegular()
        lblMessage.font = FontHelper.textRegular()
        lblComment.textColor = .themeLightTextColor
        lblMessage.textColor = .themeTextColor
        btnFilter.setTitle("TXT_APPLY".localized, for: .normal)
        txtComment.textColor = .themeTextColor
        txtComment.delegate = self
        txtComment.font = FontHelper.textRegular()
        self.cosmosVw.rating = 0.0
        self.cosmosVw.didTouchCosmos = {(rating: Double) -> () in
            
        }
        self.cosmosVw.didFinishTouchingCosmos = {(rating: Double) -> () in
            self.rate = rating
        }
        self.updateUIAccordingToTheme()
        self.cosmosVw.settings.fillMode = .half
        self.cosmosVw.settings.starSize = Double(self.cosmosVw.frame.size.height)
        self.cosmosVw.settings.minTouchRating = 0.5
        if UIApplication.isRTL(){
            self.txtComment.semanticContentAttribute = .forceRightToLeft
            self.txtComment.textAlignment = .right
        }else{
            self.txtComment.semanticContentAttribute = .forceLeftToRight
            self.txtComment.textAlignment = .left
        }
        viewForTextField.backgroundColor = .themeViewBackgroundColor
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.backgroundColor = UIColor.themeOverlayColor
        
        IQKeyboardManager.shared.enable = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        btnCancel.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
    }
    
    override func updateUIAccordingToTheme(){
        self.cosmosVw.settings.filledImage = UIImage(named: "ff")?.imageWithColor(color: UIColor.themeColor)
        self.cosmosVw.settings.emptyImage = UIImage(named: "nf")?.imageWithColor(color: UIColor.themeTitleColor)
    }
    

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            self.constraintForBottom.constant = CGFloat(+keyboardHeight) + 10
            print(self.constraintForBottom.constant)
            
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            self.constraintForBottom.constant = 10
        }
    }
    @IBAction func onClickBtnCancel(_ sender: Any) {
        IQKeyboardManager.shared.enable = true
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.alertView.frame = CGRect.init(x: self.alertView.frame.origin.x, y: self.frame.height, width: self.alertView.frame.size.width, height: self.alertView.frame.size.height)
                        
        }, completion: { test in
            
            self.removeFromSuperview()
        })
        
    }
    @IBAction func onClickBtnApply(_ sender: Any) {
        self.endEditing(true)
        IQKeyboardManager.shared.enable = true
        
        if rate != 0.0 {
            
            if isRateToProvider {
                wsRateToProvider()
            }else {
                wsRateToStore()
            }
           
        }else {
            if isRateToProvider {
                Utility.showToast(message: "MSG_ENTER_RATE".localized)
            }else{
                Utility.showToast(message: "MSG_ENTER_RATE_STORE".localized)
            }
        }
    }
    
    
    func wsRateToProvider() {
        
        var review:String = txtComment.text ?? ""
        if review.compare("TXT_COMMENT_PLACEHOLDER".localized) == .orderedSame {
            review = ""
        }
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.ORDER_ID:currentBooking.selectedOrderId ?? "",
             PARAMS.USER_REVIEW_TO_PROVIDER:review,
             PARAMS.USER_RATING_TO_PROVIDER:rate
        ]
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_USER_RATE_TO_PROVIDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if (Parser.isSuccess(response: response,withSuccessToast:true, andErrorToast: true)) {
                if self.isFromHistory {
                    self.onClickBtnCancel(self.btnCancel)
                }else {
                    self.onClickBtnCancel(self.btnCancel)
                }
                if self.onClickApplyButton != nil {
                    self.onClickApplyButton!("\(self.rate)")
                }
                return
            }
        }
    }
    
    func wsRateToStore() {
        Utility.showLoading()
        var review:String = txtComment.text ?? ""
        if review.compare("TXT_COMMENT_PLACEHOLDER".localized) == .orderedSame {
            review = ""
        }
        
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.ORDER_ID:currentBooking.selectedOrderId!,
             PARAMS.USER_REVIEW_TO_STORE:review,
             PARAMS.USER_RATING_TO_STORE:rate
        ]
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_USER_RATE_TO_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            
            if (Parser.isSuccess(response: response,withSuccessToast:true, andErrorToast: true)) {
                if self.isFromHistory {
                    self.onClickBtnCancel(self.btnCancel)
                }else {
                    self.onClickBtnCancel(self.btnCancel)
                }
                
                if self.onClickApplyButton != nil {
                    self.onClickApplyButton!("\(self.rate)")
                }
                
                return
            }
        }
    }
}
