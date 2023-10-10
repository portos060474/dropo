//
//  DocumentVC.swift
// Edelivery Store
//
//  Created by tag on 07/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import FirebaseMessaging


class DocumentVC: BaseVC,LeftDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,OnClickSubmitDelegate {
    // MARK: - OUTLET
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lblMandatoryFields: UILabel!
    @IBOutlet weak var tblForDocumentList: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    /*doc Dialog*/
    @IBOutlet var dialogForDocument: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var stkForDoc: UIStackView!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtDocId: UITextField!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocTitle: UILabel!
    @IBOutlet weak var btnSubmitDocument: UIButton!
    
    
    // MARK: - Variables
    var arrdocumentList:NSMutableArray = []
    var documentListLength:Int? = 0
    var selectedDocument:Document? = nil
    var selectedIndex = 0;
    var isPicAdded:Bool = false;
    var dialogForImage:CustomPhotoDialog? = nil;
    private let refreshControl = UIRefreshControl()
    var documentDailog:DailogForAddDocument! = nil

    // MARK: - LifeCycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        if #available(iOS 10.0, *) {
            tblForDocumentList.refreshControl = refreshControl
        } else {
            tblForDocumentList.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: .valueChanged)
        setLocalization()
        
        loadDocumentList()
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
        btnSubmit.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnSubmit.backgroundColor = UIColor.black
        view.backgroundColor = UIColor.themeViewBackgroundColor
        lblMandatoryFields.textColor = UIColor.themeRedColor;
        self.setBackBarItem(isNative: false)
        delegateLeft = self
        
        updateUI(isUpdate:false)
        
        /* Set Font */
        
        lblMandatoryFields.font = FontHelper.textRegular()
        btnSubmit.titleLabel?.font = FontHelper.textRegular()
        btnCancel.titleLabel?.font = FontHelper.textRegular()
        btnSubmitDocument.titleLabel?.font = FontHelper.textRegular()
       
        
        
        btnSubmit.setTitle("TXT_SAVE".localizedUppercase, for: UIControl.State.normal)
        btnCancel.setTitle("TXT_CANCEL".localizedUppercase, for: .normal)
        btnSubmitDocument.setTitle("TXT_OK".localizedUppercase, for: .normal)
        
        
        txtExpDate.font = FontHelper.textRegular()
        txtDocId.font = FontHelper.textRegular()
        lblDocTitle.font = FontHelper.textRegular()
        btnSubmit.backgroundColor = .themeColor
        btnSubmit.setRound(withBorderColor: .clear, andCornerRadious: btnSubmit.frame.size.height/2, borderWidth: 1.0)

    }
    func setupLayout(){
        dialogForDocument.frame = view.bounds
        tblForDocumentList.tableFooterView = UIView.init()
    }
    
    override func updateUIAccordingToTheme() {
        self.setBackBarItem(isNative: false)
    }
    
    //MARK: TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentListLength!;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:DocumentCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DocumentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentdocument:Document = arrdocumentList[indexPath.row] as! Document
        cell.setCellData(cellItem: currentdocument)
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120;
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
        wsUploadDocuments(selectedDoc:selectedDocument!, img: imgDocument.image ?? UIImage())
    }
    
    func onClickSubmitbtn(docID: String, imgDoc: UIImage) {

        
        selectedDocument?.uniqueCode = docID
        wsUploadDocuments(selectedDoc:selectedDocument!,img: imgDoc)
    }
    
    
    @IBAction func onClickBtnCancel(_ sender: Any){
        closeDocumentUploadDialog()
    }
    @IBAction func onClickBtnNext(_ sender: Any){
        if preferenceHelper.getIsUserDocumentUploaded() || arrdocumentList.count == 0 {
            preferenceHelper.setIsUserDocumentUploaded(true)
            self.navigationController?.popViewController(animated: true);
        }else {
            self.openLogoutDialog()
        }
    }
    
    func onClickLeftButton() {
        
        if(preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsUserDocumentUploaded()) {
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
        imgEmpty?.isHidden = isUpdate
        tblForDocumentList?.isHidden = !isUpdate
        lblMandatoryFields?.isHidden = !isUpdate
        if preferenceHelper.getIsUserDocumentUploaded() || arrdocumentList.count == 0 {
            self.btnSubmit?.isEnabled = true
            self.btnSubmit?.backgroundColor = UIColor.themeColor
        }else {
            self.btnSubmit?.isEnabled = false
            self.btnSubmit?.backgroundColor = UIColor.themeDisableButtonBackgroundColor
        }
    }
    //MARK:- WEB SERVICE CALLS
    func wsGetDocumentList(){
        let dictParam: Dictionary<String,Any> =
            [PARAMS.ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.TYPE:CONSTANT.TYPE_STORE]
        
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_GET_DOCUMENT_LIST, methodName: "POST", paramData: dictParam) {
            (response, error) -> (Void) in
            Parser.parseDocumentList(response, toArray: self.arrdocumentList, completion: { (result) in
                
                DispatchQueue.main.async
                    {
                        if result
                        {
                    
                            self.refreshControl.endRefreshing()
                            self.documentListLength = self.arrdocumentList.count;
                            self.tblForDocumentList?.reloadData()
                            self.updateUI(isUpdate:true)
                        }
                        else
                        {
                            self.updateUI(isUpdate:false)
                        }
                }
            })
            
        }
    }
    func wsUploadDocuments(selectedDoc:Document,img:UIImage){
        
       // if(checkDocumentValidation()) {
            let docDetail:DocumentDetail = selectedDoc.documentDetails
            var dictParam: Dictionary<String,Any> =
                [PARAMS.ID:preferenceHelper.getUserId(),
                 PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
                 PARAMS.TYPE:String(CONSTANT.TYPE_STORE),
                 PARAMS.DOCUMENT_ID:selectedDoc.id!,
                 ]
            
            if docDetail.isUniqueCode! {
                dictParam.updateValue(selectedDoc.uniqueCode!, forKey: PARAMS.UNIQUE_CODE);
                
            }
            if docDetail.isExpiredDate! {
                dictParam.updateValue(selectedDoc.expiredDate!, forKey: PARAMS.EXPIRED_DATE);
            }
            
            
            Utility.showLoading()
            let alamoFire:AlamofireHelper = AlamofireHelper.init();
            alamoFire.getResponseFromURL(url: WebService.WS_UPLOAD_DOCUMENT, paramData: dictParam, image: img, block: { (response, error) -> (Void) in
                
                if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                    let documentResponse:UploadDocumentResponse = UploadDocumentResponse.init(fromDictionary: response)
                    preferenceHelper.setIsUserDocumentUploaded(documentResponse.isDocumentUploaded!)
                    self.selectedDocument?.imageUrl = documentResponse.imageUrl
                    self.selectedDocument?.expiredDate = documentResponse.expiredDate
                    self.selectedDocument?.uniqueCode = documentResponse.uniqueCode
                    self.arrdocumentList.replaceObject(at: self.selectedIndex, with: self.selectedDocument!)
                    DispatchQueue.main.async
                        {
                            self.tblForDocumentList.reloadData()
                            if preferenceHelper.getIsUserDocumentUploaded()
                            {
                                self.btnSubmit.isEnabled = true
                                self.btnSubmit.backgroundColor = UIColor.themeColor
                            }
                            else
                            {
                                self.btnSubmit.isEnabled = false
                                self.btnSubmit.backgroundColor = UIColor.themeDisableButtonBackgroundColor
                            }
                            self.closeDocumentUploadDialog()
                    }
                }
                Utility.hideLoading()
                
            })
        //}
        
        
    }
