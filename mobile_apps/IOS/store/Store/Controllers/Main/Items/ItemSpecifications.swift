//
//  ItemsVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 24/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit


class ItemSpecificationVC: MainVC {
   
    @IBOutlet weak var imageToConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewForItem: UIView!
    @IBOutlet weak var tblVHeader: UIView!

    //MARK: -
    //MARK: - Outlets
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var tblItemSpecification: UITableView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDescriptionValue: UILabel!
    var selectedItem:Item? = nil;
    var arrForItemSpecification:[ItemSpecification]? = nil;
    
    //MARK: -
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       self.setLocalization()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.parent?.tabBarController?.tabBar.isHidden = false
     }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        setupLayout()
        //set tableview header height dynamic
        if tblItemSpecification != nil{
            tblItemSpecification.layoutTableHeaderView()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateUIAccordingToTheme() {
        if LocalizeLanguage.isRTL{
            self.btnLeft?.setImage(UIImage.init(named: "back_right")!.imageWithColor(color: .themeTextColor)!, for: .normal)
            self.btnLeft?.setImage(UIImage.init(named: "back_right")?.imageWithColor(color: .themeTextColor), for: .selected)
        }else{
            self.btnLeft?.setImage(UIImage.init(named: "back")!.imageWithColor(color: .themeTextColor)!, for: .normal)
            self.btnLeft?.setImage(UIImage.init(named: "back")?.imageWithColor(color: .themeTextColor), for: .selected)
        }
    }
    
    func setupLayout() {
        if self.view.subviews.count > 0 {
        viewForItem?.layer.cornerRadius = 8;
        viewForItem?.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize(width: -1, height: 1), shadowOpacity: 0.5, shadowRadius: 5)
        }
        
    }
    override func btnLeftTapped(_ btn: UIButton = UIButton()) {
        self.navigationController?.popViewController(animated: true)
    }
   
    //MARK: - custom set up
    
    func setLocalization() -> Void {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        //        super.setNavigationTitle(title: "TXT_ITEMS".localized)
        self.lblTitle?.text = "TXT_ITEMS".localized
        self.lblTitle?.textColor = .themeTitleColor
        lblItemName.text = selectedItem?.name
        //        lblDescription.text = "TXT_DESCRIPTION".localized
        //        imageToConstraint.constant = -Common.statusBarHeight
        lblDescriptionValue.text = "\(selectedItem?.details ?? "")"
        //         self.tblVHeader.frame.size.height = self.imgProduct.frame.size.height + self.lblItemName.frame.size.height + self.lblDescriptionValue.frame.size.height
        
        self.tblItemSpecification.backgroundColor = UIColor.themeViewBackgroundColor
        // Tableview properties.
        self.tblItemSpecification.rowHeight = UITableView.automaticDimension
        self.tblItemSpecification.estimatedRowHeight = 120.0
        self.tblItemSpecification.sectionHeaderHeight = UITableView.automaticDimension
        self.tblItemSpecification.estimatedSectionHeaderHeight = 20
        arrForItemSpecification = selectedItem?.specifications
        tblItemSpecification.reloadData()
        if !(selectedItem!.imageUrl.isEmpty) {
            imgProduct.downloadedFrom(link: (selectedItem?.imageUrl[0]) as! String)
        }
        //        self.navigationBar?.backgroundColor = UIColor.themeTransparentNavigationBackgroundColor
        self.navigationBar?.backgroundColor = UIColor.themeViewBackgroundColor
        
        //        self.lblTitle?.text = ""
        lblItemName.font = FontHelper.textLarge()
        //        lblDescription.font = FontHelper.textMedium()
        lblDescriptionValue.font = FontHelper.labelRegular()
        updateUIAccordingToTheme()
    }
    
   
   
}
extension ItemSpecificationVC:UITableViewDataSource,UITableViewDelegate {
    //MARK: -
    //MARK: - UITableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if (arrForItemSpecification?.count)!>0 {
            return self.arrForItemSpecification![section].list!.count
        }else {
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrForItemSpecification!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifire = "cell"
        var cell:ItemSpecificationCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifire, for: indexPath) as? ItemSpecificationCell
        
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifire) as? ItemSpecificationCell
        }
              let name = (arrForItemSpecification?[indexPath.section].list[indexPath.row].name) ?? ""
        let price = (arrForItemSpecification?[indexPath.section].list[indexPath.row].price) ?? 0.0

        cell?.setCellData(name: name, price: price)

        return cell!
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  sectionHeaderCell = tableView.dequeueReusableCell(withIdentifier: "cellForSection") as! ItemSpecificationSection
        
        if let obj = self.arrForItemSpecification?[section] {
            sectionHeaderCell.setData(item: obj)
        }
        
        return sectionHeaderCell
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        /*if(self.tblItemSpecification.isTableHeadeViewVisible(headerHeight: 250)) {
            self.navigationBar?.backgroundColor = UIColor.themeTransparentNavigationBackgroundColor
            self.btnLeft?.isSelected = false
            self.lblTitle?.text = ""
        }else {
            self.navigationBar?.backgroundColor = UIColor.themeNavigationBackgroundColor
            self.setNavigationTitle(title: selectedItem?.name! ?? "")
            self.lblTitle?.textColor = UIColor.themeTextColor
            self.btnLeft?.isSelected = true
            
        }*/
        
    }
}
//Mark: Class For Item Section
class ItemSpecificationSection: CustomCell {
    
    @IBOutlet weak var lblSection: CustomPaddingLabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            self.backgroundColor = UIColor.themeViewBackgroundColor
            self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
    //        lblSection.textColor = UIColor.themeTextColor
    //        lblSection.font = FontHelper.labelRegular()
            self.lblSection.font = FontHelper.textRegular(size: 14.0)
            self.lblSection.textColor = UIColor.themeTextColor
        }
    
    func setData(item: ItemSpecification) {
        if item.modifierGroupName != "" {
            lblSection.text = item.name + " " + "(\(item.modifierGroupName))"
        } else {
            lblSection.text = item.name
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

//Mark: Class For Item Cell
class ItemSpecificationCell: CustomCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

     override func awakeFromNib() {
         super.awakeFromNib()
         self.backgroundColor = UIColor.themeViewBackgroundColor
         self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
         self.lblName.font = FontHelper.labelSmall(size: 13.0)
         self.lblName.textColor = UIColor.themeTextColor
         
         self.lblPrice.font = FontHelper.labelSmall(size: 13.0)
         self.lblPrice.textColor = UIColor.themeTextColor

     }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellData(name:String,price:Double) {
        self.lblName.text = name
        self.lblPrice.text = price.toCurrencyString()

    }
    @IBAction func onClickSpecifications(sender:Any) {
        
    }
}
extension UITableView{
    

    func isTableHeadeViewVisible(headerHeight:CGFloat = 250)->Bool {
        guard tableHeaderView != nil else {
            return false
        }
        let currentYOffset = self.contentOffset.y;
        return currentYOffset < headerHeight
    }
    func layoutTableHeaderView() {
        
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerWidth = headerView.bounds.size.width;
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["headerView": headerView])
        
        headerView.addConstraints(temporaryWidthConstraints)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        
        frame.size.height = height
        headerView.frame = frame
        
        self.tableHeaderView = headerView
        
        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
}
