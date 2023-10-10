//
//  DailogForFeedback.swift
//  Edelivery Provider
//
//  Created by Elluminati on 01/03/21.
//  Copyright © 2021 Elluminati iMac. All rights reserved.
//

import UIKit
import Cosmos


class DailogForFeedback: CustomDialog,UITextFieldDelegate, /*RatingViewDelegate ,*/keyboardWasShownDelegate,keyboardWillBeHiddenDelegate{

    @IBOutlet weak var constraintForBottom: NSLayoutConstraint!
    public var isRateToUser:Bool = false
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewForTextField: UIView!
    @IBOutlet weak var txtComment: UITextField!
    static let  dialogNibName = "dailogForFeedback"
    @IBOutlet weak var btnApply: UIButton!
    var rate:Double =  0.0
    @IBOutlet weak var cosmosVw: CosmosView!
    public var selectedOrderID:String = ""
    var isFromHistory:Bool = false
    var onClickApplyButton : (() -> Void)? = nil
    
    var activeField: UITextField?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func updateUIAccordingToTheme() {
        self.setupLocalization()
    }
    public static func  showCustomFeedbackDialog(_ title:String, _ isRateForUser: Bool , _ FromHistory: Bool ,_ order_id : String ,tag:Int = 414) -> DailogForFeedback
    {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DailogForFeedback
        view.tag = tag
        view.isRateToUser = isRateForUser
        view.isFromHistory = FromHistory
        view.selectedOrderID = order_id
        view.setupLocalization()
        view.lblTitle.text = title
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
       /* if arrForLanguages[preferenceHelper.getLanguage()].code == "ar" {
            view.ratingView.semanticContentAttribute = .forceLeftToRight
            
        }
        if UIApplication.isRTL(){
            view.ratingView.semanticContentAttribute = .forceRightToLeft
            view.txtComment.semanticContentAttribute = .forceRightToLeft
            view.txtComment.textAlignment = .right
        }else{
            view.ratingView.semanticContentAttribute = .forceLeftToRight
            view.txtComment.semanticContentAttribute = .forceLeftToRight
            view.txtComment.textAlignment = .left
        }
        view.ratingView.updateConstraints() */
        DispatchQueue.main.async{
            UIApplication.shared.keyWindow?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
        }
        
        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)
        
        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
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
        btnApply.setTitle("TXT_APPLY".localized, for: .normal)
        
        txtComment.textColor = .themeTextColor
        txtComment.delegate = self
        txtComment.font = FontHelper.textRegular()

        
        btnCancel.setTitleColor(UIColor.themeIconTintColor, for: .normal)
         btnCancel.tintColor = UIColor.themeIconTintColor
        //btnCancel.setTitle("TXT_DONE".localizedUppercase, for: .normal)
         btnCancel.setTitle("", for: .normal)
         
        btnCancel.imageView?.contentMode = .scaleAspectFill
        btnCancel.setImage(UIImage.init(named: "cancel_icon")?.imageWithColor(), for: .normal)
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.backgroundColor = UIColor.themeOverlayColor
        
       // IQKeyboardManager.shared.enable = false
        self.cosmosVw.rating = 0.0
        self.cosmosVw.didTouchCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didTouchCosmos: \(rating)")
        }
        self.cosmosVw.didFinishTouchingCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didFinishTouchingCosmos: \(rating)")
            self.rate = rating
        }
        self.cosmosVw.settings.filledImage = UIImage(named: "ff")?.imageWithColor()
        self.cosmosVw.settings.emptyImage = UIImage(named: "nf")?.imageWithColor(color: .themeIconTintColor)
        self.cosmosVw.settings.fillMode = .half
    }
  /*  func RatingView(_ ratingView: RatingView, didUpdate rating: Float) {
        rate = rating
    } */
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    override func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField
        {
            _ = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
            
            if (aRect.contains(activeField!.frame.origin))
            {
                constraintForBottom.constant = 0.0
                UIView.animate(withDuration: 1.0) {
                    self.constraintForBottom.constant = keyboardSize?.height ?? 0.0
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   override func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var _ : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        
        UIView.animate(withDuration: 1.0) {
            self.constraintForBottom.constant = 20.0
        }
        self.endEditing(true)
    }
    
    @IBAction func onClickBtnCancel(_ sender: Any) {
        
        self.animationForHideAView(alertView) {
            
            self.removeFromSuperview()
        }
        
    }
    @IBAction func onClickBtnApply(_ sender: Any) {
        self.endEditing(true)
       
        
        if rate != 0.0 {
           
            if isRateToUser {
                wsRateToProvider()
            }else {
                wsRateToStore()
            }
           
        }else {
            if isRateToUser {
                Utility.showToast(message: "MSG_ENTER_RATE".localized)
            }else{
                Utility.showToast(message: "MSG_ENTER_RATE_STORE".localized)
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
            [PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.REQUEST_ID:selectedOrderID,
             PARAMS.PROVIDER_REVIEW_TO_USER:review,
             PARAMS.PROVIDER_RATING_TO_USER:rate
        ];
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_PROVIDER_RATE_TO_USER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if (Parser.isSuccess(response: response)) {
                if self.isFromHistory {
                    if self.onClickApplyButton != nil {
                        self.animationForHideAView(self.alertView) {
                            self.onClickApplyButton!()
                        }
                    }
                }else {
                    self.removeFromSuperview()
                    APPDELEGATE.goToMain()
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
            [PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.REQUEST_ID:selectedOrderID,
             PARAMS.PROVIDER_REVIEW_TO_STORE:review,
             PARAMS.PROVIDER_RATING_TO_STORE:rate
        ];
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_PROVIDER_RATE_TO_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if (Parser.isSuccess(response: response)) {
                if self.isFromHistory {
                    if self.onClickApplyButton != nil {
                        self.animationForHideAView(self.alertView) {
                            self.onClickApplyButton!()
                        }
                    }
                }else {
                    self.removeFromSuperview()
                    APPDELEGATE.goToMain()
                }
                return
            }
        }
    }
}
