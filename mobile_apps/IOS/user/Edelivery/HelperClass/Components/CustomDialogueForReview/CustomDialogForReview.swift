//
//  CustomDialogForReview.swift
//  Edelivery
//
//  Created by Elluminati on 3/9/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation
import UIKit

public class CustomDialogForReview:CustomDialog {
    
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
    @IBOutlet weak var storeRatingView: RatingView!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var collectionForReview: UICollectionView!
    @IBOutlet weak var lblShareReview: UILabel!
    @IBOutlet weak var lblRateTitle: UILabel!
    @IBOutlet weak var tblForReview: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    var rate:Float = 0.0
    
    /*collectionView*/
    
    var arrForRemainingReview:[RemainingReviewList] = []
    var arrForPublicReview:[StoreReviewList] = []
    var onClickLeftButton : (() -> Void)? = nil
    static let  reviewDialog = "dialogForReview"
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public static func showCustomReviewDialog
    (title:String,
     message:String
    ) ->
    CustomDialogForReview
    {
        let view = UINib(nibName: reviewDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomDialogForReview
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.setLocalization()
        view.lblTitle.text = title
        view.alertView.applyTopCornerRadius()
        view.tblForReview.register(UINib.init(nibName: "PublicReviewCell", bundle: nil), forCellReuseIdentifier: "publicReviewCell")
        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            view.animationBottomTOTop(view.alertView)
            view.alertView.applyTopCornerRadius()
        }
        return view
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    func setupLayout(){
        lblStoreRateValue.setRound(withBorderColor: .clear, andCornerRadious: 5.0, borderWidth: 1.0)
        alertView.applyTopCornerRadius()
    }
    
    func setLocalization() {
        self.backgroundColor = UIColor.themeOverlayColor
        btnClose.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        storeRatingView.backgroundColor = UIColor.themeViewBackgroundColor
        bar1Star.tintColor = UIColor.themeColor
        bar2Star.tintColor = UIColor.themeColor
        bar3Star.tintColor = UIColor.themeColor
        bar4Star.tintColor = UIColor.themeColor
        bar5Star.tintColor = UIColor.themeColor
        bar1Star.trackTintColor = UIColor.clear
        bar2Star.trackTintColor = UIColor.clear
        bar3Star.trackTintColor = UIColor.clear
        bar4Star.trackTintColor = UIColor.clear
        bar5Star.trackTintColor = UIColor.clear
        lblStoreRateValue.backgroundColor = UIColor.themeColor
        let transform:CGAffineTransform = CGAffineTransform.init(scaleX: 1.0, y: 6.0)
        bar1Star.transform = transform
        bar2Star.transform = transform
        bar3Star.transform = transform
        bar4Star.transform = transform
        bar5Star.transform = transform
        lblRateTitle.font = FontHelper.textMedium()
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblShareReview.font = FontHelper.textSmall()
        lblRateTitle.textColor = UIColor.themeTextColor
        lblShareReview.textColor = UIColor.themeLightTextColor
        lbl1Star.textColor = UIColor.themeTextColor
        lbl2Star.textColor = UIColor.themeTextColor
        lbl3Star.textColor = UIColor.themeTextColor
        lbl4Star.textColor = UIColor.themeTextColor
        lbl5Star.textColor = UIColor.themeTextColor
        lblTitle.textColor = UIColor.themeTextColor
        lbl1Star.font = FontHelper.textRegular()
        lbl2Star.font = FontHelper.textRegular()
        lbl3Star.font = FontHelper.textRegular()
        lbl4Star.font = FontHelper.textRegular()
        lbl5Star.font = FontHelper.textRegular()
        lbl1Star.text = "TXT_1".localized
        lbl2Star.text = "TXT_2".localized
        lbl3Star.text = "TXT_3".localized
        lbl4Star.text = "TXT_4".localized
        lbl5Star.text = "TXT_5".localized
        lblRateTitle.text = "TXT_RATE_AND_REVIEW".localizedCapitalized
        lblShareReview.text = "MSG_RATE_AND_REVIEW".localizedCapitalized
        
        /*set Titles*/
        
        storeRatingView.emptyImage = UIImage(named: "star_black")
        storeRatingView.fullImage = UIImage(named: "star_color")?.imageWithColor(color: .themeColor)
        
        // Optional params
        storeRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        storeRatingView.maxRating = 5
        storeRatingView.minRating = 1
        storeRatingView.rating = 0.0
        storeRatingView.editable = true
        storeRatingView.halfRatings = true
        tblForReview.estimatedRowHeight = 150
        tblForReview.rowHeight = UITableView.automaticDimension
        tblForReview.tableFooterView = UIView.init()
        wsGetOrderReviews()
    }
    
    //MARK: Button action methods
    
    //MARK: WEB SERVICE CALLS
    func wsGetOrderReviews() {
        Utility.showLoading()
        var dictParam: Dictionary<String,Any> =
        [PARAMS.STORE_ID:currentBooking.selectedStore?._id ?? ""]
        
        if !preferenceHelper.getUserId().isEmpty() {
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        }
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_STORE_REVIEW_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response)
            {
                self.arrForPublicReview.removeAll()
                let reviewReposnse:ReviewListResponse = ReviewListResponse.init(fromDictionary: response as! [String:Any])
                self.setReviewData(reviewResponse:reviewReposnse)
                self.arrForPublicReview =  reviewReposnse.storeReviewList
                self.arrForRemainingReview =  reviewReposnse.remainingReviewList
                self.tblForReview.reloadData()
                self.configureHeaderView()
            }
            Utility.hideLoading()
        }
    }
    
    func setReviewData(reviewResponse:ReviewListResponse)
    {
        var oneStar = 0.0, twoStar = 0.0, threeStar = 0.0, fourStar = 0.0, fiveStar = 0.0
        var rate = 0.0
        for storeData in  reviewResponse.storeReviewList {
            let roundRate =  storeData.userRatingToStore.rounded()
            rate += storeData.userRatingToStore
            
            switch(roundRate) {
            case 1.0: oneStar += 1.0
                break
            case 2.0: twoStar += 1.0
                break
            case 3.0: threeStar += 1.0
                break
            case 4.0: fourStar += 1.0
                break
            case 5.0: fiveStar += 1.0
                break
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
            storeRatingView.rating = Float(rate)
        }else {
            bar1Star.progress = Float(0)
            bar2Star.progress = Float(0)
            bar3Star.progress = Float(0)
            bar4Star.progress = Float(0)
            bar5Star.progress = Float(0)
            rate = 0.0
            lblStoreRateValue.text = String(rate)
            storeRatingView.rating = Float(rate)
        }
        
    }
    
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
    }
}
extension CustomDialogForReview:UITableViewDelegate,UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrForPublicReview.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:PublicReviewCell = tableView.dequeueReusableCell(withIdentifier: "publicReviewCell") as! PublicReviewCell
        cell.setCellData(cellData: arrForPublicReview[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension CustomDialogForReview:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func configureHeaderView() {
        
        if (arrForRemainingReview.count) > 0 {
            viewForHeader.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 201)
            tblForReview.tableHeaderView = viewForHeader
            collectionForReview.reloadData()
            collectionForReview.isHidden = false
            
        }else {
            viewForHeader.isHidden = true
            viewForHeader.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
            tblForReview.tableHeaderView = viewForHeader
        }
    }
    
    // MARK: UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForRemainingReview.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCollectionViewCell
        cell.lblOrderId.text =  "TXT_ORDER_NO".localized + "\(String(arrForRemainingReview[indexPath.row].orderUniqueId))"
        cell.btnWriteReview.tag = indexPath.row
        return cell
    }
    
    func onClikeBtnWriteReview(_ index: Int,rate:Float) {
        let selectedStore:RemainingReviewList = arrForRemainingReview[index]
        self.rate = rate
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionForReview {
            var currentCellOffset =  self.collectionForReview.contentOffset
            currentCellOffset.x += (self.collectionForReview.frame.width) / 2
            if let indexPath = self.collectionForReview.indexPathForItem(at: currentCellOffset) {
                self.collectionForReview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 120.0)
    }
    
}
class PublicReviewCell: CustomTableCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var starImage : UIImageView!
    @IBOutlet weak var heighForStack: NSLayoutConstraint!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnDisLike: UIButton!
    
    var reviewId:String = ""
    var storeListReview:StoreReviewList? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        
        /*Set Font*/
        lblName.font = FontHelper.textMedium()
        lblDate.font = FontHelper.textRegular(size: FontHelper.small)
        lblRate.font = FontHelper.textRegular(size: FontHelper.medium)
        lblComment.font = FontHelper.textRegular(size: FontHelper.medium)
        
        /*Set Color*/
        lblName.textColor = UIColor.themeTextColor
        lblRate.textColor = UIColor.themeTextColor
        lblComment.textColor = UIColor.themeTextColor
        lblDate.textColor = UIColor.themeLightTextColor
        imgProfilePic.setRound()
        btnLike.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnDisLike.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnLike.setImage(UIImage(named: "thumbsUp")?.imageWithColor(color: .themeTextColor), for: .normal)
        btnDisLike.setImage(UIImage(named: "thumbsDown")?.imageWithColor(color: .themeTextColor), for: .normal)
        btnLike.setBackgroundColor(color: UIColor.themeViewBackgroundColor, forState: .normal)
        btnDisLike.setBackgroundColor(color: UIColor.themeViewBackgroundColor, forState: .normal)
        if LocalizeLanguage.isRTL {
            btnLike.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 5.0)
            btnDisLike.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 5.0)
        }
        else {
            btnLike.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 0.0)
            btnDisLike.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 0.0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    @IBAction func onClikeLikeDislikeReview(_ sender: UIButton) {
        
        if sender == btnLike {
            storeListReview?.isLike = !(storeListReview?.isLike)!
            storeListReview?.isDisLike = false
        }else {
            storeListReview?.isDisLike = !(storeListReview?.isDisLike)!
            storeListReview?.isLike = false
        }
        wsLikeDisLikeReviews()
    }
    
    func setCellData(cellData:StoreReviewList) {
        storeListReview = cellData
        lblComment.text = cellData.userReviewToStore
        lblRate.text = String(cellData.userRatingToStore)
        lblDate.text = Utility.stringToString(strDate: (storeListReview?.createdAt)!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_DD_MMM_YY)
        reviewId = (storeListReview?.id)!
        imgProfilePic.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: imgProfilePic.frame.width, height: imgProfilePic.frame.height, imgUrl: (storeListReview?.userDetail.imageUrl)!),isFromResize: true)
        lblName.text = (storeListReview?.userDetail.firstName)! +  " " + (storeListReview?.userDetail.lastName)!
        if cellData.userReviewToStore.isEmpty() {
            lblComment.isHidden = true
            btnLike.isHidden = true
            btnDisLike.isHidden = true
            heighForStack.constant = 0
        }else {
            heighForStack.constant = 15
            lblComment.isHidden = false
            btnLike.isHidden = false
            btnDisLike.isHidden = false
            storeListReview?.isDisLike = (storeListReview?.idOfUsersDislikeStoreComment.contains(preferenceHelper.getUserId()))!
            storeListReview?.isLike = (storeListReview?.idOfUsersLikeStoreComment.contains(preferenceHelper.getUserId()))!
            btnLike.isSelected = (storeListReview?.isLike)!
            btnDisLike.isSelected = (storeListReview?.isDisLike)!
            btnDisLike.setTitle(String(cellData.idOfUsersDislikeStoreComment.count), for: .normal)
            btnLike.setTitle(String(cellData.idOfUsersLikeStoreComment.count), for: .normal)
        }
        starImage.image = UIImage.init(named: "star_black")?.imageWithColor(color: .themeTextColor)
    }
    
    func wsLikeDisLikeReviews() {
        if preferenceHelper.getUserId().isEmpty() {
            Utility.showToast(message: "MSG_LOGIN_FIRST".localized)
        }else {
            Utility.showLoading()
            
            let dictParam: Dictionary<String,Any> =
            [
                PARAMS.USER_ID:preferenceHelper.getUserId(),
                PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
                PARAMS.REVIEW_ID:reviewId,
                PARAMS.IS_USER_CLICKED_LIKE_STORE_REVIEW:storeListReview?.isLike ?? false,
                PARAMS.IS_USER_CLICKED_DISLIKE_STORE_REVIEW:storeListReview?.isDisLike ?? false
                ,
            ]
            
            let afn:AlamofireHelper = AlamofireHelper.init()
            afn.getResponseFromURL(url: WebService.WS_LIKE_DISLIKE_STORE_REVIEW, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
                Utility.hideLoading()
                if Parser.isSuccess(response: response)
                {
                    
                    if (self.storeListReview?.isLike)!
                    {
                        if let index = self.storeListReview?.idOfUsersDislikeStoreComment.firstIndex(where: { ($0 == preferenceHelper.getUserId())})
                        {
                            self.storeListReview?.idOfUsersDislikeStoreComment.remove(at: index)
                        }
                        self.storeListReview?.idOfUsersLikeStoreComment.append(preferenceHelper.getUserId())
                    }
                    else if (self.storeListReview?.isDisLike)! {
                        if let index = self.storeListReview?.idOfUsersLikeStoreComment.firstIndex(where: { ($0 == preferenceHelper.getUserId())})
                        {
                            self.storeListReview?.idOfUsersLikeStoreComment.remove(at: index)
                        }
                        self.storeListReview?.idOfUsersDislikeStoreComment.append(preferenceHelper.getUserId())
                        
                    }else {
                        if let index = self.storeListReview?.idOfUsersLikeStoreComment.firstIndex(where: { ($0 == preferenceHelper.getUserId())})
                        {
                            self.storeListReview?.idOfUsersLikeStoreComment.remove(at: index)
                        }
                        if let index = self.storeListReview?.idOfUsersDislikeStoreComment.firstIndex(where: { ($0 == preferenceHelper.getUserId())})
                        {
                            self.storeListReview?.idOfUsersDislikeStoreComment.remove(at: index)
                        }
                    }
                    self.setCellData(cellData: self.storeListReview!)
                }
            }
        }
    }
}
