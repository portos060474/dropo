//
//  DailogForNote.swift
//  Edelivery Provider
//
//  Created by Elluminati on 18/03/21.
//  Copyright © 2021 Elluminati iMac. All rights reserved.
//

import UIKit

class DailogForNote: UIView {

    @IBOutlet weak var stkDialog: UIStackView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblPickupMessage: UILabel!
    @IBOutlet weak var lblDeliveryMessage: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    
    @IBOutlet weak var alertView: UIView!
    
    var onClickLeftButton : (() -> Void)? = nil
    static let  dialogNibName = "dailogForNote"
    
    public static func  showCustomAlertDialog
        (title:String,
         pickupMessage:String,deliveryMessage:String,
         tag:Int = 417
         ) ->
    DailogForNote
     {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DailogForNote
        view.tag = tag
        if ((APPDELEGATE.window?.viewWithTag(tag)) != nil) {
            APPDELEGATE.window?.bringSubviewToFront((APPDELEGATE.window?.viewWithTag(tag))!)
        }else {
            view.setLocalization()
            view.alertView.setShadow()
            let frame = (APPDELEGATE.window?.frame)!;
            view.frame = frame;
            view.lblTitle.text = title;
            view.lblPickupMessage.text = pickupMessage;
            view.lblDeliveryMessage.text = deliveryMessage
            if pickupMessage.isEmpty {
                view.lblPickup.isHidden = true
                view.lblPickupMessage.isHidden = true
            }
            if deliveryMessage.isEmpty {
                view.lblDeliveryMessage.isHidden = true
                //view.lblDelivery.isHidden = true
            }
            view.lblDelivery.isHidden = true
            
            DispatchQueue.main.async{
                UIApplication.shared.keyWindow?.addSubview(view)
                APPDELEGATE.window?.bringSubviewToFront(view);
            }
        }
        view.alertView.layoutIfNeeded()
        DispatchQueue.main.async {
            view.animationBottomTOTop(view.alertView)
        }
        return view;
    }
    func setLocalization() {
        alertView.backgroundColor = UIColor.themeAlertViewBackgroundColor
        backgroundColor = UIColor.themeOverlayColor
        lblTitle.textColor = UIColor.themeTextColor;
        lblTitle.font = FontHelper.textLarge()
        lblPickup.textColor = UIColor.themeTextColor;
        lblDelivery.textColor = .themeTextColor
        lblPickup.font = FontHelper.textRegular()
        lblDelivery.font = FontHelper.textRegular()
        lblPickupMessage.font = FontHelper.textRegular()
        lblDeliveryMessage.font = FontHelper.textRegular()
        lblPickupMessage.textColor = UIColor.themeTextColor
        lblDeliveryMessage.textColor = .themeTextColor
        lblPickup.text = "TXT_PICKUP_NOTE".localized
        lblDelivery.text = "TXT_DESTINATION_NOTE".localized
        btnLeft.tintColor = .themeColor
       
        btnLeft.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        btnLeft.backgroundColor = .clear
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.animationForHideAView(alertView) {
                self.onClickLeftButton!();
            }
        }
    }
    
}
