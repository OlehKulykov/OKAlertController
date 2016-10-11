/*
*   Copyright (c) 2016 Oleh Kulykov <info@resident.name>
*
*   Permission is hereby granted, free of charge, to any person obtaining a copy
*   of this software and associated documentation files (the "Software"), to deal
*   in the Software without restriction, including without limitation the rights
*   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*   copies of the Software, and to permit persons to whom the Software is
*   furnished to do so, subject to the following conditions:
*
*   The above copyright notice and this permission notice shall be included in
*   all copies or substantial portions of the Software.
*
*   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*   THE SOFTWARE.
*/


import UIKit


internal class OKAlertControllerProxy: UIView, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning, UIViewControllerAnimatedTransitioning {

	//MARK: internal short types.
	typealias Element = OKAlertControllerElement
	typealias ElementType = OKAlertControllerElementType
	typealias Param = OKAlertControllerParam
	typealias ParamType = OKAlertControllerParamType

	// Original alert animated transitioning delegate.
	fileprivate var animatedTransitioning: UIViewControllerAnimatedTransitioning?

	// Original alert interactive transitioning delegate.
	fileprivate var interactiveTransitioning: UIViewControllerInteractiveTransitioning?

	// Original collection view with action buttons delegate.
	fileprivate weak var collectionDelegate: UICollectionViewDelegate?

	// Proxy gelegate that read, intersept and redirect original behavoir to UIAlertController.
	fileprivate var delegate: UIViewControllerTransitioningDelegate?

	// Root wraper weak reference.
	weak var parent: OKAlertController?

	// Detected alert content, e.g. shadow view.
	fileprivate weak var container: UIView?

	// Alert window view.
	fileprivate weak var context: UIView?

	// Last used uniq. tag. Use `nextTag` computed variable.
	fileprivate var lastTag = 0

	// Uniq tag. Increments and returns `lastTag` value.
	var nextTag: Int {
		lastTag = lastTag + 1
		return lastTag
	}

	// Cleanup strong and weak delegates.
	fileprivate func cleanup() {
		delegate = nil
		animatedTransitioning = nil
		interactiveTransitioning = nil
		collectionDelegate = nil
		container = nil
		context = nil
	}

	// Setup alert controller before presentation.
	func prepareAlert(_ alert: UIAlertController, presenter: UIViewController) {
		cleanup()
		delegate = alert.transitioningDelegate
		animatedTransitioning = delegate?.animationController?(forPresented: alert, presenting: presenter, source: presenter)
		if let animated = animatedTransitioning {
			interactiveTransitioning = delegate?.interactionControllerForPresentation?(using: animated)
		}
		alert.transitioningDelegate = self
		alert.modalPresentationStyle = .custom
	}

	// Process located alert label.
	fileprivate func processLabel(_ label: UILabel) {
		for element in elements {
			if element.processLabel(label) {
				switch element.type {
				case .message, .title:
					if let background: UIColor = self[.background, .color]?.getValue() {
						label.superview?.backgroundColor = background
					}
				default:
					continue
				}
			}
		}
	}

	// Process located collection view with action buttons.
	fileprivate func processCollectionView(_ collection: UICollectionView) {
		collection.backgroundColor = UIColor.clear
		if let background: UIColor = self[.background, .color]?.getValue() {
			for cell in collection.visibleCells {
				cell.contentView.backgroundColor = background
			}
		}
	}

	// Recursively process alert subviews.
	fileprivate func processSubviews(_ view: UIView) {
		for sub in view.subviews {
			processSubviews(sub)
		}

		if let label = view as? UILabel {
			processLabel(label)
		} else if let collection = view as? UICollectionView {
			processCollectionView(collection)
		}
	}

	// Apply settings to the alert content and window views.
	fileprivate func applySettings(_ container: UIView, context: UIView) {

		if let color: UIColor = self[.shadow, .color]?.getValue() {
			let parentBounds = container.bounds
			if let backView = container.subviews.findFirst({ $0.frame.equalTo(parentBounds) }) {
				backView.backgroundColor = color
			}
		}

		var needUpdateLayer = false

		if let color: UIColor = self[.background, .color]?.getValue() {
			needUpdateLayer = true
			context.backgroundColor = color
		}

		if let color: UIColor = self[.border, .color]?.getValue() {
			needUpdateLayer = true
			context.layer.borderColor = color.cgColor
		}

		if let number: NSNumber = self[.border, .width]?.getValue() {
			needUpdateLayer = true
			context.layer.borderWidth = CGFloat(number.floatValue)
		}

		if needUpdateLayer {
			context.clipsToBounds = true
			context.layer.cornerRadius = 14
		}

		processSubviews(context)
	}

