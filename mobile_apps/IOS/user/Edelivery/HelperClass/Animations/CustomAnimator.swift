//
//  CustomAnimator.swift
//  CustomNavigationAnimations-Complete
//
//  Created by Sam Stone on 29/09/2017.
//  Copyright © 2017 Sam Stone. All rights reserved.
//

import UIKit


enum TransitionFromTo {
    case StoreToProduct
    case ProductToStore
    case ProductSpecificationToProduct
    case ProductToProductSpecification
    case xyz
}
struct StoreToProductData {
    var imgStore:UIImage = UIImage.init()
    var viewForStore:UIView = UIView.init()
    var imgOriginFrame:CGRect = CGRect.zero
    var viewOriginFrame:CGRect = CGRect.zero
    var imgDestFrame:CGRect = CGRect.zero
    var viewDestFrame:CGRect = CGRect.zero
}
struct ProductToProductSpecification {
    var image:UIImage = UIImage.init()
    var imgOriginFrame:CGRect = CGRect.zero
    var imgDestFrame:CGRect = CGRect.zero
}
class CustomAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var duration : TimeInterval
    var isPresenting : Bool
    var transtionFromTo = TransitionFromTo.StoreToProduct
    var storeToProductData: StoreToProductData = StoreToProductData.init()
    var productToProductSpecificationData: ProductToProductSpecification = ProductToProductSpecification.init()
    
    init(duration : TimeInterval, isPresenting : Bool) {
        self.duration = duration
        self.isPresenting = isPresenting
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromView = (fromVC?.view)!
        let toView = (toVC?.view)!
        self.isPresenting ? containerView.addSubview(toView) : containerView.insertSubview(toView, belowSubview: fromView)

        switch transtionFromTo {
        case .StoreToProduct:
            self.storeToProductAnimation(fromVC: fromVC!, toVC: toVC!, fromView: fromView, toView: toView, containerView: containerView, completion: { (completion) in
                transitionContext.completeTransition(true)
            })
           break
        case .ProductToStore:
            self.productToStoreAnimation(fromVC: fromVC!, toVC: toVC!, fromView: fromView, toView: toView, containerView: containerView, completion: { (completion) in
                transitionContext.completeTransition(true)
            })
            break
        case .ProductToProductSpecification:
            self.productToProductSpecificationAnimation(fromVC: fromVC!, toVC: toVC!, fromView: fromView, toView: toView, containerView: containerView, completion: { (completion) in
                transitionContext.completeTransition(true)
            })
            break
        case .ProductSpecificationToProduct:
            self.productSpecificationToProductAnimation(fromVC: fromVC!, toVC: toVC!, fromView: fromView, toView: toView, containerView: containerView) { (completion) in
                transitionContext.completeTransition(true)
            }
            break
        default:
            break
            
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
}

extension CustomAnimator {
    func storeToProductAnimation(fromVC:UIViewController, toVC:UIViewController,fromView:UIView, toView:UIView, containerView:UIView,completion: @escaping (_ result: Bool) -> Void) {
        
        
        let productVC = toVC as! ProductVC
            productVC.view.layoutIfNeeded()
        
        let imageOriginFrame = self.storeToProductData.imgOriginFrame
        var imageDestinationFrame = productVC.imgStore.frame
        let storeDestinationFrame = productVC.viewForStore.frame
        let storeOriginFrame = CGRect.init(x: storeDestinationFrame.minX, y: imageOriginFrame.maxY, width: storeDestinationFrame.width, height:storeDestinationFrame.height)
        
        imageDestinationFrame.origin.y = 0
        self.storeToProductData.imgDestFrame = imageDestinationFrame
        self.storeToProductData.viewDestFrame = storeDestinationFrame
        self.storeToProductData.imgOriginFrame = imageOriginFrame
        self.storeToProductData.viewOriginFrame = storeOriginFrame
        
        
        var  storeView: UIView = UIView()
        
        if let from = fromVC as? StoreVC {
            if from.selectedFrom == .fromTableView {
                let indexPath = IndexPath(row: (fromVC as! StoreVC).selectedIndex, section: 0)
                let selectedCell:StoreCell = (fromVC as! StoreVC).tblForStoreList.cellForRow(at: indexPath) as! StoreCell
                
                storeView = selectedCell.viewForStore.snapshotView(afterScreenUpdates: true) ?? UIView.init()
                storeView.frame = storeOriginFrame
                self.storeToProductData.viewForStore = storeView
                containerView.addSubview(storeView)
            }
        }
        
       
        let imageView:UIImageView = UIImageView.init(frame: imageOriginFrame)
            imageView.image = self.storeToProductData.imgStore
            imageView.contentMode = UIView.ContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            
        let alphaView:UIView = UIView.init(frame: UIScreen.main.bounds)
            alphaView.backgroundColor = UIColor.white
            alphaView.alpha = 1.0
            
            
            containerView.addSubview(alphaView)
            containerView.addSubview(imageView)
        
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
                    imageView.frame = imageDestinationFrame
                    imageView.center = CGPoint(x: imageDestinationFrame.midX,
                                               y: imageDestinationFrame.midY)
                    
                    if let from = fromVC as? StoreVC {
                        if from.selectedFrom == .fromTableView {
                            storeView.frame = storeDestinationFrame
                            storeView.center = CGPoint(x: storeDestinationFrame.midX,
                                                       y: storeDestinationFrame.midY)
                            storeView.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 0.0), shadowOpacity: 0.5, shadowRadius: 3.0)
                        }
                    }
            }) { (_) in
                imageView.removeFromSuperview()
                if let from = fromVC as? StoreVC {
                    if from.selectedFrom == .fromTableView {
                        storeView.removeFromSuperview()
                    }
                }
                
                alphaView.removeFromSuperview()
                completion(true)
            }
     }
    
    func productToStoreAnimation(fromVC:UIViewController, toVC:UIViewController, fromView:UIView, toView:UIView, containerView:UIView,completion: @escaping (_ result: Bool) -> Void) {
        
        let imageOriginFrame = self.storeToProductData.imgDestFrame
        let storeOriginFrame = self.storeToProductData.viewDestFrame
        let imageDestinationFrame = self.storeToProductData.imgOriginFrame
        let storeDestinationFrame = self.storeToProductData.viewOriginFrame
        
        
        let storeView:UIView =   self.storeToProductData.viewForStore
        let imageView:UIImageView = UIImageView.init(frame:imageOriginFrame)
        imageView.image = self.storeToProductData.imgStore
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        
        if let view = UIApplication.shared.keyWindow?.viewWithTag(504) {
            view.removeFromSuperview()
        }
        storeView.frame = storeOriginFrame
        imageView.frame = imageOriginFrame
        let alphaView:UIView = UIView.init(frame: UIScreen.main.bounds)
        alphaView.backgroundColor = UIColor.white
        alphaView.alpha = 1.0
        
        
        containerView.addSubview(alphaView)
        containerView.addSubview(imageView)
        containerView.addSubview(storeView)
        
        toView.alpha = 1.0
        UIView.animate(withDuration:duration, delay: 0.0, options: [], animations: {
                imageView.frame = imageDestinationFrame
                imageView.center = CGPoint(x: (imageDestinationFrame.midX),
                                           y: (imageDestinationFrame.midY))
                storeView.frame = storeDestinationFrame
                storeView.center = CGPoint(x: storeDestinationFrame.midX,
                                           y: storeDestinationFrame.midY)
                storeView.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize(width: -1, height: 1), shadowOpacity: 0.4, shadowRadius: 4)
        }) { (_) in
            
            alphaView.removeFromSuperview()
            imageView.removeFromSuperview()
            storeView.removeFromSuperview()
            completion(true)
            
        }
    }
    
    func productToProductSpecificationAnimation(fromVC:UIViewController, toVC:UIViewController, fromView:UIView, toView:UIView, containerView:UIView,completion: @escaping (_ result: Bool) -> Void) {
        let productSpecificationVC = toVC as!  ProductSpecificationVC
        productSpecificationVC.view.layoutIfNeeded()
        self.productToProductSpecificationData.imgDestFrame = productSpecificationVC.collectionForItems.frame
        let alphaView:UIView = UIView.init(frame: UIScreen.main.bounds)
        alphaView.backgroundColor = UIColor.white
        alphaView.alpha = 1.0
        containerView.addSubview(alphaView)
        let imageView:UIImageView = UIImageView.init(frame: self.productToProductSpecificationData.imgOriginFrame)
        
        imageView.image = self.productToProductSpecificationData.image
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        containerView.addSubview(imageView)
        containerView.bringSubviewToFront(imageView)
        imageView.backgroundColor = UIColor.white
        imageView.alpha = 1.0
        
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
                imageView.frame = self.productToProductSpecificationData.imgDestFrame
                imageView.center = CGPoint(x: self.productToProductSpecificationData.imgDestFrame.midX,
                                           y: self.productToProductSpecificationData.imgDestFrame.midY)
        }) { (_) in
            
            imageView.removeFromSuperview()
            alphaView.removeFromSuperview()
            completion(true)
        }
    }
    
    func productSpecificationToProductAnimation(fromVC:UIViewController, toVC:UIViewController, fromView:UIView, toView:UIView, containerView:UIView,completion: @escaping (_ result: Bool) -> Void) {
        containerView.addSubview(toView)
        let imageView:UIImageView = UIImageView.init(frame: self.productToProductSpecificationData.imgOriginFrame)
        imageView.image = self.productToProductSpecificationData.image
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        containerView.addSubview(imageView)
        containerView.bringSubviewToFront(imageView)
        
        toView.alpha = 0.0
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
                imageView.frame = self.productToProductSpecificationData.imgDestFrame
                imageView.transform = CGAffineTransform.identity
                imageView.center = CGPoint(x: self.productToProductSpecificationData.imgDestFrame.midX,y: self.productToProductSpecificationData.imgDestFrame.midY)
                toView.alpha = 1.0
                toView.frame = fromView.frame
                
        }) { (_) in
            
            imageView.removeFromSuperview()
            completion(true)
        }
    }
}

