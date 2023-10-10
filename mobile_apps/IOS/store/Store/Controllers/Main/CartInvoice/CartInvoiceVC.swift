//
//  HomeVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CartInvoiceVC:BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var btnPlaceOrder: UIButton!
    @IBOutlet weak var viewForTotal: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var tableForInvoice: UITableView!
    @IBOutlet weak var scrInvoice: UIScrollView!
    
    //MARK: Variables
    var finalTotal = 0.0
    var userId:String = ""
    var userToken:String = ""
    var noteForDeliveryMan:String = ""
    var currentBooking:StoreSingleton = StoreSingleton.shared;
    var arrForInvoice:NSMutableArray = [];
    var invoieResponse:InvoiceResponse? = nil
    //ViewForAsAp
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideBackButtonTitle()
        Utility.showLoading();
        setLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInvoice(invoiceResponse: self.invoieResponse!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setLocalization() {
        self.tableForInvoice.estimatedRowHeight = 30
        self.tableForInvoice.rowHeight = UITableView.automaticDimension
        
        self.setNavigationTitle(title:"TXT_INVOICE".localizedCapitalized)
        
        /*Set Color*/
        lblTotal.textColor = UIColor.themeTextColor
        view.backgroundColor = UIColor.themeViewBackgroundColor
        tableForInvoice.backgroundColor = UIColor.themeViewBackgroundColor
        viewForTotal.backgroundColor = UIColor.themeViewBackgroundColor
        btnPlaceOrder.backgroundColor = UIColor.themeColor;
        btnPlaceOrder.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        /* Set text */
        btnPlaceOrder.setTitle("TXT_PLACEORDER".localizedUppercase, for: .normal)
        lblTotal.text = "TXT_TOTAL".localizedCapitalized
        
        arrForInvoice = NSMutableArray.init()
        tableForInvoice.estimatedRowHeight = 30
        tableForInvoice.rowHeight = UITableView.automaticDimension
        /* Set Font */
        
        btnPlaceOrder.titleLabel?.font = FontHelper.textRegular()
        lblTotalValue.font = FontHelper.textMedium(size: 30)
        lblTotal.font = FontHelper.textRegular()
    }
    
    //MARK: TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "TXT_PAYMENT_DETAILS".localizedUppercase
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableForInvoice == tableView {
            let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! InvoiceSection
            sectionHeader.setData(title:"TXT_PAYMENT_DETAILS".localizedUppercase)
            return sectionHeader
        }else {
            return UIView.init()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForInvoice.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:CartInvoiceCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CartInvoiceCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentInvoiceItem:Invoice = arrForInvoice.object(at: indexPath.row) as! Invoice
        cell.setCellData(cellItem: currentInvoiceItem)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    //MARK: USER DEFINE FUNCTION
    func setInvoice(invoiceResponse:InvoiceResponse) {
        Parser.parseCartInvoice((invoieResponse?.order_payment!)!, toArray: self.arrForInvoice,invoiceResponse: invoiceResponse, completetion: { (result) in
            Utility.hideLoading()
            if (result) {
                self.tableForInvoice?.reloadData();
                self.lblTotalValue.text = (self.currentBooking.totalInvoice).toCurrencyString()
            }
        })
    }
    
    //MARK:- ACTION METHODS
    @IBAction func onClickPlaceOrder(_ sender: Any) {
        self.view.endEditing(true)
        Utility.showLoading()
        wsPayOrderPayment()
    }
    
    //MARK:- NAVIGATION METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    //MARK:- WEB SERVICE
    func wsPayOrderPayment() {
        
        let dictParam : [String : Any] =
            [PARAMS.USER_ID : (invoieResponse?.order_payment?.userId) ?? "",
             PARAMS.ORDER_PAYMENT_ID   : StoreSingleton.shared.orderPaymentId,
             PARAMS.IS_PAYMENT_MODE_CASH: true,
             PARAMS.ORDER_TYPE : CONSTANT.TYPE_STORE]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_PAY_ORDER_PAYMENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.wsCreateOrder()
            }else {
                Utility.hideLoading()
            }
        }
    }
    
    func wsCreateOrder() {
        
        let dictParam:[String:Any] = [PARAMS.USER_ID: (invoieResponse?.order_payment?.userId) ?? "",
                                      PARAMS.ORDER_TYPE : CONSTANT.TYPE_STORE,
                                      PARAMS.CART_ID:preferenceHelper.getCartID(),
                                      PARAMS.NOTE_FOR_DELIVERYMAN : noteForDeliveryMan,
                                      PARAMS.ORDER_PAYMENT_ID   : StoreSingleton.shared.orderPaymentId]
        
        print(dictParam)
        print(Utility.conteverDictToJson(dict: dictParam))

        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_CREATE_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {
                preferenceHelper.setRandomCartID(String.random(length: 20))
                preferenceHelper.setCartID("")
                self.currentBooking.clearCart()
                APPDELEGATE.goToMain()
            }
        }
    }
}

class InvoiceSection: CustomCell {
    
    //MARK:- OUTLET
    @IBOutlet weak var lblName: UILabel!
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.backgroundColor = UIColor.themeColor
        lblName.textColor = UIColor.themeButtonTitleColor
    }
    
    func setData(title:String) {
        lblName.text = title
            //.appending("     ")
//        lblName.sectionRound(lblName)
    }
    
    //MARK:- SET CELL DATA
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
