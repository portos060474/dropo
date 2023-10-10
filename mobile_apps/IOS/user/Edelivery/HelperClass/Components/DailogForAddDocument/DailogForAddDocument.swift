//
//  DailogForAddDocument.swift
//  Edelivery Provider
//
//  Created by Elluminati on 17/03/21.
//  Copyright © 2021 Elluminati iMac. All rights reserved.
//

import UIKit


class DailogForAddDocument: CustomDialog,UITextFieldDelegate{

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
    @IBOutlet weak var constraintForBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintForHeight: NSLayoutConstraint!
    var selectedDocument:Document? = nil
    var activeField: UITextField?
    static let  dialogNibName = "DailogForAddDocument"
    var parentView:UIViewController!
    var isPicAdded:Bool = false;
    var keyboardHeight : CGFloat = 50.0

    override func updateUIAccordingToTheme() {
        imageForCalendar.image = UIImage.init(named: "calender_white")?.imageWithColor(color: .themeImageColor)
        self.setupLocalization()
    }
    
    var onClickSubmitButton : ((_ value : Document , _ image : UIImage) -> Void)? = nil
    public static func  showCustomAddDocumentDialog(title:String,DocIDShow : Bool,DocDateShow : Bool,DocImage : Bool,
                                                    titleRightButton:String, viewController : UIViewController , selecteddocument : Document ,
                                                    tag:Int = 416) -> DailogForAddDocument
    {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DailogForAddDocument
        view.tag = tag
        view.parentView = viewController
        view.setupLocalization()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.txtDocId.text = ""
        view.txtExpDate.text = ""
        view.imgDocument.image = UIImage.init(named:"document_placeholder")
        view.selectedDocument = selecteddocument
        if (selecteddocument.documentDetails.isMandatory)! {
        let attributes = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.font) : FontHelper.textLarge(),
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.themeTextColor
            ] as [String : Any]
            let title1 = NSMutableAttributedString(string: title.uppercased() , attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        let subTitle = NSMutableAttributedString(string: " *", attributes: convertToOptionalNSAttributedStringKeyDictionary([
            convertFromNSAttributedStringKey(NSAttributedString.Key.font) : FontHelper.textLarge(),
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.themeRedBGColor
            ] as [String : Any]))
            title1.append(subTitle)
            view.lblDocTitle.attributedText = title1
        }
        else {
            view.lblDocTitle.text = title.uppercased()
        }
        view.viewDocId.isHidden = DocIDShow
        view.viewExpDate.isHidden = DocDateShow
        view.imgDocument.isHidden = DocImage
        view.btnSubmit.setTitle(titleRightButton, for: .normal)
        if (selecteddocument.documentDetails.isExpiredDate)! {
            if isNotNSNull(object: selecteddocument.expiredDate as AnyObject) {
                if !selecteddocument.expiredDate.isEmpty {
                    view.txtExpDate.text = Utility.stringToString(strDate: selecteddocument.expiredDate!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
                    
                }
                else {
                    selecteddocument.expiredDate = ""
                }
            }
            
        }
        if (selecteddocument.documentDetails.isUniqueCode)! {
            view.txtDocId.text = selecteddocument.uniqueCode
        }
        if !(selecteddocument.imageUrl!.isEmpty) {
            view.isPicAdded = true
            view.imgDocument.downloadedFrom(link: (selecteddocument.imageUrl ?? ""), placeHolder: "document_placeholder")
        }
        
        DispatchQueue.main.async{
            UIApplication.shared.keyWindow?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
        }
        
        view.alertView.layoutIfNeeded()
        DispatchQueue.main.async {
            view.animationBottomTOTop(view.alertView)
        }
        view.deregisterFromKeyboardNotifications()
        view.registerForKeyboardNotifications()
        return view;
    }
   
