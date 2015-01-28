import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var button: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// Pop-like effect for the button.
		self.button.layer.transform = CATransform3DMakeScale(0.0, 0.0, 1)
		self.button.hidden = false
		UIView.animateWithDuration(0.5, delay: 0.7, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: { () -> Void in
			self.button.layer.transform = CATransform3DMakeScale(1, 1, 1)
			}, completion: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func circleTapped(sender:UIButton) {
		sender.hidden = true
		self.navigationController?.popViewControllerAnimated(true)
	}

	override func prefersStatusBarHidden() -> Bool {
		return true
	}
}

