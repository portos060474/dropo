//
//  ReciverCell.swift
//  Qatch Driver
//
//  Created by Sakir Sherasiya on 03/05/18.
//  Copyright © 2018 Elluminati Mini Mac 5. All rights reserved.
//

import UIKit

class ReciverCell: UITableViewCell {

    @IBOutlet var viewForMessage: UIView!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblTime: UILabel!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Userapp
//        lblMessage.font = FontHelper.font(size: FontSize.regular, type: .Regular)
//        lblTime.font = FontHelper.font(size: FontSize.small, type: .Regular)
//        viewForMessage.backgroundColor = UIColor.themeReceiverBGColor
        lblTime.textColor = UIColor.themeLightTextColor
        lblMessage.textColor = UIColor.black
        viewForMessage.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellData(dict:FirebaseMessage)
    {
        lblMessage.text = dict.message
        lblTime.text = Utility.stringToString(strDate: dict.time, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.MESSAGE_FORMAT)
        viewForMessage.layer.cornerRadius = 15.0
        viewForMessage.clipsToBounds = true
    }
    
}
