//
//  AddDocumentVC.swift
//  Store
//
//  Created by Trusha on 01/04/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit


class AddDocumentVC: BaseVC,UITextFieldDelegate {
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtDocId: UITextField!
    @IBOutlet weak var lblDocId: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var viewExpDate: UIView!
    @IBOutlet weak var viewDocId: UIView!
    @IBOutlet weak var imageForCalendar: UIImageView!

    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocTitle: UILabel!
    var selectedDocument:Document? = nil
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
//    static let  dialogNibName = "DailogForAddDocument"
//    var parentView:UIViewController!
    var isPicAdded:Bool = false;
    
    var DocIDShow : Bool = false;
    var DocDateShow : Bool = false;
    var DocImage : Bool = false;
    var titleRightButton:String = ""
//    var vc = UIViewController()
    var selecteddocument = Document(fromDictionary: [:])
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.parentView = vc
        self.setupLocalization()
        
        self.txtDocId.text = ""
        self.txtExpDate.text = ""
        self.imgDocument.image = UIImage.init(named:"document_placeholder")
        self.selectedDocument = selecteddocument
        self.lblDocTitle.text = title
        self.viewDocId.isHidden = DocIDShow
        self.viewExpDate.isHidden = DocDateShow
        self.imgDocument.isHidden = DocImage
        self.btnSubmit.setTitle(titleRightButton, for: .normal)
        if (selecteddocument.documentDetails.isExpiredDate)! {
            if !selecteddocument.expiredDate.isEmpty {
                self.txtExpDate.text = Utility.stringToString(strDate: selecteddocument.expiredDate!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
            }
            else {
                selecteddocument.expiredDate = ""
            }
        }
        if (selecteddocument.documentDetails.isUniqueCode)! {
            self.txtDocId.text = selecteddocument.uniqueCode
        }
        if !(selecteddocument.imageUrl!.isEmpty) {
            self.isPicAdded = true
            self.imgDocument.downloadedFrom(link: (selecteddocument.imageUrl ?? ""), placeHolder: "document_placeholder")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func updateUIAccordingToTheme() {
        imageForCalendar.image = UIImage.init(named: "calender")?.imageWithColor(color: UIColor.themeColor)
    }
    
    public func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    func setupLocalization() {
        
        lblDocTitle.font = FontHelper.textLarge()
        lblDocTitle.textColor = UIColor.themeTitleColor
        lblDocId.font = FontHelper.textRegular()
        lblDocId.textColor = .themeLightTextColor
        
        lblExpDate.font = FontHelper.textRegular()
        lblExpDate.textColor = .themeLightTextColor
        txtExpDate.backgroundColor = .themeViewBackgroundColor
        txtDocId.backgroundColor = .themeViewBackgroundColor
        imageForCalendar.image = UIImage.init(named: "calender")?.imageWithColor(color: .themeColor)
        lblDocId.text = "TXT_ENTER_ID_NUMBER".localized
        txtExpDate.placeholder = ""
        lblExpDate.text = "TXT_ENTER_EXP_DATE".localized
        txtDocId.placeholder = ""
        
        btnCancel.tintColor = .themeColor
        btnCancel.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnCancel.setImage(UIImage.init(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
        
        
        imgDocument.setRound(withBorderColor: UIColor.white, andCornerRadious: 3.0, borderWidth: 1.0)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgDocument.isUserInteractionEnabled = true
        imgDocument.addGestureRecognizer(tapGestureRecognizer)
        txtExpDate.font = FontHelper.textRegular()
        txtDocId.font = FontHelper.textRegular()
        txtDocId.delegate = self
        txtExpDate.delegate = self
       /* (txtDocId as? CustomTextfield)?.selectedLineColor = .themeViewBackgroundColor
        (txtDocId as? CustomTextfield)?.lineColor = .themeViewBackgroundColor
        (txtExpDate as? CustomTextfield)?.selectedLineColor = .themeViewBackgroundColor
        (txtExpDate as? CustomTextfield)?.lineColor = .themeViewBackgroundColor*/
        
        alertView.backgroundColor = .purple
        self.alertView.updateConstraintsIfNeeded()
//        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.view.backgroundColor = UIColor.themeOverlayColor
    
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtExpDate == textField {
            openDatePicker()
            return false
        }else {
//            activeField = textField
            return true
        }
            
      }
    func openImageDialog(){
//        let dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
//        dialogForImage.onImageSelected = { [unowned self, weak dialogForImage ]
//            (image:UIImage) in
//
//            self.imgDocument.image = image
//            self.isPicAdded = true
//        }
        
        self.view.endEditing(true)
        let dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, isCropRequired: false)
        dialogForImage.onImageSelected = {[unowned self] (image:UIImage) in
              self.isPicAdded = true;
              self.imgDocument.image = image
            self.imgDocument.contentMode = .scaleAspectFit

        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
        self.openImageDialog()
    }
    
    func openDatePicker(){
        self.view.endEditing(true)
        let datePickerDialog: CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_EXPIRY_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        datePickerDialog.setMinDate(mindate: Date())
        let maxDate:Date =  Calendar.current.date(byAdding: .year, value: 100, to: Date()) ?? Date.init()
        datePickerDialog.setMaxDate(maxdate: maxDate)

        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
        }
        
        datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self] (selectedDate:Date) in
                let currentDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_FORMAT)
                self.selectedDocument?.expiredDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
                self.txtExpDate.text = currentDate
                datePickerDialog.removeFromSuperview()
        }
        
        
    }
    func checkDocumentValidation() -> Bool{
        

        let docDetail:DocumentDetail = (selectedDocument?.documentDetails)!
        
        
        if ((txtDocId.text?.isEmpty())! && (docDetail.isUniqueCode)!) {
            Utility.showToast(message:"MSG_PLEASE_ENTER_DOCUMENT_ID".localized)
            return false
        }else if ((txtExpDate.text?.isEmpty())! && (docDetail.isExpiredDate)!) {
            Utility.showToast(message:"MSG_PLEASE_ENTER_DOCUMENT_EXP_DATE".localized)
            return false
        }else if !isPicAdded {
            Utility.showToast(message:"MSG_PLEASE_SELECT_DOCUMENT_IMAGE".localized)
            return false
        }else {
            return true
        }
    }
    @IBAction func onClickBtnSubmit(_ sender: Any) {
        //self.endEditing(true)
        
        if self.checkDocumentValidation() {
            if !viewDocId.isHidden {
                selectedDocument?.uniqueCode = txtDocId.text
            }
//            if onClickSubmitButton != nil {
//                if self.onClickSubmitButton != nil {
//
//
//
//                    self.animationForHideAView(alertView) {
//                        self.onClickSubmitButton!(self.selectedDocument! ,self.imgDocument.image!)
//                        self.removeFromSuperview();
//                    }
//                }
//
//            }
        }
    }
    
    @IBAction func onClickBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
