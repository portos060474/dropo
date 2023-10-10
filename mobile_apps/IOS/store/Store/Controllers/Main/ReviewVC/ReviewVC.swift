//
//  ReviewVC.swift
// Edelivery Store
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import Cosmos


class ReviewVC: BaseVC {
    
    @IBOutlet weak var lblStoreRateValue: UILabel!
    @IBOutlet weak var viewForStoreReview: UIView!
    
    @IBOutlet weak var lbl5Star: UILabel!
    @IBOutlet weak var lbl4Star: UILabel!
    @IBOutlet weak var lbl3Star: UILabel!
    @IBOutlet weak var lbl2Star: UILabel!
    @IBOutlet weak var lbl1Star: UILabel!
    
    @IBOutlet weak var lbl5StarValue: UILabel!
    @IBOutlet weak var lbl4StarValue: UILabel!
    @IBOutlet weak var lbl3StarValue: UILabel!
    @IBOutlet weak var lbl2StarValue: UILabel!
    @IBOutlet weak var lbl1StarValue: UILabel!
    
    
    @IBOutlet weak var bar5Star: UIProgressView!
    @IBOutlet weak var bar4Star: UIProgressView!
    @IBOutlet weak var bar3Star: UIProgressView!
    @IBOutlet weak var bar2Star: UIProgressView!
    @IBOutlet weak var bar1Star: UIProgressView!
    
//    @IBOutlet weak var storeRatingView: RatingView!
    @IBOutlet weak var storeRatingView: CosmosView!

    
    @IBOutlet weak var img1Star: UIImageView!
    @IBOutlet weak var img2Star: UIImageView!
    @IBOutlet weak var img3Star: UIImageView!
    @IBOutlet weak var img4Star: UIImageView!
    @IBOutlet weak var img5Star: UIImageView!

    
    /*collectionView*/
    var arrForPublicReview:[StoreReviewList] = []
    @IBOutlet weak var tblForReview: UITableView!
    var rate:Double = 0.0

    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bar1Star.progress = Float(0)
        bar2Star.progress = Float(0)
        bar3Star.progress = Float(0)
        bar4Star.progress = Float(0)
        bar5Star.progress = Float(0)
        setLocalization()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wsGetOrderReviews()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        lblStoreRateValue.setRound(withBorderColor: .clear, andCornerRadious: 5.0, borderWidth: 1.0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    func setLocalization() {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        storeRatingView.backgroundColor = UIColor.themeViewBackgroundColor
        tblForReview.tableFooterView = UIView.init()
        bar1Star.tintColor = UIColor.themeColor
        bar2Star.tintColor = UIColor.themeColor
        bar3Star.tintColor = UIColor.themeColor
        bar4Star.tintColor = UIColor.themeColor
        bar5Star.tintColor = UIColor.themeColor
        
        bar1Star.trackTintColor  = UIColor.clear
        bar2Star.trackTintColor  = UIColor.clear
        bar3Star.trackTintColor  = UIColor.clear
        bar4Star.trackTintColor  = UIColor.clear
        bar5Star.trackTintColor  = UIColor.clear
        
        lblStoreRateValue.backgroundColor = UIColor.themeColor
        
        let transform : CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        bar1Star.transform = transform
        bar2Star.transform = transform
        bar3Star.transform = transform
        bar4Star.transform = transform
        bar5Star.transform = transform
        
        self.hideBackButtonTitle()
        
        /*set Titles*/
        
        
        // Optional params
        storeRatingView.contentMode = UIView.ContentMode.scaleAspectFit
      /*  storeRatingView.maxRating = 5
        storeRatingView.minRating = 1
        storeRatingView.rating = 0.0
        storeRatingView.editable = true
        storeRatingView.halfRatings = true
        */
        
        storeRatingView.rating = 0.0
        storeRatingView.settings.fillMode = .half
        storeRatingView.settings.starSize = 13
        storeRatingView.settings.starMargin = 2


        storeRatingView.didTouchCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didTouchCosmos: \(rating)")
        }
        storeRatingView.didFinishTouchingCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didFinishTouchingCosmos: \(rating)")
            self.rate = Double(rating)
        }

