//
//  OverViewVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class OverviewVC: BaseVC {
    let upArraow:String = "\u{25B2}"
    let downArrow:String = "\u{25BC}"
    
    @IBOutlet weak var scrOVerview: UIScrollView!
    @IBOutlet weak var lblStoreAddress: UILabel!
    @IBOutlet weak var lblSlogan: UILabel!
    @IBOutlet weak var lblStoreTime: UILabel!
    @IBOutlet weak var viewForStoreTime: UIView!
    @IBOutlet weak var tblForStoreTime: UITableView!
    @IBOutlet weak var lblStoreWebsite: UILabel!
    @IBOutlet weak var lblStorePhone: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnGetDirection: UIButton!
    @IBOutlet weak var viewforShare: UIView!
    @IBOutlet weak var viewForSlogan: UIView!
    @IBOutlet weak var viewForStoreWebsite: UIView!
    @IBOutlet weak var viewForPhone: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    let store:StoreItem = currentBooking.selectedStore!
   
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        tableHeight.constant = 1
        setStoreData()
        tblForStoreTime.estimatedRowHeight = 25
        tblForStoreTime.rowHeight = UITableView.automaticDimension
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
    
    func setupLayout() {
       
        if (lblStoreWebsite.text?.isEmpty())! {
            viewForStoreWebsite.isHidden = true
        }
        if (lblSlogan.text?.isEmpty())! {
            viewForSlogan.isHidden = true
        }
        if (lblStorePhone.text?.isEmpty())! {
            viewForPhone.isHidden = true
        }
    }
    
    func setLocalization() {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        btnGetDirection.setTitle("Get Direction".localized, for: .normal)
        btnShare.setTitle("TXT_SHARE".localized, for: .normal)
    }
    
   
    func setStoreData() {
        self.lblSlogan.text = store.slogan ?? ""
        self.lblStorePhone.text = (store.country_phone_code ?? "") + (store.phone ?? "")
        self.lblStoreAddress.text = store.address ?? ""
        self.lblStoreWebsite.text = store.website_url ?? ""
        self.lblStoreTime.text = "TXT_STORE_TIME".localizedCapitalized + "  " + downArrow
        tblForStoreTime.reloadData()
    }
    @IBAction func onClickShowHideTime(_ sender: UIButton) {
        
        self.tblForStoreTime.superview?.layoutIfNeeded()
        if sender.tag == 0
      {
        sender.tag = 1
        self.lblStoreTime.text = "TXT_STORE_TIME".localizedCapitalized + "  " + upArraow
        tableHeight.constant = tblForStoreTime.contentSize.height
        
      }
        else
      {
        sender.tag = 0
            tableHeight.constant = 0
       self.lblStoreTime.text = "TXT_STORE_TIME".localizedCapitalized + "  " + downArrow
        
      }
    }
    @IBAction func onClickBtnShare(_ sender: Any) {
      var myString = ""
      if store.branch_io_url.isEmpty
      {
         myString = String(format: "TXT_SHARE_STORE_DETAIL".localized.replacingOccurrences(of: "****", with: "APP_NAME".localized),(store.name ?? "") , (store.website_url ?? ""))
        
      }
      else
      {
        myString = store.branch_io_url
      }
        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickBtnMap(_ sender: Any) {
        let url = "http://maps.apple.com/maps?saddr=\(currentBooking.currentLatLng[0]),\(currentBooking.currentLatLng[1])&daddr=\(store.location?[0] ?? 0.0),\(store.location?[1] ?? 0.0)"
        UIApplication.shared.openURL(URL(string:url)!)
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
        
    }
    @IBAction func onClickBtnWebsite(_ sender: Any) {
        guard let url = URL(string: store.website_url ?? "") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func onClickBtnCall(_ sender: Any) {
        let storeContactNumber:String = store.country_phone_code! + store.phone!
        if storeContactNumber.isEmpty {
            Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
        }else {
        if let url = URL(string: "tel://\(storeContactNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        }
}
    //ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
    }
    @IBAction func onClickBtnRight(_ sender: Any) {
        
    }
}

extension OverviewVC: UITableViewDelegate,UITableViewDataSource {
    //MARK: TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let storeTimeItem = store.store_time[section]
        if (storeTimeItem.isStoreOpenFullTime) {
            return 1
        }
        else if (!storeTimeItem.isStoreOpenFullTime && !storeTimeItem.isStoreOpen) {
            return 1
        }
        else if (storeTimeItem.dayTime.count == 0) {
            return 1
        }else {
            return storeTimeItem.dayTime.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return store.store_time.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       let cell = UITableViewCell()
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
