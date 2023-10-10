//
//  MyAnimation.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 08/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import QuartzCore

open class MyAnimation {
    
    public static let TransformScale = {
        (layer: CALayer) -> CATransform3D in
            var transform = CATransform3DIdentity
            transform = CATransform3DMakeScale(0.9, 0.9, 1.0)
            return transform
    
    }
    open class func animateCell(_ cell: UITableViewCell, withTransform transform: (CALayer) -> CATransform3D, andDuration duration: TimeInterval) {
        
        let view = cell.contentView
        view.layer.transform = transform(cell.layer)
        view.layer.opacity = 0.8
        
        UIView.animate(withDuration: duration, animations: {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        })
    }
}
