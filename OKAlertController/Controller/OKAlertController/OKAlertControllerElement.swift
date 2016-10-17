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


// Customizable alert parts with color, font, width etc.
internal enum OKAlertControllerElementType: Int {
	case title
	case message
	case background
	case allDefaultActions
	case allCancelActions
	case allDestructiveActions
	case shadow
	case border
}

extension Sequence {
	// Iterate to first occurrence of the element conformed to condition.
	
	internal func findFirst(_ condition: (Self.Iterator.Element) -> Bool) -> Self.Iterator.Element? {
		for element in self {
			if condition(element) {
				return element
			}
		}
		return nil
	}
}

internal class OKAlertControllerElement {

	// Short type names for the internal implementation.
	typealias ElementType = OKAlertControllerElementType
	typealias Param = OKAlertControllerParam
	typealias ParamType = OKAlertControllerParamType

	// Element type.
	let type: ElementType

	// Element uniq tag.
	let tag: Int

	// Parameters for this element.
	var params: [Param]

	// Generate uniq key string for the element, based on tag.
	var key: String {
		return "\(tag)"
	}

	// Check alert label conforms this element & setup.
	func processLabel(_ label: UILabel) -> Bool {
		if let text = label.text {
			let dstText: String = self[.text]?.getValue() ?? ""
			if label.tag == tag || text == key || text == dstText {
				label.tag = tag
				label.attributedText = attributedString // assigning a new a value updates the values in the font, textColor
				if #available(iOS 10.0, *) {
					if let parent = label.superview?.superview {
						parent.setNeedsLayout()
						parent.setNeedsDisplay()
					}
				}
				return true
			}
		}
		return false
	}

	// Generate attributed string from element parameters.
	// Used `.Text`, `.Color` and '.Font` params.
	fileprivate var attributedString: NSAttributedString {
		var text: String?
		var attributes = [String : AnyObject](minimumCapacity: 2)
		for param in params {
			switch param.type {
			case .text:
				text = param.getValue()
			case .color:
				if let color: UIColor = param.getValue() {
					attributes[NSForegroundColorAttributeName] = color
				}
			case .font:
				if let font: UIFont = param.getValue() {
					attributes[NSFontAttributeName] = font
				}
			default:
				continue
			}
		}
		return NSAttributedString(string: text ?? "", attributes: attributes)
	}

	// Locates and returns element parameter by parameter type.
	subscript(type: ParamType) -> Param? {
		return params.findFirst({ $0.type == type })
	}

	// Initialize element with element type and uniq tag.
	init(type: ElementType, tag: Int) {
		self.type = type
		self.tag = tag
		self.params = []
	}

	// Initialize element with element type, uniq tag and single parameter.
	init(type: ElementType, tag: Int, param: Param) {
		self.type = type
		self.tag = tag
		self.params = [param]
	}
}
