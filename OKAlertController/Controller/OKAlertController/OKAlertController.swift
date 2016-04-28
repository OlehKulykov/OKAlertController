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


// Public controller interface.


/**
Wraps and manages standart `UIAlertController` look.
First ctreate controller, fill with actions and only than make customiztion before show.
It's recommended to create extension for you application, override show function and
before show make you application specific customization.
*/
public class OKAlertController {

	private var alert: UIAlertController!
	private var proxy = OKAlertControllerProxy()

	private func proxyToAlert() {
		alert.modalPresentationStyle = proxy.modalPresentationStyle
		alert.transitioningDelegate = proxy.delegate
	}

	/**
	Get/set alert title text color. 
	The default value is nil - standart title text color.
	Provide nil to remove/ignore title text color modification and use standart.
	*/
	public var titleColor: UIColor? {
		get {
			return proxy[.Title, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Title, paramType: .Color, value: newValue)
		}
	}


	/**
	Get/set alert title font.
	The default value is nil - standart title font.
	Provide nil to remove/ignore title font modification and use standart.
	*/
	public var titleFont: UIFont? {
		get {
			return proxy[.Title, .Font]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Title, paramType: .Font, value: newValue)
		}
	}

	public var messageColor: UIColor? {
		get {
			return proxy[.Message, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Message, paramType: .Color, value: newValue)
		}
	}

	public var messageFont: UIFont? {
		get {
			return proxy[.Message, .Font]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Message, paramType: .Font, value: newValue)
		}
	}

	public var backgroundColor: UIColor? {
		get {
			return proxy[.Background, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Background, paramType: .Color, value: newValue)
		}
	}

	public var allDefaultActionsFont: UIFont? {
		get {
			return proxy[.AllDefaultActions, .Font]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllDefaultActions, paramType: .Font, value: newValue)
		}
	}

	public var allDefaultActionsColor: UIColor? {
		get {
			return proxy[.AllDefaultActions, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllDefaultActions, paramType: .Color, value: newValue)
		}
	}

	public var allCancelActionsFont: UIFont? {
		get {
			return proxy[.AllCancelActions, .Font]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllCancelActions, paramType: .Font, value: newValue)
		}
	}

	public var allCancelActionsColor: UIColor? {
		get {
			return proxy[.AllCancelActions, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllCancelActions, paramType: .Color, value: newValue)
		}
	}

	public var allDestructiveActionsFont: UIFont? {
		get {
			return proxy[.AllDestructiveActions, .Font]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllDestructiveActions, paramType: .Font, value: newValue)
		}
	}

	public var allDestructiveActionsColor: UIColor? {
		get {
			return proxy[.AllDestructiveActions, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllDestructiveActions, paramType: .Color, value: newValue)
		}
	}

	public var shadowColor: UIColor? {
		get {
			return proxy[.Shadow, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Shadow, paramType: .Color, value: newValue)
		}
	}

	public var borderColor: UIColor? {
		get {
			return proxy[.Border, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Border, paramType: .Color, value: newValue)
		}
	}

	public var borderWidth: CGFloat? {
		get {
			if let number: NSNumber = proxy[.Border, .Width]?.getValue() {
				return CGFloat(number.floatValue)
			}
			return 0
		}
		set {
			proxy.updateTypeValue(.Border, paramType: .Width, value: newValue != nil ? NSNumber(float: Float(newValue!)) : nil)
		}
	}

	public func show(fromController from: UIViewController, animated: Bool) {
		proxy.delegate = alert.transitioningDelegate
		proxy.modalPresentationStyle = alert.modalPresentationStyle
		alert.modalPresentationStyle = .Custom
		alert.transitioningDelegate = proxy
		from.presentViewController(alert, animated: animated) {
			self.proxyToAlert() // hold strongly
		}
	}

	public func addAction(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) {
		let type: OKAlertControllerProxy.ElementType
		switch style {
		case .Default:
			type = .AllDefaultActions
		case .Cancel:
			type = .AllCancelActions
		case .Destructive:
			type = .AllDestructiveActions
		}

		let element = OKAlertControllerProxy.Element(type: type, tag: proxy.nextTag, param: OKAlertControllerProxy.Param(type: .Text, value: title))
		proxy.elements.append(element)
		alert.addAction(UIAlertAction(title: element.key, style: style, handler: nil))
	}


	/**
	Initialize controller with style and optional title and message.
	
	- Parameters:
		- title: Title of the alert controller.
	
		- message: Descriptive text that provides more details about the reason for the alert.
	
		- preferredStyle: The style of the alert controller. Default value is `.Alert`. For more information look at `UIAlertControllerStyle`.
	
	- Returns: Initialized alert controller.
	*/
	public init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle = .Alert) {
		let titleElement = proxy.updateTypeValue(.Title, paramType: .Text, value: title)
		let messageElement = proxy.updateTypeValue(.Message, paramType: .Text, value: message)
		alert = UIAlertController(title: titleElement.key, message: messageElement.key, preferredStyle: preferredStyle)
	}
	
}

