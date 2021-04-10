//
//  UIImage+Ike.swift
//  Ike
//
//  Created by Randy Hill on 11/26/20.
//

import UIKit

extension UIImage {
    // Fill image with color
    static func from(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        var image: UIImage?
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext(){
            context.setFillColor(color.cgColor)
            context.fill(rect)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image
    }
    
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
	
	func scaleTo(_ newSize: CGSize) -> UIImage? {
		//UIGraphicsBeginImageContext(newSize);
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
		self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
		let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}
