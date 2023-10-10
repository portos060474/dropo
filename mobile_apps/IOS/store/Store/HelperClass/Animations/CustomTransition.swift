//
//  CustomTransition.swift
//  Custom Transitions
//
//  Created by Jaydeep Vyas on 02/02/17.
//  Copyright © 2017 tutsplus. All rights reserved.
//

//import UIKit
//enum TransitionFromTo
//{
//    case StoreToProduct
//    case ProductToStore
//    case ProductSpecificationToProduct
//    case ProductToProductSpecification
//    case xyz
//}
//struct StoreToProductData
//{
//    static var imgStore:UIImage?
//    static var viewForStore:UIView?
//    static var imgOriginFrame:CGRect?
//    static var viewOriginFrame:CGRect?
//    static var imgDestFrame:CGRect?
//    static var viewDestFrame:CGRect?
//    
//    
//}
//class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning
//{
//
//    var transtionFromTo = TransitionFromTo.StoreToProduct
//    let duration    = 0.3
//    var sourceView:UIView?
//    var image:UIImage?
//    var presenting  = true
//    var originFrame = CGRect.zero
//    var destinationFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)-> TimeInterval
//    {
//        return duration
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
//    {
//        let containerView = transitionContext.containerView
//        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
//        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
//        let fromView = (fromVC?.view)!
//        //transitionContext.view(forKey: UITransitionContextViewKey.from)!
//        let toView = (toVC?.view)!
//        //transitionContext.view(forKey: UITransitionContextViewKey.to)!
//        switch transtionFromTo
//        {
//        case .StoreToProduct:
//            storeToProductAnimation(fromVC: fromVC!, toVC: toVC!, fromView: fromView, toView: toView, containerView: containerView, completion: { (completion) in
//                    transitionContext.completeTransition(true);
//            })
//            
//                break;
//        case .ProductToStore:
//            productToStoreAnimation(fromVC: fromVC!, toVC: toVC!, fromView: fromView, toView: toView, containerView: containerView, completion: { (completion) in
//                transitionContext.completeTransition(true);
//            })
//            break;
//        case .ProductToProductSpecification:
//            productToProductSpecificationAnimation(fromVC: fromVC!, toVC: toVC!, fromView: fromView, toView: toView, containerView: containerView, completion: { (completion) in
//                transitionContext.completeTransition(true);
//            })
//            break;
//        case .ProductSpecificationToProduct:
//                productSpecificationToProductAnimation(fromVC: fromVC!, toVC: toVC!, fromView: fromView, toView: toView, containerView: containerView, completion: { (completion)
//                in
//                transitionContext.completeTransition(true);
//                toView.tag = 504;
//               UIApplication.shared.keyWindow?.addSubview(toView)
//            })
//            break;
//        default:
//            print("transition not found")
//            break
//            
//        }
//    }
//    
// //MARK: - PUSH ANIMATION
//    func storeToProductAnimation(fromVC:UIViewController, toVC:UIViewController,fromView:UIView, toView:UIView, containerView:UIView,completion: @escaping (_ result: Bool) -> Void)
//    {
//        
//        
//        let productVC = (toVC as! UINavigationController).viewControllers[0] as! ProductVC
//        productVC.view.layoutIfNeeded();
//      
//        let imageOriginFrame = StoreToProductData.imgOriginFrame
//        let imageDestinationFrame = productVC.imgStore.frame
//        let storeDestinationFrame = productVC.viewForStore.frame
//        let storeOriginFrame = CGRect.init(x: storeDestinationFrame.minX, y: originFrame.minY + (imageOriginFrame?.height)!, width: storeDestinationFrame.width, height:storeDestinationFrame.height)
//        
//        
//        StoreToProductData.imgDestFrame = imageDestinationFrame
//        StoreToProductData.viewDestFrame = storeDestinationFrame
//        StoreToProductData.imgOriginFrame = imageOriginFrame
//        StoreToProductData.viewOriginFrame = storeOriginFrame
//        
//    
//        let storeView = StoreToProductData.viewForStore!
//        storeView.frame = storeOriginFrame
//        
//        
//        
//        
//        
//        let imageView:UIImageView = UIImageView.init(frame: imageOriginFrame!)
//        imageView.image = StoreToProductData.imgStore
//        
//        
//        
//        let alphaView:UIView = UIView.init(frame: fromView.frame)
//        alphaView.backgroundColor = UIColor.white
//        alphaView.alpha = 1.0
//      
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
//        imageView.clipsToBounds = true
//        
//       
//        containerView.addSubview(alphaView)
//        containerView.addSubview(imageView)
//        containerView.addSubview(storeView)
//        
//        
//        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations:
//            {
//                imageView.frame = imageDestinationFrame
//                imageView.center = CGPoint(x: imageDestinationFrame.midX,
//                                           y: imageDestinationFrame.midY)
//                storeView.frame = storeDestinationFrame
//                storeView.center = CGPoint(x: storeDestinationFrame.midX,
//                                           y: storeDestinationFrame.midY)
//                 storeView.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize(width: -1, height: 1), shadowOpacity: 0.5, shadowRadius: 5)
//        })
//        { (_) in
//            completion(true);
//            imageView.removeFromSuperview()
//            storeView.removeFromSuperview()
//            alphaView.removeFromSuperview()
//            containerView.addSubview(toView)
//          
//            
//        }
//    }
//    
//    
//    func productToProductSpecificationAnimation(fromVC:UIViewController, toVC:UIViewController, fromView:UIView, toView:UIView, containerView:UIView,completion: @escaping (_ result: Bool) -> Void)
//    {
//        
//        
//        
//        let productSpecificationVC = (toVC as! UINavigationController).viewControllers[0] as! ProductSpecificationVC
//        productSpecificationVC.view.layoutIfNeeded();
//        destinationFrame = productSpecificationVC.collectionForItemImages.frame
//        let alphaView:UIView = UIView.init(frame: fromView.frame)
//        alphaView.backgroundColor = UIColor.white
//        alphaView.alpha = 1.0
//        containerView.addSubview(alphaView)
//        let imageView:UIImageView = UIImageView.init(frame: originFrame)
//        imageView.image = image
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
//        imageView.clipsToBounds = true
//        containerView.addSubview(imageView)
//        containerView.bringSubview(toFront: imageView)
//        imageView.backgroundColor = UIColor.white
//        imageView.alpha = 1.0
//       
//        
//        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations:
//            {
//                imageView.frame = self.destinationFrame
//                imageView.center = CGPoint(x: self.destinationFrame.midX,
//                                           y: self.destinationFrame.midY)
//        })
//        { (_) in
//            completion(true);
//                imageView.removeFromSuperview()
//                alphaView.removeFromSuperview()
//                containerView.addSubview(toView)
//        }
//    }
//    
////MARK: - POP ANIMATION
//    
//    
//    func productToStoreAnimation(fromVC:UIViewController, toVC:UIViewController, fromView:UIView, toView:UIView, containerView:UIView,completion: @escaping (_ result: Bool) -> Void)
//    {
//      
//        
//        
//        
//        let imageOriginFrame = StoreToProductData.imgDestFrame
//        let storeOriginFrame = StoreToProductData.viewDestFrame
//        let imageDestinationFrame = StoreToProductData.imgOriginFrame
//        
//        let storeDestinationFrame = StoreToProductData.viewOriginFrame!
//        let storeView:UIView = StoreToProductData.viewForStore!
//        let imageView:UIImageView = UIImageView.init(frame:imageOriginFrame!)
//       
//        
//   
//        imageView.image = StoreToProductData.imgStore!
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
//        imageView.clipsToBounds = true
//     
//        
//        
//        if let view = UIApplication.shared.keyWindow?.viewWithTag(504)
//        {
//            view.removeFromSuperview()
//        }
//        storeView.frame = storeOriginFrame!
//        imageView.frame = imageOriginFrame!
//        let alphaView:UIView = UIView.init(frame: fromView.frame)
//        alphaView.backgroundColor = UIColor.white
//        alphaView.alpha = 1.0
//        containerView.addSubview(alphaView)
//        containerView.addSubview(imageView)
//        containerView.addSubview(storeView)
//        
//        toView.alpha = 1.0
//        UIView.animate(withDuration:duration, delay: 0.0, options: [], animations:
//            {
//                imageView.frame = imageDestinationFrame!
//                imageView.center = CGPoint(x: (imageDestinationFrame?.midX)!,
//                                           y: (imageDestinationFrame?.midY)!)
//                storeView.frame = storeDestinationFrame
//                storeView.center = CGPoint(x: storeDestinationFrame.midX,
//                                           y: storeDestinationFrame.midY)
//                storeView.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize(width: -1, height: 1), shadowOpacity: 0.4, shadowRadius: 4)
//        })
//        { (_) in
//            completion(true);
//            imageView.removeFromSuperview()
//            storeView.removeFromSuperview()
//            alphaView.removeFromSuperview()
//        }
//    }
//    
//    func productSpecificationToProductAnimation(fromVC:UIViewController, toVC:UIViewController, fromView:UIView, toView:UIView, containerView:UIView,completion: @escaping (_ result: Bool) -> Void)
//    {
//        containerView.addSubview(toView)
//        let imageView:UIImageView = UIImageView.init(frame: originFrame)
//        imageView.image = image
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
//        imageView.clipsToBounds = true
//        containerView.addSubview(imageView)
//        containerView.addSubview(toView)
//        containerView.bringSubview(toFront: imageView)
//        
//        toView.alpha = 0.0
//        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations:
//            {
//                imageView.frame = self.destinationFrame
//                imageView.transform = CGAffineTransform.identity
//                imageView.center = CGPoint(x: self.destinationFrame.midX,y: self.destinationFrame.midY)
//                toView.alpha = 1.0
//                toView.frame = fromView.frame;
//                
//        })
//        { (_) in
//            completion(true);
//            imageView.removeFromSuperview()
//            
//        }
//        
//    }
//
//}
