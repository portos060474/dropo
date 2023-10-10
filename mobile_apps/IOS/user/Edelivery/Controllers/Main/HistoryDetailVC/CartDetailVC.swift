//
// CartDetailVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CartDetailVC: BaseVC {

   
    //MARK: OutLets
    
    @IBOutlet weak var btnReorder: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReceivedBy: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var heightForTblList: NSLayoutConstraint!
    override var preferredContentSize: CGSize {
        get {
            self.mainOrderTable.layoutIfNeeded()
            return self.mainOrderTable.contentSize
        }
        set {}
    }
    var arrForProducts:[CartProduct] = []
    var historyDetailResponse:HistoryOrderDetailResponse? = nil
    var strCurrency:String = ""
    
    //MARK: Variables
    @IBOutlet weak var mainOrderTable: UITableView!

    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.arrForProducts.removeAll()
        self.arrForProducts = (self.historyDetailResponse?.cartDetail?.orderDetails)!
        btnReorder.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnReorder.setTitle("TXT_REORDER".localizedCapitalized, for: .normal)
        btnReorder.titleLabel?.font = FontHelper.buttonText()
        btnReorder.backgroundColor = UIColor.themeButtonBackgroundColor
        mainOrderTable.estimatedRowHeight = 100
        mainOrderTable.rowHeight = UITableView.automaticDimension
        mainOrderTable.reloadData()
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.textLarge()
        lblTitle.text = "TXT_ORDER_DETAILS".localized
        btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        self.lblStoreName.text =  (self.historyDetailResponse?.cartDetail?.pickupAddresses.first)?.userDetails?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLocalization()
    }
    func setLocalization()  {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if (preferredContentSize.height + mainOrderTable.frame.origin.y) <= UIScreen.main.bounds.height - 100{
            heightForTblList.constant = preferredContentSize.height + mainOrderTable.frame.origin.y + 50
        }else{
            heightForTblList.constant = UIScreen.main.bounds.height - 100
        }
        self.view.layoutSubviews()
        self.view.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.view.animationBottomTOTop(self.alertView)
        lblReceivedBy.text = "TXT_ORDER_RECEIVED_BY".localized
        lblReceivedBy.font = FontHelper.textSmall()
        lblReceivedBy.textColor = UIColor.themeLightTextColor
        lblStoreName.font = FontHelper.textMedium(size: FontHelper.labelRegular)
        lblStoreName.textColor = UIColor.themeTextColor
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        alertView.roundCorner(corners: [.topLeft, .topRight], withRadius: 20.0)
    }
    override func updateUIAccordingToTheme() {
       btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClickBtnReorder(_ sender: UIButton) {
        if(currentBooking.cart.count == 0) {
            wsAddItemInServerCart()
        }else {
            openClearCartDialog()
        }
    }
    @IBAction func onClickBtnBack(_ sender: UIButton)  {
        self.dismiss(animated: true, completion: nil)
    }
    func openClearCartDialog() {
        
        let dialogForClearCart = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_CLEAR_CART_TO_REORDER".localized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized)
        dialogForClearCart.onClickLeftButton = {
                [unowned dialogForClearCart] in
                dialogForClearCart.removeFromSuperview()
        }
        dialogForClearCart.onClickRightButton = {
                [unowned self, unowned dialogForClearCart] in
                dialogForClearCart.removeFromSuperview()
                self.wsClearCart()
        }
    }

    func wsGetCart() {
        let dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        print(dictParam)

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            currentBooking.clearCart()
            _ = Parser.parseCart(response)
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Cart", bundle: nil)
            if let cartvc: CartVC = mainView.instantiateInitialViewController() as? CartVC {
                self.navigationController?.pushViewController(cartvc, animated: true)
            }
        }
    }

    func wsAddItemInServerCart() {
        Utility.showLoading()
        let cartOrder:CartOrder = CartOrder.init()
        cartOrder.server_token = preferenceHelper.getSessionToken()
        cartOrder.user_id = preferenceHelper.getUserId()
        cartOrder.store_id = self.historyDetailResponse?.order_list?.store_id!
        cartOrder.order_details = self.arrForProducts
        cartOrder.pickupAddress = (self.historyDetailResponse?.cartDetail?.pickupAddresses)!
        cartOrder.destinationAddress = (self.historyDetailResponse?.cartDetail?.destinationAddresses)!

        let dictData:NSDictionary = (cartOrder.dictionaryRepresentation())
        dictData.setValue(self.historyDetailResponse?.store_detail?.isUseItemTax, forKey: PARAMS.IS_USE_ITEM_TAX)
        dictData.setValue(self.historyDetailResponse?.store_detail?.isTaxIncluded, forKey: PARAMS.IS_TAX_INCLUDED)

        print(Utility.convertDictToJson(dict: dictData as! Dictionary<String, Any>))
        print("dicdata \(dictData)")

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ADD_ITEM_IN_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictData as? Dictionary<String, Any>) { (response,error) -> (Void) in
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                self.wsGetCart()
            } else {
                Utility.hideLoading()
            }
        }
    }

    func wsClearCart() {
        var dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.CART_ID] = currentBooking.cartId

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_CLEAR_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            Utility.hideLoading()
            currentBooking.clearCart()
            currentBooking.clearTableBooking()
            self.wsAddItemInServerCart()
        }
    }
}

