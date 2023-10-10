//
//  FeedbackVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class FeedbackVC: BaseVC, RatingViewDelegate, UITextViewDelegate, LeftDelegate{

   
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    public var imgurl:String = ""
    public var name:String = ""
    public var isRateToProvider:Bool = false
    public var isFromHistory = false
    
    var rate:Float =  0.0

    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateLeft = self
        self.setLocalization()
    }
    
    func onClickLeftButton() {
        if self.isFromHistory {
            self.navigationController?.popViewController(animated: true)
        }else {
            APPDELEGATE.goToMain()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfilePic.setRound()
    }
    
    //MARK: Set localized layout
    func setLocalization() {
       
        rate = 0.0
        self.ratingView.emptyImage = UIImage(named: "nf")
        self.ratingView.fullImage = UIImage(named: "ff")
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 1
        self.ratingView.rating = 0.0
        self.ratingView.editable = true
        self.ratingView.halfRatings = false
        self.ratingView.floatRatings = false
        txtComment.text = "TXT_COMMENT_PLACEHOLDER".localized
        
        // COLORS
        if UIApplication.isRTL(){
            self.ratingView.semanticContentAttribute = .forceRightToLeft
            self.txtComment.semanticContentAttribute = .forceRightToLeft
            self.txtComment.textAlignment = .right
        }else{
            self.ratingView.semanticContentAttribute = .forceLeftToRight
            self.txtComment.semanticContentAttribute = .forceLeftToRight
            self.txtComment.textAlignment = .left
        }
        
        lblComment.textColor = UIColor.themeTextColor
        lblName.textColor = UIColor.themeTextColor
        txtComment.textColor = UIColor.themeLightTextColor
        btnSubmit.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        
        // LOCALIZED
        
        self.title = "TXT_FEEDBACK".localized
        lblComment.text = "TXT_COMMENT".localized
        txtComment.text = "TXT_COMMENT_PLACEHOLDER".localized
        btnSubmit.setTitle("TXT_SUBMIT".localized, for: UIControl.State.normal)
        self.hideBackButtonTitle()
        
        /*Set Font*/
        lblComment.font = FontHelper.textRegular()
        lblName.font = FontHelper.textRegular()
        txtComment.font = FontHelper.textRegular()
        btnSubmit.titleLabel?.font = FontHelper.buttonText()
        imgProfilePic.downloadedFrom(link: imgurl,placeHolder: "profile_placeholder")
        lblName.text = name
    
    }
    

    //MARK: Textview Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "TXT_COMMENT_PLACEHOLDER".localized {
            textView.text = ""
            textView.textColor = UIColor.themeTextColor
        }
       
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    

    //MARK: Button action methods
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if rate != 0.0 {
            if isRateToProvider {
                    wsRateToProvider()
                }else {
                    wsRateToStore()
                }
        }else {
            Utility.showToast(message: "MSG_ENTER_COMMENT_RATE".localized)
        }
    }
    
    func RatingView(_ ratingView: RatingView, didUpdate rating: Float)
    {
        rate = rating
    }
    
    //MARK:Web Service Calls
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
                self.navigationController?.popViewController(animated: true)
                }else {
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
                    self.navigationController?.popViewController(animated: true)
                }else {
                    APPDELEGATE.goToMain()
                }
                return
            }
        }
    }
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

