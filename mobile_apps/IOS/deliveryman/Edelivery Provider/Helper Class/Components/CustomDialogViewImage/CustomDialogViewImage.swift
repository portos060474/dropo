//
//  CustomDialogViewImage.swift
//  Edelivery
//
//  Created by Elluminati on 4/16/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class CustomDialogViewImage: CustomDialog {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    static let  dialogNibName = "CustomDialogViewImage"
    var imgUrl: String = ""

    public static func  showCustomDialogViewImage(title : String ,message: String,tag:Int = 414, imgUrlToView: String) -> CustomDialogViewImage {

        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomDialogViewImage
        view.tag = tag
        view.lblTitle.text = title

        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;

        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
            view.animationBottomTOTop(view.alertView)
        }

        view.imgUrl = imgUrlToView
        view.setLocalization()
        return view;
    }

    func setLocalization() {
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.backgroundColor = UIColor.themeOverlayColor
        btnClose.setImage(UIImage(named: "close")?.imageWithColor(color: .themeColor), for: .normal)
        imgView.downloadedFrom(link: imgUrl, placeHolder: "placeholder", isIndicator: true, isAppendBaseUrl: true)
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium()
    }

    override func updateUIAccordingToTheme() {
        setLocalization()
    }

    //MARK: - Action Methods
    @IBAction func onClickBtnClose(_ sender: Any) {
        self.animationForHideAView(alertView) {
            self.removeFromSuperview()
        }
    }
}
