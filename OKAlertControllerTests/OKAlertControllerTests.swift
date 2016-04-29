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


import XCTest
@testable import OKAlertController

class OKAlertControllerTests: XCTestCase {

	let testFont = MyFont.LatoBold.fontWithSize(18)
	let testColor = UIColor.whiteColor()

	func testRegularAccessors() {
		let alert = OKAlertController(title: "title", message: "message")
		alert.addAction("Ut enim ad minim veniam", style: .Default, handler: nil)
		alert.addAction("Duis aute irure dolor", style: .Default, handler: nil)
		alert.addAction("Cancel", style: .Cancel, handler: nil)

		XCTAssertTrue(Int(alert.borderWidth) == 0, "Broken 'borderWidth' default value.")
		alert.borderWidth = 3
		XCTAssertTrue(Int(alert.borderWidth) == 3, "Broken 'borderWidth' value.")

		alert.borderWidth = -3
		XCTAssertFalse(Int(alert.borderWidth) == -3, "'borderWidth' can't be negative, get default value.")
		XCTAssertTrue(Int(alert.borderWidth) == 0, "'borderWidth' can't be negative, get default value.")
	}

	func testFontAccessors() {
		let alert = OKAlertController(title: "title", message: "message")
		alert.addAction("Ut enim ad minim veniam", style: .Default, handler: nil)
		alert.addAction("Duis aute irure dolor", style: .Default, handler: nil)
		alert.addAction("Cancel", style: .Cancel, handler: nil)

		XCTAssertNil(alert.titleFont, "Broken 'titleFont' default value.")
		alert.titleFont = testFont
		XCTAssertNotNil(alert.titleFont, "Can't store 'titleFont' value.")
		XCTAssert(alert.titleFont! == testFont, "Broken 'titleFont' value.")

		XCTAssertNil(alert.messageFont, "Broken 'messageFont' default value.")
		alert.messageFont = testFont
		XCTAssertNotNil(alert.messageFont, "Can't store 'messageFont' value.")
		XCTAssert(alert.messageFont! == testFont, "Broken 'messageFont' value.")

		XCTAssertNil(alert.allCancelActionsFont, "Broken 'allCancelActionsFont' default value.")
		alert.allCancelActionsFont = testFont
		XCTAssertNotNil(alert.allCancelActionsFont, "Can't store 'allCancelActionsFont' value.")
		XCTAssert(alert.allCancelActionsFont! == testFont, "Broken 'allCancelActionsFont' value.")

		XCTAssertNil(alert.allDestructiveActionsFont, "Broken 'allDestructiveActionsFont' default value.")
		alert.allDestructiveActionsFont = testFont
		XCTAssertNotNil(alert.allDestructiveActionsFont, "Can't store 'allDestructiveActionsFont' value.")
		XCTAssert(alert.allDestructiveActionsFont! == testFont, "Broken 'allDestructiveActionsFont' value.")

		XCTAssertNil(alert.allDefaultActionsFont, "Broken 'allDefaultActionsFont' default value.")
		alert.allDefaultActionsFont = testFont
		XCTAssertNotNil(alert.allDefaultActionsFont, "Can't store 'allDefaultActionsFont' value.")
		XCTAssert(alert.allDefaultActionsFont! == testFont, "Broken 'allDefaultActionsFont' value.")
	}

	func testColorAccessors() {
		let alert = OKAlertController(title: "title", message: "message")
		alert.addAction("Ut enim ad minim veniam", style: .Default, handler: nil)
		alert.addAction("Duis aute irure dolor", style: .Default, handler: nil)
		alert.addAction("Cancel", style: .Cancel, handler: nil)
		alert.addAction("Destructive", style: .Destructive, handler: nil)

		XCTAssertNil(alert.backgroundColor, "Broken 'backgroundColor' default value.")
		alert.backgroundColor = testColor
		XCTAssertNotNil(alert.backgroundColor, "Can't store 'backgroundColor' value.")
		XCTAssert(alert.backgroundColor! == testColor, "Broken 'backgroundColor' value.")

		XCTAssertNil(alert.titleColor, "Broken 'titleColor' default value.")
		alert.titleColor = testColor
		XCTAssertNotNil(alert.titleColor, "Can't store 'titleColor' value.")
		XCTAssert(alert.titleColor! == testColor, "Broken 'titleColor' value.")

		XCTAssertNil(alert.messageColor, "Broken 'messageColor' default value.")
		alert.messageColor = testColor
		XCTAssertNotNil(alert.messageColor, "Can't store 'messageColor' value.")
		XCTAssert(alert.messageColor! == testColor, "Broken 'messageColor' value.")

		XCTAssertNil(alert.borderColor, "Broken 'borderColor' default value.")
		alert.borderColor = testColor
		XCTAssertNotNil(alert.borderColor, "Can't store 'borderColor' value.")
		XCTAssert(alert.borderColor! == testColor, "Broken 'borderColor' value.")

		XCTAssertNil(alert.allCancelActionsColor, "Broken 'allCancelActionsColor' default value.")
		alert.allCancelActionsColor = testColor
		XCTAssertNotNil(alert.allCancelActionsColor, "Can't store 'allCancelActionsColor' value.")
		XCTAssert(alert.allCancelActionsColor! == testColor, "Broken 'allCancelActionsColor' value.")

		XCTAssertNil(alert.allDestructiveActionsColor, "Broken 'allDestructiveActionsColor' default value.")
		alert.allDestructiveActionsColor = testColor
		XCTAssertNotNil(alert.allDestructiveActionsColor, "Can't store 'allDestructiveActionsColor' value.")
		XCTAssert(alert.allDestructiveActionsColor! == testColor, "Broken 'allDestructiveActionsColor' value.")

		XCTAssertNil(alert.allDefaultActionsColor, "Broken 'allDefaultActionsColor' default value.")
		alert.allDefaultActionsColor = testColor
		XCTAssertNotNil(alert.allDefaultActionsColor, "Can't store 'allDefaultActionsColor' value.")
		XCTAssert(alert.allDefaultActionsColor! == testColor, "Broken 'allDefaultActionsColor' value.")

		XCTAssertNil(alert.shadowColor, "Broken 'shadowColor' default value.")
		alert.shadowColor = testColor
		XCTAssertNotNil(alert.shadowColor, "Can't store 'shadowColor' value.")
		XCTAssert(alert.shadowColor! == testColor, "Broken 'shadowColor' value.")

//
//		alert.titleFont = UIFont(name: "Lato-Bold", size: 18)
//		alert.titleColor = UIColor(hexString: "#4A4D55")
//
//		alert.messageFont = UIFont(name: "Lato-Light", size: 14.5)
//		alert.messageColor = UIColor(hexString: "#4A4D55")
//
//		alert.borderWidth = 0.5
//		alert.borderColor = UIColor(hexString: "#979797")
//
//		alert.allCancelActionsColor = UIColor(hexString: "#D3D3D3")
//		alert.allCancelActionsFont = UIFont(name: "Lato-Bold", size: 18)
//
//		alert.allDestructiveActionsColor = UIColor(hexString: "#D3D3D3")
//		alert.allDestructiveActionsFont = UIFont(name: "Lato-Regular", size: 18)
//
//		alert.allDefaultActionsColor = UIColor(hexString: "#6D9EE1") 
//		alert.allDefaultActionsFont = UIFont(name: "Lato-Regular", size: 18)
//
//		alert.shadowColor = UIColor(white: 1, alpha: 0.79)
//		alert.backgroundColor = UIColor.whiteColor()
	}

}
