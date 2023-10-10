//
//  FeedbackVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class StoreFeedbackVC: BaseVC, RatingViewDelegate, UITextViewDelegate{

    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    public var imgurl:String = ""
    public var name:String = ""
    public var orderId:String = ""
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
        // Required float rating view params
        self.ratingView.emptyImage = UIImage(named: "nf")
        self.ratingView.fullImage = UIImage(named: "ff")
    
        // Optional params
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 0
        self.ratingView.rating = rate
        self.ratingView.editable = true
        self.ratingView.halfRatings = false
        self.ratingView.floatRatings = false
        txtComment.text = "TXT_COMMENT_PLACEHOLDER".localized
        
        // COLORS
        
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
          
                    wsRateToStore()
        }else {
            Utility.showToast(message: "MSG_ENTER_COMMENT_RATE".localized)
        }
    }
    
    func RatingView(_ ratingView: RatingView, didUpdate rating: Float)
     {
        
        rate = rating
    }
    
    //MARK:Web Service Calls
    func wsRateToStore() {
        Utility.showLoading()
        var review:String = txtComment.text ?? ""
        if review.compare("TXT_COMMENT_PLACEHOLDER".localized) == .orderedSame {
            review = ""
        }
        
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.ORDER_ID:orderId,
             PARAMS.USER_REVIEW_TO_STORE:review,
             PARAMS.USER_RATING_TO_STORE:rate
        ]
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_USER_RATE_TO_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if (Parser.isSuccess(response: response)) {
                self.navigationController?.popViewController(animated:false)
                return
            }
        }
    }
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

