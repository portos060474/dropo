//
//  ProductItemImageViewerVC.swift
//  edelivery
//
//  Created by Elluminati on 09/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ProductItemImageViewerVC: BaseVC
{
    
  
//MARK:- OUTLETS
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGradient: UILabel!
    @IBOutlet weak var pgControl: UIPageControl!
    @IBOutlet weak var collectionForItemImages: UICollectionView!
    var arrImageList:[String]? = nil;
    //MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pgControl.numberOfPages = arrImageList?.count ?? 0
        if pgControl.numberOfPages == 1 {
            pgControl.isHidden = true
            lblGradient.isHidden = true
        }
        collectionForItemImages.reloadData()
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        setupLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        
    }
    func setLocalization(){
        
        lblGradient.text = ""
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        pgControl.currentPageIndicatorTintColor = UIColor.black
        pgControl.pageIndicatorTintColor = UIColor.gray
        
        /* Set Font */
    }
    
    func setupLayout()
    {
        lblGradient.setGradient(startColor:UIColor.themeEndGradientColor,endColor:UIColor.themeStartGradientColor)
    }
  
    //Action Method
    @IBAction func onClickBtnBack(_ sender: Any)
    {
        self.presentingViewController?.dismiss(animated: true, completion: {
        })
        
    }
}
extension ProductItemImageViewerVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrImageList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollection
        cell.imgProductItem.contentMode = UIView.ContentMode.scaleAspectFill
        cell.imgProductItem.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: cell.imgProductItem.frame.width, height:
                                                                                         cell.imgProductItem.frame.height, imgUrl: (arrImageList![indexPath.row])),isFromResize: true)
        return cell
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
   
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator)
    {
        collectionForItemImages.collectionViewLayout.invalidateLayout()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
