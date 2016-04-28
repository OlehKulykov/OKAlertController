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

	typealias Element = OKAlertControllerElement
	typealias ElementType = OKAlertControllerElementType
	typealias Param = OKAlertControllerParam
	typealias ParamType = OKAlertControllerParamType

	var modalPresentationStyle = UIModalPresentationStyle.Custom
	weak var animatedTransitioning: UIViewControllerAnimatedTransitioning?
	weak var interactiveTransitioning: UIViewControllerInteractiveTransitioning?
	weak var collectionDelegate: UICollectionViewDelegate?
	weak var delegate: UIViewControllerTransitioningDelegate? {
		didSet {
			animatedTransitioning = nil
			interactiveTransitioning = nil
			container = nil
			context = nil
		}
	}
	weak var parent: OKAlertController?
	weak var container: UIView?
	weak var context: UIView?

	var lastTag = 0
	var nextTag: Int {
		lastTag = lastTag + 1
		return lastTag
	}

	func checkLabel(label: UILabel) {
		for element in elements {
			if element.checkLabel(label) {
				switch element.type {
				case .Message, .Title:
					if let background: UIColor = self[.Background, .Color]?.getValue() {
						label.superview?.backgroundColor = background
					}
				default:
					continue
				}
			}
		}
	}

	func checkCollectionView(collection: UICollectionView) {
		collection.backgroundColor = UIColor.clearColor()
		if let background: UIColor = self[.Background, .Color]?.getValue() {
			for cell in collection.visibleCells() {
				cell.contentView.backgroundColor = background
			}
		}
	}

	func processSubviews(view: UIView) {
		for sub in view.subviews {
			processSubviews(sub)
		}

		if let label = view as? UILabel {
			checkLabel(label)
		} else if let collection = view as? UICollectionView {
			checkCollectionView(collection)
		}
	}

	func setup(container: UIView, context: UIView) {

		if let color: UIColor = self[.Shadow, .Color]?.getValue() {
			let parentBounds = container.bounds
			for sub in container.subviews {
				if CGRectEqualToRect(parentBounds, sub.frame) {
					sub.backgroundColor = color
					break
				}
			}
		}

		if let color: UIColor = self[.Background, .Color]?.getValue() {
			context.backgroundColor = color
			context.clipsToBounds = true
			context.layer.cornerRadius = 14
		}

		if let color: UIColor = self[.Border, .Color]?.getValue() {
			context.clipsToBounds = true
			context.layer.cornerRadius = 14
			context.layer.borderColor = color.CGColor
		}

		if let number: NSNumber = self[.Border, .Width]?.getValue() {
			context.clipsToBounds = true
			context.layer.cornerRadius = 14
			context.layer.borderWidth = CGFloat(number.floatValue)
		}

		processSubviews(context)
	}

	var elements: [Element] = []

	subscript(type: ElementType) -> Element? {
		return elements.filter({ $0.type == type }).first
	}

	subscript(elemType: ElementType, paramType: ParamType) -> Param? {
		guard let element = elements.filter({ $0.type == elemType}).first else {
			return nil
		}
		return element[paramType]
	}

	func updateTypeValue(elemType: ElementType, paramType: ParamType, value: AnyObject?) -> Element {
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

	override func layoutSubviews() {
		super.layoutSubviews()
		if let container = container, context = context {
			setup(container, context: context)
		}
	}

}

// UIViewControllerTransitioningDelegate
extension OKAlertControllerProxy {

	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		if let delegate = delegate, method = delegate.animationControllerForPresentedController {
			animatedTransitioning = method(presented, presentingController: presenting, sourceController: source)
		}
		return self
	}

	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		if let delegate = delegate, method = delegate.animationControllerForDismissedController {
			animatedTransitioning = method(dismissed)
		}
		return self
	}

	func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		guard let
			delegate = delegate,
			animatedTransitioning = animatedTransitioning,
			method = delegate.interactionControllerForPresentation
			else {
				return nil
		}
		interactiveTransitioning = method(animatedTransitioning)
		return interactiveTransitioning
	}

	func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		guard let
			delegate = delegate,
			originalAnimator = animatedTransitioning,
			method = delegate.interactionControllerForDismissal
			else {
				return nil
		}
		interactiveTransitioning = method(originalAnimator)
		return interactiveTransitioning
	}

}

// UIViewControllerInteractiveTransitioning
extension OKAlertControllerProxy {
	func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
		if let interactiveTransitioning = interactiveTransitioning {
			interactiveTransitioning.startInteractiveTransition(transitionContext)
		}
	}

	func completionSpeed() -> CGFloat {
		guard let
			interactiveTransitioning = interactiveTransitioning,
			method = interactiveTransitioning.completionSpeed
			else {
				return 0.24
		}
		return method()
	}

	func completionCurve() -> UIViewAnimationCurve {
		guard let
			interactiveTransitioning = interactiveTransitioning,
			method = interactiveTransitioning.completionCurve
			else {
				return .EaseIn
		}
		return method()
	}
}

// UIViewControllerAnimatedTransitioning
extension OKAlertControllerProxy {
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		guard let animatedTransitioning = animatedTransitioning else {
			return 0.24
		}
		return animatedTransitioning.transitionDuration(transitionContext)
	}

	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		if let
			container = transitionContext.containerView(),
			context = transitionContext.viewForKey(UITransitionContextToViewKey)
		{
			self.container = container
			self.context = context
			container.insertSubview(self, atIndex: 0)
			container.autoresizesSubviews = true
			self.bounds = container.bounds
			self.backgroundColor = UIColor.clearColor()
			self.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
			self.translatesAutoresizingMaskIntoConstraints = true
			setup(container, context: context)
		}

		guard let animatedTransitioning = animatedTransitioning else {
			return
		}
		animatedTransitioning.animateTransition(transitionContext)

		if #available(iOS 9.0, *) {

		} else {
			UIView.animateWithDuration(0.1) { [weak self] in
				self?.setNeedsLayout()
			}
		}
	}

	func animationEnded(transitionCompleted: Bool) {
		guard let
			animatedTransitioning = animatedTransitioning,
			method = animatedTransitioning.animationEnded
			else {
				return
		}
		method(transitionCompleted)
	}
}