        tblForReview.estimatedRowHeight = 150
        tblForReview.rowHeight = UITableView.automaticDimension
        self.setNavigationTitle(title: "TXT_REVIEW".localized)
        
        updateUIAccordingToTheme()
    }
    
    override func updateUIAccordingToTheme() {
        storeRatingView.settings.emptyImage = UIImage(named: "nf")?.imageWithColor(color: .themeTextColor)
        storeRatingView.settings.filledImage = UIImage(named: "ff")?.imageWithColor(color: .themeColor)
        
        img1Star.image = UIImage(named: "star_icon")?.imageWithColor(color: .themeTextColor)
        img2Star.image = UIImage(named: "star_icon")?.imageWithColor(color: .themeTextColor)
        img3Star.image = UIImage(named: "star_icon")?.imageWithColor(color: .themeTextColor)
        img4Star.image = UIImage(named: "star_icon")?.imageWithColor(color: .themeTextColor)
        img5Star.image = UIImage(named: "star_icon")?.imageWithColor(color: .themeTextColor)
        
        self.tblForReview.reloadData()
        
    }
    
    //MARK:
    //MARK: Button action methods
    
    //MARK: WEB SERVICE CALLS
    func wsGetOrderReviews() {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> =
            [PARAMS.STORE_ID:preferenceHelper.getUserId()]
        
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_GET_STORE_REVIEW_LIST, methodName: "POST", paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response)
            {
                self.arrForPublicReview.removeAll()
                
                let reviewReposnse:ReviewListResponse = ReviewListResponse.init(fromDictionary: response )
                self.setReviewData(reviewResponse:reviewReposnse)
                
                self.arrForPublicReview =  reviewReposnse.storeReviewList
                self.tblForReview.reloadData()
            }
            Utility.hideLoading()
        }
    }
    func setReviewData(reviewResponse:ReviewListResponse)
    {
        var oneStar = 0.0, twoStar = 0.0, threeStar = 0.0, fourStar = 0.0, fiveStar = 0.0;
        var rate = 0.0;
        for storeData in  reviewResponse.storeReviewList {
            let roundRate =  storeData.userRatingToStore.rounded()
            rate += storeData.userRatingToStore
            
            switch(roundRate) {
            case 1.0: oneStar += 1.0
                break;
            case 2.0: twoStar += 1.0
                break;
            case 3.0: threeStar += 1.0
                break;
            case 4.0: fourStar += 1.0
                break;
            case 5.0: fiveStar += 1.0
                break;
            default: break
            }
            lbl1StarValue.text = String(oneStar)
            lbl2StarValue.text = String(twoStar)
            lbl3StarValue.text = String(threeStar)
            lbl4StarValue.text = String(fourStar)
            lbl5StarValue.text = String(fiveStar)
        }
        let totalRating:Double = Double(reviewResponse.storeReviewList.count)
        if totalRating > 0.0 {
            oneStar = oneStar/totalRating
            twoStar = twoStar/totalRating
            threeStar = threeStar/totalRating
            fourStar = fourStar/totalRating
            fiveStar = fiveStar/totalRating
            bar1Star.progress = Float(oneStar)
            bar2Star.progress = Float(twoStar)
            bar3Star.progress = Float(threeStar)
            bar4Star.progress = Float(fourStar)
            bar5Star.progress = Float(fiveStar)
            rate = (rate/totalRating).rounded()
            lblStoreRateValue.text = String(rate)
            storeRatingView.rating = rate
        }else {
            bar1Star.progress = Float(0)
            bar2Star.progress = Float(0)
            bar3Star.progress = Float(0)
            bar4Star.progress = Float(0)
            bar5Star.progress = Float(0)
            rate = 0.0
            lblStoreRateValue.text = String(rate)
            storeRatingView.rating = rate
        }
        
    }
}
extension ReviewVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arrForPublicReview.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:PublicReviewCell = tableView.dequeueReusableCell(withIdentifier: "publicReviewCell") as! PublicReviewCell
        cell.selectionStyle  = .none
        cell.setCellData(cellData: arrForPublicReview[indexPath.row])
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


