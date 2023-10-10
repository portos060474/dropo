//
//  HistoryInvoiceVC.swift
//  Edelivery
//   Created by Ellumination 23/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class HistoryInvoiceVC: BaseVC, UITableViewDelegate, UITableViewDataSource, LeftDelegate {
    
    @IBOutlet weak var lblinvoiceMsg: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var viewForBottom: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTimeValue: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDistanceValue: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblPaymentValue: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblWalletValue: UILabel!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var lblCardValue: UILabel!
    @IBOutlet weak var imgPaymentIn: UIImageView!
    @IBOutlet weak var imgPaymentBy: UIImageView!
    @IBOutlet weak var viewForPromo: UIView!
    @IBOutlet weak var lblPromo: UILabel!
    @IBOutlet weak var lblPromoValue: UILabel!
    @IBOutlet weak var btnSubmitHeight: NSLayoutConstraint!
   
    var dict = NSMutableDictionary()
    var arr = [NSString]()
    public var orderPayment: OrderPayment!
    public var paymentType:String = ""
    public var strCurrency: String = ""
    public var strOrderID: String = ""
    public var imgurl: String = ""
    public var name: String = ""
    public var promoMessage: String = ""
    static var isInvoiceSubmittedOnce: Bool = false
    var isTaxIncluded: Bool = false
    var arrForInvoice:NSMutableArray = []
    var isFromHistory:Bool = false
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var heightForTblList: NSLayoutConstraint!
    var dialogForFeedback: DailogForFeedback? = nil
    
    override var preferredContentSize: CGSize {
        get {
            self.tableView.layoutIfNeeded()
            return self.tableView.contentSize
        }
        set {}
    }
    
    //MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setLocalization()
        delegateLeft = self
        if isFromHistory {
            btnSubmit.isHidden = true
            btnSubmitHeight.constant = 0
            self.tableView.estimatedRowHeight = 30
            self.tableView.rowHeight = UITableView.automaticDimension
            self.getInvoiceData()
        }else {
            self.setBackBarItem(isNative: false)
            if HistoryInvoiceVC.isInvoiceSubmittedOnce{
                btnSubmit.isHidden = true
            }else{
                btnSubmit.isHidden = false
            }
            self.tableView.estimatedRowHeight = 30
            self.tableView.rowHeight = UITableView.automaticDimension
            wsGetInvoice()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.animationBottomTOTop(self.alertView)
    }
    func onClickLeftButton() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }else {
            APPDELEGATE.goToMain()
        }
    }
    @IBAction func onClickBtnBack(_ sender: UIButton)  {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickBtnSubmit(_ sender: Any) {
        wsShowInvoice()
    }
    
    //MARK: Set localized layout
    
    func setLocalization() {
        // COLORS
        view.backgroundColor = UIColor.themeOverlayColor
        alertView.backgroundColor = UIColor.themeViewBackgroundColor
        lblTime.textColor = UIColor.themeLightTextColor
        lblinvoiceMsg.textColor = UIColor.themeLightTextColor
        lblTimeValue.textColor = UIColor.themeTextColor
        lblDistance.textColor = UIColor.themeLightTextColor
        lblDistanceValue.textColor = UIColor.themeTextColor
        lblPayment.textColor = UIColor.themeLightTextColor
        lblPaymentValue.textColor = UIColor.themeTextColor
        lblWallet.textColor = UIColor.themeLightTextColor
        lblWalletValue.textColor = UIColor.themeTextColor
        lblCard.textColor = UIColor.themeLightTextColor
        lblCardValue.textColor = UIColor.themeTextColor
        lblPromo.textColor = UIColor.themeLightTextColor
        lblPromoValue.textColor = UIColor.themeTextColor
        lblTotal.textColor = UIColor.themeTextColor
        lblTotalPrice.textColor = UIColor.themeTextColor
        viewForHeader.backgroundColor = UIColor.themeViewBackgroundColor
        viewForBottom.backgroundColor = UIColor.themeViewBackgroundColor
        btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSubmit.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.title = "TXT_INVOICE".localized
        lblTime.text = "TXT_TIME_HH_MM".localized
        btnSubmit.setTitle("TXT_SUBMIT".localizedCapitalized, for: UIControl.State.normal)
        lblDistance.text = "TXT_DISTANCE".localized
        lblPayment.text = "TXT_PAYMENT".localized
        lblWallet.text = "TXT_WALLET".localized
        lblCard.text = "TXT_CARD".localized
        lblTotal.text = "TXT_TOTAL".localized
        lblPromo.text = "TXT_PROMO".localized
        /* Set Font */
        lblTime.font = FontHelper.textSmall()
        lblTimeValue.font = FontHelper.textSmall()
        lblDistance.font = FontHelper.textSmall()
        lblDistanceValue.font = FontHelper.textSmall()
        lblPayment.font = FontHelper.textSmall()
        lblPaymentValue.font = FontHelper.textSmall()
        lblWallet.font = FontHelper.textSmall()
        lblWalletValue.font = FontHelper.textSmall()
        lblCard.font = FontHelper.textSmall()
        lblCardValue.font = FontHelper.textSmall()
        lblPromo.font = FontHelper.textSmall()
        lblPromoValue.font = FontHelper.textSmall()
        lblTotal.font = FontHelper.textSmall()
        lblTotalPrice.font = FontHelper.textLargest()
        lblinvoiceMsg.font = FontHelper.textSmall()
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.textLarge()
        lblTitle.text = "TXT_INVOICE".localized
        btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        self.hideBackButtonTitle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        alertView.roundCorner(corners: [.topLeft, .topRight], withRadius: 20.0)
    }
    
    override func updateUIAccordingToTheme() {
       btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
    }
    
    //MARK: Get Invoice Data
    func getInvoiceData() {
        
        lblTimeValue.text = Utility.minutToHoursMinutes(minut: orderPayment.total_time ?? 0.0)
        let unit = (orderPayment.is_distance_unit_mile) ? "UNIT_MILE".localized : "UNIT_KM".localized
        lblDistanceValue.text = String(orderPayment.total_distance!) + " " + unit
        lblPaymentValue.text = paymentType
        lblWalletValue.text =  strCurrency + " " + (orderPayment.wallet_payment ?? 0.0).toString()
        let strTotal = (orderPayment.promo_payment! > 0.0) ? (orderPayment.userPayPayment ?? 0.0).toString() : (orderPayment.total ?? 0.0).toString()
        lblTotalPrice.text =  strCurrency + " " + strTotal
        if orderPayment.isPaymentModeCash {
            imgPaymentBy.image = UIImage.init(named: "cash_icon")
            imgPaymentIn.image = UIImage.init(named: "cash_icon")
            lblCard.text = "TXT_CASH".localizedCapitalized
            lblCardValue.text = strCurrency + " " + (orderPayment.cash_payment ?? 0.0).toString()
        }else {
            imgPaymentBy.image = UIImage.init(named: "card_icon")
            imgPaymentIn.image = UIImage.init(named: "card_icon")
            lblCard.text = "TXT_CARD".localizedCapitalized
            lblCardValue.text = strCurrency + " " + (orderPayment.card_payment ?? 0.0).toString()
        }
        var isShowPromo: Bool = false
        if orderPayment.promo_payment! > 0.0 {
            isShowPromo = true
        }
        Parser.parseInvoice(orderPayment, toArray: self.arrForInvoice, currency:strCurrency, isTaxIncluded: self.isTaxIncluded, isShowPromo: isShowPromo, completetion: { (result) in
            if result {
                self.tableView?.reloadData()
                self.setInvoiceMessage()
                self.setPromoMessage()
                self.setTabaleHeight()
            }
        })
    }
    
    func setPromoMessage() {
        if orderPayment.is_promo_for_delivery_service && orderPayment.promo_payment! > 0.0 {
            lblPromoValue.text = strCurrency + " " + (orderPayment.promo_payment ?? 0.0).toString()
            if orderPayment.is_promo_for_delivery_service {
                lblinvoiceMsg.text =  lblinvoiceMsg.text! +  "\n" +  "TXT_DELIVERY_PROMO".localized
            }else {
                lblinvoiceMsg.text =  lblinvoiceMsg.text! +  "\n" + "TXT_ORDER_PROMO".localized
            }
            viewForPromo.isHidden = false
        }else {
            viewForPromo.isHidden = true
        }
    }
    
    func setInvoiceMessage() {
        if (orderPayment.is_store_pay_delivery_fees && orderPayment.isPaymentModeCash) {
            lblinvoiceMsg.text = "MSG_DELIVERY_FEE_FREE_AND_CASH_PAY".localized
            
        } else if (orderPayment.is_store_pay_delivery_fees && !orderPayment.isPaymentModeCash) {
            lblinvoiceMsg.text = "MSG_DELIVERY_FEE_FREE_AND_OTHER_PAY".localized
            
        } else if (orderPayment.isPaymentModeCash) {
            lblinvoiceMsg.text = "MSG_PAY_CASH".localized
            
        }else {
            lblinvoiceMsg.text = "MSG_PAY_OTHER".localized
        }
    }
    
    func setTabaleHeight()  {
        if (preferredContentSize.height + tableView.frame.origin.y) <= UIScreen.main.bounds.height - 100{
                   heightForTblList.constant = preferredContentSize.height /*+ tableView.frame.origin.y + 50 */
               }else{
                   heightForTblList.constant = UIScreen.main.bounds.height - 100
               }
               self.view.layoutSubviews()
    }
    
    //MARK: Tableview Delegate
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrForInvoice.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InvoiceCell
        
        let currentInvoiceItem:Invoice = arrForInvoice.object(at: indexPath.row) as! Invoice
        cell.setCellData(cellItem: currentInvoiceItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: Memory mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Web Service Calls
    func wsGetInvoice() {
        Utility.showLoading()
        let dictParam:[String:Any] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.ORDER_ID : strOrderID,
             PARAMS.TYPE: CONSTANT.TYPE_USER]
        print(dictParam)
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_GET_INVOICE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
            print("WS_GET_INVOICE \(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))")

            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.orderPayment = OrderPayment.init(dictionary: response.value(forKey: "order_payment") as! NSDictionary)
                self.strCurrency = response.value(forKey: "currency") as! String
                self.paymentType = response.value(forKey: "payment_gateway_name") as! String
                self.isTaxIncluded = response.value(forKey: "is_tax_included") as! Bool
                self.getInvoiceData()
            }
        })
    }
    
    func wsShowInvoice() {
        Utility.showLoading()
        let dictParam:[String:Any] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.ORDER_ID : strOrderID,
             PARAMS.TYPE: CONSTANT.TYPE_USER,
             PARAMS.IS_USER_SHOW_INVOICE: true]
        
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_SHOW_INVOICE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response) {
                self.btnSubmit.isHidden = true
                HistoryInvoiceVC.isInvoiceSubmittedOnce = true
                self.wsGetOrderStatus()
            }
        })
    }
    
    func wsGetOrderStatus() {
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.ORDER_ID : strOrderID]
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ORDER_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if (Parser.isSuccess(response: response)) {
                let orderStatusReponse = OrderStatusResponse.init(fromDictionary: response as! [String : Any])
                
                if orderStatusReponse.providerId.isEmpty {
                    APPDELEGATE.goToMain()
                }else {
                    self.name = orderStatusReponse.provider_detail!.name ?? ""
                    self.imgurl = orderStatusReponse.provider_detail?.image_url ?? ""
                    self.dismiss(animated: true, completion: nil)
                    return
                }
            }
        }
    }
    
    //MARK: USER DEFINE FUNCTION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier?.compare(SEGUE.INVOICE_TO_FEEDBACK) == ComparisonResult.orderedSame) {
            let feedbackVC = segue.destination as! FeedbackVC
            feedbackVC.name = self.name
            feedbackVC.imgurl = self.imgurl
            feedbackVC.isRateToProvider = true
        }
    }
}
