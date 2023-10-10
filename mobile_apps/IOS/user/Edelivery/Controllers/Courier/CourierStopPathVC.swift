//
//  CourierStopPathVC.swift
//  Edelivery
//
//  Created by MacPro3 on 13/10/22.
//  Copyright © 2022 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps

class CourierStopPathVC: UIViewController {

    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var btnClose: UIButton!
    
    var arrAddress = [Address]()
    var googlePathResponse: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnClose.setImage(UIImage.init(named: "close_icon_theme"), for: .normal)
        
        self.viewMap.settings.allowScrollGesturesDuringRotateOrZoom = false
        
        setPath()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewMap.clear()
        viewMap = nil
    }
    
    @IBAction func onClickClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func setPath() {
        guard let googlePathResponse = googlePathResponse else {
            return
        }
        
        if let routes = googlePathResponse["routes"] as? [[String:Any]] {
            if let rout = routes.first {
                if let overview_polyline = rout["overview_polyline"] as? [String:Any] {
                    if let points = overview_polyline["points"] as? String {
                        self.drawPath(with: points)
                    }
                }
            }
        }
    }

    private func drawPath(with points : String) {
        let path = GMSPath(fromEncodedPath: points)
        let polyLinePath = GMSPolyline(path: path)
        polyLinePath.strokeColor = UIColor.themeGooglePath
        polyLinePath.strokeWidth = 5.0
        polyLinePath.geodesic = true
        polyLinePath.map = self.viewMap
        
        focusMap()
    }

    func focusMap() {
        
        var bounds = GMSCoordinateBounds()
        
        var count = 1
        for arrAddress in arrAddress {
            let marker = GMSMarker.init(position: CLLocationCoordinate2D(latitude: arrAddress.location[0], longitude: arrAddress.location[1]))
            marker.map = viewMap
            //marker.title = arrAddress.address
            //marker.icon = UIImage(named: "map_fill")
            bounds = bounds.includingCoordinate(marker.position)
            
            let img = UIImageView(image: UIImage(named: "map_fill")!.imageWithColor(color: .themeColor))
            img.frame.size = CGSize(width: 30, height: 30)
            
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
            lbl.text = "\(count)"
            lbl.textColor = .white
            lbl.backgroundColor = .themeColor
            lbl.textAlignment = .center
            lbl.setRound()
            img.addSubview(lbl)
            marker.iconView = img
            //marker.iconView?.addSubview(lbl)
            lbl.center = marker.iconView?.center ?? CGPoint(x: 0, y: 0)
            lbl.center.y = img.frame.size.height/2.5
            
            count += 1
        }
        
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        viewMap.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 20))
        CATransaction.commit()
    }
}
