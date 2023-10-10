//
//  HomeVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit


class CartVC: BaseVC,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,RightDelegate {
    func onClickRightButton() {
        currentBooking.clearCart()
        updateUI(isUpdate: false)
    }
    
    //MARK: OutLets
    @IBOutlet weak var btnCheckout: UIButton!
    
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var viewForTotal: UIView!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var tableForCartItems: UITableView!
    //MARK: Variables
    
    var currentBooking = StoreSingleton.shared;
    
    let btnRemoveAll = UIButton.init(type: .custom)
    //MARK:
    //MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        setLocalization()
        delegateRight = self
        tableForCartItems.rowHeight = UITableView.automaticDimension
        tableForCartItems.estimatedRowHeight = 120
        self.setNavigationTitle(title: "TXT_BASKET".localizedCapitalized)
        
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        
        if (currentBooking.cart).count == 0 {
            updateUI(isUpdate: false)
        }else {
            tableForCartItems?.reloadData();
            calculateTotalAmount()
        }
        
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
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
    
    func setLocalization(){
        //Colors
        
        lblTotalValue.textColor = UIColor.themeButtonTitleColor
        btnCheckout.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnCheckout.backgroundColor = UIColor.themeColor
        viewForTotal.backgroundColor = UIColor.themeColor
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableForCartItems.backgroundColor = UIColor.themeViewBackgroundColor
        //Localizing
        title = "TXT_BASKET".localized
        
        lblTotalValue.text = "TXT_DEFAULT".localized
        btnCheckout.setTitle("TXT_CHECKOUT".localizedUppercase, for: UIControl.State.normal)
        
        /*Set Font*/
        lblTotalValue.font = FontHelper.textRegular()
        btnCheckout.titleLabel?.font = FontHelper.textRegular()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onClickCheckOut(_:)))
        gestureRecognizer.delegate = self
        viewForTotal.addGestureRecognizer(gestureRecognizer)
        viewForTotal.setRound(withBorderColor: .clear, andCornerRadious: viewForTotal.frame.size.height/2, borderWidth: 1.0)
        
        self.hideBackButtonTitle()
        updateUIAccordingToTheme()
    }
    
    func setupLayout(){
        if tableForCartItems != nil{
            tableForCartItems.tableFooterView = UIView()
        }
    }
    override func updateUIAccordingToTheme() {
        btnRemoveAll.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        
        self.tableForCartItems.reloadData()
    }
    
    //MARK: TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return currentBooking.cart[section].items.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:CartCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CartCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentProduct:CartProduct = currentBooking.cart[indexPath .section]
        let currentItem:CartProductItems = currentProduct.items[indexPath.row]
        cell.setCellData(cellItem: currentItem, section: indexPath.section, row: indexPath.row, parent: self)
        return cell;
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {   return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentBooking.cart.count
    }
    //MARK: USER DEFINE FUNCTION
    
    func updateUI(isUpdate:Bool = false) {
        tableForCartItems.isHidden = !isUpdate
        viewForTotal.isHidden = !isUpdate
        imgEmpty.isHidden = isUpdate
        btnCheckout.isHidden = !isUpdate
        if isUpdate {
            self.setRightBarButton(button: btnRemoveAll);
        }else {
            self.removerRightButton()
        }
    }
    public func increaseQuantity(currentProductItem:CartProductItems){
        var quantity = currentProductItem.quantity!;
        quantity = quantity + 1
        let total = (currentProductItem.totalSpecificationPrice + currentProductItem.itemPrice) * Double(quantity)
        
        currentProductItem.totalItemPrice = total
        currentProductItem.quantity = quantity
        currentProductItem.totalItemTax =  currentProductItem.totalTax * Double(quantity)
        self.tableForCartItems?.reloadData()
        
        calculateTotalAmount()
        
    }
    public func removeItemFromCart(currentProductItem:CartProductItems, section:Int, row:Int){
        let currentProduct:CartProduct = currentBooking.cart[section]
        currentProduct.items.remove(at: row)
        let itemCount = (currentProduct.items.count)
        if itemCount == 0 {
            currentBooking.cart.remove(at: section)
        }
        
        self.tableForCartItems?.reloadData()
        calculateTotalAmount()
    }
    public func decreaseQuantity(currentProductItem:CartProductItems){
        var quantity = currentProductItem.quantity!;
        if (quantity > 1 ) {
            quantity = quantity - 1
            let total = (currentProductItem.totalSpecificationPrice + currentProductItem.itemPrice) * Double(quantity)
            currentProductItem.totalItemPrice = total
            currentProductItem.quantity = quantity
            currentProductItem.totalItemTax =  currentProductItem.totalTax * Double(quantity)
            
            self.tableForCartItems?.reloadData()
            calculateTotalAmount()
        }
        
    }
    
    
    func getTax(itemAmount:Double, taxValue:Double) -> Double {
        if !StoreSingleton.shared.store.isTaxInlcuded{
            return itemAmount * taxValue * 0.01
        }else{
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
        
    }
    
    func calculateTotalAmount(){
        var total = 0.0
        var totalCartAmountWithoutTax = 0.0
        
        for currentProduct in currentBooking.cart {
            for currentProductItem in currentProduct.items {
                var eachItemTax = 0
                
                if StoreSingleton.shared.store.isUseItemTax{
                    for obj in currentProductItem.taxDetails{
                        eachItemTax = eachItemTax + obj.tax
                    }
                }else{
                    for obj in StoreSingleton.shared.store.taxesDetails{
                        eachItemTax = eachItemTax + obj.tax
                    }
                }
                
                let itemTax = getTax(itemAmount: currentProductItem.itemPrice, taxValue: Double(eachItemTax))
                let specificationTax = getTax(itemAmount: currentProductItem.totalSpecificationPrice, taxValue: Double(eachItemTax))
                let totalTax = itemTax + specificationTax
                print(totalTax)
                print("total item tax - \(totalTax * Double(currentProductItem.quantity))")
                
                if StoreSingleton.shared.store.isTaxInlcuded{
                    total = total + Double(currentProductItem.totalItemPrice) - (totalTax * Double(currentProductItem.quantity))
                }else{
                    total = total + Double(currentProductItem.totalItemPrice)
                }
                totalCartAmountWithoutTax = totalCartAmountWithoutTax + Double(currentProductItem.totalItemPrice)
            }
        }
        setTotalAmount(total,totalCartAmountWithoutTax: totalCartAmountWithoutTax)
    }
    
    func setTotalAmount(_ total:Double = 0.0,totalCartAmountWithoutTax:Double = 0.0) {
        currentBooking.totalCartAmount = total;
        currentBooking.totalCartAmountWithoutTax = totalCartAmountWithoutTax
        
        
        let strTotal = totalCartAmountWithoutTax.roundTo().toCurrencyString()
        lblTotalValue.text = strTotal
        
        var isModifyCart = false;
        for cartProduct in currentBooking.cart {
            if (cartProduct.items.count) > 0 {
                isModifyCart = true
                
            }
            
        }
        if  isModifyCart {
            updateUI(isUpdate: true)
        }else {
            updateUI(isUpdate: false)
            
        }
    }
    
    //MARK:- NAVIGATION METHODS
    @IBAction func onClickCheckOut(_ sender: Any) {
        if currentBooking.cart.count > 0 {
            self.performSegue(withIdentifier: SEGUE.ORDER_DELIVERY_DETAIL, sender: nil)
        }
    }
}
