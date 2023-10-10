//
// CartDetailDialogVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CartDetailDialogVC: BaseVC {
    
    
    //MARK: OutLets
    
    @IBOutlet weak var viewForDialog: Vw!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var mainOrderTable: UITableView!
    @IBOutlet weak var lblOrderDetail: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var viewForDialogHeight: NSLayoutConstraint!
    
    
    
    
    //MARK: Variables
    var arrForProducts:[OrderDetail] = []
    var currency:String = "";
    var strOrderNumber:String = "";
    override var preferredContentSize: CGSize {
        get {
            // Force the table view to calculate its height
            self.mainOrderTable.layoutIfNeeded()
            return self.mainOrderTable.contentSize
        }
        set {}
    }
    
    
    
    //MARK: LIFE CYCLE
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        btnCancel.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        //        btnCancel.setTitle("TXT_DONE".localizedUppercase, for: .normal)
        //        btnCancel.backgroundColor = UIColor.themeColor
        lblOrderNumber.text = strOrderNumber
        lblOrderDetail.textColor = UIColor.themeTextColor
        lblOrderNumber.textColor = UIColor.themeTextColor
        lblOrderNumber.font = FontHelper.textRegular()
        lblOrderDetail.font = FontHelper.textLarge()
        viewForDialog.isHidden = true
//        view.isOpaque = false
        view.backgroundColor = UIColor.themeOverlayColor
        //        viewForDialog.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 0.0), shadowOpacity: 0.17, shadowRadius: 3.0)
        
        viewForDialog.backgroundColor = UIColor.themeViewBackgroundColor
        
        if arrForProducts.isEmpty {
            
        }else {
            self.mainOrderTable.estimatedRowHeight = 150
            self.mainOrderTable.rowHeight = UITableView.automaticDimension
            self.mainOrderTable.reloadData()
            if preferredContentSize.height <= UIScreen.main.bounds.height - 55 - 30 - 100{
                viewForDialogHeight.constant = preferredContentSize.height + 55 + 30
            }else{
                viewForDialogHeight.constant = UIScreen.main.bounds.height - 55 - 30 - 100
            }
            //            setConstraintForTableview()
            updateUIAccordingToTheme()
        }        
    }
    
    override func updateUIAccordingToTheme() {
        btnCancel.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.animationBottomTOTop(self.viewForDialog)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewForDialog.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewForDialog.applyTopCornerRadius()
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    
    func setConstraintForTableview() {
        if mainOrderTable.contentSize.height >= (UIScreen.main.bounds.height - (140 + UIApplication.shared.statusBarFrame.height)) {
            tableViewHeight.constant = (UIScreen.main.bounds.height - (140 + UIApplication.shared.statusBarFrame.height))
        }else {
            tableViewHeight.constant = mainOrderTable.contentSize.height
        }
    }
}

extension CartDetailDialogVC:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return    arrForProducts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrForProducts[section].items!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomOrderDetailCell
        
        cell.setCellData(itemDetail: arrForProducts[indexPath.section].items![indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSection
        
        sectionHeader.setData(title: (arrForProducts[section].productName))
        return sectionHeader
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (arrForProducts[section].productName)
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




