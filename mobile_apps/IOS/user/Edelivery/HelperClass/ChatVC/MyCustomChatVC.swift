//
//  MyCustomChatVC.swift
//  Qatch Driver
//
//  Created by Elluminati on 03/05/18.
//  Copyright © 2018 Elluminati Mini Mac 5. All rights reserved.
//

import UIKit
import FirebaseAuth
import IQKeyboardManagerSwift
import FirebaseMessaging

class MyCustomChatVC: BaseVC,UITableViewDelegate,UITableViewDataSource,MessageRecivedDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,LeftDelegate {
   
   
    // MARK:- Outlet and Variable
    @IBOutlet var tblChat: UITableView!
    @IBOutlet var txtMessage: UITextView!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet weak var btmContraint: NSLayoutConstraint!

    private var arrMessages:[FirebaseMessage] = []
    var keyboardHeight : CGFloat = 60.0
    var navTitle  : String = ""

    // MARK:- Life Cycle
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessageHandler.Instace.delegate = self
        MessageHandler.Instace.removeObserver()
        MessageHandler.Instace.observeMessage()
        MessageHandler.Instace.observeUpdateMessage()
        print("\(preferenceHelper.getUserId())")
        
        tblChat.estimatedRowHeight = 90
        tblChat.rowHeight = UITableView.automaticDimension
        
        print(CurrentBooking.shared.selectedOrderId!)
        preferenceHelper.setChatName(CurrentBooking.shared.selectedOrderId!)
 
        txtMessage.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        txtMessage.backgroundColor = UIColor.themeViewBackgroundColor
        txtMessage.textColor = UIColor.themeTextColor
        txtMessage.tintColor = UIColor.themeTextColor
        btnSend.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSend.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnSend.setTitle("TXT_SEND".localizedCapitalized, for: .normal)
        txtMessage.text = "PLACE_HOLDER_ENTER_MESSAGE".localized
        self.btmContraint.constant = 10

        if MessageHandler.chatType == CONSTANT.CHATTYPES.ADMIN_AND_USER{
            self.setNavigationTitle(title:"TXT_CHAT_WITH".localized + navTitle)
            
        }else if MessageHandler.chatType == CONSTANT.CHATTYPES.USER_AND_STORE{
            self.setNavigationTitle(title:"TXT_CHAT_WITH".localized + navTitle)

        }else{
            self.setNavigationTitle(title:"TXT_CHAT_WITH".localized + navTitle)

        }

     self.delegateLeft = self
     self.setBackBarItem(isNative: false)
     self.hideBackButtonTitle()
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        IQKeyboardManager.shared.enable = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        Utility.hideLoading()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnSend.setRound(withBorderColor: .clear, andCornerRadious: btnSend.frame.height/2, borderWidth: 1.0)
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
        self.navigationController?.isNavigationBarHidden = false

    }
    override func updateUIAccordingToTheme() {
        self.setBackBarItem(isNative: false)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            self.btmContraint.constant = CGFloat(+keyboardHeight) + 10
            print(self.btmContraint.constant)
            self.scrollToBottom()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            self.btmContraint.constant = 10
        }
    }
    
   
    // MARK:- Tableview Data Source and delegate Method
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
        let message:FirebaseMessage = arrMessages[indexPath.row]

        if message.sender_type == CONSTANT.CHAT_USER_TYPE
        {
            let cell:SenderCell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! SenderCell
            cell.setCellData(dict: message)
            return cell
        }
        else {

            let cell:ReciverCell = tableView.dequeueReusableCell(withIdentifier: "reciverCell", for: indexPath) as! ReciverCell
            cell.setCellData(dict: message)
            if message.isRead == false {
                MessageHandler.Instace.readMessage(id: message.id)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK:- Message Recived Delegate
    
    func messageRecived(data: FirebaseMessage)
    {
        if let index = arrMessages.firstIndex(where: { (message) -> Bool in
            message.id == data.id
        })
        {
         printE(index)
        }
        else
        {
            arrMessages.append(data)
        }
        
        tblChat.reloadData()
        scrollToBottom()
    }
    
    func messageUpdated(data: FirebaseMessage)
    {
        if let index = arrMessages.firstIndex(where: { (message) -> Bool in
            message.id == data.id
        })
        {
            arrMessages[index].isRead = true
        }
        tblChat.reloadData()
        scrollToBottom()
    }
    
    // MARK:- TextView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if txtMessage.text == "PLACE_HOLDER_ENTER_MESSAGE".localized
        {
            txtMessage.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
       
        if txtMessage.text == ""
        {
            txtMessage.text = "PLACE_HOLDER_ENTER_MESSAGE".localized
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
      
        
    }
  
    // MARK:- Tap Gesture Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: tblChat))! {
            return true
        }
        return true
    }
    
    @IBAction func onClickBtnMenu(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK:- Button Click Method
    @IBAction func onClickBtnAttachment(_ sender: Any)
    {
        self.performSegue(withIdentifier:"segueToCreateTrip", sender: self)
    }
    
    @IBAction func onClickBtnSend(_ sender: Any)
    {
        btnSend.isEnabled = false
        if !txtMessage.text.isEmpty() && txtMessage.text != "PLACE_HOLDER_ENTER_MESSAGE".localized
        {
            MessageHandler.Instace.sendMessage(text: txtMessage.text, time:
            Date().toString(withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, timeZone: "UTC"))
            
            txtMessage.endEditing(true)
            txtMessage.text = "PLACE_HOLDER_ENTER_MESSAGE".localized
           
         
            if arrMessages.count > 0
            {
                self.scrollToBottom()
            }
            btnSend.isEnabled = true
            
        }
        else
        {
            self.txtMessage.endEditing(true)
            btnSend.isEnabled = true
        }
    }
   
    @IBAction func onClickBtnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func onClickLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    //    MARK:- User Define Method

    func scrollToBottom()
    {
        DispatchQueue.main.async
        { [unowned self] in
            if self.arrMessages.count > 0{
                let indexPath = IndexPath(row: (self.arrMessages).count - 1, section:0)
                self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        self.txtMessage.endEditing(true)
    }
    
    //    MARK:- Memory Management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    // MARK:- Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {

    }
    @IBAction func onClickBtnNavBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}

