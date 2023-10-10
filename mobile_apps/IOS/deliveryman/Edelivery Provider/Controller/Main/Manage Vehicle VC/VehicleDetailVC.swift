//
//  VehicleDetailVC.swift
//  edelivery
//
//  Created by Elluminati on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class VehicleDetailVC: BaseVC,RightDelegate {

    let downArrow:String = "\u{25BC}"
    let whitedownArrow: String = "\u{25BD}"
    
//MARK: OutLets
    
    @IBOutlet weak var viewForVehicleDetail: UIView!
    @IBOutlet weak var txtVehicleName: UITextField!
    @IBOutlet weak var txtVehicleModel: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    @IBOutlet weak var txtPlacteNumber: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var btnDropDownYear: UIButton!
    @IBOutlet weak var tblVehicleDocument: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pickYear: UIPickerView!

    /*doc Dialog*/
    @IBOutlet weak var btnSubmitDocument: UIButton!
    @IBOutlet var dialogForDocument: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var stkForDoc: UIStackView!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtDocId: UITextField!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocTitle: UILabel!
 
    /*Year picker*/
    @IBOutlet weak var pickerOverview: UIView!
    @IBOutlet weak var dialogForPicker: UIView!
    @IBOutlet weak var lblPickerTitle: UILabel!
    @IBOutlet weak var btnCancelPicker: UIButton!
    @IBOutlet weak var btnSelectPicker: UIButton!
    @IBOutlet weak var lblUploadDocument: UILabel!
    @IBOutlet weak var lblMandatoryFields: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var viewForDoc: UIView!
    @IBOutlet weak var viewForDocument: UIView!
    @IBOutlet weak var lblDocId: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var viewExpDate: UIView!
    @IBOutlet weak var viewDocId: UIView!
    @IBOutlet weak var imageForCalendar: UIImageView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var DocumentViewHeight: NSLayoutConstraint!
    
//MARK: Variables
    
    var selectedYear:String = ""
    var selectedVehicle:Vehicle? = nil
    var isVehicleRegister = false
    var arrForVehicleDocuments:NSMutableArray = []
    var arrForYearPicker:[String] = []
    var documentListLength:Int = 0
    var selectedDocument:Document? = nil
    var selectedIndex = 0;
    var isPicAdded:Bool = false;
    var dialogForImage:CustomPhotoDialog? = nil;
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var alertView: UIView!
    var vehicle : vehicleFunction?
    var isForAddVehicle:Bool = false
    
//MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateRight = self
        let date = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: date)
        for i in 0...20 {
            arrForYearPicker.append(String(currentYear - i))
        }
        setLocalization()
        tableViewHeight.constant = 0
        DocumentViewHeight.constant = 0
        alertView.isHidden = true
        if (selectedVehicle != nil) {
            setVehicleData()
            enableTextFields(enable: false)
            self.view.isUserInteractionEnabled = true
            btnDone.isUserInteractionEnabled = true
        }else {
            enableTextFields(enable: true)
            btnDone.tag = 2
            viewForDoc.isHidden = false
            lblUploadDocument.isHidden = true
            tblVehicleDocument.isHidden = true
            lblMandatoryFields.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (selectedVehicle == nil) {
            tableViewHeight.constant = 0
            DocumentViewHeight.constant = 0
            self.setConstraintForTableview()
        }
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
        setupLayout()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
    }
    
    //this function use for animation and Constraint
    func setConstraintForTableview() {
        if ((self.alertView.frame.size.height)  >= (UIScreen.main.bounds.height) || (tblVehicleDocument.contentSize.height + 105 + 260 + 70)  >= (UIScreen.main.bounds.height)) && selectedVehicle != nil{
            let tblheight =  (UIScreen.main.bounds.height) - ( 60 + 200 + 90 + 70  + 100)
            tableViewHeight.constant = (tblheight)
            DocumentViewHeight.constant = 105 + tableViewHeight.constant
            self.alertView.layoutIfNeeded()
            if !self.isVehicleRegister {
                self.view.animationBottomTOTop(self.alertView)
            }
        }
        else {
            tableViewHeight.constant = tblVehicleDocument.contentSize.height
            if tblVehicleDocument.contentSize.height == 0.0 || selectedVehicle == nil {
                tableViewHeight.constant = 0
                DocumentViewHeight.constant = 10
            }
            else {
                DocumentViewHeight.constant = 100 + tblVehicleDocument.contentSize.height
            }
            self.alertView.layoutIfNeeded()
            if !self.isVehicleRegister {
                self.view.animationBottomTOTop(self.alertView)
            }
        }
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    func setupLayout(){
        dialogForDocument.frame = view.bounds
        pickerOverview.frame = view.bounds
        tblVehicleDocument.tableFooterView = UIView.init()
        self.view.backgroundColor = UIColor.themeOverlayColor
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }
    
    func  setLocalization() {
        self.setRightBarItem(isNative: false)
        self.setNavigationTitle(title: "TXT_VEHICLE_DETAIL".localizedCapitalized)
        txtVehicleModel.placeholder = "TXT_VEHICLE_MODEL".localizedCapitalized
        txtVehicleName.placeholder = "TXT_VEHICLE_NAME".localizedCapitalized
        txtColor.placeholder = "TXT_VEHICLE_COLOR".localizedCapitalized
        txtYear.placeholder = "TXT_VEHICLE_REGISTER_YEAR".localizedCapitalized
        txtPlacteNumber.placeholder = "TXT_VEHICLE_PLATE_NUMBER".localizedCapitalized
        btnDone.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnDone.backgroundColor = UIColor.themeButtonBackgroundColor
        txtVehicleModel.font = FontHelper.textRegular()
        txtVehicleName.font = FontHelper.textRegular()
        txtColor.font = FontHelper.textRegular()
        txtYear.font = FontHelper.textRegular()
        txtPlacteNumber.font = FontHelper.textRegular()
        txtVehicleModel.textColor = UIColor.themeTextColor
        txtVehicleName.textColor = UIColor.themeTextColor
        txtColor.textColor = UIColor.themeTextColor
        txtYear.textColor = UIColor.themeTextColor
        txtPlacteNumber.textColor = UIColor.themeTextColor
        lblUploadDocument.text = "TXT_UPLOAD_ALL_DOCUMENT".localizedCapitalized
        lblMandatoryFields.text = "TXT_MANDATORY_FIELDS".localized
        lblMandatoryFields.textColor = UIColor.themeRedColor
        lblMandatoryFields.font = FontHelper.textRegular()
        pickerOverview.isHidden = true
        tblVehicleDocument.isHidden = true
        btnSubmitDocument.setTitle("TXT_SUBMIT".localizedUppercase, for: UIControl.State.normal)
        btnCancel.titleLabel?.font = FontHelper.textRegular(size: 14)
        btnCancel.setTitle("", for: .normal)
        btnSubmitDocument.setTitle("TXT_SUBMIT".localizedUppercase, for: .normal)
        btnCancel.setTitleColor(UIColor.themeIconTintColor, for: UIControl.State.normal)
        btnCancel.tintColor = .themeColor
        btnCancel.setImage(UIImage.init(named: "cancel_icon")?.imageWithColor(), for: .normal)
        txtExpDate.font = FontHelper.textRegular()
        txtDocId.font = FontHelper.textRegular()
        lblDocTitle.font = FontHelper.textLarge()
        
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        view.addSubview(dialogForDocument)
        dialogForDocument.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgDocument.isUserInteractionEnabled = true
        imgDocument.addGestureRecognizer(tapGestureRecognizer)
        
        /*Picker View */
        pickerOverview.backgroundColor = UIColor.themeOverlayColor
        dialogForPicker.backgroundColor = UIColor.themeAlertViewBackgroundColor
        lblPickerTitle.textColor = UIColor.themeTextColor
        lblPickerTitle.font = FontHelper.textLarge()
        lblPickerTitle.text = "TXT_SELECT_REGISTRATION_YEAR".localizedCapitalized
        btnCancelPicker.setTitle("", for: .normal)
        btnSelectPicker.setTitle("TXT_SELECT".localizedUppercase, for: .normal)
        btnCancelPicker.tintColor = .themeColor
        btnCancelPicker.setImage(UIImage.init(named: "cancel_icon")?.imageWithColor(), for: .normal)
        btnCancelPicker.setTitleColor(UIColor.themeIconTintColor, for: UIControl.State.normal)
        
        //dialogForPicker.setShadow()
        dialogForPicker.updateConstraints()
        dialogForPicker.roundCorner(corners: [.topLeft , .topRight], withRadius: 20)
        pickYear.reloadAllComponents()
        btnDropDownYear.setTitleColor(.themeTextColor, for: .normal)
        btnDropDownYear.tintColor = .themeTextColor
        btnDropDownYear.setTitle("", for: .normal)
        btnDropDownYear.setImage(UIImage.init(named: "dropdown")?.imageWithColor(color: .themeTextColor), for: .normal)
        
        if isForAddVehicle{
            lblTitle.text = "TXT_ADD_VEHICLE_DETAIL".localizedCapitalized
            btnDone.setTitle("TXT_SAVE".localizedUppercase, for: UIControl.State.normal)
        }else{
            lblTitle.text = "TXT_VEHICLE_DETAIL".localizedCapitalized
            btnDone.setTitle("TXT_DONE".localizedUppercase, for: UIControl.State.normal)
        }
        
        lblTitle.font = FontHelper.textLarge()
        lblTitle.textColor = UIColor.themeTitleColor
        self.view.backgroundColor = UIColor.themeOverlayColor
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.viewForDocument.updateConstraints()
        self.viewForDocument.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.viewForDocument.backgroundColor = .themeAlertViewBackgroundColor
        btnClose.setTitleColor(UIColor.themeIconTintColor, for: .normal)
        btnClose.tintColor = UIColor.themeColor
        btnClose.setTitle("", for: .normal)
        btnClose.setImage(UIImage.init(named: "cancel_icon")?.imageWithColor(), for: .normal)
        lblDocId.font = FontHelper.textRegular()
        lblDocId.textColor = .themeLightTextColor
        lblExpDate.font = FontHelper.textRegular()
        lblExpDate.textColor = .themeLightTextColor
        imageForCalendar.image = UIImage.init(named: "calender_white")?.imageWithColor(color: .themeIconTintColor)
        tblVehicleDocument.separatorStyle = .none
    }

    //MARK: - Other Methods
    func updateUI(isUpdate:Bool = false) {
        tblVehicleDocument.isHidden = !isUpdate
        lblUploadDocument.isHidden = !isUpdate
        viewForDoc.isHidden = false
        tblVehicleDocument.isHidden = !isUpdate
        lblMandatoryFields.isHidden = !isUpdate
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.openImageDialog()
    }

    //MARK: - Action Methods
    @IBAction func onClickDropDownYear(_ sender: Any) {
        selectedYear = arrForYearPicker[0]
        pickerOverview.isHidden = false
    }

    @IBAction func onClickBtnDone(_ sender: Any) {
        if btnDone.tag == 3 {
            self.enableTextFields(enable: true)
            btnDone.tag = 2
            btnDone.setTitle("TXT_DONE".localizedUppercase, for: .normal)
        } else if btnDone.tag == 2 {
            if txtVehicleModel.isEnabled {
                if (checkValidation()) {
                    if (selectedVehicle?.vehicleName.isEmpty) ?? true {
                        wsAddVehicleDetail()
                    }else {
                        wsUpdateVehicleDetail()
                    }
                }
            }
        }
    }

    func onClickRightButton() {
        if txtVehicleModel.isEnabled {
            if (checkValidation()) {
                if (selectedVehicle?.vehicleName.isEmpty) ?? true {
                    wsAddVehicleDetail()
                }else {
                    wsUpdateVehicleDetail()
                }
            }
        } else {
            self.enableTextFields(enable: true)
            self.setRightBarItemImage(image: UIImage.init(named: "doneBlackIcon")!)
        }
    }

    @IBAction func onClickBtnClose(_ sender: Any) {
        self.vehicle?.getVehicle()
        self.view.backgroundColor = .clear
        self.dismiss(animated: true) {
        }
    }

    func enableTextFields(enable:Bool) -> Void {
        self.view.isUserInteractionEnabled = enable
        self.txtVehicleName.isEnabled = enable
        self.txtVehicleModel.isEnabled = enable
        self.txtPlacteNumber.isEnabled = enable
        self.txtColor.isEnabled = enable
        self.txtYear.isEnabled = enable
        self.tblVehicleDocument.isUserInteractionEnabled = enable
        self.btnDropDownYear.isUserInteractionEnabled = enable
    }

    @IBAction func onClickBtnSubmit(_ sender: Any) {
        selectedDocument?.uniqueCode = txtDocId.text
        wsUploadDocuments(selectedDoc:selectedDocument!)
    }

    @IBAction func onClickBtnCancel(_ sender: Any) {
        closeDocumentUploadDialog()
    }

    //MARK: - User Define Methods
    func checkValidation() -> Bool {

        if ((txtVehicleModel.text?.isEmpty())! ||
            (txtColor.text?.isEmpty())! ||
            (txtPlacteNumber.text?.isEmpty())! ||
            (txtVehicleName.text?.isEmpty())! ||
            (txtYear.text?.isEmpty())! ) {
            
            if (txtVehicleName.text?.isEmpty())! {
                  txtVehicleName.becomeFirstResponder();
                Utility.showToast(message: "MSG_PLEASE_ENTER_VEHICLE_NAME".localized)
            } else if (txtVehicleModel.text?.isEmpty())! {
                txtVehicleModel.becomeFirstResponder();
                Utility.showToast(message: "MSG_PLEASE_ENTER_VEHICLE_MODEL".localized)
            } else if (txtPlacteNumber.text?.isEmpty())! {
                txtPlacteNumber.becomeFirstResponder()
                Utility.showToast(message: "MSG_PLEASE_ENTER_VEHICLE_PLATE_NUMBER".localized)
            } else if (txtColor.text?.isEmpty())! {
                txtColor.becomeFirstResponder()
                Utility.showToast(message: "MSG_PLEASE_ENTER_VEHICLE_COLOR".localized)
            } else if (txtYear.text?.isEmpty())! {
                txtYear.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_VEHICLE_YEAR".localized)
            }
            return false;
        } else {
            for obj in arrForVehicleDocuments {
                if let obj = obj as? Document {
                    if obj.imageUrl.count > 0 || !obj.documentDetails.isMandatory {
                        continue
                    } else {
                        Utility.showToast(message:"TXT_PLEASE_UPLOAD_ALL_REQUIRED_DICUMENTS".localized)
                        return false
                    }
                }
            }
            return true
        }
    }

    //MARK: - Web Service Call
    func wsAddVehicleDetail() {

        Utility.showLoading()

        let dictParam : [String : Any] = [
        PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
        PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
        PARAMS.VEHICLE_YEAR: txtYear.text ?? "",
        PARAMS.VEHICLE_NAME: txtVehicleName.text ?? "",
        PARAMS.VEHICLE_PLATE_NO: txtPlacteNumber.text ?? "",
        PARAMS.VEHICLE_COLOR: txtColor.text ?? "",
        PARAMS.VEHICLE_MODEL: txtVehicleModel.text ?? ""
        ]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
     
        alamoFire.getResponseFromURL(url: WebService.WS_ADD_VEHICLE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
        
                if Parser.isSuccess(response: response) {
                    self.selectedVehicle = Vehicle.init(fromDictionary: response["provider_vehicle"] as! [String : Any])
                    self.isVehicleRegister = true
                  self.wsGetDocumentList()
                }
                Utility.hideLoading()
        }
    }
    
    func wsUpdateVehicleDetail() {
        let dictParam : [String : Any] = [
            PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
            PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
            PARAMS.VEHICLE_ID : self.selectedVehicle?.id ?? "",
            PARAMS.VEHICLE_YEAR: txtYear.text ?? "",
            PARAMS.VEHICLE_NAME: txtVehicleName.text ?? "",
            PARAMS.VEHICLE_PLATE_NO: txtPlacteNumber.text ?? "",
            PARAMS.VEHICLE_COLOR: txtColor.text ?? "",
            PARAMS.VEHICLE_MODEL: txtVehicleModel.text ?? ""
        ]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.WS_UPDATE_VEHICLE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            if Parser.isSuccess(response: response) {
                self.vehicle?.getVehicle()
                self.view.backgroundColor = .clear
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    //MARK:- WEB SERVICE CALLS
    func wsGetDocumentList(){
        let dictParam: Dictionary<String,Any> =
            [PARAMS.ID:selectedVehicle?.id ?? "",
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.TYPE:CONSTANT.TYPE_PROVIDER_VEHICLE]
        
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_GET_DOCUMENT_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(respons, error) -> (Void) in
            Parser.parseVehicleDocumentList(response: respons, toArray: self.arrForVehicleDocuments, completion: { (result) in
                if result {
                    DispatchQueue.main.async
                    {
                        self.documentListLength = self.arrForVehicleDocuments.count
                        self.tblVehicleDocument.reloadData()
                        self.setConstraintForTableview()
                        self.updateUI(isUpdate:true)
                    }
                }else {
                    self.updateUI(isUpdate:false)
                    self.tblVehicleDocument.reloadData()
                    self.setConstraintForTableview()
                }
            })
        }
    }
    
    func wsUploadDocuments(selectedDoc:Document){
        
        if(checkDocumentValidation()) {
            let docDetail:DocumentDetail = selectedDoc.documentDetails
            var dictParam: Dictionary<String,Any> =
                [PARAMS.ID:self.selectedVehicle?.id ?? "",
                 PARAMS.SERVER_TOKEN:"",
                 PARAMS.TYPE:CONSTANT.TYPE_PROVIDER_VEHICLE,
                 PARAMS.DOCUMENT_ID:selectedDoc.id!,
                 PARAMS.USER_TYPE_ID:preferenceHelper.getUserId(),
                 ]
            
            if docDetail.isUniqueCode! {
                dictParam.updateValue(selectedDoc.uniqueCode!, forKey: PARAMS.UNIQUE_CODE);
                
            }
            if docDetail.isExpiredDate! {
                dictParam.updateValue(selectedDoc.expiredDate!, forKey: PARAMS.EXPIRED_DATE);
            }
            
            
            Utility.showLoading()
            let alamoFire:AlamofireHelper = AlamofireHelper.init();
            alamoFire.getResponseFromURL(url: WebService.WS_UPLOAD_DOCUMENT, paramData: dictParam, image: imgDocument.image!, block: { (response, error) -> (Void) in
                
                if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                    let documentResponse:UploadDocumentResponse = UploadDocumentResponse.init(fromDictionary: response)
                    preferenceHelper.setIsAllVehicleDocumentUploaded(documentResponse.isDocumentUploaded!)
                    self.selectedDocument?.imageUrl = documentResponse.imageUrl
                    self.selectedDocument?.expiredDate = documentResponse.expiredDate
                    self.selectedDocument?.uniqueCode = documentResponse.uniqueCode
                    self.arrForVehicleDocuments.replaceObject(at: self.selectedIndex, with: self.selectedDocument!)
                    DispatchQueue.main.async
                    {
                        self.tblVehicleDocument.reloadData()
                        self.closeDocumentUploadDialog()
                    }
                }
                Utility.hideLoading()
            })
        }
    }
    
    func checkDocumentValidation() -> Bool{
        
        let docDetail:DocumentDetail = (selectedDocument?.documentDetails)!
        if ((txtDocId.text?.isEmpty)! && (docDetail.isUniqueCode)!) {
            Utility.showToast(message:"MSG_PLEASE_ENTER_DOCUMENT_ID".localized)
            return false
        }else if ((txtExpDate.text?.isEmpty)! && (docDetail.isExpiredDate)!) {
            Utility.showToast(message:"MSG_PLEASE_ENTER_DOCUMENT_EXP_DATE".localized)
            return false
        }else if !isPicAdded {
            Utility.showToast(message:"MSG_PLEASE_SELECT_DOCUMENT_IMAGE".localized)
            return false
        }else {
            return true
        }
    }
    
    func openDocumentUploadDialog(selectedDoc:Document) {
        
        let docDetail:DocumentDetail = selectedDoc.documentDetails
        dialogForDocument.frame = self.view.frame
        dialogForDocument.isHidden = false
        lblDocTitle.text = ""
        txtDocId.text = ""
        txtExpDate.text = ""
        txtDocId.placeholder = ""
        txtExpDate.placeholder = ""
        lblDocId.text = "TXT_ENTER_ID_NUMBER".localized
        lblExpDate.text = "TXT_ENTER_EXP_DATE".localized
        txtDocId.isHidden = false
        txtExpDate.isHidden = false
        self.stkForDoc.isHidden = false
        viewExpDate.isHidden = false
        viewDocId.isHidden = false
        lblDocTitle.text = docDetail.documentName!.capitalized
        if((selectedDoc.imageUrl!.isEmpty)) {
            
            imgDocument.image = UIImage.init(named:"document_placeholder")
            
            if (docDetail.isExpiredDate)! {
                txtExpDate.text = ""
            }else {
                txtExpDate.isHidden = true
                viewExpDate.isHidden = true
            }
            if (docDetail.isUniqueCode)! {
                txtDocId.text = ""
            }else {
                txtDocId.isHidden = true
                viewDocId.isHidden = true
            }
            if(txtExpDate.isHidden && txtDocId.isHidden) {
                self.stkForDoc.isHidden = true
            }
        }else {
            imgDocument.downloadedFrom(link: (selectedDocument?.imageUrl)!, placeHolder: "document_placeholder")
            
            if (docDetail.isExpiredDate)! {
                txtExpDate.text = Utility.stringToString(strDate: selectedDoc.expiredDate!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
            }else {
                txtExpDate.isHidden = true
                viewExpDate.isHidden = true
            }
            if (docDetail.isUniqueCode)! {
                txtDocId.text = selectedDoc.uniqueCode
            }else {
                txtDocId.isHidden = true
                viewDocId.isHidden = true
            }
            if(txtExpDate.isHidden && txtDocId.isHidden) {
                self.stkForDoc.isHidden = true
            }
        }
        
        if (docDetail.isMandatory)! {
            lblDocTitle.text?.append("*")
        }
        imgDocument.setRound(withBorderColor: UIColor.white, andCornerRadious: 3.0, borderWidth: 1.0)
    }
    
    func closeDocumentUploadDialog(){
        dialogForDocument.isHidden = true
        lblDocTitle.text = ""
        txtDocId.text = ""
        txtExpDate.text = ""
    }
    
    func openImageDialog(){
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
        dialogForImage?.onImageSelected = { 
            (image:UIImage) in
            self.imgDocument.image = image
            self.isPicAdded = true
        }
    }
    
    func openDatePicker(){
        self.view.endEditing(true)
        let datePickerDialog: CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        let maxDate:Date =  Calendar.current.date(byAdding: .year, value: 100, to: Date()) ?? Date.init()
        datePickerDialog.setMaxDate(maxdate: maxDate)
        datePickerDialog.setMinDate(mindate: Date())
        
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
    
    func setVehicleData() {
        self.txtVehicleModel.text = selectedVehicle?.vehicleModel
        self.txtVehicleName.text = selectedVehicle?.vehicleName
        self.txtColor.text = selectedVehicle?.vehicleColor
        self.txtPlacteNumber.text = selectedVehicle?.vehiclePlateNo
        self.txtYear.text = String((selectedVehicle?.vehicleYear) ?? 0)
        btnDone.setTitle("TXT_EDIT".localizedUppercase, for: .normal)
        btnDone.tag = 3
       wsGetDocumentList()
        
    }
    @IBAction func onClickBtnCancelPicker(_ sender: Any) {
       pickerOverview.isHidden = true
    }
    @IBAction func onClickBtnSelectPicker(_ sender: Any) {
       self.txtYear.text = selectedYear
       pickerOverview.isHidden = true
    }
}
extension VehicleDetailVC:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtExpDate == textField {
            openDatePicker()
            return false
        }
        if txtYear == textField {
            selectedYear = arrForYearPicker[0]
            pickerOverview.isHidden = false
            return false
        }else {
            pickerOverview.isHidden = true
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        return true;
    }
}

extension VehicleDetailVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentListLength;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:VehicleDocumentCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! VehicleDocumentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentdocument:Document = arrForVehicleDocuments[indexPath.row] as! Document
        cell.setCellData(cellItem: currentdocument)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 130;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedDocument = arrForVehicleDocuments[indexPath.row] as? Document;
        selectedIndex = indexPath.row
        self.openDocumentUploadDialog(selectedDoc:selectedDocument!)
    }
}

