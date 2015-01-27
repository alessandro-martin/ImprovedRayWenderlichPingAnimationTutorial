import UIKit

class CircleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	weak var transitionContext:UIViewControllerContextTransitioning?
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
		// Shorter animation duration to achieve an effect more similar to Ping's
		return 0.25
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		//1
		self.transitionContext = transitionContext
		//2
		var containerView = transitionContext.containerView()
		var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as ViewController
		var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as ViewController
		var button = fromViewController.button
		//3
		containerView.addSubview(toViewController.view)
		//4 
		var circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
		//4.1 Choosing the biggest bounds dimension to ensure consistency
		//when switching device orientation
		var largerDimension = max(CGRectGetHeight(toViewController.view.bounds),CGRectGetWidth(toViewController.view.bounds))
		var extremePoint = CGPoint(x: button.center.x, y: button.center.y - largerDimension)
		//4.2 hypot() is a more concise way to calculate a hypothenuse ;)
		var radius = hypot(extremePoint.x, extremePoint.y)
		var circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
		//5
		var maskLayer = CAShapeLayer()
		maskLayer.path = circleMaskPathFinal.CGPath
		toViewController.view.layer.mask = maskLayer
		//6
		var maskLayerAnimation = CABasicAnimation(keyPath: "path")
		maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
		maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
		maskLayerAnimation.duration = self.transitionDuration(transitionContext)
		maskLayerAnimation.delegate = self
		maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
		
		//
		//7 Extra animations to move and scale layers
		//
		var moveToLayerAnimation = CABasicAnimation(keyPath: "position")
		moveToLayerAnimation.fromValue = NSValue(CGPoint:fromViewController.button.center)
		moveToLayerAnimation.toValue = NSValue(CGPoint:containerView.center)
		moveToLayerAnimation.duration = self.transitionDuration(transitionContext)
		moveToLayerAnimation.delegate = self
		toViewController.view.layer.addAnimation(moveToLayerAnimation, forKey: "position")
		
		var moveFromLayerAnimation = CABasicAnimation(keyPath: "position")
		moveFromLayerAnimation.fromValue = NSValue(CGPoint:fromViewController.view.center)
		moveFromLayerAnimation.toValue = NSValue(CGPoint:CGPoint(x: -500, y: 1000))
		moveFromLayerAnimation.duration = self.transitionDuration(transitionContext)
		moveFromLayerAnimation.delegate = self
		fromViewController.view.layer.addAnimation(moveFromLayerAnimation, forKey: "position")
		
		var scaleToLayerAnimation = CABasicAnimation(keyPath:"transform.scale")
		scaleToLayerAnimation.fromValue = 0.0
		scaleToLayerAnimation.toValue = 1.0
		scaleToLayerAnimation.duration = self.transitionDuration(transitionContext)
		scaleToLayerAnimation.fillMode = kCAFillModeForwards
		scaleToLayerAnimation.delegate = self
		toViewController.view.layer.addAnimation(scaleToLayerAnimation, forKey: "transform.scale")
		
		var scaleFromLayerAnimation = CABasicAnimation(keyPath:"transform.scale")
		scaleFromLayerAnimation.fromValue = 1.0
		scaleFromLayerAnimation.toValue = 5.0
		scaleFromLayerAnimation.duration = self.transitionDuration(transitionContext)
		scaleFromLayerAnimation.fillMode = kCAFillModeForwards
		scaleFromLayerAnimation.delegate = self
		fromViewController.view.layer.addAnimation(scaleFromLayerAnimation, forKey: "transform.scale")
	}
	
	override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
		self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
		self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil;
	}
}
