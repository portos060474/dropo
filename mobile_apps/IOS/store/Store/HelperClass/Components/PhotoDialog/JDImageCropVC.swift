
import UIKit

class JDImageCropVC: BaseVC, UIScrollViewDelegate {
    var onImageCropped : ((UIImage) -> Void)? = nil
    
/*Used to get aspect width and height of image*/
  var aspectW: CGFloat!
  var aspectH: CGFloat!

/*Used to set image*/
  var scrollView: UIScrollView!
  var imageView: UIImageView!
  var img: UIImage!
    
/*Used to cancel or crop the image*/
  var closeButton: UIButton!
  var cropButton: UIButton!

/*Used to display current image resolution and required resolution image*/
  var lblCurrentImageSize: UILabel!
  
  var lblMsg: UILabel!
    
    
  
  var holeRect: CGRect!
  var cropView:hollowView? = nil
    
    
  var originalImageSize:CGSize = CGSize.zero
  var cropImageSize:CGSize = CGSize.zero
    var maxWidth:Int = 0
    var maxHeight:Int = 0
    var minWidth:Int = 0
    var minHeight:Int = 0
    
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
    init(frame: CGRect, image: UIImage, maxWidth: Int, maxHeight: Int, minWidth: Int , minHeight: Int, message:String = "")
  {
    super.init(nibName: nil, bundle: nil)
    
    lblCurrentImageSize = UILabel.init(frame: CGRect(x: view.frame.minX + 10 , y: view.frame.maxY/2 , width: view.frame.width - 20, height: 40))
    
    
    aspectW = CGFloat(maxWidth)
    aspectH = CGFloat(maxHeight)
    
    self.maxHeight = maxHeight
    self.maxWidth = maxWidth
    self.minHeight = minHeight
    self.minWidth = minWidth
    view.frame = frame

    originalImageSize = CGSize.init(width: (image.size.width * image.scale), height: (image.size.height * image.scale))

    if (image.imageOrientation != .up) {
      UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
      var rect = CGRect.zero
      rect.size = image.size
      image.draw(in: rect)
      img = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    } else {
      img = image
    }
    
    setupView()
    
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  func setupView()
  {
    closeButton = UIButton(frame: CGRect(x: 0, y: view.frame.origin.y , width: view.frame.width/2, height: 50))
    closeButton.setTitle("Cancel", for: .normal)
    closeButton.titleLabel?.font = FontHelper.textMedium(size: FontHelper.large)
    closeButton.addTarget(self, action: #selector(tappedClose), for: .touchUpInside)
    
    
    cropButton = UIButton(frame: CGRect(x: view.frame.width/2, y: view.frame.origin.y , width: view.frame.width/2, height: 50))
    cropButton.setTitle("Done", for: .normal)
    cropButton.titleLabel?.font = FontHelper.textMedium(size: FontHelper.large)
    cropButton.addTarget(self, action: #selector(tappedCrop), for: .touchUpInside)
    
    
   
    view.backgroundColor = UIColor.gray
    
    // TODO: improve to handle super tall aspects (this one assumes full width)
    let holeWidth = view.frame.width
    let holeHeight = holeWidth * aspectH/aspectW
    holeRect = CGRect(x: 0, y: view.frame.height/2-holeHeight/2, width: holeWidth, height: holeHeight)
    cropView = hollowView(frame: view.frame, transparentRect: holeRect)
    

    /*Imageview Adjustment*/
    imageView = UIImageView(image: img)
    imageView.contentMode = UIView.ContentMode.center
    imageView.frame = CGRect.zero
    imageView.sizeToFit()

    
    /* Scroll view adjustment*/
    scrollView = UIScrollView(frame: view.bounds)
    scrollView.addSubview(imageView)
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.alwaysBounceHorizontal = true
    scrollView.alwaysBounceVertical = true
    scrollView.delegate = self
    scrollView.contentSize = imageView.frame.size
    let gapToTheHole = view.frame.height/2-holeRect.height/2
    scrollView.contentInset = UIEdgeInsets.init(top: gapToTheHole, left: 0, bottom: gapToTheHole, right: 0)
    let minZoom = max(holeWidth / imageView!.bounds.width, holeHeight / imageView!.bounds.height)
    scrollView.minimumZoomScale = minZoom
    scrollView.zoomScale = minZoom
    scrollView.maximumZoomScale = minZoom*4
  
    /*Message Label*/
    lblMsg = UILabel.init(frame: CGRect(x: 10 , y: view.frame.maxY - 80  , width: holeRect.maxX - 20, height: 50))
    lblMsg.text =
    "UPLOAD IMAGE SIZE BETWEEN\n(MIN: \(self.minWidth) X \(self.minHeight), MAX: \(self.maxWidth) X \(self.maxHeight))"
    lblMsg.textColor = UIColor.white
    lblMsg.backgroundColor = UIColor.themeTransparentNavigationBackgroundColor
    lblCurrentImageSize.backgroundColor = UIColor.themeTransparentNavigationBackgroundColor
    
    lblMsg.lineBreakMode = .byWordWrapping
    lblMsg.numberOfLines = 0;
    lblMsg.sizeToFit()
    
    /*Label For Height and Width*/
   
    
    lblCurrentImageSize.textColor = UIColor.white
    lblCurrentImageSize.textAlignment = .center
    let cropedWithd = ((holeRect.width)/imageView.frame.width * originalImageSize.width).rounded()
    let cropedHeight = ((holeRect.height)/imageView.frame.height * originalImageSize.height).rounded()
    
    let cropedWithd1 = (cropedWithd * 0.2).rounded()
    let cropedHeight1 = (cropedHeight * 0.2).rounded()
    

   // lblCurrentImageSize.text = "\(cropedWithd * 0.2) X \(cropedHeight * 0.2)"
    lblCurrentImageSize.text = "\(cropedWithd1) X \(cropedHeight1)"

    /*Add All View to Main View*/
    view.addSubview(scrollView)
    view.addSubview(cropView!)
    view.addSubview(closeButton)
    view.addSubview(cropButton)
    view.addSubview(lblCurrentImageSize)
    view.addSubview(lblMsg)
  }
  
  // MARK: scrollView delegate
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView)
  {
    
    let cropedWithd = (holeRect.width/imageView.frame.width  * originalImageSize.width).rounded()
    let cropedHeight = (holeRect.height/imageView.frame.height  * originalImageSize.height).rounded()
    
    let cropedWithd1 = (cropedWithd * 0.2).rounded()
    let cropedHeight1 = (cropedHeight * 0.2).rounded()
 
    lblCurrentImageSize.text = "\(cropedWithd1) X \(cropedHeight1)"
//    lblCurrentImageSize.text = "\(cropedWithd * 0.2) X \(cropedHeight * 0.2)"
    
    
  }
  
  // MARK: actions
  
  @objc func tappedClose() {
    print("tapped close")
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func tappedCrop()
  {
    print("tapped crop")
    
    var imgX: CGFloat = 0
    if scrollView.contentOffset.x > 0 {
      imgX = scrollView.contentOffset.x / scrollView.zoomScale
    }
    
    let gapToTheHole = view.frame.height/2 - holeRect.height/2
    var imgY: CGFloat = 0
    if scrollView.contentOffset.y + gapToTheHole > 0 {
      imgY = (scrollView.contentOffset.y + gapToTheHole) / scrollView.zoomScale
    }
    
    let imgW = holeRect.width  / scrollView.zoomScale
    let imgH = holeRect.height  / scrollView.zoomScale
    
    let imgH1 = imgH * 0.2
    let imgW1 = imgW * 0.2
    
    
    
    let cropRect = CGRect(x: imgX, y: imgY, width: imgW1, height: imgH1)
    let imageRef = img.cgImage!.cropping(to: cropRect)
    let croppedImage = UIImage(cgImage: imageRef!)
    
    
    if checkImageSize(image: croppedImage, maxWidth:self.maxWidth , maxHeight: self.maxHeight, minWidth: self.minWidth, minHeight: self.minHeight) {
    self.dismiss(animated: true) {
        if self.onImageCropped != nil {
            self.onImageCropped!(croppedImage)
        }
        
    }
    }
    else {
        Utility.showToast(message: "Invalid Image sized")
    }
    
  }
  
  func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
    if error == nil {
      print("saved cropped image")
    } else {
      print("error saving cropped image")
    }
  }
    
    func checkImageSize(image:UIImage,maxWidth :Int, maxHeight:Int, minWidth:Int,
                                minHeight:Int) -> Bool
         {
        let imageHeight:Int = Int((image.size.height * image.scale).rounded())
        let imageWidth:Int = Int((image.size.width * image.scale).rounded())
        
        
        let imageRatio = imageWidth / imageHeight;
        let requiredRatio = maxWidth / maxHeight;
        
        return imageHeight <= maxHeight && imageHeight >=
            minHeight && imageWidth <= maxWidth && imageWidth >= minWidth
            && imageRatio == requiredRatio
        
    }
  
}


// MARK: hollow view class

class hollowView: UIView {
  var transparentRect: CGRect!
  
  init(frame: CGRect, transparentRect: CGRect) {
    super.init(frame: frame)
    
    self.transparentRect = transparentRect
    self.isUserInteractionEnabled = false
    self.alpha = 0.7
    self.isOpaque = false
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect)
  {
    backgroundColor?.setFill()
    UIRectFill(rect)
    
    let holeRectIntersection = transparentRect.intersection( rect )
    
    UIColor.clear.setFill();
    UIRectFill(holeRectIntersection);
    
  }
}


