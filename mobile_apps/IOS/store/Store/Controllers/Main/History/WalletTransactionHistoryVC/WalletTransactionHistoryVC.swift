
//
//  OrderHistoryVC.swift
//  // Edelivery Store
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class WalletTransactionHistoryVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var arrForWalletHistory = NSMutableArray()
    var selectedWalletRequest:WalletRequestDetail?  = nil
    
    
    //MARK: View life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setLocalization()
        wsGetWalletTransactionHistory()
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        setupLayout()

        self.hideBackButtonTitle()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        setupLayout()

    }
    //MARK: Set localized layout
    func setLocalization() {
        view.backgroundColor = UIColor.themeViewBackgroundColor;
        tableView.tableFooterView = UIView()
        updateUI(isUpdate: false)
        //LOCALIZED
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
    }
    func setupLayout() {
       
        tableView.tableFooterView = UIView()
    }
    
    //MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForWalletHistory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletTransectionCell", for: indexPath) as! WalletTransactionHistoryCell
        
        let walletData = (arrForWalletHistory[indexPath.row] as! WalletRequestDetail)
        cell.setWalletHistoryData(walletRequestData: walletData )
        cell.btnCancelWalletRequest.tag = indexPath.row
        cell.btnCancelWalletRequest.addTarget(self, action: #selector(WalletTransactionHistoryVC.onClickCancelWalletRequest(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedWalletRequest = arrForWalletHistory[indexPath.row] as? WalletRequestDetail
       
        self.performSegue(withIdentifier:SEGUE.TRANSACTION_HISTORY_TO_TRANSACTION_HISTORY_DETAIL, sender: self.selectedWalletRequest)
       
        
    }
    @objc func onClickCancelWalletRequest(_ sender: UIButton) {
        self.selectedWalletRequest = arrForWalletHistory[sender.tag] as? WalletRequestDetail
        if self.selectedWalletRequest?.walletStatus == WalletRequestStatus.CANCELLED.rawValue {
            Utility.showToast(message: "MSG_REQUEST_IS_ALREADY_CANCELLED".localized)
        }else {
            openCancelRequestDialog()
        }
    }
    func openCancelRequestDialog() {
        
        let dialogForCancelRequest = CustomAlertDialog.showCustomAlertDialog(title: "TXT_CANCEL_WALLET_REQUEST".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForCancelRequest.onClickLeftButton = { [unowned dialogForCancelRequest, unowned self] in
                
                dialogForCancelRequest.removeFromSuperview();
        }
        dialogForCancelRequest.onClickRightButton = {
                 [unowned dialogForCancelRequest, unowned self] in
                dialogForCancelRequest.removeFromSuperview();
                self.wsCancelWalletRequest()
        }
    }
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let obj = segue.destination as! WalletTransactionHistoryDetailVC
        obj.walletDetail = sender as? WalletRequestDetail
    }
    
    //MARK: Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: User Define Function
    
    func updateUI(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
        tableView.isHidden = !isUpdate
    }
    //MARK:WebService Calls
    func wsCancelWalletRequest() {
        Utility.showLoading()
        let dictParam:[String:Any] =
            [PARAMS.WALLET_STATUS : selectedWalletRequest!.walletStatus,
             PARAMS.ID : selectedWalletRequest!.id,
             PARAMS.TYPE :CONSTANT.TYPE_STORE,
             ]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_CANCEL_WALLET_REQUEST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                self.selectedWalletRequest?.walletStatus = WalletRequestStatus.CANCELLED.rawValue
                    self.tableView.reloadData()
                
            }
            Utility.hideLoading()
        }
    }
    func wsGetWalletTransactionHistory() {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.ID : preferenceHelper.getUserId(),
             PARAMS.TYPE :String(CONSTANT.TYPE_STORE)]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_WALLET_REQUEST_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Parser.parseWalletTrasactionHistory(response, toArray: self.arrForWalletHistory, completion: { (result) in
                if result {
                    self.tableView.reloadData()
                    self.updateUI(isUpdate: true)
                }
                else {
                    self.updateUI(isUpdate: false)
                    
                }
                Utility.hideLoading()
            })
            
        }
    }
}
