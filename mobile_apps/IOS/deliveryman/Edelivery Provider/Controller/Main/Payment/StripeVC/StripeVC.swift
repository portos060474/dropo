//
//  StripeVCViewController.swift
//  edelivery
//
//  Created by Elluminati on 17/04/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class StripeVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

//MARK:- Outlets
    @IBOutlet weak var tableForCardList: UITableView!
    @IBOutlet weak var btnAddNewCard: UIButton!
    @IBOutlet weak var emptyImage : UIImageView!

//MARK:- Variables
    var arrForCardList : NSMutableArray = NSMutableArray.init()
    var selectedCard:CardItem? = nil ;

//MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        wsGetCardList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(cardSelected), name:Notification.Name("CardSelected"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func updateUIAccordingToTheme() {
        self.setLocalization()
        tableForCardList.reloadData()
    }

    func setLocalization() {
        btnAddNewCard.setImage(UIImage(named: "plus_icon")?.imageWithColor(color: .white), for: .normal)
        self.btnAddNewCard.backgroundColor = .themeColor
        self.btnAddNewCard.layer.cornerRadius = btnAddNewCard.frame.height/2.0
        tableForCardList.backgroundColor = UIColor.themeViewBackgroundColor
        tableForCardList.rowHeight = 75
        tableForCardList.separatorStyle = .none
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:- Action Methods
    @IBAction func onClickBtnAddNewCard(_ sender: AnyObject) {
        openCreditCardDialog()
    }

    //MARK:- Table View Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let card:CardItem = arrForCardList.object(at: indexPath.row) as! CardItem
        wsSelectCard(card: card)
        NotificationCenter.default.post(name:Notification.Name("CardSelected"), object:card, userInfo:nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrForCardList.count > 0 {
            return arrForCardList.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StripeCardCell
        let card:CardItem = arrForCardList[indexPath.row] as! CardItem
        cell.setCellData(cellItem: card, section: indexPath.section, row: indexPath.row, parent: self)
        return cell
    }

    //MARK:- Web Service Methods
    func wsAddCardToServer(paymentMethod:String,lastFour:String) {
        Utility.showLoading()
        let dictParam : [String : Any] =
        [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
         PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken() ,
         PARAMS.PAYMENT_METHOD : paymentMethod,
         PARAMS.TYPE : CONSTANT.TYPE_PROVIDER,
         PARAMS.LAST_FOUR : lastFour,
         PARAMS.PAYMENT_ID : Payment.STRIPE]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_ADD_CARD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Parser.parseCard(response, toArray: self.arrForCardList, completion: { (result) in
                if result {
                    DispatchQueue.main.async {
                        self.setSelectCard()
                        self.tableForCardList.reloadData()
                        Utility.hideLoading()
                        self.wsGetCardList()
                    }
                }
            })
            if self.arrForCardList.count == 0 {
                self.tableForCardList.isHidden = true
                self.emptyImage.isHidden = false
            } else {
                self.tableForCardList.isHidden = false
                self.emptyImage.isHidden = true
            }
        }
    }

    func wsGetCardList() {
        let dictParam : [String : Any] =
        [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
         PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken() ,
         PARAMS.TYPE :CONSTANT.TYPE_PROVIDER,
         PARAMS.PAYMENT_GATEWAY_ID : Payment.STRIPE
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_CARD_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Parser.parseCards(response, toArray: self.arrForCardList, completion: { (result) in
                if result {
                    DispatchQueue.main.async {
                        self.setSelectCard()
                        if self.arrForCardList.count == 0 {
                            self.tableForCardList.isHidden = true
                            self.emptyImage.isHidden = false
                        } else {
                            self.tableForCardList.isHidden = false
                            self.emptyImage.isHidden = true
                        }
                        self.tableForCardList.reloadData()
                    }
                }
            })
            if self.arrForCardList.count == 0 {
                self.tableForCardList.isHidden = true
                self.emptyImage.isHidden = false
            } else {
                self.tableForCardList.isHidden = false
                self.emptyImage.isHidden = true
            }
        }
    }

    func wsSelectCard(card:CardItem) {
        let dictParam : [String : Any] =
        [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
         PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken() ,
         PARAMS.CARD_ID: card.id ?? "",
         PARAMS.TYPE :CONSTANT.TYPE_PROVIDER
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_SELECT_CARD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                DispatchQueue.main.async {
                    for card in self.arrForCardList {
                        (card as! CardItem).isDefault = false;
                    }
                    card.isDefault = true
                    self.setSelectCard()
                    self.tableForCardList.reloadData()
                }
            }
        }
    }
    
    func wsDeletCard(card:CardItem) {
        let dictParam : [String : Any] =
        [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
         PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken() ,
         PARAMS.CARD_ID: card.id!,
         PARAMS.TYPE :CONSTANT.TYPE_PROVIDER
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_DELET_CARD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                DispatchQueue.main.async {
                    if card.isDefault {
                        self.arrForCardList.remove(card)
                        if self.arrForCardList.count == 0 {
                            self.setSelectCard()
                        } else {
                            self.wsSelectCard(card: self.arrForCardList.firstObject as! CardItem)
                        }
                        if self.arrForCardList.count == 0 {
                            self.tableForCardList.isHidden = true
                            self.emptyImage.isHidden = false
                        } else {
                            self.tableForCardList.isHidden = false
                            self.emptyImage.isHidden = true
                        }
                    } else {
                        self.arrForCardList.remove(card)
                        if self.arrForCardList.count == 0 {
                            self.tableForCardList.isHidden = true
                            self.emptyImage.isHidden = false
                        } else {
                            self.tableForCardList.isHidden = false
                            self.emptyImage.isHidden = true
                        }
                        self.setSelectCard()
                    }
                    self.tableForCardList.reloadData()
                }
            }
        }
    }

    //MARK:- Dialogs
    func openCreditCardDialog() {
        let dialogForCard:CustomCardDialog = CustomCardDialog.showCustomCardDialog(title: "TXT_ADD_CARD".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_SUBMIT".localizedUppercase)
        dialogForCard.onClickLeftButton = { [unowned dialogForCard] in
            dialogForCard.removeFromSuperview();
        }
        dialogForCard.onClickRightButton = {
            [unowned self,unowned dialogForCard] (card:String,lastFour:String) in
            self.wsAddCardToServer(paymentMethod: card, lastFour: lastFour)
            dialogForCard.removeFromSuperview()
        }
    }

    //MARK:- User Define Methods
    func setSelectCard() {
        selectedCard = nil
        for card in arrForCardList {
            if ((card as? CardItem)?.isDefault)! {
                selectedCard = card as? CardItem
                return;
            }
        }
    }

    //MARK:- Notification Observer
    @objc func cardSelected(_ notification: Notification) {
        let card:CardItem = notification.object as! CardItem
        if card.paymentId != Payment.STRIPE {
            selectedCard = nil
            for card in arrForCardList {
                (card as? CardItem)!.isDefault = false
            }
        }
        self.tableForCardList.reloadData()
    }
}
