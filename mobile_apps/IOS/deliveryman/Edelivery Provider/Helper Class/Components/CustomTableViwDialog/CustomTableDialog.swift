//
//  CustomTableDialog.swift
//  edelivery
//
//  Created by Elluminati on 24/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
enum CustomCellIdentifiers {
    static let dialogForCustomTable = "dialogForCustomTable"
    static let cellForBankName = "cellForBankName"
}
class CustomTableDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    //MARK:- Outlets
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableForItems: UITableView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var height:  NSLayoutConstraint!
    //MARK:- Variables
    var arrForItemList:NSMutableArray = [];
    var cellIdentifier = CustomCellIdentifiers.cellForBankName;
    var onItemSelected : ((_ selectedItem:Any) -> Void)? = nil
    override func awakeFromNib() {
        lblTitle.font = FontHelper.textLarge()
        lblTitle.textColor = UIColor.themeTextColor
        btnClose.titleLabel?.font = FontHelper.textLarge()
        btnClose.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnClose.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        btnClose.backgroundColor = .clear
        self.backgroundColor = UIColor.themeOverlayColor
        //tableForItems.separatorStyle = .none
        tableForItems.separatorColor = .themeLightTextColor
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }
    public static func  showCustomTableDialog(withDataSource:NSMutableArray = [],cellIdentifier:String, title:String ) -> CustomTableDialog {
        let view = UINib(nibName: CustomCellIdentifiers.dialogForCustomTable, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTableDialog
        view.setShadow()
        view.tableForItems.delegate = view;
        view.tableForItems.dataSource = view;
        view.arrForItemList = withDataSource
        view.cellIdentifier = cellIdentifier
        view.lblTitle.text = title
        switch view.cellIdentifier {
        case CustomCellIdentifiers.cellForBankName:
            view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier:cellIdentifier)
            break;
        default:
            print("Invalid Cell")
        }
        
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.height.constant = view.tableForItems.contentSize.height
        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)
        return view;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let item =  arrForItemList.object(at: indexPath.row)
        if self.onItemSelected != nil {
            self.animationForHideAView(alertView) {
                self.onItemSelected!(item)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrForItemList.count > 0 {
            return arrForItemList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell:CustomCell? = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CustomCell
        if cell == nil {
            
            cell = CustomCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }
        switch cellIdentifier {
        case CustomCellIdentifiers.cellForBankName:
            cell?.setBankData(bankData: arrForItemList[indexPath.row] as! BankDetail)
            break;
        default: break
            
        }
        cell?.selectionStyle = .none
        return cell!
        
    }
    @IBAction func onClickBtnClose(_ sender: Any) {
        //self.removeFromSuperview();
        self.animationForHideAView(alertView) {
            self.removeFromSuperview();
        }
    }
}
class CustomCell: CustomTableCell {
   
    /*Cell For Bank*/
    @IBOutlet weak var lblBankName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switch self.reuseIdentifier! {
        case CustomCellIdentifiers.cellForBankName:
            self.lblBankName.font = FontHelper.textRegular()
            self.lblBankName.textColor = UIColor.themeTextColor
            break;
        default: break
            
        }
    }
   
    func setBankData(bankData:BankDetail) {
        lblBankName.text = bankData.accountNumber
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
