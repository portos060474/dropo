//
//  SplashVC.swift
//  Store
//
//  Created by Disha Ladani on 18/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class SplashVC: BaseVC {
    
    @IBOutlet var splash: UIImageView!
    @IBOutlet var viewForTutorial: UIView!
    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var collectionForTutorial: UICollectionView!
    @IBOutlet var pgForTutorial: UIPageControl!
    
    let arrForTutorialImage:[String] = ["tuto1","tuto3","tuto2"]
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        wsGetAppSetting()
        if preferenceHelper.getRandomCartID().isEmpty {
            preferenceHelper.setRandomCartID(String.random(length: 20))
        }
        
        var mainView: UIStoryboard!
               
        mainView = UIStoryboard(name: "Delivery", bundle: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSkip.setTitle("TXT_SKIP".localizedCapitalized, for: .normal)
        btnSkip.setTitleColor(UIColor.themeSectionBackgroundColor, for: .normal)
        btnSkip.titleLabel?.font = FontHelper.buttonText()
        pgForTutorial.tintColor = UIColor.gray
        pgForTutorial.currentPageIndicatorTintColor = UIColor.themeSectionBackgroundColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
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
    
    func showTutorial() {
        if  preferenceHelper.getSessionToken().isEmpty() {
            if preferenceHelper.getIsShowTutorial() {
                viewForTutorial.isHidden = false
                pgForTutorial.numberOfPages = arrForTutorialImage.count
                pgForTutorial.currentPage = 0
                self.collectionForTutorial.reloadData()
                preferenceHelper.setIsShowTutorial(false)
            }else {
                viewForTutorial.isHidden = true
                preferenceHelper.setIsShowTutorial(false)
                APPDELEGATE.goToMain()
            }
            return
        }else {
            viewForTutorial.isHidden = true
            preferenceHelper.setIsShowTutorial(false)
            APPDELEGATE.goToMain()
            return
        }
    }
    
    @IBAction func onClickBtnSkip(_ sender: Any) {
        preferenceHelper.setIsShowTutorial(false)
        APPDELEGATE.goToMain()
    }
    @IBAction func onClickBtnNext(_ sender: UIButton) {
        if sender.tag <= (arrForTutorialImage.count-1) {
            let nextIndexPath = IndexPath(item: sender.tag+1, section: 0)
            if #available(iOS 14.0, *) {
                self.collectionForTutorial.isPagingEnabled = false
                self.collectionForTutorial?.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                self.collectionForTutorial.isPagingEnabled = true
            }
            else {
                self.collectionForTutorial?.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            }
            pgForTutorial.currentPage = nextIndexPath.row
        }
    }
    //MARK:- Web Serivice Calls
    func wsGetAppSetting(){
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        
        let dictParam : [String : Any] = [PARAMS.DEVICE_TYPE: CONSTANT.IOS,
                                          PARAMS.TYPE:CONSTANT.TYPE_USER]
        
        print(dictParam)
         afh.getResponseFromURL(url: WebService.WS_GET_SETTING_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self](response, error) -> (Void) in
            print(response)
            guard let self = self else { return }
            if (error != nil) {
                self.openServerErrorDialog()
            }else{
                if(Parser.parseAppSettingDetail(response: response)) {

                    let setting:SettingDetailResponse = SettingDetailResponse.init(dictionary: response)!
                    
                    if (setting.isOpenUpdateDialog! &&  self.isUpdateAvailable(preferenceHelper.getLatestAppVersion())) {
                        self.openUpdateAppDialog(isForceUpdate: preferenceHelper.getIsRequiredForceUpdate())
                    }else {
                        self.showTutorial()
                    }
                }
            }
        }
    }
    
    func isUpdateAvailable(_ latestVersion: String) -> Bool{
        
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        let myCurrentVersion: [String] = currentAppVersion.components(separatedBy: ".")
        let myLatestVersion: [String] = latestVersion.components(separatedBy: ".")
        let legthOfLatestVersion: Int = myLatestVersion.count
        let legthOfCurrentVersion: Int = myCurrentVersion.count
        if legthOfLatestVersion == legthOfCurrentVersion {
            for i in 0..<myLatestVersion.count {
                if CInt(myCurrentVersion[i])! < CInt(myLatestVersion[i])! {
                    return true
                }else if CInt(myCurrentVersion[i]) == CInt(myLatestVersion[i]) {
                    continue
                }else {
                    return false
                }
            }
            return false
        }else {
            let count: Int = legthOfCurrentVersion > legthOfLatestVersion ? legthOfLatestVersion : legthOfCurrentVersion
            for i in 0..<count {
                if CInt(myCurrentVersion[i])! < CInt(myLatestVersion[i])! {
                    return true
                }else if CInt(myCurrentVersion[i])! > CInt(myLatestVersion[i])! {
                    return false
                }else if CInt(myCurrentVersion[i]) == CInt(myLatestVersion[i]) {
                    continue
                }
            }
            if legthOfCurrentVersion < legthOfLatestVersion {
                for i in legthOfCurrentVersion..<legthOfLatestVersion {
                    if CInt(myLatestVersion[i]) != 0 {
                        return true
                    }
                }
                return false
            }else {
                return false
            }
        }
    }
    
    //MARK:- Dialogs
    func openUpdateAppDialog(isForceUpdate:Bool){
        if isForceUpdate {
            let dialogForUpdateApp = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_UPDATE_APP".localized, titleLeftButton: "TXT_EXIT".localizedCapitalized, titleRightButton: "TXT_UPDATE".localizedCapitalized)
            dialogForUpdateApp.onClickLeftButton = { [unowned dialogForUpdateApp] in
                dialogForUpdateApp.removeFromSuperview()
                exit(0)
            }
            dialogForUpdateApp.onClickRightButton = { [unowned dialogForUpdateApp] in
                if let url = URL(string: CONSTANT.UPDATE_URL),
                    UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                dialogForUpdateApp.removeFromSuperview()
            }
        }else {
            let dialogForUpdateApp = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_UPDATE_APP".localized, titleLeftButton: "TXT_CANCEL".localizedCapitalized, titleRightButton: "TXT_UPDATE".localizedCapitalized)
            dialogForUpdateApp.onClickLeftButton = { [unowned self, unowned dialogForUpdateApp] in
                dialogForUpdateApp.removeFromSuperview()
                self.showTutorial()
            }
            dialogForUpdateApp.onClickRightButton = { [unowned dialogForUpdateApp] in
                if let url = URL(string: CONSTANT.UPDATE_URL),
                    UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                dialogForUpdateApp.removeFromSuperview()
            }
        }
    }
    
    func openServerErrorDialog(){
        let dialogForServerError = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_SERVER_ERROR".localized, titleLeftButton: "TXT_EXIT".localizedCapitalized, titleRightButton: "TXT_RETRY".localizedCapitalized)
        dialogForServerError.onClickLeftButton = { [unowned dialogForServerError] in
            dialogForServerError.removeFromSuperview()
            exit(0)
        }
        dialogForServerError.onClickRightButton = { [unowned dialogForServerError] in
            dialogForServerError.removeFromSuperview()
            self.wsGetAppSetting()
        }
    }
}

