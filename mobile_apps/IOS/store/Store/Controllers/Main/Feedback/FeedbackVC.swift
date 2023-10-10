//
//  FeedbackVC.swift
//  // Edelivery Store
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit
import Cosmos

class FeedbackVC: BaseVC, RatingViewDelegate, UITextViewDelegate{
    
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    public var imgurl:String = ""
    public var name:String = ""
    public var isRateToUser:Bool = false
    public var selectedOrderID:String = ""
    
    
    

    var rate:Float =  0.0
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfilePic.setRound()
        
    }
    
    //MARK: Set localized layout
    func setLocalization() {

        rate = 0.0
        // Required float rating view params
        updateUIAccordingToTheme()
        
        // Optional params
      /*  self.ratingView.delegate = self
        self.ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 1
        self.ratingView.rating = 0.0
        self.ratingView.editable = true
        self.ratingView.halfRatings = true
        self.ratingView.floatRatings = false*/
        
        self.ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.ratingView.rating = 0.0
        self.ratingView.settings.fillMode = .half
        self.ratingView.settings.starSize = 30
        self.ratingView.settings.starMargin = 5

        self.ratingView.didTouchCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didTouchCosmos: \(rating)")
        }
        self.ratingView.didFinishTouchingCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didFinishTouchingCosmos: \(rating)")
            self.rate = Float(Double(rating))
        }

        txtComment.text = "TXT_COMMENT_PLACEHOLDER".localized
        if UIApplication.isRTL(){
            self.ratingView.semanticContentAttribute = .forceRightToLeft
            self.txtComment.semanticContentAttribute = .forceRightToLeft
            self.txtComment.textAlignment = .right
        }else{
            self.ratingView.semanticContentAttribute = .forceLeftToRight
            self.txtComment.semanticContentAttribute = .forceLeftToRight
            self.txtComment.textAlignment = .left
        }
        // COLORS
        
        lblComment.textColor = UIColor.themeTextColor
        lblName.textColor = UIColor.themeTextColor
        txtComment.textColor = UIColor.themeLightTextColor
        btnSubmit.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnSubmit.backgroundColor = UIColor.themeColor
        
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
        btnSubmit.titleLabel?.font = FontHelper.textRegular()
        
        
        imgProfilePic.downloadedFrom(link: imgurl, placeHolder:"profile_placeholder")
        lblName.text = name
        
    }
    
    override func updateUIAccordingToTheme() {
        self.ratingView.settings.emptyImage = UIImage(named: "nf")?.imageWithColor(color: .themeTextColor)
        self.ratingView.settings.filledImage = UIImage(named: "ff")?.imageWithColor(color: .themeColor)

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
        txtComment.resignFirstResponder()
        
        if rate != 0.0 {
                if isRateToUser {
                    wsRateToUser()
                }
                else {
                    wsRateToProvider()
                }
        }else {
            if isRateToUser {
                Utility.showToast(message: "MSG_ENTER_COMMENT_RATE".localized)
            }else{
                Utility.showToast(message: "MSG_ENTER_COMMENT_RATE_PROVIDER".localized)
            }
        }
        
    }
    
    func RatingView(_ ratingView: RatingView, didUpdate rating: Float) {
        rate = rating
    }
    //MARK:Web Service Calls
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
