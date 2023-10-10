

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
  
  var interactionInProgress = false
  
  fileprivate var shouldCompleteTransition = false
  fileprivate weak var viewController: UIViewController!
  
  func wireToViewController(_ viewController: UIViewController!)
  {
    self.viewController = viewController
    prepareGestureRecognizerInView(viewController.view.subviews[0])
  }
  
  fileprivate func prepareGestureRecognizerInView(_ view: UIView)
  {
    let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
    gesture.edges = UIRectEdge.left
    view.addGestureRecognizer(gesture)
  }
  
  @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer)
  {
    let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
    let verticalMovement = translation.y / (gestureRecognizer.view?.bounds.height)!
    let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
    let downwardMovementPercent = fminf(downwardMovement, 1.0)
    let progress = CGFloat(downwardMovementPercent)
    print(progress)
    switch gestureRecognizer.state {
    case .began:
        interactionInProgress = true
        viewController.dismiss(animated: true, completion: nil)
    case .changed:
      shouldCompleteTransition = progress > 0.5
      update(progress)
    case .cancelled:
      interactionInProgress = false
      cancel()
    case .ended:
      interactionInProgress = false
      if !shouldCompleteTransition
      {
        cancel()
      }
      else
      {
        finish()
      }
      
    default:
      print("Unsupported")
    }

}
}
