//
//  DocumentVC.swift
//  edelivery
//
//  Created by tag on 07/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class DocumentVC: BaseVC,LeftDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
// MARK: - OUTLET
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lblMandatoryFields: UILabel!
    @IBOutlet weak var tblForDocumentList: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    /*doc Dialog*/
    @IBOutlet weak var btnSubmitDocument: UIButton!
    @IBOutlet var dialogForDocument: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var stkForDoc: UIStackView!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtDocId: UITextField!
    @IBOutlet weak var lblDocId: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var viewExpDate: UIView!
    @IBOutlet weak var viewDocId: UIView!
    @IBOutlet weak var imageForCalendar: UIImageView!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocTitle: UILabel!
    @IBOutlet weak var lblEmptyMsg: UILabel!
    @IBOutlet var alertView: UIView!
    
// MARK: - Variables
    var arrdocumentList:NSMutableArray = []
    var documentListLength:Int? = 0
    var selectedDocument:Document? = nil
    var selectedIndex = 0;
    var isPicAdded:Bool = false;
    var dialogForImage:CustomPhotoDialog? = nil;
    private let refreshControl = UIRefreshControl()
    
// MARK: - LifeCycle
    override func viewDidLoad(){
         lblEmptyMsg.isHidden = true
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            tblForDocumentList.refreshControl = refreshControl
        } else {
            tblForDocumentList.addSubview(refreshControl)
        }
       delegateLeft = self
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: .valueChanged)
        setLocalization()
        
        loadDocumentList()
        tblForDocumentList.estimatedRowHeight = 130
        tblForDocumentList.rowHeight = UITableView.automaticDimension
        btnSubmit.isEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgDocument.isUserInteractionEnabled = true
        imgDocument.addGestureRecognizer(tapGestureRecognizer)
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    func setLocalization(){
        
        title = "TXT_DOCUMENT".localized
        lblMandatoryFields.text = "TXT_MANDATORY_FIELDS".localized
        refreshControl.tintColor = UIColor.black
        view.addSubview(dialogForDocument)
        dialogForDocument.isHidden = true
        dialogForDocument.backgroundColor = .themeOverlayColor
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        alertView.updateConstraints()
        alertView.roundCorner(corners: [.topLeft,.topRight], withRadius: 20)
        self.setBackBarItem(isNative: false)
        btnSubmit.setTitle("TXT_SAVE".localizedUppercase, for: UIControl.State.normal)
        btnSubmit.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSubmitDocument.setTitle("TXT_DONE".localizedCapitalized, for: UIControl.State.normal)
        view.backgroundColor = UIColor.themeViewBackgroundColor
        lblMandatoryFields.textColor = UIColor.red
        updateUI(isUpdate:false)
        tblForDocumentList.separatorStyle = .none
        /*Set Font*/
        lblMandatoryFields.font = FontHelper.textRegular()
        btnSubmitDocument.titleLabel?.font = FontHelper.textRegular(size: 14)
        btnCancel.titleLabel?.font = FontHelper.textRegular(size: 14)
        lblDocId.font = FontHelper.textRegular()
        lblDocId.textColor = .themeLightTextColor
        lblExpDate.font = FontHelper.textRegular()
        lblExpDate.textColor = .themeLightTextColor
        imageForCalendar.image = UIImage.init(named: "calender_white")?.imageWithColor(color: .themeIconTintColor)
        btnCancel.setTitle("", for: .normal)
        (txtDocId as? CustomTextfield)?.selectedLineColor = .themeViewBackgroundColor
        (txtDocId as? CustomTextfield)?.lineColor = .themeViewBackgroundColor
        (txtExpDate as? CustomTextfield)?.selectedLineColor = .themeViewBackgroundColor
        (txtExpDate as? CustomTextfield)?.lineColor = .themeViewBackgroundColor
        btnCancel.tintColor = .themeIconTintColor
        btnCancel.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnCancel.setImage(UIImage.init(named: "cancelBlackIcon")?.imageWithColor(), for: .normal)
        txtExpDate.font = FontHelper.textRegular()
        txtDocId.font = FontHelper.textRegular()
        lblDocTitle.font = FontHelper.textLarge()
        lblEmptyMsg.textColor = UIColor.themeTextColor
        lblEmptyMsg.font = FontHelper.textRegular()
        lblEmptyMsg.text = "TXT_DOCUMENT_LIST_EMPTY".localized
    }
    
    func setupLayout(){
        dialogForDocument.frame = view.bounds
        tblForDocumentList.tableFooterView = UIView.init()
    }
    