extension VehicleDetailVC:UIPickerViewDelegate,UIPickerViewDataSource {
   
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrForYearPicker.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrForYearPicker[row]
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = arrForYearPicker[row]
    }
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel { label = view }else { label = UILabel() }
        label.textColor = UIColor.themeTextColor
        label.textAlignment = .center
        label.font = FontHelper.textRegular(size: FontHelper.large)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = arrForYearPicker[row]
        return label
    }
}

class VehicleDocumentCell: CustomTableCell {
  
    //MARK:- OUTLET
    @IBOutlet weak var stkDocID: UIStackView!
    @IBOutlet weak var stkExpDate: UIStackView!
    @IBOutlet weak var lblDocumentName: UILabel!
    @IBOutlet weak var lblIDNumber: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var lblIDNumberValue: UILabel!
    @IBOutlet weak var lblExpDateValue: UILabel!
    @IBOutlet weak var imgDocument: UIImageView!
   
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
       
        super.awakeFromNib()
        imgDocument.setRound(withBorderColor: UIColor.white, andCornerRadious: 3)
       
        //LOCALIZED
        lblIDNumber.text = "TXT_ID_NUMBER".localized
        lblExpDate.text = "TXT_EXP_DATE".localized
        
        //COLORS
        lblDocumentName.textColor = UIColor.themeTextColor
        lblIDNumberValue.textColor = UIColor.themeTextColor
        lblExpDateValue.textColor = UIColor.themeTextColor
        lblIDNumber.textColor = UIColor.themeLightTextColor
        lblExpDate.textColor = UIColor.themeLightTextColor
       