    func setupLocalization() {
        
        lblDocTitle.font = FontHelper.textMedium()
        lblDocTitle.textColor = UIColor.themeTitleColor
        lblDocId.font = FontHelper.textRegular()
        lblDocId.textColor = .themeLightTextColor
        lblExpDate.font = FontHelper.textRegular()
        lblExpDate.textColor = .themeLightTextColor
        txtExpDate.backgroundColor = .themeViewBackgroundColor
        txtDocId.backgroundColor = .themeViewBackgroundColor
        imageForCalendar.image = UIImage.init(named: "calender_white")?.imageWithColor(color: .themeImageColor)
        lblDocId.text = "TXT_ENTER_ID_NUMBER".localized
        txtExpDate.placeholder = ""
        lblExpDate.text = "TXT_ENTER_EXP_DATE".localized
        txtDocId.placeholder = ""
        btnCancel.setTitle("", for: .normal)
        btnCancel.tintColor = .themeImageColor
        btnCancel.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnCancel.tintColor = .themeColor
        btnCancel.setImage(UIImage.init(named: "cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        imgDocument.setRound(withBorderColor: UIColor.white, andCornerRadious: 3.0, borderWidth: 1.0)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgDocument.isUserInteractionEnabled = true
        imgDocument.addGestureRecognizer(tapGestureRecognizer)
        txtExpDate.font = FontHelper.textRegular()
        txtDocId.font = FontHelper.textRegular()
        txtDocId.delegate = self
        txtExpDate.delegate = self
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.backgroundColor = UIColor.themeOverlayColor
        self.txtDocId.tintColor = UIColor.themeTitleColor
    }
   
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtExpDate == textField {
            self.endEditing(true)
            activeField = nil
            openDatePicker()
            return false
        }else {
            activeField = textField
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func openImageDialog(){
        let dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: parentView, isFrom: false)
        dialogForImage.onImageSelected = { [unowned self, weak dialogForImage ]
            (image:UIImage) in
            
            self.imgDocument.image = image
            self.isPicAdded = true
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.endEditing(true)
        self.openImageDialog()
    }
    func openDatePicker(){
        
        let datePickerDialog: CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_EXPIRY_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        datePickerDialog.setMinDate(mindate: Date())
        let maxDate:Date =  Calendar.current.date(byAdding: .year, value: 100, to: Date()) ?? Date.init()
        datePickerDialog.setMaxDate(maxdate: maxDate)
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
            UIView.animate(withDuration: 0.5) {
                self.constraintForBottom.constant = 0.0
            }
        }
        datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self] (selectedDate:Date) in
                let currentDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_FORMAT)
                self.selectedDocument?.expiredDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
                self.txtExpDate.text = currentDate
            UIView.animate(withDuration: 0.5) {
                self.constraintForBottom.constant = 0.0
            }
            self.endEditing(true)
          self.layoutIfNeeded()
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
       
        if self.checkDocumentValidation() {
            if !viewDocId.isHidden {
                selectedDocument?.uniqueCode = txtDocId.text
            }
            if onClickSubmitButton != nil {
                if self.onClickSubmitButton != nil {
                    self.animationForHideView(alertView) {
                        self.onClickSubmitButton!(self.selectedDocument! ,self.imgDocument.image!)
                        self.removeFromSuperview();
                    }
                }
            }
        }
    }
    
    @IBAction func onClickBtnCancel(_ sender: Any) {
        
        self.animationForHideView(alertView) {
            self.removeFromSuperview();
        }
    }
    // MARK: - Keyboard methods
           
    @objc override func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField
        {
            let globalPoint = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
            
            if (aRect.contains(activeField!.frame.origin))
            {
                self.constraintForBottom.constant = 0.0
                UIView.animate(withDuration: 0.5) {
                    DispatchQueue.main.async {
                        self.constraintForBottom.constant = keyboardSize!.height
                    }
                }
            }
        }
    }


    @objc override func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        var _ : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        
        UIView.animate(withDuration: 0.5) {
            self.constraintForBottom.constant = 0.0
        }
        self.endEditing(true)
        self.layoutIfNeeded()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
