

import UIKit
import Printer

@objc protocol printerDelegate: class {
    func printerSelected()
}
class PrinterListViewController: BaseVC {
    //MARK: IBoutlets
    @IBOutlet weak var  tableView: UITableView!
    @IBOutlet weak var  btnBack: UIButton!
    @IBOutlet weak var  btnRefersh: UIButton!
    @IBOutlet weak var  lblNoPrinter: UILabel!

    //MARK: Variables
    var printerArray = NSMutableArray()
    var delegate:printerDelegate?
    
    //MARK: View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnRefersh.setTitle("TXT_RESCAN".localized, for: .normal)
        self.btnRefersh.backgroundColor = UIColor.themeColor
        self.btnRefersh.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.btnRefersh.titleLabel?.font = FontHelper.buttonText()
        tableView.tableFooterView = UIView()

        lblNoPrinter.textColor = UIColor.themeLightTextColor
        lblNoPrinter.font = FontHelper.textRegular()
        lblNoPrinter.text = "MSG_NO_PRINTERS".localized
        lblNoPrinter.isHidden = true
        tableView.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        printerArray.removeAllObjects()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scanPrinters()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    //MARK: Userdefinded Functions
    func scanPrinters(){
        printerArray.removeAllObjects()
        self.tableView.reloadData()

        PrinterSDK.default()?.stopScanPrinters()
        PrinterSDK.default()?.scanPrinters(completion: { (printer) in
            if nil == self.printerArray {
                self.printerArray = [AnyHashable]() as! NSMutableArray
            }
            if let printer = printer {
                self.printerArray.add(printer)
            }
            self.tableView.reloadData()
        })
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            if self.printerArray.count == 0{
                self.lblNoPrinter.isHidden = false
                self.tableView.isHidden = true
                Utility.showToast(message: "MSG_NO_PRINTERS".localized)
            }else{
                self.lblNoPrinter.isHidden = true
                self.tableView.isHidden = false
            }
        }
    }
    
    @IBAction func onClickBackButton(sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickRefreshButton(sender:UIButton) {
        self.scanPrinters()
    }
}

extension PrinterListViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return printerArray.count
    }
    static let tableViewIdentify = "PrinterCell"

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrinterListViewController.tableViewIdentify)
        cell?.backgroundColor = UIColor.clear
        cell?.contentView.backgroundColor = UIColor.clear
        let nameLabel = cell?.contentView.viewWithTag(1) as? UILabel
        let uuidLabel = cell?.contentView.viewWithTag(2) as? UILabel

        let printer = printerArray[indexPath.row] as? Printer
        nameLabel?.text = printer?.name
        uuidLabel?.text = printer?.uuidString

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let printer = printerArray[indexPath.row] as? Printer
        PrinterSDK.default()?.connectBT(printer)

        self.dismiss(animated: true, completion: nil)
    }
}
