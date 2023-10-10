//
//  MassNotificationsVC.swift
//  Edelivery
//
//  Created by Trusha on 20/07/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import UIKit

class MassNotificationsVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
        var arrForNoti = [[String : Any]]()
        
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableView.automaticDimension
        self.hideBackButtonTitle()
        self.arrForNoti =  APPDELEGATE.fetchNotificationFromDB(entityName: CoreDataEntityName.MASS_NOTIFICATION)
        self.arrForNoti = self.arrForNoti.reversed()
        if self.arrForNoti.count <= 0{
            updateUI(isHidden:true)
        }else{
            updateUI(isHidden:false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews(){
    super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLayout() {
        tableView.tableFooterView = UIView()
    }
    
    func setLocalization() {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableView.backgroundColor = UIColor.themeViewBackgroundColor
   }
    
    func updateUI(isHidden:Bool){
        self.tableView.isHidden = isHidden
    }
        
    //MARK: TABLEVIEW DELEGATE METHODS
    
    
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrForNoti.count
        }

        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let cell:NotificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.lblMessage.text = arrForNoti[indexPath.row]["message"] as? String ?? ""
            
            let date = Date(timeIntervalSince1970: (arrForNoti[indexPath.row]["time"] as! Double / 1000.0))
       
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss a"
            print(dateFormatter.string(from: date))
            cell.lblTime.text = dateFormatter.string(from: date)

            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
            return UITableView.automaticDimension
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
           
        }
        
    }


