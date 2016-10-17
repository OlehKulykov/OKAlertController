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


/**
Custom application provided fonts.
Each case is a string file name without extension of the font.

Example: create one of the provided custom fonts.

```swift
// Create 'Lato bold' font with size 16.5
let font = MyFont.<KEY>.fontWithSize(16.5)
```
*/
public enum MyFont: String {

	//MARK: Font cases

	/// _Lato bold_ font name.
	case LatoBold = "Lato-Bold"

	/// _Lato light_ font name.
	case LatoLight = "Lato-Light"

	/// _Lato regular_ font name.
	case LatoRegular = "Lato-Regular"


	//MARK: Font creation from case

	/**
	Create custom font with size for key.

	- Parameter size: Font size in pixels.

	- Returns: Create custom font with a provided size.
	*/
	func fontWithSize(_ size: CGFloat) -> UIFont {
		return UIFont(name: self.rawValue, size: size)!
	}
}
