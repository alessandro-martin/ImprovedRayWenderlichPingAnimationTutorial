import UIKit

class CircleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	weak var transitionContext:UIViewControllerContextTransitioning?
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
		// Shorter animation duration to achieve an effect more similar to Ping's
		return 0.40
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		//1
		self.transitionContext = transitionContext
		//2
		let containerView = transitionContext.containerView()
		let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as ViewController
		let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as ViewController
		let button = fromViewController.button
		//3
		containerView.addSubview(toViewController.view)
		//4 
		let circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
		//4.1 Choosing the biggest bounds dimension to ensure consistency
		let width = CGRectGetWidth(toViewController.view.bounds)
		let height = CGRectGetHeight(toViewController.view.bounds)
		let largerDimension = max(width, height)
		let smallerDimension = min(width, height)
		var xOffset:CGFloat = 0.0
		var yOffset:CGFloat = 0.0
		if width > height {
			xOffset = 0.0
			yOffset = width - height
		} else {
			yOffset = 0.0
			xOffset = height - width
		}

		let centerRect = CGRectOffset(button.frame, xOffset, -yOffset)
		//4.2 hypot() is a more concise way to calculate a hypothenuse ;)
		let radius = hypot(largerDimension, largerDimension)
		let circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(centerRect, -radius, -radius))
		//5
		let maskLayer = CAShapeLayer()
		maskLayer.path = circleMaskPathFinal.CGPath
		toViewController.view.layer.mask = maskLayer
		//6
		let maskLayerAnimation = CABasicAnimation(keyPath: "path")
		maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
		maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
		maskLayerAnimation.duration = self.transitionDuration(transitionContext)
		maskLayerAnimation.delegate = self
		maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
		
		//
		//7 Extra animations to move and scale layers
		//
		let toAnimationsTimeRatio = 0.50
		let fromAnimationsTimeRatio = 0.90
		let p = CGPointMake(button.center.x + 2 * (width - button.center.x),
			button.center.y - 2 * (button.center.y))
		
		let moveToLayerAnimation = CABasicAnimation(keyPath: "position")
		moveToLayerAnimation.fromValue = NSValue(CGPoint:p)
		moveToLayerAnimation.toValue = NSValue(CGPoint:containerView.center)
		moveToLayerAnimation.duration = self.transitionDuration(transitionContext) * toAnimationsTimeRatio
		toViewController.view.layer.addAnimation(moveToLayerAnimation, forKey: "position")
		
		let scaleToLayerAnimation = CABasicAnimation(keyPath:"transform.scale")
		scaleToLayerAnimation.fromValue = 0.0
		scaleToLayerAnimation.toValue = 1.0
		scaleToLayerAnimation.duration = self.transitionDuration(transitionContext) * toAnimationsTimeRatio
		scaleToLayerAnimation.fillMode = kCAFillModeForwards
		toViewController.view.layer.addAnimation(scaleToLayerAnimation, forKey: "transform.scale")
		
		let moveFromLayerAnimation = CABasicAnimation(keyPath: "position")
		moveFromLayerAnimation.fromValue = NSValue(CGPoint:fromViewController.view.center)
		moveFromLayerAnimation.toValue = NSValue(CGPoint:CGPoint(x: -500, y: 1000))
		moveFromLayerAnimation.duration = self.transitionDuration(transitionContext) * fromAnimationsTimeRatio
		fromViewController.view.layer.addAnimation(moveFromLayerAnimation, forKey: "position")
		
		let scaleFromLayerAnimation = CABasicAnimation(keyPath:"transform.scale")
		scaleFromLayerAnimation.fromValue = 1.0
		scaleFromLayerAnimation.toValue = 7.0
		scaleFromLayerAnimation.duration = self.transitionDuration(transitionContext) * fromAnimationsTimeRatio
		fromViewController.view.layer.addAnimation(scaleFromLayerAnimation, forKey: "transform.scale")
	}
	
	override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
		self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
		self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
	}
}