extension SplashVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrForTutorialImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tutorialCell", for: indexPath) as!
        TutorialCollectionViewCell
        cell.tutorialImageView.image =
            UIImage.init(named: arrForTutorialImage[indexPath.row])!
        cell.tutorialImageView.contentMode = .scaleAspectFit
        cell.tutorialImageView.clipsToBounds = true
        cell.tutorialImageView.layer.masksToBounds = true
        cell.lblTitle.text = "TXT_INTRO_TITLE\(indexPath.item)".localized
        cell.lblMsg.text = "TXT_INTRO_MSG\(indexPath.item)".localized
        cell.btnSkip.addTarget(self, action: #selector(onClickBtnSkip(_:)), for: .touchUpInside)
        cell.btnNext.addTarget(self, action: #selector(onClickBtnNext(_:)), for: .touchUpInside)
        cell.btnNext.tag = indexPath.item
        cell.btnNext.isHidden = (indexPath.item == (arrForTutorialImage.count-1)) ? true : false
        if indexPath.item == 0 {
            cell.lblPage1.backgroundColor = .themeColor
            cell.lblPage2.backgroundColor = .themeDisableButtonBackgroundColor
            cell.lblPage3.backgroundColor = .themeDisableButtonBackgroundColor
        }
        else if indexPath.item == 1 {
            cell.lblPage1.backgroundColor = .themeDisableButtonBackgroundColor
            cell.lblPage2.backgroundColor = .themeColor
            cell.lblPage3.backgroundColor = .themeDisableButtonBackgroundColor
        }
        else {
            cell.lblPage1.backgroundColor = .themeDisableButtonBackgroundColor
            cell.lblPage2.backgroundColor = .themeDisableButtonBackgroundColor
            cell.lblPage3.backgroundColor = .themeColor
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionForTutorial {
            var currentCellOffset = self.collectionForTutorial?.contentOffset
            currentCellOffset?.x += (self.collectionForTutorial?.frame.width)! / 2
            if let indexPath = self.collectionForTutorial?.indexPathForItem(at: currentCellOffset!) {
                if #available(iOS 14.0, *) {
                    self.collectionForTutorial.isPagingEnabled = false
                    self.collectionForTutorial?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    self.collectionForTutorial.isPagingEnabled = true
                }
                else {
                    self.collectionForTutorial?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
                pgForTutorial.currentPage = indexPath.row
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width + 5, height: UIScreen.main.bounds.height + 5)
    }
    override func updateFocusIfNeeded() {
        collectionForTutorial.reloadData()
    }
}

class TutorialCollectionViewCell: CustomCollectionCell {
    
    @IBOutlet weak var tutorialImageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblPage1: UILabel!
    @IBOutlet weak var lblPage2: UILabel!
    @IBOutlet weak var lblPage3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        tutorialImageView.contentMode = .scaleAspectFit
        lblTitle.textColor = .themeTitleColor
        lblTitle.font = FontHelper.textLargest()
        lblMsg.textColor = .themeLightTextColor
        lblMsg.font = FontHelper.textMedium()
        btnNext.titleLabel?.font = FontHelper.textMedium()
        btnNext.setTitle("TXT_NEXT".localized, for: .normal)
        btnSkip.titleLabel?.font = FontHelper.textMedium()
        btnSkip.setTitle("TXT_SKIP_NOW".localized, for: .normal)
        btnSkip.titleLabel?.textColor = .themeColor
        btnSkip.tintColor = .themeColor
        lblPage1.backgroundColor = .themeDisableButtonBackgroundColor
        lblPage2.backgroundColor = .themeDisableButtonBackgroundColor
        lblPage3.backgroundColor = .themeDisableButtonBackgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any]
{
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
