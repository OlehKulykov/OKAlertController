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


extension OKAlertController {

	func showOriginal() {
		guard let rootController = UIApplication.shared.delegate?.window??.rootViewController else {
			return
		}
		show(fromController: rootController, animated: true)
	}

	func showMinimalistic() {

		guard let rootController = UIApplication.shared.delegate?.window??.rootViewController else {
			return
		}

		self.shadowColor = UIColor(white: 1, alpha: 0.79)
		self.backgroundColor = UIColor.white

		self.titleFont = MyFont.LatoBold.fontWithSize(18)
		self.titleColor = MyColors.AlertTextColor

		self.messageFont = MyFont.LatoLight.fontWithSize(14.5)
		self.messageColor = MyColors.AlertTextColor

		self.borderWidth = 0.5
		self.borderColor = MyColors.AlertBorderColor

		self.allCancelActionsColor = MyColors.AlertDismissButtonTextColor
		self.allCancelActionsFont = MyFont.LatoBold.fontWithSize(18)

		self.allDestructiveActionsColor = MyColors.AlertDismissButtonTextColor
		self.allDestructiveActionsFont = MyFont.LatoRegular.fontWithSize(18)

		self.allDefaultActionsColor = MyColors.AlertNormalButtonTextColor
		self.allDefaultActionsFont = MyFont.LatoRegular.fontWithSize(18)

		show(fromController: rootController, animated: true)
	}

}