//MARK: TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentListLength!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:DocumentCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DocumentCell
        let currentdocument:Document = arrdocumentList[indexPath.row] as! Document
        cell.setCellData(cellItem: currentdocument)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell;
   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 130;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedDocument = arrdocumentList[indexPath.row] as? Document;
        selectedIndex = indexPath.row
        self.openDocumentUploadDialog(selectedDoc:selectedDocument!)
    }
   
//MARK: TextField Delegate Method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtExpDate == textField {
            openDatePicker()
            return false
        }else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
//MARK:- ACTION FUNCTION
    @IBAction func onClickBtnSubmit(_ sender: Any){
        self.view.endEditing(true)
        selectedDocument?.uniqueCode = txtDocId.text
    }
    
    @IBAction func onClickBtnCancel(_ sender: Any){
        closeDocumentUploadDialog()
    }
    
    @IBAction func onClickBtnNext(_ sender: Any){
        if preferenceHelper.getIsProviderDocumentUploaded() || arrdocumentList.count == 0 {
            self.navigationController?.popViewController(animated: true);
        }else {
            self.openLogoutDialog()
        }
    }
    
    func onClickLeftButton() {
        if(preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsProviderDocumentUploaded()) {
            self.openLogoutDialog()
            
        }else {
            self.navigationController?.popViewController(animated: true);
        }
    }
    
/*Document Dialog image tapped*/
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.openImageDialog()
    }
    
//MARK:- USER DEFINE FUNCTION
    func loadDocumentList() {
      wsGetDocumentList()
    }
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        loadDocumentList()
    }
    
    func updateUI(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
       
        tblForDocumentList.isHidden = !isUpdate
        lblMandatoryFields.isHidden = !isUpdate
        if preferenceHelper.getIsProviderDocumentUploaded() || arrdocumentList.count == 0 {
            self.btnSubmit.isEnabled = true
        }
    }
//MARK:- WEB SERVICE CALLS
    func wsGetDocumentList(){
        let dictParam: Dictionary<String,Any> =
            [PARAMS.ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.TYPE:CONSTANT.TYPE_PROVIDER]
        
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_GET_DOCUMENT_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(respons, error) -> (Void) in
            
            
            Parser.parseDocumentList(response: respons, toArray: self.arrdocumentList, completion: { (result) in
                if result {
                    DispatchQueue.main.async
                    {
                            self.refreshControl.endRefreshing()
                            self.documentListLength = self.arrdocumentList.count;
                            self.tblForDocumentList.reloadData()
                            self.updateUI(isUpdate:true)
                    }
                }else {
                    self.updateUI(isUpdate:false)
                }
            })
        }
    }
    
    func wsUploadDocuments(selectedDoc:Document , image : UIImage) {
        let docDetail:DocumentDetail = selectedDoc.documentDetails
        var dictParam: Dictionary<String,Any> =
        [PARAMS.ID:preferenceHelper.getUserId(),
         PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
         PARAMS.TYPE:CONSTANT.TYPE_PROVIDER,
         PARAMS.DOCUMENT_ID:selectedDoc.id!,
        ]

        if docDetail.isUniqueCode! {
            dictParam.updateValue(selectedDoc.uniqueCode!, forKey: PARAMS.UNIQUE_CODE);
        }
        if docDetail.isExpiredDate! {
            dictParam.updateValue(selectedDoc.expiredDate!, forKey: PARAMS.EXPIRED_DATE);
        }
        print(dictParam)

        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper.init();
        alamoFire.getResponseFromURL(url: WebService.WS_UPLOAD_DOCUMENT, paramData: dictParam, image: image, block: { (response, error) -> (Void) in
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                let documentResponse:UploadDocumentResponse = UploadDocumentResponse.init(fromDictionary: response )
                preferenceHelper.setIsProviderDocumentUploaded(documentResponse.isDocumentUploaded!)

                self.selectedDocument?.imageUrl = documentResponse.imageUrl
                self.selectedDocument?.expiredDate = documentResponse.expiredDate
                self.selectedDocument?.uniqueCode = documentResponse.uniqueCode

                self.arrdocumentList.replaceObject(at: self.selectedIndex, with: self.selectedDocument!)
                DispatchQueue.main.async {
                    self.tblForDocumentList.reloadData()
                    if preferenceHelper.getIsProviderDocumentUploaded() {
                        self.btnSubmit.isEnabled = true
                    }
                    self.closeDocumentUploadDialog()
                }
            }
            Utility.hideLoading()
        })
    }

    func checkDocumentValidation() -> Bool {
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
    
    func wsLogout(){
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId()]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_PROVIDER_LOGOUT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Utility.hideLoading()
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")

                APPDELEGATE.goToHome()
            }
            
        }
    }