class PublicReviewCell: CustomCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var imgDislike: UIImageView!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblDislike: UILabel!
    @IBOutlet weak var vLike: UIView!
    @IBOutlet weak var vDislike: UIView!
    @IBOutlet weak var stkvLikeDislike: UIStackView!
    
    //    @IBOutlet weak var btnLike: UIButton!
    //    @IBOutlet weak var btnDisLike: UIButton!
    
    var reviewId:String = "";
    var storeListReview:StoreReviewList? = nil;
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        
        
        /*Set Font*/
        lblName.font = FontHelper.textRegular()
        lblDate.font = FontHelper.textRegular(size: 12.0)
        lblOrderNo.font = FontHelper.textRegular(size: 12.0)
        
        lblRate.font = FontHelper.textSmall()
        lblComment.font = FontHelper.textSmall()
        /*Set Color*/
        lblName.textColor = UIColor.themeTextColor
        lblRate.textColor = UIColor.themeTextColor
        lblComment.textColor = UIColor.themeLightTextColor
        lblOrderNo.textColor = UIColor.themeLightTextColor
        lblDate.textColor = UIColor.themeLightTextColor
        imgProfilePic.setRound()
    }
    override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            super.layoutSubviews()
            self.contentView.layoutIfNeeded()
        }
    }
    @IBAction func onClikeLikeDislikeReview(_ sender: UIButton) {
        
    }
    func setCellData(cellData:StoreReviewList) {
        imgStar.image = UIImage(named: "star_icon")?.imageWithColor(color: .themeIconTintColor)
        
        storeListReview = cellData
        lblComment.text = cellData.userReviewToStore
        lblRate.text = String(cellData.userRatingToStore)
        lblDate.text = Utility.stringToString(strDate: (storeListReview?.createdAt)!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT_MONTH)
        reviewId = (storeListReview?.id)!
        imgProfilePic.downloadedFrom(link: (storeListReview?.userDetail.imageUrl)!)
        lblName.text = (storeListReview?.userDetail.firstName)! +  " " + (storeListReview?.userDetail.lastName)!
        lblOrderNo.text = "TXT_ORDER_NO".localizedUppercase + "\(cellData.orderUniqueId ?? 0)"
        
        if cellData.userReviewToStore.isEmpty() {
            lblComment.isHidden = true
            vLike.isHidden = true
            vDislike.isHidden = true
            
            imgLike.isHidden = true
            imgDislike.isHidden = true
            
            lblLike.isHidden = true
            lblDislike.isHidden = true
            stkvLikeDislike.isHidden = true
            //            btnLike.isHidden = true
            //            btnDisLike.isHidden = true
        }else {
            lblComment.isHidden = false
            //            btnLike.isHidden = false
            //            btnDisLike.isHidden = false
            
            vLike.isHidden = false
            vDislike.isHidden = false
            stkvLikeDislike.isHidden = false
            imgLike.isHidden = false
            imgDislike.isHidden = false
            
            lblLike.isHidden = false
            lblDislike.isHidden = false
            
            
            storeListReview?.isDisLike = (storeListReview?.idOfUsersDislikeStoreComment.contains(preferenceHelper.getUserId()))!
            storeListReview?.isLike = (storeListReview?.idOfUsersLikeStoreComment.contains(preferenceHelper.getUserId()))!
            if (storeListReview?.isLike)!{
                imgLike.image = UIImage(named: "likeFill")?.imageWithColor(color: .themeIconTintColor)
            }else{
                imgLike.image = UIImage(named: "like")?.imageWithColor(color: .themeIconTintColor)
            }
            
            if (storeListReview?.isDisLike)!{
                imgDislike.image = UIImage(named: "dislikeFill")?.imageWithColor(color: .themeIconTintColor)
            }else{
                imgDislike.image = UIImage(named: "dislike")?.imageWithColor(color: .themeIconTintColor)
            }
            
            lblDislike.text = String(cellData.idOfUsersDislikeStoreComment.count)
            lblLike.text = String(cellData.idOfUsersLikeStoreComment.count)
            
            //            btnLike.isSelected = (storeListReview?.isLike)!
            //            btnDisLike.isSelected = (storeListReview?.isDisLike)!
            
            //            btnDisLike.setTitle(String(cellData.idOfUsersDislikeStoreComment.count), for: .normal)
            //            btnLike.setTitle(String(cellData.idOfUsersLikeStoreComment.count), for: .normal)
        }
    }
    
}