	// Array of the customizible alert elements.
	var elements: [Element] = []

	// Locate and return element by it's type.
	subscript(type: ElementType) -> Element? {
		return elements.findFirst({ $0.type == type })
	}

	// Locate and return parameter by element and param types.
	subscript(elemType: ElementType, paramType: ParamType) -> Param? {
		if let element = elements.findFirst({ $0.type == elemType}) {
			return element[paramType]
		}
		return nil
	}

	// Update existed or add new element/param view new optional value.
	func updateTypeValue(_ elemType: ElementType, paramType: ParamType, value: AnyObject?) -> Element {
		var updatedElem = false
		var result: Element!
		let elems = elements.filter({ $0.type == elemType })
		for elem in elems {
			var updatedParam = false
			for param in elem.params.filter({ $0.type == paramType }) {
				param.value = value
				updatedParam = true
			}
			if !updatedParam {
				elem.params.append(Param(type: paramType, value: value))
				updatedElem = true
				result = elem
			}
		}

		if !updatedElem {
			result = Element(type: elemType, tag: nextTag, param: Param(type: paramType, value: value))
			elements.append(result)
		}
		return result
	}

	// Called when need to layout subviews e.g. update alert view.
	override func layoutSubviews() {
		super.layoutSubviews()
		if let container = container, let context = context {
			applySettings(container, context: context)
		}
	}

	deinit {
		cleanup()
	}
}

//MARK: UIViewControllerTransitioningDelegate
extension OKAlertControllerProxy {

	@objc(animationControllerForPresentedController:presentingController:sourceController:) func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		if let animated = delegate?.animationController?(forPresented: presented, presenting: presenting, source: source) {
			animatedTransitioning = animated
		}
		return self
	}

	@objc(animationControllerForDismissedController:) func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		if let animated = delegate?.animationController?(forDismissed: dismissed) {
			animatedTransitioning = animated
		}
		return self
	}

	@objc(interactionControllerForPresentation:) func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		guard let animated = animatedTransitioning else {
			return nil
		}
		interactiveTransitioning = delegate?.interactionControllerForPresentation?(using: animated)
		return interactiveTransitioning
	}

	@objc(interactionControllerForDismissal:) func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		guard let animator = animatedTransitioning else {
			return nil
		}
		interactiveTransitioning = delegate?.interactionControllerForDismissal?(using: animator)
		return interactiveTransitioning
	}

}

//MARK: UIViewControllerInteractiveTransitioning
extension OKAlertControllerProxy {
	func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
		if let interactiveTransitioning = interactiveTransitioning {
			interactiveTransitioning.startInteractiveTransition(transitionContext)
		}
	}

	var completionSpeed : CGFloat {
		guard let
			interactiveTransitioning = interactiveTransitioning,
			let method = interactiveTransitioning.completionSpeed
			else {
				return 0.24
		}
		return method
	}

	var completionCurve : UIViewAnimationCurve {
		guard let
			interactiveTransitioning = interactiveTransitioning,
			let method = interactiveTransitioning.completionCurve
			else {
				return .easeIn
		}
		return method
	}
}

//MARK: UIViewControllerAnimatedTransitioning
extension OKAlertControllerProxy {
	@objc(transitionDuration:) func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		guard let animatedTransitioning = animatedTransitioning else {
			return 0.24
		}
		return animatedTransitioning.transitionDuration(using: transitionContext)
	}

	fileprivate func animate(_ container: UIView?, context: UIView) {
		guard let container = container else {
			return
		}
		self.container = container
		self.context = context
		container.insertSubview(self, at: 0)
		container.autoresizesSubviews = true
		self.bounds = container.bounds
		self.backgroundColor = UIColor.clear
		self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.translatesAutoresizingMaskIntoConstraints = true
		applySettings(container, context: context)
	}
	
	@objc(animateTransition:) func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		if let context = transitionContext.view(forKey: UITransitionContextViewKey.to) {
			animate(transitionContext.containerView, context: context)
		}

		if #available(iOS 9.0, *) {

		} else {
			UIView.animate(withDuration: 0.1, animations: { [weak self] in
				self?.setNeedsLayout()
			}) 
		}

		guard let animatedTransitioning = animatedTransitioning else {
			return
		}
		animatedTransitioning.animateTransition(using: transitionContext)
	}

	func animationEnded(_ transitionCompleted: Bool) {
		guard let
			animatedTransitioning = animatedTransitioning,
			let method = animatedTransitioning.animationEnded
			else {
				return
		}
		method(transitionCompleted)
	}
}
