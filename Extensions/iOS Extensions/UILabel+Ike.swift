//
//  UILabel.swift
//  Ike
//
//  Created by Randy Hill on 11/26/20.
//

import UIKit

extension UILabel {
	
	func sizeFor(lines: Int) -> CGSize {
		let rect = self.textRect(forBounds: self.bounds, limitedToNumberOfLines: lines)
		return rect.size
	}
}