//MARK:- DIOLOGS
    func openDocumentUploadDialog(selectedDoc:Document) {
        
        let docDetail:DocumentDetail = selectedDoc.documentDetails
        
        dialogForDocument.frame = self.view.frame
       
        lblDocTitle.text = ""
        txtDocId.text = ""
        txtExpDate.text = ""
        txtDocId.placeholder = ""
        lblDocId.text = "TXT_ENTER_ID_NUMBER".localized
        txtExpDate.placeholder = ""
        lblExpDate.text = "TXT_ENTER_EXP_DATE".localized
        txtDocId.isHidden = false
        txtExpDate.isHidden = false
        self.stkForDoc.isHidden = false
        viewExpDate.isHidden = false
        viewDocId.isHidden = false
        var isForExpDate = false
        var isForDocID = false
        lblDocTitle.text = docDetail.documentName!.capitalized
        var documentDailog:DailogForAddDocument! = nil
        if((selectedDoc.imageUrl!.isEmpty)) {
            imgDocument.image = UIImage.init(named:"document_placeholder")
            if (docDetail.isExpiredDate)! {
                txtExpDate.text = ""
            }else {
                txtExpDate.isHidden = true
                viewExpDate.isHidden = true
                isForExpDate = true
            }
            if (docDetail.isUniqueCode)! {
                txtDocId.text = ""
            }else {
                txtDocId.isHidden = true
                viewDocId.isHidden = true
                isForDocID = true
                
            }
            documentDailog = DailogForAddDocument.showCustomAddDocumentDialog(title: selectedDoc.documentDetails.documentName, DocIDShow: isForDocID, DocDateShow: isForExpDate, DocImage: false, titleRightButton: "TXT_DONE".localized, viewController: self, selecteddocument: selectedDoc)
        } else {
            imgDocument.downloadedFrom(link: (selectedDocument?.imageUrl)!, placeHolder: "document_placeholder")
            if (docDetail.isExpiredDate)! {
                txtExpDate.text = Utility.stringToString(strDate: selectedDoc.expiredDate ?? "", fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
            } else {
                txtExpDate.isHidden = true
                viewExpDate.isHidden = true
                isForExpDate = true
            }
            if (docDetail.isUniqueCode)! {
                txtDocId.text = selectedDoc.uniqueCode
            } else {
                txtDocId.isHidden = true
                viewDocId.isHidden = true
                isForDocID = true
            }

            if(txtExpDate.isHidden && txtDocId.isHidden) {
                //self.stkForDoc.isHidden = true
            }
            documentDailog = DailogForAddDocument.showCustomAddDocumentDialog(title: selectedDoc.documentDetails.documentName, DocIDShow: isForDocID, DocDateShow: isForExpDate, DocImage: false, titleRightButton: "TXT_DONE".localized, viewController: self, selecteddocument: selectedDoc)
        }

        if (docDetail.isMandatory)! {
            lblDocTitle.text?.append("*")
        }

        imgDocument.setRound(withBorderColor: UIColor.white, andCornerRadious: 3.0, borderWidth: 1.0)
        documentDailog.onClickSubmitButton = { doc , image in
            self.wsUploadDocuments(selectedDoc: doc, image: image)
        }
    }

    func closeDocumentUploadDialog() {
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
    
    func openLogoutDialog(){
        
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_LOGOUT".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForLogout.onClickLeftButton = { [unowned dialogForLogout] in
                dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton = {
                [unowned dialogForLogout, unowned self] in
                dialogForLogout.removeFromSuperview();
                self.wsLogout()
        }
    }
}





