//
//  ReviewVC.swift
//  edelivery
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
    
    @IBOutlet weak var storeRatingView: CosmosView!
    @IBOutlet weak var viewForHeader: UIView!
    
    var rate:Double = 0.0
    
    /*collectionView*/
    @IBOutlet weak var collectionForReview: UICollectionView!
    var arrForRemainingReview:[RemainingReviewList] = []
    var arrForPublicReview:[StoreReviewList] = []
    @IBOutlet weak var lblShareReview: UILabel!
    
    @IBOutlet weak var lblRateTitle: UILabel!
    @IBOutlet weak var tblForReview: UITableView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var heightViewContainer: NSLayoutConstraint!
    @IBOutlet weak var btnStar1Icon: UIButton!
    @IBOutlet weak var btnStar2Icon: UIButton!
    @IBOutlet weak var btnStar3Icon: UIButton!
    @IBOutlet weak var btnStar4Icon: UIButton!
    @IBOutlet weak var btnStar5Icon: UIButton!
    var dialogForFeedback: DailogForFeedback? = nil
    override var preferredContentSize: CGSize {
        get {
            // Force the table view to calculate its height
            self.tblForReview.layoutIfNeeded()
            return self.tblForReview.contentSize
        }
        set {}
    }
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        self.heightViewContainer.constant = 0
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.animationBottomTOTop(self.alertView)
        wsGetOrderReviews()
    }
   
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        setupLayout()
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
    
    func setupLayout(){
        alertView.applyTopCornerRadius()
       lblStoreRateValue.setRound(withBorderColor: .clear, andCornerRadious: 5.0, borderWidth: 1.0)
//        self.heightViewContainer.constant =  self.tblForReview.contentSize.height
    }
    
    func setLocalization() {
        self.view.backgroundColor = UIColor.themeOverlayColor
       btnClose.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        storeRatingView.backgroundColor = UIColor.themeViewBackgroundColor
        viewForHeader.backgroundColor = UIColor.themeViewBackgroundColor
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
        lblStoreRateValue.font = FontHelper.textRegular(size: FontHelper.largest)
        let transform:CGAffineTransform = CGAffineTransform.init(scaleX: 1.0, y: 6.0)
        
        bar1Star.transform = transform
        bar2Star.transform = transform
        bar3Star.transform = transform
        bar4Star.transform = transform
        bar5Star.transform = transform
        
        
        lblRateTitle.font = FontHelper.textMedium()
        lblShareReview.font = FontHelper.textSmall()
        lblRateTitle.textColor = UIColor.themeTextColor
        
        lblShareReview.textColor = UIColor.themeTextColor
        lbl1Star.textColor = UIColor.themeTextColor
        lbl2Star.textColor = UIColor.themeTextColor
        lbl3Star.textColor = UIColor.themeTextColor
        lbl4Star.textColor = UIColor.themeTextColor
        lbl5Star.textColor = UIColor.themeTextColor
        
        
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


        self.hideBackButtonTitle()
        
        /*set Titles*/
     /*
        storeRatingView.emptyImage = UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor)
        storeRatingView.fullImage = UIImage(named: "star_color")?.imageWithColor(color: .themeColor)
       */
        // Optional params
      /*  storeRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        storeRatingView.maxRating = 5
        storeRatingView.minRating = 1
        storeRatingView.rating = 0.0
        storeRatingView.editable = true
        storeRatingView.halfRatings = true
        */
        storeRatingView.rating = 0.0
        storeRatingView.settings.minTouchRating = 0.5
        storeRatingView.didTouchCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didTouchCosmos: \(rating)")
        }
        storeRatingView.didFinishTouchingCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didFinishTouchingCosmos: \(rating)")
            self.rate = Double(rating)
        }
        storeRatingView.settings.filledImage = UIImage(named: "star_color")?.imageWithColor(color: .themeColor)
        storeRatingView.settings.emptyImage = UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor)
        storeRatingView.settings.fillMode = .half
        tblForReview.estimatedRowHeight = 150
        tblForReview.rowHeight = UITableView.automaticDimension
       tblForReview.tableFooterView = UIView.init()
        lblTitle.text = "TXT_REVIEW_RATING".localized
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblTitle.textColor = UIColor.themeTextColor
        
         btnStar1Icon.setImage(UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
         btnStar2Icon.setImage(UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
         btnStar3Icon.setImage(UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        
         btnStar4Icon.setImage(UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
         btnStar5Icon.setImage(UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
    }

    override func updateUIAccordingToTheme() {
        //        storeRatingView.emptyImage = UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor)
        btnStar1Icon.setImage(UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnStar2Icon.setImage(UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnStar3Icon.setImage(UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnStar4Icon.setImage(UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnStar5Icon.setImage(UIImage(named: "star_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        collectionForReview.reloadData()
    }

    func openFeedbackDialogue(isRateProvider:Bool,selectedStore: RemainingReviewList)  {
        let providerName = currentBooking.selectedStore?.name ?? ""
        dialogForFeedback = DailogForFeedback.showCustomFeedbackDialog(isRateProvider, false, selectedStore.orderId, name: providerName, storeRate: rate)
        dialogForFeedback?.onClickApplyButton = {
            (rating) in
            self.dialogForFeedback?.removeFromSuperview()
        }
    }

    @IBAction func onClickBtnClose(_ sender: UIButton) {
        self.view.animationForHideView(alertView) {
            self.dismiss(animated: false, completion: nil)
        }
    }

    //MARK:- WEB SERVICE CALLS
    func wsGetOrderReviews() {
        Utility.showLoading()
        var dictParam: Dictionary<String,Any> =
            [PARAMS.STORE_ID:currentBooking.selectedStore?._id ?? ""]
        
        if !preferenceHelper.getUserId().isEmpty() {
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        }

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_STORE_REVIEW_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                self.arrForPublicReview.removeAll()

                let reviewReposnse:ReviewListResponse = ReviewListResponse.init(fromDictionary: response as! [String:Any])
                self.setReviewData(reviewResponse:reviewReposnse)

                self.arrForPublicReview =  reviewReposnse.storeReviewList
                self.arrForRemainingReview =  reviewReposnse.remainingReviewList
                self.tblForReview.reloadData()
                self.configureHeaderView()
                //                    self.heightViewContainer.constant = self.tblForReview.contentSize.height
                //
                //                    if self.alertView.frame.origin.y <= (self.view.frame.origin.y - 100.0) {
                //                        self.heightViewContainer.constant = self.tblForReview.contentSize.height - 100.0
                //                    }
            }
            Utility.hideLoading()
        }
    }

    func wsRateToStore(strReview: String, storeId: String, cell:ReviewCollectionViewCell) {
        Utility.showLoading()
        var review:String = strReview // txtComment.text ?? ""
        if review.compare("TXT_COMMENT_PLACEHOLDER".localized) == .orderedSame {
            review = ""
        }

        let dictParam: Dictionary<String,Any> =
        [PARAMS.USER_ID:preferenceHelper.getUserId(),
         PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
         PARAMS.ORDER_ID:storeId,
         PARAMS.USER_REVIEW_TO_STORE:review,
         PARAMS.USER_RATING_TO_STORE:rate
        ]
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_USER_RATE_TO_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if (Parser.isSuccess(response: response,withSuccessToast:true, andErrorToast: true)) {
                self.wsGetOrderReviews()
                cell.txtWriteReview.text = ""
                cell.rate = 0.0
                self.collectionForReview.reloadData()
                return
            }
        }
    }

    func setReviewData(reviewResponse:ReviewListResponse) {
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
            rate = (rate/totalRating)
//            lblStoreRateValue.text = rate.toStringDouble(places: 2)
            lblStoreRateValue.text = reviewResponse.storeAvgReview.toStringDouble(places: 2)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE.STORE_REVIEW {
            let destinationVC:StoreFeedbackVC = segue.destination as! StoreFeedbackVC
            let orderData:RemainingReviewList = sender as! RemainingReviewList
            destinationVC.imgurl = (currentBooking.selectedStore?.image_url) ?? ""
            destinationVC.name = currentBooking.selectedStore?.name ?? ""
            destinationVC.orderId = orderData.orderId
//            destinationVC.rate = rate
        }
    }
}

extension ReviewVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arrForPublicReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:PublicReviewCell = tableView.dequeueReusableCell(withIdentifier: "publicReviewCell") as! PublicReviewCell
        cell.setCellData(cellData: arrForPublicReview[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            tableView.deselectRow(at: indexPath, animated: false)
          }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ReviewVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func configureHeaderView() {
        
        if (arrForRemainingReview.count) > 0 {
            viewForHeader.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 201)
            tblForReview.tableHeaderView = viewForHeader
            collectionForReview.reloadData()
            collectionForReview.isHidden = false
            self.heightViewContainer.constant =  self.preferredContentSize.height + 201
            
        }else {
            viewForHeader.isHidden = true
            viewForHeader.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
            tblForReview.tableHeaderView = viewForHeader
//            self.heightViewContainer.constant =  self.preferredContentSize.height + 200
            
           
            
            
        }
        if preferredContentSize.height <= UIScreen.main.bounds.height - 100 - 200{
                       self.heightViewContainer.constant = preferredContentSize.height + 150
                   }else{
                       self.heightViewContainer.constant = UIScreen.main.bounds.height - 100 - 200
                   }
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForRemainingReview.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCollectionViewCell
        

        cell.lblOrderId.text =  "TXT_ORDER_NO".localized + "\(String(arrForRemainingReview[indexPath.row].orderUniqueId))"
        cell.btnWriteReview.tag = indexPath.row
        cell.parentVC = self
        return cell
    }
    
    func onClikeBtnWriteReview(_ index: Int,rate:Double, strReview: String, cell:ReviewCollectionViewCell) {
        let selectedStore:RemainingReviewList = arrForRemainingReview[index]
        if rate != 0.0 {
            self.rate = Double(rate)
            self.wsRateToStore(strReview: strReview, storeId: selectedStore.orderId, cell:cell)
        } else {
            Utility.showToast(message: "MSG_ENTER_RATE_STORE".localized)
        }
//        self.performSegue(withIdentifier: SEGUE.STORE_REVIEW, sender: selectedStore)
//        self.openFeedbackDialogue(isRateProvider: false, selectedStore: selectedStore)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionForReview {
            var currentCellOffset =  self.collectionForReview.contentOffset
            currentCellOffset.x += (self.collectionForReview.frame.width) / 2
            if let indexPath = self.collectionForReview.indexPathForItem(at: currentCellOffset) {
                self.collectionForReview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width-50.0, height: 120.0)
    }
    
}



//MARK: Cell For CollectionView and TableView
class ReviewCollectionViewCell: CustomCollectionCell,/*RatingViewDelegate,*/ UITextFieldDelegate {
  /*  func RatingView(_ ratingView: RatingView, didUpdate rating: Float) {
        rate = rating
    }
*/
    @IBOutlet weak var btnWriteReview: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var viewWriteReview: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtWriteReview: UITextField!

    var parentVC:ReviewVC? = nil
    var rate:Double = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewWriteReview.layer.borderWidth = 1.0
        setLocalization()
    }

    func setLocalization()  {
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblOrderId.font = FontHelper.textMedium()
        self.lblOrderId.textColor = UIColor.themeTextColor
        self.btnWriteReview.setTitle("TXT_WRITE_REVIEW".localizedCapitalized, for: .normal)
        self.btnWriteReview.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnWriteReview.titleLabel?.font = FontHelper.textRegular(size: FontHelper.medium)
   /*
        // Required float rating view params
        self.ratingView.emptyImage = UIImage(named: "nf")?.imageWithColor(color: .themeTitleColor)
        self.ratingView.fullImage = UIImage(named: "ff")?.imageWithColor(color: .themeColor)
        
        // Optional params
        self.ratingView.emptyImage = UIImage(named: "nf")?.imageWithColor(color: .themeTitleColor)
        self.ratingView.fullImage = UIImage(named: "ff")?.imageWithColor(color: .themeColor)
        
        // Optional params
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 0
        self.ratingView.rating = rate
        self.ratingView.editable = true
        self.ratingView.halfRatings = false
        self.ratingView.floatRatings = false
        self.ratingView.emptyImage = UIImage(named: "nf")?.imageWithColor(color: UIColor.themeTitleColor)
        self.ratingView.fullImage = UIImage(named: "ff")?.imageWithColor(color: UIColor.themeColor)
    */
        self.ratingView.rating = 0.0
        self.ratingView.didTouchCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didTouchCosmos: \(rating)")
        }
        self.ratingView.didFinishTouchingCosmos = { /*[unowned self]*/ (rating: Double) -> () in
            //debugPrint("self.cosmosVw.didFinishTouchingCosmos: \(rating)")
            self.rate = rating
        }
        self.ratingView.settings.filledImage = UIImage(named: "ff")?.imageWithColor(color: .themeColor)
        self.ratingView.settings.emptyImage = UIImage(named: "nf")?.imageWithColor(color: .themeTitleColor)
        self.ratingView.settings.fillMode = .half
        self.ratingView.settings.minTouchRating = 0.5
        self.ratingView.settings.starSize =  Double(self.ratingView.frame.size.height)
        self.viewWriteReview.layer.borderColor = UIColor.themeTextColor.cgColor
        
        self.txtWriteReview.placeholder = "TXT_WRITE_REVIEW".localizedCapitalized
        self.txtWriteReview.tintColor = UIColor.themeViewBackgroundColor
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }

    @IBAction func onClickGiveReview(_ sender: UIButton) {
        parentVC?.onClikeBtnWriteReview(sender.tag, rate: rate, strReview: txtWriteReview.text ?? "", cell: self)
    }

    override func updateUIAccordingToTheme() {
//        setLocalization()
    }
}

/*
extension UITableView {
    
    func reloadData(_ completion: (() -> Void)?) {
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                completion?()
            })
            self.reloadData()
            CATransaction.commit()
        }
    }
    
    func reloadData(widthToFit cntrnt: NSLayoutConstraint?,
                    _ completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.contentOffset = CGPoint.zero
            self.reloadData({
                cntrnt?.constant = self.contentSize.width
                self.superview?.layoutIfNeeded()
                
                if self.isHEqualToCH {
                    completion?()
                }
                else {
                    self.reloadData(widthToFit: cntrnt, completion)
                }
            })
        }
    }
    
    func reloadData(heightToFit cntrnt: NSLayoutConstraint?,
                    _ completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.contentOffset = CGPoint.zero
            self.reloadData({
                cntrnt?.constant = self.contentSize.height
                self.superview?.layoutIfNeeded()
                
                if self.isHEqualToCH {
                    completion?()
                }
                else {
                    self.reloadData(heightToFit: cntrnt, completion)
                }
            })
        }
    }
    
    func deleteRows(at indexPaths: [IndexPath],
                    with animation: UITableView.RowAnimation,
                    _ completion: (() -> Void)?) {
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                completion?()
            })
            self.deleteRows(at: indexPaths, with: animation)
            CATransaction.commit()
        }
    }
    
}
extension UIScrollView {
    var isHEqualToCH: Bool {
        get {
            return abs(ceil(self.frame.height)-ceil(self.contentSize.height)) <= 1.0
        }
    }
} */
