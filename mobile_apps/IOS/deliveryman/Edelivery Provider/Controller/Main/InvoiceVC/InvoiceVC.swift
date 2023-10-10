//
//  InvoiceVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 23/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class InvoiceVC: BaseVC{

    @IBOutlet weak var lblInvoiceMessage: UILabel!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var alertView : UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    public var isHistoryDetail = Bool ()
    public var orderPayment: OrderPayment!
    public var paymentType:String = ""
    public var strCurrency: String = ""
    public var activeOrder: ActiveOrder?;
    var arrForInvoice:NSMutableArray = [];
    var is_tax_included = true
   
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
        self.hideBackButtonTitle()
    }
    
    //MARK: Set localized layout
    func setLocalization() {
        if isHistoryDetail {
            btnSubmit.isHidden = true
            btnHeight.constant = 0
        }else {
            btnSubmit.isHidden = false
        }
        self.alertView.isHidden = true
        if (orderPayment != nil) {
            self.getInvoiceData()
            self.view.animationBottomTOTop(self.alertView)
            
        }else {
            self.wsGetInvoice()
        }
        lblInvoiceMessage.textColor = UIColor.themeLightTextColor
        lblInvoiceMessage.font = FontHelper.textSmall()
        // COLORS
        view.backgroundColor = UIColor.themeOverlayColor
        lblTotal.textColor = UIColor.themeLightTextColor
        lblTotalPrice.textColor = UIColor.themeTextColor
        btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSubmit.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        // LOCALIZED
        lblTotal.text = "TXT_TOTAL".localized
        btnSubmit.setTitle("TXT_SUBMIT".localizedUppercase, for: .normal)
        lblTitle.text = "TXT_INVOICE".localized
        btnCancel.setTitle("", for: .normal)
        /* Set Font */
        lblTotal.font = FontHelper.textSmall()
        lblTotalPrice.font = FontHelper.textLargest()
        lblTotal.font = FontHelper.textRegular(size: FontHelper.medium)
        lblTotalPrice.font = FontHelper.textMedium(size: 30)
        btnSubmit.titleLabel?.font = FontHelper.textRegular()
        btnCancel.setTitleColor(UIColor.themeIconTintColor, for: .normal)
        btnCancel.tintColor = UIColor.themeIconTintColor
        lblTitle.font = FontHelper.textLarge()
        lblTitle.textColor = UIColor.themeTitleColor
        btnCancel.imageView?.contentMode = .scaleAspectFill
        btnCancel.setImage(UIImage.init(named: "cancel_icon")?.imageWithColor(), for: .normal)
        lblInvoiceMessage.numberOfLines = 0
   }
    
    @IBAction func onClickBtnCancel(_ sender: Any) {
        self.view.animationForHideAView(alertView) {
            self.dismiss(animated: false, completion: nil)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        alertView.roundCorner(corners: [.topLeft , .topRight], withRadius: 20)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        self.tableViewHeight.constant = self.tableView.contentSize.height
    }
    
//MARK: Get Invoice Data
    func getInvoiceData() {
        self.lblTotalPrice.text = "\((self.orderPayment.total!).toCurrencyString())"
        Parser.parseInvoice(orderPayment, toArray: self.arrForInvoice, currency:strCurrency, isTaxIncluded: self.is_tax_included, completetion: { [self] (result) in
            if result {
                print(self.arrForInvoice)
                self.setInvoiceMessage()
                self.tableView?.reloadData()
            }
        })
    }
    
    func setInvoiceMessage() {
        
        if isHistoryDetail {
            if orderPayment.is_store_pay_delivery_fees {
                lblInvoiceMessage.text = "MSG_DELIVERY_FEE_FREE_AND_INVOICE".localized
            }
            else {
                lblInvoiceMessage.text = "TXT_INVOICE_DETAILS".localized
            }
        }
        else if (orderPayment.isPaymentModeCash) {
            if orderPayment.is_store_pay_delivery_fees {
                lblInvoiceMessage.text = "MSG_DELIVERY_FEE_FREE_AND_CASH_PAY".localizedCapitalized
                print("MSG_DELIVERY_FEE_FREE_AND_CASH_PAY".localized)
            }
            else {
                lblInvoiceMessage.text = "MSG_PAY_CASH".localized
            }
        }else {
            lblInvoiceMessage.text = "MSG_PAY_OTHER".localized
        }
    }
    
//MARK: Web Service Calls
    func wsGetInvoice() {
        Utility.showLoading()
        let dictParam:[String:Any] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.REQUEST_ID : activeOrder?._id ?? "",
             PARAMS.TYPE: CONSTANT.TYPE_PROVIDER]

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_GET_INVOICE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.orderPayment = OrderPayment.init(dictionary: response["order_payment"] as! [String:Any])
                self.strCurrency = response["currency"] as! String
                self.paymentType = response["payment_gateway_name"] as! String
                self.is_tax_included = response["is_tax_included"] as? Bool ?? false
                self.getInvoiceData()
                self.view.animationBottomTOTop(self.alertView)
            } else {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }

    func wsShowInvoice() {
        Utility.showLoading()
        let dictParam:[String:Any] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.REQUEST_ID : activeOrder?._id ?? "",
             PARAMS.TYPE: CONSTANT.TYPE_PROVIDER,
             PARAMS.IS_PROVIDER_SHOW_INVOICE: true]
        print(dictParam)
        
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_SHOW_INVOICE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
            Utility.hideLoading()
            print(response)
            if Parser.isSuccess(response: response) {
               
                let _ = DailogForFeedback.showCustomFeedbackDialog(self.activeOrder?.destinationAddresses[0].userDetails.name ?? "",true , false ,(self.activeOrder?._id!) ?? "")
              
                return
            }else {
                
            }
            
        })
    }
    
//MARK: Button action method
    @IBAction func onClickSubmit(_ sender: UIButton) {
        wsShowInvoice()
    }
   
//MARK: Memory mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension InvoiceVC :UITableViewDelegate,UITableViewDataSource {

    //MARK: Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrForInvoice.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       if  let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as? InvoiceSectionCell
       {
            if arrForInvoice.count > section {
                if let invoiceSection = arrForInvoice.object(at: section) as? [Invoice], invoiceSection.count > 0 {
                    sectionHeader.setData(title: invoiceSection[0].sectionTitle ?? "")
                }else {
                    sectionHeader.setData(title: "")
                }
            }else {
                sectionHeader.setData(title: "")
            }
            return sectionHeader
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrForInvoice.object(at: section) as! [Invoice]).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InvoiceCell
        let currentInvoiceItem:Invoice = ((arrForInvoice .object(at: indexPath.section)) as! [Invoice])[indexPath.row]
        cell.setCellData(cellItem: currentInvoiceItem)
        return cell
    }
}
class InvoiceSectionCell: CustomTableCell {
    @IBOutlet weak var lblSection: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.backgroundColor = UIColor.themeViewLightBackgroundColor//
        lblSection.textColor = UIColor.themeLightGrayTextColor
        lblSection.font = FontHelper.textRegular()
   }
    
    func setData(title: String){
        lblSection.text = "  \(title.localizedUppercase)  "
        lblSection.setRound(withBorderColor: .clear, andCornerRadious: 4.0, borderWidth: 0)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
