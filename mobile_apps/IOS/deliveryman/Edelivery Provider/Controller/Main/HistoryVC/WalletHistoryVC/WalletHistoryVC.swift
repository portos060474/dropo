
//
//  OrderHistoryVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class WalletHistoryVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
   
//MARK: OutLets
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    var arrForWalletHistory = NSMutableArray()
    var selectedWalletRequest:WalletHistoryItem?  = nil
   
//MARK: View life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setLocalization()
        wsGetWalletHistory()
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        self.hideBackButtonTitle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
   
//MARK: Set localized layout
    func setLocalization() {
        view.backgroundColor = UIColor.themeViewBackgroundColor;
        tableView.tableFooterView = UIView()
        updateUI(isUpdate: false)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletHistoryCell", for: indexPath) as! WalletHistoryCell
        let walletData = (arrForWalletHistory[indexPath.row] as! WalletHistoryItem)
        cell.setWalletHistoryData(walletRequestData: walletData )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedWalletRequest = arrForWalletHistory[indexPath.row] as? WalletHistoryItem
        self.performSegue(withIdentifier: SEGUE.WALLET_HISTORY_TO_WALLET_HISTORY_DETAIL, sender: selectedWalletRequest)
    }
   
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    let obj = segue.destination as! WalletHistoryDetailVC
       obj.walletDetail = sender as? WalletHistoryItem
    }
    
    //MARK: Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //MARK: User Define Function
    func updateUI(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
        tableView.isHidden = !isUpdate
    }
    
    //MARK:WebService Calls
   
    func wsGetWalletHistory() {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.ID : preferenceHelper.getUserId(),
             PARAMS.TYPE :CONSTANT.TYPE_PROVIDER]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_WALLET_HISTORY, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Parser.parseWalletHistory(response, toArray: self.arrForWalletHistory, completion: { (result) in
                Utility.hideLoading()
                if result {
                    self.tableView.reloadData()
                    self.updateUI(isUpdate: true)
                }else {
                    self.updateUI(isUpdate: false)
                }
                Utility.hideLoading()
            })
            
        }
    }
}
