import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
	
	func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return CircleTransitionAnimator()
	}
	
}
