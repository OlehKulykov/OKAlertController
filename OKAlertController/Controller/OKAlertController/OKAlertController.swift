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

- Note: All variables have default value as `nil`, which means this parameter will not be applied/changed.

Example:

```swift
// Create alert.
let alert = OKAlertController(title: "Some title", message: "Alert message")

// Add actions
alert.addAction("Ut enim ad minim veniam", style: .Default) { _ in

}

alert.addAction("Cancel", style: .Cancel) { _ in

}

//TODO: setup controller with custom colors, fonts, etc.
alert.shadowColor = UIColor(white: 1, alpha: 0.79)
alert.backgroundColor = UIColor.whiteColor()

// Finaly show controller
alert.show(fromController: self, animated: true)
```
*/
public class OKAlertController {

	/// Actual `UIAlertController` for setup and show.
	private var alert: UIAlertController!

	/// Main setup logic.
	private var proxy = OKAlertControllerProxy()

	/**
	Get/set alert title text color. 
	The default value is `nil` - standart title text color.
	Provide `nil` to remove/ignore title text color modification and use standart.
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
	The default value is `nil` - standart title font.
	Provide `nil` to remove/ignore title font modification and use standart.
	*/
	public var titleFont: UIFont? {
		get {
			return proxy[.Title, .Font]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Title, paramType: .Font, value: newValue)
		}
	}


	/**
	Get/set alert message text color.
	The default value is `nil` - standart message text color.
	Provide `nil` to remove/ignore message text color modification and use standart.
	*/
	public var messageColor: UIColor? {
		get {
			return proxy[.Message, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Message, paramType: .Color, value: newValue)
		}
	}


	/**
	Get/set alert message font.
	The default value is `nil` - standart message font.
	Provide `nil` to remove/ignore message font modification and use standart.
	*/
	public var messageFont: UIFont? {
		get {
			return proxy[.Message, .Font]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Message, paramType: .Font, value: newValue)
		}
	}


	/**
	Get/set alert background window color.
	The default value is `nil` - standart background window color.
	Provide `nil` to remove/ignore background window color modification and use standart.
	*/
	public var backgroundColor: UIColor? {
		get {
			return proxy[.Background, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Background, paramType: .Color, value: newValue)
		}
	}


	/**
	Get/set alert default actions text font.
	The default value is `nil` - standart default actions text font.
	Provide `nil` to remove/ignore default actions text font modification and use standart.
	*/
	public var allDefaultActionsFont: UIFont? {
		get {
			return proxy[.AllDefaultActions, .Font]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllDefaultActions, paramType: .Font, value: newValue)
		}
	}


	/**
	Get/set alert default actions text color.
	The default value is `nil` - standart default actions text color.
	Provide `nil` to remove/ignore default actions text color modification and use standart.
	*/
	public var allDefaultActionsColor: UIColor? {
		get {
			return proxy[.AllDefaultActions, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllDefaultActions, paramType: .Color, value: newValue)
		}
	}


	/**
	Get/set alert cancel actions text font.
	The default value is `nil` - standart cancel actions text font.
	Provide `nil` to remove/ignore cancel actions text font modification and use standart.
	*/
	public var allCancelActionsFont: UIFont? {
		get {
			return proxy[.AllCancelActions, .Font]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllCancelActions, paramType: .Font, value: newValue)
		}
	}


	/**
	Get/set alert cancel actions text color.
	The default value is `nil` - standart cancel actions text color.
	Provide `nil` to remove/ignore cancel actions color color modification and use standart.
	*/
	public var allCancelActionsColor: UIColor? {
		get {
			return proxy[.AllCancelActions, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllCancelActions, paramType: .Color, value: newValue)
		}
	}


	/**
	Get/set alert destructive actions text font.
	The default value is `nil` - standart destructive actions text font.
	Provide `nil` to remove/ignore destructive actions text font modification and use standart.
	*/
	public var allDestructiveActionsFont: UIFont? {
		get {
			return proxy[.AllDestructiveActions, .Font]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllDestructiveActions, paramType: .Font, value: newValue)
		}
	}


	/**
	Get/set alert destructive actions text color.
	The default value is `nil` - standart destructive actions text color.
	Provide `nil` to remove/ignore destructive actions text color modification and use standart.
	*/
	public var allDestructiveActionsColor: UIColor? {
		get {
			return proxy[.AllDestructiveActions, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.AllDestructiveActions, paramType: .Color, value: newValue)
		}
	}


	/**
	Get/set alert shadow color.
	The default value is `nil` - standart shadow color.
	Provide `nil` to remove/ignore destructive shadow color modification and use standart.
	*/
	public var shadowColor: UIColor? {
		get {
			return proxy[.Shadow, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Shadow, paramType: .Color, value: newValue)
		}
	}


	/**
	Get/set alert window border color.
	The default value is `nil` - standart window border color.
	Provide `nil` to remove/ignore destructive window border color modification and use standart.
	*/
	public var borderColor: UIColor? {
		get {
			return proxy[.Border, .Color]?.getValue()
		}
		set {
			proxy.updateTypeValue(.Border, paramType: .Color, value: newValue)
		}
	}


	/**
	Get/set alert window border line width.
	The default and minimum value is 0.
	*/
	public var borderWidth: CGFloat {
		get {
			if let number: NSNumber = proxy[.Border, .Width]?.getValue() {
				return CGFloat(number.floatValue)
			}
			return 0
		}
		set {
			let newWidth = max(0, newValue)
			proxy.updateTypeValue(.Border, paramType: .Width, value: NSNumber(float: Float(newWidth)))
		}
	}


	/**
	Show/present alert controller.

	- Warning: Before calling this function need to set all required parameters, e.g. setup controller.

	- Parameters:
		- fromController: Presenter view controller for the alert.

		- animated: Animating flag for presenting.
	*/
	public func show(fromController from: UIViewController, animated: Bool) {
		proxy.prepareAlert(alert, presenter: from)
		from.presentViewController(alert, animated: animated) {
			_ = self // hold strongly `self`
		}
	}


	/**
	Add alert action.
	
	- Parameters:
		- title: The title string of the action.
	
		- style: Action style. Look at `UIAlertActionStyle`.
	
		- handler: Handler to insform outside logic that the action was trigered.
	*/
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
		alert.addAction(UIAlertAction(title: element.key, style: style, handler: handler))
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