extension CartDetailVC:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrForProducts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForProducts[section].items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCartOrderDetailCell
        cell.setCellData(itemDetail: arrForProducts[indexPath.section].items![indexPath.row],currency: strCurrency)
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSection
        sectionHeader.setData(title: (arrForProducts[section].product_name!))
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (arrForProducts[section].product_name!)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



class CustomCartOrderDetailCell: CustomTableCell {
    
    /*View For Items*/
    @IBOutlet weak var viewForItem: UIView!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemQty: UILabel!
    @IBOutlet weak var lblnote: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var lblItemnote: UILabel!
    @IBOutlet weak var heightForTable: NSLayoutConstraint!
    /*Table For Selected Specification of Ordered Item*/
    @IBOutlet weak var tableForItemSpecification: UITableView!
    var arrForOrderItemSpecification:[Specifications] = []
    var strCurrency:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        tableForItemSpecification.dataSource = self
        tableForItemSpecification.delegate = self
        tableForItemSpecification.estimatedRowHeight = 35
        tableForItemSpecification.rowHeight = UITableView.automaticDimension
        tableForItemSpecification.estimatedSectionHeaderHeight = 40
        tableForItemSpecification.sectionHeaderHeight = UITableView.automaticDimension
        viewForItem.backgroundColor = UIColor.themeViewBackgroundColor
        lblItemPrice.textColor = UIColor.themeTextColor
        lblItemName.textColor = UIColor.themeTextColor
        lblItemQty.textColor = UIColor.themeTextColor
        lblItemnote.textColor = UIColor.themeTextColor
        footerView.backgroundColor = UIColor.themeViewBackgroundColor
        lblnote.textColor = UIColor.themeTextColor
        lblItemQty.font = FontHelper.textSmall()
        lblItemName.font = FontHelper.textMedium()
        lblItemPrice.font = FontHelper.textMedium()
        lblItemnote.font = FontHelper.textSmall()
        lblnote.font = FontHelper.textSmall()
        lblnote.text = "TXT_NOTE_FOR_ITEM".localizedCapitalized
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableForItemSpecification.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCellData(itemDetail:CartProductItems, currency:String) {
        
        self.strCurrency = currency

        if itemDetail.noteForItem.isEmpty {
            lblItemnote.isHidden = true
            lblnote.isHidden = true
            footerView.isHidden = true
        }else {
            lblItemnote.text =  itemDetail.noteForItem
            lblItemnote.isHidden = false
            lblnote.isHidden = false
            footerView.isHidden = false
        }
        
        if (itemDetail.item_price! > 0.0) {
            
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity!)  + " X " + currency + " " + ((itemDetail.item_price) ?? 0.0).toString()
            
        }else {
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity!)
            
        }
        lblItemName.text = itemDetail.item_name!
        lblItemPrice.text = currency + " " + ((itemDetail.total_specification_price! +  itemDetail.item_price!) * Double(itemDetail.quantity!)).toString()
        arrForOrderItemSpecification = itemDetail.specifications
        self.tableForItemSpecification.reloadData()
        heightForTable.constant = tableForItemSpecification.contentSize.height
        self.layoutIfNeeded()
    }
   
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            tableForItemSpecification.layer.removeAllAnimations()
            heightForTable.constant = tableForItemSpecification.contentSize.height
            UIView.animate(withDuration: 0.1) {
                self.updateConstraints()
                self.layoutIfNeeded()
            }
            
        }
}

//MARK: Tableview DataSource Methods
extension CustomCartOrderDetailCell:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return    arrForOrderItemSpecification.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrForOrderItemSpecification[section].list!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderItemSpecificationCell
        cell.setCellData(listItemDetail:arrForOrderItemSpecification[indexPath.section].list![indexPath.row],currency: strCurrency)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSpecificationSection
    
        sectionHeader.setCellData(title: arrForOrderItemSpecification[section].name ?? "",price: arrForOrderItemSpecification[section].price!,currency: strCurrency)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
