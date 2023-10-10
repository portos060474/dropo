//
//  MenuVC.swift
//  Edelivery Provider
//
//  Created by Elluminati on 10/03/21.
//  Copyright © 2021 Elluminati iMac. All rights reserved.
//

import UIKit

class MenuVC: BaseVC {
   
    @IBOutlet weak var lblTheme: UILabel!
    @IBOutlet weak var switchForTheme: UISwitch!
    @IBOutlet weak var tblForMenu : UITableView!
   
    var arrForMenu:[(String,String)] = [("TXT_HOME","bottomHomeSelected"),("TXT_EARN","bottomEarningSelected"),("TXT_HISTORY","bottomHistorySelected"),("TXT_ACCOUNT","bottomAccountSelected")]
    var selectedRow = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
    }
    
    override func updateUIAccordingToTheme() {
        tblForMenu.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLocalization()
    }
    
    func setLocalization() {
        tblForMenu.backgroundColor = UIColor.themeViewBackgroundColor
        tblForMenu.separatorStyle = .none
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        tblForMenu.reloadData()
    }
    
    func signOutFirebaseAuth(){
        
        if  firebaseAuth.currentUser != nil {
            do{
                try firebaseAuth.signOut()
                print("Logout successfully from firebase authentication")
                preferenceHelper.setAuthToken("")
            }catch let signOutError as NSError {
                print("Error signing out in: %@", signOutError)
            }
        }
    }
    
    @IBAction func onChangeTheme(_ sender: Any) {
    }
}

extension MenuVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForMenu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        cell.setData(arrForMenu[indexPath.row].0, arrForMenu[indexPath.row].1,indexPath.row , selectedRow)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.revealViewController()?.hidesideView()
        if selectedRow != indexPath.row {
            tableView.deselectRow(at: indexPath, animated: false)
            selectedRow = indexPath.row
            tblForMenu.reloadData()
            
            if let navigationVC: UINavigationController = self.revealViewController()?.mainViewController as? UINavigationController
            {
                var popview = false
                var selectedTab = ""
                selectedTab = arrForMenu[indexPath.row].0
                switch selectedTab
                {
                case "TXT_HOME":
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        navigationVC.popToRootViewController(animated: true)
                    }
                case "TXT_EARN":
                    for vc in navigationVC.viewControllers {
                        if vc.classForCoder == EarningVC.classForCoder() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                navigationVC.popToViewController(vc, animated: true)
                            }
                            popview = true
                        }
                    }
                    if !popview {
                        navigationVC.setNavigationBarHidden(false, animated: true)
                        navigationVC.navigationBar.isHidden = false
                        let storyboard = UIStoryboard.init(name: "Earning", bundle: nil)
                        let vc = storyboard.instantiateInitialViewController()
                        navigationVC.pushViewController(vc!, animated: true)
                    }
                    print("TXT_EARN".localizedCapitalized)
                case "TXT_HISTORY":
                    for vc in navigationVC.viewControllers {
                        if vc.classForCoder == OrderHistoryVC.classForCoder() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                navigationVC.popToViewController(vc, animated: true)
                            }
                            popview = true
                        }
                    }
                    if !popview {
                        navigationVC.setNavigationBarHidden(false, animated: true)
                        navigationVC.navigationBar.isHidden = false
                        let storyboard = UIStoryboard.init(name: "History", bundle: nil)
                        let vc = storyboard.instantiateInitialViewController()
                        navigationVC.pushViewController(vc!, animated: true)
                    }
                    print("TXT_HISTORY".localizedCapitalized)
                case "TXT_ACCOUNT":
                    for vc in navigationVC.viewControllers {
                        if vc.classForCoder == UserVC.classForCoder() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                navigationVC.popToViewController(vc, animated: true)
                            }
                            popview = true
                        }
                    }
                    if !popview {
                        navigationVC.setNavigationBarHidden(false, animated: true)
                        navigationVC.navigationBar.isHidden = false
                        self.setNavigationTitle(title: "TXT_ACCOUNT".localized)
                        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
                        let vc = storyboard.instantiateInitialViewController()
                        navigationVC.pushViewController(vc!, animated: true)
                    }
                    print("TXT_ACCOUNT".localizedCapitalized)
                    
                default:
                    print("")
                }
            }
        }
    }
}

class MenuCell: CustomTableCell {
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var ImageForMenu : UIImageView!
    
    var selectedRow = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = FontHelper.textMedium()
        lblName.textColor = UIColor.themeTextColor
        ImageForMenu.contentMode = .scaleAspectFit
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
    }
    
    func setData(_ name : String , _ imageName : String ,_ current : Int,_ selected : Int) {
        lblName.text = name.localizedCapitalized
        if current == selected {
            ImageForMenu?.image = UIImage.init(named: imageName)?.imageWithColor()
            lblName.textColor = UIColor.themeColor
        }
        else {
            ImageForMenu?.image = UIImage.init(named: imageName)?.imageWithColor(color: .themeIconTintColor)
            lblName.textColor = UIColor.themeTextColor
        }
    }
}
