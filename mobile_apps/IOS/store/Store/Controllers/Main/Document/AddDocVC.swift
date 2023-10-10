//
//  AddDocVC.swift
//  Store
//
//  Created by Trusha on 02/04/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

@objc protocol OnClickSubmitDelegate: class {
    func onClickSubmitbtn(docID:String,imgDoc:UIImage)
}
class AddDocVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtDocId: UITextField!
    @IBOutlet weak var lblDocId: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var viewExpDate: UIView!
    @IBOutlet weak var viewDocId: UIView!
    @IBOutlet weak var imageForCalendar: UIImageView!

    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocTitle: UILabel!
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    var isPicAdded:Bool = false;
    
    var DocIDShow : Bool = false;
    var DocDateShow : Bool = false;
    var DocImage : Bool = false;
    var titleRightButton:String = ""
    var selectedDocument:Document? = nil
    var dialogForImage:CustomPhotoDialog?;
    var delegate:OnClickSubmitDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalization()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.animationBottomTOTop(self.alertView)
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.applyTopCornerRadius()
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
        
        self.view.backgroundColor = UIColor.themeOverlayColor
        self.txtDocId.isHidden = DocIDShow
        self.txtExpDate.isHidden = DocDateShow
        
        self.lblDocId.isHidden = DocIDShow
        self.lblExpDate.isHidden = DocDateShow
        self.imageForCalendar.isHidden = DocDateShow

        
        if (selectedDocument?.imageUrl.count)! > 0{
            imgDocument.downloadedFrom(link: (selectedDocument?.imageUrl)!, placeHolder: "document_placeholder")
            self.isPicAdded = true
        }

        if (self.selectedDocument!.documentDetails.isExpiredDate)! {
            if selectedDocument?.expiredDate.count == 0{
                txtExpDate.text = ""
            }else{
                txtExpDate.text = Utility.stringToString(strDate: (selectedDocument?.expiredDate!)!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
            }
        }else {
            txtExpDate.isHidden = true
        }
        if (selectedDocument!.documentDetails.isUniqueCode)! {
            txtDocId.text = selectedDocument?.uniqueCode
        }else {
            txtDocId.isHidden = true
        }
    }
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, isCropRequired: false)
        self.dialogForImage?.onImageSelected = {[unowned self] (image:UIImage) in
              self.isPicAdded = true;
              self.imgDocument.image = image
            self.imgDocument.contentMode = .scaleAspectFit
        }
    }
    
    @IBAction func onClickBtnAddImage(_ sender: Any) {
//        openImageDialog()
        self.view.endEditing(true)
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, isCropRequired: false)
        self.dialogForImage?.onImageSelected = {[unowned self] (image:UIImage) in
              self.isPicAdded = true;
              self.imgDocument.image = image
            self.imgDocument.contentMode = .scaleAspectFit
        }
        
}
    
    @IBAction func onClickBtnSubmit(_ sender: Any) {
        selectedDocument?.uniqueCode = txtDocId.text

        if self.checkDocumentValidation() {
            if !viewDocId.isHidden {
                self.dismiss(animated: true) {
                    self.delegate?.onClickSubmitbtn(docID: self.txtDocId.text ?? "",imgDoc: self.imgDocument.image!)
                }
            }
        }
    }
    
 
    @IBAction func onClickBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        

//        let docDetail:DocumentDetail = (selectedDocument?.documentDetails)!
        if ((txtDocId.text?.isEmpty())! && (selectedDocument?.documentDetails.isUniqueCode)!) {
            Utility.showToast(message:"MSG_PLEASE_ENTER_DOCUMENT_ID".localized)
            return false
        }else if ((txtExpDate.text?.isEmpty())! && (selectedDocument?.documentDetails.isExpiredDate)!) {
            Utility.showToast(message:"MSG_PLEASE_ENTER_DOCUMENT_EXP_DATE".localized)
            return false
        }else if !isPicAdded {
            Utility.showToast(message:"MSG_PLEASE_SELECT_DOCUMENT_IMAGE".localized)
            return false
        }else {
            return true
        }
    }
}