        //Font
        lblDocumentName.font = FontHelper.textRegular()
        lblIDNumberValue.font = FontHelper.textRegular()
        lblExpDateValue.font = FontHelper.textRegular()
        lblIDNumber.font = FontHelper.textRegular()
        lblExpDate.font = FontHelper.textRegular()
        
        //Make View Hidden
        stkDocID.isHidden = true
        lblIDNumber .isHidden = true
        lblIDNumberValue.isHidden = true
        stkExpDate.isHidden = true
        lblExpDateValue.isHidden = true
        lblExpDate.isHidden = true
    }
    //MARK:- SET CELL DATA
    func setCellData(cellItem:Document) {imgDocument.setRound(withBorderColor: UIColor.white, andCornerRadious: 3.0, borderWidth: 1.0)
     
        let docDetail:DocumentDetail = cellItem.documentDetails
        lblDocumentName.text = docDetail.documentName!.uppercased()
        if((cellItem.imageUrl!.isEmpty)) {
            if (docDetail.isExpiredDate)! {
                lblExpDateValue.text = ""
                stkExpDate.isHidden = false
                lblExpDateValue.isHidden = false
                lblExpDate.isHidden = false
            }else {
                stkExpDate.isHidden = true
                lblExpDateValue.isHidden = true
                lblExpDate.isHidden = true
            }
            if (docDetail.isUniqueCode)! {
                lblIDNumberValue.text = ""
                
                stkDocID.isHidden = false
                lblIDNumber .isHidden = false
                lblIDNumberValue.isHidden = false
            }else {
                stkDocID.isHidden = true
                lblIDNumber .isHidden = true
                lblIDNumberValue.isHidden = true
            }
            
        }else {
            imgDocument.downloadedFrom(link: cellItem.imageUrl!, placeHolder: "document_placeholder")
            
            if (docDetail.isExpiredDate)! {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DATE_CONSTANT.DATE_TIME_FORMAT_WEB
                let currentDate = dateFormatter.date(from: cellItem.expiredDate!)
                dateFormatter.dateFormat = DATE_CONSTANT.DATE_FORMAT
                lblExpDateValue.text = dateFormatter.string(from: currentDate!)
                stkExpDate.isHidden = false
                lblExpDateValue.isHidden = false
                lblExpDate.isHidden = false
            }else {
                stkExpDate.isHidden = true
                lblExpDateValue.isHidden = true
                lblExpDate.isHidden = true
            }
            if (docDetail.isUniqueCode)! {
                lblIDNumberValue.text = String(cellItem.uniqueCode!)
                stkDocID.isHidden = false
                lblIDNumber .isHidden = false
                lblIDNumberValue.isHidden = false
            }else {
                stkDocID.isHidden = true
                lblIDNumber .isHidden = true
                lblIDNumberValue.isHidden = true
            }
        }
        
        if (docDetail.isMandatory)! {
            lblDocumentName.text = ""
            let attributes = [
                convertFromNSAttributedStringKey(NSAttributedString.Key.font) : FontHelper.textRegular(),
                convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.themeTextColor
                ] as [String : Any]
            let title = NSMutableAttributedString(string: docDetail.documentName!.uppercased() , attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
            let subTitle = NSMutableAttributedString(string: " *", attributes: convertToOptionalNSAttributedStringKeyDictionary([
                convertFromNSAttributedStringKey(NSAttributedString.Key.font) : FontHelper.textRegular(),
                convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.themeRedColor
                ] as [String : Any]))
            title.append(subTitle)
            lblDocumentName.attributedText = title
            
        }
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

protocol vehicleFunction {
    func getVehicle()
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
