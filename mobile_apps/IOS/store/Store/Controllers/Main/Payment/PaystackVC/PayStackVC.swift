import UIKit

class PayStackVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

    //MARK:- Outlets
    @IBOutlet weak var tableForCardList: UITableView!
    @IBOutlet weak var btnAddNewCard: UIButton!
    @IBOutlet weak var imgCardIcon: UIButton!
    @IBOutlet weak var imgEmpty: UIImageView!

    //MARK:- Variables
    var arrForCardList : NSMutableArray = NSMutableArray.init()
    var selectedCard:CardItem? = nil

    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wsGetCardList()
        if self.arrForCardList.count > 0{
            self.tableForCardList.isHidden = false
            self.imgEmpty.isHidden = true
        } else {
            self.tableForCardList.isHidden = true
            self.imgEmpty.isHidden = false
        }
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(cardSelected), name:Notification.Name("CardSelected"), object: nil)
    }

    func setLocalization() {
        btnAddNewCard.setImage(UIImage(named: "plus_icon")?.imageWithColor(color: .white), for: .normal)
        self.btnAddNewCard.backgroundColor = .themeColor
        self.btnAddNewCard.layer.cornerRadius = btnAddNewCard.frame.height/2.0
        tableForCardList.backgroundColor = UIColor.themeViewBackgroundColor
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func updateUIAccordingToTheme() {
        tableForCardList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:- Action Methods
    @IBAction func onClickBtnAddNewCard(_ sender: AnyObject) {
        self.performSegue(withIdentifier: SEGUE.PAYMENT_TO_PAYSTACK_WEBVIEW, sender: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaystackCardCell
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
             PARAMS.TYPE : CONSTANT.TYPE_STORE,
             PARAMS.LAST_FOUR : lastFour,
             PARAMS.PAYMENT_ID : Payment.PAYSTACK]

        let alamoFire:AlamofireHelper = AlamofireHelper()
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
        }
    }

    func wsGetCardList() {
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
             PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken() ,
             PARAMS.TYPE : CONSTANT.TYPE_STORE,
             PARAMS.PAYMENT_GATEWAY_ID : Payment.PAYSTACK
             ]

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_GET_CARD_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Parser.parseCards(response, toArray: self.arrForCardList, completion: { (result) in
                if result {
                    DispatchQueue.main.async {
                        self.setSelectCard()
                        self.tableForCardList.reloadData()
                        if self.arrForCardList.count > 0 {
                            self.tableForCardList.isHidden = false
                            self.imgEmpty.isHidden = true
                        } else {
                            self.tableForCardList.isHidden = true
                            self.imgEmpty.isHidden = false
                        }
                    }
                }
            })
        }
    }

    func wsSelectCard(card:CardItem) {
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
             PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken() ,
             PARAMS.CARD_ID: card.id,
             PARAMS.TYPE : CONSTANT.TYPE_STORE,
             PARAMS.PAYMENT_ID : Payment.PAYSTACK
            ]

        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_SELECT_CARD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                DispatchQueue.main.async {
                    for card in self.arrForCardList {
                        (card as! CardItem).isDefault = false
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
             PARAMS.TYPE : CONSTANT.TYPE_STORE
             ]

        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_DELET_CARD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                DispatchQueue.main.async {
                    if card.isDefault {
                        self.arrForCardList.remove(card)
                        if self.arrForCardList.count == 0 {
                            self.setSelectCard()
                        } else {
                            self.wsSelectCard(card: self.arrForCardList.firstObject as! CardItem)
                        }
                    } else {
                        self.arrForCardList.remove(card)
                        self.setSelectCard()
                    }
                    self.tableForCardList.reloadData()
                }
            }
        }
    }

    //MARK:- Dialogs
    func openCreditCardDialog() {
        let dialogForCard:CustomCardDialog = CustomCardDialog.showCustomCardDialog(title: "TXT_ADD_CARD".localized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_SUBMIT".localizedCapitalized)
        dialogForCard.onClickLeftButton = {
                [unowned self] in
//                dialogForCard.removeFromSuperview()
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
            return
            }
        }
    }

    //MARK:- Notification Observer
    @objc func cardSelected(_ notification: Notification) {
        let card:CardItem = notification.object as! CardItem
        if card.paymentId != Payment.PAYSTACK {
            selectedCard = nil
            for card in arrForCardList {
                (card as? CardItem)!.isDefault = false
            }
        }
        self.tableForCardList.reloadData()
    }
}

class PaystackCardCell: CustomTableCell {
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var btnDefault: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgCardIcon: UIImageView!

    //MARK:- Variables
    weak var payStackVCObject:PayStackVC?
    var section:Int?
    var row:Int?
    var currentCard:CardItem?

    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        lblCardNumber.font = FontHelper.textRegular()
        lblCardNumber.textColor = UIColor.themeTextColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
    }

    //MARK:- SET CELL DATA
    func setCellData(cellItem:CardItem,section:Int, row:Int,parent:PayStackVC) {
        currentCard = cellItem
        self.section = section
        self.row = row
        payStackVCObject = parent
        lblCardNumber.text = "****" + cellItem.lastFour!
        btnDefault.isHidden = !cellItem.isDefault!
        //
        btnDefault.setImage(UIImage(named: "correct"), for: .normal)
        btnDelete.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        imgCardIcon.image = UIImage(named: "card_icon")?.imageWithColor(color: .themeIconTintColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onClickBtnDeleteCard(_ sender: AnyObject) {
        openConfirmationDialog()
    }

    func openConfirmationDialog() {
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_DELETE_CARD".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForLogout.onClickLeftButton = {
            [unowned dialogForLogout, unowned self] in
            dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton = {
            [unowned dialogForLogout, unowned self] in
            dialogForLogout.removeFromSuperview();
            self.payStackVCObject?.wsDeletCard(card: self.currentCard!)
        }
    }
}
