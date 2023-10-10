//
//  ReviewVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ReviewVC: BaseVC
{
   
 
   
//MARK: View life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setLocalization()
     }
    override func viewWillAppear(_ animated: Bool)
    {
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
    func setupLayout(){
       
        
    }
    func setLocalization()
    {
        view.backgroundColor = UIColor.themeTitleColor;
        self.hideBackButtonTitle()
        
        /*set Titles*/
        
       
    }
//MARK:
//MARK: Button action methods
  
    @IBAction func onClickBtnShare(_ sender: Any)
    {
        
       /* let myString = String(format: NSLocalizedString("SHARE_REFERRAL", comment: ""),String(preferenceHelper.getReferralCode()))
        

        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
        */
        
    }
    
    
}