//    func checkDocumentValidation() -> Bool{
//
//        let docDetail:DocumentDetail = (selectedDocument?.documentDetails)!
//
//
//        if ((txtDocId.text?.isEmpty())! && (docDetail.isUniqueCode)!) {
//            Utility.showToast(message:"MSG_PLEASE_ENTER_DOCUMENT_ID".localized)
//            return false
//        }else if ((txtExpDate.text?.isEmpty())! && (docDetail.isExpiredDate)!) {
//            Utility.showToast(message:"MSG_PLEASE_ENTER_DOCUMENT_EXP_DATE".localized)
//            return false
//        }else if !isPicAdded {
//            Utility.showToast(message:"MSG_PLEASE_SELECT_DOCUMENT_IMAGE".localized)
//            return false
//        }else {
//            return true
//        }
//    }
    func wsLogout(){
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID : preferenceHelper.getUserId()]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_STORE_LOGOUT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                APPDELEGATE.removeFirebaseTokenAndTopic()
                preferenceHelper.setSessionToken("")
                APPDELEGATE.goToHome()
                StoreSingleton.shared.cart.removeAll()
                return
            }
            Utility.hideLoading()
        }
    }
    //MARK:- DIOLOGS
    func openDocumentUploadDialog(selectedDoc:Document) {
        var isForExpDate = false
        var isForDocID = false

        let docDetail:DocumentDetail = selectedDoc.documentDetails
        
        dialogForDocument.frame = self.view.frame
//        dialogForDocument.isHidden = false
        lblDocTitle.text = ""
        txtDocId.text = ""
        txtExpDate.text = ""
        txtDocId.placeholder = "TXT_ENTER_ID_NUMBER".localized
        txtExpDate.placeholder = "TXT_ENTER_EXP_DATE".localized
        txtDocId.isHidden = false
        txtExpDate.isHidden = false
        self.stkForDoc.isHidden = false
        
        lblDocTitle.text = docDetail.documentName!.uppercased()
        if((selectedDoc.imageUrl!.isEmpty())) {
            
            imgDocument.image = UIImage.init(named:"document_placeholder" )
            imgDocument.contentMode = .scaleAspectFit
            
            if (docDetail.isExpiredDate)! {
                txtExpDate.text = ""
            }else {
                txtExpDate.isHidden = true
                isForExpDate = true
            }
            
            if (docDetail.isUniqueCode)! {
                txtDocId.text = ""
            }else {
                txtDocId.isHidden = true
                isForDocID = true
                
            }
            if(txtExpDate.isHidden && txtDocId.isHidden) {
               // self.stkForDoc.isHidden = true
            }
            
  
            if let vc = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "AddDocVC") as? AddDocVC {
                vc.DocIDShow = isForDocID
                vc.DocDateShow = isForExpDate
                vc.title = selectedDoc.documentDetails.documentName
                vc.delegate = self
                vc.DocImage = false
                vc.titleRightButton = "TXT_DONE".localized
                vc.selectedDocument = selectedDocument!
                vc.selectedDocument!.documentDetails = selectedDoc.documentDetails
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: false)
            }


        }else {
             isForExpDate = false
             isForDocID = false
            
            imgDocument.downloadedFrom(link: (selectedDocument?.imageUrl)!, placeHolder: "document_placeholder")
            if (docDetail.isExpiredDate)! {
                txtExpDate.text = Utility.stringToString(strDate: selectedDoc.expiredDate!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
            }else {
                txtExpDate.isHidden = true
                isForExpDate = true
            }
            if (docDetail.isUniqueCode)! {
                txtDocId.text = selectedDoc.uniqueCode
            }else {
                txtDocId.isHidden = true
                isForDocID = true
            }
            if(txtExpDate.isHidden && txtDocId.isHidden) {
                // self.stkForDoc.isHidden = true
            }
            
            
            if let vc = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "AddDocVC") as? AddDocVC {
                vc.DocIDShow = isForDocID
                vc.DocDateShow = isForExpDate
                vc.title = selectedDoc.documentDetails.documentName
                vc.DocImage = false
                vc.delegate = self
                vc.titleRightButton = "TXT_DONE".localized
                vc.selectedDocument = selectedDocument!
                vc.selectedDocument!.documentDetails = selectedDoc.documentDetails

                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: false)
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
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, isCropRequired: false)
        dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage]
            
            (image:UIImage) in
            self.imgDocument.image = image
            self.isPicAdded = true
        }
    }
    func openDatePicker(){
        self.view.endEditing(true)
        let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_EXPIRY_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        let maxDate:Date =  Calendar.current.date(byAdding: .year, value: 100, to: Date()) ?? Date.init()
        datePickerDialog.setMaxDate(maxdate: maxDate)
        datePickerDialog.setMinDate(mindate: Date())
        
        
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
        }
        
        datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self]  (selectedDate:Date) in
                let currentDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_FORMAT)
                self.selectedDocument?.expiredDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
                self.txtExpDate.text = currentDate
                datePickerDialog.removeFromSuperview()
        }
        
        
    }
    func openLogoutDialog(){
        
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_LOGOUT".localized, message: "MSG_LOGOUT".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForLogout.onClickLeftButton = {
                [unowned dialogForLogout] in
                dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton = {
              [unowned dialogForLogout, unowned self] in
                dialogForLogout.removeFromSuperview();
                self.wsLogout()
        }
    }
    
}





